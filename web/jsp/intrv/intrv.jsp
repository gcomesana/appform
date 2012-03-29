<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
 <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@page import="org.hibernate.Session, org.hibernate.Transaction,
							  org.hibernate.HibernateException, java.util.Collection, 
								java.util.Iterator, java.util.ArrayList, 
								java.util.Enumeration, java.util.List,
								java.net.URLDecoder, java.net.URLEncoder"  %>
								
<%@page import="org.cnio.appform.entity.Interview, org.cnio.appform.entity.AbstractItem,
								org.cnio.appform.entity.Section, org.cnio.appform.entity.AnswerItem,
								org.cnio.appform.entity.Question, org.cnio.appform.entity.Text,
								org.cnio.appform.entity.AppUser, org.cnio.appform.entity.Role,
								org.cnio.appform.entity.AppGroup, org.cnio.appform.entity.Patient,
								org.cnio.appform.entity.AppDBLogger,
								org.cnio.appform.util.HibernateUtil, org.cnio.appform.util.IntrvFormCtrl,
								org.cnio.appform.util.HibController,
								org.cnio.appform.util.AppUserCtrl, org.cnio.appform.util.LogFile,
								org.cnio.appform.audit.ActionsLogger" %>
								
<%   
///////////////////////////////////////////////////////////////////
// here there could be the chance to initialize the SECTIONS LIST
//	String intrvId = request.getParameter("intrv"), intrvName="";
	String rtParam = request.getParameter("rt"), intrvName;
//				patcode = request.getParameter("patcode");
	int timeout = session.getMaxInactiveInterval();
	
	Integer intrvId = (Integer)session.getAttribute("intrvId");
	String intrvParam = request.getParameter("intrv");

	intrvId = (intrvId == null)? Integer.decode(intrvParam): intrvId;
	String onload = "onReady("+intrvId+",";
	
	session.setAttribute ("intrvId", intrvId); // added by 03.02
  pageContext.setAttribute ("intrvId", intrvId);

  Session hibSes = HibernateUtil.getSessionFactory().openSession();
  
// interview initialization  
	Interview intrv = (Interview)hibSes.get(Interview.class, intrvId);
	intrvName = intrv.getName();
	pageContext.setAttribute ("intrvName", intrv.getName());
	pageContext.setAttribute("sampleIntrv", intrv.getIsSampleIntrv());
	
	List<Section> lSecs = 
			HibController.SectionCtrl.getSectionsFromIntrv(hibSes, intrv);
	List<Integer> idSecs = new ArrayList<Integer>();
	for (Section aSec: lSecs) {
		idSecs.add(aSec.getId());
	}
	session.setAttribute ("sectionIds", idSecs);
	
	
///////////////////////////////////////////////////////////////////
// PREVIEW STUFF
	Integer secId, preview = 0, realtime;
	pageContext.setAttribute("mypreview", 0);
	String sim = request.getParameter("sim");
	if (sim != null && sim.equalsIgnoreCase("1")) {
		session.setAttribute ("preview", 1);
		pageContext.setAttribute("mypreview", 1);
		preview = 1;
	}
	else { // if it is not a preview, set the patid for session
	// patient initialization (patId was previously set on IntrvServlet)
		Integer patId = (Integer)session.getAttribute ("patId");
	  Patient pat = (Patient)hibSes.get(Patient.class, patId);
	  String patcode = pat.getCodpatient();
	  pageContext.setAttribute("patcode", patcode);
	}
	secId = lSecs.get(0).getId();
	onload += secId+",";
	
	
//		pageContext.setAttribute("rt", "1");
	


//////////////////////////////////////////////////////////////////
// PREVIEW/PERFORMANCE auditing stuff
	String msgLog;
	Integer userId = (Integer)session.getAttribute("usrid");
	AppUser appUsr = (AppUser)hibSes.get(AppUser.class, userId);
	ActionsLogger dbLog = new ActionsLogger (hibSes);
	
	if (preview == 1) {
		msgLog = "User '"+appUsr.getUsername()+
								"' does preview for interview '"+intrvName+"'";
		LogFile.info (msgLog);
		dbLog.logItem(session.getId(), "", appUsr.getId(), ActionsLogger.INTERVIEW, 
									intrv.getId(), intrv.getName(), ActionsLogger.QUERY);
		
		pageContext.setAttribute("listDisable", "disabled=disabled");
//		pageContext.setAttribute("mypreview", 1);
	}
/*
	else {
		msgLog = "User '"+appUsr.getUsername()+"' starts interview performance";
		LogFile.info(msgLog);
		dbLog.logItem(session.getId(), "", appUsr.getId(), ActionsLogger.PERFORMANCE, 
									intrv.getId(), intrv.getName(), ActionsLogger.CREATE);
		
//		pageContext.setAttribute("mypreview", 0);
	}
*/
// convert timeout (minutes) in milliseconds for settimeout js function
	onload += preview+","+rtParam+","+timeout*900+");";
	pageContext.setAttribute("onload", onload);

	
	String secGrpName	= (String)session.getAttribute("secondaryGrpName");
	if (secGrpName != null && secGrpName.length() >= 25)
		pageContext.setAttribute("grpname", secGrpName.substring(0, 25));
	else
		pageContext.setAttribute ("grpname", secGrpName);
	
	hibSes.close();
%>

<html>
<head>
  <title>Interview Performance</title>
  <META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8"/>
	<link rel="stylesheet" type="text/css" href="../css/portal_style.css"/> 
	<link rel="stylesheet" type="text/css" href="../../css/portal_style.css"/> 
  
  <link rel="stylesheet" type="text/css" href="../css/overlay.css"/>
  <link rel="stylesheet" type="text/css" href="../../css/overlay.css"/>
 <!--  
  <link rel="stylesheet" type="text/css" href="../css/theme/ui.combobox.css"/>
  <link rel="stylesheet" type="text/css" href="../../css/theme/ui.combobox.css"/>
-->  
  <link href="../img/favicon.ico" rel="shortcut icon" type="image/x-icon" />
  <link href="../../img/favicon.ico" rel="shortcut icon" type="image/x-icon" />
  	
<!-- treeview and yahoo event, dom and connection files -->
	<script type="text/javascript" src="../../js/jquery/jquery-1.3.2.js" charset="UTF-8"></script>
	
	<script type="text/javascript" src="../../js/yahoo/yahoo-dom-event.js" charset="UTF-8"></script>
	<script type="text/javascript" src="../../js/yahoo/connection-debug.js" charset="UTF-8"></script>
	<script type="text/javascript" src="../../js/yahoo/json-debug.js" charset="UTF-8"></script>
	<script type="text/javascript" src="../../js/overlay.js" charset="UTF-8"></script>
	
	<script type="text/javascript" src="../../js/lib/sha.js" charset="UTF-8"></script>
	<script type="text/javascript" src="../../js/yahoo/ajaxreq.js" charset="UTF-8"></script>
	
	<script type="text/javascript" src="../../js/jquery/ui/ui.core.js" charset="UTF-8"></script>
<!--	<script type="text/javascript" src="../../js/jquery/ui/ui.combobox.js" charset="UTF-8"></script> -->

<!-- custom javascript files -->	 	 
	<script type="text/javascript" src="../../js/core.js" charset="UTF-8"></script>
  <script type="text/javascript" src="../../js/intrvctrl/ajaxresp.js" charset="UTF-8"></script>
  <script type="text/javascript" src="../../js/intrvctrl/repelems.js" charset="UTF-8"></script>
	
	<script type="text/javascript" src="../../js/intrvctrl/ctrlforms-prot.js" charset="UTF-8"></script>
	
</head>

<!-- <body onload='onReady(${intrvId},${introId});'> -->
<body onload=${onload} id="body" onreadystatechange="${onload}">
<div id="fitter"></div>

<div id="portal-container">
	<div id="sizer">
		<div id="expander">
			<div id="logoName"></div>
			<table border="0" cellpadding="0" cellspacing="0" id="header-container">
				<tr> 
				<td align="center" valign="top" id="header">
					<c:if test="${isGuest ne 1}">
					<span style="float:left;margin-left:10px;margin-top:10px">
					<a style="color:darkblue" href="javascript:intrvFormCtrl.getPatCodes();">Codes</a>
					</span>
					</c:if>
					<div id='dashboardnav' align="left">
						User: <b>${user}</b><br/>
						Roles: <b><%= session.getAttribute("roles") %></b><br/>
						Primary Group: <b><%= session.getAttribute("primaryGrpName") %></b>
						<c:if test="${mypreview eq 0}">
						<br><span id="grpSpan" class="infotext">
						Hospital or Lab:
						</span>
						<br/><b>${secondaryGrpName}</b>
						</c:if>
<!-- 					<c:if test="${numGroups eq 1}"><b>${secondaryGrpName}</b></c:if>
						<c:if test="${numGroups gt 1}">
							<br/>
							<select name="listLabs" id="listLabs">
								<option value="-1" selected="selected">Choose...</option>
								<c:forEach items="${secGroups}" var="aGroup">
									<option value="${aGroup.id}">
										<!-- ${fn:length(aGroup.name)} -
										<c:if test="${fn:length(aGroup.name) gt 30}">
											${fn:substring(aGroup.name, 0, 30)}...
										</c:if>
										<c:if test="${fn:length(aGroup.name) le 30}">
											${aGroup.name}
										</c:if>
									</option>
								</c:forEach>
							</select>
							-- 
							<script>
								$("#listLabs").combobox();
							</script>
							-
						</c:if>-->
						<br/>
<a href="<%= response.encodeURL("../../logout.jsp") %> " style="text-decoration:none;color:darkblue;font-size=bolder">Logout</a>
					</div>
			
					<div id="navigation">Questionnaire 
					<span style="font-variant:small-caps;font-weight:bold;font-size:16px">
					${intrvName}</span>
					<c:if test="${mypreview eq 0}">
						<c:if test="${sampleIntrv eq 0}">
					(<span style="font-size:11px">Subject code</span> 
						</c:if>
						<c:if test="${sampleIntrv eq 1}">
					(<span style="font-size:11px">Aliquot code</span> 
						</c:if>
					<b>${patcode}</b>)
					</c:if> <%-- eo mypreview eq 0 --%>
					</div>
					<div id="errMsg" onclick="$('div#errMsg').text('');"></div>
				</td>
				</tr>
			</table>
			<div id="content-container">
				<div id='regionB'>
<!-- Here starts the form to collect the interview data -->				
					<div id="form">
					</div>	
<!-- Form end -->					
				</div>
				<div id='regionA'>
				</div>
			</div>
			
		</div> <!-- expander -->
	</div><!-- sizer -->
</div><!-- portal-container -->


<!-- FOOTER AND END OF PAGE -->

<div id="footer-container" class="portal-copyright">
<ul>
<li>
<a class="portal-copyright-adm" href="http://www.inab.org" target="_blank">
Developed at CNIO/INB</a></li>
<li class="last">
<a href="http://www.cnio.es/es/privacidad/index.asp" target="_blank">Política de Privacidad</a> - 
<a href="http://www.cnio.es/ing/privacidad/index.asp" target="_blank">Privacity Policy</a></li>
</ul>
<!-- 
Developed at
<a class="portal-copyright" href="http://www.inab.org">CNIO/INB</a><br/>
-->

</div>

<div id="toolDiv"></div>

<div id="overlay">
     <div>
          <p>Processing...</p>
			<p><img src="../../img/ajax-loader-trans.gif" alt="Processing..." /></p>

     </div>
</div>


</body>
</html>