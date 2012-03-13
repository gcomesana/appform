package org.cnio.appform.test;

import java.io.*;
import org.cnio.appform.entity.*;

import org.cnio.appform.util.*;
import org.cnio.appform.util.dump.*;
import org.cnio.appform.audit.*;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Criteria;
import org.hibernate.HibernateException;
import org.hibernate.Transaction;
// import static org.hibernate.criterion.Restrictions.*;
import org.hibernate.criterion.Restrictions;
import org.hibernate.Query;
import org.hibernate.SQLQuery;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.Hashtable;
import java.util.Enumeration;
import java.util.List;
import java.util.Vector;

import java.io.UnsupportedEncodingException;
import java.net.*;

// import javax.servlet.http.HttpSession;


import org.apache.commons.lang.StringEscapeUtils;

public class ClassTest {

	Session hibSess;
	
	public ClassTest () {
		SessionFactory sf = HibernateUtil.getSessionFactory();
		hibSess = sf.openSession();
	}
	
	
// it works con createinterview
	public Session getHibSes () {
		return hibSess;
	}
	
	
// Falla con createinterview
	public Session getCurrentHibSes () {
		hibSess = HibernateUtil.getSessionFactory().getCurrentSession();
		
		return hibSess;
	}
	
// Falla con createinterview
	public Session getCurrentSession () {
		return HibernateUtil.getSessionFactory().getCurrentSession();
	}
	
	
	public Session openSession () {
		hibSess = HibernateUtil.getSessionFactory().openSession();
		
		return hibSess;
	}
	
	
	public void closeHibSes () {
		hibSess.close();
	}
	
	
	
	private List<Object[]> digger (Integer grpId, Integer intrvId, String codPat) {
		
		String qryStr =
	      "select p.codpatient, q.codquestion as codq, a.thevalue, s.section_order,"+
	       " it.item_order, pga.answer_order, pga.answer_number, it.\"repeatable\" as itrep"+
	      " from patient p, pat_gives_answer2ques pga, appgroup g, performance pf," +
	          " question q, answer a, interview i, item it, section s" +
	      " where g.idgroup = :idgrp" +
	        " and i.idinterview = :idintrv"+ 
	        " and pf.codinterview = i.idinterview"+
	        
	        " and s.codinterview = i.idinterview"+
	        " and pf.codpat = p.idpat"+
	        " and pga.codpat = p.idpat"+
	        " and pga.codquestion = q.idquestion"+
	        " and pga.codanswer = a.idanswer"+
	        " and q.idquestion = it.iditem"+
	        " and it.idsection = s.idsection"+
	        " and p.codpatient = :patcode"+
	      " order by 1, 4, 7, 5, 2, 6;";
	
	 
	  Transaction tx = null;
	  List<Object[]>res = null;
	
	  try {
	    tx = hibSess.beginTransaction();
	    SQLQuery qry = hibSess.createSQLQuery(qryStr);
	    qry.setString("patcode", codPat);
	    qry.setInteger ("idgrp", grpId);
	    qry.setInteger ("idintrv", intrvId);
	
	    res = qry.list();
	//    res.foreach(elem => println(elem.toString))
	    tx.commit();
	  }
	  catch (HibernateException ex) {
	  	if (tx != null)
	  		tx.commit();
	  	ex.printStackTrace();
	  }
		
		return res;
	}
	
	
	
	private void testViews (Interview intrv) {
		
		Criteria crit = this.hibSess.createCriteria(org.cnio.appform.entity.SimpleTypesView.class);
		crit.add(Restrictions.eq ("intrvOwner", intrv));
		
		List<SimpleTypesView> res = crit.list();
		
		System.out.println ("Num of results: " + res.size());
		for (SimpleTypesView etv: res) {
			System.out.println ("idansit: "+etv.getIdAnsitem()+"; name: "+etv.getAnsItName());
		}
	}
	
	
	
	
/**
 * @param args
 */
	public static void main(String[] args) {
System.out.println("Starting script...");		
		
		ClassTest test = new ClassTest ();

		String username = "cmurta@imim.es", userid = "100";
		String ieName = "pcunningham@tcd.ie", ukName="barny", deName="fmeyer",
				seName = "glarsson", itName="apietrielli";
		String intrvId = "1301";
//		String patCode = "01010101";
//		String patCode = "17171717";
		String patCode = "011030";
		String secId = "200";
		
		String testStr = "a–ldsnf–ajk bn–aoiuhpa–dg. a–ldsnf–ajk bn–aoiuhpa–dg. a–ldsnf–ajk bn–aoiuhpa–dg. a–ldsnf–ajk bn–aoiuhpa–dg. a–ldsnf–ajk bn–aoiuhpa–dg. a–ldsnf–ajk bn–aoiuhpa–dg. a–ldsnf–ajk bn–aoiuhpa–dg. a–ldsnf–ajk bn–aoiuhpa–dg. a–ldsnf–ajk bn–aoiuhpa–dg. a–ldsnf–ajk bn–aoiuhpa–dg. a–ldsnf–ajk bn–aoiuhpa–dg. a–ldsnf–ajk bn–aoiuhpa–dg. a–ldsnf–ajk bn–aoiuhpa–dg. a–ldsnf–ajk bn–aoiuhpa–dg. a–ldsnf–ajk bn–aoiuhpa–dg. a–ldsnf–ajk bn–aoiuhpa–dg. a–ldsnf–ajk bn–aoiuhpa–dg. a–ldsnf–ajk bn–aoiuhpa–dg. a–ldsnf–ajk bn–aoiuhpa–dg. a–ldsnf–ajk bn–aoiuhpa–dg. a–ldsnf–ajk bn–aoiuhpa–dg. a–ldsnf–ajk bn–aoiuhpa–dg. a–ldsnf–ajk bn–aoiuhpa–dg. ";

		Integer usrId = Integer.decode(userid);
		List<AbstractItem> itemsSec = null;
		
		username = "lpalencia";
//		userid = "101";
		userid = "2";
		usrId = Integer.decode(userid);
		AppUser user = (AppUser)test.getHibSes().get(AppUser.class, usrId);
		AppUserCtrl usrCtrl = new AppUserCtrl (test.getHibSes());
		

		IntrvFormCtrl intrFormCtrl = new IntrvFormCtrl(test.getHibSes());
		IntrvController intrCtrl = new IntrvController (test.getHibSes());
		
//		int intrvid = intrCtrl.createInterview("Test Sample Go!", testStr, 351, 101, false, true, true);
		
//		Interview clonedIntrv;
//		test.cloneIntrv(101);
	
		
		SqlDataRetriever sqldr = new SqlDataRetriever();
		
		java.sql.ResultSet rs = sqldr.getResultSet("188", 4100, null, 3);
		
		sqldr.printResultsetOut(rs);
		

/*		
		Interview idcIntrv = (Interview)test.getHibSes().get(Interview.class, 1301),
				ispIntrv = (Interview)test.getHibSes().get(Interview.class, 1750),
				dietaIntrv = (Interview)test.getHibSes().get(Interview.class, 1250),
				qalIntrv = (Interview)test.getHibSes().get(Interview.class, 1350),
				engQes = (Interview)test.getHibSes().get(Interview.class, 1650),
				sampleIntrv = (Interview)test.getHibSes().get(Interview.class, 2300);
		
		Interview qesIntrv = (Interview)test.getHibSes().get(Interview.class, 50);

//		Patient pat = intrFormCtrl.getPatientFromCode(IntrvFormCtrl.NULL_PATIENT);


//		List<AppGroup> userGroups = usrCtrl.getGroups(user);
		System.out.println("*=====================================*");
		test.testViews(qesIntrv);
		
//		AppGroup grp = usrCtrl.getMainGroup(usrCtrl.getUser(ieName));
//		intrCtrl.createInterview("TestLog Intrv", "Nothing to say", 50, 100);
		
		
		Transaction tx = null;
		AppGroup deGrp = usrCtrl.getPrimaryGroup (usrCtrl.getUser("gereditor")),
						enGrp = usrCtrl.getPrimaryGroup (usrCtrl.getUser("ukeditor")),
						ieGrp = usrCtrl.getPrimaryGroup (usrCtrl.getUser("ieuser")),
						esGrp = usrCtrl.getPrimaryGroup (usrCtrl.getUser("aalfaro")),
						itGrp = usrCtrl.getPrimaryGroup (usrCtrl.getUser("rtosi"));
		
		Patient patbis = (Patient)test.getHibSes().get(Patient.class, new Integer(702));
		AppUser userBis = (AppUser)test.getHibSes().get(AppUser.class, 503);
		IntrvFormCtrl formCtrl = new IntrvFormCtrl (test.getHibSes());
		AppGroup frGrp = usrCtrl.getGroupFromName("FRANCE");
		AppGroup swGrp = usrCtrl.getGroupFromName("SWEDEN");
		
		
// GROUP FRANCE IS NOT ASSIGNED TO ANYONE!!!!! TRY HERE!!
		
		try { 
			Session hibSes = test.getHibSes();
// postData: what=rmvAns&ids=1256-2-1,1257-2-1,1256-2-2
			
			AppGroup grp = usrCtrl.getGroupFromName("Hospital del Mar"); 
			System.out.println ("name: "+grp.getName()+" ("+grp.getId()+")");
			
			grp = usrCtrl.getGroupFromName("Hospital de la Santa Creu I San Pau");
			System.out.println ("name: "+grp.getName()+" ("+grp.getId()+")");
			
			grp = usrCtrl.getGroupFromName("Hospital Ram—n y Cajal");
			System.out.println ("name: "+grp.getName()+" ("+grp.getId()+")");
			
test.myPrt("");

		}
		catch (Exception ex) {
			if (tx != null)
				tx.rollback();
			
ex.printStackTrace();
		}			
*/
		
		test.closeHibSes();
		
System.out.println ("acabose");
	}
	
	
	
	public void testDelete (Integer idIntrv, ClassTest test) {
		Transaction tx = null;
		try {
			tx = test.hibSess.beginTransaction();
			Interview it = 
				(Interview)test.hibSess.get(Interview.class, idIntrv);
			String theName = it.getName();
		
System.out.println ("About to delete "+theName);
			test.hibSess.delete(it);
			tx.commit();
		}
		catch (Exception ex) {
			tx.rollback ();
			
			ex.printStackTrace();
		}
		
System.out.println ("If no exception, interview with id "+idIntrv+" was deleted");
	}
	
	

	private void cloneIntrvs (Session hibSes, IntrvController intrCtrl) {
		Project isbPrj = (Project)hibSes.get(Project.class, 101);
		Project panPrj = (Project)hibSes.get(Project.class, 50);
		
		
//		Collection<Project> lPrj = HibernateUtil.getProjectByName(hibSes, "QES", -1);
//		prj = lPrj.iterator().next();

		//			Interview ispClone = intrCtrl.replicateIntrv(ispIntrv, deGrp);
//System.out.println("Interview "+ispClone.getName()+" was cloned with id "+ispClone.getId());
//		Interview idcClone = intrCtrl.replicateIntrv(idcIntrv, deGrp);
//System.out.println("Interview "+idcClone.getName()+" was cloned with id "+idcClone.getId());

/*		
		Interview deSamplePan = 
			intrCtrl.replicateIntrv (2300, deGrp, isbPrj, "Samples_DE");
System.out.println("Interview: "+deSamplePan.getName()+" was created");
*
		Interview deSamplePan = 
			intrCtrl.replicateIntrv (2300, deGrp, panPrj, "Samples_DE");
System.out.println("Interview: "+deSamplePan.getName()+" was created");

		
		Interview itSamplePan = 
			intrCtrl.replicateIntrv (2300, itGrp, panPrj, "Samples_IT");
System.out.println("Interview: "+itSamplePan.getName()+" was created");

		Interview itSampleIsb = 
			intrCtrl.replicateIntrv (2300, itGrp, isbPrj, "Samples_IT");
System.out.println("Interview: "+itSampleIsb.getName()+" was created");		
					

		Interview ieSampleIsb = 
			intrCtrl.replicateIntrv (2300, ieGrp, isbPrj, "Samples_IE");
System.out.println("Interview: "+ieSampleIsb.getName()+" was created");

		Interview ieSamplePan = 
			intrCtrl.replicateIntrv (2300, ieGrp, panPrj, "Samples_IE");
System.out.println("Interview: "+ieSamplePan.getName()+" was created");			


		Interview ukSampleIsb = 
			intrCtrl.replicateIntrv (2300, enGrp, isbPrj, "Samples_UK");
System.out.println("Interview: "+ukSampleIsb.getName()+" was created");

		Interview ukSamplePan = 
			intrCtrl.replicateIntrv (2300, enGrp, panPrj, "Samples_UK");
System.out.println("Interview: "+ukSamplePan.getName()+" was created");


		Interview swSampleIsb = 
			intrCtrl.replicateIntrv (2300, swGrp, isbPrj, "Samples_SW");
System.out.println("Interview: "+swSampleIsb.getName()+" was created");

		Interview swSamplePan = 
			intrCtrl.replicateIntrv (2300, swGrp, panPrj, "Samples_SW");
System.out.println("Interview: "+swSamplePan.getName()+" was created");			
*/
		
/*			
		System.out.println("name:"+sampleClone.getName());
		System.out.println("src:"+sampleClone.getSourceIntrv().getName());
		System.out.println("proj: "+sampleIntrv.getParentProj().getName()+" vs " +
				sampleClone.getParentProj().getName());
*/			
	}
	
	
	
	
	
	private void assignTypes2Intrv (Interview intrv) throws CloneNotSupportedException {
		String hql = "from AnswerItem where intrvOwner is null";
		Transaction tx = null;
		List<AnswerItem> lAi;
		Session mySes = this.getHibSes();
myPrt("Assigning types to interview "+intrv.getName());

		try {
			tx = mySes.beginTransaction();
			Query hqlQry = this.getHibSes().createQuery(hql);
			
			lAi = hqlQry.list();
			for (Iterator<AnswerItem> itAi = lAi.iterator(); itAi.hasNext();) {
				AnswerItem theAi = itAi.next(), newAi;
				if (theAi instanceof AnswerType)
					newAi = (AnswerItem)((AnswerType)theAi).clone();
				
				else
					newAi = (AnswerItem)((EnumType)theAi).clone();

				Long newAiId = (Long)mySes.save(newAi);
myPrt("setting: "+newAiId+" -> "+newAi.getName());

				intrv.setAnswerItem(newAi);
				
				mySes.save(newAi);
			}
			
			tx.commit();
		}
		catch (HibernateException ex) {
			if (tx != null)
				tx.rollback();
			
			ex.printStackTrace();
		}
		catch (CloneNotSupportedException cloEx) {
			if (tx != null)
				tx.rollback();
			
			cloEx.printStackTrace();
		}
		
	}
	
	

	
	
/**
 * Cloning interview test with binary streams...
 * @param intrvId
 * @return
 */	
	public Interview cloneIntrv (Integer intrvId) {
		Interview source = null;
		Interview copy = null;
		
		ByteArrayOutputStream bos = new ByteArrayOutputStream();
		ObjectOutputStream out;
		try
		{
			source = (Interview)getCurrentSession().get(Interview.class, intrvId);
		
// Materialize the associations by trying to reach 'em.
			List<Section> sections = source.getSections();
//			Iterator iterator = accountVersionStatuses.iterator();
			out = new ObjectOutputStream(bos);
			try {
				out.writeObject(source);
				out.flush();
			}
			finally {
				out.close();
			}
		
		// Retrieve an input stream from the byte array and read
		// a copy of the object back in.
			ByteArrayInputStream bin = new ByteArrayInputStream(bos.toByteArray());
			ObjectInputStream in = new ObjectInputStream(bin);
		
			copy = (Interview)in.readObject();
		}
		catch (ClassNotFoundException e) {
			throw new RuntimeException(e);
		}
		catch (IOException e) {
			throw new RuntimeException(e);
		}
		
//		copyOfAccountVersion.setAccountVersionId(null);
		copy.setId(null);
//		copyOfAccountVersion.setOptimisticLockVersion(0);

//		Set copiedClasses = copyOfAccountVersion.getAccountVersionStatuses();
		List<Section> copiedSecs = copy.getSections();
		for (Iterator<Section> iter = copiedSecs.iterator(); iter.hasNext();) {
			Section element = (Section)iter.next();
			element.setId(null);
		}

		getCurrentSession().save(copy);
		getCurrentSession().flush();
		
		return copy;
	}

//////////////////////////////////////////////////////////////////////////
// END OF REPLICATION TEST METHODS ///////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
	
	
	
	
	
	
	
	
	private void printUserRoles (AppUserCtrl usrCtrl) {
		List<Object[]> userRoles = usrCtrl.getAllUsers();
		int i = 0;
		AppUser old = null;
		while (i < userRoles.size()) {
			Object[] pair = userRoles.get(i);
			AppUser u = (AppUser)pair[0];
			AppuserRole ur = (AppuserRole)pair[1];
			
			if (u == old)
				System.out.print(", "+ur.getTheRole().getName());
			
			else {
				System.out.println();
				System.out.print(u.getUsername()+": "+ur.getTheRole().getName());
				old = u;
			}
			i++;
		}
	}
	
	
	
	private void getIntrv (Session hibSes, String username) {
		String idPrj = "50";
		AppUserCtrl usrCtrl = new AppUserCtrl (hibSes);
		Collection<Interview> intrCol = null;
		List<Section> sections = null;
		Collection<AbstractItem> itemCol;
		IntrvController intrvCtrl = new IntrvController (hibSes);
		
		Project prjAux = (Project)hibSes.get(Project.class, Integer.decode(idPrj));
//		pageContext.setAttribute("project", prjAux);
		AppUser user = usrCtrl.getUser(username);
		Integer usrId = user.getId();
		intrCol = intrvCtrl.getIntr4Proj(Integer.decode(idPrj), usrId);

		Interview intrv = (Interview)intrCol.iterator().next();
		
		sections = HibController.SectionCtrl.getSectionsFromIntrv(hibSes, intrv);
System.out.println("Interview ("+intrv.getId()+"): "+intrv.getName());		
		
		for (Section sec: sections) {
System.out.println("Section("+sec.getId()+"): "+sec.getName());			
			itemCol = HibernateUtil.getItems4Section(hibSes, sec);
	
			// pageContext.setAttribute("items", itemCol);
	
			// si instanceof Text, escribirlo
			// si instanceof Question, montar un item de formulario
			for (AbstractItem ai : itemCol) {
				System.out.println();
				if (ai instanceof Text) {
//					System.out.print(StringEscapeUtils.escapeHtml(ai.getContent()) + "<br>");
System.out.println("* "+ai.getContent());
				} 
				else if (ai instanceof Question) {
System.out.print("* "+ai.getContent());					
					Collection<AnswerItem> cai = 
							HibernateUtil.getAnswerTypes4Question(hibSes, ai);
					
// This is just for beautify
					if (cai.size() > 1) // multiple anser items
						System.out.println();
					
					for (AnswerItem ansi : cai) {
						if (ansi instanceof AnswerType) { // simple answer (label, number)
							AnswerType anst = (AnswerType)ansi;
/*							
							System.out.print(StringEscapeUtils.escapeHtml(ai.getContent())
									+ "&nbsp;<input type='text' name='q" + ai.getId() + "-"
									+ ansi.getAnswerOrder() + "' onblur='chk." + anst.getName()
									+ "'></input><br>"); */
							System.out.print("<input type='text' onblur='javascript'>"+
															anst.getName()+"   ");
						} 
						else if (ansi instanceof EnumType) {
							Collection<EnumItem> ceni = 
								HibController.EnumTypeCtrl.getEnumItems(hibSes, (EnumType) ansi);
/*							
							System.out.print(StringEscapeUtils.escapeHtml(ai.getContent())
									+ "&nbsp;<select name='q" + ai.getId() + "-"
									+ ansi.getAnswerOrder() + "'>");*/
							for (EnumItem eni : ceni) {
								System.out.println("- "+eni.getName()+":"+eni.getValue());
/*								System.out.print("<option value='" + eni.getId() + "'>"
										+ StringEscapeUtils.escapeHtml(eni.getName()) + "</option>");
										*/
							}
//							System.out.print("</select><br>");
						} 
						else {
							System.out.print("ERROR: Not implemented case -&gt: "
									+ StringEscapeUtils.escapeHtml(ansi.getName()) + "<br>");
						}
					}
					System.out.println();
				} // Question case 
				else {
					// Caso imposible
					System.err.print("ERROR: Not implemented case -&gt: "
							+ StringEscapeUtils.escapeHtml(ai.getContent()) + "<br>");
				}
			}
			System.out.println();
			System.out.println();
		} // sections
		
	}
	

	
	
	private void myPrt (String str) {
		System.out.println (str);
	}
	
	
/**
 * 
 * @param hibSes
 *
	private void createEnumTypes (Session hibSes) {
		
	// First the enum types
		Hashtable<Integer, String> aux = new Hashtable<Integer, String> (); 
		Vector<String> auxNames = new Vector<String>(), 
									auxVals = new Vector<String>();
		aux.put(1, "January");
		aux.put(2, "February");
		aux.put(3, "March");
		aux.put(4, "April");
		aux.put(5, "May");
		aux.put(6, "June");
		aux.put(7, "July");
		aux.put(8, "August");
		aux.put(9, "September");
		aux.put(10, "October");
		aux.put(11, "November");
		aux.put(12, "December");
		HibController.EnumTypeCtrl.createEnumType (hibSes, "Months (EN)", aux);
		
		int curYear = java.util.Calendar.getInstance().get(java.util.Calendar.YEAR);
		for (int i=1970; i<= curYear; i++) 
			aux.put(new Integer(i), Integer.toString(i));
		HibController.EnumTypeCtrl.createEnumType (hibSes, "Years (EN)", aux);
		
		aux.clear();
		aux.put(1, "Yes");
		aux.put(2, "No");
		aux.put(99, "Unknown");
		HibController.EnumTypeCtrl.createEnumType (hibSes, "Yes-No (EN)", aux);
				
		aux.put(1, "Black cigarettes");
		aux.put(2, "Blonde cigarettes");
		aux.put(3, "Black tobacco");
		aux.put(4, "Blonde tobacco");
		aux.put(5, "Habanos");
		aux.put(6, "Cigars");
		aux.put(7, "Pipe");
		HibController.EnumTypeCtrl.createEnumType (hibSes, "Tobacco Types (EN)", aux);
	}
*/	
}



