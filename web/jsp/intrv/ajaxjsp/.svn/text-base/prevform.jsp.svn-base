<%-- 
This page saves the data for a patient. Inserts a row in the performance table/
ternary relationship. Previously, it checks whether or not this patient has done
this interview before 
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
								org.cnio.appform.util.HibernateUtil,
								org.cnio.appform.util.HibController,
								org.cnio.appform.util.IntrvFormCtrl" %>
	
<%
Integer intrvId = (Integer)session.getAttribute ("intrvId"),
				userId = (Integer)session.getAttribute ("usrid"),
				isLogged = (Integer)session.getAttribute ("logged");
if (isLogged == null || intrvId == null || userId == null) {
	String jsonMsg = "{\"res\":0,\"msg\":\"The session has expired. Log in again\"}";
	out.println(jsonMsg);

	return;
}


Enumeration<String> params = request.getParameterNames();
String secId = request.getParameter ("secId"),
				patId = request.getParameter ("patId");

Integer currentSec = (Integer)session.getAttribute ("currentSec");
List<Integer> lSecs = (List)session.getAttribute ("sectionIds");

pageContext.setAttribute ("patId", patId);
if (currentSec < 1) {
	pageContext.setAttribute ("secId", lSecs.get(currentSec-1));
	session.setAttribute ("currentSec", currentSec);
}
else
	pageContext.setAttribute ("secId", lSecs.get(currentSec));

%>
<%-- hay que ver si esto de incluir la pagina funciona --
%-- hay que devolver, en caso de error, un gurruño con un mensaje --%>
<jsp:include page="items4sec.jsp">
	<jsp:param name="patid" value="${patId}"/>
	<jsp:param name="frmid" value="${secId}"/>
</jsp:include>