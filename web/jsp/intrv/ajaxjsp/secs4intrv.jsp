<%@ page language="java" contentType="text/html;charset=UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@page import="org.hibernate.Session, java.util.Collection, 
								java.util.Iterator, java.util.ArrayList, java.util.List, 
								java.util.Enumeration"  %>
								
<%@page import="org.cnio.appform.entity.AbstractItem,
								org.cnio.appform.entity.Text, org.cnio.appform.entity.Question, 
								org.cnio.appform.entity.Project, org.cnio.appform.entity.Section,
								org.cnio.appform.entity.Interview, 
								org.cnio.appform.entity.AnswerItem,
								org.cnio.appform.util.HibernateUtil,
								org.cnio.appform.util.HibController" %>
	
<%

Integer intrvId = (Integer)session.getAttribute ("intrvId"),
				userId = (Integer)session.getAttribute ("usrid"),
				isLogged = (Integer)session.getAttribute ("logged");

// added 03.02
String intrid = request.getParameter("frmid");
System.out.println ("secs4intrv: "+intrid);
intrvId = (intrvId == null)? Integer.decode(intrid): intrvId;

if (isLogged == null || intrvId == null || userId == null) {
	String jsonMsg = "{\"res\":0,\"msg\":\"The session has expired. Log in again\"}";
	out.println(jsonMsg);

	return;
}

String intrId = request.getParameter ("frmid");
Session hibSes = HibernateUtil.getSessionFactory().openSession();
List<Section> sectionsList = null;

List<Integer> idSecs = (List<Integer>)session.getAttribute ("sectionIds");
	
if (intrId != null || intrId.length() > 0) {
	Interview intr = (Interview)hibSes.get(Interview.class, Integer.decode(intrId));
	sectionsList = HibController.SectionCtrl.getSectionsFromIntrv (hibSes, intr);
//	pageContext.setAttribute("interview", intr);
//	pageContext.setAttribute("spid", Integer.decode(intrId));
}
else
	sectionsList = HibController.SectionCtrl.getSectionByName (hibSes, "");
	
if (idSecs == null || idSecs.size() == 0) {
	idSecs = new ArrayList<Integer>();
	for (Section aSec: sectionsList) {
		idSecs.add(aSec.getId());
	}
	session.setAttribute ("sectionIds", idSecs);
}



// Session variables to keep the sections
//session.setAttribute("sections", sectionsList);
//pageContext.setAttribute("sections", sectionsList);
/*
Integer currentSec = (Integer)session.getAttribute ("currentSec");
if (currentSec != null) 
	currentSec++;
else
	currentSec = new Integer (1);
session.setAttribute("currentSec", currentSec);
*/
hibSes.close();

Integer lastSec = (Integer)session.getAttribute("lastSec");
lastSec = (lastSec == null)? 0: lastSec;

String jsonStr = "[";
for (Section aSec: sectionsList)  {
	int active = 0;
	if (aSec.getSectionOrder() <= lastSec+1) // can be lastSec+1...
		active = 1;
	
	Integer thePreview = (Integer)session.getAttribute ("preview");
	active = (thePreview == null)? active: 1;
	
	jsonStr += "{\"name\":\""+aSec.getName()+"\",\"order\":"+aSec.getSectionOrder();
	jsonStr += ",\"id\":"+aSec.getId()+",\"active\":"+active+"},";
}
jsonStr = jsonStr.substring(0, jsonStr.length()-1);
jsonStr += "]";

out.print(jsonStr);
%>

