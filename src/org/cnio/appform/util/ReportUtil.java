package org.cnio.appform.util;

import static org.hibernate.criterion.Restrictions.*;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.AnnotationConfiguration;
import org.hibernate.cfg.AnnotatedClassType;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.Transaction;
import org.hibernate.Criteria;
import org.hibernate.HibernateException;
import org.hibernate.criterion.*;

import org.cnio.appform.entity.*;

public class ReportUtil {

	private Session hibSes;
	
	public ReportUtil (Session hibSess) {
		hibSes = hibSess;
	}
	
	
/**
 * This method is supossed to implement the following query:
 * select s.section_order, s.name, q.codquestion
	from interview i, section s, item it, question q
	where i.idinterview = 50
	  and s.codinterview = i.idinterview
	  and it.idsection = s.idsection
	  and it.iditem = q.idquestion
	order by 1;
 * @param theIntrv
 */	
	public List<Object[]> getQuestionCodes (Interview theIntrv) {
		String hql = "select q.id, q.codquestion, " +
				"substring(q.codquestion, 2, length(q.codquestion)), q.parentSec.name, " +
				"q.parentSec.sectionOrder" +
				" from Question q where q.parentSec.parentInt=:intrv order by 5,1,3";
		Transaction tx = null;
		List<Object[]> questions = null;
		try {
			tx = hibSes.beginTransaction();
			Query qry = hibSes.createQuery(hql);
			qry.setEntity("intrv", theIntrv);
			
			questions = qry.list();
			tx.commit();
		}
		catch (HibernateException hibEx) {
			if (tx != null)
				tx.rollback();
			hibEx.printStackTrace();
		}
		
		return questions;
		
	}
	
	
	
/**
 * Get the subject codes who was previously performed an interview to belonging to
 * a secondary group secGrp
 * @param intrv, the questionnaire which the interview was based in
 * @param secGrp, the secondary group
 * @return a list with the retrieved subject codes
 */
	public List<String> getSubjectCodes (Interview intrv, AppGroup secGrp) {
		Transaction tx = null;
		String strQry = "select p.codpatient from Patient p join p.performances pf where " +
				"pf.interview=:intrv and pf.group=:grp and " +
				"p.codpatient <> '"+org.cnio.appform.util.IntrvFormCtrl.NULL_PATIENT+
				"' and p.codpatient <> '"+org.cnio.appform.util.IntrvFormCtrl.TEST_PATIENT+
				"' order by 1";
		List<String> aux = null;
		
		try {
			tx = hibSes.beginTransaction();
			Query qry = hibSes.createQuery(strQry);
			qry.setEntity("intrv", intrv);
			qry.setEntity("grp", secGrp);
			
			aux = qry.list();
			tx.commit();
			
			return aux;
		}
		catch (HibernateException ex) {
			if (tx != null)
				tx.rollback();
			
			String msgLog = "Unable to get subject codes for '" + intrv.getName() + "'" +
					" and secondary group '"+secGrp.getName()+"'";
      LogFile.error(msgLog);
      LogFile.error(ex.getLocalizedMessage());
      StackTraceElement[] stack = ex.getStackTrace();
      LogFile.logStackTrace(stack);
      
      return null;
		}
	} // eo getSubjectCodes
	
}
