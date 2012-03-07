<%@
	page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"
%>
        
<%@
	page import="org.hibernate.Session,	org.hibernate.Transaction,
				org.hibernate.HibernateException"
%>
<%@
	page import="org.cnio.appform.util.HibernateUtil,
				org.cnio.appform.util.HibController, org.cnio.appform.util.AppUserCtrl,
				org.cnio.appform.entity.*"
%>
<%@
	page import="java.util.Collection, java.util.Iterator, java.util.List,
				java.util.ArrayList, java.util.Vector, java.util.Enumeration,
				java.util.Hashtable, java.net.URLDecoder"
%>

<%
final String USR_CODE = "usr";
%>
<%
//out.print("{\"id\":"+hException.get("id")+",\"type\":\""+hException.get("type")+"\",\"message\":\""+hException.get("message")+"\"}");
String what = request.getParameter("what");
String msg = "", jsonStr = "", itemName = "";
int newId = 0;

Session hibSes = HibernateUtil.getSessionFactory().openSession();
AppUserCtrl usrCtrl = new AppUserCtrl (hibSes);


if (what != null && what.equalsIgnoreCase(USR_CODE)) {
	String userName, usrPasswd, roles="", grps="", prjs="", lastName, firstName;
	Integer usrId;
	
	List<AppGroup> listGrps = null;
	List<Project>listPrjs = null;
	List<Role> roleList = null;
	
	AppUser theUsr = null;
	String frmId = request.getParameter("frmid");
	
	if (frmId != null) {
		theUsr = (AppUser)hibSes.get(AppUser.class, Integer.decode(frmId));
		
		if (theUsr != null) {
			userName = theUsr.getUsername();
			usrPasswd = theUsr.getPasswd();
			firstName = (theUsr.getFirstName()==null)? "": theUsr.getFirstName();
			lastName = (theUsr.getLastName() == null)? "": theUsr.getLastName();
			
			usrId = theUsr.getId();
			roleList = usrCtrl.getRoleFromUser(theUsr);
			listGrps = usrCtrl.getGroups(theUsr);
			listPrjs = usrCtrl.getProjects(theUsr);

			if (roleList != null && roleList.size() > 0) {
				for (Iterator<Role> it=roleList.iterator(); it.hasNext();) {
					Role rol = it.next();
					roles += rol.getId()+",";
				}
			}
			roles = roles.substring(0, roles.length()-1);
			
			if (listPrjs != null && listPrjs.size() > 0) {
				for (Iterator<Project> itPrj=listPrjs.iterator(); itPrj.hasNext();) {
					Project prj = itPrj.next();
					prjs += prj.getId()+",";
				}
			}
			prjs = prjs.substring(0, prjs.length()-1);
			
			if (listGrps != null && listGrps.size() > 0) {
				for (Iterator<AppGroup> itGrp=listGrps.iterator(); itGrp.hasNext();) {
					AppGroup grp = itGrp.next();
					grps += grp.getId()+",";
				}
			}
			grps = (grps.length()==0)? grps: grps.substring(0, grps.length()-1);
			
			msg = "";
			jsonStr = "{\"res\":"+1+",\"msg\":\""+msg+"\",\"id\":"+usrId;
			jsonStr += ",\"username\":\""+userName+"\",\"passwd\":\""+usrPasswd;
			jsonStr += "\",\"firstName\":\""+firstName+"\",\"lastName\":\""+lastName;
//			jsonStr += "\",\"roles\":[100],\"groups\":[4, 300],\"prjs\":[50]}";
			jsonStr += "\",\"roles\":["+roles+"],\"groups\":["+grps+"],\"prjs\":["+
								prjs+"]}";
			
		}
		else {
			msg = "There is no user registered for this request";
			jsonStr = "{\"res\":"+0+",\"msg\":\""+msg+"\"}";
		}
	}
	else {
		msg = "No element id was found on the request. Please, provide one";
		jsonStr = "{\"res\":"+0+",\"msg\":\""+msg+"\"}";
	}
}
else if (what == null) {
	msg = "No element id was found on the request. Please, provide one";
	jsonStr = "{\"res\":"+0+",\"msg\":\""+msg+"\"}";
}
hibSes.close();

out.print(jsonStr);
%>