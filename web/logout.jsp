<%@page import="org.cnio.appform.util.AppUserCtrl"%>
<%@page import="org.cnio.appform.util.LogFile, 
							org.cnio.appform.entity.AppUser, org.cnio.appform.entity.AppGroup,
							org.cnio.appform.util.HibernateUtil"%>
							
<%@page import="org.hibernate.Session, org.hibernate.Transaction,
								org.hibernate.HibernateException" %>

<%
	String adm = request.getParameter("adm");
	String ipAddr = request.getRemoteAddr();
	String appname = request.getContextPath();

	 try {
	
		session.invalidate();
	}
	catch (IllegalStateException ex) {
		
	}

	
	if (adm == null)
  	response.sendRedirect ("jsp/index.jsp");
	else {
		response.sendRedirect ("/"+appname+"/web/admintool/index.jsp");
	}
%>
