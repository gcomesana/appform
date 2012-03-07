<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@page import="java.io.PrintWriter, org.hibernate.Session,
								org.cnio.appform.util.HibernateUtil, 
								org.cnio.appform.util.AppUserCtrl" %>
<%
	String json = "{\"res\":1,\"msg\":\"at least, this is a json response\"}";
	
//	pageContext.setAttribute ("json", json);
	
	Integer usrId = (Integer)request.getSession().getAttribute("usrid");
	String grpId = request.getParameter("grpid");
	String groupName = "groupName";
	
	Session hibSes = HibernateUtil.getSessionFactory().openSession();
/*		
	AppUserCtrl usrCtrl = new AppUserCtrl (hibSes);
	AppUser user = (AppUser)hibSes.get(AppUser.class, usrId);
	AppGroup grp = (AppGroup)hibSes.get(AppGroup.class, grpId);
	groupName = grp.getName();
*/		
//	boolean success = usrCtrl.setActiveGroup(user, grp);
	boolean success = false;
	
	hibSes.close();
	
	if (success) {
		json = "{\"res\":1,\"msg\":\"New active group is '"+groupName+"'\"}";
	}
	else {
		json = "{\"res\":0,\"msg\":\"New group activation could not be performed" +
				". Contact with <a href=\\\"mailto:" +AppUserCtrl.ADM_MAIL+ "\\\">" +
				"administrator</a> to report and solve this issue\"}";
				
//		json = "{\"res\":0,\"msg\":\"Merdiña2: gcomesana@cnio.es\"}";
	}
	
	pageContext.setAttribute ("json", json);
//	PrintWriter pout = response.getWriter();
//	out.print(json);
%>
${json}