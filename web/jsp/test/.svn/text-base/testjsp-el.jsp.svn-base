<?xml version="1.0" encoding="ISO-8859-1" ?>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
<title>Insert title here</title>
</head>
<body>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%--
<jsp:useBean id="patient" scope="session" 
						 class="org.cnio.pangenes.bean.PatientBean" />
<jsp:setProperty name="patient" property="name" value="Eufrasi" />
<jsp:setProperty name="patient" property="id" value="328965" />
--%>
<c:set var="myresults" value="${listIds.ids}"/>
						 
<%--
<c:set var="myHash" value="${listIds.patientIds}"/>
<c:set var="theMap" value="${myHash}"/>
--%>

<%--
Hashtable<String,Integer> theList = listIds.getPatientIds();
Enumeration<String> en = theList.keys(); 
int listSize = theList.size();

out.print("So, the number of patients is: " + listSize);
--%>
<c:set var="typeName" value="Number" />
<%--test="${fn:containsIgnoreCase(name, searchString)==true}" --%>
<c:set var="subName" value="mber" />
<c:set var="lenNumber" value="${fn:length(subName)}" />
${lenNumber}<br>

<c:set var="numberComp" value="${fn:containsIgnoreCase(typeName, subName)}" />
${numberComp}<br>


<c:if test="${fn:containsIgnoreCase(typeName,subName)}">
	<c:set var="chkRange" value="formCtrl.chkRange('N', this)"/>
</c:if> 
<c:if test="${fn:containsIgnoreCase(typeName,subName)}">
	<c:set var="chkRange" value="formCtrl.chkRange('D', this)"/>
</c:if>

<c:out value="${chkRange}" />
<%--
<c:forEach begin="0" end="${sapIds.elementCount}" var="i">
	<option val="${dbIds[i]}">${sapIds[i]}</option>
</c:forEach>
--%>
<%--
while (en.hasMoreElements()) {
	String k = (String)en.nextElement();

<option value="%= theList.get(k) %">%= k %</option>
%
}
--%>
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