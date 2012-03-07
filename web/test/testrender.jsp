<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
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

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>

<%
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

// Open session, only TypesCache needs a hibernate session to work
// Session hibSes = HibernateUtil.getSessionFactory().openSession();
Session hibSes = sf.openSession();
IntrvFormCtrl intrCtrl = new IntrvFormCtrl(hibSes);

Integer usrId = 101;
System.out.println ("testrender: hibSes.isopen?: "+hibSes.isOpen());
AppUser user = (AppUser)hibSes.get(AppUser.class, usrId);
pageContext.setAttribute ("usrid", usrId);

// GROOVY BASED RENDER INITIALIZATION should be here ///////////////////////////
// * new the ItemsFecher (dbServer, dbName, dbUser) and
// * set the resultSet (ItemsFetcher (intrvId, prjCode, patid, orderSec)
// * new the FormRenderUtil as support for main FormRender
// * new the FormRender (patId, secId, orderSec, resultSet, null)
// * new the TypesCache (intrvId)
// * set the render types cache
// * set the render formRenderUtil
// * set preview or not
	String patId = request.getParameter ("pat");
	Patient myPat = (Patient)hibSes.get(Patient.class, Integer.decode(patId));
	String thePatCode = (session.getAttribute ("preview") != null)? IntrvFormCtrl.NULL_PATIENT:
		myPat.getCodpatient();
	Integer thePatId = myPat.getId();
pageContext.setAttribute ("patid", patId);
	
	String secId = request.getParameter("sec");
	Section sec = (Section)hibSes.get(Section.class, Integer.decode(secId));
	int secOrder = sec.getSectionOrder().intValue();
	
	Integer intrvId = 50;
	Interview intrv = (Interview)hibSes.get(Interview.class, intrvId);
	List<Section> secs = HibController.SectionCtrl.getSectionsFromIntrv(hibSes, intrv);
	if (hibSes.isOpen() == false)
		System.out.println ("testrender: hibSes closed :(");
	
	Integer nextSecId = secs.get(secOrder).getId();
pageContext.setAttribute ("nextSec", nextSecId);

	pageContext.setAttribute ("prevSec", 0);
	if (secOrder > 1) {
		Integer prevSecId = secs.get(secOrder-1).getId();
pageContext.setAttribute("prevSec", prevSecId);
	}
	
System.out.println ("patId: "+patId+", thePatCode: "+thePatCode+", hibSes.open?: "+ hibSes.isOpen());
	TypesCache cache = new TypesCache (hibSes, intrvId, true);	
	
// NO hibernate calls after this point: so we close the session just now	
System.out.println("items4sec before finish: hibSes.isOpen? "+hibSes.isOpen());
	if (hibSes != null && hibSes.isOpen())
		hibSes.close();
	

System.out.println ("dbName: "+dbName+"; dbServer: "+dbServer+":"+HibernateUtil.DB_USERNAME);
	ItemsFetcher fetcher = new ItemsFetcher (dbName, dbServer, HibernateUtil.DB_USERNAME);
	FormRenderUtil fru = new FormRenderUtil ();
	
	List<Object[]> rs = fetcher.getResultSet (intrvId, thePatCode, secOrder);
	thePatId = fetcher.getPatientId(thePatCode);
	fetcher.close ();
System.out.println ("items4sec: after fetcher.close()");
	
	FormRender fr = new FormRender (thePatId, Integer.decode(secId), secOrder, rs, null);
	fr.setFormRenderUtil(fru);
	fr.setTypesCache(cache);
	if (session.getAttribute ("preview") != null)
		fr.setPreview (true);

System.out.println("items4sec: just be4 formrender.renderpage()");	
	String htmlOut = (String)fr.renderPage ();
	out.println (htmlOut);
	/*	
	for (AbstractItem ai : itemsSec) {
		render.clearHtmlStr();
		render.html4Item (hibSes, ai, Integer.decode(patId), intrCtrl);
out.println (render.getHtmlStr());		
	} // EO rendering core loop
	*/	

%>
<br/>
<table width="400px">
<tr><td align="left">
<a href="testrender.jsp?pat=${patid}&sec=${prevSec}">Prev</a>
</td>
<td>
<a href="testrender.jsp?pat=${patid}&sec=${nextSec}">Next</a>
</td>
</tr>
</table>

</body>
</html>