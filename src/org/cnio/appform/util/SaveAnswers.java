package org.cnio.appform.util;

import org.cnio.appform.entity.*;
import org.cnio.appform.util.*;
import java.util.*;
import org.hibernate.*;
import javax.servlet.http.HttpServletRequest;

public class SaveAnswers {
/*	
	private class QuestionCoords {
		
		public Integer questionId;
		public String ansVal;
		public Integer ansOrder;
		public Integer ansNumber;
		
		public Integer idanswer;
		public Integer patId;
		public Integer idAnsItem;
		
		
		public QuestionCoords () {
			
		}
		
		
		public QuestionCoords (Integer qId, int ansNumber, int ansOrder) {
			questionId = qId;
			this.ansOrder = ansOrder;
			this.ansNumber = ansNumber;
		}
		
		
		
		public boolean equals (Object obj) {
			if (obj != null) {
				QuestionCoords qc = (QuestionCoords)obj;
				if (qc.ansNumber == null) {
					if (qc.ansOrder != null && this.questionId.compareTo(qc.questionId) == 0 && 
							this.ansOrder.compareTo(qc.ansOrder) == 0) 
						return true;
				}	
				
				else if (qc.ansNumber != null && qc.ansOrder != null &&
								this.questionId.compareTo(qc.questionId) == 0 && 
								this.ansNumber.compareTo(qc.ansNumber) == 0 &&
								this.ansOrder.compareTo(qc.ansOrder) == 0) 
						return true;
					
				else
						return false;
			} // EO first if
			return false;
		}
		
		
		public String toString () {
		
			String msg = "qId: "+questionId+"; num: "+ansNumber+"; ord: "+ansOrder;
			msg += "; ansVal: "+ansVal+"; idAns: "+idanswer+"; patId: "+patId;
			msg += "; idAnsItem: "+idAnsItem;
			
			return msg;
		}
		
	} 
*/
////// EO QuestionCoords ///////////////////////////////////////////////////////	
	
	
	private Session hibSes;
	
// Lists to hold information about answers and questions
/**
 * Hold the parameters sent from the form client
 */
	private List<QuestionCoords> listParams = new ArrayList<QuestionCoords> ();
/**
 * Hold the answer values retrieved from database for this subject
 */
	private List<QuestionCoords> listAnswers = new ArrayList<QuestionCoords>();
	
	
	public SaveAnswers () {
		hibSes = HibernateUtil.getSessionFactory().openSession();
	}
	
	
	
	public SaveAnswers (Session theHibSes) {
		hibSes = theHibSes;
	}
	
	
	private void saveHibAnswer (String qId, String patId, String answerOrder, String answerNumber) {
		
		Patient pat = (Patient)hibSes.get(Patient.class, Integer.decode(patId));
		
		Integer ansOrder = Integer.decode(answerOrder), 
							ansNumber = Integer.decode(answerNumber), ansGroup = 0;
		IntrvFormCtrl formCtrl = new IntrvFormCtrl (hibSes);
		String paramVal = "9999";
		boolean res;
		
		
		Question q = (Question)hibSes.get(Question.class, Long.decode(qId));
		List<AnswerItem> ansTypes = HibernateUtil.getAnswerTypes4Question(hibSes, q);
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
//				if (res == false)
//					break;
		 	}
		 	else {
		// an update of the answer must be done if values are different
	//			if (((String)ans[1]).equalsIgnoreCase(paramVal) == false)
				if (((String)ans[1]).compareTo(paramVal) != 0)
					res = formCtrl.updateAnswer((Integer)ans[0], paramVal);
				
//				if (res == false)
//					break;
		 	}
		hibSes.close();
	}
	
	
	
	
	
/**
 * Gets the questions and their answers stored in database. Fills the listAnswers
 * member with QuestionCoords elements
 * 
 * @param intrvId, the id of the current questionnaire
 * @param theSecOrder, the order of the current section
 * @param codPatient, the patient code
 */
	public void getQuestions4Section (Integer intrvId, Integer theSecOrder, String codPatient) {
		
// ALL QUESTIONS (AND TEXTS) FOR THE CURRENT SECTION
		String sqlQry = "select items.*, pgabis.answer_number,  qai.answer_order, "+ 
        "pgabis.codpatient, pgabis.idpat, a.idanswer, a.thevalue, ai.name, ai.idansitem, "+
        "qai.pattern from ("+
        "select it.item_order as itemord, it.content as content, q.codquestion as codq, "+
        "it.iditem as itemid, it.highlight as highlight, it.ite_iditem as itparent, "+
        "it.\"repeatable\" as itrep, q.idquestion as idq, " +
        "s.name as secname, s.idsection as secid " +
        "from question q right join item it on (it.iditem = q.idquestion), " +
        "section s,  interview i" +
        " where 1 = 1" +
        " and i.idinterview = :theIntrvId " +
        " and i.idinterview = s.codinterview" +
        " and s.section_order = :theSecOrder" +
        " and it.idsection = s.idsection" +
        ") items" +
        " left join question_ansitem qai on (items.idq = qai.codquestion)" +
        " left join answer_item ai on (qai.codansitem = ai.idansitem)" +
        " left join (" +
        "select *" +
        " from pat_gives_answer2ques pga right join" +
        " patient p on (pga.codpat = p.idpat)" +
        " where p.codpatient = :theCodPatient" + // "+'157011063' -- '157851555'
        ") pgabis on (" +
        "items.itemid = pgabis.codquestion and " +
        "pgabis.answer_order = qai.answer_order) "+
        "left join answer a on (pgabis.codanswer = a.idanswer)" +
        " order by itemord, answer_number, answer_order;";
		
// System.out.println (sqlQry);
		
		SQLQuery questionsQry = hibSes.createSQLQuery(sqlQry);
		questionsQry.setParameter("theIntrvId", intrvId);
		questionsQry.setParameter("theSecOrder", theSecOrder);
		questionsQry.setParameter("theCodPatient", codPatient);
		
		List<Object[]> rs = questionsQry.list();
		
		
		Iterator<Object[]> itRs = rs.iterator();
		listAnswers.clear();
		while (itRs.hasNext()) {
			Object[] row = itRs.next();
			if (row[7] == null) // this is a text
				continue;
			
			Integer myQuesId = (Integer)row[7]; // idq
			Integer myAnsOrd = (Integer)row[11]; 
			Integer myAnsNum = (Integer)row[10];
			Integer myIdAns = (Integer)row[14];
			String ansVal = (String)row[15];
			Integer idAnsItem = (Integer)row[17];
// System.out.println (myQuesId+","+myAnsOrd+","+myAnsNum+",("+myIdAns+"->"+ansVal+") for "+idAnsItem);			

// QuestionCoords qc = new QuestionCoords (myQuesId, myAnsOrd, myAnsNum);
			QuestionCoords qc = new QuestionCoords ();
			qc.ansNumber = myAnsNum;
			qc.ansOrder = myAnsOrd;
			qc.questionId = myQuesId;
			qc.ansVal = ansVal;
			qc.idanswer = myIdAns;
			qc.idAnsItem = idAnsItem;
			
			listAnswers.add(qc);
		}
		
int k=0;/*
System.out.println("(tid: "+Thread.currentThread().getId()+") SaveAnswers.getQuestions4Section from DB:");
for (QuestionCoords current: listAnswers)
	System.out.println ((++k)+".- "+current.toString());
		
		System.out.println ("Finishing building question coords: "+listAnswers.size()+" questions");
		
// Compare each of these retrieved items with the request parameters
// equals for QuestionRows is idq && ansNum && ansOrd equity
// then, if retrieved ansVal is null, an insert has to be raised
// if retrieved ansVal is diff than parameter ansVal, an update is raised
// if both ansVal are the same, nothing happens
*/
	}

	
	
/**
 * Just print the elements of a list of <b>QuestionCoords</b> elements
 * @param l, the list of <b>QuestionCoords</b> elements
 */
	public void printListQuestionCoords (List<QuestionCoords> l) {
		if (l == null)
			l=listAnswers;
		
		for (QuestionCoords qc: l)
			System.out.println(qc.toString());
	}
	
	
	
	
	public void saveOrUpdateSectionAnswers (Integer patId, List<QuestionCoords> l) {
		listParams.clear();
		listParams.addAll(l);
		
		saveOrUpdateSectionAnswers(patId);
	}
	
	
/**
 * This is the method will be called in order to save or update all answers from
 * the form. Basically, two lists are built previously: one list with the questions
 * from the request parameters, and the other containing the question-answers as
 * retrieved from the database. 
 * Then, an answer is inserted/updated if:
 * - parameter value an database value are different
 * - answer is NOT in database
 * @param patId, the patient id, necessary to insert in ternary relationship table
 */
	public void saveOrUpdateSectionAnswers (Integer patId) {
		
		IntrvFormCtrl formCtrl = new IntrvFormCtrl (hibSes);
		Iterator<QuestionCoords> itParam = listParams.iterator();
		
		long timeIni = Calendar.getInstance().getTimeInMillis();
System.out.println ("saveOrUpdateSectionAnswers init!! :: (tid: "+Thread.currentThread().getId()+") saveOrUpdateSectionAnswers: About to start while..."+
		listParams.size());

		while (itParam.hasNext()) {
			QuestionCoords qcParam = itParam.next();
			
// Get the index of the db-retrieved answer related to the web parameter answer
			int indexOfAnswer = listAnswers.indexOf(qcParam);
			
// System.out.println("saveOrUpdate: qcAns: " + qcAns.toString());
// System.out.println ("(tid: "+Thread.currentThread().getId()+") saveOrUpdateSectionAnswers: qcParam: "+qcParam.toString() + " has indexOfAnswer:"+indexOfAnswer);
			String msg;
			long writingIni = Calendar.getInstance().getTimeInMillis();
			long writingEnd = Calendar.getInstance().getTimeInMillis();
			
			if (indexOfAnswer != -1) {
				QuestionCoords qcAns = listAnswers.get(indexOfAnswer);
// System.out.println("(tid: "+Thread.currentThread().getId()+") saveOrUpdateSectionAnswers: qcAns: "+qcAns.toString());				

				if (qcAns.ansVal == null) { // Assume there is no answer
					msg = "saveOrUpdate: formCtrl.saveAnswer(q, pat, ansNumber, ansOrder, ansGroup, paramVal, ansType);";
					msg = "save answer as an entity object: new Answer(ansVal); ansId = hibSes.save(answer)";
					msg += "insert into pga  (codpat, cosanswer, codquestion, answer_number, answer_order)";
					msg += " values ("+patId+", ansId, "+qcParam.questionId+", "+qcParam.ansNumber;
					msg += ", "+qcParam.ansOrder+");";
					
/* System.out.println("SaveAnswers: formCtrl.saveAnswer("+qcParam.questionId+", "+patId+", "+
										qcParam.ansNumber+", "+qcParam.ansOrder+", 0, "+qcParam.ansVal+
										", "+qcAns.idAnsItem+");");
*/
					formCtrl.saveAnswer(qcParam.questionId, patId, qcParam.ansNumber, 
															qcParam.ansOrder, 0, qcParam.ansVal, qcAns.idAnsItem);
					writingEnd = Calendar.getInstance().getTimeInMillis();
				}
				
// 2nd case: answer was removed from questionnaire => answer has to be removed from database				
				else if (qcParam.ansVal == null && qcAns.ansVal != null) {
					String currentParam = qcParam.questionId+"-"+qcParam.ansNumber+"-"+qcParam.ansOrder;
					msg = "saveOrUpdate: formCtrl.removeAnswers ("+currentParam+", "+patId+")";
					
					formCtrl.removeAnswers(currentParam, patId);
				}
				
// 3rd case: values are different => update
				else if (qcAns.ansVal.compareTo(qcParam.ansVal) != 0) {  
					msg = "saveOrUpdate: update answer set thevalue='"+qcParam.ansVal+"' where ";
					msg += "idanswer="+qcAns.idanswer;
					
// System.out.println("SaveAnswers: formCtrl.updateAnswer("+qcAns.idanswer+", "+qcParam.ansVal+");");
					formCtrl.updateAnswer(qcAns.idanswer, qcParam.ansVal);
					writingEnd = Calendar.getInstance().getTimeInMillis();
				}
				else
					msg = "Do nothing: both values are the same";
				
// System.out.println ("(tid: "+Thread.currentThread().getId()+") "+msg);
			}
			
// there is no answer in the database with the same question coords than 
// the current question, it means, if current param is q1450-2-3 there is no
// no question in the database matching with the previous one
// so, it has to be created			
			else { 
				
System.out.println("(tid: "+Thread.currentThread().getId()+") !! No value for the answer in listOfAnswers and it has to be created into the DB");
				Question currentQ = (Question)hibSes.get(Question.class, qcParam.questionId.longValue());
				List<AnswerItem> answerItems = 
							HibController.ItemManager.getAnswerTypes4Question(hibSes, currentQ);
				
				AnswerItem currentAi = answerItems.get(qcParam.ansOrder-1);
				
				formCtrl.saveAnswer(qcParam.questionId, patId, qcParam.ansNumber, 
									qcParam.ansOrder, 0, IntrvFormCtrl.MISSING_ANSWER, 
									currentAi.getId().intValue());
			} // EO else no answer in the DB
			
 		}// EO while
		
		long timeEnd = Calendar.getInstance().getTimeInMillis();
// System.out.println ("*** Total time elapsed in saving/updating section: "+(timeEnd-timeIni)+" ms ***");
	}
	
	
	
	
/**
 * Get all params in the request req and, for each of them, creates a 
 * QuestionCoords object withe the attriburtes for each question (including answer)
 * and store all params in a list as commented QuestionCoords objects
 * @param req, the http request to decompose the parameters
 */	
	public void decodeParams (HttpServletRequest req) {
		Enumeration<String> reqParams = req.getParameterNames();
System.out.println("### decodeParams...");		
	  while (reqParams.hasMoreElements()) {
	    String paramName = (String) reqParams.nextElement();
	    String paramValues[] = req.getParameterValues(paramName);
	
/*	    
if (paramName.indexOf(paramName) != -1)
	System.out.println (paramName+": "+printArray(paramValues));
*/
	    QuestionCoords qc;
	    if (paramName.startsWith("q")) {
      	paramName = paramName.substring(1, paramName.length());
      	String[] parts = paramName.split("-");
      	Integer qId = Integer.valueOf(parts[0]);
      	Integer num = Integer.valueOf(parts[1]);
      	Integer ord = Integer.valueOf(parts[2]);
//      	String msg = "QuestionCoords qc"+ka+" = QuestionCoords ("+parts[0]+","+parts[1]+","+parts[2]+");";
//      	System.out.println (msg);
      	
      	qc = new QuestionCoords (qId, num, ord);
      	if (paramValues.length == 1) {
      		String theAnsValue = paramValues[0].compareTo("")==0? "9999": paramValues[0];
//  	      System.out.println("SaveAnswers.decodeParams: "+paramName+"="+theAnsValue);
  	      
      		qc.ansVal = theAnsValue;
  	      
  	    } // EO paramValues is 1
  	    else {
  	      System.out.print("ANOMALY: "+paramName+"=");
  	      for (int i=0; i < paramValues.length; i++) {
	          if (i > 0) 
	          	System.out.print(',');
	          System.out.print(paramValues[i]);
  	      }
  	      System.out.println();
  	    }
      	listParams.add(qc);
	    } // EO first if
	    
	  } // EO while
	  
/*	  
	  for (QuestionCoords qci: listParams) {
	  	String msg = qci.patId+"-"+qci.questionId+"-"+qci.ansNumber+"-"+qci.ansOrder+":"+qci.ansVal;
	  	System.out.println (msg);
	  }
*/
	}
	
	
	
	private String printArray (String[] params) {
	
		String strOut = "";
		for (String str: params)
			strOut += str+",";
		
		strOut = strOut.substring(0, strOut.length()-1);
		
		return strOut;
	}
	
	
	public String listParams2String () {
		
		
		
		return null;
	}
	
	
	public void closeHibSess () {
		hibSes.close();
	}
	
	
	/*
	public static void main (String args[]) {
		SaveAnswersTest test = new SaveAnswersTest ();
		String qId = "12359"; 
		String codPatient = "157081099";
		Integer patId = 7450; // retrieved from the session vars
		
//		test.saveHibAnswer(qId, patId, "1", "1");
		test.mockData ();
*
		test.getQuestions4Section(50, 2, "157081003");
		test.saveOrUpdateSectionAnswers(patId);
*		
System.out.println ();
System.out.println ("Next one for just created 157081099");
		test.getQuestions4Section(50, 2, "157081099");
		test.saveOrUpdateSectionAnswers(patId);
		
		test.closeHibSess();
	}
*/
	
}
