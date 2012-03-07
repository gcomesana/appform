package org.cnio.appform.util.curation;



import org.cnio.appform.entity.*;
import org.cnio.appform.util.*;


import java.util.*;
import java.io.*;
import java.nio.charset.Charset;
import org.hibernate.*;

public class InterviewsCuration {
	
	private Session hibSess;
	private BufferedWriter bw;
	
// We will use this guard in order to save or only present results
	private boolean saveGuard;
	
	public InterviewsCuration () {
		hibSess = HibernateUtil.getSessionFactory().openSession();
	}
	
	
	public InterviewsCuration (Session hibSess) {
		this.hibSess = hibSess;
	}
	
	
	public InterviewsCuration (Session hibSes, String fileName, boolean save) {
		this (hibSes);
		try {
			bw =  new BufferedWriter (
	        new OutputStreamWriter (new FileOutputStream (fileName), Charset.defaultCharset()));
		}
		catch (IOException ioEx) {
			ioEx.printStackTrace();
		}
		
		saveGuard = save;
	}
	
	
	
	private void pukeExc (Transaction tx, HibernateException ex, String errMsg) {
		
		if (tx != null)
			if (tx.isActive())
				tx.rollback();
		
		LogFile.getLogger().error(errMsg);
		LogFile.getLogger().error(ex.getLocalizedMessage());
		StackTraceElement[] stElems = ex.getStackTrace();
		LogFile.logStackTrace(stElems);
	}
	
	
	
	
/**
 * Get all items in a section which are either containers or simple questions
 * @param prjId, the project id
 * @param intrvId, the interview id
 * @param secOrder, the section order in the questionnaire
 * @return a list with the items in the section without being contained
 */
	private List<AbstractItem> getAllParentItems (Integer prjId, Integer intrvId, Integer secOrder) {
		
		String hqlQry = "select it from Project p join p.interviews i join" +
				" i.sections s join s.items it " +
				"where p.id = " + prjId +
				" and i.id = "+intrvId + " and s.sectionOrder = " + secOrder+
//				" and it.container is null " +
				" and (it.containees is not empty or it.container is null)"+
				"order by it.itemOrder";
		Transaction tx = null;
		List<AbstractItem> res = null;
		try {
			tx = hibSess.beginTransaction();
			Query qry = hibSess.createQuery(hqlQry);
			
			res = qry.list();
			tx.commit();
		}
		catch (HibernateException hibEx) {
			pukeExc (tx, hibEx, "IntrvFormCuration.getAllParentItems ERR");
		}
		
		return res;
	}
	
	
	
/**
 * Get the items with containees belonging to the secOrderth section in the 
 * interview intrvId and project prjId
 * @param prjId
 * @param intrvId
 * @param secOrder
 * @return a list of items with child items
 */
	private List<AbstractItem> getRepetibleParents (Integer prjId, 
																			Integer intrvId, Integer secOrder) {
		Transaction tx = null;
		String hqlQry = "select it from Project p join p.interviews i join" +
				" i.sections s join s.items it " +
				"where p.id = " + prjId +
				" and i.id = "+intrvId + " and s.sectionOrder = " + secOrder+
				" and it.repeatable = 1 and it.containees is not empty order by it.itemOrder";
		
		List<AbstractItem> res = null;
		
		try {
			tx = hibSess.beginTransaction();
			Query qry = hibSess.createQuery(hqlQry);
			
			res = qry.list();
			tx.commit();
			
		}
		catch (HibernateException hibEx) {
			pukeExc (tx, hibEx, "IntrvFormCuration.getRepetibleParents ERR");
		}
		
		return res;
	}
	
	
	
	
	
/**
 * Returns the collection of children questions ordered by item order. These ones
 * are the items have to be answered and/or the items have been composed in the
 * composing tool
 * @param parent, the children container abstract item
 * @return
 */	
	private List<Question> getChildren (AbstractItem parent) {
		Transaction tx = null;
		String hqlQry = "select q from Question q " +
				"where q.container = :container order by q.itemOrder";
		List<Question> questions = new java.util.ArrayList<Question> ();
		
		try {
			tx = hibSess.beginTransaction();
			Query qry = hibSess.createQuery(hqlQry);
			qry.setEntity("container", parent);
			
			questions = qry.list();
			tx.commit();
		}
		catch (HibernateException ex) {
			pukeExc (tx, ex, "IntrvFormCuration.getChildren: "+parent.getId());
		}
		
		return questions;
	}
	
	
	

/**
 * Returns the answered items for a list of containers ordered by the containers
 * first and then by the answer number and answer order to provide a convenient
 * layout to perform further processing
 * @param prjId
 * @param intrvId
 * @param repContainers, a list of repeatable containers
 * @param patId, the patient id
 * @return a list of entries subject-question-answer as an instance of PatGivesAns2Ques
 */
	private List<PatGivesAns2Ques> getAnswers4Items (Integer prjId, Integer intrvId, 
												List<AbstractItem> repContainers, Integer patId) {
		
		Transaction tx = null;
		String hqlQry = "select pga from PatGivesAns2Ques pga join pga.question q " +
				" where q.container = :container and pga.patient = :pat " +
				"order by pga.answerNumber, pga.question.id, pga.answerOrder";
		
		List<PatGivesAns2Ques> res = new java.util.ArrayList ();
		try {
			tx = hibSess.beginTransaction();
			Patient pat = (Patient)hibSess.get(Patient.class, patId);
			
			Iterator<AbstractItem> cont = repContainers.iterator();
			Query qry = hibSess.createQuery(hqlQry);
			qry.setEntity("pat", pat);
			
			while (cont.hasNext()) {
				AbstractItem theParent = cont.next();
				qry.setEntity("container", theParent);
				List<PatGivesAns2Ques> innerRes = null;
				innerRes = qry.list();
/*
System.out.println ("theParent: "+theParent.getId());
				for (int i=0; i<res.size(); i++) {
					PatGivesAns2Ques pga = res.get(i);
System.out.println (pga.getQuestion().getId()+":"+pga.getAnswerNumber()+":"+pga.getAnswerOrder());
				} // eo for
*/
				res.addAll(innerRes);
			}
			
			tx.commit();
		}
		catch (HibernateException ex) {
			pukeExc (tx, ex, "IntrvFormCuration.getAnswer4Items ERR");
		}
				
		return res;
		
	}
	
	
	
/**
 * Gets the answered entries for the patient patId and the containee items in
 * repeatable container repContainer
 * @param prjId
 * @param intrvId
 * @param repContainer, a repeatable item container
 * @param patId, a subject id, necessary to discriminate answers
 * @return
 */	
	private List<PatGivesAns2Ques> getAnswers4Items (Integer prjId, Integer intrvId, 
							AbstractItem repContainer, Integer patId) {

		Transaction tx = null;
		String hqlQry = "select pga from PatGivesAns2Ques pga join pga.question q " +
		" where q.container = :container and pga.patient = :pat " +
		"order by pga.answerNumber, pga.question.id, pga.answerOrder";
		
		List<PatGivesAns2Ques> res = new ArrayList ();
		try {
			tx = hibSess.beginTransaction();
			Patient pat = (Patient) hibSess.get(Patient.class, patId);

			Query qry = hibSess.createQuery(hqlQry);
			qry.setEntity("pat", pat);
			qry.setEntity("container", repContainer);
			
			res = qry.list();

			tx.commit();
		}
		catch (HibernateException ex) {
			pukeExc (tx, ex, "IntrvFormCuration.getAnswer4Items ERR");
		}
		
		return res;
	}
	
	
	
	
/**
 * Gets the answers for a question regarding to its answer number and a subject 
 * @param q, the question to retrieve answers
 * @param ansNumber, the number of answer to retrieve (in the case of this question
 * is repeatable)
 * @param patId, the subject
 * @return a list of questions
 */
	private List<PatGivesAns2Ques> getAnswers4Ques (Question q, int ansNumber, 
									Integer patId) {
		Transaction tx = null;
		String hqlQry = "from PatGivesAns2Ques pga where pga.question =:question" +
				" and pga.answerNumber = :number and pga.patient = :patient" +
				" order by pga.answerNumber, pga.answerOrder";
		
		List<PatGivesAns2Ques> res = null;
		try {
			tx = hibSess.beginTransaction();
			Patient pat = (Patient)hibSess.get(Patient.class, patId);
			
			Query qry = hibSess.createQuery(hqlQry);
			qry.setEntity("question", q);
			qry.setInteger("number", new Integer(ansNumber));
			qry.setEntity("patient", pat);
			
			res = qry.list();

			tx.commit();
		}
		catch (HibernateException ex) {
			pukeExc (tx, ex, "IntrvFormCuration.getAnswer4Ques ERR");
		}
		
		return res;
	}
	
	
	
	
/**
 * Insert a new answer for the question q and the patient patId fixing the 
 * order answer and the answer number
 * @param patId, the id of the subject
 * @param q, the question
 * @param ordAns, the order for the answer
 * @param ansNum, the number of answer 
 * @return true on successfully completion, false otherwise
 */
	private boolean addAnswer (Integer patId, Question q, 
											Integer ordAns, Integer ansNum) throws IOException {
		Transaction tx = null;
		
		try {
			tx = hibSess.beginTransaction();
			Patient pat = (Patient)hibSess.get(Patient.class, patId);
			
			Answer ans = new Answer (RenderEng.MISSING_ANSWER);
			ans.setAnswerOrder(ordAns);
			AnswerItem ai = q.getQuestionAnsItems().get(ordAns-1).getTheAnswerItem();
			ans.setAnswerItem(ai);
			hibSess.save(ans);
			// save
			
			PatGivesAns2Ques pga = new PatGivesAns2Ques (q, ans, pat, ansNum, ordAns);
			hibSess.save(pga);
			/*save
System.out.println("answer for question "+q.getId()+"-"+ansNum+"-"+ordAns+
			"("+q.getCodquestion()+")"+" is missing");
*/
bw.append ("Answer for q"+q.getId()+"-"+ansNum+"-"+ordAns+
			"("+q.getCodquestion()+")"+" is missing\n");

			tx.commit();
bw.append ("Answer for q"+q.getId()+"-"+ansNum+"-"+ordAns+
					"("+q.getCodquestion()+")"+" was filling\n");			
			return true;
		}
		catch (HibernateException ex) {
			pukeExc (tx, ex, "IntrvFormCuration.addAnswer ERR");
		}
		
		return false;
	}
	
	
	
	
	
/**
 * Return the maximum number of answers in a group of answered items. The list
 * of answered should belong to the same container, so the return value will
 * be the number of answers for the container, even if the questions have several
 * answer items
 * @param answered, a list of answers
 * @return the highest number of answer
 */
	private int getMaxAnswers (List<PatGivesAns2Ques> answered) {
		
		int maxAnswers = 1;
		for (Iterator<PatGivesAns2Ques> it=answered.iterator(); it.hasNext();) {
			PatGivesAns2Ques pga = it.next();
			maxAnswers = Math.max(maxAnswers, pga.getAnswerNumber());
		}
		
		return maxAnswers;
	}
	
	
	
	
	
/**
 * Returns a list of subject-question-answer entries from answered list 
 * with the same id/codquestion than q
 * @param q, the question reference
 * @param answered, the gross list of answered items
 * @return an subset of answered with the same question id than q
 */
	private List<PatGivesAns2Ques> getSameCodeAnswers (Question q, 
																					List<PatGivesAns2Ques> answered) {
		
		Iterator<PatGivesAns2Ques> pgaIt = answered.iterator();
		List<PatGivesAns2Ques> res = new ArrayList<PatGivesAns2Ques> ();
		while (pgaIt.hasNext()) {
			PatGivesAns2Ques pga = pgaIt.next();
			
			if (pga.getQuestion().getId() == q.getId())
				res.add(pga);
		}
		return res;
		
	}
	
	
	
/**
 * Get the subjects who have any interview performed 
 * @param intrv
 * @return
 */	
	private List<Patient> getSubjects4Intrv (Interview intrv) {
		String hql = "select pf.patient from Performance pf " +
				"where pf.interview =:intrv";
		Transaction tx = null;
		List<Patient> res = null;
		try {
			tx = hibSess.beginTransaction();
			Query qry = hibSess.createQuery(hql);
			qry.setEntity("intrv", intrv);
			
			res = qry.list();
			tx.commit();
		}
		catch (HibernateException ex) {
			pukeExc (tx, ex, "IntrvFormCuration.getSubjecst4Intrv ERR");
		}
		
		return res;
	}
	
	
	
	
	
/**
 * Add an answer missing for the question q and the patient given by patId. The 
 * answer may have several questions (like dd, mm and yyyy)
 * @param q, the question
 * @param patId, the id of the subject
 * @param numOfQues, the number of the question. This will be 0 for a single question
 * @return, true on successfully completion; otherwise false
 */	
	private int fillAnswer (Question q, Integer patId, int numOfQues) throws IOException {
		int numOfAnsItems = q.getQuestionAnsItems().size();
		int numFills = 0;
		
// Get the answers for this question and this number of answer
		List<PatGivesAns2Ques> ans4Ques = getAnswers4Ques(q, numOfQues+1, patId);
		for (int ordAns = 0; ordAns < numOfAnsItems; ordAns++) {
			PatGivesAns2Ques pga = 
				(ans4Ques == null || ans4Ques.size() <= ordAns)?null: ans4Ques.get(ordAns);
			
			if (pga == null || pga.getAnswerOrder() != ordAns+1) {
				boolean res;
				if (saveGuard) {
					res = addAnswer (patId, q, ordAns+1, numOfQues+1);
					numFills = res? numFills+1: numFills;
				}
				else {
					bw.append ("Answer for q"+q.getId()+"-"+numOfQues+1+"-"+ordAns+1+
							"("+q.getCodquestion()+")"+" is missing\n");
					numFills++;
				}
					
			}
			else
bw.append ("Answer for "+q.getCodquestion()+": q"+q.getId()+"-"+(numOfQues+1)+
		"-"+(ordAns+1)+" = "+pga.getAnswer().getValue()+"\n");
				
		} // EO answer items loop for a question
		
		return numFills;
	}
	
	
	
	
/**
 * Fixes the missing answers for the list of items
 * @param allItems, a list of items,
 * @param patId the subject id for who the answers have to be fixed
 * @return the number of answers fixed or -1 if the list of items is null
 */
	private int fixAnswers (List<AbstractItem> allItems, Integer patId) throws IOException {
		if (allItems == null)
			return -1;
		
		else {
			int numMissing = 0;
// loop over repeatable containers
			for (Iterator<AbstractItem> it = allItems.iterator(); it.hasNext();) {
				AbstractItem container = it.next();
				
				if (container.getContainees().size() == 0) {
					if (container instanceof Question)
						numMissing += fillAnswer(((Question)container), patId, 0);
				}
				else {
					List<Question> children = getChildren(container);
					List<PatGivesAns2Ques> answered = getAnswers4Items(50, 50, container, patId); // 550);
bw.append (container.getId()+": "+ children.size()+" containees\n");
					
	// To get the maximum number of items answered, the maximum answered.getNumAnser()
	// should be got
					int maxAnswers = getMaxAnswers (answered);
									
	//				Iterator<PatGivesAns2Ques> itpga = answered.iterator();
					
	// Loop maxAnswers times over children: that will be the whole set of questions
	// should have any answer. Then, if any element in answered list doesn't correspond
	// with some element in children, has to be created
					for (int iAns=0; iAns < maxAnswers; iAns++) {
	// System.out.println ("\nnum of answer: "+(iAns+1));
	// bw.append ("\nnum of answer: "+(iAns+1)+"\n");
	
						Iterator<Question> itChild = children.iterator();
						while (itChild.hasNext()) {
							Question q = itChild.next();
							int numOfAnsItems = q.getQuestionAnsItems().size();
							
							numMissing += fillAnswer (q, patId, iAns);
						} // EO loop over (repeatable) container children
						
					} // EO loop over number of answers for repeatable container
					
					// EO while itChild
					bw.append("============================\n");
				}
				
			} // EO loop over repeatable containers
			return numMissing;
		} // EO items list is not null
		
	}
	
	

	
/**
 * Fixes the <b>orderSec</b>th section of the <b>intrv</b> for the patient with
 * code <b>codPatient</b>
 * @param prj, the project which the interview belongs to
 * @param intrv, the interview object
 * @param codPatient, the patient code
 * @param orderSec, the order of the section in the questionnaire
 * @return, the number of fixed (actually, filled) answers
 * @throws IOException
 */
	public int fixSection (Project prj, Interview intrv, String codPatient, Integer orderSec) 
												throws IOException {
		int fixedAns = 0;
bw.append("Fix interview '"+intrv.getName()+"' ("+intrv.getId()+")");		
		Integer intrId = intrv.getId(), prjId = prj.getId();
		
		if (codPatient == null || codPatient.length() == 0)
			return fixIntrv (prj, intrv, orderSec);
		
		else {
			List<Section> secs = 
				HibController.SectionCtrl.getSectionsFromIntrv(hibSess, intrv);
			IntrvFormCtrl formCtrl = new IntrvFormCtrl (hibSess);
			Patient aPat = formCtrl.getPatientFromCode(codPatient);
			
			for (Iterator<Section> itSec = secs.iterator(); itSec.hasNext() && aPat != null;) {
				Section sec = itSec.next();
System.out.println("Fixing section: "+sec.getName()+"\n");
bw.append("Fixing section: "+sec.getName()+"\n");
				int secOrder = sec.getSectionOrder();
				if (orderSec != null && orderSec.compareTo(secOrder) != 0)
					continue;
				
// System.out.println ("Fixing '"+aPat.getCodpatient()+"' ("+aPat.getId()+")\n");
System.out.print("#");
bw.append("** Fixing patient '"+aPat.getCodpatient()+"' ("+aPat.getId()+")\n");				
				List<AbstractItem> allItems = getAllParentItems(prjId, intrId, secOrder);
					
				fixedAns += fixAnswers (allItems, aPat.getId());
bw.flush();
			}
			
System.out.println();
bw.append("======================================");
bw.append("Total missing answers fixed: "+fixedAns);
bw.flush();

			return fixedAns;
		}
	}
	
	
	
	

/**
 * Fixes just a interview for a patient with code codPatient
 * @param prj, the project which the interview belongs to
 * @param intrv, the questionnaire whose performance is to be fixed
 * @param codPatient, the 9 digit patient code
 * @return the total number of question-answer fixed
 * @throws IOException
 */
	public int fixPerformance (Project prj, Interview intrv, String codPatient) throws IOException{
		int fixedAns = 0;
bw.append("Fix interview '"+intrv.getName()+"' ("+intrv.getId()+")");		
		Integer intrId = intrv.getId(), prjId = prj.getId();
		
		if (codPatient == null || codPatient.length() == 0)
			return fixIntrv (prj, intrv, null);
		
		else {
			List<Section> secs = 
				HibController.SectionCtrl.getSectionsFromIntrv(hibSess, intrv);
			IntrvFormCtrl formCtrl = new IntrvFormCtrl (hibSess);
			Patient aPat = formCtrl.getPatientFromCode(codPatient);
			
			for (Iterator<Section> itSec = secs.iterator(); itSec.hasNext() && aPat != null;) {
				Section sec = itSec.next();
System.out.println("Fixing section: "+sec.getName()+"\n");
bw.append("Fixing section: "+sec.getName()+"\n");
				int secOrder = sec.getSectionOrder();
				
// System.out.println ("Fixing '"+aPat.getCodpatient()+"' ("+aPat.getId()+")\n");
System.out.print("#");
bw.append("** Fixing patient '"+aPat.getCodpatient()+"' ("+aPat.getId()+")\n");				
				List<AbstractItem> allItems = getAllParentItems(prjId, intrId, secOrder);
					
				fixedAns += fixAnswers (allItems, aPat.getId());
bw.flush();
			}
			
System.out.println();
bw.append("======================================");
bw.append("Total missing answers fixed: "+fixedAns);
bw.flush();

			return fixedAns;
		}
	}
	
	
	
	
/**
 * Fixes all missing answers for all subjects which intrv was performed. The fixing
 * is enclosed to the section with order orderSec if orderSec is not null
 * @param prj, the project which the interview belongs to.
 * @param intrv, the interview to fix answers
 * @param orderSec, the number of section to curate or all of them if this
 * parameter is null
 * @return the number of answers missing which were fixed for the questionnaire
 */	
	public int fixIntrv (Project prj, Interview intrv, Integer orderSec) throws IOException {
		int fixedAns = 0;
bw.append("Fix interview '"+intrv.getName()+"' ("+intrv.getId()+")");		
		Integer intrId = intrv.getId(), prjId = prj.getId();
		List<Patient> patients = getSubjects4Intrv (intrv);
		
		List<Section> secs = 
			HibController.SectionCtrl.getSectionsFromIntrv(hibSess, intrv);
		
		for (Iterator<Section> itSec = secs.iterator(); itSec.hasNext();) {
			
			Section sec = itSec.next();
System.out.println("\nFixing section: "+sec.getName()+"\n");
bw.append("Fixing section: "+sec.getName()+"\n");
			int secOrder = sec.getSectionOrder();
			if (orderSec != null && orderSec.compareTo(secOrder) != 0)
				continue;
			
			for (Iterator<Patient> itPat = patients.iterator(); itPat.hasNext();) {
				Patient aPat = itPat.next();
// System.out.println ("Fixing patient '"+aPat.getCodpatient()+"' ("+aPat.getId()+")\n");
System.out.print("#");
bw.append("** Fixing patient '"+aPat.getCodpatient()+"' ("+aPat.getId()+")\n");				
				List<AbstractItem> allItems = getAllParentItems(prjId, intrId, secOrder);
				
				fixedAns += fixAnswers (allItems, aPat.getId());
bw.flush();
			}
System.out.println();
		}
bw.append("======================================");
bw.append("Total missing answers fixed: "+fixedAns);
bw.flush();
		return fixedAns;
	}
	
	
	
	
/**
 * Fixes all missing answers for all interviews in the entire project aPrj
 * @param aPrj, a project
 * @return the number of answer missing which were fixed for aPrj project
 */	
	public int fixProject (Project aPrj) throws IOException {
		int fixedAns = 0;
		
bw.append("Fix project '"+aPrj.getName()+"' ("+aPrj.getId()+")\n");
		List<Interview> intrvs = aPrj.getInterviews();
		for (Iterator<Interview> itIntrv = intrvs.iterator(); itIntrv.hasNext();) {
			Interview intrv = itIntrv.next();
bw.append("\nFix interview '"+intrv.getName()+"' ("+intrv.getId()+")\n");		

			fixIntrv (aPrj, intrv, null);
/*
			Integer intrId = intrv.getId(), prjId = aPrj.getId();
			List<Patient> patients = getSubjects4Intrv (intrv);
			
			List<Section> secs = 
				HibController.SectionCtrl.getSectionsFromIntrv(hibSess, intrv);
			
			for (Iterator<Section> itSec = secs.iterator(); itSec.hasNext();) {
				Section sec = itSec.next();
				int secOrder = sec.getSectionOrder();
				
				for (Iterator<Patient> itPat = patients.iterator(); itPat.hasNext();) {
					Patient aPat = itPat.next();
					List<AbstractItem> allItems = getAllParentItems(prjId, intrId, secOrder);
					
					fixedAns += fixAnswers (allItems, aPat.getId());
				}
				
			}
*/
		}
		return fixedAns;
	}
	
	
}
