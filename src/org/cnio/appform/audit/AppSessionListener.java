package org.cnio.appform.audit;

import java.util.Date;
import java.util.List;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.Enumeration;

import java.text.DateFormat;

import javax.servlet.*;
import javax.servlet.http.*;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.HibernateException;
import org.hibernate.Transaction;
import org.hibernate.Query;

import org.cnio.appform.entity.AppUser;
import org.cnio.appform.entity.AppGroup;
import org.cnio.appform.entity.RelGrpAppuser;
import org.cnio.appform.entity.AppDBLogger;
import org.cnio.appform.util.LogFile;
import org.cnio.appform.util.HibernateUtil;
import org.cnio.appform.util.AppUserCtrl;
import org.cnio.appform.util.Singleton;


public class AppSessionListener implements HttpSessionListener {

	private int sessionCount;
	private Session hibSes;
	
	public AppSessionListener() {
		this.sessionCount = 0;
		SessionFactory sf = HibernateUtil.getSessionFactory(); 
		hibSes = sf.openSession();
	}
	

/**
 * This method is call back by the container when one session is created. 
 * Actually, it does nothing as the session creation logging is done in
 * jsp/index.jsp
 */
	public void sessionCreated(HttpSessionEvent se) {

		HttpSession session = se.getSession();

		// increment the session count
		sessionCount++;

		String sessionid = session.getId();
		Date now = new Date();
System.out.println("AppSessionListner.sessionCreated: "+session.getId()+"!!!");
		boolean islogged = checkUserLogged (session);
		
	}
	

/**
 * This is the method called back by the container when one session is
 * invalidated/destroyed. It is intended to do post-invalidated-session 
 * processing
 * In order to implement the logging for the application, a row with the same
 * sessionid has to be retrieved to get the username, then one row is inserted
 * in the applog table and the user row has to be updated to set the loggedin
 * field to 0
 */
	public void sessionDestroyed (HttpSessionEvent se) {
		
		HttpSession session = se.getSession();
		String id = session.getId(), msgLog = "", username = "";
		String hql = "from AppDBLogger where sessionId='"+id+"' order by evTime desc";
		List<AppDBLogger> logRows = null;
		
		Integer logged = (Integer)session.getAttribute("logged");
		Integer usrId = (Integer)session.getAttribute("usrid");
		
		
System.out.println(".sessionDestroyed: " +"el usrId que siempre peta: "+
							usrId+" and logged: "+logged);		
		
		if (logged == null)
			return;

		Transaction tx = null;
		try {
			if (!hibSes.isOpen())
				hibSes = HibernateUtil.getSessionFactory().openSession();
			
			AppUser theUser = usrId == null? null: (AppUser)hibSes.get(AppUser.class, usrId);
			
			tx = hibSes.beginTransaction();
			Query qry = hibSes.createQuery(hql);
			logRows = qry.list();
System.out.println(".sessionDestroyed: before checking theUser is null");
			if (logRows != null && logRows.size() > 0 && theUser != null) {
// set the user loggedin to 0 and loggedfrom to null
				username = theUser.getUsername();
System.out.println("trying to reset the user: "+username);
//				theUser.setLoggedIn(0);
				theUser.setLoggedFrom(null);
				theUser.setLoginAttempts(0);
			}
			else {
				LogFile.error("No previous data found for this session ("+
							id+") in database log");
			}
			tx.commit();
			
			tx.begin();
			
// set all groups belonging this user to active=0
			AppUserCtrl usrCtrl = new AppUserCtrl (hibSes);
			AppGroup primary = usrCtrl.getPrimaryActiveGroup(theUser),
							secondary = usrCtrl.getSecondaryActiveGroup(theUser);

			String hqlQry = "from RelGrpAppuser r where r.appuser=:user and (" +
					"r.appgroup=:primary", hqlQryBis =" or r.appgroup=:secondary)";
			
			if (primary != null || secondary != null) {
			
				if (secondary == null) {
					qry = hibSes.createQuery(hqlQry+")");
					qry.setEntity("user", theUser);
					qry.setEntity("primary", primary);
				}
				else {
					qry = hibSes.createQuery(hqlQry+hqlQryBis);
					qry.setEntity("user", theUser);
					qry.setEntity("primary", primary);
					qry.setEntity("secondary", secondary);
				}
				
// set to 0 all possible active groups, not only the current active one(s)
				List<RelGrpAppuser> rels = qry.list();
				for (Iterator<RelGrpAppuser> it=rels.iterator(); it.hasNext();) {
					RelGrpAppuser rel = it.next();
System.out.println ("Deactive group "+rel.getAppgroup().getId());
					rel.setActive(0);
				}
			}
			msgLog = "User '"+username+"'("+usrId+") has logged out";
System.out.println("SessionListener: "+msgLog);			
			LogFile.info(msgLog);
			
			tx.commit();
			
			ActionsLogger acLog = new ActionsLogger (hibSes);
			acLog.customLog(id, "", theUser.getId(), "SESSION", msgLog);
		}
		catch (HibernateException hibEx) {
			if (tx != null) {
				tx.rollback();
				hibSes.close();
			}
hibEx.printStackTrace();			
			String msg = "Unable to finish and record logging out for session "+id;
			StackTraceElement[] stack = hibEx.getStackTrace();
			LogFile.error(msg);
			LogFile.error(hibEx.getLocalizedMessage());
			LogFile.logStackTrace(stack);
		}
		catch (Exception ex) {
			if (tx != null) {
				tx.rollback();
				hibSes.close();
			}
ex.printStackTrace();			
			String msg = "Unable to finish and record logging out for session "+id;
			StackTraceElement[] stack = ex.getStackTrace();
			LogFile.error(msg);
			LogFile.error(ex.getLocalizedMessage());
			LogFile.logStackTrace(stack);
		}
		finally {
System.out.println(".sessionDestroyed: closing hibSes.");
			hibSes.close();
		}

		session.removeAttribute("logged");
		session.removeAttribute("usrid");
		session.removeAttribute("user");
		session.removeAttribute("roles");
		session.removeAttribute("primaryGrpId");
		session.removeAttribute("primaryGrpName");
		session.removeAttribute("secondaryGrpId");
		session.removeAttribute ("secondaryGrpName");
		
System.out.println("Just before removing user: "+username);		
		Singleton.getInstance().rmvUser(username);
		--sessionCount;// decrement the session count variable
		
	}
	
	
	
	
	public boolean checkUserLogged (HttpSession ses) {
	/*
		String user = request.getUserPrincipal().getName();
		String ipAddr = request.getRemoteAddr();
		String sessId = request.getSession().getId();

		Session hibSes = HibernateUtil.getSessionFactory().openSession();
		
		AppUserCtrl userCtrl = new AppUserCtrl (hibSes);
		AppUser appUsr = userCtrl.getUser(user);
		
		if (appUsr.wasRemoved()) {
			response.sendRedirect("../logout.jsp");
			return;
		}

	System.out.println("username: "+appUsr.getUsername()+"; logged? "+appUsr.getLoggedIn());
	System.out.println("checking: "+ipAddr+" x "+ appUsr.getLoggedFrom() + ": "+!ipAddr.equalsIgnoreCase(appUsr.getLoggedFrom()));
	// This piece of code avoids one user logs in concurrently from DIFFERENT ips
		if (appUsr.getLoggedIn() == 1 && !ipAddr.equalsIgnoreCase(appUsr.getLoggedFrom())) {
			LogFile.info ("user ALREADY logged: '"+appUsr.getUsername()+
					"' from "+ipAddr+" (vs "+appUsr.getLoggedFrom()+") with "+
					session.getId()+" and redirecting...");
			
			userCtrl.logSessionInit(appUsr.getId(), user, "", "", ipAddr,
					AppUserCtrl.LOGIN_CONCURRENT);
			session.invalidate();
			response.sendRedirect("../nologged.jsp");
			return;
		}
	*/
		
System.out.println("Num of session attributes in t=0:");
		int i = 0;
		for (Enumeration<String> attrs = ses.getAttributeNames(); attrs.hasMoreElements();	) {
			System.out.println(++i+": "+attrs.nextElement());
		}
		
		return false;
	}
}