/**
 * 
 */
package org.cnio.appform.util;


import static org.hibernate.criterion.Restrictions.*;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.AnnotationConfiguration;
import org.hibernate.cfg.AnnotatedClassType;
import org.hibernate.Query;
import org.hibernate.Transaction;
import org.hibernate.Criteria;
import org.hibernate.HibernateException;
import org.hibernate.FetchMode;

import org.hibernate.criterion.*;

import org.cnio.appform.entity.*;

import java.util.List;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.Set;
import java.util.Collection;
import java.util.Collections;
import java.util.Properties;
import java.util.ResourceBundle;

import java.io.FileInputStream;

import java.sql.SQLException;

/**
 * @author gcomesana
 *
 */
public class HibernateUtil {
	
	public static final Integer MANDATORY = new Integer(1);
	public static final Integer OPTIONAL = new Integer(0);
	
	public static final Integer REPEATABLE = new Integer(1);
	public static final Integer SINGLE = new Integer(0);
	
	public static final Integer TEXT_HIGHLIGHT = new Integer (1);
	public static final Integer TEXT_NORMAL	= new Integer (0);
	
	public static final String MAIN_GROUPTYPE = "COUNTRY";
	public static final String HOSP_GROUPTYPE = "HOSPITAL";
	
	public static final String LOGIN_ATTEMPTS_KEY = "num_login_attempts";
	
	public static final String DB_USERNAME = "gcomesana";
	
// This value is set by default here but, actually, it is got from the
// JaasServlet init-param
	public static Integer MAX_LOGIN_ATTEMPTS = 8;

	private static SessionFactory sessionFactory;
	
	static {
		try {
			AnnotationConfiguration cfg = new AnnotationConfiguration ();
// LogFile.getLogger().info("mapping Project...");
			cfg.addAnnotatedClass(org.cnio.appform.entity.Project.class);
// LogFile.getLogger().info("mapping Interview...");			
			cfg.addAnnotatedClass(org.cnio.appform.entity.Interview.class);			
// LogFile.getLogger().info("mapping Section...");			
			cfg.addAnnotatedClass(org.cnio.appform.entity.Section.class);
// LogFile.getLogger().info("mapping AbstractItem...");			
			cfg.addAnnotatedClass(org.cnio.appform.entity.AbstractItem.class);
// LogFile.getLogger().info("mapping Question...");
			cfg.addAnnotatedClass(org.cnio.appform.entity.Question.class);
// LogFile.getLogger().info("mapping Text...");
			cfg.addAnnotatedClass(org.cnio.appform.entity.Text.class);
// LogFile.getLogger().info("mapping QuestionsAnsItems...");
			cfg.addAnnotatedClass(org.cnio.appform.entity.QuestionsAnsItems.class);			
// LogFile.getLogger().info("mapping AnswerItem...");
			cfg.addAnnotatedClass(org.cnio.appform.entity.AnswerItem.class);			
// LogFile.getLogger().info("mapping AnswerType...");
			cfg.addAnnotatedClass(org.cnio.appform.entity.AnswerType.class);
// LogFile.getLogger().info("mapping EnumType...");
			cfg.addAnnotatedClass(org.cnio.appform.entity.EnumType.class);
// LogFile.getLogger().info("mapping EnumItem...");
			cfg.addAnnotatedClass(org.cnio.appform.entity.EnumItem.class);
// LogFile.getLogger().info("mapping Answer...");
			cfg.addAnnotatedClass(org.cnio.appform.entity.Answer.class);
// LogFile.getLogger().info("mapping Patient...");
			cfg.addAnnotatedClass(org.cnio.appform.entity.Patient.class);
// LogFile.getLogger().info("mapping Hospital...");
//			cfg.addAnnotatedClass(org.cnio.appform.entity.Hospital.class);			
// LogFile.getLogger().info("mapping Role...");
			cfg.addAnnotatedClass(org.cnio.appform.entity.Role.class);			
// LogFile.getLogger().info("mapping AppUser...");
			cfg.addAnnotatedClass(org.cnio.appform.entity.AppUser.class);
// LogFile.getLogger().info("mapping AppuserRole...");
			cfg.addAnnotatedClass(org.cnio.appform.entity.AppuserRole.class);
// LogFile.getLogger().info("mapping RelIntrvGroup...");
			cfg.addAnnotatedClass(org.cnio.appform.entity.RelIntrvGroup.class);			
// LogFile.getLogger().info("mapping GroupType...");
			cfg.addAnnotatedClass(org.cnio.appform.entity.GroupType.class);			

			cfg.addAnnotatedClass(org.cnio.appform.entity.AppDBLogger.class);
/*// LogFile.info("mapping IntrvInstance...");
			cfg.addAnnotatedClass(org.cnio.appform.entity.IntrvInstance.class);
// LogFile.info("mapping UsrPatIntrinst...");
			cfg.addAnnotatedClass(org.cnio.appform.entity.UsrPatIntrinst.class);			
*/
			
// LogFile.getLogger().info("mapping AppGroup...");
			cfg.addAnnotatedClass(org.cnio.appform.entity.AppGroup.class);
// LogFile.getLogger().info("mapping PatGivesAns2Ques...");
			cfg.addAnnotatedClass(org.cnio.appform.entity.PatGivesAns2Ques.class);
// LogFile.getLogger().info("mapping Performance...");
			cfg.addAnnotatedClass(org.cnio.appform.entity.Performance.class);
// LogFile.getLogger().info("mapping RelGrpAppuser...");
			cfg.addAnnotatedClass(org.cnio.appform.entity.RelGrpAppuser.class);
// LogFile.getLogger().info("mapping RelPrjAppusers...");
			cfg.addAnnotatedClass(org.cnio.appform.entity.RelPrjAppusers.class);
			
			cfg.addAnnotatedClass(org.cnio.appform.entity.PerfUserHistory.class);
			
			cfg.addAnnotatedClass(org.cnio.appform.entity.EnumTypesView.class);
			cfg.addAnnotatedClass(org.cnio.appform.entity.SimpleTypesView.class);
			cfg.configure();
			
			sessionFactory = cfg.buildSessionFactory();
//		sessionFactory=new Configuration().configure().buildSessionFactory();
		}  
		catch (Throwable ex) {
//			throw new ExceptionInInitializerError(ex);
			ex.printStackTrace();
		}
/*
		try {

			Properties props = new Properties ();
			props.load(new FileInputStream ("application.props"));
			
			String propsNumLogin = (String)props.get(NUM_LOGIN_ATTEMPTS);
			MAX_LOGIN_ATTEMPTS = Integer.parseInt(propsNumLogin);

			ResourceBundle rsrc = ResourceBundle.getBundle("application.props");
			
			String propsNumLogin = (String)rsrc.getObject(NUM_LOGIN_ATTEMPTS);
			MAX_LOGIN_ATTEMPTS = Integer.parseInt(propsNumLogin);
			
System.out.println("numLoginAttemps from props: "+MAX_LOGIN_ATTEMPTS);
		}
		catch (Exception ioEx) {
			ioEx.printStackTrace ();
		}
*/		
		
	}
	
	public static SessionFactory getSessionFactory() {
		// Alternatively, you could look up in JNDI here
		return sessionFactory;
	}
	
	public static void shutdown() {
		// Close caches and connection pools
		getSessionFactory().close();
	}
	
	
	
/**
 * Set the maximum login attempts
 * @param attempts, the maximum number of login attempts
 */
	public static void setMaxLoginAttempts (int attempts) {
		MAX_LOGIN_ATTEMPTS = attempts;
	}
	
	
/**
 * Add an item to a section named by secName
 * @param session, the session within which the transaction is gonna be performed
 * @param secName, the name of the section container for the text
 * @param content, the content of the text
 * @return true on successful completion, false otherwise
 *
	public static boolean addItem2Section (Session session, Section parent, 
																				 String content) {
LogFile.info("Starting adding text 2 section...");
		Transaction tx = session.beginTransaction();
		try {

			Item theTxt = new Item(content, parent);
			session.save(theTxt);
			tx.commit();
			
			return true;
		}
		catch (HibernateException exHib) {
LogFile.stderr("Exception in addSection2Intrv(...)");
			if (tx != null)
				tx.rollback();
			
			exHib.printStackTrace();
			return false;
		}
	}
*/
	
	
/**
 * Add an item to a section. If anItem is not in the db, it is made persistent
 * @param session, a session to perform the transaction
 * @param parent, the section the item belongs to
 * @param anItem, the item to store in the section
 * @return true on sucessful completion, otherwise false
 *
	public static boolean addItem2Section (Session session, Section parent, 
																				 Item anItem) {
LogFile.info("Starting adding item object 2 section..."+anItem.toString());
		Transaction tx = null;
		try {
// if the item doesent exist in db, it is made persistent			
			if (anItem.getId() == null) {
				tx = session.beginTransaction();
				session.save(anItem);
				tx.commit();
			}
			
			tx = session.beginTransaction();
//			parent.getItems().add((Item)session.get(Item.class, anItem.getId()));
			parent.getItems().add(anItem);
			anItem.setParentSec(parent);
			tx.commit();
				
			return true;
		}
		catch (HibernateException exHib) {
LogFile.stderr("Exception in addSection2Intrv(...)");
			if (tx != null)
				tx.rollback();
			
			exHib.printStackTrace();
			return false;
		}
	}	
	
	
	
/**
 * Add a text to a section named by secName
 * @param session, the session within which the transaction is gonna be performed
 * @param secName, the name of the section container for the text
 * @param heading, the content of the text
 * @param qOrder, the text order, which is optional
 * @param qType, the type of the question as retrieved from answertype table
 * @return true on successful completion, false otherwise
 *
	public static boolean addQuestion2Section (Session session, String secName, 
																				 		String heading, String ansType,
																				 		Integer order) {
LogFile.info("Starting adding question to section...");
		Transaction tx = session.beginTransaction();
		try {
			Section parent = (Section)session.createCriteria(Section.class).
												add(Restrictions.eq("name", secName)).uniqueResult();
			
			if (order == null || order <= 0)
				order = HibernateUtil.getOrder(session, Section.class, secName);
			
			Text txt = new Text (heading, order, parent);
			session.save(txt);
			
			AnswerType at = (AnswerType)session.createCriteria(AnswerType.class).
											add(Restrictions.eq("name", ansType)).
											uniqueResult();
			Question q = new Question (at);
			session.save(q);
			q.addText(txt);
			
//			q.setAnswerType(at);
			tx.commit();
			
			return true;
		}
		catch (HibernateException exHib) {
LogFile.stderr("Exception in addQuestion2Section (...)");
			if (tx != null)
				tx.rollback();
			
			exHib.printStackTrace();
			return false;
		}
	}
	*/
	
	

/**
 * Returns an ordered (by text order) collection of the texts for the 
 * section sec
 * @param hibSes, the section to perform the transaction
 * @param name, the name of the type
 * @param desc, a description for the type
 * @param pattern, it will be a pattern to use in reg exps.
 * @return, true on successful completion; otherwise it returns false and the
 * transaction will be rolled back.
 */
	public static boolean createSimpleType (Session hibSes, String name,
																					String desc, String pattern) {
		Transaction tx = hibSes.getTransaction();
		if (!tx.isActive())
			tx = hibSes.beginTransaction();
		
		try {
			AnswerType at = new AnswerType (name);
			at.setDescription(desc);
			if (pattern != null && pattern.length() != 0)
				at.setPattern(pattern);
													
			hibSes.save(at);
			
			tx.commit();
			return true;
		} 
		catch (HibernateException e) {
			if (tx != null) {
				tx.rollback();
//				e.printStackTrace();
			}
			return false;
		}
	}
	
	

	
/**
 * Returns an ordered (by item order) list of items for the section sec, which
 * are containers for another items or items without containees but without
 * being contained in any container
 * @param session, the section to perform the transaction
 * @param sec, the section container of the texts
 * @return, a collection of items or null if an error has produced
 */
	public static List<AbstractItem> getContainers4Section (Session session, 
																								 	 							Section sec){
		Transaction tx = null;
		
		try {
			tx = session.beginTransaction();
			Criteria ordItems = session.createCriteria(AbstractItem.class).
																		addOrder(Order.asc("itemOrder")).
																		add(Restrictions.isNull("container")).
																		add(Restrictions.eq("parentSec", sec));
			
			List<AbstractItem> res = ordItems.list();
			tx.commit();
			
			return res;
		} 
		catch (HibernateException e) {
			if (tx != null)
				tx.rollback();
				
			e.printStackTrace();
			return null;
		}
	}	

	
	
	
/**
 * Returns an ordered (by item order) collection of the texts for the 
 * section sec (candidate to be deleted)
 * @param session, the section to perform the transaction
 * @param sec, the section container of the texts
 * @return, a collection of items or null if an error has produced
 */
	public static List<AbstractItem> getItems4Section (Session session, 
																								 	 Section sec){
		Section theSection;
		Transaction tx = session.getTransaction();
		if (!tx.isActive())
			tx = session.beginTransaction();
		
		try {
			Criteria ordTexts = session.createCriteria(AbstractItem.class).
													createAlias("parentSec", "p").
													add(Restrictions.eq("p.id", sec.getId())).
													addOrder(Order.asc("itemOrder"));
			
			/*
			theSection = (Section)session.createCriteria(Section.class).
													add(Restrictions.eq("name", secName)).uniqueResult();
			*/																		 
			List<AbstractItem> res = ordTexts.list();
													
			tx.commit();
			return res;
		} 
		catch (HibernateException e) {
			if (tx != null) {
				tx.rollback();
				e.printStackTrace();
			}
			return null;
		}
	}	
			
		
	
/**
 * Gets the elements for the section with id secId. The elements are ordered first
 * like normal items and containers and then, the containees are ordered just inside
 * the containers. The order is set when the elements are saved or updated, so
 * the responsibility 
 * @param session, the session to perform the query
 * @param secName, the name of the section
 * @return a Collection of Items or null on error
 */
	public static List<AbstractItem> getItems4Section (Session session, 
																									 Integer secId) {
		Section theSection;
		List<AbstractItem> itemsSec;
		
		theSection = (Section)session.get(Section.class, secId);
	  itemsSec = HibernateUtil.getContainers4Section(session, theSection);
//			if (itemsSec.size() > 1)
	  Transaction tx = null;
	  try {
	  	tx = session.beginTransaction();
	  	itemsSec = HibernateUtil.allItems(session, itemsSec);
	  	tx.commit();
	  }
	  catch (HibernateException hibEx) {
	  	if (tx != null)
	  		tx.rollback();
	  	
	  	hibEx.printStackTrace();
	  	itemsSec = null;
	  }
		
		return itemsSec;
	}

	
	
	
	
/**
 * Gets all items belonging to a section with the right order and taking into
 * account containers and containees.
 * @param l, the list of simple items and containers for one section
 * @return the list with the entire set of elements for one section
 */	
	private static List<AbstractItem> allItems (Session ses, List<AbstractItem> l) {
		List<AbstractItem> aux = new ArrayList<AbstractItem> ();
		
		for (int i=0; i<l.size(); i++) {
			AbstractItem current = l.get(i); 
			aux.add(current);
			if (current.getContainees().size() > 0)
//					aux.addAll(allItems(current.getContainees()));
				aux.addAll(allItems(ses, HibController.ItemManager.getOrderedContainees(ses, current)));
		}
		return aux;
	}
			
			
			
		
/**
 * This method says whether or not the answer item is already used in some
 * answer. This is used to know if the answeritem can be deleted or updated.
 * @param hibSes, the session
 * @param ai, the answer item to know if it is already used.
 * @return true if the type is used, false otherwise 
 */	
	public static boolean isTypeUsed (Session hibSes, AnswerItem ai) {
// This one maybe has to be embedded into a transaction		
		Transaction tx = null;
		List<Answer> lAns;
		try {
			tx = hibSes.beginTransaction();
		
// We have to see the ternary relationship table to see if, actually, the 
// answeritem is involved in a question for some patient
			String hqlStr = "from Answer a where a.answerItem=:ai",
				hqlStrBis = "from PatGivesAns2Ques p join p.answer a join p.question q "
					+" where a.answerItem=:ai";
			Query qry = hibSes.createQuery(hqlStrBis);
			qry.setEntity("ai", ai);
			lAns = qry.list();
			tx.commit();
			
			if (lAns == null || lAns.size() == 0)
				return false;
			else
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
 * Gets the sections for the interview identified with its name. We supposed here 
 * there is only one interview for this name
 * @param session, the session to perform the query
 * @param secName, the name of the section
 * @return a Collection of Items or null on error
 */
//	public static List<AbstractItem> getItems4Section (Session session, 
//																									 String secName) {
//		Section theSection;
//		Transaction tx = session.getTransaction();
//		if (!tx.isActive())
//			tx = session.beginTransaction();
//		
//		try {
//			Criteria ordTexts = session.createCriteria(AbstractItem.class).
//													createAlias("parentSec", "p").
//													add(Restrictions.eq("p.name", secName)).
//													addOrder(Order.asc("itemOrder"));
//			
//			/*
//			theSection = (Section)session.createCriteria(Section.class).
//													add(Restrictions.eq("name", secName)).uniqueResult();
//			*/																		 
//			List<AbstractItem> res = ordTexts.list();
//													
//			tx.commit();
//			return res;
//		} 
//		catch (HibernateException e) {
//			if (tx != null) {
//				tx.rollback();
//				e.printStackTrace();
//			}
//			return null;
//		}
//	}
	

	
	
/*	
	private static List<Pair<Integer, AbstractItem>> allPairs (List<Pair<Integer, AbstractItem>> l, int deep) {
		List<Pair<Integer, AbstractItem>> aux = new ArrayList<Pair<Integer, AbstractItem>> ();
		
		for (int i=0; i<l.size(); i++) {
			Pair<Integer, AbstractItem> current = l.get(i);
			aux.add(current);
			AbstractItem it = current.getSnd();
			if (it.getContainees().size() > 0)
				aux.addAll(allItems();
		}
		return aux;
	}
	
	
	
	public static List<Pair<Integer, AbstractItem>> getPairs4Section (Session session, 
			 								Integer secId) {
		Section theSection;
		List<Pair<Integer,AbstractItem>> pairs = 
						new ArrayList<Pair<Integer,AbstractItem>> ();
		List<AbstractItem> itemsSec;
		
		theSection = (Section)session.get(Section.class, secId);
		itemsSec = HibernateUtil.getContainers4Section(session, theSection);
		
		for (int i=0; i<itemsSec.size(); i++)
			pairs.add(new Pair<Integer, AbstractItem>(0, itemsSec.get(i)));
		
		if (itemsSec.size() > 1)
			pairs = HibernateUtil.allPairs(pairs, 0);
		
		return pairs;
	}
*/	
	

	
/**
 * Gets a list of current questions for the section
 * @param hibSess, a hibernate session to perform the transaction
 * @param sec, the section
 * @return a collectoin of questions of the section
 */	
	public static Collection<Question> sectionQuestions (Session hibSess, 
																												Section sec) {
		Collection<Question> questions = null;
		try {
			Criteria ct = hibSess.createCriteria(Question.class).
										createAlias("parentSec", "sec").
										add(Restrictions.eq("sec.id", sec.getId()));
			
			questions = ct.list();
		}
		catch (HibernateException hibEx) {
			hibEx.printStackTrace();
		}
		
		return questions;
	}


	
	
/**
 * Remove all answer types for a question, which means to delete 
 * @param hibSess, the session to perform the transaction
 * @param q, the "detached" question object
 * @return
 */	
	public static boolean rmvAnswerTypes4Question (Session hibSess, Question q) {
		
		Transaction tx = hibSess.getTransaction();
		if (!tx.isActive())
			tx = hibSess.beginTransaction();
		
		try {
// in order to get all answer items for a question, the sql to be run is like
// select * from question, questionansitems 
// where question.id = questionansitems.qid
			String sqlQuery = "select * from question_ansitem where codquestion="+
												q.getId().toString();
			List<QuestionsAnsItems> l = hibSess.createSQLQuery(sqlQuery).
																				 addEntity(QuestionsAnsItems.class).
																				 list();
			for (QuestionsAnsItems qai: l) 
				hibSess.delete(qai);
			
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
 * Gets the collection of enumerated types for all interviews. Most of them
 * will be repeated
 * @param hibSess, the session
 * @param ait, the abstract item to get the answer items
 * @return a collection of answer items, which is null
 */	
	public static Collection<EnumType> getEnumTypes (Session hibSess) {
/////////////////////////// get the data type(s) associated to this question
		Collection<EnumType> enumTypeCol = null;
		Criteria ct = hibSess.createCriteria(EnumType.class);
		ct.addOrder(Order.asc("name"));
		enumTypeCol = ct.list();
	
		return enumTypeCol;
	}
		
		
		
	
/**
 * Return the list of enumerated types for the interview with id intrvId
 * @param hibSes, the hibernate session
 * @param intrvId, the id of the interview whose enum types want to be retrieved
 * @return
 */	
	public static List<EnumType> getEnumTypes (Session hibSes, Integer intrvId) {
		List<EnumType> enumTypeList = null;
		String hqlStr = "from EnumType e where e.intrvOwner=:intrv order by e.name";
		Interview intrv = null;
		Transaction tx = null;
		
		try {
			tx = hibSes.beginTransaction();
			intrv = (Interview)hibSes.get(Interview.class, intrvId);
			
			Query qry = hibSes.createQuery(hqlStr);
			qry.setEntity("intrv", intrv);
			enumTypeList = qry.list();
			tx.commit();
		}
		catch (HibernateException hibEx) {
			if (tx != null)
				tx.rollback();
		}
		
		return enumTypeList;
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
		List<AnswerItem> aItemCol = null;
		Session ses = HibernateUtil.getSessionFactory().getCurrentSession(); 
		Transaction tx = ses.beginTransaction();
		try {
			if (ait instanceof Question) {
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
				tx.commit();
				if (aItemCol.isEmpty())
					LogFile.info("No AnswerTypes for this question");
		
				else {
					Iterator<AnswerItem> itAnsIt = aItemCol.iterator();
			
				} // else
			} // if ait instanceof Question
			else
				return null;
		}
		catch (HibernateException ex) {
			if (tx != null) 
				tx.rollback();
			
			LogFile.getLogger().error(ex.getLocalizedMessage());
			StackTraceElement[] stElems = ex.getStackTrace();
			LogFile.logStackTrace(stElems);
			
			return null;
		}
		return aItemCol;
	}	

	
	
/**
 * Gets all types of answer as are in the database
 * @param hibSes, the hibernate session to perform the transaction
 * @return
 */	
	public static List<AnswerItem> getAnswerItems (Session hibSes, Interview intrv) {
		
		Transaction tx = null;
		List<AnswerItem> lAnsItems = null;
		try {
			tx = hibSes.beginTransaction();
			Criteria ct = hibSes.createCriteria(AnswerItem.class);
			if (intrv != null)
				ct.add(Restrictions.eq("intrvOwner", intrv));
			
			ct.addOrder(Order.asc("name"));
			lAnsItems = ct.list();
			tx.commit();
			
			return lAnsItems;
		}
		catch (HibernateException hibEx) {
			if (tx != null)
				tx.rollback();
			
			hibEx.printStackTrace();
			return null;
		}
		
	}
	
	
	
/**
 * Similar method to the previous one but with different signature (this one 
 * expects a interview id instead the interview object itself) and, internally,
 * a Query object is used instead a query by criteria
 * @param hibSes, the hibernate session supporting the transaction
 * @param intrvId, the interview id
 * @return, a list of answeritems or null if it happened an error
 */
	public static List<AnswerItem> getAnswerItems	 (Session hibSes, Integer intrvId) {
		String hql = "from AnswerItem ai where intrvOwner=:intrv";
		Transaction tx = null;
		List<AnswerItem> list = null;
		try {
			tx = hibSes.beginTransaction();
			Interview intrv = (Interview)hibSes.get(Interview.class, intrvId);
			
			Query qry = hibSes.createQuery(hql);
			qry.setEntity("intrv", intrv);
			
			list = qry.list();
			tx.commit();
			
			return list;
		}
		catch (HibernateException hibEx) {
			if (tx != null) {
        tx.rollback();
      }
      String msgLog = "Unable to get answer types for interview with id '" + intrvId +"'";
      LogFile.error(msgLog);
      LogFile.error(hibEx.getLocalizedMessage());
      StackTraceElement[] stack = hibEx.getStackTrace();
      LogFile.logStackTrace(stack);

      return null;
		}
	}
	
	
	
	
/**
 * Gets the AnswerItem based on its name. 
 * On 27.03 several types with the same name are allowed, but this method 
 * returns only the first one found
 * @param hibSes, the session to perform the transaction
 * @param name, the name of the answer item
 * @return the first AnswerItem found matching with name or null whether nothing
 * was found
 */	
	public static AnswerItem getAnswerItem (Session hibSes, String name) {
		Criteria ct = hibSes.createCriteria(AnswerItem.class).
												 add(like("name", name+"%").ignoreCase()).addOrder(Order.asc("name"));
		Collection<AnswerItem> colItems = ct.list();
		
		return (colItems != null && colItems.size()>0)? 
																colItems.iterator().next(): null;
	}
	

	
	public boolean canHavePattern (Session hibSes, Integer ansItemId) {
		
		Transaction tx = null;
		AnswerItem ai = null;
		try {
			tx = hibSes.beginTransaction();
			ai = (AnswerItem)hibSes.get(AnswerItem.class, ansItemId);
			tx.commit();
			
			if (ai.getName().equalsIgnoreCase(HibController.TYPE_DECIMAL) ||
					ai.getName().equalsIgnoreCase(HibController.TYPE_NUMBER))
				return true;
			else
				return false;
		}
		catch (Exception ex) {
			if (tx != null)
				tx.rollback();
		}
		
		return false;
	}	
	
	
/**
 * Get the pattern of the answer item in position order for the Question q 
 * @param hibSes, the session
 * @param q
 * @param order
 * @return
 */	
	public static String getPattern (Session hibSes, Question q, int order) {
		
		String hqlStr = "from QuestionsAnsItems qai where qai.theQuestion.id = "+
					q.getId()+" and qai.answerOrder = "+order;
		String pattern = null;
		Query qry = null;
		
		Transaction tx = null;
		try {
			tx = hibSes.beginTransaction();
			qry = hibSes.createQuery(hqlStr);
			QuestionsAnsItems qai = (QuestionsAnsItems)qry.uniqueResult();
			
			pattern = qai.getPattern();
			tx.commit();
		}
		catch (org.hibernate.NonUniqueResultException nonEx) {
			List<QuestionsAnsItems> lQai = qry.list();
			
			pattern = lQai.get(0).getPattern();
		}
		catch (HibernateException hibEx) {
			if (tx != null)
				tx.rollback();
			
			pattern = null;
		}
		
		return pattern;
	}
	
	
/**
 * Set an answertype for the question. The answertype should be a numerical
 * type along with its pattern. The order is took into account
 * @param hibSess, the hibernate session
 * @param q, the question to be qualified by a answer type
 * @param a, the answer type to qualify the question
 * @return true on sucessfully completion; otherwise false
 */
	public static boolean setFullAnswerType (Session hibSess, Question q, 
																			 		AnswerItem ans, 
																			 		int order, String pattern) {
		Transaction tx = null;
		try {
			tx = hibSess.getTransaction();
			tx = (!tx.isActive())? hibSess.beginTransaction(): tx;
			QuestionsAnsItems qa = new QuestionsAnsItems(q, ans);
			hibSess.save(qa);
			
			qa.setAnswerOrder(new Long(order));
			qa.setPattern(pattern);
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
 * Set an answertype for the question, without order or pattern
 * @param hibSess, the hibernate session
 * @param q, the question to be qualified by a answer type
 * @param a, the answer type to qualify the question
 * @return true on sucessfully completion; otherwise false
 */
	public static boolean setAnswerType (Session hibSess, Question q, 
																			 AnswerItem ans) {
		Transaction tx = null;
		try {
			tx = hibSess.getTransaction();
			tx = (!tx.isActive())? hibSess.beginTransaction(): tx;
			QuestionsAnsItems qa = new QuestionsAnsItems(q, ans);
			hibSess.save(qa);
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
 * This method set the order for the answeritem a of the question q. Remember
 * the relationship between answeritem and question is given by the 
 * question_ansitem table implementing a M-N relationship
 * @param q, the question
 * @param a, one of the answer(items) for the question q
 * @param order, the order for the answer
 * @return, true on success; otherwise, returns false
 */	
	public static boolean setAnswerOrder (Question q, AnswerItem a, int order) {
		Session ses = HibernateUtil.getSessionFactory().getCurrentSession(); 
		Transaction tx = ses.beginTransaction();
		try {
			Criteria ct = ses.createCriteria(QuestionsAnsItems.class).
												createAlias("theAnswerItem", "a").
												createAlias("theQuestion", "q").
												add(Restrictions.eq("a.id", a.getId())).
												add(Restrictions.eq("q.id", q.getId()));
			
			QuestionsAnsItems qai = (QuestionsAnsItems)ct.uniqueResult();
			qai.setAnswerOrder(new Long(order));
//			ses.save(qai);
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
 * This private method creates de introduction section for every created 
 * interview
 * @param intrv, the interview to be initialized...
 * @return
 */	
	private static boolean createIntro (Interview intrv) {
		
		Session mySes = HibernateUtil.getSessionFactory().getCurrentSession();
//		mySes.beginTransaction();
		
		AnswerItem ai; // = getAnswerItem(mySes, "label");
		Criteria ct = mySes.createCriteria(AnswerItem.class).
		 										add(like("name", "free text"+"%").ignoreCase());
		Collection<AnswerItem> colItems = ct.list();
		
		ai = (colItems != null)? colItems.iterator().next(): null;
		if (ai == null) {
			mySes.getTransaction().rollback();
			return false;
		}
		else {
			Section intro = new Section ("Introducción", "");
			intro.setInterview(intrv);
			mySes.save(intro);
			
			Question qPatCode = new Question ("Código de paciente:");
			qPatCode.setParentSec(intro);
			qPatCode.setItemOrder(new Long (1));
			mySes.save(qPatCode);
		
		
			QuestionsAnsItems qas = new QuestionsAnsItems (qPatCode, ai);
			qas.setAnswerOrder(new Long(1));
			mySes.save(qas);
/*			
			Text titleTxt = new Text ("Título de la página de introducción");
			titleTxt.setParentSec(intro);
			titleTxt.setItemOrder(new Long (2));
			mySes.save(titleTxt);
			
			Text introTxt = new Text ("Escribe aquí el texto de introducción");
			introTxt.setParentSec(intro);
			introTxt.setItemOrder(new Long (3));
			mySes.save(introTxt);*/
		}

//		mySes.getTransaction().commit();
		return true;
	}
		
	
	
/**
 * Creates a new project based on name and description. The users assigned to 
 * the project will be defined in elsewhere
 * @param hibSess
 * @param name, a String representing the name of the section
 * @param desc, a String representing some description
 * @param code, a String representing the code associated to this project, which
 * use to be 3 digit long.
 * @return
 */	
	public static int createProj (Session hibSess, String name, String desc, String code) {
		Transaction tx = null;
		try {
			tx = hibSess.getTransaction();
			tx = (!tx.isActive())? hibSess.beginTransaction(): tx;
			
			Project prj = new Project (name, desc, code);
			Integer idPrj = (Integer)hibSess.save(prj);
			tx.commit();
			
			return idPrj.intValue();
		}
		catch (HibernateException hibEx) {
			if (tx != null)
				tx.rollback();
			
			hibEx.printStackTrace();
			return -1;
		}
	}
	
	
	
/**
 * Delete a project based on an id
 * @param session, the hibernate session
 * @param secId, the id of the section which is gonna be deleted
 * @return true on sucessfully completion; otherwise false
 */	
	public static boolean removeProj (Session session, Integer projId) {
		Transaction tx = session.getTransaction();
		tx = (!tx.isActive())? session.beginTransaction(): tx;
		try {
			Interview theProj = (Interview)session.get(Interview.class, projId);
			
			session.delete(theProj);
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
 * Gets a list of projects partially matching the name. The search is 
 * performed based on the like sql operator on the parameter %name%, where % is 
 * the sql wildcard. Set name param to "" (empty string) to retrieve all 
 * sections
 * @param hibSes, the hibernate session to perform the search
 * @param name, the name of the section
 * @return a Collection of Section objects
 */		
		public static List<Project> getProjectByName (Session hibSes, String name) {
			Criteria ctSec = hibSes.createCriteria(Project.class).
															 add(like("name", "%"+name+"%"));
			return ctSec.list();
		}	
	
	
/**
 * Add a list of sections to the interview intrv
 * @param session
 * @param intrv
 * @param sections
 * @return
 */	
	public static boolean addSection2Interview (Session session, Interview intrv, 
																							List<Section> sections) {
		
		Transaction tx = session.getTransaction();
		tx = (!tx.isActive())? session.beginTransaction(): tx;
		try {
			
			Iterator<Section> itSec = sections.iterator();
			while (itSec.hasNext()) {
				Section oneSec = itSec.next();
				oneSec.setInterview(intrv);
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
}

