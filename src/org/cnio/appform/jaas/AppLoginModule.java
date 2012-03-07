package org.cnio.appform.jaas;

import java.io.PrintStream;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Vector;

import javax.security.auth.Subject;
import javax.security.auth.callback.Callback;
import javax.security.auth.callback.CallbackHandler;
import javax.security.auth.callback.NameCallback;
import javax.security.auth.callback.PasswordCallback;
import javax.security.auth.login.LoginException;
import javax.security.auth.spi.LoginModule;

import org.cnio.appform.entity.AppUser;
import org.cnio.appform.entity.Role;
import org.cnio.appform.util.AppUserCtrl;
import org.cnio.appform.util.HibernateUtil;
import org.cnio.appform.util.LogFile;
import org.cnio.appform.util.Singleton;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;



/**
 * <p>
 * AppLoginModule is a LoginModule that authenticates
 * a given username/password credential against a JDBC
 * datasource.
 *
 * <p> This <code>LoginModule</code> interoperates with
 * any conformant JDBC datasource.  To direct this
 * <code>LoginModule</code> to use a specific JNDI datasource,
 * two options must be specified in the login <code>Configuration</code>
 * for this <code>LoginModule</code>.
 * <pre>
 *    url=<b>jdbc_url</b>
 *    driverb>jdbc driver class</b>
 * </pre>
 *
 * <p> For the purposed of this example, the format in which
 * the user's information must be stored in the database is
 * in a table named "USER_AUTH" with the following columns
 * <pre>
 *     USERID
 *     PASSWORD
 *     FIRST_NAME
 *     LAST_NAME
 *     DELETE_PERM
 *     UPDATE_PERM
 * </pre>
 *
 * @see     javax.security.auth.spi.LoginModule
 * @author  Paul Feuer and John Musser
 * @version 1.0
 */

public class AppLoginModule implements LoginModule {

	// initial state
	private CallbackHandler callbackHandler;
	private Subject subject;
	private Map sharedState;
	private Map options;

	// temporary state
	private Vector tempCredentials;
	private Vector tempPrincipals;

	// the authentication status
	private boolean success;

	// configurable options
	private boolean debug;
	private String url;
	private String driverClass;
	
	private String username;
	private String passwd;
	private int userId;
	
	private final int ALREADY_LOGGED = 1;
	private final int MISMATCHING_PASSWD = 2;
	private final int USER_NO_EXIST = 3;
	
	private int errCause;
	

	/**
	 * <p>Creates a login module that can authenticate against
	 * a JDBC datasource.
	 */
	public AppLoginModule() {
		tempCredentials = new Vector();
		tempPrincipals = new Vector();
		success = false;
		debug = false;
		userId = -1;
		
		errCause = 0;
	}

/*	
	public AppLoginModule (String username, String passwd) {
		this ();

		this.username = username;
		this.passwd = passwd;
	}
*/	
	
	
/**
 * Initialize this <code>LoginModule</code>.
 * <p>
 *
 * @param subject the <code>Subject</code> to be authenticated. <p>
 *
 * @param callbackHandler a <code>CallbackHandler</code> for communicating
 *			with the end user (prompting for usernames and
 *			passwords, for example). <p>
 *
 * @param sharedState shared <code>LoginModule</code> state. <p>
 *
 * @param options options specified in the login
 *			<code>Configuration</code> for this particular
 *			<code>LoginModule</code>.
 */
	public void initialize (Subject subject, CallbackHandler callbackHandler,
			Map sharedState, Map options) {

		// save the initial state
		this.callbackHandler = callbackHandler;
		this.subject = subject;
		this.sharedState = sharedState;
		this.options = options;

		// initialize any configured options
		if (options.containsKey("debug"))
			debug = "true".equalsIgnoreCase((String) options.get("debug"));

//		url = (String) options.get("url");
//		driverClass = (String) options.get("driver");

		if (debug) {
			System.out.println("\t\t[AppLoginModule] initialize");
			System.out.println("\t\t[AppLoginModule] url: " + url);
			System.out.println("\t\t[AppLoginModule] driver: " + driverClass);
		}
	}
	
	

/**
 * <p> Verify the password against the relevant JDBC datasource.
 *
 * @return true always, since this <code>LoginModule</code>
 *      should not be ignored.
 *
 * @exception FailedLoginException if the authentication fails. <p>
 *
 * @exception LoginException if this <code>LoginModule</code>
 *      is unable to perform the authentication.
 */
	public boolean login() throws LoginException {

		if (debug)
			System.out.println("\t\t[AppLoginModule] login");

		if (callbackHandler == null)
			throw new LoginException("Error: no CallbackHandler available "
					+ "to garner authentication information from the user");

		try {
			// Setup default callback handlers.
			Callback[] callbacks = new Callback[] { 
				new NameCallback("Username: "),
				new PasswordCallback("Password: ", false) 
			};
			callbackHandler.handle(callbacks);

			String username = ((NameCallback) callbacks[0]).getName();
			String password = new String(((PasswordCallback) callbacks[1])
					.getPassword());

			((PasswordCallback) callbacks[1]).clearPassword();
// System.out.println("about to do loginValidate ("+username+","+password+")");
			success = loginValidate(username, password);
			
			callbacks[0] = null;
			callbacks[1] = null;
			if (!success) {
// System.out.println("finishing AppLoginModule.login()");
// Log the possible error
				Session hibSes = HibernateUtil.getSessionFactory().openSession();
				AppUserCtrl ctrl = new AppUserCtrl (hibSes);

				ctrl.logSessionInit(userId, username, "", "", "", errCause);
//				LogFile.error(msgLog);
System.out.println("loginModule.login: after logging error...");
				hibSes.close();
//				throw new LoginException("Authentication failed: Password does not match");
			}
//			return (true);
// LogFile.info("User '"+username+"' logged in successfully");			
			return success;
		}/*
		catch (LoginException ex) {
			throw ex;
		} */
		catch (Exception ex) {
			success = false;
			throw new LoginException(ex.getMessage());
		}
	}

	
	
	
/**
 * Abstract method to commit the authentication process (phase 2).
 *
 * <p> This method is called if the LoginContext's
 * overall authentication succeeded
 * (the relevant REQUIRED, REQUISITE, SUFFICIENT and OPTIONAL LoginModules
 * succeeded).
 *
 * <p> If this LoginModule's own authentication attempt
 * succeeded (checked by retrieving the private state saved by the
 * <code>login</code> method), then this method associates a
 * <code>AppPrincipal</code>
 * with the <code>Subject</code> located in the
 * <code>AppLoginModule</code>.  If this LoginModule's own
 * authentication attempted failed, then this method removes
 * any state that was originally saved.
 * <p>
 *
 * @exception LoginException if the commit fails
 *
 * @return true if this LoginModule's own login and commit
 *      attempts succeeded, or false otherwise.
 */
	public boolean commit() throws LoginException {

		if (debug)
			System.out.println("\t\t[AppLoginModule] commit");

		if (success) {
			if (subject.isReadOnly()) {
				throw new LoginException("Subject is Readonly");
			}

			try {
				Iterator it = tempPrincipals.iterator();
				if (debug) {
					while (it.hasNext())
						System.out.println("\t\t[AppLoginModule] Principal: "
								+ it.next().toString());
				}

				subject.getPrincipals().addAll(tempPrincipals);
				subject.getPublicCredentials().addAll(tempCredentials);

				tempPrincipals.clear();
				tempCredentials.clear();

				if (callbackHandler instanceof AppPassiveCallbackHandler)
					((AppPassiveCallbackHandler) callbackHandler).clearPassword();
System.out.println("finishing AppLoginModule.commit(): "+subject.toString());
				return (true);
			} 
			catch (Exception ex) {
				ex.printStackTrace(System.out);
				throw new LoginException(ex.getMessage());
			}
		} 
		else {
System.out.println("AppLoginModule.commit(): "+subject.toString());
			tempPrincipals.clear();
			tempCredentials.clear();
			return (true);
		}
	}
	
	
	

	/**
	 * <p> This method is called if the LoginContext's
	 * overall authentication failed.
	 * (the relevant REQUIRED, REQUISITE, SUFFICIENT and OPTIONAL LoginModules
	 * did not succeed).
	 *
	 * <p> If this LoginModule's own authentication attempt
	 * succeeded (checked by retrieving the private state saved by the
	 * <code>login</code> and <code>commit</code> methods),
	 * then this method cleans up any state that was originally saved.
	 *
	 * <p>
	 *
	 * @exception LoginException if the abort fails.
	 *
	 * @return false if this LoginModule's own login and/or commit attempts
	 *     failed, and true otherwise.
	 */
	public boolean abort() throws javax.security.auth.login.LoginException {

		if (debug)
			System.out.println("\t\t[RdbmsLoginModule] abort");

		// Clean out state
		success = false;

		tempPrincipals.clear();
		tempCredentials.clear();

		if (callbackHandler instanceof AppPassiveCallbackHandler)
			((AppPassiveCallbackHandler) callbackHandler).clearPassword();

		logout();

		return (true);
	}
	
	
	

	/**
	 * Logout a user.
	 *
	 * <p> This method removes the Principals
	 * that were added by the <code>commit</code> method.
	 *
	 * <p>
	 *
	 * @exception LoginException if the logout fails.
	 *
	 * @return true in all cases since this <code>LoginModule</code>
	 *		should not be ignored.
	 */
	public boolean logout() throws javax.security.auth.login.LoginException {

		if (debug)
			System.out.println("\t\t[RdbmsLoginModule] logout");

		tempPrincipals.clear();
		tempCredentials.clear();

		if (callbackHandler instanceof AppPassiveCallbackHandler)
			((AppPassiveCallbackHandler) callbackHandler).clearPassword();

		// remove the principals the login module added
		Iterator it = subject.getPrincipals(AppPrincipal.class).iterator();
		while (it.hasNext()) {
			AppPrincipal p = (AppPrincipal) it.next();
			if (debug)
				System.out.println("\t\t[RdbmsLoginModule] removing principal "
						+ p.toString());
			subject.getPrincipals().remove(p);
		}

		// remove the credentials the login module added
		it = subject.getPublicCredentials(AppCredential.class).iterator();
		while (it.hasNext()) {
			AppCredential c = (AppCredential) it.next();
			if (debug)
				System.out.println("\t\t[RdbmsLoginModule] removing credential "
						+ c.toString());
			subject.getPrincipals().remove(c);
		}

		return (true);
	}

	
	
	
	
/*
 * Validate the given user and password against the JDBC datasource.
 * <p>
 *
 * @param user the username to be authenticated. <p>
 * @param pass the password to be authenticated. <p>
 * @exception Exception if the validation fails.
 *
	private boolean rdbmsValidate(String user, String pass) throws Exception {

		Connection con;
		String query = "SELECT * FROM USER_AUTH where userid='" + user + "'";
		Statement stmt;
		AppPrincipal p = null;
		AppCredential c = null;
		boolean passwordMatch = false;

		try {
			Class.forName(driverClass);
		} catch (java.lang.ClassNotFoundException e) {
			System.err.print("ClassNotFoundException: ");
			System.err.println(e.getMessage());
			throw new LoginException("Database driver class not found: "
					+ driverClass);
		}

		try {
			if (debug)
				System.out.println("\t\t[RdbmsLoginModule] Trying to connect...");

			con = DriverManager.getConnection(url, "Administrator", "");

			if (debug)
				System.out.println("\t\t[RdbmsLoginModule] connected!");

			stmt = con.createStatement();

			if (debug)
				System.out.println("\t\t[RdbmsLoginModule] " + query);

			ResultSet result = stmt.executeQuery(query);
			String dbPassword = null, dbFname = null, dbLname = null;
			String updatePerm = null, deletePerm = null;
			boolean isEqual = false;

			while (result.next()) {
				if (!result.isFirst())
					throw new LoginException("Ambiguous user (located more than once): "
							+ user);
				dbPassword = result.getString(result.findColumn("password"));
				dbFname = result.getString(result.findColumn("first_name"));
				dbLname = result.getString(result.findColumn("last_name"));
				deletePerm = result.getString(result.findColumn("delete_perm"));
				updatePerm = result.getString(result.findColumn("update_perm"));
			}

			if (dbPassword == null)
				throw new LoginException("User " + user + " not found");

			if (debug)
				System.out.println("\t\t[RdbmsLoginModule] '" + pass + "' equals '"
						+ dbPassword + "'?");

			passwordMatch = pass.equals(dbPassword);
			if (passwordMatch) {
				if (debug)
					System.out.println("\t\t[RdbmsLoginModule] passwords match!");

				c = new AppCredential();
				c.setProperty("delete_perm", deletePerm);
				c.setProperty("update_perm", updatePerm);
				this.tempCredentials.add(c);
				this.tempPrincipals.add(new AppPrincipal(dbFname + " " + dbLname));
			} else {
				if (debug)
					System.out.println("\t\t[RdbmsLoginModule] passwords do NOT match!");
			}
			stmt.close();
			con.close();
		} catch (SQLException ex) {
			System.err.print("SQLException: ");
			System.err.println(ex.getMessage());
			throw new LoginException("SQLException: " + ex.getMessage());
		}
		return (passwordMatch);
	}
*/
	
	
	
/**
 * Private method to perform the core logic of logging process.
 * @param username
 * @param passwd
 * @return 
 */
	private boolean loginValidate (String username, String passwd) {
		AppPrincipal p = null;
		AppCredential c = null;
		Session hibSes = HibernateUtil.getSessionFactory().openSession();
		AppUserCtrl ctrl = new AppUserCtrl (hibSes);
		AppUser user = ctrl.getUser(username);
		AppUserValidation auv = new AppUserValidation (hibSes);
		
// in the (unlikely) case the user is null
		if (user == null) {
			errCause = AppUserCtrl.LOGIN_USER_WRONG;
			return false;
		}
			
		
		if (user.getRemoved() == 1) {
			errCause = AppUserCtrl.LOGIN_EXCEED_ATTEMPTS;
			return false;
		}
		
// This remains here but, as Singleton.adduser was removed, no user will be logged in
		if (Singleton.getInstance().isLogged(username)) {
      this.errCause = 2;
      this.userId = user.getId().intValue();

      return false;
    }
		
		Transaction tx = null;

    boolean passwdOk = auv.valUser(username, passwd);
    if (passwdOk) {
      String strRoles = "";

      c = new AppCredential();
      this.tempCredentials.add(c);

      AppPrincipal userPpal = new AppPrincipal(user.getFirstName(), user.getLastName(), username);

      userPpal.setLoggedIn(true);
      this.tempPrincipals.add(userPpal);

      List<Role> roles = ctrl.getRoleFromUser(user);
      for (Role role : roles) {
        this.tempPrincipals.add(new AppPrincipalRole(role.getName()));
        strRoles = strRoles + role.getName() + ",";
      }
      strRoles = strRoles.substring(0, strRoles.length() - 1);
//      Singleton.getInstance().addUser(username);
    }
    else
    {
      try
      {
        this.errCause = 4;
        this.userId = ((user.getId() != null) ? user.getId().intValue() : -1);

        tx = hibSes.beginTransaction();
        Integer numAttempts = user.getLoginAttempts();

        if (numAttempts.compareTo(HibernateUtil.MAX_LOGIN_ATTEMPTS) == 0) {
          this.errCause = 5;
          user.setRemoved(Integer.valueOf(1));
          user.setLoginAttempts(Integer.valueOf(0));
        }
        else {
          user.setLoginAttempts(numAttempts = Integer.valueOf(numAttempts.intValue() + 1));
        }

        tx.commit();
      }
      catch (HibernateException hibEx) {
        if (tx != null) {
          tx.rollback();
        }
        LogFile.error("Unable to set user login attempts to database");
        StackTraceElement[] stack = hibEx.getStackTrace();
        LogFile.logStackTrace(stack);
      }
    }
		hibSes.close();
		
		return passwdOk;
	}
}
