package org.cnio.appform.test;


import org.cnio.appform.util.*;
import org.cnio.appform.util.curation.InterviewsCuration;
import org.cnio.appform.util.curation.MissingAnsSamples;
import org.cnio.appform.entity.*;

import java.io.IOException;
import java.util.*;

/**
 * @author bioinfo
 *
 */
public class CurTest {
	
	
	public static void main (String args[]) {
		
		org.hibernate.Session hibSes = HibernateUtil.getSessionFactory().openSession();
		InterviewsCuration ic = 
			new InterviewsCuration (hibSes, "qes-curation-full.log", true);
		IntrvController intrvCtrl = new IntrvController (hibSes);
//		IntrvFormCtrl intrvFC = new IntrvFormCtrl (hibSes);
//		IntrvController intrvCtrl = new IntrvController (hibSes);
		
		
		String lastArg = "";
		String prjArg = "", intrv = "", patCod = "", file = "", sec = "";
		
		if (args.length == 0 || args[0].equalsIgnoreCase("-h")) {
			String helpMsg = "\nDatabase curator:\n\nOptions are (order is irrelevant):\n" +
					"\t-p project name\n" +
					"\t-i questionnaire name\n" +
					"\t-u subject code\n" +
					"\t-s section order in questionnaire\n\nNotes:\n" +
//					"\t-f file name (absolute or relative)\n\n" +
					"* Spaces between options and names are relevant.\n" +
					"* If -u parameter is specified, -s parameter will be ignored.\n" +
					"* If -u parameter specifies a non valid subject code, the curation" +
					" will be performed for all subjects in the questionnaire (it could be" +
					"take a while, so be aware of it)\n";
			System.out.println (helpMsg);
			return;
		}
		
		
		for (String arg: args) {
			if (arg.startsWith("-")) 
				lastArg = arg;

			else {
				if (lastArg.equalsIgnoreCase("-p"))
					prjArg += prjArg.equals("")? arg: " "+arg;
				
				if (lastArg.equalsIgnoreCase("-i"))
					intrv += intrv.equals("")? arg: " "+arg;
				
				if (lastArg.equalsIgnoreCase("-u"))
					patCod += patCod.equals("")? arg: " "+arg; 
				
				if (lastArg.equalsIgnoreCase("-s"))
					sec += sec.equals("")? arg: " "+arg;
				
			}
		}
		
		
		if (prjArg.equals("")) {
			System.out.println ("The name of the project has to be provided with the form" +
					" -p project_name");
			return;
		}
		
		if (intrv.equals("")) {
			System.out.println ("The name of the interview has to be provided with the form" +
					" -i questionnaire_name");
			return;
		}
		
		
		if (sec.equals("")) {
			System.out.println ("The section order for the questionnaire has to be provided with the form" +
					" -s section_order");
			return;
		}
/*		
		if (file.equals("")) {
			System.out.println ("The name of the output file has to be provided with the form" +
					" -f filename. It can be absolute or relative.");
			return;
		}
*/		
		
		Project prj = null;
		Interview theIntrv = null;
		List<Project> prjs = HibernateUtil.getProjectByName(hibSes, prjArg);
		if (prjs != null && prjs.size() > 0) {
			prj = prjs.get(0);
			List<Interview> intrvs = intrvCtrl.getIntr4Proj(prj, intrv);
			
			if (intrvs != null && intrvs.size() > 0)
				theIntrv = intrvs.get(0);
			else {
				System.err.println("No interview with the name '"+intrv+"' found " +
						"for project '"+prjArg+"'");
				return;
			}
		}
		else {
			System.err.println("No projects found with the name '"+prjArg+"'");
			return;
		}
		
		
		
//		Interview qes = (Interview)hibSes.get(Interview.class, 50);
		try {
			
			Integer orderSec = Integer.decode(sec);
			if (patCod.equals("") == false)
				ic.fixPerformance(prj, theIntrv, patCod);
			else
				ic.fixIntrv(prj, theIntrv, orderSec);
				
//			ic.fixPerformance(prj, theIntrv, "157011031");
//			ic.fixSection(prj, qes, "157011003", null);
		}
		catch(IOException ex) {
			ex.printStackTrace();
		}
		
	}
	
	
	
	
/*	
	public void main () {
		int secOrder = 12;
		InterviewsCuration fc = new InterviewsCuration ();
		List<AbstractItem> items = fc.getRepetibleParents(50, 50, secOrder);
		List<AbstractItem> allItems = fc.getAllParentItems(50, 50, secOrder);
		
		
		
		
**
 * for all projects
 * 	for all interviews
 * 		for all sections
 * 			get repeatable containers
 * 			for allSubjects in currentInterview
 * 				get Answers for container
 * 				get MaxNumber of answers
 * 				group answers by numbers
 * 				for all answers in children not in answers
 * 					create a new question
 *
		CurTest test = new CurTest ();
		
//		(new CurTest()).fixContainers (items, fc);

		if (allItems == null)
			System.out.println("No items for interview 50 and section order "+secOrder);
		
		else {
			Integer patId = 1009; // 1552;
			
// loop over repeatable containers
			for (Iterator<AbstractItem> it = allItems.iterator(); it.hasNext();) {
				AbstractItem container = it.next();
				
				if (container.getContainees().size() == 0) {
					if (container instanceof Question)
						test.fillAnswer(((Question)container), fc, patId, 0);
				}
				else {
					List<Question> children = fc.getChildren(container);
					List<PatGivesAns2Ques> answered = fc.getAnswers4Items(50, 50, container, patId); // 550);
	System.out.println(container.getId()+": "+ children.size()+" containees");
					
	// To get the maximum number of items answered, the maximum answered.getNumAnser()
	// should be got
					int maxAnswers = fc.getMaxAnswers (answered);
									
	//				Iterator<PatGivesAns2Ques> itpga = answered.iterator();
					
	// Loop maxAnswers times over children: that will be the whole set of questions
	// should have any answer. Then, if any element in answered list doesn't correspond
	// with some element in children, has to be created
					for (int iAns=0; iAns < maxAnswers; iAns++) {
	System.out.println ("\nnum of answer: "+(iAns+1));
						Iterator<Question> itChild = children.iterator();
						while (itChild.hasNext()) {
							Question q = itChild.next();
							int numOfAnsItems = q.getQuestionAnsItems().size();
							
							test.fillAnswer (q, fc, patId, iAns);
							
						} // EO loop over (repeatable) container children
						
					} // EO loop over number of answers for repeatable container
					
					
					// EO while itChild
					System.out.println("============================");
				}
				
			} // EO loop over repeatable containers
			
		} // EO items list is not null
	}
	*/
	
	

/*
	private boolean fillAnswer (Question q, InterviewsCuration fc, Integer patId, int numOfQues) {
		int numOfAnsItems = q.getQuestionAnsItems().size();
		
// Get the answers for this question and this number of answer
		List<PatGivesAns2Ques> ans4Ques = fc.getAnswers4Ques(q, numOfQues+1, patId);
		for (int ordAns = 0; ordAns < numOfAnsItems; ordAns++) {
			PatGivesAns2Ques pga = 
				(ans4Ques == null || ans4Ques.size() <= ordAns)?null: ans4Ques.get(ordAns);
			
			if (pga == null || pga.getAnswerOrder() != ordAns+1) 
				fc.addAnswer (patId, q, ordAns+1, numOfQues+1);
			
			else
System.out.println ("Answer for "+q.getCodquestion()+": q"+q.getId()+"-"+(numOfQues+1)+"-"+(ordAns+1)+" = "+
pga.getAnswer().getValue());
				
		} // EO answer items loop for a question
		return false;
		
	}
	
	
	
	
	private void fixContainers (List<AbstractItem> containers, InterviewsCuration fc) {
		
		int secOrder = 12;
	
		if (containers == null)
			System.out.println("No items for interview 50 and section order "+secOrder);
		
		else {
			Integer patId = 102; // 1200; // 1009;
			
// loop over repeatable containers
			for (Iterator<AbstractItem> it = containers.iterator(); it.hasNext();) {
				AbstractItem container = it.next();
				
				List<Question> children = fc.getChildren(container);
				List<PatGivesAns2Ques> answered = fc.getAnswers4Items(50, 50, container, patId); // 550);
System.out.println(container.getId()+": "+ children.size()+" containees");
				
// To get the maximum number of items answered, the maximum answered.getNumAnser()
// should be got
				int maxAnswers = fc.getMaxAnswers (answered);
								
//				Iterator<PatGivesAns2Ques> itpga = answered.iterator();
				
// Loop maxAnswers times over children: that will be the whole set of questions
// should have any answer. Then, if any element in answered list doesn't correspond
// with some element in children, has to be created
				for (int iAns=0; iAns < maxAnswers; iAns++) {
System.out.println ("\nnum of answer: "+(iAns+1));
					Iterator<Question> itChild = children.iterator();
					while (itChild.hasNext()) {
						Question q = itChild.next();
						int numOfAnsItems = q.getQuestionAnsItems().size();
						
// Get the answers for this question and this number of answer
						List<PatGivesAns2Ques> ans4Ques = fc.getAnswers4Ques(q, iAns+1, patId);
						for (int ordAns = 0; ordAns < numOfAnsItems; ordAns++) {
							PatGivesAns2Ques pga = 
								(ans4Ques == null || ans4Ques.size() <= ordAns)?null: ans4Ques.get(ordAns);
							
							if (pga == null || pga.getAnswerOrder() != ordAns+1) 
								fc.addAnswer (patId, q, ordAns+1, iAns+1);
							
							else
System.out.println ("Answer for "+q.getCodquestion()+": q"+q.getId()+"-"+(iAns+1)+"-"+(ordAns+1)+" = "+
			pga.getAnswer().getValue());
								
						} // EO answer items loop for a question
						
					} // EO loop over (repeatable) container children
					
				} // EO loop over number of answers for repeatable container
				
				
				// EO while itChild
				System.out.println("============================");
			} // EO loop over repeatable containers
			
		} // EO items list is not null
	}
*/
	
	
	
/*	
	private void fckMethod () {
		List<Object[]> list = null;
		
		MissingAnsSamples cure = new MissingAnsSamples ();
		list = cure.getA1A5answers();
		for (Iterator<Object[]> it = list.iterator(); it.hasNext();) {
			Object[] row = it.next();
			String patCod = (String)row[1];
			String ansVal = (String)row[8];
			Integer ansNum = (Integer)row[5];
			Integer ansOrd = (Integer)row[6];
			String qCod = (String)row[2];
// System.out.println ("subject: "+patCod+"-> '"+qCod+"' val: "+ansVal+" ("+ansNum+","+ansOrd+")");
		}
System.out.println("Tot: "+list.size()+" answers found");
		
		List<Question> questions = cure.getQuestions4IdPat();
		for (Iterator<Question> it = questions.iterator(); it.hasNext();) {
			Question q = it.next();
			System.out.println("id:"+q.getId()+";cod: "+q.getCodquestion()+" -> "
					+q.getContent().trim());
		}
System.out.println("*****************************************");		
//		cure.setNewPatients();
		cure.assignNewPatients();
		
	}
*/
}
