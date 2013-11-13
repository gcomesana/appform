<%-- 
This page saves the data for a patient (mainly the patient code).
Inserts a row in the performance table/ternary relationship. 
Previously, it checks whether or not this patient has done
this interview before 
--%>

<%@ page language="java" contentType="text/html;charset=UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@page import="org.hibernate.Session, org.hibernate.Query, java.util.Collection, 
								java.util.Iterator, java.util.ArrayList, java.util.List,
								java.util.Enumeration, java.util.Calendar, java.util.Locale,
								java.util.TimeZone, java.text.DateFormat, java.net.URLDecoder"  %>
								
<%@page import="org.apache.commons.lang.StringEscapeUtils" %>								
<%@page import="org.cnio.appform.entity.*,
								org.cnio.appform.util.HibernateUtil,
								org.cnio.appform.util.HibController,
								org.cnio.appform.util.IntrvFormCtrl, 
								org.cnio.appform.util.AppUserCtrl" %>
								
								
<%!
/**
	* Convenient jsp method to save the questions in the introduction section to
	* and interview
	*/
	public void saveFrontQuestions (HttpServletRequest request,
																	Patient newPat, Session ses) {
		boolean res = false;
		IntrvFormCtrl ctrlForm = new IntrvFormCtrl (ses);
		Enumeration<String> params = request.getParameterNames();
		
System.out.println ("Saving/updating front questions..."+params.hasMoreElements());
//The questions on the frontpage are saved.
//It is not possible to display them on the frontpage as there is not patient
//selected, but it can be saved more than once
	 	while (params.hasMoreElements()) {
			String paramName = (String) params.nextElement();
	System.out.println("saveform.jsp: saving..."+paramName);		
			if (paramName.startsWith("q") != true)
				continue; // discard secId and patId
				
	// all params have simple values
			String paramVal = "";
			try {
			  paramVal = request.getParameter(paramName);
				paramVal = URLDecoder.decode (paramVal, "UTF-8");
				paramVal = (paramVal == "")? org.cnio.appform.util.RenderEng.MISSING_ANSWER:
																		paramVal;
			}
			catch (java.io.UnsupportedEncodingException uee) {
				paramVal = (paramVal == "")? org.cnio.appform.util.RenderEng.MISSING_ANSWER:
					paramVal;
			}
			
		// This is to avoid sending a value which was already sent
			if (paramVal.compareTo(org.cnio.appform.util.RenderEng.MISSING_ANSWER) == 0)
				continue;
			
		// paramName structure: q145-1-2-g2, 145 qid, 1 num answer, 2 order answer 
		// g2 the group of the answers. this is necessary when there is a question with
		// undefined number of answers inside a question with undefined number of answers
		// the deepest answers has to be grouped
			paramName = paramName.substring(1); // i get 145-1-2-g2
			String ansParams[] = paramName.split("-"); // i have {145,1,2,g2}
			String qId = ansParams[0];
			Integer ansNumber = Integer.decode(ansParams[1]), 
							ansOrder = Integer.decode(ansParams[2]), ansGroup = null;
			
			if (ansParams.length > 3) { // we have a group
				if (ansParams[3] != null) {
					String aux = ansParams[3].substring(1);
					ansGroup = Integer.decode(aux);
				}
			}
		
		// decoupled? objects... lets see if this works
			Question q = (Question)ses.get(Question.class, Long.decode(qId));
			List<AnswerItem> ansTypes = HibernateUtil.getAnswerTypes4Question(ses, q);
			AnswerItem ansType = ansTypes.get(ansOrder.intValue()-1);
		
		 	Object[] ans = 
		 		ctrlForm.getAnswer4Question(Integer.decode(qId), newPat.getId(),
		 																ansNumber,ansOrder);

		 	if (ans == null) {
System.out.println("savintro.saveFront: saving answer: "+q.getContent()+": "+paramVal);
				res = ctrlForm.saveAnswer(q, newPat, ansNumber, ansOrder, ansGroup, paramVal, ansType);
				if (res == false)
					System.out.println("failed saving asnwer");
		 	}
		 	else {
		// an update of the answer must be done if values are different and not blank
// for (Object obj: ans)
	System.out.println("ans...:"+(Integer)ans[0]);
		
// System.out.println("savintro.saveFront: updating answer: "+q.getContent()+": "+paramVal);
				if (((String)ans[1]).equalsIgnoreCase(paramVal) == false &&
						paramVal.equalsIgnoreCase("") == false) 
					res = ctrlForm.updateAnswer((Integer)ans[0], paramVal);
				
				if (res == false)
					System.out.println ("failed update answer");
		 	}
		} // end while
	
	} // eo saveFrontQuestions
/*****************************************************************************/
%> 
	
	
	
<!-- JSP scriptlet -->
<%
Enumeration<String> params = request.getParameterNames();

while (params.hasMoreElements()) {
  String paramName = (String) params.nextElement();
  String paramValues[] = request.getParameterValues(paramName);
	paramName = URLDecoder.decode (paramName, "UTF-8");
  if (paramValues.length == 1) {
    System.out.println(StringEscapeUtils.unescapeHtml(paramName)+"="+
    						StringEscapeUtils.escapeHtml(paramValues[0]));
  }
  else {
  	System.out.print(paramName+"=");
    for (int i=0; i < paramValues.length; i++) {
        if (i > 0) 
        	System.out.print(',');
//        out.print(URLDecoder.decode (paramValues[i], "UTF-8"));
				System.out.print(StringEscapeUtils.unescapeHtml(paramValues[i]));
    }
    System.out.println();
  }
}

/*****************************************************************************/

Integer intrvId = (Integer)session.getAttribute ("intrvId"),
			  userId = (Integer)session.getAttribute ("usrid"),
			  isLogged = (Integer)session.getAttribute ("logged");
if (isLogged == null || intrvId == null || userId == null) {
	String jsonMsg = "{\"res\":0,\"msg\":\"The session has expired. Log in again\"}";
	out.println(jsonMsg);
	
	return;
}


String patCode = request.getParameter ("patcode"), fullPatCode = "",
			 hospCode = request.getParameter("hospCod"),
			 prjCode = request.getParameter("prjCod"),
			 typeCode = request.getParameter("typecod"),
			 place = "",
			 finish = request.getParameter("finish"),
			 ipAddr = request.getRemoteAddr(),
			 jspSesId = request.getSession().getId();

fullPatCode = prjCode+hospCode+typeCode+patCode;

// set the place if exists!!!
while (params.hasMoreElements()) {
  String paramName = (String) params.nextElement();
  String paramValues[] = request.getParameterValues(paramName);
	paramName = URLDecoder.decode (paramName, "UTF-8");
/*	
  if (paramName.startsWith("q")) {
    place = URLDecoder.decode(paramValues[0], "UTF-8");
    break;
  }
*/
System.out.println ("paramName: "+paramName);
	for (String val: paramValues)
		System.out.print(val+",");
System.out.println();
}


Session ses = HibernateUtil.getSessionFactory().openSession();
IntrvFormCtrl ctrlForm = new IntrvFormCtrl (ses);
boolean res = true;
Patient newPat;

// ESTO PUEDE PETAR, OJO!!!!!!!!!!!, PUEDE HACER FALTA INCLUIR EL GRUPO
Performance perf = ctrlForm.getPerformance(fullPatCode, intrvId, userId, jspSesId, ipAddr);
if (perf == null) {
	 perf = ctrlForm.savePerformance(userId, jspSesId, ipAddr, intrvId, fullPatCode, place);
	 newPat = ctrlForm.getPatientFromCode(fullPatCode);
}

// This is a control to be sure the performance history is logged
boolean historyDone = false;
if (perf != null) {
	AppUser user = (AppUser)ses.get(AppUser.class, userId);
	historyDone = ctrlForm.setCurrentPerfUser(user, perf);
}

//If this patient already is in db and history was successful, 
//then retrieve it and set the session variables for it: patId and currentSec
if (historyDone) {
	Integer lastSec = perf.getLastSec ();
	session.setAttribute ("lastSec", lastSec);
System.out.println("saveintro - patCode & lastSec: "+fullPatCode+" & "+lastSec);
	newPat = ctrlForm.getPatientFromCode(fullPatCode);
// out.println("patCode: "+patCode);
	session.setAttribute ("patId", newPat.getId());
	session.setAttribute ("currentSec", 2);
	
	saveFrontQuestions (request, newPat, ses);
	
	if (finish.equalsIgnoreCase("1")) {
		session.removeAttribute ("patId");
		session.removeAttribute ("lastSec");
		ses.close ();

// Log for interview pause
%>
	<jsp:include page="items4sec.jsp"/>
<%
	}
	else { // not finish
		session.setAttribute ("patId", newPat.getId());
		pageContext.setAttribute ("patId", newPat.getId());
		
// Access to the sections is done with currentSec-1 because the List index
// starts with 0
		List<Integer> lSecs = (List<Integer>)session.getAttribute ("sectionIds");
//		pageContext.setAttribute ("secId", (Integer)lSecs.get(currentSec));
		pageContext.setAttribute ("secId", (Integer)lSecs.get(1));
	
//		session.setAttribute ("currentSec", currentSec+1);
		ses.close();
// System.out.println("saveintro:currentSec = "+session.getAttribute ("currentSec"));		
%>
<%-- hay que ver si esto de incluir la pagina funciona --%>
<%-- hay que devolver, en caso de error, un gurruño con un mensaje --%> 

	<jsp:include page="items4sec.jsp">
		<jsp:param name="patid" value="${patId}"/>
		<jsp:param name="frmid" value="${secId}"/>
	</jsp:include>
<%
	}
} // perf != null
else {
	String msg;
	msg = ctrlForm.getErrMsg();
	out.println ("{\"ok\":0,\"msg\":\""+msg+"\"}");
}

%>