
<%-- <?xml version="1.0" encoding="UTF-8" ?> --%>
<%@ page language="java" contentType="text/html;charset=UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@page import="org.hibernate.Session, org.hibernate.HibernateException,
								org.hibernate.Transaction, java.util.Collection, 
								java.util.Iterator, java.util.ArrayList, 
								java.util.Enumeration, java.util.List"  %>
								
<%@page import="org.cnio.appform.entity.*, org.cnio.appform.util.LogFile,
								org.cnio.appform.util.*" %>
								
 
<%
//  Enumeration<String> params = request.getParameterNames();
 
	String paramOp = request.getParameter ("op"), opName = "",
	paramT = (request.getParameter("t") == null)? "prj":
						request.getParameter("t");
	pageContext.setAttribute("t", paramT);
	
	String user = request.getUserPrincipal().getName();
	String ipAddr = request.getRemoteAddr();
	String sessId = request.getSession().getId();

	Session hibSes = HibernateUtil.getSessionFactory().openSession();
//	request.setAttribute("hibSess", hibSes);

	AppUserCtrl userCtrl = new AppUserCtrl (hibSes);
	AppUser appUsr = userCtrl.getUser(user);
	
	Integer usrId = (Integer)session.getAttribute("usrid");
	AppUser userFromId = (AppUser)hibSes.get(AppUser.class, usrId);


//Primary groups stuff ///////////////////////////////////////////////////
//	Integer usrId = appUsr.getId();	
	AppGroup active1ary = userCtrl.getPrimaryActiveGroup(appUsr);
	int numGroups = -1;
	String grpName = "";
	
	if (active1ary == null) { // there is no primary active group set
		List<AppGroup> mainGrps = userCtrl.getPrimaryGroups(appUsr);
		numGroups = (mainGrps == null)? 0: mainGrps.size();
		
		if (numGroups == 0)
			pageContext.setAttribute("numGroups", 0);
		
		else {
			pageContext.setAttribute("numGroups", numGroups);
			String grpsId = "";
			for (Iterator<AppGroup> itGrp = mainGrps.iterator(); itGrp.hasNext();) {
				AppGroup grp = itGrp.next();
				grpsId += grp.getName()+":" + grp.getId().toString()+";";
			}
			
			grpsId = grpsId.substring(0, grpsId.length()-1);
			pageContext.setAttribute("grpsId", grpsId);

			
			if (numGroups == 1) {
				String[] grpStr = grpsId.split(":");
				session.setAttribute("primaryGrpId", Integer.parseInt(grpStr[1]));
				session.setAttribute("primaryGrpName", grpStr[0]);
				
				userCtrl.setActiveGroup(appUsr, mainGrps.get(0), 1);
				grpName = mainGrps.get(0).getName();
			}
		}
	} // active1ary
	else if (session.getAttribute("primaryGrpId") == null) {
		grpName = active1ary.getName();
		numGroups = 1;
		session.setAttribute("primaryGrpName", active1ary.getName());
		session.setAttribute("primaryGrpId", active1ary.getId());
		
		pageContext.setAttribute("numGroups", 1);
	}
	
	
// There is already one group selected, so it has to be audited
	if (numGroups == 1) {
		Transaction tx = null;
		String msgLog = "User "+userFromId.getUsername()+" has '" +grpName+
									"' as primary group";

		try {
			tx = hibSes.beginTransaction();
			
			AppDBLogger sessionLog = new AppDBLogger ();
			sessionLog.setUserId(usrId);
			sessionLog.setSessionId(session.getId());
			sessionLog.setMessage(msgLog);
			sessionLog.setLastIp(request.getRemoteAddr());
			hibSes.save(sessionLog);
			
			tx.commit();
		}
		catch (HibernateException ex) {
			if (tx != null)
				tx.rollback();
			
			LogFile.error("Fail to log user group selection:\t");
			LogFile.error("userId="+usrId+"; sessionId="+session.getId());
			LogFile.error(ex.getLocalizedMessage());
			StackTraceElement[] stack = ex.getStackTrace();
			LogFile.logStackTrace(stack);
		}
	}

	
/*	
	Integer codHosp = userCtrl.getCodHospital(user);
	session.setAttribute ("hospital", codHosp);

	if (strRoles.equalsIgnoreCase("interviewer")) {
		response.sendRedirect ("intrv/index.jsp");
	}
*/
//	hibSes.close();

%>

<c:if test="${numGroups eq 0}">
	<jsp:forward page="noprofile.jsp" />
</c:if>

<!-- numGroups: ${numGroups} -->
<c:if test="${numGroups gt 1}"> 
	<jsp:forward page="setprimarygrp.jsp">
		<jsp:param name="typegroup" value="PRI" />
		<jsp:param name="groups" value="${grpsId}" />
	</jsp:forward>
</c:if>


<c:set var="t" value="${param.t}"/>
<c:if test="${empty t}">
	<c:set var="t" value="prj"/>
</c:if>

<c:choose>
	<c:when test="${t eq 'prj'}">
		<c:set var="typename" value="project"/>
	</c:when>
	<c:when test="${t eq 'int'}">
		<c:set var="typename" value="interview"/>
	</c:when>
	<c:when test="${t eq 'sec'}">
		<c:set var="typename" value="section"/>
	</c:when>
	<c:when test="${t eq 'ele'}">
		<c:set var="typename" value="element"/>
	</c:when>
	<c:when test="${t eq 'txt'}">
		<c:set var="typename" value="text"/>
	</c:when>
	<c:when test="${t eq 'que'}">
		<c:set var="typename" value="question"/>
	</c:when>
	<c:when test="${t eq 'enu'}">
		<c:set var="typename" value="enum type"/>
	</c:when>
	
</c:choose>
	
	
	
<%
	if (request.getParameter("res") != null) 
		pageContext.setAttribute ("res", request.getParameter("res"));
		
	else if (request.getParameter("op") != null) 
		pageContext.setAttribute ("op", request.getParameter("op"));
%>	
<%@include file="inc/header.jsp" %>
	
<%-- HEADER.JSP initialization 
<%
	if (request.getParameter("res") != null) {
		pageContext.setAttribute ("res", request.getParameter("res"));
%>
	<jsp:include page="inc/header.jsp" />
	
<%
	}

	else if (request.getParameter("op") != null) {
		pageContext.setAttribute ("op", request.getParameter("op"));
%>
	<jsp:include page="inc/header.jsp" />
<%
	}
	else {
%>
	<jsp:include page="inc/header.jsp" />
--%>


		
<%-- ------------------------------------------------------------- --%>	
<%-- HERE STARTS THE CENTRAL PART, BOTH THE MENU AND CONTENT AREAS --%>				 
        <div id="content-container">
        
<!-- **************** START CONTENT (CENTER) AREA (REGION B)**************** -->

<%
if (request.getParameter("res") != null) 
	pageContext.setAttribute ("res", request.getParameter("res"));

else
	pageContext.setAttribute ("op", request.getParameter("op"));
	
%>
<%@ include file="inc/center.jsp" %>
	

<%--
	if (request.getParameter("res") != null) {
		pageContext.setAttribute ("res", request.getParameter("res"));
%>
	<jsp:include page="inc/center.jsp">
		<jsp:param name="itemname" value="${typename}"/>
		<jsp:param name="t" value="${t}"/>
	</jsp:include>
<%
	}
	else if (request.getParameter("op") != null) {
		pageContext.setAttribute ("op", request.getParameter("op"));
%>
	<jsp:include page="inc/center.jsp">
		<jsp:param name="itemname" value="${typename}"/>
		<jsp:param name="t" value="${t}"/>
	</jsp:include>
<%
	}
	else {
%>
	<jsp:include page="inc/center.jsp">
		<jsp:param name="itemname" value="${typename}"/>
		<jsp:param name="t" value="${t}"/>
	</jsp:include>
<%
/*
		if (hibSes.isOpen())
			System.out.println ("after center: hibSes is still open: "+hibSes.hashCode());
*/
	}
--%>


<%-- ****************** START MENU (LEFT) AREA (REGION A) ***************** --%>
<%@include file="inc/left.jsp" %>
<%-- JBOSS pieces
            < p:region regionName='left' regionID='regionA'/ >
            < p:region regionName='center' regionID='regionB'/ >
            <hr class="cleaner"/> 
--%>
            
        </div> <%-- content-container --%>
        
<%@include file="inc/footer.jsp" %>

<%
	if (hibSes.isOpen()) {
System.out.println ("\nindex.jsp: closing hib session...");
		hibSes.close();
	}
	else
		System.out.println ("\nindex.jsp: hib session already closed");
		
%>
