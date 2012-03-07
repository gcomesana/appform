<%--<?xml version="1.0" encoding="UTF-8" ?> --%>
<%@ page language="java" contentType="text/html;charset=UTF-8"
    pageEncoding="UTF-8"%>
        
<%@page import="org.hibernate.Session,
				org.hibernate.Transaction,
				org.hibernate.criterion.Restrictions,
							  org.hibernate.HibernateException, java.util.Collection, 
								java.util.Iterator, java.util.ArrayList, 
								java.util.Enumeration, java.util.Hashtable,
								java.net.URLDecoder"  %>
<%@page import="org.cnio.appform.entity.AbstractItem, 
								org.cnio.appform.entity.Section,
								org.cnio.appform.entity.AnswerItem,
								org.cnio.appform.entity.EnumItem,
								org.cnio.appform.entity.EnumType,
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
								
<%-- newtype.jsp?typename=name&elements=key 1@val1,key 2@val2,... --%>
<%
	Long id = Long.decode(URLDecoder.decode(request.getParameter("typeid"), "UTF-8"));
	Session hibSes = HibernateUtil.getSessionFactory().openSession();
//	Collection<EnumType> typesCol = hibSes.createCriteria(EnumType.class).add(Restrictions.eq("id", id)).list();
//	EnumType myType = typesCol.iterator().next();
	Transaction tx = null;
	boolean isType4Question = HibController.EnumTypeCtrl.isType4Question(hibSes, id);
	if (isType4Question)
		out.print("{\"res\":2}".trim());
	
	else {
		try {
			tx = hibSes.getTransaction();
			tx = (!tx.isActive())? hibSes.beginTransaction(): tx;
			
			EnumType myType = (EnumType)hibSes.get(EnumType.class, id);
			hibSes.delete(myType);
			tx.commit();
			out.print("{\"res\":1}".trim());
		} 
		catch(HibernateException he) {
			if (tx != null)
				tx.rollback();
			out.print("{\"res\":0}".trim());
		} 
		finally {
			hibSes.close();
		}
	}
	
//out.println("Name:"+name);
	
%>