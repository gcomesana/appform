
<%
String type = request.getParameter ("t");
Section sec;
Interview intrv;
String elemId = request.getParameter ("frmid");
//			spid = request.getParameter ("spid");
/*
hibSes = HibernateUtil.getSessionFactory().getCurrentSession();
if (!hibSes.isOpen())
	hibSes = HibernateUtil.getSessionFactory().openSession();
*/

pageContext.setAttribute("isGuest", 0);
if (appUsr != null) {
	if (appUsr.isGuest()) 
		pageContext.setAttribute("isGuest", 1);
}

// String roles = (String)session.getAttribute("roles");
pageContext.setAttribute("isCoord", 0);
if (roles.indexOf ("coordinator") != -1)
	pageContext.setAttribute("isCoord", 1);

if (roles.toUpperCase().indexOf(AppUserCtrl.ADMIN_ROLE) != -1 ||
		roles.toUpperCase().indexOf(AppUserCtrl.EDITOR_ROLE) != -1 ||
		roles.toUpperCase().indexOf(AppUserCtrl.INTRVR_ROLE) != -1)
	pageContext.setAttribute("isCoord", 0);

/*
Transaction tx = null;
try {
	tx = hibSes.beginTransaction ();
*/

	if (type != null) {
		if (type.equalsIgnoreCase("ele")) {
			if (elemId != null) {
				AbstractItem ai = (AbstractItem)hibSes.get(AbstractItem.class, Long.decode(elemId));
				sec = ai.getParentSec();
			}
			else { // new elem is gonna be created, no frmid but spid
				elemId = request.getParameter("spid");
				sec = (Section)hibSes.get(Section.class, Integer.decode(elemId));
			}
			intrv = sec.getParentIntr();
			
			pageContext.setAttribute ("interview", intrv);
		
		}
		else if (type.equalsIgnoreCase("sec")) {
			
			if (elemId != null && spid != null) {
				sec = (Section)hibSes.get(Section.class, Integer.decode(spid));
				if (sec == null)
					sec = (Section)hibSes.get(Section.class, Integer.decode(elemId));
				
				intrv = sec.getParentIntr();
			}
			else if (elemId != null) {
				sec = (Section)hibSes.get(Section.class, Integer.decode(elemId));
				intrv = sec.getParentIntr();
			}
			else { // we are creating a new section, no frmid but spid
				elemId = request.getParameter("spid");
				intrv = (Interview)hibSes.get(Interview.class, Integer.decode(elemId));
			}
			
			pageContext.setAttribute ("interview", intrv);
		}
		
		else if (type.equalsIgnoreCase("int") && 
						request.getParameter("op").equalsIgnoreCase("det")) {
			
			intrv = (Interview)hibSes.get(Interview.class, Integer.decode(elemId));
			pageContext.setAttribute ("interview", intrv);
		}
	}

/*	
	tx.commit();
}
catch (HibernateException hibEx) {
	if (tx != null)
		tx.rollback();
}
*/
// hibSes.close();
%>

<!-- **************** START LEFT MENU AREA (REGION A)**************** -->
     <div id='regionAdmA'>
       <c:if test="${not empty interview}">
<!--           <a href="intrv/index.jsp?intrv=${interview.id}" style="text-decoration:none;color:darkblue" target="_blank">-->
				<a href="javascript:listCtrl.raiseLeftIntrv(${interview.id},0)" style="text-decoration:none;color:darkblue">
       		Perform Interview <b>'${interview.name}'</b></a><br>
				<c:if test="${isGuest eq 0 and isCoord eq 0}">
       		<input type="checkbox" name="chkRT" id="chkRT" value="1" checked="checked"/>
				<span class="minifont">Autosaving</span><br><br>
				</c:if>
				<c:if test="${isGuest eq 1 or isCoord eq 1}">
					<br>
				</c:if>
<!--          <a href="intrv/index.jsp?intrv=${interview.id}&sim=1" style="text-decoration:none;color:darkblue" target="_blank">-->
				<a href="javascript:listCtrl.raiseLeftIntrv(${interview.id},1)" style="text-decoration:none;color:darkblue">
       		Preview Interview <b>'${interview.name}'</b></a><br>
       </c:if>
		 	<div id="treePane"></div>
		 	
     </div> <!-- region A --> 
<!-- ****************** END LEFT MENU AREA (REGION A) ***************** -->