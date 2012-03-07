<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%-- 
This page saves the data for a patient. Inserts a row in the performance table/
ternary relationship. Previously, it checks whether or not this patient has done
this interview before 
--%>
    
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
<%@page import="org.cnio.appform.util.SaveAnswers"%>								
	

<%
Integer intrvId = (Integer)session.getAttribute ("intrvId"),
		grpId = (Integer)session.getAttribute ("secondaryGrpId"),
		userId = (Integer)session.getAttribute ("usrid"),
		isLogged = (Integer)session.getAttribute ("logged");

if (isLogged == null || intrvId == null || userId == null) {
	String jsonMsg = "{\"res\":0,\"msg\":\"The session has expired. Log in again\"}";
	out.println(jsonMsg);

	return;
}


Enumeration<String> params = request.getParameterNames();
Integer	currentSec = (Integer)session.getAttribute ("currentSec");

String secId = request.getParameter ("secId"),
			patId = request.getParameter ("patId"),
			finish = request.getParameter("finish"),
			ipAddr = request.getRemoteAddr(),
			jspSesId = request.getSession().getId(),
			jsonMsg = "";


int jsonRes = -1; // 0 is something was wrong, 1 everything is ok, -1 role not able to save
			 
Session ses = HibernateUtil.getSessionFactory().openSession();
Patient pat = (Patient)ses.get(Patient.class, Integer.decode(patId));
// IntrvFormCtrl formCtrl = new IntrvFormCtrl(ses);
boolean res = true;

// this is the real time param. if set, there will be nothing to save
String rtParam = (String)session.getAttribute("rt");
pageContext.setAttribute("rtParam", rtParam);
pageContext.setAttribute ("patId", patId);

// checking roles
// The coordinator role is set, no matter what kind of coordinator, as opposite
// the admin, interviewer or editor roles
String roles = (String)session.getAttribute("roles");
boolean coordinatorRole = false;
if ((roles.indexOf("editor") == -1) && (roles.indexOf("admin") == -1) &&
		(roles.indexOf("interviewer") == -1)) {
	coordinatorRole = true;
}

// conditions to save:
// not to be working on autosaving and -> removed!!!!
// to have a admin, editor or interviewer role   
// if ((rtParam == null || !rtParam.equalsIgnoreCase("1")) && !coordinatorRole) {
if (!coordinatorRole) {
	
	try {
		SaveAnswers saveAns = new SaveAnswers (ses);
		saveAns.decodeParams(request);
		saveAns.getQuestions4Section(intrvId, (currentSec+1), pat.getCodpatient());
System.out.println ("***-> save-on-sectionchange: about to call saveOrUpdateSectionAnswers("+patId+")");
		saveAns.saveOrUpdateSectionAnswers(Integer.decode(patId));
		
		jsonRes = 1;
		jsonMsg = "Questions were updated successfully";
	}
	catch (Exception ex) {
		jsonRes = 0;
		jsonMsg = "There was a problem saving section data. Please, refill the section and try to save again";
		
		ex.printStackTrace(System.err);
	}
	
} // end if not coordinator role
else {
	jsonMsg = "Coordinator roles can not modify interviews";
	jsonRes = 1;
}
	
// Left side sections stuff, this is to get the next section questions and 
// light the next section up on the left side
// Integer currentSec = (Integer)session.getAttribute ("currentSec");
// currentSec = (currentSec == null)? 0: currentSec;

// ActionsLogger logDb = new ActionsLogger (ses);
	
	if (ses.isOpen()) {
		ses.flush();
		ses.close ();
	}
// System.out.println("saveform: currentSec = "+session.getAttribute ("currentSec"));


String jsonOut = "{\"res\":"+jsonRes+",\"msg\":\""+jsonMsg+"\"}";
// ,\"secId\":"+Integer.decode(secId)+"}";
out.println (jsonOut);
%>
