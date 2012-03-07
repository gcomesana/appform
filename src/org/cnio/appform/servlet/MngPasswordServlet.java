package org.cnio.appform.servlet;

import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

import org.hibernate.Session;
import org.hibernate.HibernateException;
import org.hibernate.Transaction;
import org.cnio.appform.entity.AppDBLogger;
import org.cnio.appform.entity.AppUser;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import org.cnio.appform.jaas.AppUserValidation;

import org.cnio.appform.util.AppUserCtrl;
import org.cnio.appform.util.HibernateUtil;
import org.cnio.appform.util.LogFile;
import org.cnio.appform.util.captcha.ImgCaptchaSingleton;
import org.cnio.appform.util.TransportSender;

import com.octo.captcha.service.CaptchaServiceException;
/**
 * Servlet implementation class for Servlet: MngPasswordServlet
 * This class performs the protocol when an user lose the password:
 * - check whether or not the user is registered
 * - check the captcha to avoid possble attacks
 * - if so, deletes the database password and generates a new one
 * - send the new password back to the user
 */
 public class MngPasswordServlet extends javax.servlet.http.HttpServlet implements javax.servlet.Servlet {
   static final long serialVersionUID = 1L;
   
   private String urlPassGet = 
  	 "http://localhost:8080/appform/users/getpasswd?digest=";
   
// The location of the file with the form to reset the password  
   private String resetLoc = "";
   private static final String RESET_LOC = "/appform/web/getpass";
   
   
  /* (non-Java-doc)
	 * @see javax.servlet.http.HttpServlet#HttpServlet()
	 */
	public MngPasswordServlet() {
		super();
	}   	
	
	
	
	
	/* (non-Java-doc)
	 * @see javax.servlet.http.HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet (HttpServletRequest request, 
						HttpServletResponse response) throws ServletException, IOException {
// This is to redirect in the case of digest is present
	  String digest = request.getParameter("digest");
	  if (digest != null) {
	  	response.sendRedirect(resetLoc+"/resetpass.jsp?digest="+digest);
	  	return;
	  }
	}  
	
	
	public void init () throws ServletException {
		ServletConfig config = this.getServletConfig();
/*		
java.util.Enumeration parameters = config.getInitParameterNames(); 
while (parameters.hasMoreElements()) {
  String parameter = (String) parameters.nextElement(); 
  System.out.println("MngPasswdServlet: Parameter name : " + parameter); 
  System.out.println("MngPasswdServlet: Parameter value : " + 
    config.getInitParameter(parameter)); 
}		
*/
		
		String realPath = config.getServletContext().getRealPath("/");
		String urlInitParam = config.getInitParameter("urlPassGet");
		String location = config.getInitParameter("resetPasswdLoc");

System.out.println ("resetLoc: "+location+"; urlPassGet: "+urlInitParam);

		resetLoc = (location != null)? location: RESET_LOC;
		urlPassGet = (urlInitParam != null)? urlInitParam: urlPassGet;
	}
	
	
	
	/* (non-Java-doc)
	 * @see javax.servlet.http.HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost (HttpServletRequest request, 
										HttpServletResponse response) throws ServletException, IOException {
		String jsonStr = "";
		
// First, check if captcha is ok
		Boolean isResponseCorrect = Boolean.FALSE;
	    //remenber that we need an id to validate!
	  String captchaId = request.getSession().getId();

//retrieve the response
	  String resp = request.getParameter("j_captcha_response");
	  String email = request.getParameter("frmemail");
	  String username = request.getParameter("frmusername");
	  String passwd = request.getParameter ("frmpass");
	  
	  if (passwd != null) { // process the new password reset
// In this case, check whether or not the request comes from a password miss
// or from a password expiration
	  	String src = request.getParameter("source");
	  	if (src != null && src.compareTo("extjs") == 0) {
	  		HttpSession ses = request.getSession();
	  		username = (String)ses.getAttribute("user");
	  		
	  		jsonStr = checkNewExtPasswd (username, passwd, request);
	  	}
	  	else
	  		jsonStr = checkNewPasswd (username, passwd, request);
	  
	  }
	  else {
			// Process the new password request
		  try {
		    isResponseCorrect = ImgCaptchaSingleton.getInstance().
		     														validateResponseForID(captchaId, resp);
		  } 
		  catch (CaptchaServiceException e) {
		    // should not happen, may be thrown if the id is not valid
		  }
		
		  if (isResponseCorrect) {
		  	Session hibSes = HibernateUtil.getSessionFactory().openSession();
				
				AppUserCtrl usrCtrl = new AppUserCtrl (hibSes);
				AppUser user = usrCtrl.getUserFromEmail(email, username);
				
				if (user == null) {
					jsonStr = "{\"res\":0, \"msg\":\"User with email '"+email+"' was not found\"}";
				}
				else if (username.equalsIgnoreCase(user.getUsername()) == false) {
System.out.println("username: "+username+"; user.getUsername(): "+user.getUsername());
					jsonStr = "{\"res\":0, \"msg\":\"User '"+username+"' was not found\"}";
				}
				else {
//					PasswordGenerator passGen = new PasswordGenerator();
//					String newPasswd = passGen.getPassword();
					Transaction tx = null;
					try {
/*						
						tx = hibSes.beginTransaction();
						user.setPasswd(newPasswd);
						tx.commit();
*/						
						String theUrl = urlPassGet+user.getPasswd();
						String mailbody = "DO NOT REPLY TO THIS MAIL.\n\n" +
								"Click on the link enclosed in square brackets or copy and paste it into " +
								"your browser:\n[" + theUrl +"]\n\n";
						
						mailbody += "If this email means nothing to you, then it is possible " +
								"that somebody else has entered your email address either " +
								"deliberately or accidentally, so please ignore this email.\n\n" +
								"If your have any questions, please send an email to " +
								"<a href=\"mailto:"+AppUserCtrl.ADM_MAIL+"\">system admin</a>.\n\n" +
								"Thank you";
						TransportSender ms = new TransportSender ();
						String strSubject = 
								"Password Recovery request from user "+user.getUsername();
						ms.send(user.getEmail(), strSubject, mailbody);
						
	//					jsonStr = "{\"res\":1, \"msg\":\"New password is <b>"+newPasswd+"</b>\"}";
						jsonStr = "{\"res\":1, \"msg\":\"An email with the new password"+
												" has been sent to "+user.getEmail()+"\"}";
						
					}
					catch (HibernateException ex) {
						if (tx != null)
							tx.rollback();
						
						jsonStr = "{\"res\":0,";
						jsonStr += "\"msg\":\"New password could not be generated. Try again\"}";
					}
				}
		  	hibSes.close();
		  }
		  else
		  	jsonStr = "{\"res\":0, \"msg\":\"Bad captcha: try again\"}";
		  
	  } // else if passwd = null
	   
	  PrintWriter out = response.getWriter();
		out.print(jsonStr);
	}
	

	
/**
 * This method just checks the new password for the user
 * @param username, the username
 * @param passwd, the new password as introduced by user
 * @return a json string with the result of the operation
 */	
	private String checkNewPasswd (String username, String passwd, HttpServletRequest req) {
		String jsonStr;
		Session hibSes = null;
		String msgLog = null;
		
		hibSes = HibernateUtil.getSessionFactory().openSession();
		
		AppUserCtrl usrCtrl = new AppUserCtrl (hibSes);
		AppUser user = usrCtrl.getUser(username);
		if (passwd.matches(username) == false) {
			Transaction tx = null;
			if (user != null) {
				
				AppUserValidation userVal = new AppUserValidation (hibSes);
				if (userVal.valUser(username, passwd)) {
					msgLog = "Password can not be similar to the previous one";
					jsonStr = "{\"res\":0, \"msg\":\"Password can not be similar to the previous one\"}";
					hibSes.close();
					
					return jsonStr;
				}
				
				try {
					tx = hibSes.beginTransaction();
					user.setPasswd(passwd);
					user.setLastPasswdUpdate(new java.util.Date());
					
					tx.commit();
					msgLog = "The password was reset successfully";
					jsonStr = "{\"res\":1, \"msg\":\"The password was reset successfully\"}";
				}
				catch (HibernateException hibEx) {
					if (tx != null)
						tx.rollback();
					
					hibEx.printStackTrace(System.err);
					msgLog = "Password could not be reset";
					jsonStr = "{\"res\":0, \"msg\":\"Password could not be reset.\"}";
				}
			}
			else { 
				msgLog = "User '"+username+"' was not found";
				jsonStr = "{\"res\":0, \"msg\":\"User '"+username+"' was not found\"}";
			}
	  }
	  else {
	  	msgLog = "Password can not contain the username";
	  	jsonStr = "{\"res\":0, \"msg\":\"Password can not contain the username\"}";
	  }
		if (hibSes != null)
			hibSes.close();
		
		auditChange (user, msgLog, req);
		return jsonStr;
	}
	
	
	
/**
 * This method just checks the new password for the user
 * @param username, the username
 * @param passwd, the new password chosen by user on Ext modal form
 * @return a json string with the result of the operation
 */	
	private String checkNewExtPasswd (String username, String passwd, HttpServletRequest req) {
		String jsonStr;
		Session hibSes = null;
		Transaction tx = null;
		String msgLog = "";
		
		hibSes = HibernateUtil.getSessionFactory().openSession();
		
		AppUserCtrl usrCtrl = new AppUserCtrl (hibSes);
		AppUser user = usrCtrl.getUser(username);
		
		if (passwd.matches(username) == false) {
			AppUserValidation userVal = new AppUserValidation (hibSes);
			if (userVal.valUser(username, passwd)) { // passwords are the same
				msgLog = "Password can not be similar to the previous one";
				
				jsonStr = "{\"success\":false, " + "\"errormsg\":\""+msgLog+"\"}";
				hibSes.close();
				
				return jsonStr;
			}
			
			
			if (user != null) {
				try {
					tx = hibSes.beginTransaction();
					user.setPasswd(passwd);
					user.setLastPasswdUpdate(new java.util.Date ());
					
					tx.commit();
					msgLog = "The password was reset successfully";
					jsonStr = "{\"success\":true, \"msg\":\""+msgLog+"\"}";
				}
				catch (HibernateException hibEx) {
					if (tx != null)
						tx.rollback();
					
					hibEx.printStackTrace(System.err);
					msgLog = "Password could not be reset";
					jsonStr = "{\"success\":false, \"errormsg\":\""+"\"}";
				}
			}
			else {
				msgLog = "User '"+username+"' was not found";
				jsonStr = "{\"success\":false, \"errormsg\":\""+msgLog+"\"}";
			}	
	  }
	  else {
	  	msgLog = "Password can not contain the username";
	  	jsonStr = "{\"success\":false, \"errormsg\":\""+msgLog+"\"}";
	  }

		if (hibSes != null)
			hibSes.close();
		
		auditChange (user, msgLog, req);
		return jsonStr;
	}
	
	
	
/**
 * Audit the password change, either it is wrong or right
 * @param user, the AppUser who is changing the password
 * @param msgLog, the message for the log
 * @param request, the request to get the session id
 */
	private void auditChange (AppUser user, String msgLog, HttpServletRequest request) {
		Session hibSes = null;
		Transaction tx = null;
		HttpSession mySes = request.getSession();
	// AUDITING			
		try {
			hibSes = HibernateUtil.getSessionFactory().openSession();
			tx = hibSes.beginTransaction();
			
			AppDBLogger sessionLog = new AppDBLogger ();
			sessionLog.setUserId(user.getId());
			sessionLog.setSessionId(mySes.getId());
			msgLog = "Password change for user '"+user.getUsername()+"': " + msgLog;
			sessionLog.setMessage(msgLog);
			sessionLog.setLastIp(request.getRemoteAddr());
			hibSes.save(sessionLog);
			
			tx.commit();
		}
		catch (HibernateException ex) {
			if (tx != null)
				tx.rollback();
			
			LogFile.error("Fail to log user password change:\t");
			LogFile.error("userId="+user.getId()+"; sessionId="+mySes.getId());
			LogFile.error(ex.getLocalizedMessage());
			StackTraceElement[] stack = ex.getStackTrace();
			LogFile.logStackTrace(stack);
		}
		finally {
			if (hibSes != null)
				hibSes.close();
		}
	}
	
}