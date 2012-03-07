<%-- 
<%@ page language="java" contentType="text/html;charset=UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@page import="org.hibernate.Session, java.util.Collection, 
								java.util.Iterator, java.util.ArrayList, java.util.List,
								java.util.Enumeration"  %>
								
<%@page import="org.cnio.appform.entity.AbstractItem, 
					org.cnio.appform.entity.AppGroup,
					org.cnio.appform.entity.Section, org.cnio.appform.entity.Project,
					org.cnio.appform.entity.Interview, org.cnio.appform.entity.AppUser,
					org.cnio.appform.util.HibernateUtil, org.cnio.appform.util.AppUserCtrl,
					org.cnio.appform.util.HibController" %>
--%>

<!-- 
header.jsp
<%
  Enumeration<String> params = request.getParameterNames();

  while (params.hasMoreElements()) {
    String paramName = (String) params.nextElement();
    String paramValues[] = request.getParameterValues(paramName);

    if (paramValues.length == 1) {
      out.println(paramName+"="+paramValues[0]);
    }
    else {
      out.print(paramName+"=");
      for (int i=0; i < paramValues.length; i++) {
          if (i > 0) 
          	out.print(',');
          out.print(paramValues[i]);
      }
      out.println();
    }
  }
%>
-->
								
<%
//	Session hibSes = HibernateUtil.getSessionFactory().openSession();
//	Session hibSes = (Session)request.getAttribute("hibSess");
System.out.println("header.jsp: hibSes: "+hibSes.hashCode());
/*	
	String paramOp = request.getParameter ("op"), opName = "",
				paramT = (request.getParameter("t") == null)? "prj":
									request.getParameter("t");
	pageContext.setAttribute("t", paramT);
*/	
// op=upd&t=ele&frmid=102
// this java snippet is to display a message after an operation
// so, it is supossed that parameter res is present
	
	if (request.getParameter("res") != null) {
		if (paramT.equalsIgnoreCase("sec")) {
			Section newSec;
			String secName="", secId="";
			
			if (paramOp != null && paramOp.length() > 0) { 
				if (paramOp.equalsIgnoreCase("NEW")) {
					/*
					newSec = HibController.SectionCtrl.getLastSection(hibSes);
					secName = newSec.getName();
					secId = newSec.getId().toString();
					*/
					opName = "added";
				}
					
				else if (paramOp.equalsIgnoreCase ("UPD")) {
					newSec = (Section)hibSes.get (Section.class, 
															Integer.decode(request.getParameter("frmid")));
					secName = newSec.getName();
					secId = newSec.getId().toString();
					
					opName = "updated";
				}
					
				else if (paramOp.equalsIgnoreCase ("DEL")) {
					secId = request.getParameter("frmid");
					opName = "deleted";
				}
			}
			pageContext.setAttribute("name", secName);
			pageContext.setAttribute("id", secId);
			pageContext.setAttribute("opName", opName);
		}
	
		
		if (paramT.equalsIgnoreCase("ele")) {
			AbstractItem newItem;
			String itemName="", itemId="";
			
			if (paramOp != null && paramOp.length() > 0) {
				if (paramOp.equalsIgnoreCase("NEW")) {
	/*				newItem = HibController.ItemManager.getLastItem(hibSes);
					newItem = 
						(AbstractItem)hibSes.get(AbstractItem.class, 
																		 Long.decode(request.getParameter("frmid")));
					itemName = newItem.getContent();
					itemId = newItem.getId().toString();
	*/				
					opName = "added";
				}
					
				else if (paramOp.equalsIgnoreCase ("UPD")) {
					newItem = (AbstractItem)hibSes.get (AbstractItem.class, 
															Long.decode(request.getParameter("frmid")));
					itemName = newItem.getContent();
					itemId = newItem.getId().toString();
					
					opName = "updated";
				}
					
				else if (paramOp.equalsIgnoreCase ("DEL")) {
					itemId = request.getParameter("frmid");
					opName = "deleted";
				}
			}
			pageContext.setAttribute("name", itemName);
			pageContext.setAttribute("id", itemId);
			pageContext.setAttribute("opName", opName);
		}
			
		
		if (paramT.equalsIgnoreCase("prj")) {
				Project newItem;
				String itemName="", itemId="";
				
				if (paramOp != null && paramOp.length() > 0) {
					if (paramOp.equalsIgnoreCase("NEW")) {
	/*					
						newItem = HibController.ItemManager.getLastItem(hibSes);
						newItem = 
							(Project)hibSes.get(Project.class, 
																	Integer.decode(request.getParameter("frmid")));
						itemName = newItem.getName();
						itemId = newItem.getId().toString();
	*/					
						opName = "added";
					}
						
					else if (paramOp.equalsIgnoreCase ("UPD")) {
						newItem = (Project)hibSes.get (Project.class, 
																Integer.decode(request.getParameter("frmid")));
						itemName = newItem.getName();
						itemId = newItem.getId().toString();
						
						opName = "updated";
					}
						
					else if (paramOp.equalsIgnoreCase ("DEL")) {
						itemId = request.getParameter("frmid");
						opName = "deleted";
					}
				}
				pageContext.setAttribute("name", itemName);
				pageContext.setAttribute("id", itemId);
				pageContext.setAttribute("opName", opName);
		}
		
		if (paramT.equalsIgnoreCase("int")) {
			Interview newItem;
			String itemName="", itemId="";
			
			if (paramOp != null && paramOp.length() > 0) {
				if (paramOp.equalsIgnoreCase("NEW")) {
/*					
					newItem = HibController.ItemManager.getLastItem(hibSes);
					newItem = 
						(Project)hibSes.get(Project.class, 
																Integer.decode(request.getParameter("frmid")));
					itemName = newItem.getName();
					itemId = newItem.getId().toString();
*/					
					opName = "added";
				}
					
				else if (paramOp.equalsIgnoreCase ("UPD")) {
					newItem = (Interview)hibSes.get (Interview.class, 
															Integer.decode(request.getParameter("frmid")));
					itemName = newItem.getName();
					itemId = newItem.getId().toString();
					
					opName = "updated";
				}
					
				else if (paramOp.equalsIgnoreCase ("DEL")) {
					itemId = request.getParameter("frmid");
					opName = "deleted";
				}
			}
			pageContext.setAttribute("name", itemName);
			pageContext.setAttribute("id", itemId);
			pageContext.setAttribute("opName", opName);
		}
	} // if res is present
	
	
	
////////////////////////////////////////////////////////////////////////////
// This is for BREADCRUMBS in order to be able to go back or whatever
// urls for the BREADCRUMBS, not exclusive
// if t = prj, nothing
// if t = int, just index.jsp?t=prj&op=det&frmid=idprj
// if t = sec, index.jsp?t=int&op=det&frmid=idintr and above
// if t = ele, index.jsp?t=sec&op=det&frmid=idsec and above
	String frmId = request.getParameter("frmid"),
				 spid = request.getParameter("spid"),
				 prjStr = "<a href=\"index.jsp", intrStr = "<a href=\"index.jsp",
				 secStr = "<a href=\"index.jsp", href="",
				 hrefStyle = "style=\"text-decoration:none;color:darkblue\"",
				 homeStr = "<a href=\"index.jsp\" "+hrefStyle+">Home</a>";
 	
	if (frmId != null && spid == null) {
		if (paramT.equalsIgnoreCase("int")) {
			Interview intr = (Interview)hibSes.get(Interview.class, Integer.decode (frmId));
			Integer prjId = intr.getParentProj().getId();
			prjStr += "?t=prj&op=det&frmid="+prjId.intValue()+"\" "+hrefStyle+">Project</a>";
		}
		
		if (paramT.equalsIgnoreCase("sec")) {
			Section sec = (Section)hibSes.get(Section.class, Integer.decode(frmId));
			Interview intr = sec.getParentIntr();
			
			Integer prjId = intr.getParentProj().getId();
			prjStr += "?t=prj&op=det&frmid="+prjId.intValue()+"\" "+hrefStyle+">Project</a>";
			
			Integer intrId = sec.getParentIntr().getId();
			intrStr += "?t=int&op=det&frmid="+intrId.intValue()+"\" "+hrefStyle+">Interview</a>";
		}
		
		if (paramT.equalsIgnoreCase("ele")) {
			AbstractItem ait = (AbstractItem)hibSes.get(AbstractItem.class, Long.decode(frmId));
			Section sec = ait.getParentSec();
			Interview intr = sec.getParentIntr();
			
			Integer prjId = intr.getParentProj().getId();
			prjStr += "?t=prj&op=det&frmid="+prjId.intValue()+"\" "+hrefStyle+">Project</a>";
			
			Integer intrId = sec.getParentIntr().getId();
			intrStr += "?t=int&op=det&frmid="+intrId.intValue()+"\" "+hrefStyle+">Interview</a>";
			
			Integer secId = ait.getParentSec().getId();
			secStr += "?t=sec&op=det&frmid="+secId.intValue()+"\" "+hrefStyle+">Section</a>";
		}
	}
	
	
// spid is the id of the parent of the current element, which doesnt have frmid
// for example, when a new elem is being created
	if (frmId == null && spid != null) {
		if (paramT.equalsIgnoreCase("int")) {
//			Interview intr = (Interview)hibSes.get(Interview.class, Integer.decode (frmId));
//			Integer prjId = intr.getParentProj().getId();
			prjStr += "?t=prj&op=det&frmid="+spid+"\" "+hrefStyle+">Project</a>";
		}
		
		if (paramT.equalsIgnoreCase("sec")) {
//			Section sec = (Section)hibSes.get(Section.class, Integer.decode(frmId));
			Interview intr = (Interview)hibSes.get(Interview.class, Integer.decode(spid));
			
			Integer prjId = intr.getParentProj().getId();
			prjStr += "?t=prj&op=det&frmid="+prjId.intValue()+"\" "+hrefStyle+">Project</a>";
			
			intrStr += "?t=int&op=det&frmid="+spid+"\" "+hrefStyle+">Interview</a>";
		}
		
		if (paramT.equalsIgnoreCase("ele")) {
			Section sec = (Section)hibSes.get(Section.class, Integer.decode(spid));
			Interview intr = sec.getParentIntr();
			
			Integer prjId = intr.getParentProj().getId();
			prjStr += "?t=prj&op=det&frmid="+prjId.intValue()+"\" "+hrefStyle+">Project</a>";
			
			Integer intrId = sec.getParentIntr().getId();
			intrStr += "?t=int&op=det&frmid="+intrId.intValue()+"\" "+hrefStyle+">Interview</a>";
			
			secStr += "?t=sec&op=det&frmid="+spid+"\" "+hrefStyle+">Section</a>";
		}
	}
	
// Both spid and frmid are not null, 
// which occurs when updating frmid and the parent is spid

	if (frmId != null && spid != null) {
		if (paramT.equalsIgnoreCase("prj")) {
			Project prj = (Project)hibSes.get(Project.class, Integer.decode (spid));
			Integer prjId = prj.getId();
			prjStr += "?t=prj&op=det&frmid="+spid+"\" "+hrefStyle+">Project</a>";
		}
		
		if (paramT.equalsIgnoreCase("int")) {
//			Interview intr = (Interview)hibSes.get(Interview.class, Integer.decode (spid));
//			Integer prjId = intr.getParentProj().getId();
			Interview intr = (Interview)hibSes.get(Interview.class, Integer.decode (frmId));
			Integer prjId = Integer.parseInt(spid);
			prjStr += "?t=prj&op=det&frmid="+spid+"\" "+hrefStyle+">Project</a>";
		}
		
		if (paramT.equalsIgnoreCase("sec")) {
			Section sec = (Section)hibSes.get(Section.class, Integer.decode(spid));
			if (sec == null)
				sec = (Section)hibSes.get(Section.class, Integer.decode(frmId));
			
			Interview intr = sec.getParentIntr();
			
			Integer prjId = intr.getParentProj().getId(),
						intrvId = intr.getId();
			prjStr += "?t=prj&op=det&frmid="+prjId.intValue()+"\" "+hrefStyle+">Project</a>";
			
			intrStr += "?t=int&op=det&frmid="+intrvId+"\" "+hrefStyle+">Interview</a>";
		}
		
		if (paramT.equalsIgnoreCase("ele")) {
			
			Section sec = (Section)hibSes.get(Section.class, Integer.decode(spid));
			Interview intr = sec.getParentIntr();
			
			Integer prjId = intr.getParentProj().getId();
			prjStr += "?t=prj&op=det&frmid="+prjId.intValue()+"\" "+hrefStyle+">Project</a>";
			
			Integer intrId = sec.getParentIntr().getId();
			intrStr += "?t=int&op=det&frmid="+intrId.intValue()+"\" "+hrefStyle+">Interview</a>";
			
			secStr += "?t=sec&op=det&frmid="+spid+"\" "+hrefStyle+">Section</a>";
		}

	}


	
	if (paramT != null && (frmId != null || spid != null)) {
		if (paramT.equalsIgnoreCase("ele")) {
			href = homeStr + " > " + prjStr + " > " + intrStr + " > " + secStr;
		}
		
		if (paramT.equalsIgnoreCase("sec")) {
			href = homeStr + " > " + prjStr + " > " + intrStr;
		}
		
		if (paramT.equalsIgnoreCase("int")) {
			href = homeStr + " > " + prjStr;
		}
		
		if (paramT.equalsIgnoreCase("prj")) {
			href = homeStr;
		}
	}
	
// added to implement m:n user-group relationship
// at this time for primary groups (countries in this particular case
//	Integer usrId = (Integer)session.getAttribute("usrid");
	AppUser appUser = (AppUser)hibSes.get(AppUser.class, usrId);
	AppUserCtrl usrCtrl = new AppUserCtrl(hibSes);
	
	pageContext.setAttribute("grpName", (String)session.getAttribute("primaryGrpName"));	
	pageContext.setAttribute("breadcrumbs", href);
	pageContext.setAttribute ("res", request.getParameter("res"));
	
// This is to allow interview comparison. THIS MUST NOT BE HERE!!!!
	String strRoles = (String)session.getAttribute("roles");
	String compareLnk = "";
	if (strRoles.toUpperCase().indexOf(AppUserCtrl.ADMIN_ROLE) != -1 ||
			strRoles.toUpperCase().indexOf(AppUserCtrl.DATAMGR_ROLE) != -1 ||
			strRoles.toUpperCase().indexOf(AppUserCtrl.EDITOR_ROLE) != -1) {
		compareLnk = "<a href=\"javascript:compareIntrv();\" style=\"color:darkblue\">Compare interviews</a>";
	}
	pageContext.setAttribute("complnk", compareLnk);	
	
	List<AppGroup> listGroups = usrCtrl.getPrimaryGroups(appUser);
	pageContext.setAttribute("numGroups", listGroups.size());
	
	if (listGroups.size() > 1) {
		String grpsId = "";
		for (Iterator<AppGroup> itGrp = listGroups.iterator(); itGrp.hasNext();) {
			AppGroup grp = itGrp.next();
			grpsId += grp.getName()+":" + grp.getId().toString()+";";
		}
		
		grpsId = grpsId.substring(0, grpsId.length()-1);
		pageContext.setAttribute("grpsId", grpsId);
	}
	
//	hibSes.close();
%>    

<!-- header.jsp: numbGroups is ${numGroups} -->
<!-- start layout index.jsp -->
<!-- %@ page import="org.jboss.portal.server.PortalConstants" % -->
<!-- %@ taglib uri="/WEB-INF/theme/panportal-layout.tld" prefix="p" --> 
<!-- %@ taglib uri="/tld/portal-layout.tld" prefix="p" % -->
<!-- %@ taglib uri="/WEB-INF/theme/portal-layout.tld" prefix="p" % -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>Application Form Tool</title>
  <META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8"/>
   <!-- to correct the unsightly Flash of Unstyled Content. -->
	
	<link rel="stylesheet" type="text/css" 
					href="../../css/portal_style.css" id="portalCss"/>   
  <link rel="stylesheet" type="text/css" 
  				href="../css/portal_style.css" id="portalCss"/> 
  <link rel="stylesheet" type="text/css" href="../css/supernote.css" />
  <link rel="stylesheet" type="text/css" href="../css/overlay.css" />
  
  <c:if test="${t eq 'ele'}">
  	<link rel="stylesheet" type="text/css" 
  				href="../js/yahoo/container/assets/skins/sam/container.css" />
  </c:if>
	 
<!-- this are the js includes to build the left tree -->
	<link rel="stylesheet" type="text/css" href="../js/fonts/fonts-min.css" />
	
	<link href="../../img/favicon.ico" rel="shortcut icon" type="image/x-icon" />
	<link href="../img/favicon.ico" rel="shortcut icon" type="image/x-icon" />
	
<!-- treeview and yahoo event, dom and connection files -->	
	<script type="text/javascript" src="../js/yahoo/yahoo-dom-event.js"></script>
	<script type="text/javascript" src="../js/yahoo/connection-debug.js"></script>
	<script type="text/javascript" src="../js/yahoo/json-debug.js"></script>
	<script type="text/javascript" src="../js/overlay.js"></script>
	<script type="text/javascript" src="../js/yahoo/ajaxreq.js"></script>
	
<!-- These are the YUI files necessary to implement a modal simple dialog -->
	<c:if test="${t eq 'ele'}">
	<script type="text/javascript" src="../js/yahoo/animation/animation.js"></script>
	<script type="text/javascript" src="../js/yahoo/container/container.js"></script>
	</c:if>
<!-- custom javascript files -->	 	 
	<script type="text/javascript" src="../js/core.js"></script>	
 <!--	<script type="text/javascript" src="../js/ajaxresponses.js"></script> -->
 	
 	<script type="text/javascript" src="../js/ctrlsec.js"></script>
 	
<!-- ${t} ; ${res} --> 	
	<c:if test="${t eq 'prj'}">
 		<script type="text/javascript" src="../js/ctrlprj.js"></script>
 	</c:if>
 	
 	<c:if test="${t eq 'int'}">
 		<script type="text/javascript" src="../js/ctrlintr.js"></script>
 	</c:if>
 	
<%--	<c:if test="${t eq 'sec' || (t eq 'ele' && res != null)}"> --%>
	
 		<script type="text/javascript" src="../js/listitemctrl.js"></script>
 	
 	
 	<c:if test="${t eq 'ele' && res == null}">
 		<script type="text/javascript" src="../js/yahoo/selector-beta-debug.js"></script>
 		<script type="text/javascript" src="../js/formitemctrl.js"></script>
 	</c:if>
 	
<!-- 
	<script type="text/javascript" src="/miniappform/js/ctrlitem.js"></script>
-->
	<script type="text/javascript" src="../js/supernote.js"></script>
	
	<script type="text/javascript" src="../js/main.js"></script>
</head>

<body onload="onReady();" onreadystatechange="onReady()"; id="body" 
<c:if test="${t eq 'ele'}">class="yui-skin-sam"</c:if> 
	onunload="onRemovePage();">
<script type="text/javascript" src="../js/wz_tooltip.js"></script>
<div id="fitter"></div>

<div id="portal-container">
   <div id="sizer">
      <div id="expander">
         <div id="logoName"><!-- 
         <a href="http://www.inab.org" target="_blank" style="text-decoration:none">
              <img src="../img/inblogo.gif" height="100" border="0"/>
            <span class="inblogo">Instituto Nacional de Bioinformática</span>
            </a>-->
				 </div>
         <table border="0" cellpadding="0" cellspacing="0" id="header-container-adm">
            <tr> 
              <td align="center" valign="top" id="header">
              <span style="float:left;margin-left:15px;margin-top:5px">
              ${complnk}
              </span>
                <!-- Utility controls -->
                <!-- actually, dashboard is located at the upper right corner 
                     and is composed by the links to the different sections
                     in the portal: dashboard, portal, logout, maybe admin -->
                <div id='dashboardnavAdm' align="left">
							User: <b><%= session.getAttribute("user") %></b><br/>
							Roles: <b><%= session.getAttribute("roles") %></b><br/>
							<c:if test="${numGroups eq 1}">
							Primary Group: <b>${grpName}</b>
							</c:if>
							
							<c:if test="${numGroups gt 1}">
							<a href="setprimarygrp.jsp?typegroup=PRI&groups=${grpsId}&click=1" 
								style="text-decoration:none;color:darkblue;font-size=bolder">
							Primary Group</a>: <b>${grpName}</b>
							</c:if>
							<br>
<a href="<%= response.encodeURL("../logout.jsp") %> " style="text-decoration:none;color:darkblue;font-size=bolder">Logout</a>
							<!-- p:region regionName='dashboardnav' regionID='dashboardnav'/> -
							&nbsp;&nbsp;
							<a href="http://localhost:8080/portal/auth/dashboard">Dashboard</a>
							&nbsp;&nbsp;|
							&nbsp;&nbsp;<a href="http://localhost:8080/portal/auth/portal/admin">Admin</a>&nbsp;&nbsp;| -
							<a href="http://localhost:8080/portal/signout">Logout</a>-->
							</div>

                <!-- navigation tabs and such -->
							<div id="navigation">
								<%--
								<c:if test="${param.res eq '1'}">
									<c:out value="${typename}"/>
									The <b>${param.itemname}</b> was sucessfully ${opName} 
									<c:if test="${not empty id}">: id: <b>${id}</b></c:if> 
									<c:if test="${not empty name}">- name: <b>${name}</b></c:if>
									<br/>
								</c:if>
								<c:if test="${param.res eq '0'}">
									<span id="error">The <b>${param.itemname}</b> 
									could not be ${opName}</span><br/>
								</c:if>
								--%>
<!-- BREADCRUMS -->${breadcrumbs}

							 <!-- 
							<ul id="tabsHeader">   
								 <li  id="current" onmouseover="this.className='hoverOn'" 
								      onmouseout="this.className='hoverOff'">
								 <a href="/portal/auth/portal/HelloPortal/default">Home</a>   
								 </li>
								 
								 <li  onmouseover="this.className='hoverOn'" onmouseout="this.className='hoverOff'">
								 <a href="/portal/auth/portal/HelloPortal/foobar">foobar</a>  
								 </li>
							</ul> -->
<!-- < p:region regionName='navigation' regionID='navigation'/ > -->
							</div> <!-- navigation -->
<!--                 <div id="spacer"></div> -->
								
						  </td>
            </tr>
         </table>