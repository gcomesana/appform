<?xml version="1.0" encoding="ISO-8859-1" ?>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@page import="org.hibernate.Session, java.util.Collection, 
								java.util.Iterator, java.util.ArrayList, 
								java.util.Enumeration"  %>
								
<%@page import="org.cnio.appform.entity.AbstractItem, 
								org.cnio.appform.entity.Section, 
								org.cnio.appform.util.HibernateUtil,
								org.cnio.appform.util.HibController" %>
								
<%
	Session hibSes = HibernateUtil.getSessionFactory().openSession();
	Collection<Section> sectionsCol; 
	Collection<AbstractItem> itemsSec;
	
	String secParam = request.getParameter("selSections");
	
	if (secParam != null) {
out.write ("<!-- merdinha selSections: "+Integer.decode(secParam)+" -->");	 
		Section secAux = (Section)hibSes.get(Section.class, 
																					Integer.decode(secParam));
		itemsSec = HibernateUtil.getItems4Section(hibSes, secAux);
out.write("num of items for "+secAux.getName()+": "+itemsSec.size());		
		pageContext.setAttribute ("items", itemsSec);
	}

	sectionsCol = HibController.SectionCtrl.getSectionByName(hibSes, "");
	pageContext.setAttribute("sections", sectionsCol);
%>
  
<!--   
items:

<c:if test="${not empty sections}">
	<c:forEach items="${sections}" var="anItem">
		${anItem.id},${anItem.name}
	</c:forEach>
</c:if>
-->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
<title>Sections properties</title>
<script type="text/javascript" src="/miniappform/js/controller.js"></script>
</head>
<body>
<p>
	Select a section from the list:<br/>
	<table width="820" cellpadding="3" cellspacing="3" border="1">
	<tr>
		<td>
		<form name="formSections" id="formSections" action="" method="get">
		<select id="selSections" name="selSections" title="Sections" size="1" 
						onchange="SectionsCtrl.getSection(this.form, this);">
			<option value="-1" selected="selected">Choose section</option>
			<c:if test="${not empty sections}">
				<c:forEach items="${sections}" var="aSec">
					<option value="${aSec.id}">${aSec.name}</option>
				</c:forEach>
			</c:if>
		</select>&nbsp;&nbsp;
		<input id="btnNewSec" name="btnNewSec" value=" New " type="button" 
						onclick=""/>
		</form>
		</td>
	</tr>
	</table>
</p>
<p>
Select a question from the list (you have to select a section first):<br/>
<table width="820" cellpadding="3" cellspacing="3" border="1" >
<tr>
	<td>Select one item to edit:<br/>
	<form name="formItemList" id="formItemList" action="" method="get">
	<select id="selSecItems" name="selSecItems" size="10" 
					ondblclick="ItemsCtrl.editItem(this.form);">
		<c:if test="${not empty items}">
			<c:forEach items="${items}" var="anItem">
				<option value="${anItem.id}" title="${anItem.content}">
				${fn:substring(anItem.content,0,10)}</option>
			</c:forEach>
		</c:if>
		<!-- 
		<option value="1">Test item 1</option>
		<option value="2">Test item 2</option>
		-->
	</select>
	</form>
	</td>
</tr>
</table>
</p>
</body>
</html>