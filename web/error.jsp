
<%@ page language="java" contentType="text/html;charset=UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@page import="org.hibernate.Session" %>
<%@page import="org.cnio.appform.util.LogFile, org.cnio.appform.audit.ActionsLogger,
								org.cnio.appform.util.HibernateUtil, 
								org.cnio.appform.util.AppUserCtrl, org.cnio.appform.entity.AppUser" %>
								
<%

	Session hibSes = HibernateUtil.getSessionFactory().openSession();
	
	String user = (String)request.getParameter("j_username");

//	LogFile.info("Access to user '"+user+"' was denied: mismatching user:passwd");
	AppUserCtrl usrCtrl = new AppUserCtrl (hibSes);
	AppUser theUser = usrCtrl.getUser(user);
	
	pageContext.setAttribute("existUsr", 1);
	if (theUser == null)
		pageContext.setAttribute ("existUsr", 0);
	
	pageContext.setAttribute("userRemoved", 0);
	if (theUser != null && theUser.getRemoved() != 0) 
		pageContext.setAttribute("userRemoved", 1);
	
//	usrCtrl.logSessionInit(-1, user, "", "", ipAddr, AppUserCtrl.LOGIN_FAIL);
	
	hibSes.close();

%>


<html>
<head>
  <title>Application Form Tool</title>
  
  <link rel="stylesheet" type="text/css" href="../css/portal_style.css" id="portalCss" /> 
  <link rel="shortcut icon" href="img/favicon.ico"/>
  
</head>

<body id="body">
<div id="portal-container">
   <div id="sizer">
      <div id="expander">
         <table border="0" cellpadding="" cellspacing="5"
					id="header-container-adm">
					<tr>
						<td align="left" valign="top" id="header" width="220px"><a
							href="http://www.inab.org" target="_blank"
							style="text-decoration: none; margin-left: 20px"> <img src="../img/inblogo.jpg"
			height="110" border="0" /></a></td>
						<td align="left" valign="bottom"><a href="http://www.inab.org"
							target="_blank" style="text-decoration: none"> <span
							class="inblogo">Instituto Nacional de Bioinform&aacute;tica</span> </a></td>
					</tr>
				</table>

		
	
<!-- HERE STARTS THE CENTRAL PART, BOTH THE MENU AND CONTENT AREAS -->				 
        <div id="content-container">

<!-- **************** START CONTENT AREA (REGION b)**************** -->		 
           <div id='regionAdmB'> 
           	<table width="100%" height="30%" cellpadding="1" cellspacing="1" border="0">
           	<tr><td align="center" valign="middle">
           		<h1>Application Form Construction and Development Tool</h1>
           	</td></tr>
           	<tr><td height="25"></td></tr>
           	<c:if test="${existUsr eq 0}">
           	<tr><td>
           	<div align="center" id="unableMsg" 
           				style="border: 4px solid red;padding: 15 5 15 5;margin-top:30px">
           		The account you are trying to sign in with was 
           		<span style="text-decoration: blink;color: red;font-weight:bold">not found</span> in the system.<br>
           		Please, contact the <a href="mailto:gcomesana@cnio.es">admin</a> to
           		get an active account.<br>
           		Thank you.
           	</div>
           	</td></tr>
           	</c:if>
           	
           	<c:if test="${userRemoved eq 1}">
           	<tr><td>
           	<div align="center" id="unableMsg" 
           				style="border: 4px solid red;padding: 15 5 15 5;margin-top:30px">
           		The account you are trying to sign in with was 
           		<span style="text-decoration: blink;color: red;font-weight:bold">deactivated</span> for security issues.<br>
           		Please, contact the <a href="mailto:gcomesana@cnio.es">admin</a> to
           		get the active account back.<br>
           		Thank you.
           	</div>
           	</td></tr>
           	</c:if>
           	
           	</table>
           	
           	
           </div> <!-- regionB -->
<!-- ****************** END CONTENT AREA (REGION B) ***************** -->
				
<!-- ****************** START MENU (LEFT) AREA (REGION A) ***************** -->
          <div id='regionAdmA'>
        <c:if test="${userRemoved eq 0}">
          <span style="font-family: Arial, Helvetica, sans-serif;font-size: 12px;">
          Invalid username and/or password, please try
          <a href='<%= response.encodeURL("index.jsp") %>' style="text-decoration:none;color:darkblue;font-size=bolder">login</a> again.
					</span>
				</c:if>
          </div> <!-- region A --> 
<!-- ****************** END LEFT MENU AREA (REGION A) ***************** -->
            
        </div> <!-- content-container -->
        
</div> <!-- expander -->

</div><!-- sizer -->
</div><!-- portal-container -->


<!-- FOOTER AND END OF PAGE -->
<div id="footer-container-adm" class="portal-copyright-adm">Develope at
<a class="portal-copyright-adm" href="http://www.inab.or">INB/CNIO</a><br/>
</div>

</body>
</html>
