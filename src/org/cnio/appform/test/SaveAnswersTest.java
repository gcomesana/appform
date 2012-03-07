package org.cnio.appform.test;

import org.cnio.appform.entity.*;
import org.cnio.appform.util.*;
import java.util.*;
import org.hibernate.*;
import javax.servlet.http.HttpServletRequest;

public class SaveAnswersTest {
/*	
	public class QuestionCoords {
		
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
////// EO QuestionCoords ///////////////////////////////////////////////////////	
*/	
	
	private Session hibSes;
	
// Lists to hold information about answers and questions
/**
 * Hold the parameters sent from the form client
 */
	public List<QuestionCoords> listParams = new ArrayList<QuestionCoords> ();
/**
 * Hold the answer values retrieved from database for this subject
 */
	private List<QuestionCoords> listAnswers = new ArrayList<QuestionCoords>();
	
	
	public SaveAnswersTest () {
		hibSes = HibernateUtil.getSessionFactory().openSession();
	}
	
	
	
	public SaveAnswersTest (Session theHibSes) {
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
	
	
	
	
	
	private void getQuestions4Section (Integer intrvId, Integer theSecOrder, String codPatient) {
		
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
		
// Compare each of these retrieved items with the request parameters
// equals for QuestionRows is idq && ansNum && ansOrd equity
// then, if retrieved ansVal is null, an insert has to be raised
// if retrieved ansVal is diff than parameter ansVal, an update is raised
// if both ansVal are the same, nothing happens

/*
		Iterator<QuestionCoords> itQc = listAnswers.iterator();
		int i = 1;
		while (itQc.hasNext()) {
			QuestionCoords myQc = itQc.next();
			System.out.println ("#"+i+" id: "+myQc.questionId+" ("+myQc.ansNumber+","+myQc.ansOrder+") -> "+myQc.ansVal);
			i++;
		}
*/
		
	}
	
	
	
// TODO probar el método para grabar las respuestas en un recién creado 
// TODO paciente a ver
// TODO elucubrar más posibilidades a ver...
	private void saveOrUpdateSectionAnswers (Integer patId) {
		
		IntrvFormCtrl formCtrl = new IntrvFormCtrl (hibSes);
		Iterator<QuestionCoords> itParam = listParams.iterator();
		
		long timeIni = Calendar.getInstance().getTimeInMillis();
		while (itParam.hasNext()) {
			QuestionCoords qcParam = itParam.next();
			
// Get the index of the db-retrieved answer related to the web parameter answer
			int i = listAnswers.indexOf(qcParam);

			String msg;
			long writingIni = Calendar.getInstance().getTimeInMillis();
			long writingEnd = Calendar.getInstance().getTimeInMillis();
			if (i != -1) {
				QuestionCoords qcAns = listAnswers.get(i);
				
System.out.println("qcAns: " + qcAns.toString());
System.out.println ("qcParam: "+qcParam.toString());
System.out.println("qcAns.ansVal: "+qcAns.ansVal+" vs qcParam.ansVal: "+qcParam.ansVal);				
				if (qcAns.ansVal == null) { // Assume there is no answer
					msg = "formCtrl.saveAnswer(q, pat, ansNumber, ansOrder, ansGroup, paramVal, ansType);";
					msg = "save answer as an entity object: new Answer(ansVal); ansId = hibSes.save(answer)";
					msg += "insert into pga  (codpat, cosanswer, codquestion, answer_number, answer_order)";
					msg += " values ("+patId+", ansId, "+qcParam.questionId+", "+qcParam.ansNumber;
					msg += ", "+qcParam.ansOrder+");";
					
System.out.println("formCtrl.saveAnswer("+qcParam.questionId+", "+patId+", "+
										qcParam.ansNumber+", "+qcParam.ansOrder+", 0, "+qcParam.ansVal+
										", "+qcAns.idAnsItem+");");

					formCtrl.saveAnswer(qcParam.questionId, patId, qcParam.ansNumber, 
															qcParam.ansOrder, 0, qcParam.ansVal, qcAns.idAnsItem);
					writingEnd = Calendar.getInstance().getTimeInMillis();
				}
// 2nd case: values are different => update
				else if (qcAns.ansVal.compareTo(qcParam.ansVal) != 0) {  
					msg = "update answer set thevalue='"+qcParam.ansVal+"' where ";
					msg += "idanswer="+qcAns.idanswer;
					
System.out.println("formCtrl.updateAnswer("+qcAns.idanswer+", "+qcParam.ansVal+");");
formCtrl.updateAnswer(qcAns.idanswer, qcParam.ansVal);

/*					
					String updStrQry = "update answer set thevalue=:newVal where idanswer=:theIdAnswer";
System.out.println ("update answer set thevalue='"+qcParam.ansVal+"' where idanswer="+qcAns.idanswer);
					Transaction tx = null;
					try {
						tx = hibSes.beginTransaction();
						
						SQLQuery updateQry = hibSes.createSQLQuery(updStrQry);
						updateQry.setString("newVal", qcParam.ansVal);
						updateQry.setInteger("theIdAnswer", qcAns.idanswer);
						int numUpdates = updateQry.executeUpdate();
						
						tx.commit();
					}
					catch (HibernateException hibEx) {
						if (tx != null)
							tx.rollback();
					}
*/					
					writingEnd = Calendar.getInstance().getTimeInMillis();
					
				}
				else
					msg = "Do nothing: both values are the same";
				
// System.out.println (msg);
System.out.println ("Elapsed for this writing: "+(writingEnd-writingIni)+" ms");
System.out.println ("===============================================");
			}
		}// EO while
		
		long timeEnd = Calendar.getInstance().getTimeInMillis();
System.out.println ("*** Total time elapsed: "+(timeEnd-timeIni)+" ms ***");
	}
	
	
	
	private void mockRealData () {
// very very very long line		
		String qString = "patId=3480&secId=200&finish=0&q2904-1-1=C%2FCenso%204%2C%200-B&q1150-1-1=Madrid&q1280-1-1=28041&q2902-1-1=Madrid&q2901-1-1=Madrid&q4053-1-1=Espa%C3%B1a&q701-1-1=913417809&q702-1-1=692547315&q703-1-1=09&q703-1-2=2005&q1227-1-1=2&q1230-1-1=2&q3000-1-1=C%2FGran%20Avenida%2021%2C%202-AyB&q1235-1-1=Madrid&q1281-1-1=28041&q3001-1-1=Madrid&q3002-1-1=Madrid&q4054-1-1=Espa%C3%B1a&q850-1-1=14&q850-1-2=34&q851-1-1=2&q1152-1-1=0&q1153-1-1=0&q1283-1-1=4&q1284-1-1=4&q1155-1-1=0&q1156-1-1=0&q858-1-1=1&q1256-1-1=1&q1256-1-2=1&q1257-1-1=20&q1256-2-1=&q1256-2-2=1&q1257-2-1=16&q862-1-1=&q862-1-2=9999&q865-1-1=&q1259-1-1=&q1259-1-2=9999&q1260-1-1=&q1238-1-1=2&q1240-1-1=&q1240-1-2=9999&q1241-1-1=&q1241-1-2=9999&q1243-1-1=&q1244-1-1=&q1246-1-1=9999&q1247-1-1=9999&q1249-1-1=&q1251-1-1=&q1253-1-1=&q1255-1-1=&currentsec=4";
		
		String params[] = qString.split("&");
		for (String param: params) {
			if (!param.startsWith("q"))
				continue;
			
			param = param.substring(1, param.length());
			String aParam[] = param.split("=");
			String questionAttrs[] = aParam[0].split("-");
			
			QuestionCoords qc  = new QuestionCoords(Integer.decode(questionAttrs[0]),
					Integer.decode(questionAttrs[1]),
							Integer.decode(questionAttrs[2]));
			qc.ansVal = aParam.length < 2? "9999": aParam[1];
			listParams.add(qc);
		}
		
	}
	
	
	
	private void mockData () {
		
		QuestionCoords qc0 = new QuestionCoords (5506,1,1);
		qc0.ansVal = "Colombia";
		listParams.add(qc0);
		
		QuestionCoords qc1 = new QuestionCoords (1265,1,1);
		qc1.ansVal = IntrvFormCtrl.MISSING_ANSWER;
		listParams.add(qc1);
		
		QuestionCoords qc2 = new QuestionCoords (5414,1,1);
		qc2.ansVal = "Colomvia";
		listParams.add(qc2);
		
		QuestionCoords qc3 = new QuestionCoords (704,1,1);
		qc3.ansVal = "5";
		listParams.add(qc3);
		QuestionCoords qc4 = new QuestionCoords (1193,1,1);
		qc4.ansVal = "5";
		listParams.add(qc4);
		QuestionCoords qc5 = new QuestionCoords (100,1,1);
		qc5.ansVal = "1";
		listParams.add(qc5);
		QuestionCoords qc6 = new QuestionCoords (152,1,2);
		qc6.ansVal = "1";
		listParams.add(qc6);
		QuestionCoords qc7 = new QuestionCoords (152,1,1);
		qc7.ansVal = "74";
		listParams.add(qc7);
		QuestionCoords qc8 = new QuestionCoords (53,1,1);
		qc8.ansVal = "44";
		listParams.add(qc8);
		QuestionCoords qc9 = new QuestionCoords (5505,1,1);
		qc9.ansVal = "Antioquia";
		listParams.add(qc9);
		QuestionCoords qc11 = new QuestionCoords (1196,1,1);
		qc11.ansVal = "3";
		listParams.add(qc11);
		QuestionCoords qc12 = new QuestionCoords (1264,1,1);
		qc12.ansVal = IntrvFormCtrl.MISSING_ANSWER;
		listParams.add(qc12);
		QuestionCoords qc13 = new QuestionCoords (5413,1,1);
		qc13.ansVal = "Colombia";
		listParams.add(qc13);
		QuestionCoords qc14 = new QuestionCoords (151,1,4);
		qc14.ansVal = "1";
		listParams.add(qc14);
		QuestionCoords qc15 = new QuestionCoords (151,1,3);
		qc15.ansVal = "67";
		listParams.add(qc15);
		QuestionCoords qc16 = new QuestionCoords (151,1,2);
		qc16.ansVal = "1";
		listParams.add(qc16);
		QuestionCoords qc17 = new QuestionCoords (151,1,1);
		qc17.ansVal = "1";
		listParams.add(qc17);
		QuestionCoords qc18 = new QuestionCoords (5416,1,1);
		qc18.ansVal = IntrvFormCtrl.MISSING_ANSWER;
		listParams.add(qc18);
		
		QuestionCoords qc19 = new QuestionCoords (5504,1,1);
		qc19.ansVal = "Medellín";
		listParams.add(qc19);
		QuestionCoords qc20 = new QuestionCoords (5412,1,1);
		qc20.ansVal = "Colombia";
		listParams.add(qc20);
		QuestionCoords qc22 = new QuestionCoords (154,1,2);
		qc22.ansVal = "9999";
		listParams.add(qc22);
		QuestionCoords qc23 = new QuestionCoords (154,1,1);
		qc23.ansVal = "8888";
		listParams.add(qc23);
		QuestionCoords qc24 = new QuestionCoords (1191,1,1);
		qc24.ansVal = "2";
		listParams.add(qc24);
		QuestionCoords qc25 = new QuestionCoords (150,1,1);
		qc25.ansVal = "7";
		listParams.add(qc25);
		QuestionCoords qc26 = new QuestionCoords (51,1,3);
		qc26.ansVal = "1964";
		listParams.add(qc26);
		QuestionCoords qc27 = new QuestionCoords (5415,1,1);
		qc27.ansVal = "2";
		listParams.add(qc27);
		QuestionCoords qc28 = new QuestionCoords (51,1,2);
		qc28.ansVal = "11";
		listParams.add(qc28);
		QuestionCoords qc29 = new QuestionCoords (51,1,1);
		qc29.ansVal = "07";
		listParams.add(qc29);
		QuestionCoords qc31 = new QuestionCoords (1194,1,1);
		qc31.ansVal = "8888";
		listParams.add(qc31);
		QuestionCoords qc32 = new QuestionCoords (5411,1,1);
		qc32.ansVal = "Colombia";
		listParams.add(qc32);
		QuestionCoords qc34 = new QuestionCoords (153,1,2);
		qc34.ansVal = "9999";
		listParams.add(qc34);
		QuestionCoords qc35 = new QuestionCoords (153,1,1);
		qc35.ansVal = "6666";
		listParams.add(qc35);
	}
	
	
	
	
	public void printListQuestions (List<QuestionCoords> l) {
		
		for (QuestionCoords qci: l) {
			System.out.println(qci.toString());
		}
		
	}
	
	
	
	public void decodeParams (HttpServletRequest req) {
		Enumeration<String> reqParams = req.getParameterNames();
		
		int ka = 0;
	  while (reqParams.hasMoreElements()) {
	    String paramName = (String) reqParams.nextElement();
	    String paramValues[] = req.getParameterValues(paramName);

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
//  	      System.out.println(paramName+"="+paramValues[0]);
  	      
	      	if (paramValues[0].length() > 0) {
//	      		System.out.println ("qc"+ka+".ansVal = \""+paramValues[0]+"\";");
	      		qc.ansVal = paramValues[0];
	      	}
  	      
  	    } // EO paramValues is 1
  	    else {
  	      System.out.print("ANOMALY: "+paramName+"=");
  	      for (int i=0; i < paramValues.length; i++) {
	          if (i > 0) 
	          	System.out.print(',');
	          System.out.print(paramValues[i]);
  	      }
//  	      System.out.println();
  	    }
      	listParams.add(qc);
	    } // EO first if
	    
//	    System.out.println ("listParams.add(qc"+ka+");");
    	ka++;
	  } // EO while
	  
	  for (QuestionCoords qci: listParams) {
//	  	String msg = qci.patId+"-"+qci.questionId+"-"+qci.ansNumber+"-"+qci.ansOrder+":"+qci.ansVal;
	  	System.out.println ("decodeParams: "+qci.toString());
	  }

	}
	
	
	
	public void closeHibSess () {
		hibSes.close();
	}
	
	
	private void mock157101103 () {
		SaveAnswers saveAns = new SaveAnswers (this.hibSes);
		
		saveAns.getQuestions4Section(1250, (1+1), "157101103");
//System.out.println ("***-> save-on-sectionchange: about to call saveOrUpdateSectionAnswers("+patId+")");
//		saveAns.saveOrUpdateSectionAnswers(Integer.decode(patId));
	}
	
	
	
	public static void main (String args[]) {
		SaveAnswersTest test = new SaveAnswersTest ();
//		test.mockRealData();
//		test.printListQuestions(test.listParams);
	
		
		Session hibSes = HibernateUtil.getSessionFactory().openSession();
		SaveAnswers sa = new SaveAnswers(hibSes);

// intrvid 1700; secId 1811; qId 4974, 4963
//		sa.getQuestions4Section(50, 5, "157081023"); // "188011060");
		sa.getQuestions4Section(1250, (1+1), "157101103");
//		sa.getQuestions4Section(1700, 10, "157501073");
System.out.println("DB ANSWERS!!!!");
		sa.printListQuestionCoords(null);
//		sa.saveOrUpdateSectionAnswers(3480, test.listParams);
//		sa.saveOrUpdateSectionAnswers(3232);

		sa.closeHibSess();
		
/*		
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
*/
	
	}
	
}
