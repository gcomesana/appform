
<%@page language="java" contentType="text/html;charset=UTF-8"%>

<%@ 
	page
	import="org.hibernate.Session,org.hibernate.Transaction,org.hibernate.HibernateException"%>
<%@ 
	page
	import="org.cnio.appform.util.HibernateUtil,org.cnio.appform.util.AppUserCtrl,org.cnio.appform.entity.AppuserRole,org.cnio.appform.entity.Role,org.cnio.appform.entity.AppUser,org.cnio.appform.entity.AppGroup,org.cnio.appform.entity.GroupType,org.cnio.appform.entity.Project"%>
<%@ 
	page import="java.util.List"%>

<%
	// Checking the users permissions
	String user = request.getUserPrincipal().getName();
	List<Role> roleList = null;
	List<Role> roles = null;
	AppUserCtrl userCtrl = null;
	AppUser appUsr = null;

	if (user == null || user.length() == 0)
		response.sendRedirect("../logout.jsp?adm=1");

	else {
		Session hibSes = HibernateUtil.getSessionFactory()
				.openSession();

		userCtrl = new AppUserCtrl(hibSes);
		appUsr = userCtrl.getUser(user);

		roles = userCtrl.getRoleFromUser(appUsr);

		String strRoles = "";
		for (Role r : roles) {
			strRoles += r.getName() + ",";
		}
		if (strRoles.length() > 0)
			strRoles = strRoles.substring(0, strRoles.length() - 1);

		// checking if the user is allowed to act as admin
		if (strRoles.length() == 0 || strRoles.indexOf("admin") == -1) {
			//	session.invalidate();
			response.sendRedirect("../logout.jsp?adm=1");
			/*
%>
<jsp:forward page="../logout.jsp?adm=1" />
<%
	*/
		} else {
			session.setAttribute("usrid", appUsr.getId());
			session.setAttribute("user", user);
			session.setAttribute("roles", strRoles);

			roleList = userCtrl.getAllRoles();
		}
	}
%>

<html>
<head>
<title>Admin Form Tool</title>

<link rel="stylesheet" type="text/css" href="../css/portal_style.css"
	id="portalCss" />
<link rel="stylesheet" type="text/css" href="../css/admintool.css"
	id="adminCss" />
<link rel="stylesheet" type="text/css" href="../css/overlay.css" />

<link rel="shortcut icon" href="../img/favicon.ico" />
<script type="text/javascript" language="javascript" src="mixed2b.js"></script>

<!-- yahoo event, dom and connection files -->
<script type="text/javascript" src="../js/yahoo/yahoo-dom-event.js"></script>
<script type="text/javascript" src="../js/yahoo/connection-debug.js"></script>
<script type="text/javascript" src="../js/yahoo/json-debug.js"></script>

<script type="text/javascript" src="../js/jquery/jquery-1.2.6.js"></script>

<script type="text/javascript" src="../js/yahoo/ajaxreq.js"></script>
<script type="text/javascript" src="../js/overlay.js"></script>
<!-- Admin tool scripts -->
<script type="text/javascript" src="adminType.js"></script>
<script type="text/javascript" src="adminutil.js"></script>

</head>

<body xonload="onReady();" id="body">
<div id="portal-container">
<div id="sizer">
<div id="expander">
<table border="0" cellpadding="0" cellspacing="0"
	id="header-container-adm">
	<tr valign="bottom">
		<td align="center" valign="middle" id="header">

		<div id='dashboardnavAdm' align="left">User: <b><%=session.getAttribute("user")%></b><br />
		Roles: <b><%=session.getAttribute("roles")%></b><br />
		<a href="<%= response.encodeURL("../logout.jsp?adm=1") %> "
			style="text-decoration: none; color: darkblue;">Logout</a> <!-- p:region regionName='dashboardnav' regionID='dashboardnav'/> -
							&nbsp;&nbsp;
							<a href="http://localhost:8080/portal/auth/dashboard">Dashboard</a>
							&nbsp;&nbsp;|
							&nbsp;&nbsp;<a href="http://localhost:8080/portal/auth/portal/admin">Admin</a>&nbsp;&nbsp;| -
							<a href="http://localhost:8080/portal/signout">Logout</a>--></div>

		<span
			style="font-family: Arial, Helvetica, sans-serif; font-size: 24px; font-weight: bold;">Application
		Form Tool Administration</span></td>
	</tr>
</table>



<!-- HERE STARTS THE CENTRAL PART, BOTH THE MENU AND CONTENT AREAS -->
<div id="content-container"><!-- ****************** START MENU (CENTER) AREA (REGION D) ***************** -->
<div id='regionD'>
<div id='registerAdminForm'
	style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">
<table border="0" cellspacing="5">
	<input type="hidden" name="frmUsrId" id="frmUsrId" value="" />
	<tr>
		<th align="right" width="10%">Username:</th>
		<td align="left">
		<table border="0">
			<tr>
				<td><input type="text" id="username" class="textInputRegionD">
				</td>
				<td align="right" width="100"><b>First name:</b></td>
				<td><input type="text" id="firstname" name="firstname"
					class="textInputRegionD"></td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<th align="right">Password:</th>
		<td align="left">
		<table border="0">
			<tr>
				<td><input type="password" id="password" name="password"
					class="textInputRegionD"></td>
				<td align="right" width="100"><b>Last name:</b></td>
				<td><input type="text" id="lastname" name="lastname"
					class="textInputRegionD"></td>
			</tr>
		</table>

		</td>
	</tr>
	<tr>
		<th align="right">Password (confirm):</th>
		<td align="left">&nbsp;<input type="password" id="re-password"
			class="textInputRegionD"></td>
	</tr>
	<tr>
		<th align="right">Role:</th>
		<td align="left" style="border: 3px solid darkgray"><!-- table for the role group of components -->
		<table border="0" cellpadding="5" width="100%">
			<tr>
				<td><select class="selectRegionD" id="registered_role"
					multiple="multiple" size="3">
					<%
						if (roleList != null) {
							for (Role role : roleList)
								out.println("<option value='" + role.getId() + "'>" + role.getName()
										+ "</option>");
						}
					%>
				</select></td>
				<td align="center" valign="middle">
				<div class='rightButtonList'
					onClick="moveOptions(document.getElementById('registered_role'), document.getElementById('selected_role'));"></div>
				<div class='leftButtonList'
					onClick="moveOptions(document.getElementById('selected_role'), document.getElementById('registered_role'));"></div>
				</td>
				<td><select class="selectRegionD" id="selected_role"
					name="selected_role" size="5" multiple="multiple"></select></td>
			</tr>
			<tr>
				<td colspan="3" height="2px"></td>
			</tr>
			<tr bgcolor="lightgray">
				<td>

				<table>
					<tr>
						<td><input type="text" id="frmRoleName" name="frmRoleName"
							class="textInputRegionD" value="New role name"
							onclick="this.value=''" /></td>
					</tr>
				</table>

				</td>
				<td align="center" valign="top" width="80"><input type="button"
					id="btnNewGrp" name="btnNewRole" onclick="admCtrl.newRole();"
					value="New" /></td>
				<td></td>
				<!-- 
				<td valign="top"><input type="button" id="btnRmvRole"
					name="btnRmvRole" onclick="javascript:alert('rmv role');"
					value="Remove" /></td>
-->
			</tr>
		</table>

		</td>
	</tr>

	<tr>
		<td colspan="3" height="25px"></td>
	</tr>

	<tr style="border: 1px solid darkgray;">
		<th align="right">Group:</th>
		<td align="left" style="border: 3px solid darkgray">
		<table border="0" cellpadding="5" width="100%">
			<tr>
				<td><select class="selectRegionD" id="registered_group"
					size="5" multiple="multiple">
					<%
						List<AppGroup> groupList = userCtrl.getAllGroups();
						for (AppGroup group : groupList) {
							out.println("<option value='" + group.getId() + "'>" + group.getName()
									+ "</option>");
						}
					%>
				</select></td>

				<td align="center" valign="middle">
				<div class='rightButtonList'
					onClick="moveOptions(document.getElementById('registered_group'), document.getElementById('selected_group'));"></div>
				<div class='leftButtonList'
					onClick="moveOptions(document.getElementById('selected_group'), document.getElementById('registered_group'));"></div>
				</td>
				<td><select class="selectRegionD" id="selected_group"
					name="selected_group" size="5" multiple="multiple"></select></td>
			</tr>
			<tr>
				<td colspan="3" height="2px"></td>
			</tr>
			<tr bgcolor="lightgray">
				<td>

				<table>
					<tr>
						<td><input type="text" id="frmGrpName" name="frmGrpName"
							class="textInputRegionD" value="New group name"
							onclick="this.value=''" /></td>
					</tr>
					<tr>
						<td><select style="width: 200px" id="frmGrpType"
							name="frmGrpType">
							<option value="-1">Choose a Group Type</option>
							<%
								List<GroupType> grpTypes = userCtrl.getGroupTypes();
								for (GroupType grpType : grpTypes) {
									out.println("<option value=\"" + grpType.getId() + "\">"
											+ grpType.getName() + "</option>");
								}
							%>
						</select></td>
					</tr>
				</table>

				</td>
				<td align="center" valign="top" width="80"><input type="button"
					id="btnNewGrp" name="btnNewGrp" onclick="admCtrl.newGroup();"
					value="New" /></td>

				<td valign="top"><input type="button" id="btnRmvGrp"
					name="btnRmvGrp" onclick="javascript:alert('rmv group');"
					value="Remove" disabled="disabled" /></td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td colspan="3" height="25px"></td>
	</tr>
	<tr>
		<th align="right">Project:</th>
		<td align="left" style="border: 3px solid darkgray">
		<table border="0" cellpadding="5" width="100%">
			<tr>
				<td><select class="selectRegionD" id="registered_project"
					size="5" multiple="multiple">
					<%
						List<Project> projectList = userCtrl.getAllProjects();
						for (Project project : projectList) {
							out.println("<option value='" + project.getId() + "'>"
									+ project.getName() + "</option>");
						}
					%>
				</select></td>
				<td align="center" valign="middle">
				<div class='rightButtonList'
					onClick="moveOptions(document.getElementById('registered_project'), document.getElementById('selected_project'));"></div>
				<div class='leftButtonList'
					onClick="moveOptions(document.getElementById('selected_project'), document.getElementById('registered_project'));"></div>
				</td>
				<td><select class="selectRegionD" id="selected_project"
					size="5" multiple="multiple"></select></td>
			</tr>

			<tr>
				<td colspan="3" height="2px"></td>
			</tr>

			<tr bgcolor="lightgray">
				<td>
				<table cellspacing="0">
					<tr>
						<td><input type="text" id="frmPrjName" name="frmPrjName"
							class="textInputRegionD" value="New project name"
							onclick="this.value=''" /></td>
					</tr>
					<tr>
						<td><textarea rows="2" style="width: 200px" id="frmPrjDesc"
							name="frmPrjDesc"></textarea></td>
					</tr>
				</table>
				</td>

				<td align="center" valign="top" width="80"><input type="button"
					id="btnNewPrj" name="btnNewPrj" onclick="admCtrl.newProject();"
					value="New" /></td>
				<td valign="top"><input type="button" id="btnRmvPrj"
					name="btnRmvPrj" onclick="alert('rmv prj');" value="Remove" disabled="disabled"/></td>
			</tr>
		</table>
		</td>
	</tr>
	
	<tr><td colspan="2" height="20"></td></tr>
	<tr>
		<td align="right"><input type="button" id="btnSend"
			value="register" onclick="admCtrl.submitRegisterForm()"></td>
		<td align="left"><input type="button" value="reset"
			onclick="admCtrl.resetRegisterForm()"></td>
	</tr>
</table>
</div>
</div>
<!-- region D -->

<div id='regionE' align="center"><span
	style="text-align: left; margin: 10px 0px 0px 0px;"> <b>Registered
users</b></span><br>
<span style="text-align: left; margin: 10px 0px 0px 0px;"> (A)
Admin, (E) Editor, (I) Interviewer </span> <br>
<br>
<select id="listUsrs" name="listUsrs" multiple="multiple" size="10"
	class="selectRegionE" xonclick="admCtrl.displayUsr();">
	<%
		List<Object[]> userRoles = userCtrl.getAllUsers();
		int i = 0;
		AppUser old = null;
		String roleCode = "";
		while (i < userRoles.size()) {
			Object[] pair = userRoles.get(i);
			AppUser u = (AppUser) pair[0];
			AppuserRole ur = (AppuserRole) pair[1];

			String removed = u.wasRemoved()? " disabled=\"disabled\" ": "";
			if (ur.getTheRole().getName().equalsIgnoreCase("admin"))
				roleCode = "(A)";

			else if (ur.getTheRole().getName().equalsIgnoreCase("editor"))
				roleCode = "(E)";

			else if (ur.getTheRole().getName().equalsIgnoreCase("interviewer"))
				roleCode = "(I)";

			// this is because the user can have several roles					
			if (u == old)
				out.print(" " + roleCode);

			else { // the user is new...
				if (i > 0)
					out.println("</option>");

				out.print("<option value=\"" + u.getId() + removed +"\">" + u.getUsername());
				out.print(" " + roleCode);
				old = u;
			}
			i++;
		}
		roleCode = null;
		old = null;
	%>
</select> <br>
<input type="button" id="btnDelUsr" name="btnDelUsr"
	onclick="admCtrl.delUsr();" value=" Disable " /> <%-- 			
			<div id='panelSmsAdmin' class="usersList">
			<%
				List<Object[]> userRoles = userCtrl.getAllUsers();
				int i = 0;
				AppUser old = null;
				String roleCode = "";
				while (i < userRoles.size()) {
					Object[] pair = userRoles.get(i);
					AppUser u = (AppUser)pair[0];
					AppuserRole ur = (AppuserRole)pair[1];

					if (ur.getTheRole().getName().equalsIgnoreCase("admin"))
						roleCode = "(A)";
					
					else if (ur.getTheRole().getName().equalsIgnoreCase("editor"))
						roleCode = "(E)";
					
					else if (ur.getTheRole().getName().equalsIgnoreCase("interviewer"))
						roleCode = "(I)";
					
					
					if (u == old)
						out.print(" "+roleCode);
					
					else {
						if (i > 0)
							out.println("<br>");
						out.print(u.getUsername()+" "+roleCode);
						old = u;
					}
					i++;
				}
				roleCode = null;
				old = null;
			%>
			</div>
--%></div>
<!--  region E --> <!-- ****************** END LEFT MENU AREA (REGION D) ***************** -->

</div>
<!-- content-container --></div>
<!-- expander --></div>
<!-- sizer --></div>
<!-- portal-container -->


<!-- FOOTER AND END OF PAGE -->
<div id="footer-container-adm" class="portal-copyright-adm">Developed
at <a class="portal-copyright" href="http://www.inab.org">CNIO/INB</a><br />
</div>

<%-- this is to create the modal "dialog" to run the progress bar --%>
<div id="overlay">
<div>
<p style="font-family: Arial, Helvetica, sans-serif; Font-size: 12px;">
Processing...</p>
<p><img src="../img/ajax-loader-trans.gif" alt="Processing..." /></p>
</div>
</div>
</body>
</html>
