package org.cnio.appform.util;

import static org.hibernate.criterion.Restrictions.*;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;
import org.apache.commons.lang.*;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.FileNotFoundException;

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
import org.cnio.appform.audit.ActionsLogger;

/**
 * This class contains methods to control the user properties
 * 
 * @author willy
 * 
 */
public class IntrvFormCtrl {

  private Session hibSes;

  private String errMsg;

  public static final String DEFAULT_PRJ = "157";

  // This is the patient code used for previewing
  public static final String NULL_PATIENT = "15700000000";

  // This is the patient code used for testing, it won't be included on queries
  public static final String TEST_PATIENT = "15769696969";

  public static final String JUSTIFICATION_NAME = "frmJustify";
  
  public static final String MISSING_ANSWER = "9999";

// This static method is to synchronize the access to methods in this class by
// several threads. 
// Its only purpose by 30.08.2010 is to avoid concurrent access when checking for
// an answer existence and, in such a way, duplicated answers in DB for a single
// question
// The lock will be used in savform.jsp
  public final static Object THE_LOCK = new Object ();
  
  private Properties sessionVars = null;

  public IntrvFormCtrl(Session aSession) {
    hibSes = aSession;
    errMsg = "";
/*
    try {
      sessionVars = new Properties();
      sessionVars.load(new FileInputStream("sessionvars.props"));
    }
    catch (FileNotFoundException ex) {
      System.out.println("File sessionvars.props was not found");
    }
    catch (IOException ioex) {
      System.out.println("Error:");
      ioex.printStackTrace();
    }
*/
  }

  /**
   * Create a new performance Inserts a new row in the performance table for the
   * new patient who is gonna be interviewed by one user (it means, belonging to
   * a GROUP). A performance has to be saved when: - the user can access the
   * patient => the patient is new OR - the patient is NULL_PATIENT and the
   * performance is new for this user's group
   * 
   * It doesent have to be saved when: - is used in a performance by one of the
   * user's partners (himself included)
   * 
   * @param userId
   *          , the user id, who is gonna perform the interview
   * @param intrvId
   *          , the interview id
   * @param patCode
   *          , the full patient code which is gonna be saved. it will be the
   *          patient identifier
   * @return
   */
  public Performance savePerformance(Integer userId, String sessId,
      String lastIp, Integer intrvId, String patCode, String place) {
    Transaction tx = null;

    Patient patient = this.getPatientFromCode(patCode);
    Performance perf;
    boolean patientAllowed;
    ActionsLogger logDb = new ActionsLogger(hibSes);
    String prjCod, hospCod, typeCod, patCod;

    try {
      // tx = hibSes.beginTransaction();
      Interview intrv = (Interview) hibSes.get(Interview.class, intrvId);
      AppUser usr = (AppUser) hibSes.get(AppUser.class, userId);
      // tx.commit();

      if (patient != null) { // patient exists
      // we have to see if the patient belongs to this user's group
        patientAllowed = this.isPatientCodeAllowed(patient, userId);

        if (!patientAllowed) {
          errMsg = "Duplicate patient (" + patient.getCodpatient() + ")";
          errMsg += ". Please choose another code for the patient";

          logDb.customLog(sessId, lastIp, userId, patCode, errMsg);
          return null;
        }
        else { // we gotta see whether or not this patient has a performance
               // with
          // the interview represented by intrvId
          perf = this.getPerformance(patCode, intrvId, userId, sessId, lastIp);
          if (perf != null) {
            // tx.commit();
            return perf;
          }
        } // patient exists and it is allowed

      }
      else { // patient is null, so we can create it and process it
        prjCod = patCode.substring(0, 3);
        hospCod = patCode.substring(3, 5);
        typeCod = patCode.substring(5, 6);
        patCod = patCode.substring(6);

        tx = hibSes.beginTransaction();

        patient = new Patient(patCode);
        patient.setCodPrj(prjCod);
        patient.setCodHosp(hospCod);
        patient.setCodCaseCtrl(typeCod);
        patient.setCodSubject(patCod);

        Integer patId = (Integer) hibSes.save(patient);
        tx.commit();

        logDb.logItem(sessId, lastIp, userId, ActionsLogger.PATIENT, patId,
            patCode, ActionsLogger.CREATE);

        String msgLog = "New patient created with code: '" + patCode + "'";
        LogFile.info(msgLog);
      } // patient =! null

      AppUserCtrl usrCtrl = new AppUserCtrl(hibSes);
      AppGroup secondaryGrp = usrCtrl.getSecondaryActiveGroup(usr);
      if (tx == null)
        tx = hibSes.beginTransaction();
      else
        tx.begin();

      if (usr == null || intrv == null || patient == null
          || secondaryGrp == null) {
        errMsg = "The requested interview performance could not be recorded.\\n";
        errMsg += "Either the group the user belongs to "
            + "or the patient code is invalid.\\n";
        errMsg += "Please, contact and report to administrator";

        LogFile.getLogger().error(errMsg);

        tx.rollback();
        return null;
      }
      else {
        perf = new Performance(usr, intrv, patient, secondaryGrp);
        perf.setPlace(place);
        perf.setLastSec(new Integer(1));
        Integer perfId = (Integer) hibSes.save(perf);

        tx.commit();

        logDb.logItem(sessId, lastIp, userId, ActionsLogger.PERFORMANCE,
            perfId, intrv.getName(), ActionsLogger.CREATE);

        String logMsg = "New performance saved for user: '" + usr.getUsername();
        logMsg += "'; patient code: '" + patient.getCodpatient();
        logMsg += "'; interview: '" + intrv.getName() + "' (" + intrvId + ")";

        logDb.customLog(sessId, lastIp, userId, intrv.getName(), logMsg);
        LogFile.info(logMsg);

        logMsg = "New performance id is " + perf.getId();
        LogFile.info(logMsg);

        return perf;
      }
    }
    catch (HibernateException ex) {
      if (tx != null)
        tx.rollback();

      errMsg = "The requested interview performance could not be recorded";
      LogFile.getLogger().error(errMsg);
      LogFile.getLogger().error(ex.getLocalizedMessage());
      StackTraceElement[] stElems = ex.getStackTrace();
      LogFile.logStackTrace(stElems);

      return null;
    }

  }

  /**
   * This method save the performance for a samples' questionnaire, which is
   * slightly different than a subject questionnaire.
   * 
   * @param userId
   *          , the user which is doing the performance
   * @param sessId
   *          , the web session id
   * @param intrvId
   *          , the id of the samples' questionnaire
   * @param lastIp
   *          , the ip of the client
   * @param samplCode
   *          , the code for the sample
   * @return the instance of the performance which has been created
   */
  public Performance savePerf4Sample(Integer userId, String sessId,
      Integer intrvId, String lastIp, String sampleCode) {

    Performance perf;
    ActionsLogger logDb = new ActionsLogger(hibSes);
    String prjCod, hospCod, sampleCod, patType;
    Transaction tx = null;
    Patient sample = this.getPatientFromCode(sampleCode);

    try {
      Interview intrv = (Interview) hibSes.get(Interview.class, intrvId);
      AppUser usr = (AppUser) hibSes.get(AppUser.class, userId);
      // tx.commit();

      if (sample != null) { // patient exists
      // we have to see if the sample belongs to this user's group
        perf = this.getPerformance(sampleCode, intrvId, userId, sessId, lastIp);
        if (perf != null) {
          // tx.commit();
          return perf;
        }
      } // sample exists and it is allowed

      else { // patient is null, so we can create it and process it
        prjCod = sampleCode.substring(0, 3);
        hospCod = sampleCode.substring(3, 5);
//        patType = sampleCode.substring (5, 6);
        sampleCod = sampleCode.substring(5);

        tx = hibSes.beginTransaction();

        sample = new Patient(sampleCode);
        sample.setCodPrj(prjCod);
        sample.setCodHosp(hospCod);
//        sample.setCodCaseCtrl(patType);
        sample.setCodSubject(sampleCod);

        Integer patId = (Integer) hibSes.save(sample);
        tx.commit();

        logDb.logItem(sessId, lastIp, userId, ActionsLogger.SAMPLE, patId,
            sampleCode, ActionsLogger.CREATE);

        String msgLog = "New sample created with code: '" + sampleCode + "'";
        LogFile.info(msgLog);
      } // sample =! null

      AppUserCtrl usrCtrl = new AppUserCtrl(hibSes);
      AppGroup secondaryGrp = usrCtrl.getSecondaryActiveGroup(usr);
      if (tx == null)
        tx = hibSes.beginTransaction();
      else
        tx.begin();

      if (usr == null || intrv == null || sample == null
          || secondaryGrp == null) {
        errMsg = "The requested interview performance could not be recorded.\\n";
        errMsg += "Either the group the user belongs to "
            + "or the sample code is invalid.\\n";
        errMsg += "Please, contact and report to administrator";

        LogFile.getLogger().error(errMsg);

        tx.rollback();
        return null;
      }
      else {
        perf = new Performance(usr, intrv, sample, secondaryGrp);
        perf.setLastSec(new Integer(1));
        Integer perfId = (Integer) hibSes.save(perf);

        tx.commit();

        logDb.logItem(sessId, lastIp, userId, ActionsLogger.PERFORMANCE,
            perfId, intrv.getName(), ActionsLogger.CREATE);

        String logMsg = "New performance saved for user: '" + usr.getUsername();
        logMsg += "'; sample code: '" + sample.getCodpatient();
        logMsg += "'; interview: '" + intrv.getName() + "' (" + intrvId + ")";

        logDb.customLog(sessId, lastIp, userId, intrv.getName(), logMsg);
        LogFile.info(logMsg);

        logMsg = "New performance id is " + perf.getId();
        LogFile.info(logMsg);

        return perf;
      }
    }
    catch (HibernateException ex) {
      if (tx != null)
        tx.rollback();

      errMsg = "The requested interview performance could not be recorded";
      LogFile.getLogger().error(errMsg);
      LogFile.getLogger().error(ex.getLocalizedMessage());
      StackTraceElement[] stElems = ex.getStackTrace();
      LogFile.logStackTrace(stElems);

      return null;
    }

  }

  /**
   * Gets a row of the Performance table based mostly on codPat and usrId. If
   * the interview was performed by another user in the same group than the
   * current user. In the case of the user has 'admin' role, the interview has
   * to be displayed The modified data has to be saved related to a right user
   * 
   * @param codPat
   *          , the code of the patient (not the patient id!!!!)
   * @param intrvId
   *          , the id of the interview
   * @param usrId
   *          , the id of the user who is gonna do the interview
   * @return
   */
  public Performance getPerformance(String codPat, Integer intrvId,
      Integer usrId, String jspSess, String lastIp) {

    AppGroup grp = null;
    /*
     * String hqlStrQry = "from Performance p where p.appuser in (:users) and "+
     * "p.patient=:patient and p.interview=:intrv";
     */
    String hqlStrQry = "from Performance p where p.group=:grp and "
        + "p.patient=:patient and p.interview=:intrv";
    String hqlQryAdm = "from Performance p where p.patient=:patient "
        + "and p.interview=:intrv";

    Transaction tx = null;
    try {
      AppUser user = (AppUser) hibSes.get(AppUser.class, usrId);

      // tx.commit();
      // No transaction here because it is inside getUserPartners
      AppUserCtrl usrCtrl = new AppUserCtrl(hibSes);
      // userGrp = usrCtrl.getUserPartners(user, HibernateUtil.HOSP_GROUPTYPE);
      if (!user.isAdmin())
        grp = usrCtrl.getSecondaryActiveGroup(user);

      // tx.begin();
      Interview intrv = (Interview) hibSes.get(Interview.class, intrvId);

      tx = hibSes.beginTransaction();
      String qry = "from Patient p where p.codpatient='" + codPat + "'";
      Query hqlQry = hibSes.createQuery(qry);
      Patient pat = (Patient) hqlQry.uniqueResult();

      if (pat == null)
        return null;
      /*
       * String sqlQry =
       * "select idperformance from performance where codpat = "+ pat.getId()+
       * " and coduser in ("; Iterator<AppUser> itUsr = userGrp.iterator();
       * while (itUsr.hasNext()) { sqlQry += itUsr.next().getId()+","; } sqlQry
       * = sqlQry.substring(0, sqlQry.length()-1)+")";
       */
      // hqlQry = hibSes.createSQLQuery(sqlQry);
      if (user.isAdmin())
        hqlQry = hibSes.createQuery(hqlQryAdm);

      else { // an user with not admin role
        hqlQry = hibSes.createQuery(hqlStrQry);
        // hqlQry.setParameterList("users", userGrp);
        hqlQry.setEntity("grp", grp);
      }

      hqlQry.setEntity("patient", pat);
      hqlQry.setEntity("intrv", intrv);

      // perfList = hqlQry.list();

      // List<Integer>idsPerf = hqlQry.list();
      List<Performance> idsPerf = hqlQry.list();
      Performance perf = null;
      if (idsPerf != null && idsPerf.size() > 0)
        // perf = (Performance)hibSes.get(Performance.class, idsPerf.get(0));
        perf = idsPerf.get(0);

      tx.commit();

      if (perf != null) {
        String msgLog = "User '" + user.getUsername()
            + "': Resuming interview '" + intrv.getName() + "' ("
            + intrv.getId();
        msgLog += ") for patient '" + pat.getCodpatient() + "'";

        if (!jspSess.equalsIgnoreCase("")) {
          ActionsLogger logDb = new ActionsLogger(hibSes);

          logDb.customLog(jspSess, lastIp, usrId, intrv.getName(), msgLog);
          LogFile.info(msgLog);
        }
      }

      return perf;
    }
    catch (RuntimeException ex) {
      ex.printStackTrace();

      LogFile.getLogger().error(ex.getLocalizedMessage());
      StackTraceElement[] stack = ex.getStackTrace();
      LogFile.logStackTrace(stack);
    }
    return null;
  }

  public PerfUserHistory getPerformanceFromIntrv(Integer patid, Integer intrvid) {
    Transaction tx = null;
    String hql = "select ph from PerfUserHistory ph join ph.performance p where ";
    hql = hql
        + " p.interview=:intrv and p.patient=:pat order by ph.idhistory desc";
    Interview intrv = null;
    Patient pat = null;
    try {
      tx = this.hibSes.beginTransaction();
      intrv = (Interview) this.hibSes.get(Interview.class, intrvid);
      pat = (Patient) this.hibSes.get(Patient.class, patid);

      Query qry = this.hibSes.createQuery(hql);
      qry.setEntity("intrv", intrv);
      qry.setEntity("pat", pat);

      List lph = qry.list();
      tx.commit();

      return ((PerfUserHistory) lph.get(0));
    }
    catch (HibernateException hibEx) {
      if (tx != null) {
        tx.rollback();
      }
      String msgLog = "Unable to retrieve performance history for interview '";
      msgLog = msgLog + ((intrv != null) ? intrv.getName() : "");
      msgLog = msgLog + "' and patient with database id ";
      msgLog = msgLog + ((pat != null) ? pat.getId() : "");
      LogFile.error(msgLog);
      LogFile.error(hibEx.getLocalizedMessage());
      StackTraceElement[] stack = hibEx.getStackTrace();
      LogFile.logStackTrace(stack);
    }
    return null;
  }

  public boolean justifyShortPerf(PerfUserHistory puh, String txt) {
    Transaction tx = null;
    if (puh == null)
      return false;
    try {
      tx = this.hibSes.beginTransaction();

      puh.setJustification(txt);
      tx.commit();

      return true;
    }
    catch (HibernateException hibEx) {
      try {
        if ((tx != null) && (tx.isActive())) {
          tx.rollback();
        }
        this.errMsg = "Could not set the justification for the interview with performance'"
            + puh.getPerformance().getId() + "'";

        LogFile.getLogger().error(this.errMsg);
        LogFile.getLogger().error(hibEx.getLocalizedMessage());
        StackTraceElement[] stElems = hibEx.getStackTrace();
        LogFile.logStackTrace(stElems);
      }
      catch (RuntimeException rbEx) {
        this.errMsg = "Could not set the justification for the interview with performance'"
            + puh.getPerformance().getId() + "'";

        LogFile.getLogger().error(this.errMsg);
        LogFile.getLogger().error(hibEx.getLocalizedMessage());
        StackTraceElement[] stElems = hibEx.getStackTrace();
        LogFile.logStackTrace(stElems);

        return false;
      }
    }
    return false;
  }

  public PerfUserHistory getLastJustification(Integer patId, Integer intrvId) {
    String hql = "select ph from PerfUserHistory ph join ph.performance p where ph.justification is not null and";

    hql = hql
        + " p.interview=:intrv and p.patient=:pat order by ph.timeStamp desc";

    Transaction tx = null;
    List puhList = null;
    try {
      tx = this.hibSes.beginTransaction();
      Patient pat = (Patient) this.hibSes.get(Patient.class, patId);
      Interview intrv = (Interview) this.hibSes.get(Interview.class, intrvId);
      Query qry = this.hibSes.createQuery(hql);
      qry.setEntity("pat", pat);
      qry.setEntity("intrv", intrv);
      puhList = qry.list();
      tx.commit();
      System.out.println(("puhList: " + puhList == null) ? " null" : Integer
          .valueOf(puhList.size()));

      if ((puhList != null) && (puhList.size() > 0))
        return ((PerfUserHistory) puhList.get(0));
    }
    catch (HibernateException hibEx) {
      try {
        if ((tx != null) && (tx.isActive())) {
          tx.rollback();
        }
        this.errMsg = "Could not set the justification for the interview '"
            + intrvId + "' and subject '" + patId + "'";

        LogFile.getLogger().error(this.errMsg);
        LogFile.getLogger().error(hibEx.getLocalizedMessage());
        StackTraceElement[] stElems = hibEx.getStackTrace();
        LogFile.logStackTrace(stElems);
      }
      catch (RuntimeException rbEx) {
        this.errMsg = "Could not set the justification for the interview '"
            + intrvId + "' and subject '" + patId + "'";

        LogFile.getLogger().error(this.errMsg);
        LogFile.getLogger().error(hibEx.getLocalizedMessage());
        StackTraceElement[] stElems = hibEx.getStackTrace();
        LogFile.logStackTrace(stElems);

        return null;
      }
    }
    return null;
  }

  /**
   * Insert a new entry in the history of users doing this performance
   * 
   * @param user
   *          , the user (interviewer) doing the performance
   * @param perf
   *          , the performance in about to start
   * @return true on successfully completion; false otherwise
   */
  public boolean setCurrentPerfUser(AppUser user, Performance perf) {
    Transaction tx = null;
    System.out.println("setCurretnPerfUser: user: " + user.getUsername());
    try {
      tx = hibSes.beginTransaction();

      PerfUserHistory puh = new PerfUserHistory(user, perf);
      puh.setTimeStamp(new java.util.Date());

      hibSes.save(puh);
      tx.commit();

      return true;
    }
    catch (HibernateException hibEx) {
      try {
        if (tx.isActive())
          tx.rollback();

        hibEx.printStackTrace();
      }
      catch (RuntimeException rbEx) {
        return false;
      }

      return false;
    }
  }

  /**
   * Gets a row of the Performance table based mostly on codPat and usrId
   * 
   * @param codPat
   *          , the code of the patient (not the patient id!!!!)
   * @param intrvId
   *          , the id of the interview
   * @param usrId
   *          , the id of the user who is gonna do the interview
   * @param lastSec
   *          , the order of the last section completed
   * @return
   */
  public boolean setLastSec(String codPat, Integer intrvId, Integer usrId,
      int lastSec) {
    // Session theSes = HibernateUtil.getSessionFactory().getCurrentSession();
    Performance perf = getPerformance(codPat, intrvId, usrId, "", "");

    Transaction tx = null;
    try {
      tx = hibSes.beginTransaction();

      perf.setLastSec(new Integer(lastSec));
      // hibSes.save(perf);

      tx.commit();
    }
    catch (RuntimeException ex) {
      try {
        if (tx.isActive())
          tx.rollback();
      }
      catch (RuntimeException rbEx) {
        // it would has to log something
        // theSes.close();
        return false;
      }
      // throw ex;
      return false;
    }
    finally {
      // theSes.close();
    }
    return true;
  }

  
  
  
/**
 * Wrapper for the main method to save an answer. Objects for question, patient
 * and answer item where replaced by their ids. The method gets the entity objects
 * and call the saveAnswer method with those values
 * @param qId, the question identifier
 * @param patId, the patien identifier
 * @param ansNumber, the answer number
 * @param ansOrder, the answer order
 * @param ansGroup
 * @param ansVal, the answer value
 * @param answerItId, the answer item identifier
 * @return
 */  
  public boolean saveAnswer (Integer qId, Integer patId, Integer ansNumber, Integer ansOrder,
  												Integer ansGroup, String ansVal, Integer answerItId) {
  	
  	Question q = (Question)hibSes.get(Question.class, qId.longValue());
  	Patient pat = (Patient)hibSes.get(Patient.class, patId);
  	AnswerItem ait = (AnswerItem)hibSes.get(AnswerItem.class, answerItId.longValue());
  	
  	boolean res;
  	res = saveAnswer (q, pat, ansNumber, ansOrder, ansGroup, ansVal, ait);
  	
  	return res;
  }
  												
  
  
  
  /**
   * Saves the answer to the question and inserts a row in the ternary
   * relationship to connect answer to question to patient
   * 
   * @param qId, the question id
   * @param ansNumber, the number of answer
   * @param ansOrder, the order of the answer
   * @param ansVal, the value of the answer
   * @param patId, the patient id
   * @param ait, the answer item corresponding to this answer
   * @return
   */
  public boolean saveAnswer(Question q, Patient pat, Integer ansNumber,
      Integer ansOrder, Integer ansGroup, String ansVal, AnswerItem ait) {
    // Session theSes = HibernateUtil.getSessionFactory().getCurrentSession();
    Transaction tx = null;
    try {
      tx = hibSes.beginTransaction();

      Answer newAns = new Answer(ansVal);
      newAns.setAnswerOrder(ansOrder);
      newAns.setAnswerItem(ait);
//      hibSes.save(newAns);

      PatGivesAns2Ques row = new PatGivesAns2Ques(q, newAns, pat);
      row.setAnswerNumber(ansNumber);
      row.setAnswerOrder(ansOrder);
      if (ansGroup != null)
        row.setAnswerGrp(ansGroup);

      hibSes.save(row);
/*
System.out.println ("(tid: "+Thread.currentThread().getId()+") ** IntrvFormCtrl.saveAnswer: "+ansVal+" ("+q.getId()+"); n: "+ansNumber+"; o: "+ansOrder);
for (StackTraceElement ste: Thread.currentThread().getStackTrace())
	System.out.println("-- "+ste.toString());
*/
      tx.commit();
    }
    catch (RuntimeException ex) {
      try {
        if (tx.isActive())
          tx.rollback();

        ex.printStackTrace();
      }
      catch (RuntimeException rbEx) {
        // it would has to log something
        // theSes.close();
        return false;
      }
      // throw ex;
    }
    finally {
      // theSes.close();
    }
    return true;
  }

  
  
  /**
   * Update the value of an answer from the answer id
   * 
   * @param ansId
   *          , the answer id to get the answer
   * @param newValue
   *          , the newvalue for the answer
   * @return
   */
  public boolean updateAnswer(Integer ansId, String newValue) {
    Transaction tx = null;
    try {
      tx = hibSes.beginTransaction();
      Answer theAns = (Answer) hibSes.get(Answer.class, ansId);
      theAns.setValue(newValue);

      tx.commit();
    }
    catch (HibernateException ex) {
      try {
        if (tx != null)
          tx.rollback();

        ex.printStackTrace();
      }
      catch (RuntimeException rbEx) {
        // it would has to log something
        // theSes.close();

        return false;
      }
      // throw ex;
    }
    finally {
      // theSes.close();
    }
    return true;
  }
  
  
  

  /**
   * Gets a Patient entity from the code assigned on interview time
   * 
   * @param patientCode
   *          , the code of the patient when assigned
   * @return a patient entity object
   */
  public Patient getPatientFromCode(String patientCode) {
    // Session theSes = HibernateUtil.getSessionFactory().getCurrentSession();
    Transaction tx = null;
    try {
      tx = hibSes.beginTransaction();
      String qry = "from Patient p where p.codpatient='" + patientCode + "'";

      Query hqlQry = hibSes.createQuery(qry);
      Patient pat = (Patient) hqlQry.uniqueResult();
      tx.commit();

      return pat;
    }
    catch (RuntimeException ex) {
      if (tx != null)
        tx.rollback();

      // ex.printStackTrace();
      errMsg = "Could not retrieve patient from patient code";
      LogFile.getLogger().error(errMsg);
      LogFile.getLogger().error(ex.getLocalizedMessage());
      StackTraceElement[] stElems = ex.getStackTrace();
      LogFile.logStackTrace(stElems);
    }
    return null;
  }

  
  
  
  /**
   * Remove records from entity classes PatGivesAnswer2Ques and Answer from the
   * ids parameter got from client.
   * 
   * @param paramIds
   *          , the list of ids for the questions whose answers have to be
   *          removed They looks like QQQQQ1-N1-O1,...,QQQQQn-Nn-On
   * @param patId
   *          , the patient identifier who the interviews is being performed for
   * @return true on successfully completion; false otherwise. The items on
   *         database were removed
   */
  public boolean removeAnswers(String paramIds, Integer patId) {
    boolean res = false;
    Transaction tx = null;
    String[] ids = paramIds.split(",");
    String qryPga = "from PatGivesAns2Ques pga where patient=:pat "
        + "and question=:ques " + "and answerNumber=:num "
        + "and answerOrder=:ord";

    try {
      tx = hibSes.beginTransaction();
      Patient pat = (Patient) hibSes.get(Patient.class, patId);
      Query qry = hibSes.createQuery(qryPga);
//      PatGivesAns2Ques pga = null;
      List<PatGivesAns2Ques> pgaList;

      // loop over ids to remove them one by one, questions and pga items
      for (String id : ids) {
        String[] partId = id.split("-");
        Question q = (Question) hibSes.get(Question.class, Long
            .decode(partId[0]));

        qry.setEntity("pat", pat);
        qry.setEntity("ques", q);
        qry.setInteger("num", Integer.decode(partId[1]));
        qry.setInteger("ord", Integer.decode(partId[2]));

//        pga = (PatGivesAns2Ques) qry.uniqueResult();
        
// Usually, it should be just one answer per question, number, order
// But, as sometimes there are more than one answer, a list has to be retrieved
        pgaList = qry.list();
        for (PatGivesAns2Ques pga: pgaList) {
        	Answer ans = pga.getAnswer();
        	String ansVal = ans.getValue();
        	Integer ansId = ans.getId();
          if (ans != null)
            hibSes.delete(ans);

          if (pgaList.indexOf(pga) == pgaList.size()-1) {
          	hibSes.delete(pga);
          	errMsg = "Deleted entry for question "+q.getId()+" and subject "+patId;
          	LogFile.getLogger().info(errMsg);
          }
          errMsg = "Answer: '"+ansVal+"' ("+ansId+") was deleted for patient with id "+patId;
          LogFile.getLogger().info(errMsg);
        }
        
/*
        if (pga != null) {
          Answer ans = pga.getAnswer();
          if (ans != null)
            hibSes.delete(ans);

          hibSes.delete(pga);
        }
*/
      }
      tx.commit();

      res = true;
    }
    catch (HibernateException hibEx) {
      if (tx != null)
        tx.rollback();

      errMsg = "Could not remove all requested answers";
      LogFile.getLogger().error(errMsg);
      LogFile.getLogger().error(hibEx.getLocalizedMessage());
      StackTraceElement[] stElems = hibEx.getStackTrace();
      LogFile.logStackTrace(stElems);
    }
    return res;
  }

  
  
  /**
   * This method sees if the patient is allowed to be used by this group of
   * users. This is to avoid the same code is used in two different interviews
   * done by different users from different groups. The only exception is with
   * the NULL_PATIENT, which is allowed to be used by everyone
   * 
   * @param pat
   *          , the patient
   * @param usrId
   *          , the id of the user who is developing the interview
   * @return true if the code for the patient is allowed to be used; otherwise
   *         it returns false
   */
  public boolean isPatientCodeAllowed(Patient pat, Integer usrId) {

    if (pat.getCodpatient().equals(TEST_PATIENT))
      return true;

    AppUserCtrl usrCtrl = new AppUserCtrl(hibSes);
    /*
     * List<AppUser> groupUsrs =
     * usrCtrl.getUserPartners((AppUser)hibSes.get(AppUser.class, usrId),
     * HibernateUtil.HOSP_GROUPTYPE); String hql =
     * "from Performance where appuser in (:users) and patient=:pat";
     */
    AppGroup grp = usrCtrl.getSecondaryActiveGroup((AppUser) hibSes.get(
        AppUser.class, usrId));

    String hqlStr = "from Performance where group=:grp and patient=:pat";

    Transaction tx = null;
    try {
      tx = hibSes.beginTransaction();
      /*
       * Query qry = hibSes.createQuery(hql); qry.setEntity("pat", pat);
       * qry.setParameterList("users", groupUsrs);
       */
      Query qry = hibSes.createQuery(hqlStr);
      qry.setEntity("grp", grp);
      qry.setEntity("pat", pat);
      List<Performance> lPerf = qry.list();
      tx.commit();

      // if the list is empty, the patient exists, has a performance but it was
      // not
      // developed by usrId or partners. so the code is not suitable for this
      // user
      if (lPerf == null || lPerf.isEmpty())
        return false;
      else
        // the patient has previous performances with usrId
        return true;

    }
    catch (HibernateException ex) {
      if (tx != null && tx.isActive())
        tx.rollback();

      errMsg = "Error while trying to check patient code allowed";
      LogFile.getLogger().error(errMsg);
      LogFile.getLogger().error(ex.getLocalizedMessage());
      StackTraceElement[] stElems = ex.getStackTrace();
      LogFile.logStackTrace(stElems);

      return false;
    }
  }
  
  

  /*
   * This method check whether or not a patient code is allowed to be used by
   * the user represented by usrId. The patient is allowed if there is a
   * performance for this patient and the usrId belongs to the group which made
   * the performance to the patient. This method gets involved when an
   * interviewer puts a patient code to start/ continue an interview
   * 
   * @param pat, the patient
   * 
   * @param usrId, the id of the user
   * 
   * @return the performance which was performed to the patient or null if the
   * patient doesnt have interview for this user, which implies the patient is
   * not allowed for the user represented by usrId
   * 
   * public Performance isPatientCodeAllowed (Patient pat, Integer usrId) {
   * 
   * AppUserCtrl usrCtrl = new AppUserCtrl (hibSes); List<AppUser> groupUsrs =
   * usrCtrl.getUserPartners((AppUser)hibSes.get(AppUser.class, usrId),
   * HibernateUtil.HOSP_GROUPTYPE);
   * 
   * String hql = "from Performance where appuser in (:users) and patient=:pat";
   * Transaction tx = null; try { tx = hibSes.beginTransaction(); Query qry =
   * hibSes.createQuery(hql); qry.setEntity("pat", pat);
   * qry.setParameterList("users", groupUsrs);
   * 
   * List<Performance> lPerf = qry.list(); tx.commit();
   * 
   * // if the list is empty, the patient exists, has a performance but it was
   * not // developed by usrId or partners. so the code is not suitable for this
   * user if (lPerf == null || lPerf.isEmpty()) return null; else // the patient
   * has previous performances with usrId return lPerf.get(0);
   * 
   * } catch (HibernateException ex) { if (tx != null && tx.isActive())
   * tx.rollback();
   * 
   * return null; } }
   */

  /*
   * String hql =
   * "select a.idanswer, a.thevalue, pga.answer_number, pga.answer_order," +
   * "a.answer_order from Answer a, AnswerItem ai, PatGivesAns2Ques pga" +
   * "where a.codansitem = ai.idansitem and pga.codanswer = a.idanswer" +
   * " and pga.codquestion = 51 and pga.codpat = 750	order by 4, 5;";
   */
  
  
  
  
  
  /**
   * Gets the answers for a question made to a patient. Returns a list of an
   * an object array, where every element in the list is an answer (with value,
   * order, number,...). It is a list as there can be questions with multiple
   * answers (i.e. day, mn, yr, which would be a list of three elements)
   * 
   * @param Long
   *          qId, the question id
   * @param Integer
   *          patId, the patient id (this is the database id, not the patient
   *          code)
   * @param int numAns, the num of answer when there are several answers for a
   *        question (repeatable questions)
   * @return a list of array of Object with:<br>
   *         the answer id (Integer) the answer value (String) the answer number
   *         (Integer) the answer order (Integer) the answer order from answer
   *         table (Integer) the answer item id which this answer belong to the
   *         answer item name
   */
  // public List<Object[]> getAnswers (Question q, Integer patId, int numAns) {
  public List<Object[]> getAnswers(Long qId, Integer patId, int numAns) {

    // Session hibSes = HibernateUtil.getSessionFactory().getCurrentSession();
    Transaction tx = null;

    try {
      String strQry = "select a.idanswer, a.thevalue, pga.answer_number, pga.answer_order,"
          + " a.answer_order, ai.idansitem, ai.name "
          + "from answer a, answer_item ai, PAT_GIVES_ANSWER2QUES pga"
          + " where a.codansitem = ai.idansitem and pga.codanswer = a.idanswer"
          + " and pga.codquestion = " + qId + " and pga.codpat = " + patId
          + " and pga.answer_number = " + numAns + "  order by 4, 5;";
  /*
   * String hql =
   * "select a.idanswer, a.thevalue, pga.answer_number, pga.answer_order," +
   * "a.answer_order from Answer a, AnswerItem ai, PatGivesAns2Ques pga" +
   * "where a.answerItem = ai and pga.answer = a" +
   * " and pga.question = :ques and pga.codpat = "+patId+
   * "	order by pga.answer_number asc, a.answer_order asc";
   * 
   * tx = hibSes.beginTransaction(); Query sql = hibSes.createQuery(hql);
   * sql.setEntity("ques", q);
   */
      tx = hibSes.beginTransaction();
      SQLQuery sql = hibSes.createSQLQuery(strQry);
      List<Object[]> l = sql.list();
      /*
       * if (l == null || l.size() == 0) { Object[] res = {null, "", 1, 1, 1,
       * null, ""}; if (l == null) { l = new ArrayList<Object[]>(); l.add(res);
       * } else // size is 0 l.add(res); }
       */
      tx.commit();

      return l;
    }
    catch (HibernateException ex) {
      if (tx != null)
        if (tx.isActive())
          tx.rollback();

      errMsg = "Could not retrieve answers for question with id: " + qId;
      LogFile.getLogger().error(errMsg);
      LogFile.getLogger().error(ex.getLocalizedMessage());
      StackTraceElement[] stElems = ex.getStackTrace();
      LogFile.logStackTrace(stElems);
    }

    return null;
  }
  
  

  /**
   * Return the number of answers for a, usually repeatable, question
   * 
   * @param q
   *          , the question
   * @param pat
   *          , the patient who the question was answered for
   * @return the number of different answers
   */
  public int getNumOfAnswers(Question q, Integer patId) {
    String hql = "select count(distinct answer_number) "
        + "from PatGivesAns2Ques where question = :q and patient=:p";

    Transaction tx = null;
    try {
      tx = hibSes.beginTransaction();

      Patient pat = (Patient) hibSes.get(Patient.class, patId);
      Query qry = hibSes.createQuery(hql);
      qry.setEntity("q", q);
      qry.setEntity("p", pat);

      Long answerNum = (Long) qry.uniqueResult();

      return answerNum.intValue();

    }
    catch (HibernateException ex) {
      if (tx != null)
        if (tx.isActive())
          tx.rollback();

      errMsg = "Could not retrieve number of questions for question with id: "
          + q.getId();
      LogFile.getLogger().error(errMsg);
      LogFile.getLogger().error(ex.getLocalizedMessage());
      StackTraceElement[] stElems = ex.getStackTrace();
      LogFile.logStackTrace(stElems);
    }

    return -1;
  }

  /**
   * Gets the answer as a Object[], where every position in the array is a
   * Answer property, based on the response of a patient to a question in a
   * number of answer (in the case of repetitivity) and order of answer (for
   * questions with several answer values). The array elements are like [207, 1,
   * 1, 551] or, in general, [idAnswer, thevalue, answer_order, cod_ansitem}
   * 
   * @param idQues
   *          , the id of the question
   * @param idPat
   *          , the id of the patient
   * @param ansNum
   *          , number of answer (repetitivity)
   * @param ansOrd
   *          , the order of the answer
   * @param ansGroup
   *          , the group of the answer (GOTTA BE ADDED!!!!!!!!!!!?)
   *          
   * @return, return a array of objects which are the fields in the Answer class
   */
  public Object[] getAnswer4Question(Integer idQues, Integer idPat,
      Integer ansNum, Integer ansOrd) {
    Transaction tx = null;
    String strQry = null;

    try {
      strQry = "select a.*	from pat_gives_answer2ques pga, answer a "
          + "where pga.codquestion=" + idQues + " and pga.answer_number = "
          + ansNum + " and " + "pga.answer_order = " + ansOrd
          + " and pga.codpat=" + idPat + " and "
          + "pga.codanswer = a.idanswer	"
          + "order by pga.answer_number, pga.answer_order, pga.answer_grp;";

      String hqlQry = "from Answer a join a.patAnsQues paq where"
          + " paq.answerNumber =" + ansNum + " and paq.answerOrder=" + ansOrd
          + " and paq.question.id=" + idQues + " and paq.patient.id=" + idPat
          + " order by pqa.answerNumber, pqa.answerOrder, pga.answerGrp";

      tx = hibSes.beginTransaction();
      SQLQuery sql = hibSes.createSQLQuery(strQry);
      // Object[] ans = (Object[])sql.uniqueResult();
// System.out.println ("(tid: "+Thread.currentThread().getId()+") - IntrvFormCtrl.getAnswer4Question ("+idQues+","+idPat+","+ansNum+","+ansOrd+")");      
      List<Object[]> anses = sql.list();

      // Query qry = hibSes.createQuery(hqlQry);
      // Answer ans = (Answer)qry.uniqueResult();
      tx.commit();

      if (anses != null && anses.size() > 0) {
// System.out.println ("(tid: "+Thread.currentThread().getId()+") IntrvFormCtrl.getAnswer4Question: ansId"+anses.get(0)[0]);
        return anses.get(0);
      }
    }
    catch (HibernateException ex) {
      if (tx != null)
        if (tx.isActive())
          tx.rollback();

      System.out.println("***** QUERY *****\n" + strQry);
      ex.printStackTrace(System.out);
      errMsg = "Could not get answer for question...";
      LogFile.getLogger().error(errMsg);
      LogFile.getLogger().error(ex.getLocalizedMessage());
      StackTraceElement[] stElems = ex.getStackTrace();
      LogFile.logStackTrace(stElems);
    }
    return null;
  }

  /**
   * Retrieves the error message for some error yielded during running
   * 
   * @return
   */
  public String getErrMsg() {
    return errMsg;
  }

  
  
 /* OjO con este method
  protected void finalize() {
    if (hibSes != null) {
      if (hibSes.isOpen())
        hibSes.close();
    }
  }
*/
}