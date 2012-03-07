<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%--
items4sec.jsp?t=sec&frmid=anId
returns all items for the section with id anId in an xml format:
<items>
	<item>
		<id>anId</id>
		<content>content</content>
	</item>
	<item>
		<id>anId</id>
		<content>content</content>
	</item>
	...
</items>
--%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@page import="org.hibernate.Session, java.util.Collection, 
								java.util.Iterator, java.util.ArrayList, 
								java.util.Enumeration"  %>
								
<%@page import="org.cnio.appform.entity.AbstractItem,
								org.cnio.appform.entity.Text, org.cnio.appform.entity.Question, 
								org.cnio.appform.entity.Section, 
								org.cnio.appform.entity.AnswerItem,
								org.cnio.appform.util.HibernateUtil,
								org.cnio.appform.util.HibController" %>
								
								
<%
//{"puppies":[{"name":"Ashley","age":12,"NEWKEY":null},{"name":"Abby","age":9}]} 
	Session hibSes = HibernateUtil.getSessionFactory().openSession();
	String idSec = request.getParameter("frmid");
	
	String xmlOut = "<items>", textOut="", jsonOut="[";
	boolean first = true;
	
	if (idSec != null) {
		Integer crapId = Integer.decode(idSec);
		
		Collection<AbstractItem> itemsCol = 
				HibernateUtil.getItems4Section (hibSes, crapId);
		
		for (AbstractItem item: itemsCol) {
			if (first) 
				first = false;
			else
				jsonOut += ",";
			
			xmlOut += "<item><id>" + item.getId()+"</id><content>"+
								item.getContent()+"</content></item>";
			textOut += "["+item.getId()+"|"+item.getContent()+"]";
			jsonOut += "{\"id\":"+item.getId()+",\"content\":\""+item.getContent()+"\"}";
		}
		jsonOut += "]";
		xmlOut += "</items>";
		
		hibSes.close();
	}
	else
		textOut = "frmid seems to be null";
	
//	out.write(xmlOut);
	out.write(jsonOut);
%>