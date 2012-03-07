<?xml version="1.0" encoding="UTF-8" ?>
<%@ page language="java" contentType="text/html;charset=UTF-8"
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
								org.cnio.appform.entity.AppGroup,
								org.cnio.appform.util.HibernateUtil, 
								org.cnio.appform.util.HibController,
								org.cnio.appform.util.AppUserCtrl, org.cnio.appform.util.LogFile" %>
								
<%
	Integer usrid = (Integer)session.getAttribute("usrid");
	Session hibSes = HibernateUtil.getSessionFactory().openSession();
	
	AppUser usr = (AppUser)hibSes.get(AppUser.class, usrid);
	AppGroup secGrp = (new AppUserCtrl (hibSes)).getSecondaryActiveGroup(usr);
	if (secGrp != null)
		pageContext.setAttribute("grpName", secGrp.getName());
	
	hibSes.close();
	
	

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

<script type="text/javascript" src="../../js/yahoo/yahoo-dom-event.js" charset="UTF-8"></script>
	<script type="text/javascript" src="../../js/yahoo/connection-debug.js" charset="UTF-8"></script>
	<script type="text/javascript" src="../../js/yahoo/json-debug.js" charset="UTF-8"></script>
	<script type="text/javascript" src="../../js/overlay.js" charset="UTF-8"></script>
	<script type="text/javascript" src="../../js/yahoo/ajaxreq.js" charset="UTF-8"></script>
	
	<script type="text/javascript" src="../../js/jquery/jquery-1.3.js" charset="UTF-8"></script>

<!-- custom javascript files -->	 	 
	<script type="text/javascript" src="../../js/core.js" charset="UTF-8"></script>
	
	<script type="text/javascript" src="../../js/intrvctrl/mycodes.js" charset="UTF-8"></script>
<title>Patient codes for group</title>
<style type="text/css">
<!--
#containerDiv {
	font-family: Arial, Helvetica, sans-serif;
	background-color: #EDDFDE;
	position: absolute;
	width: 280px;
	max-height: 300px;
	/*
	height: 480px;
	width: 280px;
	max-height: 300px;
	*/
}

#containerTit {
	height: 20px;
	background-color: #CAD9EC;
	top: 0px;
	margin: 5px 5px 10px 5px;
	padding: 0px 5px 15px 5px;
	font-size: 16px;
	background-color: #CAD9EC;
	border: 1px solid black;
}

#containerList {
	background-color: #CAD9EC;
	padding: 15px 5px 15px 5px;
	overflow:auto;
	padding-left: 10px;
	padding-top: 5px;
	margin: 0px 5px 10px 5px;
	border: 1px solid black;
	height: 200px;
}

#footer {
	background-color: #CAD9EC; 
	text-align: right; 
	padding-right: 20px;
	padding-top: 2px;
	padding-bottom: 2px;
	border: 1px solid black;
	margin: 0px 5px 10px 5px;
/*	vertical-align: middle; */
}

a {
	text-decoration: none;
}

-->
</style>
</head>

<body style="background-color: #EDDFDE">
<div id="containerDiv">
  <div id="containerTit">Codes for group "${grpName}"</div>
  <div id="containerList">
	<span id="totalMsg"></span>
      <ul id="codesUl">
      <!-- 
        <li>032032</li>
        <li>032032</li>
        <li>032032</li>
        <li>032032</li>
        <li>032032</li>
        <li>032032</li>
        <li>032032</li>
        <li>032032</li>
      -->
      </ul>
  </div>
  <div id="footer" style="">
  <a href="javascript:this.window.close();">Close</a>
  </div>
</div>

<div id="overlay">
     <div>
          <p>Processing...</p>
			<p><img src="../../img/ajax-loader-trans.gif" alt="Processing..." /></p>

     </div>
</div>
</body>
</html>
