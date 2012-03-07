<?xml version="1.0" encoding="ISO-8859-1" ?>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
<title>Insert title here</title>
</head>
<body>

<jsp:useBean id="listIds" class="org.cnio.pangenes.bean.DBPatientBean" 
			 scope="session" />

<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.Enumeration" %>
<%
Hashtable<String,Integer> theList = listIds.getPatientIds();
Enumeration<String> en = theList.keys(); 
int listSize = theList.size();

out.print("So, the number of patients is: " + listSize);
%>
<form method="get" id="frmIds">
<select id="ids">

<%
while (en.hasMoreElements()) {
	String k = (String)en.nextElement();
%>
<option value="<%= theList.get(k) %>"><%= k %></option>
<%
}
%>
</select>
</form>

<%--

Results:<br/>
Name: <= patient.getName() ><br/>
Id: <= patient.getId() >
<hr />
... and with EL:<br/>
Name: {patient.name}<br/>
Id: {patient.id}
<hr/>
Se fine

--%>

</body>
</html>