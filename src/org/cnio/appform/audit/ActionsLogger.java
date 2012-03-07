package org.cnio.appform.audit;

import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.HibernateException;

import org.cnio.appform.entity.*;
import org.cnio.appform.util.HibernateUtil;
import org.cnio.appform.util.LogFile;

/**
 * This is a class which concentrates all database audition stuff. So, all
 * kind of actions has to be logged to DB by calling one of these methods.
 * The AppDBLogger entity class will be used to audit every action. The fields
 * to be audit will be sessionId, userId, itemId, timestamp and a log Message
 * @author bioinfo
 *
 */
public class ActionsLogger {
	
	private Session hibSes;
	
// ITEMS TO BE AUDIT	
	public static final Integer INTERVIEW = 1;
	public static final Integer PROJECT = 0;
	public static final Integer SECTION = 2;
	public static final Integer PERFORMANCE = 3;
	public static final Integer PATIENT = 4;
	public static final Integer QUESTION = 5;
	public static final Integer SAMPLE = 6;
	
// ACTIONS TO BE AUDIT
	public static final Integer CREATE = 0;
	public static final Integer UPDATE = 1;
	public static final Integer DELETE = 2;
	public static final Integer QUERY = 3;
	
	
	
	public ActionsLogger () {
		hibSes = HibernateUtil.getSessionFactory().openSession();
	}
	
	
	public ActionsLogger (Session theSes) {
		hibSes = theSes;
	}
	
	
/**
 * Inserts a row log in the applog table in the database
 * @param sessionId
 * @param userId
 * @param what, the item to log. This is mostly to build the messago
 * @param itemId, the item id in the database
 * @param itemName
 * @param action, the action performed on the item
 * @return
 */
	public Integer logItem (String sessionId, String ipAddr, Integer userId, Integer what, 
													Integer itemId, String itemName, Integer action) {
		
		String msgLog = null, whatItem, whatAction = "", username = "";
		Integer returningId = -1;
		
		if (what == ActionsLogger.PROJECT)
			whatItem = "project";
		
		else if (what == ActionsLogger.INTERVIEW)
			whatItem = "interview template";
		
		else if (what == ActionsLogger.SECTION)
			whatItem = "section";
		
		else if (what == ActionsLogger.PERFORMANCE)
			whatItem = "interview performance";
		
		else if (what == ActionsLogger.PATIENT)
			whatItem = "patient";
		
		else if (what == ActionsLogger.SAMPLE)
			whatItem = "sample";
		else
			whatItem = "undefined item";
		
		
		if (action == ActionsLogger.CREATE)
			whatAction = "created";
		
		else if (action == ActionsLogger.UPDATE)
			whatAction = "updated";
		
		else if (action == ActionsLogger.DELETE)
			whatAction = "deleted";
		
		else if (action == ActionsLogger.QUERY)
			whatAction = "checked";
		else
			whatAction = "changed";
		
		
		Transaction tx = null;
		try {
			tx = hibSes.beginTransaction();
			
			AppUser usr = (AppUser)hibSes.get(AppUser.class, userId);
			username = usr.getUsername();
			
//			msgLog = "A $item '$itemName'($newItemId) was $action by $username";
			msgLog = "A "+whatItem+" named '"+itemName+"' ("+itemId+") was "+whatAction;
			msgLog += " by user '"+username+"'";
			
			AppDBLogger sessionLog = new AppDBLogger ();
			sessionLog.setUserId(userId);
			sessionLog.setSessionId(sessionId);
			sessionLog.setLastIp(ipAddr);
			sessionLog.setMessage(msgLog);
			if (what == ActionsLogger.INTERVIEW)
				sessionLog.setIntrvId(itemId);
			
			returningId = (Integer)hibSes.save(sessionLog);
			
			tx.commit();
			LogFile.info(msgLog);
		}
		catch (HibernateException ex) {
			if (tx != null)
				tx.rollback();
			
			LogFile.error("Fail to log item manipulation:\t");
			LogFile.error("userId="+userId+"; sessionId="+sessionId+"; item type="+
					whatItem+"; itemId="+itemId);
			LogFile.error(ex.getLocalizedMessage());
			
			StackTraceElement[] stack = ex.getStackTrace();
			LogFile.logStackTrace(stack);
			
//			hibSes.close();
			
//			hibSes = HibernateUtil.getSessionFactory().openSession();
		}
		
		return returningId;
	}
	
	
	
/**
 * This method is intended to log a custom action with a custom message (i.e. 
 * when a patient is not allowed to be seen
 * @param sessionId, the tomcat session id
 * @param ipAddr, remote ip address
 * @param userId
 * @param itemName
 * @param msg, the custom message
 * @return
 */
	public Integer customLog (String sessionId, String ipAddr, Integer userId,
														String itemName, String msgLog) {
		Transaction tx = null;
		Integer returningId = -1;
		try {
			tx = hibSes.beginTransaction();
			
			AppUser usr = (AppUser)hibSes.get(AppUser.class, userId);
			String username = usr.getUsername();
			
			AppDBLogger sessionLog = new AppDBLogger ();
			sessionLog.setUserId(userId);
			sessionLog.setSessionId(sessionId);
			sessionLog.setLastIp(ipAddr);
			sessionLog.setMessage(msgLog);
			
			returningId = (Integer)hibSes.save(sessionLog);
			
			tx.commit();
			LogFile.info(msgLog);
		}
		catch (HibernateException ex) {
			if (tx != null)
				tx.rollback();
			
			LogFile.error("Fail to log item manipulation:\t");
			LogFile.error("userId="+userId+"; sessionId="+sessionId+"; item name="+
									itemName);
			LogFile.error(ex.getLocalizedMessage());
			
			StackTraceElement[] stack = ex.getStackTrace();
			LogFile.logStackTrace(stack);
			
//			hibSes.close();
//			hibSes = HibernateUtil.getSessionFactory().openSession();
		}
		
		return returningId;
	}
	
	
}
