<!-- 
	detailsec.jsp?op=det&t=sec&frmid=id 
	show details for a section, including its contained items, being
	able to delete them from this page. This is similar as mngsec, which displays
	the sections for the an interview based on interview id.
	09.06 containers and containees highlighted
-->

<%@page language="java" contentType="text/html;charset=UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@page import="org.hibernate.Session, java.util.Collection, 
								java.util.Iterator, java.util.ArrayList, 
								java.util.Enumeration, java.util.List,
								org.json.simple.*"  %>
								
<%@page import="org.cnio.appform.entity.*, 
								org.cnio.appform.util.HibernateUtil,
								org.cnio.appform.util.HibController,
								org.cnio.appform.util.AppUserCtrl" %>
																
<%
// 	Session hibSes = HibernateUtil.getSessionFactory().openSession();
	List<AbstractItem> itemsSec = null;

	pageContext.setAttribute("section", null);
	pageContext.setAttribute("spid", null);
// if frmid and spid are present, then this is the result of an update/save of
// an item
/*
	String frmId = request.getParameter ("frmid"), 
				 spid = request.getParameter ("spid");
*/
	if (spid != null) {
		Section sec = (Section)hibSes.get(Section.class, Integer.decode(spid));
		itemsSec = HibernateUtil.getItems4Section (hibSes, Integer.decode(spid));
		pageContext.setAttribute("section", sec);
		pageContext.setAttribute("spid", Integer.decode(spid));
	}
	else {
		Section sec = (Section)hibSes.get(Section.class, Integer.decode(frmId));
		itemsSec = HibernateUtil.getItems4Section (hibSes, Integer.decode(frmId));
		pageContext.setAttribute("section", sec);
		pageContext.setAttribute("spid", Integer.decode(frmId));
	}
	
	pageContext.setAttribute("items", itemsSec);
	
//	String roles = (String)session.getAttribute("roles");
out.print("<!-- roles: " + roles + " -->");
		String btnDis = "disabled=\"disabled\"";
		pageContext.setAttribute("btnDis", "");
		if ((roles.indexOf("editor") == -1) && (roles.indexOf("admin") == -1)) {
/*		if (roles.indexOf("interviewer") != -1 || roles.indexOf("guest") != -1 ||
				roles.indexOf("curator") != -1 || roles.indexOf("datamanager") != -1) {*/
			pageContext.setAttribute ("btnDis", btnDis);
		}

		pageContext.setAttribute ("btnDisAdm", "");
		if (roles.indexOf("admin") != -1)
			pageContext.setAttribute("btnDisAdm", btnDis);
	
//	hibSes.close();
%>


<!-- **************** START CONTENT AREA (REGION b)**************** -->		 
<div id='regionAdmB'>

<h3>Section Details</h3>
Name: <b>${section.name}</b><br/>
Description: <b>${section.description}</b><br/>
Elements contained:
<form id="formListItem" name="formListItem">
<table cellpadding="5" cellspacing="1" border="1" xwidth="90%">
<input type="hidden" name="t" value="ele"/>
<input type="hidden" name="frmid" value=""/>
<input type="hidden" name="op" value=""/>
	
	<tr>
	<td rowspan="3" valign="top">
	Choose one...
	<table border="0">
		<tr>
			<td rowspan="3">
			<select id="frmListItems" name="frmListItems" size="10" style="width:400px" multiple="multiple">
				<c:if test="${not empty items}">
					<c:forEach items="${items}" var="anItem">
						<c:set var="theCls" value="" />
						<c:if test="${not empty anItem.containees}">
						 	<c:set var="theCls" value="class=\"containerHigh\"" />
						</c:if>
						<c:if test="${not empty anItem.container}">
						 	<c:set var="theCls" value="class=\"containeeHigh\"" />
						</c:if>
						
						<c:set var="theStyle" value="" />
						<c:catch var="err">
							<c:set var="mandatory" value="${anItem.mandatory}" />
						</c:catch>
						<c:if test="${empty err && mandatory eq 1}">
							<c:set var="theStyle" value="style=\"color:blue\" " />
						</c:if>
							<option value="${anItem.id}" 
								ondblclick="listCtrl.goUpdItem(this.form, 'ele', ${section.id});"
								onmouseover="Tip ('${fn:trim(anItem.content)}');"
						 		onmouseout="UnTip();" ${theStyle}
										${theCls}>${fn:trim(anItem.content)}
							</option>
					</c:forEach>
				</c:if>
			</select>
			</td>
			<td>
				<input type="button" name="btnUp" id="btnUp" value="  Up  "
					onclick="listCtrl.moveUp(this.form.frmListItems);" ${btnDis}/>
			</td>
		</tr>
		
		<tr><td>
			<input type="button" name="btnDown" id="btnDown" value=" Down "
				onclick="listCtrl.moveDown(this.form.frmListItems);" ${btnDis}/>
		</td></tr>
		<tr><td>
			<input type="button" name="btnReord" id="btnReord" value=" Re-sort "
				onclick="listCtrl.onRearrange(this.form.frmListItems, 'ele');" ${btnDis}/>
		</td></tr>
	</table>
	
	</td>
	<td align="left">
		<input type="button" name="btnNew" value=" New " 
					onclick="listCtrl.goNewItem(this.form,  'ele', ${section.id});" ${btnDis}/>
	</td>
	</tr>
	
	<tr><td align="left">
		<input type="button" name="btnUpd" value=" Modify "
					onclick="listCtrl.goUpdItem(this.form, 'ele', ${section.id});" ${btnDis}/>
	</td></tr>
	<tr><td align="left">
		<input type="button" name="btnDel" value = " Delete "
					onclick="listCtrl.goDelItem(this.form, 'ele');" ${btnDis}/>
	</td></tr>
</table>
</form>

</div> <!-- regionB -->
<!-- ****************** END CONTENT AREA (REGION B) ***************** -->