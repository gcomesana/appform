
<%@ page language="java" contentType="text/html;charset=UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@page import="org.hibernate.Session, org.hibernate.Transaction, 
								org.hibernate.HibernateException, java.util.Collection, 
								java.util.Iterator, java.util.ArrayList, 
								java.util.Enumeration"  %>
								
<%@page import="org.cnio.appform.entity.AbstractItem, 
								org.cnio.appform.entity.Section, org.cnio.appform.audit.ActionsLogger,
								org.cnio.appform.util.HibernateUtil,org.cnio.appform.util.LogFile,
								org.cnio.appform.util.HibController" %>

<%
	String type = request.getParameter("t");
	String orderedIds[] = request.getParameterValues("newOrder");
		orderedIds = orderedIds[0].split(",");
	Session hibSes = HibernateUtil.getSessionFactory().openSession();
	boolean res = true; 
	String errMsg, ipAddr = request.getRemoteAddr(), itemName="";
	
	Transaction tx = null;
	try {
	// out.print("orderedIds.length:"+orderedIds.length+"<br/>");
		tx = hibSes.getTransaction();
		tx = (!tx.isActive())? hibSes.beginTransaction(): tx;
		
		ActionsLogger actLogger = new ActionsLogger (hibSes);
		int what = 0;
		for (int i=0; i<orderedIds.length; i++) {
		
			if (type.equalsIgnoreCase("sec")) {
				Section sec = 
					(Section)hibSes.get(Section.class, Integer.decode(orderedIds[i]));
				if (sec != null)
					sec.setSectionOrder(new Integer(i+1));
				what = ActionsLogger.SECTION;
				itemName = "'All sections in questionnaire'";
			}
			
			else if (type.equalsIgnoreCase("ele")) {
				AbstractItem ai = 
					(AbstractItem)hibSes.get(AbstractItem.class, Long.decode(orderedIds[i]));
				if (ai != null)
					ai.setItemOrder(new Long(i+1));
				itemName = "'All items in section'";
			}
		}
		tx.commit();
		
		Integer usrId = (Integer)session.getAttribute("usrid");
		actLogger.logItem(session.getId(), ipAddr, usrId, what, Integer.decode(orderedIds[0]), 
											itemName, ActionsLogger.UPDATE);
	}
	catch (HibernateException hibEx) {
		if (tx != null)
			tx.rollback();
		
		errMsg = hibEx.getMessage()+hibEx.getLocalizedMessage();
		pageContext.setAttribute("errmsg", errMsg);
//		hibEx.printStackTrace();

		LogFile.error("Fail to rearrange items:\t");
		LogFile.error("Items type (first id): "+type+"("+orderedIds[0]+")");
		
		LogFile.error(hibEx.getLocalizedMessage());
		StackTraceElement[] stack = hibEx.getStackTrace();
		LogFile.logStackTrace(stack);
		
		res = false;
	}
	
	hibSes.close();
	if (res) {
%>
{"res":1}
<%
}
else {
%>
{"res":0}
<%
}
%>