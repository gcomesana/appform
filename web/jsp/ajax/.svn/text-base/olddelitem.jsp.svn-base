<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
        
<%@page import="org.hibernate.Session, org.hibernate.Transaction,
							  org.hibernate.HibernateException, java.util.Collection, 
								java.util.Iterator, java.util.ArrayList, 
								java.util.Enumeration"  %>
								
<%@page import="org.cnio.appform.entity.AbstractItem, 
								org.cnio.appform.entity.Question,
								org.cnio.appform.entity.Section,
								org.cnio.appform.entity.Interview,
								org.cnio.appform.entity.Project, 
								org.cnio.appform.util.HibernateUtil,
								org.cnio.appform.util.HibController" %>


<%-- this is to add/update a section from editsec.jsp page --%>
 
<%--
Enumeration theParams = request.getParameterNames();

while (theParams.hasMoreElements()) {
  String paramName = (String) theParams.nextElement();
  String paramValues[] = request.getParameterValues(paramName);

  if (paramValues.length == 1) {
      out.println(paramName+"="+paramValues[0]);
  }
  else {
      out.print(paramName+"=");
      for (int i=0; i < paramValues.length; i++) {
          if (i > 0) 
          		out.print(',');
          out.print(paramValues[i]);
      }
      out.println();
  }
}
<!-- delitem.jsp?t=sec&op=del&frmid=id, t can be ele, sec, ... -->

--%>
								

<%
	String op = request.getParameter("op"),
					t = request.getParameter("t"),
					id = request.getParameter("frmid"), msgOut = "err",
					jsonOut= "", sons="";
	
	Session hibSes = HibernateUtil.getSessionFactory().openSession();
	boolean res = false;
	Transaction tx = null;
	
	try {
		hibSes.getTransaction();
		tx = (tx == null || !tx.isActive())? hibSes.beginTransaction(): tx;
		
		if (t.equalsIgnoreCase("sec")) { 
			Section sec = (Section)hibSes.get(Section.class, Integer.decode(id));
			hibSes.delete(sec);
			msgOut = "ok";
			res = true;
		}
// DELETING AN ELEMENT, CONTAINEES INCLUDED		
		else if (t.equalsIgnoreCase("ele")) {

			AbstractItem it = 
				(AbstractItem)hibSes.get(AbstractItem.class, Long.decode(id));
// I gotta delete the sons before deleting the container object
			sons=(it.getContainees().size() > 0)? ",\"sons\":\"": "";
			for (int i=it.getContainees().size(); i>0 ; i--) {
				AbstractItem son = it.getContainees().get(i-1);
				son.setContainer(null);
				
				sons += son.getId()+",";
			}
				
			sons = sons.equalsIgnoreCase("")? "": 
											sons.substring(0, sons.length()-1)+"\"";
			it.removeContainees();
			tx.commit();

			tx.begin();
// out.print (it.getId()+".-"+it.getContent());
			if (it instanceof Question) {
				if (((Question)it).getMandatory () == 0) {
					hibSes.delete(it);
					msgOut = "ok";
					res = true;
				}
				else  { // mandatory = 1, so the question is considered as MANDATORY
					msgOut = "The Question can not be deleted";
					res = false;
				}
			}
			else {
				hibSes.delete(it);
				msgOut = "ok";
				res = true;
			}
			
		}
		
		else if (t.equalsIgnoreCase("prj")) {
// out.print("about to delete ele with frmid:"+id);			
			Project it = 
				(Project)hibSes.get(Project.class, Integer.decode(id));
// out.print (it.getId()+".-"+it.getContent());

			hibSes.delete(it);
			res = true;
			msgOut = "ok";
		}
		
		else if (t.equalsIgnoreCase("int")) {
// out.print("about to delete ele with frmid:"+id);			
			Interview it = 
				(Interview)hibSes.get(Interview.class, Integer.decode(id));
// out.print (it.getId()+".-"+it.getContent());

			hibSes.delete(it);
			msgOut = "ok";
			res = true;
		}
		// else whatever
		
		tx.commit();
	}
	catch (HibernateException hibEx) {
		if (tx != null)
			tx.rollback();
// hibEx.printStackTrace();		
		msgOut = hibEx.getMessage();
		res = false;
	}
	hibSes.close();
	
	if (res) 
		jsonOut = "{\"res\":1,\"frmid\":"+id+",\"msg\":\""+msgOut+"\""+sons+"}";
		
	else
		jsonOut = "{\"res\":0,\"frmid\":"+id+",\"msg\":\""+msgOut+"\"}";
	
	out.print(jsonOut);
%>

<%--
 	<jsp:forward page="index.jsp">
		<jsp:param  name="res" value="1"/>
	</jsp:forward>
	
%
	}
	else {
		
	}
%
%--
		<jsp:forward page="index.jsp">
			<jsp:param name="res" value="0"/>
		</jsp:forward>
%
	}
	// pageContext.setAttribute("sections", sectionsCol);
%
%-
 	<jsp:forward page="index.jsp">
		<jsp:param  name="res" value="1"/>
These next two parameters are not included because would be redundant!!!!		
	->	<jsp:param name="op" value="${param.op}"/>
	->	<jsp:param name="t" value="${param.t}" /> 
	</jsp:forward>
--%>