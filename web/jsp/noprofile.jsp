<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

    

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
<!-- 	<link rel="shortcut icon" href="../img/favicon.ico"/> -->
	 
<!-- this are the js includes to build the left tree -->
	<link rel="stylesheet" href="../js/treeview/assets/treeview.css" type="text/css"/>
	<link rel="stylesheet" type="text/css" href="../js/fonts/fonts-min.css" />

	
<!-- custom javascript files -->	 	 
	<script type="text/javascript" src="../js/core.js"></script>	 
 	<script type="text/javascript" src="../js/ajaxresponses.js"></script>
 	
 	
	<script type="text/javascript" src="../js/supernote.js"></script>
	<!-- <script type="text/javascript" src="../js/main.js"></script> -->
</head>

<body xonload="onReady();" xonreadystatechange="onReady()"; id="body">
<div id="fitter"></div>

<div id="portal-container">
   <div id="sizer">
      <div id="expander">

     <table border="0" cellpadding="" cellspacing="5" id="header-container-adm">
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
        <div id="content-container">

<!-- **************** START CONTENT AREA (REGION b)**************** -->		 
	<div id='regionNotGrantedB'>
		<span id="errProf" style="font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;
	font-size: 22px;font-weight: bold;color:red; padding:30px 0px 20px 25px;">
		Profile Error
		</span>
		<br><br>
		<p style="margin:5px 0px 10px 25px;">
		You <span style="color:red;font-weight: bold;">
		profile is not completed to see and execute</span> the application.<br>
		Please, contact and report the
		issue to <a href="mailto:gcomesana@cnio.es" style="text-decoration:none;color:darkblue">
		the administrator</a>.
		<br><br>
		<a href="../logout.jsp" style="text-decoration:none;color:darkblue">Log in</a> again as a different user<br>
		or<br>
		<a href="javascript:window.history.go(-1)" style="text-decoration:none;color:darkblue">go back to the previous page</a>
		</p>
	</div> <!-- regionB -->
<!-- ****************** END CONTENT AREA (REGION B) ***************** -->
				

<!-- **************** START LEFT MENU AREA (REGION A)**************** -->
        <div id='regionAdmA' align="center">
					 	
        </div> <!-- region A --> 
<!-- ****************** END LEFT MENU AREA (REGION A) ***************** -->

            
        </div> 
        
</div> <!-- expander -->
   </div><!-- sizer -->
</div><!-- portal-container -->


<!-- FOOTER AND END OF PAGE -->
<div id="footer-container-adm" class="portal-copyright-adm">Developed at
<a class="portal-copyright-adm" href="http://www.inab.org">CNIO/INB</a><br/>

</div>

<div id="overlay">
    <div>
    <p>Processing...</p>
		<p><img src="../img/ajax-loader-trans.gif" alt="Processing..." /></p>
    </div>
</div>
<!-- p:region regionName='AJAXFooter' regionID='AJAXFooter'/> 
<script type='text/javascript'>footer()</script> -->

</body>
</html>

