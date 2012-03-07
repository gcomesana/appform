
<%@page import="java.util.Enumeration, java.net.URLDecoder" %>

<%-- {"res":0,"frmid":${id},"msg":"err"} --%>

<%
  Enumeration params = request.getParameterNames();
	String jsonStr = "{";
	
  while (params.hasMoreElements()) {
    String paramName = (String) params.nextElement();
    String paramValues[] = request.getParameterValues(paramName);

    if (paramValues.length == 1) {
			String aux = URLDecoder.decode(paramValues[0], "UTF-8");
			try {
				int i = Integer.parseInt(aux);
				jsonStr += "\""+paramName+"\":"+ i;
			}
			catch (NumberFormatException nfe) {
      	jsonStr += "\""+paramName+"\":\""+aux+"\"";
			}
			jsonStr += ",";
    }
    else {
      
    	for (int i=0; i < paramValues.length; i++) {
    		jsonStr += "\""+paramName+"\":"+URLDecoder.decode(paramValues[i], "UTF-8");
    		jsonStr += ",";
      }
      
    }
  }
  jsonStr = jsonStr.substring(0, jsonStr.length()-1);
	jsonStr += "}";  
  out.print(jsonStr);
%>
