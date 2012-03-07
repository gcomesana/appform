<!-- **************** START CONTENT AREA (REGION b)**************** -->
<%-- 
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
								org.cnio.appform.entity.AnswerItem,
								org.cnio.appform.util.HibernateUtil,
								org.cnio.appform.util.HibController,
								org.cnio.appform.util.IntrvController, 
								org.cnio.appform.util.AppUserCtrl" %>

--%>
	
<%
//	Session hibSes = HibernateUtil.getSessionFactory().openSession();
	boolean existOp = false;
	Enumeration<String> en;
	
	for (en = request.getParameterNames(); en.hasMoreElements(); ) {
		String elem = en.nextElement();
		
		if (elem.equalsIgnoreCase ("op")) {
			existOp = true;
			break;
		}
	}
	
	pageContext.setAttribute ("existOp", existOp);

// page vars necessary to check the permissions	
	String roles = (String)session.getAttribute("roles");
	int action = AppUserCtrl.ACTION_R;
	boolean granted = false;
	
	
//	String paramT = request.getParameter("t");
//	String paramOp = request.getParameter("op");
	String paramRes = request.getParameter("res");
System.out.println("paramT: "+paramT+" & paramOp: "+paramOp+" & paramRes: "+paramRes);	

// SECTION MANAGEMENT
	if (paramT.equalsIgnoreCase("sec")) {
		if (existOp && paramOp.equalsIgnoreCase("det")) {
%>
				<%@include file="detailsec.jsp" %>
<%
		}
		else if (!existOp && (paramRes == null || paramRes.equalsIgnoreCase(""))) {
%>
				<%@include file="mngsec.jsp" %>
<%
		}
		else {
%>
			<%@include file="editsec.jsp" %>
<%
		}
	}
	
// ELEMENT MANAGEMENT
	else if (paramT.equalsIgnoreCase("ele")) {
		granted = AppUserCtrl.elemPermissions(roles, action);
		
		if (paramRes != null && !paramRes.equalsIgnoreCase("")) {
			if (!granted) {
%>
				<%@ include file="nogranted.jsp" %>
<%
				return;
			}
			else {
%>
				<%@ include file="detailsec.jsp" %>
<%
			}
		}
		else if (existOp && (paramOp.equalsIgnoreCase("new"))) {
			if (!granted) {
%>
				<%@ include file="nogranted.jsp" %>
<%
				return;
			}
			else {
%>
				<%@ include file="editelem.jsp" %>
<%
			}
		}
		else if (existOp && (paramOp.equalsIgnoreCase("upd") || paramOp.equalsIgnoreCase("det"))) {
			if (!granted) {
%>
				<%@ include file="nogranted.jsp" %>
<%
				return;
			}
			else {
%>
				<%@ include file="editelem.jsp" %>
<%
			}
		}
		
	}

// PROJECT MANAGEMENT
	else if (paramT.equalsIgnoreCase("prj")) {
		granted = AppUserCtrl.projectPermissions(roles, action);
		if (existOp && paramOp.equalsIgnoreCase("det")) {
			if (!granted) {
%>
				<%@ include file="nogranted.jsp" %>
<%
				return;
			}
			else {
%>
				<%@ include file="detailprj.jsp" %>
<%
			}
		}
		
		else if ((!existOp && (paramRes == null || paramRes.equalsIgnoreCase(""))) || 
						 (existOp && (paramRes != null && !paramRes.equalsIgnoreCase("")))) {
			if (!granted) {
%>
				<%@ include file="nogranted.jsp" %>
<%
				return;
			}
			else {
%>
				<%@ include file="prjlist.jsp" %>
<%
			}
		}
		else {
			action = AppUserCtrl.ACTION_U;
			granted = AppUserCtrl.projectPermissions(roles, action);
			action = AppUserCtrl.ACTION_C;
			granted &= AppUserCtrl.projectPermissions(roles, action);
			if (!granted) {
%>
				<%@ include file="nogranted.jsp" %>
<%
				return;
			}
			else {
%>
				<%@ include file="editprj.jsp" %>
<%
			}
		
		}
	}

// INTERVIEW/QUESTIONNAIRE MANAGEMENT
	else if (paramT.equalsIgnoreCase("int")) {
		granted = AppUserCtrl.projectPermissions(roles, action);
		if (existOp && (paramOp != null && paramOp.equalsIgnoreCase("det"))) {
			if (!granted) {
%>
				<%@ include file="nogranted.jsp" %>
<%
				return;
			}
			else {
%>
				<%@ include file="mngsec.jsp" %>
<% 
			}
		}
		else if ((!existOp && (paramRes == null || paramRes.equalsIgnoreCase("res"))) || 
						 (existOp && (paramRes != null && !paramRes.equalsIgnoreCase("")))) {
			if (!granted) {
%>
				<%@ include file="nogranted.jsp" %>
<%
				return;
			}
			else {
%>
				<%@ include file="mngsec.jsp" %>
<%
			}
		}
		else {
			action = AppUserCtrl.ACTION_C;
			granted = AppUserCtrl.intrvPermissions(roles, action);
			action = AppUserCtrl.ACTION_U;
			granted &= AppUserCtrl.intrvPermissions(roles, action);
System.out.println("center.jsp: intrv granted? " + granted +" for roles: "+roles);

			if (!granted) {
%>
				<%@ include file="nogranted.jsp" %>
<%
				return;
			}
			else {
%>
				<%@ include file="editintr.jsp" %>
<%
			}
		}
	}
	else {
		out.println("<span style=\"font-color:red\">Error params: please contact with administrator</span>");
		
	}
	
%>


<!-- ****************** END CONTENT AREA (REGION B) ***************** -->