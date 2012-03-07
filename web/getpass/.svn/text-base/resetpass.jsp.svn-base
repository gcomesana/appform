<?xml version="1.0" encoding="ISO-8859-1" ?>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%@page import="org.hibernate.Session, org.hibernate.HibernateException,
org.hibernate.Transaction, org.hibernate.Query,
org.cnio.appform.entity.AppUser,
org.cnio.appform.util.AppUserCtrl, 
org.cnio.appform.util.HibernateUtil,
org.cnio.appform.util.captcha.ImgCaptchaSingleton"
%>

<%
	pageContext.setAttribute("usrId", 101);

	String digest = request.getParameter("digest");
	if (digest == null)
		return;

	String strqry = "from AppUser where passwd=:digest";
System.out.println("resetpass: "+strqry+"; digest: "+digest);

	Session hibSes = HibernateUtil.getSessionFactory().openSession();
	Transaction tx = null;
	Query qry = null;
	try {
		tx = hibSes.beginTransaction();
		qry = hibSes.createQuery(strqry);
		qry.setString("digest", digest);
		
		AppUser user = (AppUser)qry.uniqueResult();
		tx.commit();
		
		if (user != null) {
			pageContext.setAttribute("username", user.getUsername());
		}
		else
			pageContext.setAttribute ("username", "-1");
	}
	catch (HibernateException hibEx) {
		if (tx != null)
			tx.rollback();
		
		hibEx.printStackTrace(System.err);
	}
	
	hibSes.close();
%>


<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Password Reset Dialog</title>
<!link type="text/css" href="../css//ui.all.css" rel="stylesheet" />

<link type="text/css" href="../js/yahoo/container/assets/skins/sam/container.css" 
			rel="stylesheet" />
			
<link type="text/css" href="../css/passwdlg.css" rel="stylesheet" />

<script type="text/javascript" src="js/yahoo/yahoo-dom-event.js"></script>
<script type="text/javascript" src="js/yahoo/connection-debug.js"></script>
<script type="text/javascript" src="js/yahoo/json-debug.js"></script>
<script type="text/javascript" src="js/yahoo/container/container-debug.js"></script>
<script type="text/javascript" src="../js/yahoo/container/container-debug.js"></script>

<script type="text/javascript" src="js/yahoo/ajaxreq.js"></script>

<script type="text/javascript" src="js/jquery/jquery-1.3.js"></script>
<!-- 
<script type="text/javascript" src="js/jquery/ui/1.5/ui.core.js"></script>
<script type="text/javascript" src="js/jquery/ui/1.5/ui.draggable.js"></script>
<script type="text/javascript" src="js/jquery/ui/1.5/ui.resizable.js"></script>
<script type="text/javascript" src="js/jquery/ui/1.5/ui.dialog.js"></script>
-->

<script type="text/javascript" src="js/resetpassyui.js"></script>

</head>

<body xonreadystatechange="onReady ('${username}');" onload="onReady('${username}');"
		class="yui-skin-sam">
		
<div id="dialog" title="Password Recovery Dialog">

<div class="hd" id="divHd">
Write your
registered <b>username</b> and the new <b>password</b> twice
</div>

<div class="bd" id="divBody">
<table id="tablesplit" align="center">
<tr>
<td valign="bottom">
<form id="frmPasswdReset" name="frmPasswdReset" method="post">
<table id="tblGetPasswd">
	<tr>
		<td>Username:</td>
		<td><input type="text" name="frmusername" id="frmusername" /></td>
	</tr>
	<tr>
		<td>New password:</td>
		<td><input type="password" name="frmpass" id="frmpass" 
							onkeyup="passwdCtrl.onKeyUp(this.value);"/></td>
	</tr>
	<tr>
		<td>Repeat new password:</td>
		<td><input type="password" name="frmpassbis" id="frmpassbis" 
							 onkeyup="passwdCtrl.onKeyUp(this.value);"/></td>
	</tr>
	<tr>
		<td colspan="3" height="15px"></td>
	</tr>
	<!-- captcha layout -->
	<tr>
		<td rowspan="2"><img id="captchaImg" src="/appform/jcaptcha"
			border="1" /></td>
		<td valign="bottom"><a href="#" onclick="passwdCtrl.refresh();">Refresh
		image</a></td>
	</tr>
	<tr>
		<td valign="bottom"><input type="text" id="j_captcha_response"
			name="j_captcha_response" value="" /></td>
	</tr>
</table>
</form>
<br>
</td>
<td width="10"></td>
<td valign="bottom" style="padding-bottom: 23px;border-left:1px solid darkgray;padding-left:5px;">
Restrictions:<br>
<input type="checkbox" name="eightchars" id="eightchars" disabled="disabled" />
<span id="passlength" class="constraints-font">Password has to be 8 characters long</span>
<br>
<input type="checkbox" name="lcasechars" id="lcasechars" disabled="disabled"/>
<span id="lcasepass" class="constraints-font">Password has to contain lower case characters</span>
<br>
<input type="checkbox" name="ucasechars" id="ucasechars" disabled="disabled" />
<span id="ucasepass" class="constraints-font">Password has to contain upper case characters</span>
<br>
<input type="checkbox" name="numberchars" id="numberchars" disabled="disabled" />
<span id="numberpass" class="constraints-font">Password has to contain at least a number</span>
<br><br>
<span id="titlebar" class="constraints-font">Password strength-meter:</span><br>
<span id="passwordStrength" class="strength0"></span>
<br>
</td>
</tr>
</table>

<div id="divMsg" align="center" class="spanfont"></div>

</div> <!-- id=divBocy -->
</div> <!-- id=dialog -->


</body>
</html>
