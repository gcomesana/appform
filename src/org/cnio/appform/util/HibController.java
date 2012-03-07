/**
 * 
 */
package org.cnio.appform.util;

import static org.hibernate.criterion.Restrictions.*;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.Vector;

import java.io.*;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.AnnotationConfiguration;
import org.hibernate.cfg.AnnotatedClassType;
import org.hibernate.Query;
import org.hibernate.Transaction;
import org.hibernate.Criteria;
import org.hibernate.HibernateException;
import org.hibernate.criterion.*;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.log4j.*;
import org.apache.log4j.config.*;

import org.cnio.appform.entity.Section;
import org.cnio.appform.entity.AbstractItem;
import org.cnio.appform.entity.Question;
import org.cnio.appform.entity.Text;
import org.cnio.appform.entity.Answer;
import org.cnio.appform.entity.AnswerItem;
import org.cnio.appform.entity.AnswerType;
import org.cnio.appform.entity.EnumItem;
import org.cnio.appform.entity.EnumType;
import org.cnio.appform.entity.QuestionsAnsItems;
import org.cnio.appform.entity.Interview;
import org.cnio.appform.entity.Project;


/**
 * This class contains methods and inner classes to control the persistent
 * classes via through Hibernate
 * @author willy
 *
 */
public class HibController {
	
	public static final String TYPE_LABEL = "FREE TEXT";
	public static final Integer TYPE_LABEL_ID = 100; // 1
	
	public static final String TYPE_NUMBER = "NUMBER";
	public static final Integer TYPE_NUMBER_ID = 101; // 2

	public static final String TYPE_DECIMAL = "DECIMAL";
	public static final Integer TYPE_DECIMAL_ID = 102; // 3
	
	public static final String TYPE_TEXT = "LONG FREE TEXT";
	public static final Integer TYPE_TEXT_ID = 103;
	
	public static final Integer TYPE_ENUM_YES = 110;
	public static final String ENUM_YESNO	= "yes-no";
	
	
	
	public static class ItemManager {
		
	/**
	 * Gets an AbstractItem from the unique id
	 * @param hibSess, the session to perform the transaction
	 * @param id, the id of the item
	 * @return an AbstractItem object or null whether not item related to the id
	 */
		public static AbstractItem getItemById (Session hibSess, int id) {
			Transaction tx = hibSess.getTransaction();
			tx = (!tx.isActive())? hibSess.beginTransaction(): tx;
			
			try {
				AbstractItem tal = (AbstractItem)hibSess.get(AbstractItem.class, 
																										 new Long(id));
				tx.commit();
				return tal;
			}
			catch (HibernateException hibEx) {
				if (tx != null)
					tx.rollback();
				
				hibEx.printStackTrace();
				return null;
			}
		}
		
		
		
/**
 * Gets the question from the interview and its question code
 * @param hibSes
 * @param intrvId
 * @param qcode
 * @return
 */		
		public static Question getQuestionFromCode (Session hibSes, 
																							Integer intrvId, String qcode) {
			
			String hql = "from Question q where q.parentSec.parentInt=:intrv and " +
					"q.codquestion='"+qcode+"'";
			String hql2 = "from Question q where q.parentSec.parentInt=:intrv";
			Transaction tx = null;
			
			try {
				tx = hibSes.beginTransaction();
				Interview intrv = (Interview)hibSes.get(Interview.class, intrvId);
				if (intrv != null) {
					Query qry = hibSes.createQuery(hql);
					qry.setEntity("intrv", intrv);
					
					List<Question> qList = qry.list();
/*
for (Question q: qList)
	System.out.println("id: "+q.getId()+"; qCode: "+q.getCodquestion());
*/
					tx.commit();
					return qList.get(0);
				}
				return null;
			}
			catch (HibernateException hibEx) {
				if (tx != null)
					tx.rollback();
				
				hibEx.printStackTrace(System.err);
				return null;
			}
		}
		
		
	/**
	 * Get the item with highest item_order for the section sec,  
	 * (In further versions this may have to be changed for some date)
	 * @param hibSes, the session to perform the transaction
	 * @param sec, the section to get the items
	 * @return the AbstractItem with highest id
	 */		
		public static AbstractItem getLastItem (Session hibSes, Section sec) {
			String sql = "from AbstractItem a where a.id=";
			sql += "(select max(ai.id) from AbstractItem ai)";
			
			String hql = "from AbstractItem a where a.parentSec=:paramSec "+
									"order by itemOrder desc";
			List<AbstractItem> l = hibSes.createQuery(sql).list();
//			AbstractItem ait = (AbstractItem)hibSes.createQuery(sql).uniqueResult();
 //System.out.println("ItemMngr.getLastItem->numelems: "+l.size());
			if (l != null && l.size() > 0)
				return l.get(0);
			else
				return null;
		}
		
		
	/**
	 * Gets the containees for an AbstractItem container
	 * @param hibSess, the session to perform the transaction
	 * @param container, the abstract item which is a container
	 * @return a collection with the child items for the container; null if no items
	 */	
		public static List<AbstractItem> getContainees (Session hibSess,
																												AbstractItem container) {
	///////////////////// get the containees for this question in the case it has
			List<AbstractItem> col = container.getContainees();
			Iterator<AbstractItem> itSons = col.iterator();
			while (itSons.hasNext()) {
				AbstractItem at = itSons.next();
				if (at instanceof Text)
					LogFile.stdout("Subtext: " + at.getId() + ". " + at.getContent()
							+ "(pos: " + container.getItemOrder() + ")");

				else
					LogFile.stdout("Subquestion: " + at.getId() + ". "
							+ at.getContent() + "(pos: " + at.getItemOrder() + ")");
			} // while
			
			return col;
		}	

		
	/**
	 * Return an ordered list with the containees of an AbstractItem.  
	 * @param hibSes, the session to perform the query
	 * @param container, the object container whose containees are gonna be 
	 * retrieved
	 * @return a collection of the containees ordered by item order. null if the 
	 * container doesent have any element
	 */	
		public static List<AbstractItem> 
												getOrderedContainees (Session hibSes, 
																							AbstractItem container) {
//	LogFile.stdout("id: "+container.getId()+"-"+container.getContent());		

			String strQry = "from AbstractItem p join p.containees c where p.id=";
			strQry += container.getId() + " order by c.itemOrder";
			Query q = hibSes.createQuery(strQry);
			
			Iterator pairs = q.list().iterator();
			List<AbstractItem> l = new ArrayList<AbstractItem>();
			while ( pairs.hasNext() ) {
				Object[] pair = (Object[]) pairs.next();
//					AbstractItem p = (AbstractItem) pair[0];
				AbstractItem c = (AbstractItem) pair[1];
				l.add(c);
			//System.out.println(p.getName()+"-"+c.getName());			
			}
			
			return l;
		}
		
	
	
/**
 * Return a list with all answer items for the question q. This is necessary to
 * get the answer order and, mostly, to get the pattern for the simple types
 * @param hibSes, the hibernate session to perform the transaction
 * @param q, the Question which the answer items will be retrieved for
 * @return, a list with the answer items codes for the question q
 */		
	public static List<QuestionsAnsItems> getPatterns (Session hibSes, Question q) {
		
		String strQry = "from QuestionsAnsItems qai where " +
				"(lower(qai.theAnswerItem.name) = lower('"+HibController.TYPE_NUMBER+"') or " +
//				"qai.theAnswerItem.id = "+HibController.TYPE_LABEL_ID+" or " +
				"(lower(qai.theAnswerItem.name) = lower('"+HibController.TYPE_DECIMAL+"'))) and "+
				"qai.theQuestion.id = "+q.getId() + " order by qai.answerOrder";
		Transaction tx = null;
		List<QuestionsAnsItems> lQai = null;
		
		try {
			tx = hibSes.beginTransaction();
			
			Query qry = hibSes.createQuery(strQry);
			lQai = qry.list();
			
			tx.commit();
		}
		catch (HibernateException ex) {
			if (tx != null)
				tx.rollback();
		}
		
		return lQai;
	}
		
	
	
		
	/**
	 * Check if the Question q is a head of group
	 * @param hibSess, the hibernate session to perform the queries
	 * @param q, the question to see whether is a head of group
	 * @return a collection with the group of questions with the head of it first or
	 * null if there is no group
	 */
		public static Collection<AbstractItem> 
											getQuestionGroup (Session hibSess, Question q) {
			Collection<AbstractItem> qGroup = null;

			try {
				if (!q.getContainees().isEmpty()) {
					qGroup = new ArrayList<AbstractItem> ();
					qGroup.add(q);
					
					Criteria ct = hibSess.createCriteria(AbstractItem.class);
					ct.add(Restrictions.eq("container", q)).
						 addOrder(Order.asc("itemOrder"));
					
					qGroup.addAll(ct.list());
				}
			}
			catch (HibernateException hibEx) {
				hibEx.printStackTrace();
			}
			return qGroup;
		}
		
		
		
	/**
	 * Gets the answer items for an abstractitem which actually must be a question
	 * @param hibSess, the session
	 * @param ait, the abstract item to get the answer items
	 * @return a collection of answer items, which is null
	 */	
		public static List<AnswerItem> 
									getAnswerTypes4Question (Session hibSess, AbstractItem ait) {
	/////////////////////////// get the data type(s) associated to this question
			Transaction tx = null;
			List<AnswerItem> aItemCol = null;
			
			try {
				tx = hibSess.beginTransaction();
				Criteria ct = hibSess.createCriteria(AnswerItem.class).
											createAlias("questionsAnsItems", "a").
											createAlias("a.theQuestion", "q").
											add(Restrictions.eq("q.id", ait.getId())).
											addOrder(Order.asc("a.answerOrder"));
 /*
	* This next three Criteria perform the same than the previous one
	* Criteria ctAux = hibSess.createCriteria(AnswerItem.class).
	* createCriteria("questionsAnsItems"). createCriteria("theQuestion").
	* add(Restrictions.eq("id", ait.getId()));
	* 
	* Criteria ctOne = hibSess.createCriteria(AnswerItem.class); Criteria
	* ctTwo = ctOne.createCriteria("questionsAnsItems"); Criteria ctThr =
	* ctTwo.createCriteria("theQuestion"). add(Restrictions.eq("id",
	* ait.getId()));
	*/
				aItemCol = ct.list();
/*
				if (aItemCol.isEmpty())
					LogFile.stdout("No AnswerTypes for this question");
	
				else {
					Iterator<AnswerItem> itAnsIt = aItemCol.iterator();
					while (itAnsIt.hasNext()) {
						AnswerItem auxAnsIt = itAnsIt.next();
		// LogFile.stdout("Type: " + auxAnsIt.getName());
						if (auxAnsIt instanceof EnumType) {
							Collection<EnumItem> enCol = ((EnumType) auxAnsIt).getItems();
							Iterator<EnumItem> itEnCol = enCol.iterator();
		// LogFile.stdout("Items:");
							while (itEnCol.hasNext()) {
								EnumItem theItem = itEnCol.next();
		// LogFile.stdout(theItem.getName() + ": " + theItem.getValue());
							}
	
						} // EO if instanceof EnumType
					} // first while
				} // else
*/
				tx.commit();
				return aItemCol;
			}
			catch (HibernateException hibEx) {
				if (tx != null)
					tx.rollback();
				
				hibEx.printStackTrace();
				
				return null;
			}
		}
		
		
		
	/**
	 * Retrieves the list of answers for a question
	 * @param hibSes, the hibernate session
	 * @param q, the question whose answers are gonna be retrieved
	 * @return
	 */	
		public static List<Answer> getAnswers4Question (Session hibSes, Question q) {
			
			String hql = "from Answer a where a.patAnsQues.question = :question",
				hqlDef = "select distinct a from Answer a join a.patAnsQues p where p.question=:question";
			Transaction tx = null;
			List<Answer> lAns = null;
			
			try {
				tx = hibSes.beginTransaction();
				Query qry = hibSes.createQuery(hqlDef);
				qry.setEntity("question", q);
				
				lAns = qry.list();
				
				tx.commit();
			}
			catch (HibernateException hibEx) {
				if (tx != null)
					tx.rollback();
				
//				hibEx.printStackTrace();
			}
			
			return lAns;
		}
		
		
	/**
	 * Creates a new question based on composer form parameters
	 * @param hibSess, the session to support the transaction
	 * @param qTxt, the text for the question
	 * @param ansItemId, the answer item id, if present (not for text items) (UNUSED)
	 * @param mandatory, mandatory param 
	 * @param repeat, the repeatable param
	 * @param parentSecId, the section id which the item is gonna belong to
	 * @param parentItemId, the container item id which the item is gonna be
	 * contained to
	 * @return 
	 */	
		public static Question createQuestion(Session hibSess, String theTxt,
				int iHighlight, String codQues, long ansItemId, int mandatory,
				int repeat, int parentSecId, int parentItemId) {
			Transaction tx = hibSess.getTransaction();
			tx = (!tx.isActive()) ? hibSess.beginTransaction() : tx;

			try {
				Long order;
				Section parent = (Section) hibSess.get(Section.class, new Integer(
						parentSecId));
				/*
				 * AbstractItem lastItem =
				 * HibController.ItemManager.getLastItem(hibSess, parent);
				 * 
				 * if (lastItem == null) order = new Long(1); else order =
				 * lastItem.getItemOrder();
				 */
// always the order of the item!!!
				order = new Long(parent.getItems().size());
				Question q = new Question(theTxt);
				q.setRepeatable(new Integer(repeat));
				q.setItemOrder(order + 1);
				q.setCodquestion(codQues);
				q.setHighlight(iHighlight);
				q.setMandatory(mandatory);
				hibSess.save(q);
				tx.commit();

				tx.begin();
				if (parent != null)
					q.setParentSec(parent);

				AbstractItem aIt = (AbstractItem) hibSess.get(AbstractItem.class,
						new Long(parentItemId));
				if (aIt != null)
					q.setContainer(aIt);
				tx.commit();
/*
				AnswerItem ansIt = (AnswerItem) hibSess.get(AnswerItem.class, new Long(
						ansItemId));

 set the answer item type and its order for the created question
				if (ansIt != null) {
					HibernateUtil.setAnswerType(hibSess, q, ansIt);
					HibernateUtil.setAnswerOrder(q, ansIt, 1);
				}
*/
				return q;
			} 
			catch (HibernateException hibEx) {
				if (tx != null)
					tx.rollback();

				hibEx.printStackTrace();
				return null;
			}
		}

	
	
	/**
	 * Creates a new text based on composer form
	 * 
	 * @param hibSess,
	 *          the session to support the transaction
	 * @param theTxt,
	 *          the text for the question
	 * @param parentSecId,
	 *          the section id which the item is gonna belong to
	 * @param parentItemId,
	 *          the container item id which the item is gonna be contained to
	 * @return
	 */
		public static Text createText (Session hibSess, String theTxt, int iHighlight,
																	int iRep, int parentSecId, int parentItemId) {
			Transaction tx = hibSess.getTransaction();
			tx = (!tx.isActive())? hibSess.beginTransaction(): tx;
			
			try {
				Long order;
				Section parent = (Section)hibSess.get(Section.class, new Integer (parentSecId));
/*				AbstractItem lastItem = HibController.ItemManager.getLastItem(hibSess, parent);
				
				if (lastItem == null)
					order = new Long(1);
				else
					order = lastItem.getItemOrder();
*/
				order = new Long (parent.getItems().size());
				Text t = new Text (theTxt);
				t.setItemOrder(order+1);
				t.setRepeatable(new Integer(iRep));
				t.setHighlight(iHighlight);
				hibSess.save(t);
				tx.commit();
				
				tx.begin();
				if (parent != null)
					t.setParentSec(parent);
				
				AbstractItem aIt = (AbstractItem)hibSess.get(AbstractItem.class, 
																										new Long(parentItemId));
				if (aIt != null)
					t.setContainer(aIt);
				tx.commit();
				
				return t;
			}
			catch (HibernateException hibEx) {
				if (tx != null)
					tx.rollback();
				
				hibEx.printStackTrace();
				return null;
			}
		}
		
		
	/**
	 * Delete all answers related to the question which is gonna be deleted
	 * @param q, the question which is gonna be deleted
	 * @return
	 */	
		public static boolean deleteAnswers (Session hibSes, Question q) {
			
			String hql = "from Answer a where a.patAnsQues.question = :question",
				hqlDef = "select distinct a from Answer a join a.patAnsQues p where p.question=:question";;
			Transaction tx = null;
			List<Answer> lAns = null;
			boolean theReturn = false;
			
			try {
				tx = hibSes.beginTransaction();
				Query qry = hibSes.createQuery(hqlDef);
				qry.setEntity("question", q);
				
				lAns = qry.list();
				for (Iterator<Answer> itAns =  lAns.iterator(); itAns.hasNext(); ) {
					Answer theAns = itAns.next();
System.out.println("Deleting "+theAns.getId()+":"+theAns.getValue());					
					hibSes.delete(theAns);
				}
				
				tx.commit();
				theReturn = true;
			}
			catch (HibernateException hibEx) {
				if (tx != null)
					tx.rollback();
			}
			return theReturn;
		}
		
	} // inner class ItemManager

	
	
	
/**
 * This inner static class encapsulates the methods with operations on Sections
 */	
	public static class SectionCtrl {
		
		
		
/**
 * Gets a ordered list of sections for an interview
 * @param hibSes, the hibernate session
 * @param intr, the interview whose sections are gonna be retrieved
 * @return a ordered list of sections
 */		
		public static List<Section> getSectionsFromIntrv (Session hibSes, 
											Interview intr) {
			List<Section> secCol = null;
			Transaction tx = null;
			
			try {
				tx = hibSes.beginTransaction();
				Criteria ct = hibSes.createCriteria(Section.class).
										addOrder(Order.asc("sectionOrder")).
										createCriteria("parentInt").
										add(Restrictions.eq("id", intr.getId()));
				
				secCol = ct.list();
				tx.commit();
			}
			catch (HibernateException hibEx) {
				if (tx != null)
					tx.rollback();
				
				LogFile.error("Fail to log section creation:\t");
				LogFile.error(hibEx.getLocalizedMessage());
				StackTraceElement[] stack = hibEx.getStackTrace();
				LogFile.logStackTrace(stack);
				
				return null;
			}
			
			return secCol;
		}
		
		
/**
 * Gets a list of sections partially matching agains name. The search is 
 * performed based on the like sql operator on the parameter %name%, where % is 
 * the sql wildcard. Set name param to "" (empty string) to retrieve all 
 * sections
 * @param hibSes, the hibernate session to perform the search
 * @param name, the name of the section
 * @return a Collection of Section objects
 */		
		public static List<Section> getSectionByName (Session hibSes, String name) {
			List<Section> secCol = null;
			Transaction tx = null;
			try {
				tx = hibSes.beginTransaction();
				Criteria ctSec = hibSes.createCriteria(Section.class).
																			 add(like("name", "%"+name+"%")).
																			 addOrder(Order.asc("sectionOrder"));
				secCol = ctSec.list();
				tx.commit();
			}
			catch (HibernateException hibEx) {
				if (tx != null)
					tx.rollback();
				
				hibEx.printStackTrace();
			}
			
			return secCol;
		}
		
		
		
/**
 * Get the section with highest id, which use to be the last added section. 
 * In further versions this can have to be changed for some date
 * @param hibSes, the session to perform the transaction
 * @return the section with highest id
 */		
		public static Section getLastSection (Session hibSes) {
/*
 * select *
from section
where section.iditem = (select max(section) from section)
 */			
			String sql = "select * from section where idsection = ";
			sql += "(select max(idsection) from section)";
			
		  Section s = (Section)hibSes.createSQLQuery(sql).addEntity(Section.class).
		  														uniqueResult();
		  													
System.out.println("s.id: "+s.getId());
			return s;
		}
		
		
	/**
	 * Creates a new section based on name and description
	 * @param hibSess
	 * @param name, a String representing the name of the section
	 * @param desc, a String representing some description
	 * @return
	 */	
		public static boolean createSection (Session hibSess, String name,
																				 String desc) {
			Transaction tx = null;
			try {
				tx = hibSess.getTransaction();
				tx = (!tx.isActive())? hibSess.beginTransaction(): tx;
				
				Section sec = new Section (name, desc);
				hibSess.save(sec);
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
	 * Creates a new section based on name and description
	 * @param hibSess
	 * @param name, a String representing the name of the section
	 * @param desc, a String representing some description
	 * @param parentIntr, the id of the parent interview
	 * @return
	 */	
		public static int createSection (Session hibSess, String name,
																				 String desc, Integer parentIntr) {
			Transaction tx = null;
			Integer newSecId;
			try {
				
				tx = hibSess.getTransaction();
				tx = (!tx.isActive())? hibSess.beginTransaction(): tx;
				
				Section sec = new Section (name, desc);
				newSecId = (Integer)hibSess.save(sec);
				tx.commit();
				
				tx = hibSess.beginTransaction();
				Section newSec = (Section)hibSess.get(Section.class, newSecId);
				Interview intr = (Interview)hibSess.get(Interview.class, parentIntr);
				
				newSec.setInterview(intr);
				newSec.setSectionOrder(intr.getSections().size());
				tx.commit();
				
				return newSecId;
			}
			catch (HibernateException hibEx) {
				if (tx != null)
					tx.rollback();
				
				LogFile.error("Fail to log section creation:\t");
				LogFile.error(hibEx.getLocalizedMessage());
				StackTraceElement[] stack = hibEx.getStackTrace();
				LogFile.logStackTrace(stack);
				
				return -1;
			}
		}
		
		
	/**
	 * Delete a section based on an id
	 * @param session, the hibernate session
	 * @param secId, the id of the section which is gonna be deleted
	 * @return true on sucessfully completion; otherwise false
	 */	
		public static boolean removeSection (Session session, Integer secId) {
			Transaction tx = session.getTransaction();
			tx = (!tx.isActive())? session.beginTransaction(): tx;
			try {
				Section theSection = (Section)session.get(Section.class, secId);
				
				session.delete(theSection);
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
		
		
	}
	
	
	public static class EnumTypeCtrl {
		
		
		
	/**
	 * Checks whether or not the enumitem represented by typeId and val has been
	 * used as answer for any question
	 * @param hibSes, the hibernate session
	 * @param typeId, the id of the type
	 * @param val, the value of the enumerated item. Each item belonging to an
	 * enumerated type has a different value
	 * @return true if the enumerated item has been used as answer; false otherwise
	 */	
		public static boolean isEnumitemAnswered (Session hibSes, Long typeId, String val) {
			
			String hql = "from Answer where answerItem = :ansType and value = :val";
			Transaction tx = null;
			
			try {
				tx = hibSes.beginTransaction();
				AnswerItem ait = (AnswerItem)hibSes.get(AnswerItem.class, typeId);
				
				Query qry = hibSes.createQuery(hql);
				qry.setEntity("ansType", ait);
				qry.setString("val", val);
				
				List<Answer> answers = qry.list();
				tx.commit();
				
				if (answers != null && answers.size() > 0)
					return true;
				else
					return false;
			}
			catch (HibernateException ex) {
				if (tx != null)
					tx.rollback();
				
				ex.printStackTrace(System.err);
			}
			
			return false;
		}
		
		
		
		
		
		
		
		
		
	/**
	 * This method checks whether or not the (enum)type represented by typeId
	 * is related to some question or it was just created
	 * @param hibSes, the hibernate session to use with this transaction
	 * @param typeId, the id of the enumtype
	 * @return true if the type is "linked" to one question; false otherwise
	 */
		public static boolean isType4Question (Session hibSes, Long typeId) {
			
			String hql = "from QuestionsAnsItems where theAnswerItem =:enItem";
			Transaction tx = null;
			try {
				tx = hibSes.beginTransaction();
				AnswerItem ai = (AnswerItem)hibSes.get(AnswerItem.class, typeId);
				
				Query qry = hibSes.createQuery(hql);
				qry.setEntity("enItem", ai);
				List<QuestionsAnsItems> res = qry.list();
				tx.commit();
				
				if (res != null && res.size() > 0)
					return true;
				else
					return false;
			}
			catch (HibernateException ex) {
				if (tx != null)
					tx.rollback();
				
				ex.printStackTrace(System.err);
				return false;
			}
		}
		
		
		
		
	/**
	 * Gets a collection of items for the enumeration type
	 * @param hibSes, the hibernate session to perform the queries
	 * @param enType, the enumeration type
	 * @return a collection with the types in this enum type or null whether
	 * the enum type doesnt have any item
	 */	
		public static List<EnumItem> getEnumItems (Session hibSes, 
																											EnumType enType) {
			List<EnumItem> auxCol = null;
			Transaction tx = null;
			try {
				tx = hibSes.getTransaction();
				tx = (!tx.isActive())? hibSes.beginTransaction(): tx;
			
				Criteria ct = hibSes.createCriteria(EnumItem.class).
															addOrder(Order.asc("listOrder")).
															createCriteria("parentType").
															add(Restrictions.eq("id", enType.getId()));
				auxCol = ct.list();
				tx.commit();
			}
			catch (HibernateException hibEx) {
				if (tx != null)
					tx.rollback();
				
				hibEx.printStackTrace();
			}
//			auxCol = enType.getItems();
			
			return auxCol;
		}
		
		
	/**
	 * Gets the enum items for a enum type defined by its name
	 * @param hibSess, the session to perform the transaction
	 * @param enumName, the name of the enumeration type
	 * @return a collection with the enumeration items inside or null if no items
	 */	
		public static List<EnumItem> itemsFromEnum (Session hibSess, 
																										 	String enumName) {
			Transaction tx = null;
			List<EnumItem> itemCol = null;
			try {
				tx = hibSess.getTransaction();
				tx = (!tx.isActive())? hibSess.beginTransaction(): tx;
				Criteria crit = hibSess.createCriteria(EnumType.class);
//				crit.add(Restrictions.eq("name", enumName));
				crit.add(Restrictions.like("name", enumName+"%"));
				EnumType aux = (EnumType)crit.uniqueResult();
//				itemCol = aux.getItems();
				itemCol = EnumTypeCtrl.getEnumItems(hibSess, aux);
				
				tx.commit();
			}
			catch (HibernateException hibEx) {
				if (tx != null)
					tx.rollback();
				
				hibEx.printStackTrace();
			}
			
			return itemCol;
		}	
			
		
	/**
	 * Adds an item to an enumeration type
	 * @param hibSess, the session to perform de transaction
	 * @param type, the enum type which the item is gonna be added to
	 * @param itemName, the name of the item to be added
	 * @param itemVal, the value for the item is gonna be added
	 * @return true on sucessful completion, otherwise false
	 */	
		public static boolean addItem2Enum (Session hibSess, EnumType type, 
																	String itemName, String itemVal) {
			Transaction tx = null;
			try {
				tx = hibSess.getTransaction();
				tx = (!tx.isActive())? hibSess.beginTransaction(): tx;
				
				EnumItem enIt = new EnumItem (itemName, itemVal);
				enIt.setParentType(type);
				hibSess.save(enIt);
				
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
	 * Creates a new enumeration type
	 * @param hibSes, the session which the transaction is gonna be performed in
	 * @param nameType, the name of the new enumtype
	 * @param items, a hashtable with pairs value-name for the items as it would
	 * be retrieved from a web form
	 * @return true on sucessful completion; otherwise returns false
	 */
		public static boolean createEnumType (Session hibSes, Interview owner, boolean fromClon, 
								String nameType, Vector<String> elems, Vector<String> vals) {
			Transaction tx = null;
			
			try {
//				tx = hibSes.getTransaction();
//				tx = (!tx.isActive())? hibSes.beginTransaction(): tx;
				tx = hibSes.beginTransaction();
				EnumType enType = new EnumType (nameType);
				hibSes.save(enType);
				enType.setIntrvOwner(owner);
//				enType.setForClone(fromClon? 1: 0);
				
				tx.commit();
// Warning: this is the way to chain transactions				
//				tx = hibSes.beginTransaction();
				tx.begin();
				int j=0;
				for (String elem: elems) {
					String val = vals.elementAt(j);
					EnumItem anItem = new EnumItem(elem, val);
					anItem.setParentType(enType);
					anItem.setListOrder(new Integer(j+1));
					hibSes.save(anItem);
					j++;
				}
/*				
				Enumeration<Integer> values = items.keys();
				int j=1;
				while (values.hasMoreElements()) {
					Integer aKey = values.nextElement();
					EnumItem anItem = new EnumItem(items.get(aKey), aKey.toString());
					anItem.setParentType(enType);
					anItem.setListOrder(new Integer(j++));
					hibSes.save(anItem);
				}
*/				
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

		
/*		
		public static boolean editEnumType (Session hibSes, String enumtype, Vector<String> elems, Vector<String> vals) {
			Transaction tx = null;
			try {
				tx = hibSes.getTransaction();
				tx = (!tx.isActive())? hibSes.beginTransaction(): tx;
				Collection<EnumType> typesCol = hibSes.createCriteria(EnumType.class).
																				add(eq("name", enumtype)).
																				list();
				EnumType myType = typesCol.iterator().next();
				return editEnumTypeInternal(hibSes,tx,myType,elems,vals);
			} catch (HibernateException hibEx) {
					if (tx != null)
						tx.rollback();
					
					hibEx.printStackTrace();
					return false;
			}
			
		}
*/
		
		
/**
 * Edit an enum type changing its name, its keys and the corresponding values
 * @param hibSes
 * @param enType, the enum type instance
 * @param name, the name of the enum type
 * @param elems, the keys of the enum type's items
 * @param vals, the corresponding vals
 * @return, true on successful completion; otherwise return false
 */		
		public static boolean editEnumType (Session hibSes, EnumType enType, 
								String name, Vector<String> elems, Vector<String> vals) {
			Transaction tx = null;
			try {
				tx = hibSes.getTransaction();
				tx = (!tx.isActive())? hibSes.beginTransaction(): tx;
				boolean resEdit = editEnumTypeInternal(hibSes, tx, enType, name, elems, vals);
// There is no necessary commit because it is done in the callees				
				return resEdit;
			} 
			catch (HibernateException hibEx) {
					if (tx != null)
						tx.rollback();
					
					hibEx.printStackTrace();
					return false;
			}
			
		}
		

/**
 * The same than above but using a type id rather than the type itself
 * @param hibSes
 * @param typeId, the id of the enum type
 * @param name, the name of the enum type
 * @param elems, the keys of the enum type's items
 * @param vals, the corresponding vals
 * @return, true on successful completion; otherwise return false
 */
		public static boolean editEnumType (Session hibSes, Long typeId, 
							String name, Vector<String> elems, Vector<String> vals) {
			Transaction tx = null;
			try {
				tx = hibSes.getTransaction();
				tx = (!tx.isActive())? hibSes.beginTransaction(): tx;
				EnumType enType = (EnumType)hibSes.get(EnumType.class, typeId);
//				boolean resEdit = editEnumTypeInternal(hibSes,tx,enType,name,elems,vals);
				boolean resEdit = updateNames (hibSes,tx,enType,name,elems,vals);
// There is no necessary commit because it is done in the callees
				return resEdit;
			} 
			catch (HibernateException hibEx) {
				if (tx != null)
					tx.rollback();
				
				hibEx.printStackTrace();
				return false;
			}
		}
		
		
		
/**
 * Update the names of the values for a enumerated type. This means both the 
 * type identifier and the value keys to do further statistical work won't be
 * changed
 * @param hibSes
 * @param tx, the transaction
 * @param enType, the enumerated type
 * @param name, hte name of the type
 * @param elems, the list of keys for the enumerated type
 * @param vals, the values for the type
 * @return true on sucessfully completion; false otherwise
 */
		protected static boolean updateNames (Session hibSes, Transaction tx, 
										EnumType enType, String name, 
										Vector<String> elems, Vector<String> vals) {
			try {
				List<EnumItem> lItems = enType.getItems();
				
	// now the enumtype is edited by adding the new items			
				int j=0;
				for (String elem: elems) {
					String val = vals.elementAt(j);
					
					for (EnumItem item: lItems) {
						if (item.getValue().equalsIgnoreCase(val)) {
							item.setName(elem);
							break;
						}
					}
//					hibSes.save(anItem);
					j++;
				}
				
				if (name != null && name.length() > 0)
					enType.setName(name);
				
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
	 * This method re-creates an enumtype. Actually this method relates with a 
	 * modification of the enumtype from the application
	 * @param hibSes, the session
	 * @param enumtype, the name of the enum type
	 * @param newItems, the new set of items for this enum type
	 * @return true on successful completion; otherwise returns false
	 */	
		protected static boolean editEnumTypeInternal (Session hibSes, Transaction tx, 
							EnumType enType, String name, Vector<String> elems, 
							Vector<String> vals) {
			try {
	// first remove the old items
				Collection<EnumItem> enItems = enType.getItems();
				for(EnumItem auxItem: enItems) {
					hibSes.delete(auxItem);
					// enItems.remove(auxItem);
				}
				// WARNING: you must also remove the relations, Jarl!
				enItems.clear();
	// now the enumtype is edited by adding the new items			
				int j=0;
				for (String elem: elems) {
					String val = vals.elementAt(j);
					EnumItem anItem = new EnumItem(elem, val);
					anItem.setParentType(enType);
					anItem.setListOrder(new Integer(j+1));
					hibSes.save(anItem);
					j++;
				}
				if (name != null && name.length() > 0)
					enType.setName(name);
				
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
 * Rearrange the items in an enumerated type
 * @param hibSes, the session to perform the transaction
 * @param itemSet, a hashtable with pairs <itemId,order>
 * @return true on successful completion; otherwise returns false
 */		
		public static boolean rearrangeItems (Session hibSes, 
																					Hashtable<Integer, Integer> itemSet) {
			Transaction tx = null;
			try {
				tx = hibSes.getTransaction();
				tx = (!tx.isActive())? hibSes.beginTransaction(): tx;

				Enumeration<Integer> itemIds = itemSet.keys();
				while (itemIds.hasMoreElements()){
					Integer anId = itemIds.nextElement();
					EnumItem theItem = (EnumItem)hibSes.get(EnumItem.class, 
																									new Long (anId.longValue()));
					theItem.setListOrder(itemSet.get(anId));
				}
				
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
	 * Removes an enumtype and associated items from datastores
	 * @param hibSes, the session to perform de transaction
	 * @param enumtype, the name of the enum type to remove
	 * @return true on sucessful completion; otherwise returns false
	 */	
		public static boolean delEnumType (Session hibSes, String enumtype) {
			
			Transaction tx = null;
			try {
				tx = hibSes.getTransaction();
				tx = (!tx.isActive())? hibSes.beginTransaction(): tx;
				
				Collection<EnumType> typesCol = hibSes.createCriteria(EnumType.class).
																				add(eq("name", enumtype)).
																				list();
				EnumType myType = typesCol.iterator().next();
				Collection<EnumItem> enItems = myType.getItems();
				Iterator<EnumItem> itItem = enItems.iterator();
				while (itItem.hasNext()) {
					EnumItem auxItem = itItem.next();
					hibSes.delete(auxItem);
				}
				hibSes.delete(myType);
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
	 * Deletes an item from the enumerated type represented by typeId with the value val
	 * @param hibSes, the hiberbate session to perform this transaction
	 * @param typeId, the id of the enumerated type
	 * @param val, the val (not the label) of the item belonging to this enumerated type
	 * @return several int values depending on the error:
	 * _ -2 if the enumerated type was not found
	 * _ -1 if the enumerated item was not found because of any reason
	 * _ 0 if the item was used as answer for any question
	 * _ 1 everything was ok
	 */
		public static int delEnumItem (Session hibSes, Long typeId, String val) {
			
			boolean isItemUsed = isEnumitemAnswered (hibSes, typeId, val);
			
			if (!isItemUsed) {
				String hql = "from EnumItem where value=:val and parentType=:entype";
				Transaction tx = null;
				try {
					tx = hibSes.beginTransaction();
					EnumType enType = (EnumType)hibSes.get(EnumType.class, typeId);
					
					if (enType != null) {
						Query qry = hibSes.createQuery(hql);
						qry.setEntity("entype", enType);
						qry.setString("val", val);
						
						EnumItem uniqueItem = (EnumItem)qry.uniqueResult();
						if (uniqueItem != null)
							hibSes.delete(uniqueItem);
						
						else {
							tx.commit();
							return -1;
						}
						
						tx.commit();
						return 1;
					}
					
					return -2;
				}
				catch (HibernateException ex) {
					if (tx != null)
						tx.rollback();
					
					ex.printStackTrace(System.err);
				}
			}
			
			return 0;
		}
		
	} // end of EnumTypeCtrl


}
