<!-- **************** START CONTENT AREA (REGION b)**************** -->
<%@ page language="java" contentType="text/html;charset=UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@page import="org.hibernate.Session, java.util.Collection, 
								java.util.Iterator, java.util.ArrayList, java.util.List, 
								java.util.Enumeration"  %>
								
<%@page import="org.cnio.appform.entity.AbstractItem, org.cnio.appform.entity.AppUser,
								org.cnio.appform.entity.Text, org.cnio.appform.entity.Question, 
								org.cnio.appform.entity.Section, org.cnio.appform.entity.AppGroup,
								org.cnio.appform.entity.AnswerItem,
								org.cnio.appform.util.AppUserCtrl,
								org.cnio.appform.util.HibernateUtil" %>	
<%
	Session hibSes = HibernateUtil.getSessionFactory().openSession();
	
	AppUserCtrl usrCtrl = new AppUserCtrl (hibSes);
	AppUser user = (AppUser)hibSes.get(AppUser.class, 550);
	
	List<AppGroup> groups = usrCtrl.getSecondaryGroups(user);
	for (AppGroup grp: groups) {
		out.println("<b>"+grp.getName()+"</b><br>");
	}
	
	hibSes.close();
%>

