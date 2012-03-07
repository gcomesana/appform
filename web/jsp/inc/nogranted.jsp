<!-- prjlist.jsp -->
<%-- This snippet list the projects in the system --%>
<%@ page language="java" contentType="text/html;charset=UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@page import="org.hibernate.Session, java.util.Collection, 
								java.util.Iterator, java.util.ArrayList, java.util.List,
								java.util.Enumeration"  %>
								
<%@page import="org.cnio.appform.util.HibernateUtil,
								org.cnio.appform.util.AppUserCtrl,
								org.cnio.appform.util.IntrvController" %>	
								
<%
// 	Session hibSes = HibernateUtil.getSessionFactory().openSession();

//	hibSes.close();
%>


<!-- **************** START CONTENT AREA (REGION b)**************** -->		 
	<div id='regionNotGrantedB'>
		<br>
		You <span style="color:red;font-weight: bold;">
		don't have permissions to see and execute</span> the requested page 
		in the application.<br><br>
		Please, log in with different (higher) roles or contact and report the
		issue to <a href="mailto:gcomesana@cnio.es" style="text-decoration:none;color:darkblue">
		the administrator</a>.<br>
		You can see your current roles at the upper right corner in this page.<br>
		<br><br>
		<a href="../logout.jsp" style="text-decoration:none;color:darkblue">Log in</a> again as a different user<br>
		or<br>
		<a href="javascript:window.history.go(-1)" style="text-decoration:none;color:darkblue">go back to the previous page</a>

	</div> <!-- regionB -->
<!-- ****************** END CONTENT AREA (REGION B) ***************** -->