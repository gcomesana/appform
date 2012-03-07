<%--<?xml version="1.0" encoding="UTF-8" ?> --%>
<%@ page language="java" contentType="text/html;charset=UTF-8"
    pageEncoding="UTF-8"%>
        
<%@page import="org.hibernate.Session, org.hibernate.Transaction,
							  org.hibernate.HibernateException, java.util.Collection, 
								java.util.Iterator, java.util.ArrayList, 
								java.util.Enumeration,
								java.net.URLDecoder, java.net.URLEncoder"  %>
								
<%@page import="org.cnio.appform.entity.AbstractItem, 
								org.cnio.appform.entity.Section, org.cnio.appform.entity.AnswerItem,
								org.cnio.appform.entity.Question, org.cnio.appform.entity.Text,
								org.cnio.appform.entity.QuestionsAnsItems,
								org.cnio.appform.util.HibernateUtil, 
								org.cnio.appform.util.HibController,
								org.cnio.appform.util.IntrvController,
								org.cnio.appform.audit.ActionsLogger" %>


<%-- this is to add/update a section from editsec.jsp page --%>
<%--
  Enumeration params = request.getParameterNames();

  while (params.hasMoreElements()) {
    String paramName = (String) params.nextElement();
    String paramValues[] = request.getParameterValues(paramName);

    if (paramValues.length == 1) {
      out.println(paramName+"="+URLDecoder.decode(paramValues[0], "UTF-8"));
    }
    else {
      out.print(paramName+"=");
      for (int i=0; i < paramValues.length; i++) {
          if (i > 0) 
          		out.print(',');
          out.print(URLDecoder.decode(paramValues[i], "UTF-8"));
      }
      out.println();
    }
  }
--%>
								
								
<%
	String op = request.getParameter("op"),
					t = request.getParameter("t"),
				 ipAddr = request.getRemoteAddr();
	
	Session hibSes = HibernateUtil.getSessionFactory().openSession();
	boolean res = true;
	
	pageContext.setAttribute("t", t);
	pageContext.setAttribute("op", op);
	String jsonStr = "";
	String n="", desc="";
	Integer usrId = (Integer)session.getAttribute("usrid");
	
	if (t.equalsIgnoreCase("prj") || 
			t.equalsIgnoreCase("int") || 
			t.equalsIgnoreCase("sec")) {
		n = URLDecoder.decode(request.getParameter ("frmName"), "UTF-8");
		desc = URLDecoder.decode(request.getParameter ("frmDesc"), "UTF-8");
	}
	
	if (t == null) 
		res = false;
//INSERTION OF A NEW PROJECT
	else {
		ActionsLogger actLogger = new ActionsLogger (hibSes);
		if (t.equalsIgnoreCase("prj")) {
		//	if (op.equalsIgnoreCase("new"))
			String prjCode = URLDecoder.decode(request.getParameter("frmPrjCode"), "UTF-8");
			int newId = HibernateUtil.createProj(hibSes, n, desc, prjCode);
			if (newId != -1) {
				jsonStr = "{\"res\":1}";
				actLogger.logItem(session.getId(), ipAddr, usrId, ActionsLogger.PROJECT, 
													newId, n, ActionsLogger.CREATE);
			}
			else
				jsonStr = "{\"res\":0}";
		}
		
// INSERTION OF A NEW INTERVIEW
// This snippet creates an interview with a section intro and 3 customizable
// items and, besides, assigns the interview to a project. The last part
// is apart from the construction of the interview...
		if (t.equalsIgnoreCase("int")) {
			IntrvController intrvCtrl = new IntrvController (hibSes);
			String spid = request.getParameter ("spid");
			String frmShort = request.getParameter("chkShort"),
						frmCrtSubj = request.getParameter("chkCrtSubj"),
						frmSample = request.getParameter("chkSample");
			
			int newId = 
				intrvCtrl.createInterview(n, desc, Integer.decode(spid), usrId, 
																frmShort, frmCrtSubj, frmSample);
			
			if (res)  {
				jsonStr = "{\"res\":1,\"spid\":"+spid+"}";
				actLogger.logItem (session.getId(), ipAddr, usrId, ActionsLogger.INTERVIEW, 
								newId, n, ActionsLogger.CREATE);
			}
			else
				jsonStr = "{\"res\":0}";
		}
	
// INSERTION OF A NEW SECTION	
		if (t.equalsIgnoreCase("sec")) {
					String spid = request.getParameter("spid");
		//	if (op.equalsIgnoreCase("new"))
			int newId = HibController.SectionCtrl.createSection (hibSes, n, desc, 
																									Integer.decode(spid));
			if (res) {
				jsonStr = "{\"res\":1,\"spid\":"+spid+"}";
				actLogger.logItem (session.getId(), ipAddr, usrId, ActionsLogger.INTERVIEW, 
								newId, n, ActionsLogger.CREATE);
			}
			else
				jsonStr = "{\"res\":0}";
		}

// INSERTION OF A NEW ELEMENT: QUESTION OR TEXT	
		if (t.equalsIgnoreCase("ele")) {
			String isText = request.getParameter("frmChkTxt"),
						content = request.getParameter("frmStmt"),
						container = request.getParameter("frmNewParent"),
						secId = request.getParameter("frmNewSec"),
						secCurId = request.getParameter("frmCurSec"),
						codQues = request.getParameter ("frmCodQues");
			int secParentId=-1, containerId=-1;
			int newId = -1;
			
			String mandatory = request.getParameter("frmMandatory"),
			 		repeat = request.getParameter("frmChkRep"),
			 		bold = request.getParameter("frmChkBold"),
			 		italic = request.getParameter("frmChkItalic"),
			 		underline = request.getParameter ("frmChkUnder");
System.out.println("mandatory: "+mandatory);

			int iMandatory, iRep, iBold, iItalic, iUnder, iHighlight;
			iMandatory = (mandatory == null)? 0: 1;
			iRep = (repeat == null)? 0: 1;
			
			iBold = (bold == null)? 0: AbstractItem.HIGHLIGHT_BOLD;
			iItalic = (italic == null)? 0: AbstractItem.HIGHLIGHT_ITALIC;
			iUnder = (underline == null)? 0: AbstractItem.HIGHLIGHT_UNDERLINE;
			iHighlight = iBold + iItalic + iUnder;
			
// this can be change because it isnt clear whether or not a item will have to
// have a parent section from the beginning or not
			if (secId != null) {
				secParentId = Integer.parseInt(secId);
				pageContext.setAttribute("secid", secParentId);
			}
			else if (secCurId != null) {
				secParentId = Integer.parseInt(secCurId);
				pageContext.setAttribute("secid", secParentId);
			}
			
			
			if (container != null)
				containerId = Integer.parseInt(container);
			
			if (isText != null) { 
				Text txt = HibController.ItemManager.createText(hibSes, content, iHighlight, iRep, 
																						 				secParentId, containerId);
				if (txt == null)
					res = false;
				
				else {
					pageContext.setAttribute("id", txt.getId());
					newId = txt.getId().intValue();
				}
			}
			else { // the part from here is to create a Question item
				
				String[] ansItems = request.getParameterValues("frmAnswers");
				int ansItemsLen = (ansItems == null)? 1: ansItems.length;
				long[] ansItemsId = new long [ansItemsLen];
	
				if (ansItems != null) {
					for (int i=0; i<ansItems.length; i++) 
						ansItemsId[i] = Integer.parseInt(ansItems[i]);
				}
// build the patterns to set along with the new questionsAnsItems
// there has to be as many ranges as ansItemsId with id 101,102
// 100 is reserved for Labels and can be used further
// First, hold the patterns in an arrayList for further retrieving
				ArrayList<String> patterns = new ArrayList<String>();
				int currentRange = 1;
				for (int i=0; i<ansItemsId.length; i++) {
// As the ids for Number, Decimal and Label are different among interviews, 
// in order to know what is the answer type, the id is not enough: we need the
// name to compare the chosen types with the answer types in the DB
					AnswerItem ansIt = (AnswerItem)hibSes.get(AnswerItem.class, ansItemsId[i]);
					String ansItName = ansIt.getName();

					if (ansItName.equalsIgnoreCase(HibController.TYPE_DECIMAL) ||
							ansItName.equalsIgnoreCase(HibController.TYPE_NUMBER)) {
// This loop is to avoid the gaps when ranges are added and removed							
						while (request.getParameter("frmmin"+currentRange) == null)
							currentRange++;
							
						String frmmin = request.getParameter("frmmin"+currentRange);
						frmmin = (frmmin == null || frmmin.length()==0)? "-": frmmin;
						String frmmax = request.getParameter("frmmax"+currentRange);
						frmmax = (frmmax == null || frmmax.length()==0)? "-": frmmax;
						String frmexc = request.getParameter("frmexc"+currentRange);
						frmexc = (frmexc == null || frmexc.length()==0)? "-": frmexc;
						
						String patternRange = frmmin+";"+frmmax+";"+frmexc;
							
						patterns.add(patternRange);
						currentRange++;
					}
				} // EO for
				
// Create the question with the first answer type item			
				Question newQ = 
					HibController.ItemManager.createQuestion(hibSes, content, iHighlight, codQues, 
																				ansItemsId[0], iMandatory, iRep, secParentId, containerId);
	
				if (newQ != null) {
// Store the answer items in database and set the range patterns appropiately
					currentRange = 0;
// Now the rest of answer item types gotta be assigned to the new question
					for (int i=0; i<ansItemsId.length; i++) {
						AnswerItem ai = (AnswerItem)hibSes.get(AnswerItem.class, 
																									 new Long (ansItemsId[i]));
						if (ai != null) {
							int ansItId = ai.getId().intValue();
							String ansItName = ai.getName();
							if (ansItName.equalsIgnoreCase(HibController.TYPE_DECIMAL) ||
									ansItName.equalsIgnoreCase(HibController.TYPE_NUMBER)) {
								HibernateUtil.setFullAnswerType(hibSes, newQ, ai, i+1, 
																								patterns.get(currentRange));
								currentRange++;
							}
							else {
								HibernateUtil.setAnswerType(hibSes, newQ, ai);
								HibernateUtil.setAnswerOrder(newQ, ai, i+1);
							}
						}
					}
					
					pageContext.setAttribute("id", newQ.getId());
					newId = newQ.getId().intValue();
				}
				else
					res = false;
				
			} // is a Question item
			
			if (res) {
				jsonStr = "{\"res\":1,\"spid\":"+secParentId;
				
				if (newId != -1) 
					jsonStr += ",\"frmid\":"+newId+"}";
				else
					jsonStr += "}";
			}
			else
				jsonStr = "{\"res\":0}";
		} // element insertion
	
	hibSes.close();
	out.print(jsonStr);
	}
	
		
		
%>
<%--
{"res":1,"msg":"ok"}
 	{"res":1,"frmid":${id},"msg":"ok","secid":${secid}} -
 	<jsp:forward page="../index.jsp">
		<jsp:param name="res" value="1"/>
		<jsp:param name="op" value ="${op}"/>
		<jsp:param name="t" value="${t}"/>
	</jsp:forward>
%>
	
<%
	}
	else {
%>
{"res":0,"msg":"err"}
	<%--
	<jsp:forward page="../index.jsp">
		<jsp:param name="res" value="0"/>
		<jsp:param name="op" value ="${op}"/>
		<jsp:param name="t" value="${t}"/>
	</jsp:forward>
	-%>
<%
	}
	// pageContext.setAttribute("sections", sectionsCol);
%>

<%-
<jsp:forward page="index.jsp">
		<jsp:param name="res" value="1"/>
	Both ones are redundant!!!
-->		<jsp:param name="op" value="${param.op}"/>
-->		<jsp:param name="t" value="${param.t}" /> 
	</jsp:forward>
--%>