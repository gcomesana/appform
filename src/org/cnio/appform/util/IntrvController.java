package org.cnio.appform.util;

import static org.hibernate.criterion.Restrictions.*;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.IOException;

import org.apache.commons.lang.*;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.AnnotationConfiguration;
import org.hibernate.cfg.AnnotatedClassType;
import org.hibernate.Query;
import org.hibernate.Transaction;
import org.hibernate.Criteria;
import org.hibernate.HibernateException;
import org.hibernate.criterion.*;
import org.hibernate.SQLQuery;

import org.cnio.appform.entity.*;

/**
 * This class contains methods for duplicating an interview for another group
 * @author willy
 *
 */
public class IntrvController {

	private Session hibSes;
	
	
	public IntrvController (Session aSession) {
		hibSes = aSession;
	}
	
	


/**
 * Replicate the interview with id intrvId for the group of users represented 
 * by grp and for the target project prj and set it a new name 
 * @param intrvId, the source interview id
 * @param grp, the target group 
 * @param prj, the target project
 * @return, a new interview 
 */	
	public Interview replicateIntrv (Integer intrvId, AppGroup grp, Project prj, 
					String newName) {
		
		Interview intrvAux = (Interview)hibSes.get(Interview.class, intrvId), 
							intrvBis = null;
		Transaction tx = null;
		try {
			tx = hibSes.beginTransaction();
			intrvBis = (Interview)intrvAux.clone();
			intrvBis.setParentPrj(prj);
			intrvBis.setName(newName);
			
			Integer intId = (Integer)hibSes.save(intrvBis);
System.out.println("Interview "+intrvBis.getName()+" cloned with id: "+intId);

			RelIntrvGroup rig = new RelIntrvGroup (grp, intrvBis);
			Integer rigId = (Integer)hibSes.save(rig);
System.out.println("Interview assigned to group "+grp.getName());			
// Now, the answer items has to be assigned to every question
// At this point, the relationship between the cloned questions and the
// cloned answeritems doesnt exist, because the relationship is between the
// cloned questions and the original/old answeritems
			List<AbstractItem> items = getItemsFromIntrv (intrvBis);
			List<AnswerItem> ansItList = intrvBis.getAnswerItems();
			for (Iterator<AbstractItem> itemIt = items.iterator(); itemIt.hasNext();) {
				AbstractItem theItem = itemIt.next();
				
				if (theItem instanceof Text)
					continue;
				
				else { // it should be a Question
					List<QuestionsAnsItems> lQai = ((Question)theItem).getQuestionAnsItems();
					for (Iterator<QuestionsAnsItems> itQai = lQai.iterator(); itQai.hasNext();) {
						QuestionsAnsItems qai = itQai.next();
						AnswerItem ai = qai.getTheAnswerItem();
// The ai is the old answerItem and now we have to get the cloned answeritem
// and substitute the original/old with the new one
// In order to do this, the cloned answeritem has to be got from the list of 
// cloned answeritems with the cloned interview as owner
						int index = ansItList.indexOf(ai);
						qai.setTheAnswerItem(ansItList.get(index));
					}
				}
				
			}
			
			tx.commit();
//System.out.println("the new intrvId: "+intId);
		}
		catch (Exception ex) {
			if (tx != null)
				tx.rollback();
			
//					ex.printStackTrace();
			return null;
		}
		return intrvBis;
	}
	
	
	
	
	
/**
 * Replicate the interview with id intrvId for the group of users represented 
 * by grp and for the target project prj 
 * @param intrvId, the source interview id
 * @param grp, the target group 
 * @param prj, the target project
 * @return, a new interview 
 */	
	public Interview replicateIntrv (Integer intrvId, AppGroup grp, Project prj) {
		
		Interview intrvAux = (Interview)hibSes.get(Interview.class, intrvId), 
							intrvBis = null;
		Transaction tx = null;
		try {
			tx = hibSes.beginTransaction();
			intrvBis = (Interview)intrvAux.clone();
			intrvBis.setParentPrj(prj);
			Integer intId = (Integer)hibSes.save(intrvBis);
System.out.println("Interview "+intrvBis.getName()+" cloned with id: "+intId);

			RelIntrvGroup rig = new RelIntrvGroup (grp, intrvBis);
			Integer rigId = (Integer)hibSes.save(rig);
System.out.println("Interview assigned to group "+grp.getName());			
// Now, the answer items has to be assigned to every question
// At this point, the relationship between the cloned questions and the
// cloned answeritems doesnt exist, because the relationship is between the
// cloned questions and the original/old answeritems
			List<AbstractItem> items = getItemsFromIntrv (intrvBis);
			List<AnswerItem> ansItList = intrvBis.getAnswerItems();
			for (Iterator<AbstractItem> itemIt = items.iterator(); itemIt.hasNext();) {
				AbstractItem theItem = itemIt.next();
				
				if (theItem instanceof Text)
					continue;
				
				else { // it should be a Question
					List<QuestionsAnsItems> lQai = ((Question)theItem).getQuestionAnsItems();
					for (Iterator<QuestionsAnsItems> itQai = lQai.iterator(); itQai.hasNext();) {
						QuestionsAnsItems qai = itQai.next();
						AnswerItem ai = qai.getTheAnswerItem();
// The ai is the old answerItem and now we have to get the cloned answeritem
// and substitute the original/old with the new one
// In order to do this, the cloned answeritem has to be got from the list of 
// cloned answeritems with the cloned interview as owner
						int index = ansItList.indexOf(ai);
						qai.setTheAnswerItem(ansItList.get(index));
					}
				}
				
			}
			
			tx.commit();
//System.out.println("the new intrvId: "+intId);
		}
		catch (Exception ex) {
			if (tx != null)
				tx.rollback();
			
//				ex.printStackTrace();
			return null;
		}
		return intrvBis;
	}	
	
	
	
	
	
/**
 * Replicate the interview with id intrvId for the group of users represented 
 * by grp 
 * @param intrvId, the source interview id
 * @param grp, the target group 
 * @return, a new interview 
 */	
	public Interview replicateIntrv (Integer intrvId, AppGroup grp) {
		
		Interview intrvAux = (Interview)hibSes.get(Interview.class, intrvId), 
							intrvBis = null;
		Transaction tx = null;
		try {
			tx = hibSes.beginTransaction();
			intrvBis = (Interview)intrvAux.clone();
			Integer intId = (Integer)hibSes.save(intrvBis);
System.out.println("Interview "+intrvBis.getName()+" cloned with id: "+intId);

			RelIntrvGroup rig = new RelIntrvGroup (grp, intrvBis);
			Integer rigId = (Integer)hibSes.save(rig);
System.out.println("Interview assigned to group "+grp.getName());			
// Now, the answer items has to be assigned to every question
// At this point, the relationship between the cloned questions and the
// cloned answeritems doesnt exist, because the relationship is between the
// cloned questions and the original/old answeritems
			List<AbstractItem> items = getItemsFromIntrv (intrvBis);
			List<AnswerItem> ansItList = intrvBis.getAnswerItems();
			for (Iterator<AbstractItem> itemIt = items.iterator(); itemIt.hasNext();) {
				AbstractItem theItem = itemIt.next();
				
				if (theItem instanceof Text)
					continue;
				
				else { // it should be a Question
					List<QuestionsAnsItems> lQai = ((Question)theItem).getQuestionAnsItems();
					for (Iterator<QuestionsAnsItems> itQai = lQai.iterator(); itQai.hasNext();) {
						QuestionsAnsItems qai = itQai.next();
						AnswerItem ai = qai.getTheAnswerItem();
// The ai is the old answerItem and now we have to get the cloned answeritem
// and substitute the original/old with the new one
// In order to do this, the cloned answeritem has to be got from the list of 
// cloned answeritems with the cloned interview as owner
						int index = ansItList.indexOf(ai);
						qai.setTheAnswerItem(ansItList.get(index));
					}
				}
				
			}
			
			tx.commit();
//System.out.println("the new intrvId: "+intId);
		}
		catch (Exception ex) {
			if (tx != null)
				tx.rollback();
			
//			ex.printStackTrace();
			return null;
		}
		return intrvBis;
	}
	
	
	
	
/**
 * Replicate the interview intrvAux for the group of users represented 
 * by grp 
 * @param intrvId, the source interview id
 * @param grp, the target group 
 * @return, a new interview 
 */	
	public Interview replicateIntrv (Interview intrvAux, AppGroup grp) {
		
		Interview intrvBis = null;
		Transaction tx = null;
		try {
			tx = hibSes.beginTransaction();
			intrvBis = (Interview)intrvAux.clone();
			Integer intId = (Integer)hibSes.save(intrvBis);
// System.out.println("IntrvController.replicateIntrv: Interview "+intrvBis.getName()+" cloned with id: "+intId);

			RelIntrvGroup rig = new RelIntrvGroup (grp, intrvBis);
			Integer rigId = (Integer)hibSes.save(rig);
// System.out.println("IntrvController.replicateIntrv: Interview assigned to group "+grp.getName());			
// Now, the answer items has to be assigned to every question
// At this point, the relationship between the cloned questions and the
// cloned answeritems doesnt exist, because the relationship is between the
// cloned questions and the original/old answeritems
			List<AbstractItem> items = getItemsFromIntrv (intrvBis);
			List<AnswerItem> ansItList = intrvBis.getAnswerItems();
			for (Iterator<AbstractItem> itemIt = items.iterator(); itemIt.hasNext();) {
				AbstractItem theItem = itemIt.next();
				
				if (theItem instanceof Text)
					continue;
				
				else { // it should be a Question
					List<QuestionsAnsItems> lQai = ((Question)theItem).getQuestionAnsItems();
					for (Iterator<QuestionsAnsItems> itQai = lQai.iterator(); itQai.hasNext();) {
						QuestionsAnsItems qai = itQai.next();
						AnswerItem ai = qai.getTheAnswerItem();
// The ai is the old answerItem and now we have to get the cloned answeritem
// and substitute the original/old with the new one
// In order to do this, the cloned answeritem has to be got from the list of 
// cloned answeritems with the cloned interview as owner
						int index = ansItList.indexOf(ai);
						qai.setTheAnswerItem(ansItList.get(index));
					}
				}
				
			}
			
			tx.commit();
//System.out.println("the new intrvId: "+intId);
		}
		catch (Exception ex) {
			if (tx != null)
				tx.rollback();
			
				ex.printStackTrace();
			return null;
		}
		return intrvBis;
	}	
	
	
	
/**
 * Find out whether or not the interview represented by intrvId is cloned
 * @param intrvId
 * @return true if the interview is a clone of another; false if it is 
 * an original interview
 */	
	public Boolean isClon (Integer intrvId) {
		Transaction tx = null;
		Boolean cloned = true;
		try {
			tx = hibSes.beginTransaction();
			Interview intrv = (Interview)hibSes.get(Interview.class, intrvId);
			
			cloned = (intrv.getSourceIntrv() == null)? false: true;
			return cloned;
		}
		catch (HibernateException ex) {
			if (tx != null)
				tx.rollback();
			
			return null;
		}
	}

	
	
	
/**
 * Gets all items from all sections from the interview represented by intrv
 * @param intrv, the interview whose elements want to be retrieved
 * @return, a list with the items
 */	
	private List<AbstractItem> getItemsFromIntrv (Interview intrv) {
		List<AbstractItem> aux = new ArrayList<AbstractItem>();
		List<Section> sections = intrv.getSections();
		
		for (Iterator<Section> itSec = sections.iterator(); itSec.hasNext();) {
			Section sec = itSec.next();
			aux.addAll(sec.getItems());
		}
		
		return aux;
	}
	


/**
 * Apply the deletion rules on item to see whether or not this item can be removed
 * @param it, the item
 * @param roles, the roles the current user has
 * @return a int value such that<br/>
 * <li>1 if the item can be deleted anyway</li>
 * <li>2 if the item is a question with answers and the user is admin</li>
 * <li>3 if the item is a question with answers but the user is not admin</li>
 */
	private int applyItemDeletionRules (AbstractItem it, String roles) {
		int res = 0;
		boolean isQuestion = it instanceof Question;
		boolean hasAnswers = false;
		List<AbstractItem> children = it.getContainees();
		List<Answer> answers = 
			isQuestion? HibController.ItemManager.getAnswers4Question(hibSes, (Question)it)
								: null; 
		
		if (isQuestion)
			hasAnswers = answers != null && answers.size() > 0;
		
// remove a single text
		if (!isQuestion && (children == null || children.size() == 0)) 
			res = 1;
		
// remove a single question without answers
		if (isQuestion && !hasAnswers) 
			res = 1;

// try to remove a single question with answers
		if (isQuestion && hasAnswers) {
			if (roles.indexOf("admin") != -1)
				res = 2; // report to admin to confirm deletion
			else
				res = 3; // report to user he/she is not allowed to delete
		}
		return res;
	}
	
	

	
/**
 * Try to delete an item and its containees with the following restrictions:<br/>
 * - check if the item is a question and it has answers<br/>
 * - check the permissions: only admins can delete questions<br/>
 * - a text can be deleted by anyone<br/>
 * - for a container, it can be deleted if above conditions are met for
 * every child
 * @param it, the item to remove
 * @param roles, the roles of the current user
 * @return
 */
	public int deleteItem (AbstractItem it, String roles) {
		int res = 1;
		Transaction tx = null;
		String sons;

// Check the deletion rules for the children (if so)
		List<AbstractItem> children = it.getContainees();
		sons = (children.size() > 0)? ",\"sons\":\"": "";
		AbstractItem son = null;
		try {
			for (int i=children.size(); i>0 ; i--) {
				son = children.get(i-1);
				
				res = applyItemDeletionRules (son, roles);
				if (res != 1)
					break;
				
				son.setContainer(null);
				sons += son.getId()+",";
			}
		
	// Check the deletion rules for the item itself
			if (res == 1) 
				res = applyItemDeletionRules (it, roles);
				
	// if all above was ok, then the item is empty or text, 
	// and it can be deleted right now
			if (res == 1) {
				tx = hibSes.beginTransaction();
				sons = sons.equalsIgnoreCase("")? "": 
												sons.substring(0, sons.length()-1)+"\"";
				it.removeContainees();
				hibSes.delete(it);
				tx.commit();
			}
		}
		catch (HibernateException hibEx) {
			if (tx != null)
				tx.rollback();
			
			hibEx.printStackTrace();
			res = -1;
		}
/*		
		tx.begin();
// out.print (it.getId()+".-"+it.getContent());
		if (it instanceof Question) {
			if (((Question)it).getMandatory () == 0) {
				hibSes.delete(it);
				msgOut = "ok";
				res = true;
			}
			else  { // mandatory = 1, so the question is considered as MANDATORY
				msgOut = "The Question can not be deleted";
				res = false;
			}
		}
		else {
			hibSes.delete(it);
			msgOut = "ok";
			res = true;
		}
		tx.commit();
*/		
		return res;
	}
	

	
	
/**
 * Remove all items which are related to the parameter it, children, answers and
 * the item itself
 * @param it
 * @return
 */	
	public int removeQuestionsAndAnswers (AbstractItem it) {
		List<AbstractItem> children = it.getContainees();
		List<Answer> answers = null;
		Transaction tx = null;
		int res = 1;
		
		try {
			for (Iterator<AbstractItem> itr = children.iterator(); itr.hasNext();) {
				AbstractItem son = itr.next();
				if (son instanceof Question) {
					answers = HibController.ItemManager.getAnswers4Question(hibSes, (Question)son);
					if (answers != null && answers.size() > 0)
						HibController.ItemManager.deleteAnswers (hibSes, (Question)son);
				}
			}
			
			tx = hibSes.beginTransaction();
			for (Iterator<AbstractItem> itr = children.iterator(); itr.hasNext();) {
				AbstractItem son = itr.next();
				hibSes.delete(son);
			}
			
			it.removeContainees();
			hibSes.delete(it);
			tx.commit();
		}
		catch (HibernateException ex) {
			if (tx != null)
				tx.rollback();
			
			ex.printStackTrace();
			
			res = -1;
		}
		
		return res;
	}
	
	
	
/**
 * Add a list of Interviews to the Project proj
 * @param session
 * @param intrv
 * @param sections
 * @return
 */	
	public boolean addIntr2Proj (Project proj, List<Interview> intrvs) {
		
		Transaction tx = hibSes.getTransaction();
		tx = (!tx.isActive())? hibSes.beginTransaction(): tx;
		try {
			
			Iterator<Interview> itIntr = intrvs.iterator();
			while (itIntr.hasNext()) {
				Interview oneIntr = itIntr.next();
				oneIntr.setProject(proj);
			}
			
			tx.commit();	
			return true;
		} 
		catch (HibernateException e) {
			if (tx != null) {
				tx.rollback();
				e.printStackTrace();
			}
			return false;
		}
	}




/**
 * Creates a new interview based on name and description
 * @param hibSess
 * @param name, a String representing the name of the section
 * @param desc, a String representing some description
 * @return
 */	
	public boolean createInterview (String name, String desc) {
		Transaction tx = null;
		try {
			tx = hibSes.getTransaction();
			tx = (!tx.isActive())? hibSes.beginTransaction(): tx;
			
			Interview intrv = new Interview (name, desc);
			hibSes.save(intrv);
			tx.commit();
			
			return true;
		}
		catch (HibernateException hibEx) {
			if (tx != null)
				tx.rollback();
			
			hibEx.printStackTrace();
			return false;
		}
	}




/**
 * This method gets the list of interviews based on the current project and the
 * main group which the user belongs to. This is necessary because the interviews
 * belong to a entire group of users, which is the COUNTRY group in the case of
 * Pangenes development
 * In the case of a user with role 'admin', all interviews have to be returned
 * @param prjId, the id of the project
 * @param usrId, the id of the user, necessary to get the main group
 * @return a Interview list or null
 */		
	public List<Interview> getIntrv4Usr (Integer prjId, Integer usrId) {
		AppUserCtrl usrCtrl = new AppUserCtrl (hibSes);
		AppUser user = (AppUser)hibSes.get(AppUser.class, usrId);
		Project prj = (Project)hibSes.get(Project.class, prjId);
		List<Interview> lIntrv = null;
		
		if (user == null)
			return null;
		
		else {
			Transaction tx = null;
			List<AppGroup> userGroups = usrCtrl.getGroups(user), auxGroups;
			AppGroup activeGroup = usrCtrl.getPrimaryActiveGroup(user);
/*			
String hqlIntr = "from RelIntrvGroup rig where rig.appgroup=:group and " +
"intrv.parentPrj=:prj";
*/
			String hqlAdm = "from Interview i where i.parentPrj=:prj order by i.name";
			String hqlGrpTmpl = "from AppGroup g where g in (:groups) and"+
										" g.type.name='"+HibernateUtil.MAIN_GROUPTYPE+"'";
			String hqlIntrBis = "select i from Interview i join i.relIntrvGrps rig where" +
					" rig.appgroup=:group and i.parentPrj=:prj order by i.name";
			
			try {
				tx = hibSes.beginTransaction();
				if (user.isAdmin()) {
					Query qry = hibSes.createQuery(hqlAdm);
					qry.setEntity("prj", prj);
					lIntrv = qry.list();
					tx.commit();
					
					return lIntrv;
				}
/*				
				Query qGrp = hibSes.createQuery(hqlGrpTmpl);
				qGrp.setParameterList("groups", userGroups);
				auxGroups = qGrp.list();
*/
				Query qIntr = hibSes.createQuery(hqlIntrBis);
//				qIntr.setEntity("group", auxGroups.get(0));
				qIntr.setEntity("group", activeGroup);
				qIntr.setEntity("prj", prj);
				
				lIntrv = qIntr.list();
	/*			
				List<Object[]>lAux = qIntr.list();
				Iterator<Object[]> itAux = lAux.iterator();
				lIntrv = new ArrayList<Interview>();
				while (itAux.hasNext()) {
					Object[] pair = (Object[])itAux.next();
					lIntrv.add((Interview)pair[0]);
				}
	*/			
				tx.commit();
			}
			catch (HibernateException hibEx) {
				if (tx != null)
					tx.rollback();
				
				hibEx.printStackTrace();
			}
		}
		
		return lIntrv;
	}



	
/**
 * Get a list of interviews with the name 'intrvName' belonging to project 'prj'.
 * Usually there will be only one interview, but it returns a list to prevent
 * @param prj, the project which the interview is contained in
 * @param intrvName, the name of the interview
 * @return, a list of interviews matching the parameters criteria
 */
	public List<Interview> getIntr4Proj (Project prj, String intrvName) {
		Transaction tx = null;
		String hql = "from Interview i where i.parentPrj=:prj and i.name='"+intrvName+"'";
		List<Interview> intrvs = null;
		
		try {
			tx = hibSes.beginTransaction();
			Query qry = hibSes.createQuery(hql);
			qry.setEntity("prj", prj);
//			qry.setString("name", intrvName);
			
			intrvs = qry.list();
			tx.commit();
		}
		catch (HibernateException hibEx) {
			if (tx != null)
				tx.rollback();
			
			LogFile.error("IntrvController.getIntr4Proj: Fail retrieving interview:\t");
			LogFile.error(hibEx.getLocalizedMessage());
			StackTraceElement[] stack = hibEx.getStackTrace();
			LogFile.logStackTrace(stack);
hibEx.printStackTrace();
		}
		
		return intrvs;
	}
	
	
	

/**
 * Get the list of interviews for the project identified with prjId and for an
 * owner identified with his/her system id. The list of interviews is the list of
 * interviews for all users in that group (actually, the country)
 * @param session
 * @param prjId
 * @param userId
 * @return
 */	
	public List<Interview> getIntr4Proj (Integer prjId, Integer userId) {
		AppUserCtrl usrCtrl = new AppUserCtrl (hibSes);
		AppUser user = (AppUser)hibSes.get(AppUser.class, userId);
		Project prj = (Project)hibSes.get(Project.class, prjId);
		
		if (user == null)
			return null;
		
		else {
/*			List<AppUser> lUsr = usrCtrl.getUserPartners(user);
			int numUsrs = lUsr.size(), cont=1;
			
			String sql = "select i.* from project p, interview i " +
					"where p.idprj="+prjId+" and (";
			
			for (AppUser usr: lUsr) {
				sql += "i.codusr="+usr.getId();
				if (cont == numUsrs)
					sql += ")";
				else
					sql += " or ";
				
				cont++;
			}
			
			sql += " and i.codprj=p.idprj";
*/			
//	System.out.println(sql);
			Transaction tx = null;
			List<AppGroup> userGrps = usrCtrl.getGroups(user);
			String hqlCountry = "from AppGroup g where g in :groups and g.type.name='COUNTRY'";
			
			
			String hql = "from Interview i where parentPrj=:prj";
			List<Interview> intCol;
//			intCol = session.createSQLQuery(sql).addEntity(Interview.class).list();
			Query qHql = hibSes.createQuery(hql).setEntity("prj", prj); 
			intCol = qHql.list();
		
			return intCol;
		}
		
	}



/**
 * Gets the basic (and neutral, without belonging any interview templ) answer 
 * types. They are 3 basic (label, number and decimal) and one enum type (yes/no)
 * @return a list of the basic answer items
 */
	private List<AnswerItem> defaultTypes () {
		String hqlStr = "from AnswerItem a where a.id in ("+
		HibController.TYPE_LABEL_ID+","+HibController.TYPE_NUMBER_ID+","+
		HibController.TYPE_DECIMAL_ID+","+HibController.TYPE_ENUM_YES+")";
//		+","+HibController.TYPE_TEXT_ID+")";
//			hqlStr += "or lower(a.name) like '%yes%'";
		
		Transaction tx = hibSes.getTransaction();
		List<AnswerItem> ansItems = null;
		
		if (tx == null) {
			try {
				tx = hibSes.beginTransaction();
				Query qry = hibSes.createQuery(hqlStr);
				
				ansItems = qry.list();
			}
			catch (HibernateException ex) {
				if (tx != null)
					tx.rollback();
				
				return null;
			}
		}
		else {
			Query qry = hibSes.createQuery(hqlStr);
			
			ansItems = qry.list();
		}
			
		return ansItems;
	}
	
	
	

	

/**
 * This is a wrapper on datatypes (or, the same said, another interface) to create
 * a new interview
 * @param name, the name of the new interview
 * @param desc, the description of the interview
 * @param parentPrj, the parent the interview is going to belong to
 * @param usrId, the usrId who created the interview
 * @param shortEnable, true to allow to perform a short interview
 * @param canCrtSubj, true to allow to create subjects in the new interview
 * @param isSampleIntrv, true to set the interview as a sample interview
 * @return the id of the newly created interview/questionnaire
 */	
	public int createInterview (String name, String desc, Integer parentPrj, Integer usrId,
														boolean shortEnable, boolean canCrtSubj, boolean isSampleIntrv) {
		String strEnable = shortEnable? "true": "false";
		String strCrtSubje = canCrtSubj? "true": "false";
		String strSample = isSampleIntrv? "true": "false";
		
		int newId = createInterview (name, desc, parentPrj, usrId, strEnable, strCrtSubje, strSample);
		
		return newId;
	}	
	
	
	

/**
 * Creates a new interview based on name and description. Besides, as it is part
 * of every interview, the Introduction section is added by default
 * usrId will have to be removed because the users are assigned to projects, not
 * to interviews
 * @param hibSess
 * @param name, a String representing the name of the section
 * @param desc, a String representing some description
 * @param parentPrj, the identifier of the parent project
 * @return
 */	
	public int createInterview (String name,String desc, Integer parentPrj,
								Integer usrId, String shortEnable, String canCrtSubj, String isSample) {
		Transaction tx = null;
		Integer intrId;
		boolean res = true;
LogFile.info("IntrvController.createInterview ()!!!");
// Get user from usrId and main group for user
		AppUserCtrl usrCtrl = new AppUserCtrl (hibSes);
		AppUser theUsr = (AppUser)hibSes.get(AppUser.class, usrId);		
		AppGroup mainGroup = usrCtrl.getPrimaryActiveGroup(theUsr);
//		mainGroup = mainGroup == null? (AppGroup)hibSes.get(AppGroup.class, 304): mainGroup;
		
		try {
			tx = hibSes.getTransaction();
// System.out.println("tx.active: "+tx.isActive());			
			tx = (!tx.isActive())? hibSes.beginTransaction(): tx;
			
			Interview intrv = new Interview (name, desc);
			intrv.setUsrOwner(theUsr);
			
			intrv.setCanShorten(Integer.valueOf((Boolean.parseBoolean(shortEnable))? 1: 0));
			intrv.setCanCreateSubject (Integer.valueOf((Boolean.parseBoolean(canCrtSubj))? 1: 0));
			intrv.setIsSampleIntrv(Integer.valueOf((Boolean.parseBoolean(isSample))? 1: 0));
			intrId = (Integer)hibSes.save(intrv);

// Assign the user main group to this interview in order the other users in the
// group can access it.			
			RelIntrvGroup rig = new RelIntrvGroup (mainGroup, intrv);
			hibSes.save(rig);
			
			
			List<AnswerItem> lItems = defaultTypes ();
			for (Iterator<AnswerItem> itItems=lItems.iterator(); itItems.hasNext(); ) {
				AnswerItem ai = itItems.next(), clonedAi;
				clonedAi = (AnswerItem)ai.clone();
				clonedAi.setIntrvOwner(intrv);
				
				Long clonedId = (Long)hibSes.save(clonedAi);
			}
			
			String hqlQry = "from AnswerItem ai where upper(ai.name)=upper('"+
							HibController.TYPE_LABEL +	"') and ai.intrvOwner=:owner";
			AnswerItem ai; 

			Query hql = hibSes.createQuery(hqlQry);
			hql.setEntity("owner", intrv);
			Collection<AnswerItem> colItems = hql.list();
			
			ai = (colItems != null)? colItems.iterator().next(): null;
			if (ai == null) {
				tx.rollback();
				return -1;
			}
			else {
				Section intro = new Section ("Introducci—n", "");
				intro.setSectionOrder(new Integer (1));
				intro.setInterview(intrv);
				hibSes.save(intro);
// Box for patient code				
				Question qPatCode = new Question ("C—digo de paciente:");
				qPatCode.setParentSec(intro);
				qPatCode.setItemOrder(new Long (1));
				qPatCode.setMandatory(1);
				qPatCode.setHighlight(0);
				hibSes.save(qPatCode);
			
				QuestionsAnsItems qas = new QuestionsAnsItems (qPatCode, ai);
				qas.setAnswerOrder(new Long(1));
				hibSes.save(qas);

			}
			
			tx.commit();
			
			List<Interview> l = new ArrayList<Interview>();
			Interview intr = (Interview)hibSes.get(Interview.class, intrId);
			Project prj = (Project)hibSes.get(Project.class, parentPrj);
			l.add(intr);
			res = res && addIntr2Proj(prj, l);
			
			
	// if the creation of the intro was ok, then we commit the transaction, other
	// wise it is considered the interview can not be created 
			/*
			if (res)
				tx.commit();
			else
				tx.rollback();
			*/
			return intrId;
		}
		catch (HibernateException hibEx) {
			if (tx != null)
				tx.rollback();
			
			LogFile.error("Fail create interview:\t");
			LogFile.error(hibEx.getLocalizedMessage());
			StackTraceElement[] stack = hibEx.getStackTrace();
			LogFile.logStackTrace(stack);
hibEx.printStackTrace();
			
			return -1;
		}
		catch (CloneNotSupportedException ex) {
			if (tx != null)
				tx.rollback();
			
			LogFile.error("Fail to log interview creation:\t");
			LogFile.error(ex.getLocalizedMessage());
			StackTraceElement[] stack = ex.getStackTrace();
			LogFile.logStackTrace(stack);
			
			return -1;
		}
		
	}




/**
 * Delete an interview based on an id
 * @param session, the hibernate session
 * @param secId, the id of the section which is gonna be deleted
 * @return true on sucessfully completion; otherwise false
 */	
	public boolean removeInterview (Integer intrId) {
		Transaction tx = hibSes.getTransaction();
		tx = (!tx.isActive())? hibSes.beginTransaction(): tx;
		try {
			Interview theIntr = (Interview)hibSes.get(Interview.class, intrId);
			
			hibSes.delete(theIntr);
			tx.commit();	
			return true;
		} 
		catch (HibernateException e) {
			if (tx != null) {
				tx.rollback();
				e.printStackTrace();
			}
			return false;
		}
	}
	
	
	
	
/**
 * This method clones the answer-items belonging to one interview or, if the 
 * source interview is null, all answer-items and it relates them with the
 * target interview
 * @param src, the source interview for the source answer-items (it can be null)
 * @param dest, the target interview where the answer-items are gonna be 
 * cloned to
 * @return true on successful termination; false on error
 */		
	public boolean cloneAnswerItems (Interview src, Interview dest) {
		List<AnswerItem> lAnsIt;
		Transaction tx;
// HibernateUtil.getAnswerItems has a inner transaction		
		if (src == null) 
			lAnsIt = HibernateUtil.getAnswerItems(hibSes, src);
		else
			lAnsIt = src.getAnswerItems();
		
		
		try {
			tx = hibSes.beginTransaction();
			
			for (Iterator<AnswerItem> aiIt = lAnsIt.iterator(); aiIt.hasNext();) {
				AnswerItem ai = aiIt.next(), newAi;
				
				if (ai instanceof AnswerType) 
					newAi = (AnswerItem)((AnswerType)ai).clone();
					
				else  // an EnumType
					newAi = (AnswerItem)((EnumType)ai).clone();
				
				Long newAiId = (Long)hibSes.save(newAi);
				dest.setAnswerItem(newAi);
			}
			hibSes.flush();
			
			tx.commit();
		}
		catch (CloneNotSupportedException ex) {
			ex.printStackTrace();
			return false;
		}
		
		return true;
	}
	
/*
	protected void finalize () {
		if (hibSes != null)
			if (hibSes.isOpen())
				hibSes.close();
	}
*/
}