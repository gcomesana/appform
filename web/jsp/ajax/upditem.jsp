
<%@ page language="java" contentType="text/html;charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
        
<%@page import="org.hibernate.Session, org.hibernate.Transaction,
							  org.hibernate.HibernateException, java.util.Collection, 
								java.util.Iterator, java.util.ArrayList, 
								java.util.Enumeration, java.util.List,
								java.net.URLDecoder, java.net.URLEncoder"  %>
								
<%@page import="org.cnio.appform.entity.AbstractItem, 
				org.cnio.appform.entity.Section, org.cnio.appform.util.HibernateUtil, 
				org.cnio.appform.util.HibController, org.cnio.appform.entity.AnswerItem,
				org.cnio.appform.entity.Text, org.cnio.appform.entity.Question,
				org.cnio.appform.entity.Project, org.cnio.appform.entity.Interview,
				org.cnio.appform.entity.QuestionsAnsItems,
				org.cnio.appform.audit.ActionsLogger, org.cnio.appform.util.LogFile" %>


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
  
/**	
	else if (op.equalsIgnoreCase ("upd")) { // update section based on id
		String theId = request.getParameter("frmListSecs");
		
		Transaction tx = hibSes.getTransaction();
		tx = (!tx.isActive())? hibSes.beginTransaction(): tx;
		
		try {
			Section sec = (Section)hibSes.get(Section.class, Integer.decode(theId));
			
			if (!sec.getName().equals(n))
				sec.setName(n);
			
			if (!sec.getDescription().equals(desc))
				sec.setDescription(n);
			
			tx.commit();
			res = true;
		}
		catch (HibernateException hibEx) {
			if (tx != null)
				tx.rollback();
			
			hibEx.printStackTrace();
			res = false;
		}
	}
*/


--%>
							
								
<%
	String op = request.getParameter("op"),
					t = request.getParameter("t"),
				theId = request.getParameter("frmid"),
				errMsg = "", jsonStr="",
				ipAddr = request.getRemoteAddr();
	
	Session hibSes = HibernateUtil.getSessionFactory().openSession();
	boolean res = true, modified = false;
	int what = -1;
	
	Transaction tx = null;
//	Transaction tx = hibSes.beginTransaction();
	pageContext.setAttribute("parentid", null);
	try {
		pageContext.setAttribute("id", theId);		
		String n="", desc="";
		
// String to message the question code changing in a clone and, at the time
// a switch to set whether or not this is a changed qCode clone
		String changedCodeMsg = "";
	
		tx = hibSes.getTransaction();
		tx = (!tx.isActive())? hibSes.beginTransaction(): tx;
		
		ActionsLogger actLogger = new ActionsLogger (hibSes);
		
		if (t.equalsIgnoreCase("prj") || t.equalsIgnoreCase("int") || 
				t.equalsIgnoreCase("sec")) {
			n = URLDecoder.decode(request.getParameter ("frmName"), "UTF-8");
			desc = URLDecoder.decode(request.getParameter ("frmDesc"), "UTF-8");
		}
		
// PROJECT UPDATE		
		if (t.equalsIgnoreCase("prj")) {
			
			Project prj = (Project)hibSes.get(Project.class, Integer.decode(theId));
			String prjCode = URLDecoder.decode(request.getParameter("frmPrjCode"), "UTF-8");
			if (prj != null) {
				if (!prj.getName().equals(n))
					prj.setName(n);
				
				if (!prj.getDescription().equals(desc))
					prj.setDescription(desc);
				
				prj.setProjectCode(prjCode);
				
//				tx.commit();
				modified = true;
				res = true;
				what = ActionsLogger.PROJECT;
			}
			else
				res = false;
		}
		
// INTERVIEW UPDATE		
		if (t.equalsIgnoreCase("int")) {
			Interview intr = (Interview)hibSes.get(Interview.class, Integer.decode(theId));
			
			if (intr != null) {
				if (!intr.getName().equals(n))
					intr.setName(n);
				
				if (!intr.getDescription().equals(desc))
					intr.setDescription(desc);
				
				Integer shortEnable = Boolean.parseBoolean(request.getParameter("chkShort"))? 1: 0;
				Integer canCrtSubj = Boolean.parseBoolean(request.getParameter("chkCrtSubj"))? 1: 0;
				Integer isSample = Boolean.parseBoolean(request.getParameter("chkSample"))? 1: 0;
System.out.println("shortEnable: "+shortEnable+"; createSubj: "+canCrtSubj);

				if (intr.getCanShorten() != shortEnable)
					intr.setCanShorten(shortEnable);
				
				if (intr.getCanCreateSubject() != canCrtSubj)
					intr.setCanCreateSubject(canCrtSubj);
				
				if (intr.getIsSampleIntrv() != isSample)
					intr.setIsSampleIntrv(isSample);
				
				Project prj = intr.getParentProj();
				pageContext.setAttribute("parentid", prj.getId());
//				tx.commit();
				modified = true;
				res = true;
				what = ActionsLogger.INTERVIEW;
			}
			else
				res = false;
		}

// SECTION UPDATE	
		if (t.equalsIgnoreCase("sec")) {
			Section sec = (Section)hibSes.get(Section.class, Integer.decode(theId));
			
			if (sec != null) {
				if (!sec.getName().equals(n))
					sec.setName(n);
				
				if (!sec.getDescription().equals(desc))
					sec.setDescription(desc);
				
				Interview intr = sec.getParentIntr();
				pageContext.setAttribute("parentid", intr.getId());
//				tx.commit();
				modified = true;
				res = true;
				what = ActionsLogger.SECTION;
			}
			else
				res = false;
		}
		
// ABSTRACTITEM UPDATE
// Everything on editelem.jsp can be updated except the item type (multiple,
// repeatable and text)
		else if (t.equalsIgnoreCase("ele")) {
			
			String isText = request.getParameter("frmChkTxt"),
						content = request.getParameter("frmStmt"),
						container = request.getParameter("frmNewParent"),
						secId = request.getParameter("frmNewSec"),
						secCurId = request.getParameter("frmCurSec"),
						codQues = request.getParameter("frmCodQues");
			codQues = (codQues == null)? "": codQues;
			
			
			String mandatory = request.getParameter("frmMandatory"),
							repeat = request.getParameter("frmChkRep"),
					 		bold = request.getParameter("frmChkBold"),
					 		italic = request.getParameter("frmChkItalic"),
					 		underline = request.getParameter ("frmChkUnder");
			
			int iMandatory, iRep, iBold, iItalic, iUnder, iHighlight;
			iMandatory = (mandatory == null || mandatory.equalsIgnoreCase("0"))? 0: 1;
			iRep = (repeat == null || repeat.equalsIgnoreCase(""))? 0: 1;
			
			iBold = (bold == null)? 0: AbstractItem.HIGHLIGHT_BOLD;
			iItalic = (italic == null)? 0: AbstractItem.HIGHLIGHT_ITALIC;
			iUnder = (underline == null)? 0: AbstractItem.HIGHLIGHT_UNDERLINE;
			iHighlight = iBold + iItalic + iUnder;
			
			int secParentId=-1;
			long containerId=-1;
			
			AbstractItem ai = (AbstractItem)hibSes.get(AbstractItem.class, 
																								Long.decode(theId));
			
			if (ai == null) {
				errMsg = "Unable to find item with id "+theId;
				res = false;
			}
			
			if (secId != null) {
				secParentId = Integer.parseInt(secId);
				pageContext.setAttribute("parentid", secParentId);
			}
			else if (secCurId != null) {
				secParentId = Integer.parseInt(secCurId);
				pageContext.setAttribute("parentid", secParentId);
			}
			
			if (container != null)
				containerId = Long.parseLong(container);
			
			if (ai != null) {
// common settings for both Text and Question items...
				ai.setContent(content);
				ai.setHighlight(iHighlight);
				modified = true;
				
// This is to keep the old section and get the interview
				Section oldSec = ai.getParentSec();
				Interview intrv = oldSec.getParentIntr();
				
				Section newSec = 
					(Section)hibSes.get(Section.class, Integer.valueOf(secParentId));
				if (newSec != null)
					ai.setParentSec(newSec);
					
				AbstractItem auxAi = 
					(AbstractItem)hibSes.get(AbstractItem.class, Long.valueOf(containerId));
				if (auxAi != null)
					ai.setContainer(auxAi);
				
				if (containerId == 0)
					ai.setContainer(null);
				else 
					errMsg = "Unable to find container item with id "+theId;
				
				ai.setRepeatable(Integer.valueOf(iRep));

// only for QUESTIONS..			
				if (ai instanceof Question) {
					((Question)ai).setMandatory(iMandatory);
					ArrayList<String> patterns = new ArrayList<String>(); 
					
// if the interview is a clon and the question code was changed, record the change
					String qCodQues = ((Question)ai).getCodquestion();
					qCodQues = qCodQues == null? "": qCodQues;
					if ((qCodQues.equalsIgnoreCase(codQues) == false) &&
							intrv.getSourceIntrv() != null) {
						changedCodeMsg = "User '"+session.getAttribute ("user");
						changedCodeMsg += "' has changed the question code for question "+ai.getId();
						changedCodeMsg += " from '"+((Question)ai).getCodquestion()+"' to '";
						changedCodeMsg += codQues +"'";
					}
							
					((Question)ai).setCodquestion(codQues);
					
					String[] ansItems = request.getParameterValues("frmAnswers");
					int ansItemsLen = (ansItems == null)? 1: ansItems.length;
					int[] ansItemsId = new int [ansItemsLen];
					
					if (ansItems != null) {
						for (int i=0; i<ansItems.length; i++) 
							ansItemsId[i] = Integer.parseInt(ansItems[i]);
					}
					
// Update the answeritems...
// The answer items has an intermediate table performing a M:N relationship
// between question entities and answer items entities.
// So, first removes all items relating the question with the answer types and
// then, refills the relationship with the types from the form (it means, 
// remove and the re-create again :)
//				HibernateUtil.rmvAnswerTypes4Question(hibSes, (Question)ai);
// ... impossible to use this method because of transaction nesting doesent work					

					String sqlQuery = "select * from question_ansitem where codquestion="+
												ai.getId().toString();
					List<QuestionsAnsItems> l = hibSes.createSQLQuery(sqlQuery).
																						 addEntity(QuestionsAnsItems.class).
																						 list();
					for (QuestionsAnsItems qai: l) 
						hibSes.delete(qai);

// build the patterns to set along with the new questionsAnsItems
// there has to be as many ranges as ansItemsId with id 101,102
// 100 is reserved for Labels and can be used further
// This is not valid for all interviews. because the types are cloned and the
// corresponding id's will be different.
// First, hold the patterns in an arrayList for further retrieving
					int currentRange = 1;
					for (int i=0; i<ansItemsId.length; i++) {
						AnswerItem ansIt = (AnswerItem)hibSes.get (AnswerItem.class,
																					new Long(ansItemsId[i]));
						
//						if (ansItemsId[i] == HibController.TYPE_DECIMAL_ID ||
//								ansItemsId[i] == HibController.TYPE_NUMBER_ID) { 
						if (ansIt != null &&
								(ansIt.getName().equalsIgnoreCase(HibController.TYPE_DECIMAL) ||
								 ansIt.getName().equalsIgnoreCase(HibController.TYPE_NUMBER))) {
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
					}

// Store the answer items in the database and set the range patterns 
// appropiately
					currentRange = 0;
					
					for (int i=0; i<ansItemsId.length; i++) {
						AnswerItem ansIt = (AnswerItem)hibSes.get(AnswerItem.class, 
																									 new Long (ansItemsId[i]));
						if (ansIt != null) {
//						HibernateUtil.setAnswerType(hibSes, (Question)ai, ansIt);
							int ansItId = ansIt.getId().intValue();
							QuestionsAnsItems qa = new QuestionsAnsItems((Question)ai, ansIt);
							hibSes.save(qa);
							
							qa.setAnswerOrder(new Long(i+1));
							
//							if (ansItId == HibController.TYPE_DECIMAL_ID.intValue() ||
//									ansItId == HibController.TYPE_NUMBER_ID.intValue()) {

							if (ansIt.getName().equalsIgnoreCase(HibController.TYPE_DECIMAL) ||
									ansIt.getName().equalsIgnoreCase(HibController.TYPE_NUMBER)) {
								qa.setPattern(patterns.get(currentRange));
								currentRange++;
							}
//						HibernateUtil.setAnswerOrder((Question)ai, ansIt, i+1);
						}
					} // EO for (...)
	
				} // Questions
			} // if the item with frmid is not null
			modified = true;
			
		} // else if t equals 'ele'
		if (modified)
			tx.commit();
	
	// The changedCodeMsg is used as a guard as it was modified only whether 
	// the question code was changed for a clone
		if (changedCodeMsg.length() > 0) {
			actLogger.customLog(request.getSession().getId(), "", 
					(Integer)session.getAttribute("usrid"), 
					ActionsLogger.QUESTION.toString(), changedCodeMsg);
		}
				
	
		if (what != -1) {
			Integer usrId = (Integer)session.getAttribute("usrid");
			actLogger.logItem(session.getId(), ipAddr, usrId, what, Integer.decode(theId), 
												n, ActionsLogger.UPDATE);
		}	
		
		pageContext.setAttribute("errmsg", errMsg);
	}
	catch (HibernateException hibEx) {
		if (tx != null && modified)
			tx.rollback();
		
		errMsg = hibEx.getMessage()+hibEx.getLocalizedMessage();
		pageContext.setAttribute("errmsg", "The item could not be updated.\nPlease contact with the administrator");
//		hibEx.printStackTrace();
		res = false;
		
		LogFile.error("Fail to update item:\t");
		LogFile.error("Item type (id): "+t+"("+theId+")");
		
		LogFile.error(hibEx.getLocalizedMessage());
		StackTraceElement[] stack = hibEx.getStackTrace();
		LogFile.logStackTrace(stack);
	}
	
	hibSes.close();
	
	if (res) {
%>
<c:if test="${not empty parentid}">
	{"res":1,"frmid":${id},"msg":"ok","spid":${parentid}}
</c:if>
<c:if test="${empty parentid}">
	{"res":1,"frmid":${id},"msg":"ok"}
</c:if>
<%--	
 	<jsp:forward page="index.jsp">
		<jsp:param name="res" value="1"/>
	</jsp:forward>
--%>	
<%
	}
	else {
%>
	{"res":0,"frmid":${id},"msg":"${errmsg}"}
<%--	
		<jsp:forward page="index.jsp">
			<jsp:param name="res" value="0"/>
		</jsp:forward>
--%>		
<%
	}
	// pageContext.setAttribute("sections", sectionsCol);
%>

<%--
<jsp:forward page="index.jsp">
		<jsp:param name="res" value="1"/>
	Both ones are redundant!!!
-->		<jsp:param name="op" value="${param.op}"/>
-->		<jsp:param name="t" value="${param.t}" /> 
	</jsp:forward>
--%>