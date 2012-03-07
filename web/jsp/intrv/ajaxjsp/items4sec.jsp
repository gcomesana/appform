<%--
This page gets the items for a section. It takes into acount the existence of
a patientid in the session attribute set in order to include the patient code
introduction page or display the proper section.
--%>

<%@ page language="java" contentType="text/html;charset=UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@page import="org.hibernate.Session, org.hibernate.engine.SessionFactoryImplementor,
								java.util.Collection, org.hibernate.SessionFactory, 
								java.util.Iterator, java.util.ArrayList, java.util.List,
								java.util.Enumeration, java.util.Calendar, java.util.Locale,
								java.util.TimeZone, java.text.DateFormat"  %>
								
<%@page import="org.apache.commons.lang.StringEscapeUtils" %>								
<%@page import="org.cnio.appform.entity.*,
								org.cnio.appform.util.IntrvFormCtrl,
								org.cnio.appform.util.HibernateUtil,
								org.cnio.appform.util.HibController,
								org.cnio.appform.util.RenderEng" %>

<!-- groovy lib included to add new renderer funcionality -->
<%@page import="org.cnio.appform.groovy.util.*" %>								

<%@page import="java.util.*" %>	
<%
Integer isLogged = (Integer)session.getAttribute("logged");
Integer	intrvId = (Integer)session.getAttribute ("intrvId");
Integer usrId = (Integer)session.getAttribute ("usrid");

if (isLogged == null || intrvId == null || usrId == null) {
	String jsonMsg = "{\"res\":0,\"msg\":\"The session has expired. Log in again\"}";
	out.println(jsonMsg);
	
	return;
}

// if frmid and spid are present, then 
// this is the result of an update/save of an item
String secId = request.getParameter ("frmid");
String patId = request.getParameter ("patid");
String finish = request.getParameter("intrv_end");

String rt = (String)session.getAttribute("rt");

pageContext.setAttribute ("frmid", secId);
pageContext.setAttribute ("patid", patId);
// pageContext.setAttribute ("rt", rt);

// usrId = (usrId == null)? 100: usrId;

String itrtd="<tr><td>", etrtd="</td></tr>", btnDisabled = "";
List<AbstractItem> itemsSec = null;
Section sec = null;

String dbName = this.getServletContext().getInitParameter("dbName");
String dbServer = this.getServletContext().getInitParameter("dbServerName");
String dbUserName = this.getServletContext().getInitParameter("dbUserName");
String dbPasswd = this.getServletContext().getInitParameter("dbPassword");

/*
SessionFactory sf = HibernateUtil.getSessionFactory();
final SessionFactoryImplementor sfi =	(SessionFactoryImplementor)sf;
String dbUrl = 
			sfi.getSettings().getConnectionProvider().getConnection().getMetaData().getURL();

////////////////////// Decompose dbUrl as jdbc:postgresql://host:port/database
int pointer = dbUrl.lastIndexOf ("/");
int pointerBis = dbUrl.lastIndexOf ("/", pointer-1);

String dbName = dbUrl.substring (pointer+1, dbUrl.length());
String dbServer = dbUrl.substring (pointerBis+1, pointer);

int colonIndex = dbServer.indexOf (":");
if (colonIndex != -1)
    dbServer = dbServer.substring (0, colonIndex);
////////////////////////////////////// EO database URL parsing
*/

// Open session, only TypesCache needs a hibernate session to work
Session hibSes = HibernateUtil.getSessionFactory().openSession();
IntrvFormCtrl intrCtrl = new IntrvFormCtrl(hibSes);

if (secId != null) { // it is suppossed than we have always a secId
	sec = (Section)hibSes.get(Section.class, Integer.decode(secId));
// Here we have to read simple text, questions and containers!!!!
//	itemsSec = HibernateUtil.getItems4Section (hibSes, Integer.decode(secId));
	itemsSec = HibernateUtil.getContainers4Section(hibSes, sec);
	pageContext.setAttribute("section", sec);
}
else { // this is in the case the secId is missing, which implies the load of the first section
	Interview intrv = (Interview)hibSes.get(Interview.class, intrvId);
	sec = intrv.getSections().get(0);
	itemsSec = HibernateUtil.getContainers4Section(hibSes, sec);
	
	pageContext.setAttribute ("section", sec);
	secId = sec.getId().toString();
}
AppUser user = (AppUser)hibSes.get(AppUser.class, usrId);


// this switch is to check whether or not this is a normal page or the
// intro page and, so, disabling buttons or not
boolean normalpage = false, coordinatorRole = false;
Integer thePatId = null;

// Previewing
if (session.getAttribute ("preview") != null) {
	String codProject = (String)session.getAttribute("prjId");
	
//	codProject = (codProject == null? IntrvFormCtrl.DEFAULT_PRJ: codProject);
// for preview we use the default project with the NULL_PATIENT
// no worries as it is not possible to save data on preview
	codProject = IntrvFormCtrl.DEFAULT_PRJ;
	Patient pat = intrCtrl.getPatientFromCode(IntrvFormCtrl.NULL_PATIENT);
	patId = Integer.toString(pat.getId());
	btnDisabled = "disabled=\"disabled\" ";
}
else { // or not previewing but the patId can be got from the session vars
	thePatId = (Integer)session.getAttribute ("patId");
	patId = (thePatId != null)? thePatId.toString(): patId;
	
// Besides checking the patient id, we have to check whether or not the
// role is authorized to perform the interview
	String roles = (String)session.getAttribute("roles");
	if ((roles.indexOf("editor") == -1) && (roles.indexOf("admin") == -1) &&
			(roles.indexOf("interviewer") == -1)) {
		btnDisabled = "disabled=\"disabled\" ";
		coordinatorRole = true;
	}
}


// This means we are rendering the intro page and the guard patId == null
// indicates this is a new interview. patId is set null on saveform.jsp when
// the intervie is finished/paused
if (patId == null) { 
	btnDisabled = "";
%>

<jsp:include page="intropage.jsp" /> 

<%
}
else { // a "normal" section
	normalpage = true;
//	Patient pat = (Patient)hibSes.get(Patient.class, Integer.decode(patId));

	RenderEng render;
	if (rt == null || rt.equalsIgnoreCase("0"))
		render	= new RenderEng();
	else
		render = new RenderEng (1);
	
	out.println ("<form id=\"sectionForm\" name=\"sectionForm\">");
	out.println ("<span class=\"titleForm\">"+sec.getName()+"</span><br><br>");
	out.println ("<table>");
	out.println ("<input type=\"hidden\" id=\"patId\" name=\"patId\" value=\""+patId+"\" />");
	out.println ("<input type=\"hidden\" id=\"secId\" name=\"secId\" value=\""+secId+"\" />");
	out.println ("<input type=\"hidden\" id=\"finish\" name=\"finish\" value=\"0\" />");
	
	
///////////////////////////////////////////////////////////////////////////
// MAIN BODY OF THE FORM, RENDERING COMPONENTS AND TEXTS //////////////////
///////////////////////////////////////////////////////////////////////////



// In the case of short interview, display the textarea for justifying
//////////////////////////////////////////////////////////////////////////////
	Integer shortPerf = (Integer)session.getAttribute("shortPerf");
	if (shortPerf != null && shortPerf == 1 && sec.getSectionOrder() == 1) {
		PerfUserHistory puh = 
				intrCtrl.getLastJustification(Integer.decode(patId), intrvId);
		
		String msgEn = "A <b>SHORT</b> interview performance was chosen this time. This decision has ";
		msgEn += "to be justified. The next text is the justification for this ";
		msgEn += "interview last time it was performed. Just keep this text or ";
		msgEn += "edit it to justify the short performance this time";
		String msgEs = "Se ha elegido realizar una entrevista <b>CORTA</b>. Esta decisión ";
		msgEs += "tiene que ser justificada. El siguiente texto es la justificación ";
		msgEs += "para esta entrevista la última vez que fue realizada. Tan solo ";
		msgEs += "mantiene este texto o edítalo para justificar la entrevista ";
		msgEs += "corta esta vez";
		
		String justifyTime = "";
		if (puh != null) {
			justifyTime = "<br>Last justification date/time was: ";
			DateFormat endf = DateFormat.getDateInstance(DateFormat.LONG, Locale.ENGLISH);
			justifyTime += endf.format(puh.getTimeStamp());
		}
		
		Integer grpId = (Integer)session.getAttribute("primaryGrpId");
		AppGroup grp = 	(AppGroup)hibSes.get(AppGroup.class, grpId);

		if (grp.getCodgroup().toUpperCase() == "ESP")
			out.print("<tr><td>"+msgEs+justifyTime+"</td></tr>");
		else
			out.print("<tr><td>"+msgEn+justifyTime+"</td></tr>");
		
		out.println("<tr><td>");
		String onBlurRT = " onblur=\"event.stopPropagation();";
		onBlurRT += "intrvFormCtrl.sendJustification(this, "+patId+", "+intrvId+")\" ";
		
		String onFocusTxt = " onfocus=\"intrvFormCtrl.onfocus('"+
					IntrvFormCtrl.JUSTIFICATION_NAME+"');\" ";
		String txtJustify = "<textarea id=\""+IntrvFormCtrl.JUSTIFICATION_NAME+
				"\" name=\""+IntrvFormCtrl.JUSTIFICATION_NAME+"\"";
		
// REAL TIME EVENT for justification textarea		
		if (rt != null && rt.equalsIgnoreCase("1"))
			txtJustify += onBlurRT;
		
		txtJustify += onFocusTxt + " rows=\"5\" cols=\"50\" wrap=\"soft\" must=\"1\">";
		txtJustify += puh == null? "": 
							(puh.getJustification() == null)? "": puh.getJustification();
		txtJustify += "</textarea>";
		
		out.print (txtJustify);
		out.print("</td></tr>");
	}
//////////////////////////////////////////////////////////////////////////////
// END OF display the textarea in the case of a justification is required
	



// GROOVY BASED RENDER INITIALIZATION should be here ///////////////////////////
// * new the ItemsFecher (dbServer, dbName, dbUser) and
// * set the resultSet (ItemsFetcher (intrvId, prjCode, patid, orderSec)
// * new the FormRenderUtil as support for main FormRender
// * new the FormRender (patId, secId, orderSec, resultSet, null)
// * new the TypesCache (intrvId)
// * set the render types cache
// * set the render formRenderUtil
// * set preview or not

	String thePatCode;
	Patient myPat = (Patient)hibSes.get(Patient.class, Integer.decode(patId));
	thePatCode = (session.getAttribute ("preview") != null)? IntrvFormCtrl.NULL_PATIENT:
		myPat.getCodpatient();
	int secOrder = sec.getSectionOrder().intValue();

System.out.println ("patId: "+patId+", thePatCode: "+thePatCode);
	TypesCache cache = new TypesCache (hibSes, intrvId, true);	
	
// NO hibernate calls after this point: so we close the session just now	
System.out.println("items4sec before finish: hibSes.isOpen? "+hibSes.isOpen());
	if (hibSes != null && hibSes.isOpen())
		hibSes.close();
	
	String fetcherUserName = dbUserName == null? HibernateUtil.DB_USERNAME: dbUserName;
System.out.println ("dbName: "+dbName+"; dbServer: "+dbServer+":"+fetcherUserName);
//	ItemsFetcher fetcher = new ItemsFetcher (dbName, dbServer, fetcherUserName);

	String dbPort;
	String remoteHost = request.getRemoteHost();
	if (remoteHost.indexOf("localhost") != -1 ||
			remoteHost.indexOf("lady-qu") != -1 ||
			remoteHost.indexOf ("127.0.0.1") != -1)
		dbPort = "4321";
	else
		dbPort = "5432";
	
System.out.println ("remoteHost: "+remoteHost+"; dbPort: "+dbPort);
	ItemsFetcher fetcher = new ItemsFetcher (dbServer, dbName, fetcherUserName, dbPasswd, dbPort);
	FormRenderUtil fru = new FormRenderUtil ();
	
	List<Object[]> rs = fetcher.getResultSet (intrvId, thePatCode, secOrder);
// newReps contains the elements in the repeatable blocks, no matter the patient
// then, it includes the elements added after a questionnaire performance, which
// wouldn't have any answer and, so, wouldn't appear when resuming interviews
	List<Object[]> newReps = fetcher.getRepeatableItemsBlock(intrvId, secOrder);
	thePatId = fetcher.getPatientId(thePatCode);
	fetcher.close ();
System.out.println ("items4sec: after fetcher.close()");
	
	FormRender fr = new FormRender (thePatId, Integer.decode(secId), secOrder, rs, null);
	fr.setFormRenderUtil(fru);
	fr.setTypesCache(cache);
	fr.setNewestItems(newReps);
	
	if (session.getAttribute ("preview") != null)
		fr.setPreview (true);

// System.out.println("items4sec: just be4 formrender.renderpage()");	
	String htmlOut = (String)fr.renderPage ();
	out.println (htmlOut);

/*		
	for (AbstractItem ai : itemsSec) {
		render.clearHtmlStr();
		render.html4Item (hibSes, ai, Integer.decode(patId), intrCtrl);
out.println (render.getHtmlStr());		
	} // EO rendering core loop
*/		
	
} // else (this is a "normal" section)



// Integer currentSec = (Integer)session.getAttribute ("currentSec");
// currentSec = (currentSec == null)? 1: currentSec;
Integer currentSec;
List<Integer> idSecs = null;
if (finish == null) {
	idSecs = (List<Integer>)session.getAttribute ("sectionIds");
	currentSec = idSecs.indexOf(Integer.decode(secId));

	session.setAttribute ("currentSec", currentSec);
}
else {
	session.setAttribute ("currentSec", 0);
	currentSec = 0;
}

out.println(itrtd);
out.println("<br>");


// buttons
String country = (String)session.getAttribute("primaryGrpName"), btnSave, btnCont;
if (country.equalsIgnoreCase("SPAIN")) {
	btnSave = " Guardar ";
	btnCont = " Continuar ";
}
else {
	btnSave = " Save ";
	btnCont = " Continue ";
}

out.println("<input type=\"hidden\" name=\"currentsec\" id=\"currentsec\" ");
out.println("value=\"" + currentSec +"\"/>");
if (!coordinatorRole || !normalpage) {
	
	if (idSecs == null)
		idSecs = (List<Integer>)session.getAttribute ("sectionIds");
		
	boolean endInterview = idSecs.size()-1 == currentSec;
	String continueBtnEnd = "intrvFormCtrl.finish(this.form,"+currentSec+")",
		continueBtnCont = "intrvFormCtrl.send (this.form, 0, true)";
	
	String onClickCont = endInterview? continueBtnEnd: continueBtnCont;
	
	out.println("<input type=\"button\" name=\"btnSend\" value=\""+btnCont+"\" "+
							btnDisabled +
							"onclick=\""+onClickCont+"\"/>&nbsp;&nbsp;");
	out.println("<input type=\"button\" name=\"btnEnd\" value=\""+btnSave+"\" "+
							btnDisabled +
							"onclick=\"intrvFormCtrl.finish(this.form,"+currentSec+")\"/>");
}

// remove this piece of code, as the coordinators does not have rights to 
// do anything. If finish button is enabled, they can perform a whole intervie
// So, will be disabled
if (normalpage && coordinatorRole) {
	out.println("<input type=\"button\" name=\"btnEnd\" value=\"Finish\" "+
				btnDisabled +
				"onclick=\"intrvFormCtrl.finish();\"/>");
}
//
out.println(etrtd);
out.println("</table>");
out.println("</form>");

/*
System.out.println("items4sec before finish: hibSes.isOpen? "+hibSes.isOpen());
if (hibSes != null && hibSes.isOpen())
	hibSes.close();
*/
%>
