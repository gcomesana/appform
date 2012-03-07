package org.cnio.appform.util;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import org.apache.log4j.Logger;
import org.cnio.appform.entity.AppDBLogger;
import org.cnio.appform.entity.AppGroup;
import org.cnio.appform.entity.AppUser;
import org.cnio.appform.entity.AppuserRole;
import org.cnio.appform.entity.GroupType;
import org.cnio.appform.entity.Project;
import org.cnio.appform.entity.RelGrpAppuser;
import org.cnio.appform.entity.RelPrjAppusers;
import org.cnio.appform.entity.Role;
import org.hibernate.Criteria;
import org.hibernate.HibernateException;
import org.hibernate.NonUniqueResultException;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.criterion.Restrictions;



/**
 * This class holds useful and convenient business methods to deal with generic and 
 * subject issues along the application.
 * @author bioinfo
 *
 */
public class AppUserCtrl {
  public static final Integer COD_ADMROLE = Integer.valueOf(50);

  public static final Integer COD_HOSPITAL_INI_ES = Integer.valueOf(1);
  public static final Integer COD_HOSPITAL_END_ES = Integer.valueOf(19);

  public static final Integer COD_HOSPITAL_INI_EN = Integer.valueOf(20);
  public static final Integer COD_HOSPITAL_END_EN = Integer.valueOf(29);

  public static final Integer COD_HOSPITAL_INI_IT = Integer.valueOf(30);
  public static final Integer COD_HOSPITAL_END_IT = Integer.valueOf(39);

  public static final Integer COD_HOSPITAL_INI_AT = Integer.valueOf(40);
  public static final Integer COD_HOSPITAL_END_AT = Integer.valueOf(49);

  public static final Integer COD_HOSPITAL_INI_DE = Integer.valueOf(50);
  public static final Integer COD_HOSPITAL_END_DE = Integer.valueOf(59);

  public static final Integer COD_HOSPITAL_INI_SE = Integer.valueOf(60);
  public static final Integer COD_HOSPITAL_END_SE = Integer.valueOf(69);

  public static final Integer COD_HOSPITAL_INI_IE = Integer.valueOf(70);
  public static final Integer COD_HOSPITAL_END_IE = Integer.valueOf(89);
  public static final int LOGIN_SUCCESS = 0;
  public static final int LOGIN_FAIL = 1;
  public static final int LOGIN_CONCURRENT = 2;
  public static final int LOGIN_USER_WRONG = 3;
  public static final int LOGIN_MISMATCH_PASSWD = 4;
  public static final int LOGIN_EXCEED_ATTEMPTS = 5;
  public static final int MAX_LOGIN_ATTEMPTS = 5;
  public static final String ADMIN_ROLE = "ADMIN";
  public static final String EDITOR_ROLE = "EDITOR";
  public static final String INTRVR_ROLE = "INTERVIEWER";
  public static final String GUEST_ROLE = "GUEST";
  public static final String DATAMGR_ROLE = "DATA MANAGER";
  public static final String CURATOR_ROLE = "CURATOR";
  public static final String PRJ_MNGR_ROLE = "PROJECT COORDINATOR";
  public static final String NODE_MNG_ROLE = "NODE COORDINATOR";
  public static final String COUNTRY_MNGR_ROLE = "COUNTRY COORDINATOR";
  public static final String HOSP_MNGR_ROLE = "HOSPITAL COORDINATOR";
  public static final int ROLE_ADM = 0;
  public static final int ROLE_EDI = 1;
  public static final int ROLE_INT = 3;
  public static final int ROLE_INV = 2;
  public static final int ROLE_DMG = 6;
  public static final int ROLE_CUR = 7;
  public static final int ROLE_DUM1 = 5;
  public static final int ROLE_DUM2 = 4;
  public static final int ACTION_C = 0;
  public static final int ACTION_R = 1;
  public static final int ACTION_U = 3;
  public static final int ACTION_D = 2;
  public static final String ADM_MAIL = "gcomesana@cnio.es";
  
  private Session theSess;

  
  
  public AppUserCtrl(Session aSession)
  {
    this.theSess = aSession;
  }
  
  
  
/**
 * Check the permissions to do an action on any project by the roles in rolenames
 * @param rolenames, a comma-separated list of roles
 * @param action, the action to perform. it can be one of the CRUD actions
 * @return true if there is a role in rolenames able to do the action; false otherwise
 */
  public static boolean projectPermissions(String rolenames, int action)  {
    String[] roles = rolenames.split(",");
    boolean granted = false;

    String[] arr$ = roles; int len$ = arr$.length; int i$ = 0; if (i$ < len$) { String rolename = arr$[i$];
      int role = role2Code(rolename);

      if (role == 0) {
        granted = true;
      }
      else if (action == 1) {
        granted = true;
      }
      else
      {
        return false; }
    }
    return granted;
  }

  
  
/**
 * Check the permissions to do an action on any questionnaire by the roles in rolenames
 * @param rolenames, a comma-separated list of roles
 * @param action, the action to perform. it can be one of the CRUD actions
 * @return true if there is a role in rolenames able to do the action; false otherwise
 */  
  public static boolean intrvPermissions(String rolenames, int action) {
    String[] roles = rolenames.split(",");
    boolean granted = false;

    String[] arr$ = roles; 
    int len$ = arr$.length; 
    int i$ = 0; 
    
 /*
  * public static final int ROLE_ADM = 0;
  public static final int ROLE_EDI = 1;
  public static final int ROLE_INT = 3;
  public static final int ROLE_INV = 2;
  public static final int ROLE_DMG = 6;
  public static final int ROLE_CUR = 7;
  public static final int ROLE_DUM1 = 5;
  public static final int ROLE_DUM2 = 4;
  public static final int ACTION_C = 0;
  public static final int ACTION_R = 1;
  public static final int ACTION_U = 3;
  public static final int ACTION_D = 2;
  */
    for (String strRole: roles) {
 //   if (i$ < len$) { 
//    	String rolename = arr$[i$];
      int role = role2Code(strRole);

      if (role == AppUserCtrl.ROLE_EDI) {
        granted = true;
      }
      else if (action == AppUserCtrl.ACTION_R) {
        granted = true;
      }
      else if (role == AppUserCtrl.ROLE_ADM) {
        granted = true;
      }
      else 
        return false; 
    }
    
    return granted;
  }
  
  
  
/**
 * Check the permissions to do an action on any interview or performance
 * by the roles in rolenames
 * @param rolenames, a comma-separated list of roles
 * @param action, the action to perform. it can be one of the CRUD actions
 * @return true if there is a role in rolenames able to do the action; false otherwise
 */
  public static boolean performancePermissions(String rolenames, int action) {
    String[] roles = rolenames.split(",");
    boolean granted = false;

    String[] arr$ = roles; 
    int len$ = arr$.length; 
    int i$ = 0; 
//    if (i$ < len$) { 
    for (String rolename: roles) {
//    	String rolename = arr$[i$];
      int role = role2Code(rolename);

      if ((role == AppUserCtrl.ROLE_EDI) || (role == AppUserCtrl.ROLE_INT)) {
        granted = granted || true;
      }
      else if ((role == AppUserCtrl.ROLE_EDI || role == AppUserCtrl.ROLE_ADM) && 
      				 (action == AppUserCtrl.ACTION_R || action == AppUserCtrl.ACTION_U || 
      					action == AppUserCtrl.ACTION_D)) {
        granted = granted || true;
      }
      else if ((role == AppUserCtrl.ROLE_INT || role == AppUserCtrl.ROLE_CUR) && 
      				 (action == 	AppUserCtrl.ACTION_R || action == AppUserCtrl.ACTION_U))
      {
        granted = granted || true;
      }
      else if ((role == 6 || role == 7) && action == 1) {
        granted = granted || true;
      }
      else
        granted = granted || false; 
    } // EO for
     
    return granted;
  }
  
  

/**
 * Check the permissions to do an action on any item (text or question)
 * by the roles on rolenames
 * @param rolenames, a comma-separated list of roles
 * @param action, the action to perform. it can be one of the CRUD actions
 * @return true if there is a role in rolenames able to do the action; false otherwise
 */
  public static boolean elemPermissions(String rolenames, int action) {
    String[] roles = rolenames.split(",");
    boolean granted = false;

    for (String rolename : roles) {
      int role = role2Code(rolename);

      if ((role == AppUserCtrl.ROLE_EDI) || (role == AppUserCtrl.ROLE_ADM)) {
        granted = true;
        break;
      }
    }
    return granted;
  }

 
  
/**
 * This is the translation method to convert from role name to a internal numerical
 * representation
 * @param rolename, the role name
 * @return a local integer representing a role
 */
  private static int role2Code(String rolename) {
    if (rolename.equalsIgnoreCase("ADMIN")) {
      return 0;
    }
    if (rolename.equalsIgnoreCase("EDITOR")) {
      return 1;
    }
    if (rolename.equalsIgnoreCase("INTERVIEWER")) {
      return 3;
    }
    if (rolename.equalsIgnoreCase("CURATOR")) {
      return 7;
    }
    if (rolename.equalsIgnoreCase("DATA MANAGER")) {
      return 6;
    }

    return 2;
  }

  
  
  
/**
 * Get the list of roles from an user
 * @param usr, the user object
 * @return a list of role objects related to the user usr
 * @throws HibernateException
 */
  public List<Role> getRoleFromUser (AppUser usr)  throws HibernateException {
    String sqlQuery = "select r.* from appuser a, role r, user_role ur where a.username='" + usr.getUsername() + "' and a.iduser = ur.coduser " + "and ur.codrole = r.idrole";

    String hql = "from Role r join r.userRoles ur where ur.theUser=:user";

    Transaction tx = null;
    List l = null;
    try {
      tx = this.theSess.beginTransaction();
      Query qry = this.theSess.createQuery(hql);
      qry.setEntity("user", usr);

      List aux = qry.list();
      l = new ArrayList();
      for (Iterator it = aux.iterator(); it.hasNext(); ) {
        Object[] pair = (Object[])it.next();
        l.add((Role)pair[0]);
      }

      tx.commit();
    }
    catch (HibernateException hibEx) {
      if (tx != null) {
        tx.rollback();
      }
      l = null;
    }

    return l;
  }
  
  
  
  

 /**
  * Simply returns all users registered on the application
  * @return a list of AppUser objects
  */
  public List<AppUser> getOnlyUsers() {
    Criteria ct = null;
    Transaction tx = null;
    List l = null;
    try {
      boolean doCommit = false;
      tx = this.theSess.getTransaction();
      if ((tx == null) || (!(tx.isActive()))) {
        tx = this.theSess.beginTransaction();
        doCommit = true;
      }

      ct = this.theSess.createCriteria(AppUser.class);
      l = ct.list();

      if (doCommit)
        tx.commit();
    }
    catch (HibernateException hibEx)
    {
      if (tx != null) {
        tx.rollback();
      }
      String msgLog = "Unable to retrieve users from DB";
      StackTraceElement[] stack = hibEx.getStackTrace();
      LogFile.error(msgLog);
      LogFile.logStackTrace(stack);
    }

    return l;
  }
  
  
  
  

  public List<Object[]> getAllUsers() {
    List aux = null;
    String hqlStr = "from AppUser a join a.userRoles u order by a.username";

    Query q = this.theSess.createQuery(hqlStr);
    aux = q.list();
    return aux;
  }
  
  
  
/**
 * Gets the user from the username, which is not primary key
 * @param username, the name of the user to use the application
 * @return, the AppUser representing the user with username
 * @throws HibernateException
 */
  public AppUser getUser(String username)
    throws HibernateException
  {
    Criteria ct = this.theSess.createCriteria(AppUser.class).add(Restrictions.eq("username", username));
    AppUser theUser = (AppUser)ct.uniqueResult();

    return theUser;
  }

  
  
  
/**
 * Gets an user from their username and email. This is to reinforce the 
 * user identity by matching his/her email and username.
 * @param email
 * @return
 */
  public AppUser getUserFromEmail(String email, String username)
  {
    String hqlQry = "from AppUser u where lower(u.email)=lower(:email) ";
    hqlQry += "and username = :usrname";
    Transaction tx = null;
    try {
      tx = this.theSess.beginTransaction();
      Query qry = this.theSess.createQuery(hqlQry);
      qry.setString("email", email);
      qry.setString("usrname", username);

      List lu = qry.list();
      tx.commit();

      if ((lu != null) && (lu.size() > 0)) {
        return ((AppUser)lu.get(0));
      }
      return null;
    }
    catch (HibernateException ex) {
      if (tx != null)
        tx.rollback();
    }
    return null;
  }

  
  
/**
 * Get all groups which the user usr belongs to
 * @param usr, the user whose groups want to be retrieved
 * @return, the list of groups or null if something wrong happened
 * @throws HibernateException
 */  
  public List<AppGroup> getGroups(AppUser usr)
    throws HibernateException
  {
    String hql = "from RelGrpAppuser r where r.appuser=:user";
    String hqlAdm = "from AppGroup";
    String superhql = "select a from AppGroup a join a.relGrpAppusrs r " +
    		"where r.appuser=:user";

    Transaction tx = null;
    Query qry = null;

    List aux = null;
    try
    {
      boolean doCommit = false;
      tx = this.theSess.getTransaction();
      if ((tx == null) || (!(tx.isActive()))) {
        tx = this.theSess.beginTransaction();
        doCommit = true;
      }

      if (usr.isAdmin()) {
        qry = this.theSess.createQuery(hqlAdm);
        aux = qry.list();

        if (doCommit)
          tx.commit();
      }
      else
      {
        qry = this.theSess.createQuery(superhql);
        qry.setEntity("user", usr);

        aux = qry.list();
        if (doCommit) {
          tx.commit();
        }

      }

    }
    catch (HibernateException ex)
    {
      if (tx != null) {
        tx.rollback();
      }
      String msgLog = "Unable to create a new interview '" + usr.getUsername() + "'";
      LogFile.error(msgLog);
      LogFile.error(ex.getLocalizedMessage());
      StackTraceElement[] stack = ex.getStackTrace();
      LogFile.logStackTrace(stack);

      return null;
    }

    return aux;
  }
  
  
  
  
/**
 * Return the list of primary groups, which means for this context, the list of
 * countries registered in the application
 * @return a list of group entity objects
 */  
  public List<AppGroup> getPrimaryGroups () {
  	String hql = "from AppGroup g where UPPER(g.type.name)='COUNTRY'";

    Transaction tx = this.theSess.beginTransaction();
    Query q = this.theSess.createQuery(hql);

    List lGrp = q.list();
    tx.commit();

    return lGrp;
  }
  
  

 
/**
 * Gets a all-groups list
 * @return a list with all groups (without specific order) registered in the application
 */
  public List<AppGroup> getAllGroups() {
    String hql = "from AppGroup";

    Transaction tx = this.theSess.beginTransaction();
    Query q = this.theSess.createQuery(hql);

    List lGrp = q.list();
    tx.commit();

    return lGrp;
  }
  
  
  

/**
 * Gets a all-projects list
 * @return a list with all projects (without specific order) registered in the application
 */
  public List<Project> getAllProjects() {
    String hql = "from Project";

    Transaction tx = this.theSess.beginTransaction();
    Query q = this.theSess.createQuery(hql);

    List lPrj = q.list();
    tx.commit();

    return lPrj;
  }

  
  
/**
 * Gets a all-roles list
 * @return a list with all roles (without specific order) registered in the application
 */
  public List<Role> getAllRoles() {
    String hql = "from Role";

    Transaction tx = this.theSess.beginTransaction();
    Query q = this.theSess.createQuery(hql);

    List lRole = q.list();
    tx.commit();

    return lRole;
  }
  
  

 /**
  * This method fetch all users which belongs to the same group type identified by
  * grpTypeName (this is not the group name, it is the group type name as parameter)
  * @param user, the user whose partners are to be fetched
  * @param grpTypeName, the name of the group the users have to belong to
  * @return a list with the users belonging to grpTypeName
  */
  public List<AppUser> getUserPartners(AppUser user, String grpTypeName) {
    String sqlQry = "select a.iduser from appuser a, rel_grp_appusr rga where a.iduser = rga.coduser and rga.codgroup in (select rga.codgroup from appuser a, rel_grp_appusr rga, appgroup g where a.iduser = rga.coduser and a.iduser = " + user.getId() + " and rga.codgroup = g.idgroup " + "and g.codgroup_type = " + " (select idgrouptype from grouptype where name = '" + grpTypeName + "'));";

    String hqlQryBad = "select a from AppUser a join a.relGrpAppusrs b " +
    		"where b.appgroup in (select d.appgroup from AppUser c " +
    		"join c.relGrpAppusrs d where c = :user)";

    Transaction tx = null;
    tx = this.theSess.beginTransaction();
    Query q = this.theSess.createSQLQuery(sqlQry);

    List l = q.list();
    List lUsr = new ArrayList();

    Iterator it = l.iterator();
    while (it.hasNext()) {
      AppUser usr = (AppUser)this.theSess.get(AppUser.class, (Serializable)it.next());
      lUsr.add(usr);
    }

    tx.commit();

    return lUsr;
  }
  
  

/**
 * This is and ad-hoc method only regarded to this context. This method return the
 * lowest code for hospitals regarding to the parameter country (for example, in the
 * study specification document, for Spain the lowest hospital code is 1 and 
 * highest 19)
 * @param country, the country represented by two characters
 * @return an integer with the lowest hospital code for the country
 */  
  private Integer getCodHospIni(String country) {
    if (country.equalsIgnoreCase("es")) {
      return COD_HOSPITAL_INI_ES;
    }
    if (country.equalsIgnoreCase("en")) {
      return COD_HOSPITAL_INI_EN;
    }
    if (country.equalsIgnoreCase("it")) {
      return COD_HOSPITAL_INI_IT;
    }
    if (country.equalsIgnoreCase("at")) {
      return COD_HOSPITAL_INI_AT;
    }
    if (country.equalsIgnoreCase("de")) {
      return COD_HOSPITAL_INI_DE;
    }
    if (country.equalsIgnoreCase("se")) {
      return COD_HOSPITAL_INI_SE;
    }
    if (country.equalsIgnoreCase("ie")) {
      return COD_HOSPITAL_INI_IE;
    }

    return COD_HOSPITAL_INI_ES;
  }
  
  
  
/**
 * This is and ad-hoc method only regarded to this context. This method return the
 * highest code for hospitals regarding to the parameter country (for example, in the
 * study specification document, for Spain the lowest hospital code is 1 and 
 * highest 19)
 * @param country, the country represented by two characters
 * @return an integer with the highest hospital code for the country
 */  
  private Integer getCodHospEnd(String country) {
    if (country.equalsIgnoreCase("es")) {
      return COD_HOSPITAL_END_ES;
    }
    if (country.equalsIgnoreCase("en")) {
      return COD_HOSPITAL_END_EN;
    }
    if (country.equalsIgnoreCase("it")) {
      return COD_HOSPITAL_END_IT;
    }
    if (country.equalsIgnoreCase("at")) {
      return COD_HOSPITAL_END_AT;
    }
    if (country.equalsIgnoreCase("de")) {
      return COD_HOSPITAL_END_DE;
    }
    if (country.equalsIgnoreCase("se")) {
      return COD_HOSPITAL_END_SE;
    }
    if (country.equalsIgnoreCase("ie")) {
      return COD_HOSPITAL_END_IE;
    }

    return COD_HOSPITAL_END_ES;
  }

  @Deprecated
  public List<AppUser> getCountryGroup(String country)
    throws HibernateException
  {
    Integer codIni = getCodHospIni(country);
    Integer codEnd = getCodHospEnd(country);

    String sql = "select * from appuser a where a.codhosp in (select idhosp from hospital where hospcod between " + codIni + " and " + codEnd + ") " + "or a.iduser = (select a.iduser from appuser a, user_role ur " + "where a.iduser = ur.coduser and ur.codrole = " + COD_ADMROLE + ");";

    Transaction tx = this.theSess.beginTransaction();
    List l = this.theSess.createSQLQuery(sql).addEntity(AppUser.class).list();

    tx.commit();
    return l;
  }

  
  
 /**
  * Gets the list of projects which the user is assigned to
  * @param user, an user
  * @return a list of Project entity objects
  */
  public List<Project> getProjects(AppUser user) {
    String hql = "from Project p where p.relPrjAppuserses.appuser=:user";
    String hqlBis = "from Project p join p.relPrjAppuserses rpa where rpa.appuser=:user";

    String hqlAdm = "from Project";

    Transaction tx = null;
    List prjs = null;
    try
    {
      Query qry;
      tx = this.theSess.beginTransaction();

      if (user.isAdmin()) {
        qry = this.theSess.createQuery(hqlAdm);
        prjs = qry.list();
      }
      else {
        qry = this.theSess.createQuery(hqlBis);
        qry.setEntity("user", user);
        List aux = qry.list();

        Iterator itAux = aux.iterator();
        prjs = new ArrayList();
        while (itAux.hasNext()) {
          Object[] pair = (Object[])(Object[])itAux.next();
          prjs.add((Project)pair[0]);
        }
      }

      tx.commit();
    }
    catch (HibernateException ex) {
      if (tx != null) {
        tx.rollback();
      }
    }
    return prjs;
  }
  
  
  
  
/**
 * Set a group for the user active or inactive depending on the setting parameter
 * @param user, the application user
 * @param group, the group which is to be activated or not
 * @param setting, the activation setting:<br/>0, group becomes inactive<br/>
 * 1, group becomes active
 * @return, true on successful completion; false otherwise
 */
  public boolean setActiveGroup(AppUser user, AppGroup group, Integer setting)  {
    boolean res = false;
    String hqlStr = "from RelGrpAppuser r where r.appgroup=:grp and r.appuser=:user";
    List relGroups = null;
    AppGroup prevGrp = null;

    String grpType = group.getType().getName();
    if (grpType.equalsIgnoreCase("COUNTRY"))
      prevGrp = getPrimaryActiveGroup(user);
    else {
      prevGrp = getSecondaryActiveGroup(user);
    }
    
    Transaction tx = null;
    try
    {
      boolean doCommit = false;
      tx = this.theSess.getTransaction();
      if ((tx == null) || (!(tx.isActive()))) {
        tx = this.theSess.beginTransaction();
        doCommit = true;
      }

      Query hqlQry = this.theSess.createQuery(hqlStr);
      if ((prevGrp != null) && (setting.intValue() == 1)) {
        hqlQry.setEntity("user", user);
        hqlQry.setEntity("grp", prevGrp);

        relGroups = hqlQry.list();
        ((RelGrpAppuser)relGroups.get(0)).setActive(Integer.valueOf(0));
      }

      hqlQry.setEntity("user", user);
      hqlQry.setEntity("grp", group);
      relGroups = hqlQry.list();

      if ((relGroups != null) && (relGroups.size() == 1)) {
        RelGrpAppuser rel = (RelGrpAppuser)relGroups.get(0);
        rel.setActive(setting);
        res = true;
      }

      if (doCommit)
        tx.commit();
    }
    catch (HibernateException ex)
    {
      if (tx != null) {
        tx.rollback();
      }
      String msgLog = "Unable to set active group '" + group.getName() + "' for user '" + user.getUsername() + "'";

      LogFile.error(msgLog);
      LogFile.error(ex.getLocalizedMessage());
      StackTraceElement[] stack = ex.getStackTrace();
      LogFile.logStackTrace(stack);
      return res;
    }

    return res;
  }
  
  
  
/**
 * Get the secondary group in which the user user is currently working on
 * @param user, the user
 * @return an AppGroup entity object which is the active secondary group (hospital
 * for this context)
 */
  public AppGroup getSecondaryActiveGroup(AppUser user) {
    List groups = null;
    AppGroup activeGrp = null;
    String hql = "select g from AppGroup g join g.relGrpAppusrs r " +
    		"where g.type.name='HOSPITAL' and r.active=1 and r.appuser=:user";

    Transaction tx = null;
    try
    {
      boolean doCommit = false;
      tx = this.theSess.getTransaction();
      if ((tx == null) || (!(tx.isActive()))) {
        tx = this.theSess.beginTransaction();
        doCommit = true;
      }

      Query hqlQry = this.theSess.createQuery(hql);
      hqlQry.setEntity("user", user);
      groups = hqlQry.list();
      if (doCommit)
        tx.commit();
    }
    catch (HibernateException ex)
    {
      if (tx != null) {
        tx.rollback();
      }
      String msgLog = "Unable to get secondary group for user '" + user.getUsername() + "'";
      LogFile.error(msgLog);
      LogFile.error(ex.getLocalizedMessage());
      StackTraceElement[] stack = ex.getStackTrace();
      LogFile.logStackTrace(stack);
      return null;
    }

    if ((groups != null) && (groups.size() > 0)) {
      activeGrp = (AppGroup)groups.get(0);
    }
    return activeGrp;
  }

  
  
  
  
 /**
  * This just get a secondary group which is related to the user user 
  * @param user
  * @return a AppGroup entity object
  */
  @Deprecated
  public AppGroup getSecondaryGroup(AppUser user) {
    List groups = getGroups(user);
    List aux = null;
    String hqlGrps = "from AppGroup g where g in (:groups) and g.type.name='HOSPITAL'";

    Query qry = null;

    Transaction tx = null;
    AppGroup group = null;
    try {
      tx = this.theSess.beginTransaction();

      if (groups != null) {
        qry = this.theSess.createQuery(hqlGrps);
        qry.setParameterList("groups", groups);
        aux = qry.list();
      }
      tx.commit();
    }
    catch (HibernateException ex) {
      if (tx != null) {
        tx.rollback();
      }
      LogFile.getLogger().error(ex.getLocalizedMessage());
      StackTraceElement[] stElems = ex.getStackTrace();
      LogFile.logStackTrace(stElems);

      return null;
    }

    if ((aux != null) && (aux.size() > 0)) {
      group = (AppGroup)aux.get(0);
    }
    return group;
  }

  
  
  
/**
 * This method returns all secondary groups bound to the user represented by usrid
 * Actually, this method call the <b>getSecondaryGroups (AppUser user)</b>
 * after retrieving the user form the usrid
 * @param usrid, the id of the user
 * @return a list of AppGroups which are bound to the user
 */
  public List<AppGroup> getSecondaryGroups(int usrid, Integer mainGrpId) {
    AppUser myUsr = (AppUser)this.theSess.get(AppUser.class, Integer.valueOf(usrid));
    AppGroup grp = (AppGroup)this.theSess.get(AppGroup.class, mainGrpId);
    
    return getSecondaryGroups(myUsr, grp);
  }

  
  
  
  
/**
 * This method returns all secondary groups bound to the user represented by
 * the user entity 
 * @param user, the user entity
 * @return a list of AppGroups which are bound to the user
 */
  public List<AppGroup> getSecondaryGroups(AppUser user, AppGroup mainGrp) {
    List lGrps = null;
    String hql = "select a from AppGroup a join a.relGrpAppusrs r where " +
    		"a.type.name='HOSPITAL' and r.appuser=:user " +
    		"and a.container=:maingrp order by a.name";

    Transaction tx = null;
    AppGroup group = null;
    Query qry = null;
    try {
      boolean doCommit = false;
      tx = this.theSess.getTransaction();
      if ((tx == null) || (!(tx.isActive()))) {
        tx = this.theSess.beginTransaction();
        doCommit = true;
      }

      qry = this.theSess.createQuery(hql);
      qry.setEntity("user", user);
      qry.setEntity("maingrp", mainGrp);
      lGrps = qry.list();

      if (doCommit)
        tx.commit();
    }
    catch (HibernateException ex) {
      if (tx != null) {
        tx.rollback();
      }
      LogFile.getLogger().error(ex.getLocalizedMessage());
      StackTraceElement[] stElems = ex.getStackTrace();
      LogFile.logStackTrace(stElems);

      return null;
    }

    return lGrps;
  }
  
  
  
  
/**
 * This method gets the primary group (a COUNTRY in this context) in which the 
 * user user is currently working on
 * @param user, the user whose group wants to be retrieved
 * @return an AppGroup entity object 
 */
  public AppGroup getPrimaryActiveGroup(AppUser user) {
    List groups = null;
    AppGroup activeGrp = null;
    String hql = "select g from AppGroup g join g.relGrpAppusrs r where g.type.name='COUNTRY' and r.active = 1 and r.appuser=:user";

    String hqlName = "from AppGroup g where g.type.name='COUNTRY'";

    Transaction tx = null;
    try
    {
      boolean doCommit = false;
      tx = this.theSess.getTransaction();
      if ((tx == null) || (!(tx.isActive()))) {
        tx = this.theSess.beginTransaction();
        doCommit = true;
      }

      Query hqlQry = this.theSess.createQuery(hql);
      hqlQry.setEntity("user", user);
      groups = hqlQry.list();
      if (doCommit)
        tx.commit();
    }
    catch (HibernateException ex)
    {
      if (tx != null) {
        tx.rollback();
      }
      String msgLog = "Unable to get main group for user '" + user.getUsername() + "'";
      LogFile.error(msgLog);
      LogFile.error(ex.getLocalizedMessage());
      StackTraceElement[] stack = ex.getStackTrace();
      LogFile.logStackTrace(stack);
      return null;
    }

    if ((groups != null) && (groups.size() > 0)) {
      activeGrp = (AppGroup)groups.get(0);
    }
    return activeGrp;
  }
  
  

  @Deprecated
  public AppGroup getPrimaryGroup(AppUser user) {
    List groups = null;
    List aux = null;
    String hql = "select g from AppGroup g where g in (:groups) and g.type.name='COUNTRY'";

    Transaction tx = null;
    AppGroup group = null;
    try {
      groups = getGroups(user);

      boolean doCommit = false;
      tx = this.theSess.getTransaction();
      if ((tx == null) || (!(tx.isActive()))) {
        tx = this.theSess.beginTransaction();
        doCommit = true;
      }

      if (groups != null) {
        Query qry = this.theSess.createQuery(hql);
        qry.setParameterList("groups", groups);
        aux = qry.list();
      }
      if (doCommit)
        tx.commit();
    }
    catch (HibernateException ex) {
      if (tx != null) {
        tx.rollback();
      }
      String msgLog = "Unable to get main group for user '" + user.getUsername() + "'";
      LogFile.error(msgLog);
      LogFile.error(ex.getLocalizedMessage());
      StackTraceElement[] stack = ex.getStackTrace();
      LogFile.logStackTrace(stack);
      return null;
    }

    if ((aux != null) && (aux.size() > 0)) {
      group = (AppGroup)aux.get(0);
    }
    return group;
  }

  public List<AppGroup> getPrimaryGroups(int usrid)
  {
    AppUser myUsr = (AppUser)this.theSess.get(AppUser.class, Integer.valueOf(usrid));

    return getPrimaryGroups(myUsr);
  }

  
  
  
  
 /**
  * Get the primary groups assigned to a user
  * @param user, the user
  * @return a list of the groups assigned to the user; null if something was wrong
  */ 
  public List<AppGroup> getPrimaryGroups (AppUser user) {
    List lGrps = null;
    String hql = "select a from AppGroup a join a.relGrpAppusrs r " +
    		"where a.type.name='COUNTRY' and r.appuser=:user order by a.name";

    Transaction tx = null;
    AppGroup group = null;
    Query qry = null;
    try {
      boolean doCommit = false;
      tx = this.theSess.getTransaction();
      if ((tx == null) || (!(tx.isActive()))) {
        tx = this.theSess.beginTransaction();
        doCommit = true;
      }

      qry = this.theSess.createQuery(hql);
      qry.setEntity("user", user);
      lGrps = qry.list();

      if (doCommit)
        tx.commit();
    }
    catch (HibernateException ex) {
      if (tx != null) {
        tx.rollback();
      }
      LogFile.getLogger().error(ex.getLocalizedMessage());
      StackTraceElement[] stElems = ex.getStackTrace();
      LogFile.logStackTrace(stElems);

      return null;
    }
    return lGrps;
  }

  
  
/**
 * Get a group with the name <b>name</b>. If several groups have the same name,
 * the groups with lowest database id is returned
 * @param name, the name of the group
 * @return the group with the name or the group with lowest id if several ones overlap
 */  
  public AppGroup getGroupFromName (String name) {
  	String hql = "select g from AppGroup g where name like :name order by g.id";
  	Transaction tx = null;
  	AppGroup grp = null;
  	
  	try {
  		tx = theSess.beginTransaction();
  		Query qry = theSess.createQuery(hql);
// System.err.println("getGroupFromName: is theSess open?: "+theSess.isOpen());
  		qry.setString("name", name);
  		
  		List<AppGroup> grps = qry.list();
/* 
System.out.println ("AppUserCtrl.getGroupFromName ("+name+"): "+grps.size());
for (AppGroup group: grps) {
	System.out.println ("- "+group.getName()+"("+group.getId()+")");
}
*/
  		if (grps != null && grps.size() != 0)
  			grp = grps.get(0);
  		
  		tx.commit();
//  		return grp;
  	}
  	catch (HibernateException ex) {
  		if (tx != null) {
        tx.rollback();
      }
      LogFile.getLogger().error(ex.getLocalizedMessage());
      StackTraceElement[] stElems = ex.getStackTrace();
      LogFile.logStackTrace(stElems);
      
ex.printStackTrace(System.err);
      return null;
  	}
  	return grp;
  }
  
  
  
  
/**
 * This is a simple method to get the group types on the GroupType table 
 * @return, a list of GroupType entity objects
 */
  public List<GroupType> getGroupTypes() {
    List aux = null;
    String hqlStr = "from GroupType";
    Transaction tx = null;
    try {
      tx = this.theSess.beginTransaction();
      Query hqlQry = this.theSess.createQuery(hqlStr);
      aux = hqlQry.list();
      tx.commit();

      return aux;
    }
    catch (HibernateException ex) {
      if (tx != null)
        tx.rollback();
      
      ex.printStackTrace(System.err);
    }
    return null;
  }


  
  
/**
 * Create a new group
 * @param name, the name of the group
 * @param grpCode, the code assigned for the group
 * @param grpTypeId, the type of the group as a database group type identifier
 * @return the id assigned to the new group in the DB; otherwise returns -1 
 */
  public int createGroup(String name, String grpCode, Integer grpTypeId) {
    Transaction tx = null;
    try {
      tx = this.theSess.beginTransaction();
      AppGroup group = new AppGroup(name);
      group.setCodgroup(grpCode);
      Integer grpId = (Integer)this.theSess.save(group);

      GroupType gt = (GroupType)this.theSess.get(GroupType.class, grpTypeId);
      if (gt != null) {
        group.setType(gt);
      }
      tx.commit();

      return grpId.intValue();
    }
    catch (HibernateException hibEx) {
      if (tx != null)
        tx.rollback();
      
      hibEx.printStackTrace(System.err);
    }
    return -1;
  }
  
  
  
  
/**
 * It adds the user user to the group grp
 * @param user, an user
 * @param grp, an group
 * @return true on successful completion; false otherwise
 * @throws HibernateException if something was wrong and the exception has to be
 * caught on a upper level
 */
  public boolean addUser2Group(AppUser user, AppGroup grp)
    throws HibernateException {
    Transaction tx = this.theSess.beginTransaction();

    RelGrpAppuser rga = new RelGrpAppuser(grp, user);
    tx.commit();

    return true;
  }
  

  
/**
 * It adds the user user to the project prj
 * @param user, an user
 * @param prj, a project
 * @return true on successful completion; false otherwise
 * @throws HibernateException if something was wrong and the exception has to be
 * caught on a upper level
 */  
  public boolean addUser2Prj(AppUser user, Project prj)
    throws HibernateException {
    Transaction tx = this.theSess.beginTransaction();

    RelPrjAppusers rpa = new RelPrjAppusers(prj, user);
    tx.commit();

    return true;
  }
  
  
  
  
/**
 * Unbinds the user user from the group grp
 * @param user, an user
 * @param grp, a group
 * @return true on successfully completion; false otherwise
 * @throws HibernateException
 */
  public boolean rmvUserFromGroup(AppUser user, AppGroup grp)
    throws HibernateException {
    RelGrpAppuser rga;
    List lUsers;
    Transaction tx = null;

    String hql = "from RelGrpAppuser where appgroup=:grp and appuser=:usr";
    Query qry = null;
    try
    {
      tx = this.theSess.beginTransaction();

      qry = this.theSess.createQuery(hql);
      qry.setEntity("grp", grp);
      qry.setEntity("usr", user);
      rga = (RelGrpAppuser)qry.uniqueResult();

      this.theSess.delete(rga);
      tx.commit();
    }
    catch (NonUniqueResultException ex) {
      if (qry != null) {
        lUsers = qry.list();
        if ((lUsers == null) || (lUsers.size() == 0)) {
          return false;
        }
        rga = (RelGrpAppuser)lUsers.get(0);
      }
      else {
        return false;
      }
    } catch (HibernateException hibEx) {
      if (tx != null)
        tx.rollback();
      return false;
    }

    return true;
  }
  
  
  
  
/**
 * Unbinds the user user from the group grp
 * @param user, an user
 * @param prj, a project
 * @return true on successfully completion; false otherwise
 * @throws HibernateException
 */
  public boolean rmvUserFromPrj(AppUser user, Project prj)
    throws HibernateException {
    RelPrjAppusers rpa;
    List lUsers;
    Transaction tx = null;

    String hql = "from RelGrpAppuser where project=:prj and appuser=:usr";
    Query qry = null;
    try
    {
      tx = this.theSess.beginTransaction();
      qry = this.theSess.createQuery(hql);
      qry.setEntity("prj", prj);
      qry.setEntity("usr", user);

      rpa = (RelPrjAppusers)qry.uniqueResult();

      this.theSess.delete(rpa);
      tx.commit();
    }
    catch (NonUniqueResultException ex) {
      if (qry != null) {
        lUsers = qry.list();
        if ((lUsers == null) || (lUsers.size() == 0)) {
          return false;
        }
        rpa = (RelPrjAppusers)lUsers.get(0);
      }
      else {
        return false;
      }
    } catch (HibernateException hibEx) {
      if (tx != null) {
        tx.rollback();
      }
      return false;
    }

    return true;
  }
  
  
  
  

/**
 * Creates a new role. Role attributes are coded elsewhere
 * @param name, the name of the role
 * @param desc, a description
 * @return the DB identifier for the new created role on successfully completion;
 * otherwise returns -1
 */
  public int createRole(String name, String desc) {
    Transaction tx = null;
    try {
      tx = this.theSess.beginTransaction();
      Role role = new Role(name, desc);

      Integer rolId = (Integer)this.theSess.save(role);

      tx.commit();

      return rolId.intValue();
    }
    catch (HibernateException hibEx) {
      if (tx != null)
        tx.rollback();
    }
    return -1;
  }

  
  
  
/**
 * Actually, it assigns a role to an user, first checking if user and role are 
 * already bound
 * @param user, an user
 * @param role, the role 
 * @return true on successfully completion or if user and role are already bound;
 * false otherwise
 * @throws HibernateException
 */  
  public boolean addUser2Role(AppUser user, Role role)
    throws HibernateException {
    Transaction tx = this.theSess.beginTransaction();

    List<Role> roles = getRoleFromUser (user);
    if (roles.contains(role)) {
    	tx.commit();
    	return true;
    }
    
    AppuserRole ur = new AppuserRole(user, role);
    this.theSess.save(ur);
    tx.commit();

    return true;
  }
  
  
  
  
/**
 * Unbind user and role if there is a relationship between both of them
 * @param user, the user as an AppUser entity object
 * @param role, the role as an Role entity object
 * @return true on successfully completion; false otherwise
 * @throws HibernateException
 */
  public boolean rmvRoleFromUser(AppUser user, Role role)
    throws HibernateException {
    AppuserRole rga;
    List lUsers;
    Transaction tx = null;

    String hql = "from AppuserRole where theRole=:role and theUser=:usr";
    Query qry = null;
    try
    {
      tx = this.theSess.beginTransaction();
      qry = this.theSess.createQuery(hql);
      qry.setEntity("role", role);
      qry.setEntity("usr", user);

      rga = (AppuserRole)qry.uniqueResult();
      this.theSess.delete(rga);

      tx.commit();
    }
    catch (NonUniqueResultException ex) {
      if (qry != null) {
        lUsers = qry.list();
        if ((lUsers == null) || (lUsers.size() == 0)) {
          return false;
        }
        rga = (AppuserRole)lUsers.get(0);
      }
      else {
        return false;
      }
    } catch (HibernateException hibEx) {
      if (tx != null) {
        tx.rollback();
      }
      return false;
    }
    return true;
  }
  
  
  

  
/**
 * This is a convenient method to audit the beginning of a session of an user. 
 * The record goes both the database (by using the AppDBLogger class) and the
 * log file to have some backup in the case of needed (but the latter is not formal)
 * @param userId, the DB identifier of the user signed in
 * @param userName, the name of the user signed in
 * @param roles, an list of comma-separated roles as a String object
 * @param sessionId, the session identifier if available
 * @param ipAddr, the IP address of the referer if available. Actually, current
 * reached IP addresses on CNIO are masked by the web server. This is mostly intended
 * for future deployments. 
 * @param result, this is a switch to indicate the type of record to audit
 * @return true on successfully completion, successful database log; false otherwise
 */
  public boolean logSessionInit (Integer userId, String userName, String roles, 
  															 String sessionId, String ipAddr, int result) {
    String msgLog;
    Transaction tx = null;
    AppDBLogger sessionLog = null;

    switch (result)
    {
    case 0:
      AppGroup mainGrp = getPrimaryActiveGroup((AppUser)this.theSess.get(AppUser.class, userId));

      msgLog = "User '" + userName + "' logged in with roles '" + roles + "'";
      if (mainGrp != null)
        msgLog = msgLog + " and for primary group '" + mainGrp.getName() + "'"; break;
    case 1:
      msgLog = "Fail to log in for user '" + userName + "': mismatching username:password";

      break;
    case 2:
      msgLog = "User '" + userName + "' (" + userId + ") tried to access from " + ipAddr + " while already logged in";

      break;
    case 4:
      msgLog = "Wrong password and/or username for '" + userName + "'";
      break;
    case 3:
      msgLog = "User '" + userName + "' was not found";
      break;
    case 5:
      msgLog = "User account for '" + userName + "' is deactivated as exceeding " + "maximum number of consecutive login attempts";

      break;
    default:
      msgLog = "Attempt to log in audited";
    }

    try
    {
      tx = this.theSess.beginTransaction();
      sessionLog = new AppDBLogger();
      sessionLog.setUserId(userId);
      sessionLog.setSessionId(sessionId);
      sessionLog.setMessage(msgLog);
      sessionLog.setLastIp(ipAddr);

      if (result == 0)
        LogFile.info(msgLog);
      else {
        LogFile.error(msgLog);
      }
      this.theSess.save(sessionLog);
      tx.commit();

      return true;
    }
    catch (HibernateException ex) {
      if (tx != null) {
        tx.rollback();
      }
      LogFile.error("Fail to log user session init:\t");
      LogFile.error("userId=" + userId + "; sessionId=" + sessionId);
      LogFile.error(ex.getLocalizedMessage());
      StackTraceElement[] stack = ex.getStackTrace();
      LogFile.logStackTrace(stack); }
    return false;
  }

  
  
  protected void finalize()
  {
    if ((this.theSess == null) || 
      (!(this.theSess.isOpen())))
      return;
  }
}
