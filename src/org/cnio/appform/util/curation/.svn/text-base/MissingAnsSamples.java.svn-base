package org.cnio.appform.util.curation;


/**
update patient set codpat = substr (codpat, 1, 5)
where codpat like '%0000';


update patient set codpat = codpat || '00'
where codpatient like '188011___';


-- from the scratch
update patient set codpatient = codpatient || '00'
where codpatient like '188011%';

update patient set codpat = codpat || '00'
where codpatient like '188%00';

*/

import java.nio.charset.Charset;
import java.io.*;
import org.cnio.appform.entity.*;
import org.cnio.appform.util.*;

import java.util.*;

import org.hibernate.*;

public class MissingAnsSamples {
	
	private Session hibSess;
	
	private final String filepath = "/Users/bioinfo/Development/Projects/appform/sql";
	public MissingAnsSamples () {
		hibSess = HibernateUtil.getSessionFactory().openSession();
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
	
	
	
	
	public void setNewPatients () {
		
		Transaction tx = null;
		String hqlpats = "from Patient p where p.codpatient like '188%00'";
		List<Patient> lPats = null;
		try {
			tx = hibSess.beginTransaction();
			Query hqlQry = hibSess.createQuery(hqlpats);
			
			lPats = hqlQry.list();
			
			for (int i=0; i<lPats.size(); i++) {
				Patient curr = lPats.get(i);
				Patient newPat = new Patient ();
				newPat.setCodCaseCtrl(curr.getCodCaseCtrl());
				newPat.setCodHosp(curr.getCodHosp());
				newPat.setCodPrj(curr.getCodPrj());
				
				String codPatient = curr.getCodpatient();
				newPat.setCodpatient(codPatient.substring(0, codPatient.length()-2));

				String codPat = curr.getCodSubject();
				newPat.setCodSubject(codPat.substring(0, codPat.length()-2));
				
				hibSess.save(newPat);
System.out.println("new pat: "+newPat.getCodpatient()+"|"+newPat.getCodSubject());				
			}
			tx.commit();
		}
		catch (HibernateException ex) {
			pukeExc (tx, ex, "MissingAnsSamples.setNewPatients");
		}
		
	}
		
	
	
	public void assignNewPatients () {
		
		String hqlNewPats = "from Patient p " +
				"where p.codpatient like '188011___' order by p.codpatient";
		Transaction tx = null;
		List<Patient> newPats = null;
		
// Question stuff for new questionnaire
		List<Question> newQues = getQuestions4IdPat();
		
		try {
			
			BufferedReader a1a5In = null;
			
			tx = hibSess.beginTransaction();
			
			Query qry = hibSess.createQuery(hqlNewPats);
			newPats = qry.list();
			if (newPats == null || newPats.size() == 0)
				return;
			
			Interview intrv = (Interview)hibSess.get(Interview.class, 3700);
			AppUser usr = (AppUser)hibSess.get(AppUser.class, 750);
			AppGroup grp = (AppGroup)hibSess.get(AppGroup.class, 304);
			
// AnswerItem associated to the new questionnaire. Only FreeText is necessary			
			AnswerItem aitFreeTxt = (AnswerItem)hibSess.get(AnswerItem.class, new Long(5660));
			
// start scanning just created patients			
			for (Iterator<Patient> it = newPats.iterator(); it.hasNext();) {
				Patient newPat = it.next();
System.out.print("** patient "+newPat.getCodpatient());

// save the performance				
				Performance perf = new Performance (usr, intrv, newPat, grp);
				Integer perfId = (Integer)hibSess.save(perf);
System.out.print("...saving performance");				

// save the history				
				PerfUserHistory puh = new PerfUserHistory(usr, perf);
				hibSess.save(puh);
System.out.println("... saving performance history");

// do the interview				
				int qCount = 0; // this is to choose the appropiate question from list
//				for (Iterator<Object[]> it2 = a1a5ans.iterator(); it2.hasNext();) {
//					Object[] row = it2.next();
				
				String line;
				a1a5In = new BufferedReader (new InputStreamReader (
						new FileInputStream (filepath+"/fileaux.txt"), Charset.defaultCharset()));
				while ((line = a1a5In.readLine()) != null) {
					Object[] row = line.split(",");
					
					if (((String)row[1]).equalsIgnoreCase(newPat.getCodpatient())) {
						String ansVal = (String)row[8];
						Integer ansNum = Integer.decode((String)row[5]);
						Integer ansOrd = Integer.decode((String)row[6]);
						Integer itemOrder = Integer.decode((String)row[3]);
// System.out.println ("ansVal:"+ansVal+", ansNum:"+ansNum+", ansOrd: "+ansOrd+", itemOrder:"+itemOrder);						
						Answer newAnswer = new Answer (ansVal);
						newAnswer.setAnswerOrder(ansOrd);
						newAnswer.setAnswerItem(aitFreeTxt);
						hibSess.save(newAnswer);
						
						Question q = newQues.get(itemOrder-1);
						
						PatGivesAns2Ques pga = 
									new PatGivesAns2Ques (q, newAnswer, newPat, ansNum, ansOrd);
						hibSess.save(pga);
						
System.out.println ("saving answer "+ansVal+" for "+ q.getCodquestion()+" and itemOrder:"+itemOrder);
						qCount++;
					}
				} // EO while a1a5answers
				a1a5In.close();
				a1a5In = null;
			} // EO for patients
			
			tx.commit();
		}
		catch (HibernateException ex) {
			ex.printStackTrace();
			pukeExc (tx, ex, "MissingAnsSamples.assignNewPatients");
		}
		catch (IOException ex2) {
			ex2.printStackTrace();
		}
	}
	
	
	
	
	public List<Question> getQuestions4IdPat () {
		Transaction tx = null;
		String hql = "select q from Question q join q.parentSec s join " +
				"s.parentInt i where i.id = 3700 and s.sectionOrder = 1 " +
				"order by q.itemOrder";
		
		List<Question> questions = null;
		
		try {
			tx = hibSess.beginTransaction();
			Query qry = hibSess.createQuery(hql);
			
			questions = qry.list();
			tx.commit();
		}
		catch (HibernateException ex) {
			pukeExc (tx, ex, "MissingAnsSamples.getQuestions4IdPat");
		}
		
		return questions;
	}
	
	

	
	public List<Object[]> getA1A5answers () {
		Transaction tx = null;
		String sqlQry = "select p.idpat, substr(p.codpatient, 1, 9)," +
				" q.codquestion as codq, it.item_order, " +
				"q.idquestion, pga.answer_number, pga.answer_order," +
				"	a.idanswer, a.thevalue " +
				"from answer a, pat_gives_answer2ques pga, question q, item it, " +
				"section s, interview i, patient p " +
				"where i.idinterview = 2400 " +
				" and i.idinterview = s.codinterview " +
				" and s.section_order = 1" +
				" and s.idsection = it.idsection" +
				" and it.iditem = q.idquestion" +
				" and it.item_order <= 5" +
				" and q.idquestion = pga.codquestion" +
				" and pga.codanswer = a.idanswer" +
				" and pga.codpat = p.idpat" +
				" order by 2, 4";
		
		BufferedWriter fileAux = null;
		
		List<Object[]> res = null;
		try {
			fileAux = new BufferedWriter (
					new OutputStreamWriter (
							new FileOutputStream (filepath+"/fileaux.txt"), Charset.defaultCharset()));
			
			tx = hibSess.beginTransaction();
			SQLQuery theQry = hibSess.createSQLQuery(sqlQry);
			
			res = theQry.list();
			
			tx.commit();
		}
		catch (HibernateException ex) {
			pukeExc (tx, ex, "MissinAnsSamples.getA1A5answers");
		}
		catch (Exception ex2) {
			ex2.printStackTrace();
		}
		
		if (fileAux != null) {
			for (Iterator<Object[]> it = res.iterator(); it.hasNext();) {
				Object[] row = it.next();
				Integer idPat = (Integer)row[0];
				String patCod = (String)row[1];
				String qCod = (String)row[2];
				Integer itemOrder = (Integer)row[3];
				Integer idQues = (Integer)row[4];
				Integer idAnswer = (Integer)row[7];
				String ansVal = (String)row[8];
				Integer ansNum = (Integer)row[5];
				Integer ansOrd = (Integer)row[6];
				
				String out = idPat+","+patCod+","+qCod+","+itemOrder+",";
				out += idQues+","+ansNum+","+ansOrd+","+idAnswer+","+ansVal+"\n";
				try {
					fileAux.append(out);
					fileAux.flush();
				}
				catch (IOException ex) {
					ex.printStackTrace();
				}
				
	// System.out.println ("subject: "+patCod+"-> '"+qCod+"' val: "+ansVal+" ("+ansNum+","+ansOrd+")");
			}
			
		}
		
		return res;
	}
	
	

}
