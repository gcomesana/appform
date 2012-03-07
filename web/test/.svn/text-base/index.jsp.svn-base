<%-- <?xml version="1.0" encoding="UTF-8" ?> --%>
<%@ page language="java" contentType="text/html;charset=UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@page import="org.hibernate.Session, org.hibernate.HibernateException,
								org.hibernate.Transaction, org.hibernate.SessionFactory, java.util.Collection, 
								java.util.Iterator, java.util.ArrayList, 
								java.util.Enumeration, java.util.List"  %>
								
<%@page import="org.cnio.appform.entity.*, org.cnio.appform.util.LogFile,
								org.cnio.appform.util.HibernateUtil,
								org.cnio.appform.util.HibController,
								org.cnio.appform.util.AppUserCtrl" %>
								
<%
/*
	SessionFactory sf = HibernateUtil.getSessionFactory();
	Session hibSes = sf.openSession();

	AppUserCtrl userCtrl = new AppUserCtrl (hibSes);
	List<AppUser> l = userCtrl.getOnlyUsers();
	
	pageContext.setAttribute("users", l);
*/
%>    
   

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>JQuery Dialog test</title>

<link type="text/css" href="../css/theme/ui.theme.css" rel="stylesheet" />

<script type="text/javascript" src="../js/yahoo/yahoo-dom-event.js"></script>
<script type="text/javascript" src="../js/yahoo/connection-debug.js"></script>
<script type="text/javascript" src="../js/yahoo/json-debug.js"></script>
<script type="text/javascript" src="../js/yahoo/ajaxreq.js"></script>

<script type="text/javascript" src="../js/jquery/jquery-1.3.js"></script>
<script type="text/javascript" src="../js/jquery/ui/1.5/ui.core.js"></script>
<script type="text/javascript" src="../js/jquery/ui/1.5/ui.draggable.js"></script>
<script type="text/javascript" src="../js/jquery/ui/1.5/ui.resizable.js"></script>
<script type="text/javascript" src="../js/jquery/ui/1.5/ui.dialog.js"></script>

<!-- custom javascript files -->
<script type="text/javascript" src="../js/core.js"></script>
<script type="text/javascript" src="../js/ajaxresponses.js"></script>
<script type="text/javascript" src="../js/jquery/jquery.form.js"></script>
<script type="text/javascript" src="../js/yahoo/json-debug.js"></script>
<script type="text/javascript" src="dlgtest.js"></script>
</head>
<body onload="onReady();" onreadystatechange="onReady();">
super cagallón!!!!!
<input type="button" name="noname" id="btn" value="the button" onclick="alert('i am a button');" />
<div id="formDlg" name="formDlg">
	<form id="testform" name="testform"> 
		<input type="hidden" name="usrid" id="usrid" value="101" />
		<input type="hidden" name="grpid" id="grpid" value="4" />
	  <div> 
	    <label for="city">City</label> 
	    <input type="text" id="city" name="city" size="20" /> 
	  </div>
	   
	  <div> 
	    <label for="state">State</label> 
	    <input type="text" id="state" name="state" size="5" value="MI" /> 
	  </div>
<!-- 
	  <div> 
	    <label for="comment" style="vertical-align:top;">Comments</label> 
	    <textarea id="comment" name="comment" rows="8" cols="30"> 
	    </textarea> 
	  </div>
-->	  
	  <div> 
	    <label for="sacks">Villages sacked</label> 
	    <select name="villages" id="villages"> 
	    	<option value="-1" selected="selected">Choose...</option>
	      <option value="4">none</option> 
	      <option value="5">1-5</option> 
	      <option value="4">6-10</option> 
	      <option value="5">11-20</option> 
	      <option value="5">21-50</option> 
	      <option value="4">51-100</option> 
	      <option value="5">over 100</option> 
	    </select> 
	  </div>
	  <div> 
	    <span class="multi-label">Viking gear</span><br> 
	    <input type="checkbox" name="gear[helmet]" value="yes"  
	                 id="helmet" checked="checked" />
	          <label for="helmet">horned helmet</label> 
	    <input type="checkbox" name="gear[longboat]" value="yes"  
	                id="longboat" /><label for="pillage">longboat</label> 
	    <input type="checkbox" name="gear[goat]" value="yes" id="goat"  
	              checked="checked"/><label for="goat">magic goat</label> 
	  </div> 
	  <!-- 
	  <div> 
	    <input type="button" id="btnSubmit" name="btnSubmit" value="Send" /> 
	    <input type="button" id="more" name="more" value="Cancel" /> 
	  </div>
	  -->
	</form>
</div>

<div id="divMsg">Message</div>
</body>
</html>
<%
// hibSes.close();
%>