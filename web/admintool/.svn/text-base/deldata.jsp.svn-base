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
String what = request.getParameter("what");
String msg = "", jsonStr = "", itemName = "";
int newId = 0, res;

Session hibSes = HibernateUtil.getSessionFactory().openSession();

if (what != null && what.equalsIgnoreCase(USR_CODE)) {
	String strUsrId = request.getParameter("frmid");
	String name = request.getParameter("frmname");
	Transaction tx = null;
	
	try {
		tx = hibSes.beginTransaction();
		AppUser usr = (AppUser)hibSes.get(AppUser.class, Integer.decode(strUsrId));
		if (usr != null) {
/*
			List<Performance> perfs = usr.getPerformances();
			for (int i=0; i<perfs.size(); i++) {
				Performance perf = perfs.get(i);
				perf.setAppuser(null);
				
				usr.getPerformances().remove(perf);
			}
			hibSes.delete(usr);
*/
			usr.setRemoved(1);
			tx.commit();
			
			msg = "The user named '"+name+"' was successfully disabled";
			res = 1;
		}
		else {
			msg = "The user named '"+name+"' doesn't exist";
			res = 0;
		}
	}
	catch (NumberFormatException nfEx) {
		if (tx != null) 
			tx.rollback();
		
		msg = "The user doesn't exists";
		res = 0;
	}
	catch (HibernateException hibEx) {
		if (tx != null) 
			tx.rollback();
		
		msg = "The user could not be deleted. Try again in few minutes";
		res = 0;
	}
	finally {
		hibSes.close ();
	}

	jsonStr = "{\"res\":"+res+",\"msg\":\""+msg+"\",\"id\":"+strUsrId+"}";
	out.print(jsonStr);
}
%>