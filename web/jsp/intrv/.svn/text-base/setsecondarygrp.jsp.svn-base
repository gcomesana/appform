<?xml version="1.0" encoding="ISO-8859-1" ?>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%@page import="org.hibernate.Session, org.hibernate.HibernateException,
								org.cnio.appform.entity.AppGroup, org.cnio.appform.util.AppUserCtrl,
								org.cnio.appform.util.HibernateUtil, org.cnio.appform.entity.AppUser" 
%>
<%@page import="java.util.List, java.util.Iterator, java.net.URLDecoder" %>


<%
//	pageContext.setAttribute("usrId", 101);

//	Integer usrid = (Integer)session.getAttribute("usrid");
//	out.println("<!-- userid: "+usrid+" -->");
	
	String grpType = request.getParameter("typegroup");
	pageContext.setAttribute("grpType", grpType);
	if (grpType.equalsIgnoreCase("pri"))
		pageContext.setAttribute("type", "COUNTRY");
	else
		pageContext.setAttribute("type", "HOSPITAL OR LAB");
/*	
	String myGroups = request.getParameter("groups");
	String[] arrGrps = myGroups.split(",");
	int numGrps = arrGrps.length;
	pageContext.setAttribute("numGroups", numGrps);
*/

// this parameter is checked to see what to do on click Cancel button
	String clickParam = request.getParameter("click");
	clickParam = (clickParam == null)? "0": clickParam;
	pageContext.setAttribute("clicked", clickParam);
%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Group Selection Dialog</title>
<!link type="text/css" href="../css//ui.all.css" rel="stylesheet" />

<link type="text/css" href="../../css/theme/ui.theme.css" rel="stylesheet" />
<link type="text/css" href="../../css/grpdialog.css" rel="stylesheet" />

<script type="text/javascript" src="../../js/yahoo/yahoo-dom-event.js"></script>
<script type="text/javascript" src="../../js/yahoo/connection-debug.js"></script>
<script type="text/javascript" src="../../js/yahoo/json-debug.js"></script>
<script type="text/javascript" src="../../js/yahoo/ajaxreq.js"></script>

<script type="text/javascript" src="../../js/jquery/jquery-1.3.js"></script>
<script type="text/javascript" src="../../js/jquery/ui/1.5/ui.core.js"></script>
<script type="text/javascript" src="../../js/jquery/ui/1.5/ui.draggable.js"></script>
<script type="text/javascript" src="../../js/jquery/ui/1.5/ui.resizable.js"></script>
<script type="text/javascript" src="../../js/jquery/ui/1.5/ui.dialog.js"></script>

<!-- custom javascript files -->
<script type="text/javascript" src="../../js/core.js"></script>
<script type="text/javascript" src="../../js/ajaxresponses.js"></script>
<script type="text/javascript" src="../../js/jquery/jquery.form.js"></script>
<script type="text/javascript" src="../../js/groupdlg.js"></script>

</head>

<body onreadystatechange="onReady ('${grpType}', ${clicked});" 
			onload="onReady('${grpType}',${clicked} );">
<div id="dialog" title="Group activation dialog">

Choose a <b>${type}</b> to use in this session<br>
<div id="slider">
<form id="frmGrpChooser" name="frmGrpChooser"  method="post">

<input type="hidden" name="usrid" id="usrid" value="${usrId}" />
<input type="hidden" name="intrvid" id="intrvid" 
		value="<%= session.getAttribute("intrvId") %>" />
<input type="hidden" name="rt" id="rt" value="${rt}" />
<!-- 
<select name="grpid" id="grpid">
<option value="-1" selected="selected">Choose...</option>
-->
	<%
	// This snippet is just to create a client variable to communicate the groups
	// to javascript snippets
	// groups is like '4:SPAIN,5:GERMANY'
		String grps = request.getParameter("groups");
		Integer usrid = (Integer)session.getAttribute("usrid");
		Integer mainGrpId = (Integer)session.getAttribute("primaryGrpId");
		
		if (grps == null) {
			Session hibSes = HibernateUtil.getSessionFactory().openSession();
			AppUserCtrl usrCtrl = new AppUserCtrl (hibSes);
			AppGroup mainGrp = (AppGroup)hibSes.get(AppGroup.class, mainGrpId);
			AppUser user = (AppUser)hibSes.get(AppUser.class, usrid);
			List<AppGroup> groups = usrCtrl.getSecondaryGroups(user, mainGrp);
			
			grps = ""; 
			for (Iterator<AppGroup> itGrp = groups.iterator(); itGrp.hasNext();) {
				AppGroup grp = itGrp.next();
				grps += grp.getName()+":" + grp.getId().toString()+";";
			}
			grps = grps.substring(0, grps.length()-1);
			hibSes.close();
		}
	
//		String groups = (String)request.getParameter("groups");
//		String groups = param;
		String[] grpBins = grps.split(";");

		for (int i = 0; i < grpBins.length; i++) {
			String[] pair = grpBins[i].split(":");
// System.out.println("setsecondarygrp: "+grps);
			String grpName = URLDecoder.decode(pair[0], "UTF-8");
			out.println("<input type=\"radio\" name=\"grpid\" value=\""+pair[1]+
					"\"> "+grpName+"<br>");
			
		}
	%>
<!/select>

<!-- 
<br><br>
<div> 
  <input type="button" id="btnSubmit" name="btnSubmit" value="Send" /> 
  <input type="button" id="more" name="more" value="Cancel" /> 
</div> 
-->
</form>
</div>

<div id="divMsg" align="center"></div>
</div>

</body>
</html>
