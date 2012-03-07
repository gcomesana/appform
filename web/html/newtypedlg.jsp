<%-- <?xml version="1.0" encoding="UTF-8" ?> --%>
<%@page language="java" contentType="text/html;charset=UTF-8" 
			pageEncoding="UTF-8"%>
			
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@page import="org.cnio.appform.util.IntrvController,
	org.cnio.appform.util.HibernateUtil, org.cnio.appform.util.AppUserCtrl, 
	org.hibernate.Session" %>

<%
	String intrvId = request.getParameter("intrvId");
	pageContext.setAttribute("intrvId", intrvId);
	
	Session hibSes = HibernateUtil.getSessionFactory().openSession();
	IntrvController intrvCtrl = new IntrvController (hibSes);
	Boolean isClon = intrvCtrl.isClon(Integer.decode(intrvId));
	pageContext.setAttribute ("isClon", isClon);
	Boolean isAdmin = false, isEditor = false;
	
	String[] roles = ((String)session.getAttribute("roles")).split(",");
	for (String role: roles) {
		if (role.compareToIgnoreCase(AppUserCtrl.ADMIN_ROLE) == 0)
			isAdmin = true;
		
		isEditor = (role.compareToIgnoreCase(AppUserCtrl.EDITOR_ROLE) == 0)? true: false;
		
	}
	
	pageContext.setAttribute("isAdmin", isAdmin);
	pageContext.setAttribute ("isEditor", isEditor);
	pageContext.setAttribute ("isClon", Boolean.FALSE);
%>

<html>
<head>
	<script type="text/javascript" src="../js/yahoo/yahoo-dom-event.js"></script>
	<script type="text/javascript" src="../js/yahoo/connection-debug.js"></script>
	<script type="text/javascript" src="../js/yahoo/json-debug.js"></script>
	<script type="text/javascript" src="../js/overlay.js" charset="UTF-8"></script>
	<script type="text/javascript" src="../js/yahoo/ajaxreq.js"  charset="UTF-8"></script>
	<script type="text/javascript" src="../js/core.js"  charset="UTF-8"></script>
	<script type="text/javascript" src="../js/ajaxresponses.js"  charset="UTF-8"></script>
	<script type="text/javascript" src="../js/newtype.js"></script>
	
	<link rel="stylesheet" type="text/css" href="../css/newtype.css">
	<link rel="stylesheet" type="text/css" href="../css/overlay.css"/>
  
	<title>Manage Types</title>
	
</head>
<body onload="onReady(${intrvId}, ${isClon}, ${isAdmin});">

	<form name="frmNewType" id="frmNewType">
		<input type="hidden" id="intrvId" name="intrvId" value="${intrvId}"/>
		<div class="g1">
			<span>Name: </span><input type="text" id="typename" name="typename" value="">
			<span>Type: </span><select id="typeSelect" name="typeSelect"></select>
			<!-- <c:if test="${isEditor || isAdmin}">
			<input type="button" class="button" name="" onclick="newTypeCtrl.delType();" value="Remove type">
			</c:if> -->
			<c:if test="${isEditor || isAdmin}">
			<input type="button" class="button" name="" onclick="newTypeCtrl.delType();" value="Erase type">
			</c:if>
		</div>
		<div class="g2">
			<span>Label: </span><input type="text" name="typekey" id="typekey">
			<span>Value: </span><input type="text" name="typevalue" id="typevalue">
			<input type="button"  class="buttonarrow" name="" onclick="newTypeCtrl.add();" value=">">
		</div>

		<div class="g3">
			<div id="typelist">
			</div>
			<c:if test="${not isClon || (isAdmin || isEditor)}">
			<input type="button" class="button" name="" onclick="newTypeCtrl.delItem();" value="Remove">
			<input type="button" class="buttonarrow" name="" value="U" onclick="newTypeCtrl.up();">
			<input type="button" class="buttonarrow" name="" value="D" onclick="newTypeCtrl.down();">
			</c:if>
<!-- isClon:${isClon} && isAdmin:${isAdmin} -->
			<c:if test="${isClon && (not isAdmin || isEditor)}">
			<input type="button" disabled="disabled" class="button" name="" onclick="newTypeCtrl.delItem();" value="Remove">
			<input type="button" disabled="disabled" class="buttonarrow" name="" value="U" onclick="newTypeCtrl.up();">
			<input type="button" disabled="disabled" class="buttonarrow" name="" value="D" onclick="newTypeCtrl.down();">
			</c:if>
		</div>
		
		<div id="divMsg"></div>
		
<!-- buttons -->
		<c:if test="${not isClon || (isAdmin || isEditor)}">
		<input type="button"  class="button" name="btnSave" value="save"
			onclick="newTypeCtrl.onSave();">&nbsp;
		</c:if>
		
		<c:if test="${isClon && (isAdmin || isEditor)}">
		<input type="button"  class="button" name="btnUpd" value="update"
			onclick="newTypeCtrl.onSave();">&nbsp;
		</c:if>
		
		<input type="button"  class="button" name="btnClose" value="close"
			onclick="self.close();">
	</form>
	<div id="overlay">
    <div>
    <p>Processing...</p>
		<p><img src="../img/ajax-loader-trans.gif" alt="Processing..." /></p>
   </div>
</div>
</body>
</html>

<%
	hibSes.close();
%>