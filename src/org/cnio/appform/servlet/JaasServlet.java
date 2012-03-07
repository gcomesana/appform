package org.cnio.appform.servlet;

import java.io.IOException;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.cnio.appform.jaas.*;

import javax.security.auth.login.LoginContext;
import javax.security.auth.login.LoginException;
import javax.security.auth.Subject;
import javax.security.auth.callback.CallbackHandler;
import javax.security.auth.callback.Callback;

import org.cnio.appform.util.HibernateUtil;
import org.cnio.appform.util.SingletonPreserver;
import org.cnio.appform.util.Singleton;

/**
 * Servlet implementation class for Servlet: JaasServlet
 *
 */
 public class JaasServlet extends javax.servlet.http.HttpServlet 
 													implements javax.servlet.Servlet {
   static final long serialVersionUID = 1L;
   
   private final static String JAAS_CONFIG_NAME = "appform.props";
   
   private String jaasConfigFile;
   
  /* (non-Java-doc)
	 * @see javax.servlet.http.HttpServlet#HttpServlet()
	 */
	public JaasServlet() {
		super();
//		jaasConfigLoc = getServletContext().getInitParameter("jaas.config");
	}   	
	
	
	public void init () throws ServletException {
		ServletConfig config = this.getServletConfig();
		
		String realPath = config.getServletContext().getRealPath("/");
		String theJaasFile = config.getInitParameter("jaasconfig.file");
		theJaasFile = (theJaasFile == null)? JAAS_CONFIG_NAME: theJaasFile;
// System.out.println("the fucking props file: "+fuckingFile);	
		
		realPath += theJaasFile;
// System.out.println("JaasServlet.init() - got jaasconfig.file: "+realPath);
		
		AppJaasConfiguration.init(realPath);
		
		String maxLoginAttempts = config.getInitParameter("max_login_attempts");
System.out.println("jaasServlet maxLoginAttempts: "+maxLoginAttempts);
		Integer intLoginAttempts = Integer.decode(maxLoginAttempts);
		HibernateUtil.setMaxLoginAttempts(intLoginAttempts);
		
// Set up the singleton stuff to keep track the logged users 
// (this to avoid double login)
		SingletonPreserver.preserveObject(Singleton.getInstance());
		
		
//		String testParam = config.getInitParameter("jaastest");
//System.out.println("JaasServlet.init() = got jaastest:"+testParam);		
	}
	
	
	
	
/*	
	public void init (ServletConfig config) throws ServletException {
		super.init(config);
		
		ServletConfig myCfg = this.getServletConfig();

		String realPath = myCfg.getServletContext().getRealPath("/");
System.out.println("servletCntxt.getRealPath(): "+realPath);

		jaasConfigFile = myCfg.getInitParameter("jassconfig.file");
		realPath += jaasConfigFile;
System.out.println("JaasServlet.init(config) - got '"+realPath+"'");

		AppJaasConfiguration.init(realPath);
	}
*/	
	
	
	/* (non-Java-doc)
	 * @see javax.servlet.http.HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) 
						throws ServletException, IOException {
		// TODO Auto-generated method stub
		String username = request.getParameter("j_username");
		String passwd = request.getParameter("j_password");
		
		CallbackHandler cbh = new AppPassiveCallbackHandler (username, passwd);
		
		try {
			LoginContext lc = new LoginContext ("appform", cbh);
			lc.login();
			
			Subject person = lc.getSubject();
System.out.println("person: "+person.toString());
		}
		catch (LoginException ex) {
			System.out.println(ex.getMessage());
			ex.printStackTrace();
		}
		
		
		
	}  	
	
	/* (non-Java-doc)
	 * @see javax.servlet.http.HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}   	  	    
}