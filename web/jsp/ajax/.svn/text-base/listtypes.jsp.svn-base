<%--<?xml version="1.0" encoding="UTF-8" ?> --%>
<%@ page language="java" contentType="text/html;charset=UTF-8"
    pageEncoding="UTF-8"%>
        
<%@page import="org.hibernate.Session, org.hibernate.Transaction,
							  org.hibernate.HibernateException, java.util.Collection, 
								java.util.Iterator, java.util.ArrayList, java.util.List, 
								java.util.Enumeration, java.util.Hashtable,
								java.net.URLDecoder"  %>
								
<%@page import="org.cnio.appform.entity.AbstractItem, org.cnio.appform.entity.Interview, 
								org.cnio.appform.entity.Section, org.cnio.appform.entity.AnswerItem,
								org.cnio.appform.entity.Question, org.cnio.appform.entity.Text,
								org.cnio.appform.util.HibernateUtil,
								org.cnio.appform.util.HibController" %>


<%-- this is to add/update a section from editsec.jsp page --%>
<%--
  Enumeration params = request.getParameterNames();

  while (params.hasMoreElements()) {
    String paramName = (String) params.nextElement();
    String paramValues[] = request.getParameterValues(paramName);

    if (paramValues.length == 1) {
      out.println(paramName+"="+URLDecoder.decode(paramValues[0], "UTF-8"));
    }
    else {
      out.print(paramName+"=");
      for (int i=0; i < paramValues.length; i++) {
          if (i > 0) 
          		out.print(',');
          out.print(URLDecoder.decode(paramValues[i], "UTF-8"));
      }
      out.println();
    }
  }
--%>
								
<%-- listtypes.jsp --%>
<%
	String intrvId = request.getParameter("intrvId");

	Session hibSes = HibernateUtil.getSessionFactory().openSession();
	Interview intrv = (Interview)hibSes.get(Interview.class, Integer.decode(intrvId));
	List<AnswerItem> answersCol = null;
	if (intrv == null)
		answersCol = HibernateUtil.getAnswerItems(hibSes, (Interview)null);
	else
		answersCol = HibernateUtil.getAnswerItems(hibSes, intrv);
	
//	StringBuilder sb = new StringBuilder();
	
	out.print("[");
	boolean first=false;
	for(AnswerItem aType:answersCol) {
		if(first)
			out.print(",");
		out.print("{\"id\":"+aType.getId()+",\"name\":\""+aType.getName().replace("\"", "\\\"")+"\"}");
		first=true;
	}
	out.print("]");
	hibSes.close();
//out.println("Name:"+name);
	
%>