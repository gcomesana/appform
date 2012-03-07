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

Enumeration<String> params = request.getParameterNames();
/*
while (params.hasMoreElements()) {
  String paramName = (String) params.nextElement();
  String paramValues[] = request.getParameterValues(paramName);
	paramName = URLDecoder.decode (paramName, "UTF-8");
  if (paramValues.length == 1) {
    out.println(paramName+"="+URLDecoder.decode (paramValues[0], "UTF-8"));
  }
  else {
    out.print(paramName+"=");
    for (int i=0; i < paramValues.length; i++) {
        if (i > 0) 
        	out.print(',');
        out.print(URLDecoder.decode (paramValues[i], "UTF-8"));
    }
    out.println();
  }
}
*/

Integer intrvId = (Integer)session.getAttribute ("intrvId"),
				userId = (Integer)session.getAttribute ("usrid"),
				isLogged = (Integer)session.getAttribute ("logged");
if (isLogged == null || intrvId == null || userId == null) {
	String jsonMsg = "{\"res\":0,\"msg\":\"The session has expired. Log in again\"}";
	out.println(jsonMsg);

	return;
}


String secId = request.getParameter ("secId"),
			 patId = request.getParameter ("patId"),
			 finish = request.getParameter("finish");

Session ses = HibernateUtil.getSessionFactory().openSession();
// Patient pat = (Patient)ses.get(Patient.class, Integer.decode(patId));
IntrvFormCtrl formCtrl = new IntrvFormCtrl(ses);
boolean res = true;

// walk along the form to get the ansers

if (res) { // everything was ok, save the last section and get the next form 
/*	Performance perf = 
			formCtrl.getPerformance(pat.getCodpatient(), intrvId, userId);

	if (perf != null)
		perf.setLastSec((Integer)session.getAttribute("currentSec"));
	
	Integer currentSec = perf.getLastSec (); 
*/

	Integer currentSec = (Integer)session.getAttribute ("currentSec");
	List<Integer> lSecs = (List)session.getAttribute ("sectionIds");
	if (finish.equalsIgnoreCase("1") || (currentSec >= lSecs.size())) {
		ses.close ();
		
		session.removeAttribute ("patId");
		session.removeAttribute ("currentSec");
//		session.removeAttribute ("sectionIds");
%>
	<jsp:include page="items4sec.jsp"/>
<%		
	}
	else {
	
//Access to the sections is done with currentSec-1 because the List index
//starts with 0
	
	pageContext.setAttribute ("secId", lSecs.get(currentSec));
	session.setAttribute ("currentSec", currentSec+1);

	ses.close ();
	
%>
<%-- hay que ver si esto de incluir la pagina funciona --
%-- hay que devolver, en caso de error, un gurruño con un mensaje --%>
	<jsp:include page="items4sec.jsp">
		<jsp:param name="patid" value="${patId}"/>
		<jsp:param name="frmid" value="${secId}"/>
	</jsp:include>
<%
	}
}
else {
	String msg = "No existe el paciente o no se pudo hacer el registro";
	out.println ("{\"ok\":0,\"msg\":\""+msg+"\"}");
}

%>
