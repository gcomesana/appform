/**
 * 
 */
package org.cnio.appform.servlet.filter;

import java.io.IOException;
import java.io.PrintWriter;
import java.security.Principal;
import java.util.List;
import java.util.Iterator;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.cnio.appform.entity.AppUser;
import org.cnio.appform.entity.AppGroup;
import org.cnio.appform.entity.Role;
import org.cnio.appform.util.AppUserCtrl;
import org.cnio.appform.util.HibernateUtil;
import org.cnio.appform.util.LogFile;
import org.cnio.appform.util.Singleton;

import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.HibernateException;

/**
 * @author bioinfo
 *
 */
public class AuthenticationFilter implements Filter {

	
	public static final String INITPARAM_DOCROOT = "docroot";
	
	private FilterConfig cfg;
	
	private String docRoot = "";
	/* (non-Javadoc)
	 * @see javax.servlet.Filter#destroy()
	 */
	public void destroy() {
		// TODO Auto-generated method stub

	}

	
	
	/* (non-Javadoc)
	 * @see javax.servlet.Filter#doFilter(javax.servlet.ServletRequest, javax.servlet.ServletResponse, javax.servlet.FilterChain)
	 */
	public void doFilter(ServletRequest req, ServletResponse resp,
											FilterChain chain) throws IOException, ServletException {

		if (req instanceof HttpServletRequest) {
			HttpServletRequest httpReq = (HttpServletRequest) req;
			HttpServletResponse httpResp = (HttpServletResponse) resp;
			String username = httpReq.getRemoteUser();
			Principal myPpal = httpReq.getUserPrincipal();
			HttpSession session = httpReq.getSession(false);

			String ipAddr = req.getRemoteAddr();
// System.out.println("session: "+session.getId());		
			if (session == null) {
//				System.out.println ("Authentication filter: session is null");
				String contextPath = httpReq.getContextPath();
// System.out.println ("redirect: "+contextPath+"/web/jsp/index.jsp");
				httpResp.sendRedirect (contextPath+docRoot);
				return;
			}

// This conditional prevents from get into the code more than once
// the second guard is based on session as the logged attribute is set right here
			if (myPpal != null && session.getAttribute("logged") == null) {

				String sessionId = session.getId();
//				HttpServletResponse httpResp = (HttpServletResponse)resp;
				Session hibSes = HibernateUtil.getSessionFactory().openSession();
				
				AppUserCtrl userCtrl = new AppUserCtrl (hibSes);
				AppUser appUsr = userCtrl.getUser(username);
				
				if (appUsr.wasRemoved()) {
					String contextPath = httpReq.getContextPath();
					httpResp.sendRedirect(contextPath+docRoot);
					return;
				}
				
// This piece of code avoids one user logs in concurrently from DIFFERENT ips
/*				if (appUsr.getLoggedIn() == 1) {
					LogFile.info ("user ALREADY logged: '"+appUsr.getUsername()+
							"' from "+ipAddr+" (vs "+appUsr.getLoggedFrom()+") with "+
							session.getId()+" and redirecting...");
					
					userCtrl.logSessionInit(appUsr.getId(), username, "", "", ipAddr,
																	AppUserCtrl.LOGIN_CONCURRENT);
					session.invalidate();
					httpResp.sendRedirect("../nologged.jsp");
					return;
				}
				appUsr.setLoggedIn(1);
*/				
				session.setAttribute ("user", username);
				session.setAttribute ("usrid", appUsr.getId());
				session.setAttribute ("logged", 1);
// System.out.println("Set user to '"+username+"' and usrid to '"+appUsr.getId()+"'");
				
// Roles stuff
				List<Role> roles = userCtrl.getRoleFromUser(appUsr);
				int numRoles = roles.size();
				String strRoles = "";
				for (Role r: roles) {
					strRoles += r.getName()+",";
				}
				
				if (strRoles.length() > 0)
					strRoles = strRoles.substring(0, strRoles.length()-1);
				else {
					httpResp.sendRedirect("../logout.jsp");
					return;
				}
				session.setAttribute ("roles", strRoles);
				
				
// This conditional, which seems to redundant, is here as the previous snippet
// can fail by raising an exception during database update
				boolean isLogged = Singleton.getInstance().isLogged(username);
				if (session != null && isLogged) {
					userCtrl.logSessionInit(appUsr.getId(), username, strRoles, 
																	sessionId, ipAddr, AppUserCtrl.LOGIN_SUCCESS);
			LogFile.info("User '"+username+"' logged in with role(s) '"+strRoles+"'");
// System.out.println("User '"+username+"' logged in with role(s) '"+strRoles+"'");
				}
System.out.println ("AuthenticationFilter: I walked over here");
				hibSes.close();
			} // myPpal != null && session.getAttribute("logged") == null 
		}
		
		chain.doFilter(req, resp);
	}
	
	

	/* (non-Javadoc)
	 * @see javax.servlet.Filter#init(javax.servlet.FilterConfig)
	 */
	public void init(FilterConfig arg0) throws ServletException {
		// TODO Auto-generated method stub
		cfg = arg0;
		
		docRoot = cfg.getInitParameter(INITPARAM_DOCROOT);
	}

}
