<%@ 
	page import="org.hibernate.Session,
				org.hibernate.Transaction,
				org.hibernate.HibernateException"
%>
<%@ 
	page import="org.cnio.appform.util.HibernateUtil,
				org.cnio.appform.util.AppUserCtrl, org.cnio.appform.entity.AppuserRole,
				org.cnio.appform.entity.Role, org.cnio.appform.entity.AppUser,
				org.cnio.appform.entity.AppGroup,
				org.cnio.appform.entity.Project"
%>
<%@ 
	page import="java.util.List"
%>
	
<%
Session hibSess = HibernateUtil.getSessionFactory().openSession();
AppUserCtrl userControl = new AppUserCtrl(hibSess);

List <Role> roleList = userControl.getAllRoles();

%>

<html>
<head>
  <title>Admin Form Tool</title>
  
  <link rel="stylesheet" type="text/css" href="../css/portal_style.css" id="portalCss" />
  <link rel="stylesheet" type="text/css" href="../css/admintool.css" id="adminCss" /> 
  <link rel="shortcut icon" href="../img/favicon.ico"/>
  <script type="text/javascript" src="../js/mixed2b.js"></script>

  <!-- yahoo event, dom and connection files -->	
  <script type="text/javascript" src="../js/yahoo/yahoo-dom-event.js"></script>
  <script type="text/javascript" src="../js/yahoo/connection-debug.js"></script>
  <script type="text/javascript" src="../js/yahoo/json-debug.js"></script>
  <script type="text/javascript" src="../js/yahoo/ajaxreq.js"></script>

<!-- Admin tool scripts -->
  <script type="text/javascript" src="adminType.js"></script>
  <script type="text/javascript" language="javascript" src="adminutil.js"></script>
</head>

<body>
<div id="portal-container">
   <div id="sizer">
      <div id="expander">
         <table border="0" cellpadding="0" cellspacing="0" id="header-container-adm">
            <tr valign="bottom"> 
              <td align="center" valign="middle" id="header">
              <span style="font-family: Arial, Helvetica, sans-serif;font-size: 24px;
              font-weight: bold;">Application Form Tool Administration</span>
              </td>
            </tr>
         </table>

		
	
<!-- HERE STARTS THE CENTRAL PART, BOTH THE MENU AND CONTENT AREAS -->				 
        <div id="content-container">

<!-- ****************** START MENU (CENTER) AREA (REGION D) ***************** -->
          <div id='regionD'>
          	<span style="font-family: Arial, Helvetica, sans-serif;font-size: 14px;
              	font-weight: bold;">
          	Something in region D
          	</span>
          </div> <!-- region D -->
           
		<div id='regionE'>
			<span style="text-align:left;margin:10px 0px 0px 40px;">
			Something in region E
			</span>
		</div> <!--  region E -->
<!-- ****************** END LEFT MENU AREA (REGION D) ***************** -->
            
        </div> <!-- content-container -->
        
</div> <!-- expander -->

</div><!-- sizer -->
</div><!-- portal-container -->


<!-- FOOTER AND END OF PAGE -->
<div id="footer-container-adm" class="portal-copyright-adm">Developed at
<a class="portal-copyright" href="http://www.inab.org">CNIO/INB</a><br/>
</div>

</body>
</html>
