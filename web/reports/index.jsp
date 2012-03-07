<%-- <?xml version="1.0" encoding="UTF-8" ?> --%>
<%@page language="java" contentType="text/html;charset=UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@page import="org.hibernate.Session, org.hibernate.Transaction,
								org.hibernate.Query,
								 java.util.Collection, 
								java.util.Iterator, java.util.ArrayList, 
								java.util.Enumeration, java.util.List,
								org.json.simple.*"  %>
								
<%@page import="org.cnio.appform.entity.*, 
								org.cnio.appform.util.HibernateUtil,
								org.cnio.appform.util.HibController,
								org.cnio.appform.util.AppUserCtrl,
								org.cnio.appform.util.ReportUtil" %>
<!-- editelem.jsp -->
<%-- editelem.jsp?t=ele&op=new --%>
<%-- editelem.jsp?t=ele&op=new&spid=secId 
		where spid is the id of the parent section --%>
<%-- editelem.jsp?t=ele&op=upd&frmid=id&spid=secId --%>
<%--
Create or edit an element, text or question, assigning its section and element
parent if suitable.  
To set the parents (container and section), the rule so far is gonna be:
- select a section for container
- via ajax (or not) get the questions for that section
so, while the section is not selected, the container has to be disabled
--%>

<%
	Session hibSes = HibernateUtil.getSessionFactory().openSession();
	ReportUtil reporter = new ReportUtil (hibSes);
	List<Object[]> report = null;
	
	Interview myIntrv = (Interview)hibSes.get(Interview.class, 50);
	report = reporter.getQuestionCodes(myIntrv);
%>

<table border="1" style="font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;font-size: 12px;">
	<tr bgcolor="lightgray">
		<td>Cont</td>
		<td>Question Id</td>
		<td><b>Question Cod</b></td>
		<td><b>Section Name</b></td>
	</tr>
<%
if (report != null) {
	int contQs = 0;
	for (Iterator<Object[]> itObj = report.iterator(); itObj.hasNext();) {
		Object[] item = itObj.next();
		contQs++;
		out.print("<td>"+contQs+"</td>");
		for (int i=0; i<item.length-1; i++) {
			if (i == 2)
				continue;
			String msg = "<td>";
			msg += item[i]+"</td>";
			out.println(msg);
		}
		out.println ("</tr>");
	}
}
else {
%>

<td colspan="4">No questions were found</td>

<%
}

hibSes.close();
%>	
</table>
