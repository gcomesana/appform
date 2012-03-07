<%-- 
This page saves the data for a patient. Inserts a row in the performance table/
ternary relationship. Previously, it checks whether or not this patient has done
this interview before 
--%>

<%@ page language="java" contentType="text/html;charset=UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@page import="org.hibernate.Session, java.util.Collection, 
								java.util.Iterator, java.util.ArrayList, java.util.List,
								java.util.Enumeration, java.util.Calendar, java.util.Locale,
								java.util.TimeZone, java.text.DateFormat, java.net.URLDecoder,
								javax.servlet.http.HttpUtils"  %>
								
<%@page import="org.apache.commons.lang.StringEscapeUtils" %>								
<%@page import="org.cnio.appform.entity.*,
								org.cnio.appform.util.HibernateUtil, org.cnio.appform.util.LogFile,
								org.cnio.appform.util.HibController, org.cnio.appform.audit.ActionsLogger,
								org.cnio.appform.util.IntrvFormCtrl" %>
<%@page import="org.cnio.appform.util.SaveAnswers"%>								
	
<%-- 
saveform.jsp

  Enumeration<String> reqParams = request.getParameterNames();

	int ka = 0;
  while (reqParams.hasMoreElements()) {
    String paramName = (String) reqParams.nextElement();
    String paramValues[] = request.getParameterValues(paramName);

    if (paramValues.length == 1) {
      System.out.println(paramName+"="+paramValues[0]);
      if (paramName.startsWith("q")) {
      	paramName = paramName.substring(1, paramName.length());
      	String[] parts = paramName.split("-");
      	String msg = "QuestionCoords qc"+ka+" = QuestionCoords ("+parts[0]+","+parts[1]+","+parts[2]+");";
      	System.out.println (msg);
      	if (paramValues[0].length() > 0)
      		System.out.println ("qc"+ka+".ansVal = \""+paramValues[0]+"\";");
      }
      
    }
    else {
      System.out.print(paramName+"=");
      for (int i=0; i < paramValues.length; i++) {
          if (i > 0) 
          	System.out.print(',');
          System.out.print(paramValues[i]);
      }
      System.out.println();
    }
    System.out.println ("listParams.add(qc"+ka+");");
    ka++;
  }
--%>


<%



/*
Enumeration<String> myparams = request.getParameterNames();
while (myparams.hasMoreElements()) {
  String paramName = (String) myparams.nextElement();
  String paramValues[] = request.getParameterValues(paramName);
	paramName = URLDecoder.decode (paramName, "UTF-8");
  if (paramValues.length == 1) {
    System.out.println(paramName+"="+URLDecoder.decode (paramValues[0], "UTF-8"));
  }
  else {
    System.out.print(paramName+"=");
    for (int i=0; i < paramValues.length; i++) {
        if (i > 0) 
        	out.print(',');
        System.out.print(URLDecoder.decode (paramValues[i], "UTF-8"));
    }
    System.out.println();
  }
}
*/




Enumeration<String> params = request.getParameterNames();
Integer intrvId = (Integer)session.getAttribute ("intrvId"),
				grpId = (Integer)session.getAttribute ("secondaryGrpId"),
				userId = (Integer)session.getAttribute ("usrid"),
				isLogged = (Integer)session.getAttribute ("logged"),
				currentSec = (Integer)session.getAttribute ("currentSec");

if (isLogged == null || intrvId == null || userId == null) {
	String jsonMsg = "{\"res\":0,\"msg\":\"The session has expired. Log in again\"}";
	out.println(jsonMsg);

	return;
}


String secId = request.getParameter ("secId"),
			 patId = request.getParameter ("patId"),
			 finish = request.getParameter("finish"),
			 ipAddr = request.getRemoteAddr(),
			 jspSesId = request.getSession().getId();

Session ses = HibernateUtil.getSessionFactory().openSession();
Patient pat = (Patient)ses.get(Patient.class, Integer.decode(patId));
IntrvFormCtrl formCtrl = new IntrvFormCtrl(ses);
boolean res = true;

// this is the real time param. if set, there will be nothing to save
String rtParam = (String)session.getAttribute("rt");
pageContext.setAttribute("rtParam", rtParam);
pageContext.setAttribute ("patId", patId);

// checking roles
// The coordinator role is set, no matter what kind of coordinator, as opposite
// the admin, interviewer or editor roles
String roles = (String)session.getAttribute("roles");
boolean coordinatorRole = false;
if ((roles.indexOf("editor") == -1) && (roles.indexOf("admin") == -1) &&
		(roles.indexOf("interviewer") == -1)) {
	coordinatorRole = true;
}

// conditions to save:
// not to be working on autosaving and -> removed!!!!
// to have a admin, editor or interviewer role   
// if ((rtParam == null || !rtParam.equalsIgnoreCase("1")) && !coordinatorRole) {
if (!coordinatorRole) {
	
	SaveAnswers saveAns = new SaveAnswers (ses);
	saveAns.decodeParams(request);
System.out.println ("saveform.jsp: saveAns.getQuestions4Section ("+
			intrvId+", "+(currentSec+1)+", "+pat==null? "pat is null": pat.getCodpatient()+")");
	saveAns.getQuestions4Section(intrvId, (currentSec+1), pat.getCodpatient());
	saveAns.saveOrUpdateSectionAnswers(Integer.decode(patId));
	
	
/*
// walk along the form to get the answers
	while (params.hasMoreElements()) {
		String paramName = (String) params.nextElement();
// System.out.println("saveform.jsp: saving..."+paramName+":"+ request.getParameter(paramName));

// This is to save the justification for this hypothetical short interview
		if (paramName.equalsIgnoreCase(IntrvFormCtrl.JUSTIFICATION_NAME)) {
			String paramVal = request.getParameter(paramName);
			String justification = URLDecoder.decode(paramVal, "UTF-8");
			PerfUserHistory puh = formCtrl.getPerformanceFromIntrv(pat.getId(), intrvId);
			res = formCtrl.justifyShortPerf(puh, justification);
			if (res)
				continue;
			else
				break;
		}

		if (paramName.startsWith("q") != true)
			continue; // discard secId and patId
			
// all params have simple values	
	  String paramVal = request.getParameter(paramName);
		paramVal = URLDecoder.decode (paramVal, "UTF-8");
		paramVal = (paramVal == null || paramVal.equalsIgnoreCase(""))? 
								org.cnio.appform.util.RenderEng.MISSING_ANSWER: paramVal;
				
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
	// out.print("question: "+qId+"-"+ansNumber+"-"+ansOrder+"="+paramVal);	
	
	// decoupled? objects... lets see if this works
		Question q = (Question)ses.get(Question.class, Long.decode(qId));
		List<AnswerItem> ansTypes = HibernateUtil.getAnswerTypes4Question(ses, q);
		AnswerItem ansType = ansTypes.get(ansOrder.intValue()-1);
	// out.print("ansType: " + ansType.getName()+"<br>");
	
//		synchronized (IntrvFormCtrl.THE_LOCK) {
		 	Object[] ans = 
		 		formCtrl.getAnswer4Question(Integer.decode(qId), Integer.decode(patId),
		 																ansNumber,ansOrder);
	
	// System.out.println("answer for qId: "+qId+";n: "+ansNumber+";o:"+ansOrder+" is "+ans);
		 	if (ans == null) {
	// System.out.println("no answer for idq: "+qId+";number: "+ansNumber+";order: "+ansOrder);	
				res = formCtrl.saveAnswer(q, pat, ansNumber, ansOrder, ansGroup, paramVal, ansType);
				if (res == false)
					break;
		 	}
		 	else {
		// an update of the answer must be done if values are different
	//			if (((String)ans[1]).equalsIgnoreCase(paramVal) == false)
				if (((String)ans[1]).compareTo(paramVal) != 0)
					res = formCtrl.updateAnswer((Integer)ans[0], paramVal);
				
				if (res == false)
					break;
		 	}
//		} // synchronized!! 
		
		
	} // end WHILE (param.elements()) 
	
*/
} // end if not coordinator role

	
// Left side sections stuff, this is to get the next section questions and 
// light the next section up on the left side
// Integer currentSec = (Integer)session.getAttribute ("currentSec");
currentSec = (currentSec == null)? 0: currentSec;

ActionsLogger logDb = new ActionsLogger (ses);
if (res) { // everything was ok, save the last section and get the next form 

	currentSec++;
	session.setAttribute ("currentSec", currentSec);
	Integer lastSec = (Integer)session.getAttribute("lastSec");
	lastSec = lastSec == null? 1: lastSec;
	List<Integer> secIds = (List<Integer>)session.getAttribute ("sectionIds");
	
// System.out.println("saveform: secIds.size="+secIds.size()+"; lastSec-1="+(lastSec-1));	
	Integer lastSecInt = secIds.get(Math.min(secIds.size()-1,lastSec-1));
	Section completedSec = (Section)ses.get(Section.class, lastSecInt);
	
// System.out.println("saveform before saving: lastSec="+lastSec+"; currentSec="+currentSec);
// In order to set the correct last section session attribute, this one have to 
// be equals to the current section
	if (currentSec > lastSec) {
		Performance perf = 
			formCtrl.getPerformance(pat.getCodpatient(), intrvId, userId, "", "");

		if (perf != null) 
			formCtrl.setLastSec(pat.getCodpatient(), intrvId, userId, currentSec);
		
		session.setAttribute ("lastSec", currentSec);
	}
	
// Finishing/pausing interview
	List<Integer> lSecs = (List<Integer>)session.getAttribute ("sectionIds");
	Interview intrv = (Interview)ses.get(Interview.class, intrvId);
	String intrvName = intrv.getName(), patCode = pat.getCodpatient();
	AppUser user = (AppUser)ses.get(AppUser.class, userId);
	
// The interview is finished when the user wants or when the current section
// is the last section. The current section is the order of the section
	if (finish.equalsIgnoreCase("1") || (currentSec >= lSecs.size())) {
String myMsg = "Finish is "+finish+" :: URI: "+ HttpUtils.getRequestURL(request).toString();
System.out.println (myMsg);
		
// Here we have to log the end/interruption of the interview
		String msgLog;
		if (currentSec >= lSecs.size())
			msgLog = "User '"+user.getUsername()+"': Interview performance'"+
								intrvName+"' ("+intrvId+") finished for patient '";
		else
			msgLog = "User '"+user.getUsername()+"': Interview performance'"+
								intrvName+"' ("+intrvId+") interrupted for patient '";
			
		msgLog += patCode+"'";
		logDb.customLog (jspSesId, ipAddr, userId, intrvName, msgLog);
		ses.close ();
		
		session.removeAttribute ("patId");
		session.removeAttribute ("currentSec");
		session.removeAttribute ("lastSec");
		
		LogFile.info (msgLog);
//		session.removeAttribute ("sectionIds");
		String msg = "Interview was finished/stopped successfully";
		String jsonSes = "";
		if (request.getRequestedSessionId() != null && request.isRequestedSessionIdValid())
			jsonSes = "\"sessionExpired\":0";
		else
			jsonSes = "\"sessionExpired\":1";
		out.print ("{\"res\":1,\"intrv\":"+intrvId+",\"rt\":"+rtParam+",\"msg\":\""+
			msg+"\","+jsonSes+"}");

%>
<%-- with the msg param is possible to difference the end of a interview --%>
<%-- <jsp:param name="msg" value="<%= msgLog %>" /> 
	<jsp:include page="items4sec.jsp">
		<jsp:param name="intrv_end" value="1" />
	</jsp:include>
--%>
<%		
	}
	else { // NO finish
//		currentSec++;
//		session.setAttribute ("currentSec", currentSec);	
		pageContext.setAttribute ("secId", lSecs.get(currentSec));
		String msgLog = "User '"+user.getUsername()+"': Interview performance'"+
					intrvName+"' ("+intrvId+"). Section  '"+
					completedSec.getName()+"' was completed for patient '"+patCode+"'";
		
		logDb.customLog (jspSesId, ipAddr, userId, intrvName, msgLog);
	//	session.setAttribute ("currentSec", currentSec+1);
	
		if (ses.isOpen()) 
			ses.close ();
// System.out.println("saveform: currentSec = "+session.getAttribute ("currentSec"));	
%>
<%-- hay que ver si esto de incluir la pagina funciona --
%-- hay que devolver, en caso de error, un gurruño con un mensaje --%>
	
<jsp:include page="items4sec.jsp">
		<jsp:param name="patid" value="${patId}"/>
		<jsp:param name="frmid" value="${secId}"/>
	</jsp:include>
<%
	} // EO else NO finish
}
else { // res is false, something was wrong
	String msg = "Unabe to write answers or patient is missing. Use the normal procedure to complete the form";
	out.println ("{\"res\":0,\"msg\":\""+msg+"\"}");
}

%>
