<?xml version="1.0" encoding="UTF-8" ?>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
    
    
<%
pageContext.setAttribute("msg", "<b>Hola pueblo</b>");
String appname = request.getContextPath();
String hostname = request.getServerName();
pageContext.setAttribute ("redir", "http://"+hostname+":8080/"+appname+"/jsp/index.jsp");
// response.sendRedirect(request.getContextPath() + "/web/jsp/index.jsp");

String redir = "web/jsp/index.jsp";
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
<META HTTP-EQUIV=REFRESH CONTENT="0; URL=<%= redir %>">

<title></title>
</head>
</body>
</html>