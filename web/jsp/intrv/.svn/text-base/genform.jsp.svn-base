<!-- **************** START CONTENT AREA (REGION b)**************** -->
<%@ page language="java" contentType="text/html;charset=UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@page import="org.hibernate.Session, java.util.Collection, 
								java.util.ArrayList, 
								java.util.Enumeration,
								org.apache.commons.lang.StringEscapeUtils
								"  %>
								
<%@page import="org.cnio.appform.entity.AbstractItem,
								org.cnio.appform.entity.Text, org.cnio.appform.entity.Question, 
								org.cnio.appform.entity.Section, 
								org.cnio.appform.entity.AnswerItem,
								org.cnio.appform.entity.EnumItem,
								org.cnio.appform.entity.AnswerType,
								org.cnio.appform.entity.EnumType,
								org.cnio.appform.util.HibernateUtil,
								org.cnio.appform.util.HibController" %>	
<%
	Session hibSes = HibernateUtil.getSessionFactory().openSession();
	
	String strIdSec = request.getParameter("secid"),
				 strIdIntr = request.getParameter("intrid"); // for the interview
	
	Collection<AbstractItem> itemCol = 
			HibernateUtil.getItems4Section(hibSes, Integer.decode(strIdSec));
				 
//	pageContext.setAttribute("items", itemCol);

// si instanceof Text, escribirlo
// si instanceof Question, montar un item de formulario
	for(AbstractItem ai: itemCol) {
		if(ai instanceof Text) {
			out.print(StringEscapeUtils.escapeHtml(ai.getContent())+"<br>");
		} else if(ai instanceof Question) {
			Collection<AnswerItem> cai = HibernateUtil.getAnswerTypes4Question(hibSes,ai);
			for(AnswerItem ansi: cai) {
				if(ansi instanceof AnswerType) {
					AnswerType anst=(AnswerType)ansi;
					out.print(StringEscapeUtils.escapeHtml(ai.getContent())+"&nbsp;<input type='text' name='q"+ai.getId()+"-"+ansi.getAnswerOrder()+"' onblur='chk."+anst.getName()+"'></input><br>");
				} else if(ansi instanceof EnumType) {
					Collection<EnumItem> ceni = HibController.EnumTypeCtrl.getEnumItems(hibSes,(EnumType)ansi);
					out.print(StringEscapeUtils.escapeHtml(ai.getContent())+"&nbsp;<select name='q"+ai.getId()+"-"+ansi.getAnswerOrder()+"'>");
					for(EnumItem eni: ceni) {
						out.print("<option value='"+eni.getId()+"'>"+StringEscapeUtils.escapeHtml(eni.getName())+"</option>");
					}
					out.print("</select><br>");
				} else {
					out.print("ERROR: Not implemented case -&gt: "+StringEscapeUtils.escapeHtml(ansi.getName())+"<br>");
				}
			}
		} else {
			// Caso imposible
			out.print("ERROR: Not implemented case -&gt: "+StringEscapeUtils.escapeHtml(ai.getContent())+"<br>");
		}
	}
	
%>

