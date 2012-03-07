<%-- 
This page remove the current interview session attributes and display the 
intro page to start checking another interview.
Intended ONLY when the user is a coordinator without writing privileges
--%>

<%@ page language="java" contentType="text/html;charset=UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@page import="org.hibernate.Session, java.util.Collection, 
								java.util.Iterator, java.util.ArrayList, java.util.List,
								java.util.Enumeration, java.util.Calendar, java.util.Locale,
								java.util.TimeZone, java.text.DateFormat, java.net.URLDecoder"  %>
								
<%@page import="org.apache.commons.lang.StringEscapeUtils" %>								
<%@page import="org.cnio.appform.entity.*,
								org.cnio.appform.util.HibernateUtil, org.cnio.appform.util.LogFile,
								org.cnio.appform.util.HibController, org.cnio.appform.audit.ActionsLogger,
								org.cnio.appform.util.IntrvFormCtrl" %>
	
<%
session.removeAttribute ("patId");
session.removeAttribute ("currentSec");
session.removeAttribute ("lastSec");
%>

<jsp:include page="items4sec.jsp">
	<jsp:param name="intrv_end" value="1" />
</jsp:include>

<%--
String msg = "";
out.println ("{\"res\":0}");

--%>