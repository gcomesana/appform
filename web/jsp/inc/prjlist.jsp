<!-- prjlist.jsp -->
<%-- This snippet list the projects in the system --%>
<%@ page language="java" contentType="text/html;charset=UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@page import="org.hibernate.Session, java.util.Collection, 
								java.util.Iterator, java.util.ArrayList, java.util.List,
								java.util.Enumeration"  %>
								
<%@page import="org.cnio.appform.entity.AbstractItem,
								org.cnio.appform.entity.Text, org.cnio.appform.entity.Question, 
								org.cnio.appform.entity.Project, org.cnio.appform.entity.Section,
								org.cnio.appform.entity.Interview, 
								org.cnio.appform.entity.AppUser,
								org.cnio.appform.util.HibernateUtil,
								org.cnio.appform.util.AppUserCtrl, org.cnio.appform.audit.ActionsLogger,
								org.cnio.appform.util.IntrvController" %>	
								
<%
// 	Session hibSes = HibernateUtil.getSessionFactory().openSession();
	Collection<Project> projsCol; 
	Collection<AbstractItem> itemsSec;
//	String roles = (String)session.getAttribute("roles");
	
//	final int action = AppUserCtrl.ACTION_R;
	action = AppUserCtrl.ACTION_R;
//	boolean granted = AppUserCtrl.projectPermissions(roles, AppUserCtrl.ACTION_R);
	
	if (!granted) {
//		hibSes.close();
		return;
	}
// userId will be used to use as index for the project's owner	
//	String userId = request.getParameter("userId");
	Integer userId = (Integer)session.getAttribute("usrid");
	AppUser usr = (AppUser)hibSes.get(AppUser.class, userId);
//	AppUserCtrl usrCtrl = new AppUserCtrl (hibSes);
	
//	projsCol = HibernateUtil.getProjectByName(hibSes, "", -1);
	projsCol = usrCtrl.getProjects(usr);
	pageContext.setAttribute("projects", projsCol);
	
//	out.print("roles: " + roles);
	String btnDis = "";
	if (roles.indexOf("admin") == -1) {
		pageContext.setAttribute ("btnDis", "disabled");
	}
	
	hibSes.close();
%>


<!-- **************** START CONTENT AREA (REGION b)**************** -->		 
           <div id='regionAdmB'>

<h3>Project List</h3>
<form id="formSecs" name="formSecs" method="post">
<table cellpadding="2" cellspacing="1" border="1" width="400">
	
	<tr>
	<td rowspan="3" valign="top">
	Choose one...
	<table border="0">
		<tr><td rowspan="3">
			<select id="frmListPrjs" name="frmListPrjs" size="5" style="width:200px">
				<c:if test="${not empty projects}">
					<c:forEach items="${projects}" var="aPrj">
						<option value="${aPrj.id}" 
										ondblclick="prjFormCtrl.goItemProps(${aPrj.id},'prj');"
										onmouseover="Tip ('${aPrj.name}');"
						 				onmouseout="UnTip();">
						${aPrj.name}
						</option>
					</c:forEach>
				</c:if>
			</select><a href="javascript:prjFormCtrl.goItem('frmListPrjs','prj');"
									style="text-decoration:none;color:darkblue;">
								Edit selected</a>
			</td>
			<td><!-- 
				<input type="button" name="btnUp" id="btnUp" value="  Up  "
							onclick="PrjFormCtrl.moveUp(this.form.frmListPrjs);"/> -->
			</td>
		</tr>
		
		<tr><td><!-- 
			<input type="button" name="btnDown" id="btnDown" value=" Down "
					onclick="PrjFormCtrl.moveDown(this.form.frmListPrjs);"/>-->
		</td></tr>
		<tr><td><!-- 
			<input type="button" name="btnReord" id="btnReord" value=" Re-sort "
					onclick="PrjFormCtrl.onRearrange(this.form.frmListPrjs);"/> -->
		</td></tr>
	</table>
	
	</td>
	<td align="left">
		<input type="button" name="btnNew" value=" New " ${btnDis}
					onclick="prjFormCtrl.listProjects(this.form, 'NEW');"/>
	</td>
	</tr>
	
	<tr><td align="left">
		<input type="button" name="btnUpd" value=" Modify " ${btnDis}
					onclick="prjFormCtrl.listProjects(this.form, 'UPD');"/>
	</td></tr>
	<tr><td align="left">
		<input type="button" name="btnDel" value = " Delete " ${btnDis}
					onclick="prjFormCtrl.listProjects(this.form, 'DEL');"/>
	</td></tr>
</table>
</form>
					 </div> <!-- regionB -->
<!-- ****************** END CONTENT AREA (REGION B) ***************** -->