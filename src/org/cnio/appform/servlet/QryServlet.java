package org.cnio.appform.servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.util.List;
import java.util.Iterator;
import java.util.ArrayList;

import java.net.URLEncoder;


import org.cnio.appform.entity.Project;
import org.cnio.appform.entity.Interview;
import org.cnio.appform.entity.Section;
import org.cnio.appform.entity.AbstractItem;
import org.cnio.appform.entity.Question;
import org.cnio.appform.entity.Text;
import org.cnio.appform.entity.AppUser;
import org.cnio.appform.entity.AppGroup;

import org.cnio.appform.util.HibernateUtil;
import org.cnio.appform.util.HibController;
import org.cnio.appform.util.IntrvController;
import org.cnio.appform.util.AppUserCtrl;
import org.cnio.appform.util.LogFile;

import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.HibernateException;
import org.hibernate.Query;

import org.json.simple.*;

/**
 * Servlet implementation class for Servlet: QryServlet
 *
 */
public class QryServlet extends javax.servlet.http.HttpServlet 
 												implements javax.servlet.Servlet {
   
	 static final long serialVersionUID = 1L;
	 private Session hibSes = null;
   
/* (non-Java-doc)
 * @see javax.servlet.http.HttpServlet#HttpServlet()
 */
	public QryServlet() {
		super();
	}
	
	
	

/*
 * select i.idinterview, s.idsection, s.name, s.section_order
from interview i, section s
where i.idinterview in (50,1650,1700,2000)
  and s.codinterview = i.idinterview
  and s.section_order = 3
order by 1, 4


select i.idinterview, s.name, it.item_order, it.content
from interview i, section s, item it
where i.idinterview in (50,1650,1700,2000)
  and s.codinterview = i.idinterview
  and it.idsection = s.idsection
  and s.section_order = 3
order by 1,3
 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) 
						throws ServletException, IOException {

		String what = request.getParameter("what"), jsonOut;
		List<?> list = null;
		
//		response.setHeader("Content-type", "application/json; charset=UTF-8");
		response.setHeader("Content-type", "text/html; charset=UTF-8");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		
// This checks whether or not "newcode" is the same as question code for question qid
		if (what.equalsIgnoreCase("qcode")) {
			String intrvId = request.getParameter("intrvid"), 
						newCode = request.getParameter("newcode"),
						qid = request.getParameter("qid");
			
			boolean result = isSameCode (qid, newCode);
			String  jsonStr;
			jsonStr = "{\"res\":1,\"samecode\":"+(result? 1: 0)+"}";
			out.print(jsonStr);
			
			return;
		}

		
// Get the subjects codes for the current active secondary group
// the json out has the shape of:
// [{"code":"157031024"},{"code":"10398365"},{"code":"1570931003"}]
		else if (what.equalsIgnoreCase("cod")) {
			String jsonMsg = "{\"codes\":[";
			JSONArray outJson = new JSONArray ();

			List<String> patCodes = getPatCodes (request);
			boolean empty = (patCodes == null || patCodes.size() == 0)? true: false;
			if(!empty) {
				for (String code: patCodes) {
					JSONObject elem = new JSONObject ();
					elem.put("code", code);
					
					outJson.add(elem);
				}
			}
			out.println(outJson);
			
			return;
		}
		
		else if (what.equalsIgnoreCase("prj")) {
			list = getProjects ();
		}
		
		
// Search for interviews which name contains intrvname and parent project is parentid
		else if (what.equalsIgnoreCase("search")) {
			String parentId = request.getParameter("parentid");
			String intrvName = request.getParameter("intrvname");
			
			Transaction tx = null;
			String strQry = "from Interview i where i.parentPrj=:prj and UPPER(i.name) like UPPER('%"+
						intrvName+"%') order by i.name";
			try {
				openHibSession ();
				tx = hibSes.beginTransaction();
				Project prj = (Project)hibSes.get(Project.class, Integer.parseInt(parentId));
				Query qry = hibSes.createQuery(strQry);
				qry.setEntity("prj", prj);
				
				list = qry.list();
				tx.commit();
			}
			catch (HibernateException hibEx) {
				if (tx != null)
					tx.rollback();
			}
			finally {
				closeHibSession ();
			}
		}
		
// gets a list of interviews based on interview ids		
		else if (what.equalsIgnoreCase("intrv")) {
//			String parentId = request.getParameter("parentid");
//			String intrvName = request.getParameter("intrvname");
			String intrvIds = request.getParameter("intrvids");
			
//			list = getInterviews (Integer.parseInt(parentId), intrvName);
// List<Object[]> secs = getIntrvStruct (Integer.parseInt(parentId), intrvName);
//			list = getIntrvStruct (Integer.parseInt(parentId), intrvName);
			list = getSectionsIntrv (intrvIds);
		}
		
		else if (what.equalsIgnoreCase("sec")) {
			String intrvId = request.getParameter("parentid");
			
			list = getSections (Integer.parseInt(intrvId));
		}
		
		else if (what.equalsIgnoreCase("items")) {
			String secId = request.getParameter("secid");
			
			list = getSectionItems (Integer.parseInt(secId));
		}
		
		else if (what.equalsIgnoreCase("mulitems")) {
			String secsId = request.getParameter("secids");
			
			jsonOut = diffQuestionCode (secsId);
			out.print(jsonOut);
			return;
			
		}
		
		
		jsonOut = buildJson (list, what);
		
		out.print (jsonOut);
	}  	
	
	
	
	
/* (non-Java-doc)
 * @see javax.servlet.http.HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
						throws ServletException, IOException {
		
		String what = request.getParameter("what");
		JSONObject json = new JSONObject ();
		
		response.setHeader("Content-type", "application/json; charset=UTF-8");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		
		if (what.equalsIgnoreCase("del_en_it")) {
			String typeId = request.getParameter("typeid"); // id of the enumerated type
			String enumVal = request.getParameter("val"); // value of the enumerated item
			
			Long enId = Long.decode(typeId);
			openHibSession ();
			if (hibSes == null || !hibSes.isOpen()) {
				json.put("res", -3);
				json.put("msg", "Hibernate session not open or some crap");
				out.print(json);
				return;
			}
				
			int res = HibController.EnumTypeCtrl.delEnumItem(hibSes, enId, enumVal);
			
			json.put("res", res);
			String msg = "";
			switch (res) {
				case -2: 
					msg = "Enumerated type was not found on database"; break;
					
				case -1: 
					msg = "Enumerated item was not found on database"; break;
				
				case 0:
					msg = "Unable remove entry: It is used as answer for at least one question";
					break;
					
				case 1:
					msg = "The entry of the enumerated type was successfully removed";
					break;
					
				default: break;
			}
			json.put("msg", msg);
		} // EO what == del_en_it
		closeHibSession();
		out.print(json);
	}
	
	
	
	
	
/**
 * Get the question code differences between elements from both lists, looking for
 * the elements in the fst list in the snd list. Returns a list with the quesion
 * codes for the questions which are not in the second list
 * @param fst, a first list
 * @param snd, a second list with items
 * @return, a list of question codes that are not in the second list
 */
	private List<String> getDiffCodes (List<AbstractItem> fst, List<AbstractItem> snd) {
// check all items in the src list against all items in the other to see
// how many items in the src list are/are not in the other list
		List<String> diffCodes = new ArrayList<String>();
		
		for (AbstractItem srcIt: fst) {
			if (srcIt instanceof Text)
				continue;
			
			else {
				String srcQCode = ((Question)srcIt).getCodquestion();
				boolean similarCode = false;
//					jsonSrc += "<b>[Q</b>, (<i style=\\\"color:red\\\">"+srcQCode+"</i>)<b>]</b> ";
				
				for (AbstractItem clonIt: snd) {
					if (clonIt instanceof Text)
						continue;
					else {
						String clonQCode = ((Question)clonIt).getCodquestion();
						if (srcQCode.equalsIgnoreCase(clonQCode)) {
							similarCode = true;
							break; // what was being looked for was found, so it can be stopped
						}
					}
				}
				if (similarCode == false) // src is not in clone
					diffCodes.add(srcQCode);
			}
		}
		
		return diffCodes;
	}
		
		
		
/**
 * Gets and compares the codes for the items in the sections. The comparison
 * is performed comparing the question codes in the reference list of items
 * against all question codes in the other list(s). 
 * 
 * @param secIds
 * @return
 */
	public String diffQuestionCode (String secIds) throws java.io.UnsupportedEncodingException {
		
		String [] theIds = secIds.split(",");
		
		List<AbstractItem> clonItems, srcItems; // the items' lists
// list with the index of different elements in every list
		List<String> clonRedCodes = new ArrayList<String>(), 
								srcRedCodes = new ArrayList<String>(); 
		
		Interview intrvClon, intrvSrc;
		Section secClon, secSrc;
		openHibSession();
		secClon = (Section)hibSes.get(Section.class, Integer.parseInt(theIds[0]));
		secSrc = (Section)hibSes.get(Section.class, Integer.parseInt(theIds[1]));
		
		intrvSrc = secSrc.getParentIntr();
		intrvClon = secClon.getParentIntr();
/*
		if (secClon.getParentIntr().getSourceIntrv() == null) {
			secSrc = secClon;
			intrvSrc = secSrc.getParentIntr();
			secClon = (Section)hibSes.get(Section.class, Integer.parseInt(theIds[1]));
			intrvClon = secClon.getParentIntr();
		}
		else {
			intrvClon = secClon.getParentIntr();
			secSrc = (Section)hibSes.get(Section.class, Integer.parseInt(theIds[0]));
			intrvSrc = secSrc.getParentIntr();
		}
*/
		clonItems = HibernateUtil.getItems4Section(hibSes, secClon.getId());
		srcItems = HibernateUtil.getItems4Section(hibSes, secSrc.getId());
		
		clonRedCodes = getDiffCodes (clonItems, srcItems);
		srcRedCodes = getDiffCodes (srcItems, clonItems);

// now we have the items on every list and the index of the different items on
// each both lists in two list of index... now, the json has to be generated
// json is as
//	 		{"numSecs":2,"secs":[
//				{"secid":150,"items":[{"id":13556,"content":"htmlcode"}...]},
//				{"secid":330,"items":[{"id":13569,"content":"htmlcode"}...]}
//				]}
		String json = "{\"numSecs\":2,\"secs\":[";
		
		String jsonSrc = "{\"intrvid\":"+intrvSrc.getId()+",\"secid\":"+secSrc.getId()+",\"items\":[";
		for (AbstractItem srcIt: srcItems) {
			jsonSrc += "{\"id\":"+srcIt.getId()+",\"content\":\"";
			if (srcIt instanceof Question) {
				Question q = (Question)srcIt;
				String qCode = q.getCodquestion();
				
				if (srcRedCodes.contains(qCode))
					jsonSrc += "<b>[Q</b>, (<i style=\\\"color:red\\\">"+qCode+"</i>)<b>]</b> ";
				
				else
					jsonSrc += "<b>[Q</b>, (<i>"+qCode+"</i>)<b>]</b> ";
			}
			else
				jsonSrc += "<b>[T]</b> ";
			
			jsonSrc += URLEncoder.encode(srcIt.getContent().trim(), "UTF-8")+"\"},";
		}
		jsonSrc = jsonSrc.substring(0, jsonSrc.length()-1)+"]},";
		
		String jsonClon = "{\"intrvid\":"+intrvClon.getId()+",\"secid\":"+secClon.getId()+",\"items\":[";
		for (AbstractItem clonIt: clonItems) {
			jsonClon += "{\"id\":"+clonIt.getId()+",\"content\":\"";
			if (clonIt instanceof Question) {
				Question q = (Question)clonIt;
				String qCode = q.getCodquestion();
				
				if (clonRedCodes.contains(qCode))
					jsonClon += "<b>[Q</b>, (<i style=\\\"color:red\\\">"+qCode+"</i>)<b>]</b> ";
				
				else
					jsonClon += "<b>[Q</b>, (<i>"+qCode+"</i>)<b>]</b> ";
			}
			else
				jsonClon += "<b>[T]</b> ";
			
			jsonClon += URLEncoder.encode(clonIt.getContent().trim(), "UTF-8")+"\"},";
		}
		
		closeHibSession();
		json += jsonSrc + jsonClon.substring(0, jsonClon.length()-1)+"]}]}";
		return json;
	}
		
	
	
	
	
/**
 * Build the json string to send back to client. It will look like:
 * {"type":"typename","items":[{"id":anid,"name":"thename"}]}
 * @param list, the list of items
 * @param what, the type of the items (project, interview, section, ...)
 * @return an string with json format, alike at 
 * {"num":4,"intrvs":[{"name":"uno","id":325},{"name":"dos","id":4001}]}
 */
	private String buildJson (List<?> list, String what) throws java.io.UnsupportedEncodingException {
		String jsonAux = null;
		int numElems = (list != null)? list.size(): 0;
		
		jsonAux = "{\"num\":"+numElems+",\"";
		if (list == null || list.size() == 0) {
			jsonAux += "elems\":[]}";
			return jsonAux;
		}
		
		if (what.equalsIgnoreCase("prj")) {
			jsonAux += "prjs\":[";
			for (Object obj: list) {
				Project prj = (Project)obj;
				jsonAux += "{\"name\":\""+prj.getName()+"\",\"id\":"+prj.getId()+"},";
			}
		}
		
		else if (what.equalsIgnoreCase("intrv")) {

			int oldId = -1;
			jsonAux = "{\"intrvs\":[[";
			boolean first = true;
// Iterate over the row {idintrv, idsec, intrvname,secname, secorder}
// there will be several idsec, secname for each idintrv/intrvname
			
			for (Object item: list) {
				Object[] row = (Object[])item;
				Integer idIntrv = (Integer)row[0];
				
				if (idIntrv == oldId) { // add a section
					row[3] = URLEncoder.encode((String)row[3], "UTF-8");
					jsonAux += "{\"id\":"+row[1]+",\"name\":\""+row[3]+"\"},";
				}
				else { // new interview!!!
					oldId = idIntrv;
					jsonAux = jsonAux.substring (0, jsonAux.length()-1);
					if (!first) 
						jsonAux += "]},";
					else 
						first = false;
/*					
					int isClon = (row[5] != null)?1: 0;
					jsonAux += "{\"id\":"+idIntrv+",\"name\":\""+
										row[2]+"\",\"isclon\":"+isClon+",\"secs\":[";
*/
					
					jsonAux += "{\"id\":"+idIntrv+",\"name\":\""+
					row[2]+"\",\"secs\":[";
					row[3] = URLEncoder.encode((String)row[3], "UTF-8");
					jsonAux += "{\"id\":"+row[1]+",\"name\":\""+row[3]+"\"},";
				}
			}
			jsonAux = jsonAux.substring(0, jsonAux.length()-1) + "]},"; // finish below
			
		}
		else if (what.equalsIgnoreCase("sec")) {
			jsonAux += "secs\":[";
			for (Object obj: list) {
				Section sec = (Section)obj;
				jsonAux += "{\"name\":\""+URLEncoder.encode(sec.getName(), "UTF-8")+
									"\",\"id\":"+sec.getId()+"},";
			}
		}
		else if (what.equalsIgnoreCase("items")) {
			jsonAux += "items\":[";
			for (Object obj: list) {
				AbstractItem ai = (AbstractItem)obj;
				jsonAux += "{\"id\":"+ai.getId()+",\"content\":\"";
				if (ai instanceof Question) {
					Question q = (Question)ai;
					String qCode = q.getCodquestion();
					jsonAux += "<b>[Q</b>, (<i style=\\\"color:red\\\">"+qCode+"</i>)<b>]</b> ";
				}
				else
					jsonAux += "<b>[T]</b> ";
				
				jsonAux += URLEncoder.encode(ai.getContent().trim(), "UTF-8")+"\"},";
//				jsonAux += ai.getContent().trim()+"\"},";
			}
			
		}
		
		else if (what.equalsIgnoreCase("mulitems")) {
			
		}
		
		else if (what.equalsIgnoreCase("search")) {
			int num = list.size();
			jsonAux = "{\"num\":"+num+",\"intrv\":[";
			openHibSession ();
			for (Object item: list) {
				Interview current = (Interview)item;
				int isClon = current.getSourceIntrv() == null? 0: 1;
				jsonAux += "{\"name\":\""+current.getName()+"\",\"id\":"+current.getId()+","+
				"\"isclon\":"+isClon+"},";
			}
			closeHibSession ();
		}
		
		jsonAux = jsonAux.substring(0, jsonAux.length()-1);
		jsonAux += "]}";
		return jsonAux;
	}
	
	
	
	
	
	
	
	
	
/**
 * Checks whether or not the new question code is the same than the old one
 * @param quesId, the question id
 * @param newQCode, the new code as the user wrote it
 * @return true if both codes are the same; false otherwise
 */	
	private boolean isSameCode (String quesId, String newQCode) {
		
		Long questionId = Long.decode(quesId);
		openHibSession ();
		
		Question q = (Question)hibSes.get(Question.class, questionId);
		String oldCode = q.getCodquestion();
		closeHibSession ();
		
		return newQCode.equalsIgnoreCase(oldCode);
	}
	
	
	
/**
 * Get a list with the patient codes as strings based on the current questionnaire
 * and the current secondary active group
 * @return the list of patient codes
 */
	private List<String> getPatCodes (HttpServletRequest request) {
		List<String> aux = null;
		HttpSession session = request.getSession();
		openHibSession ();
		
		Integer usrid = (Integer)session.getAttribute("usrid");
		Integer intrvid = (Integer)session.getAttribute ("intrvId");
		if (intrvid == null || usrid == null)
			return aux;
		
		AppUserCtrl usrCtrl = new AppUserCtrl (hibSes);
		AppUser usr = (AppUser)hibSes.get(AppUser.class, usrid);
		AppGroup actGrp = usrCtrl.getSecondaryActiveGroup (usr);
		Interview intrv = (Interview)hibSes.get(Interview.class, intrvid);
		

		if (usr != null && actGrp != null && intrv != null) {
/*
			Transaction tx = null;
			String strQry = "select p.codpatient from Patient p join p.performances pf where " +
					"pf.interview=:intrv and pf.group=:grp and " +
					"p.codpatient <> '"+org.cnio.appform.util.IntrvFormCtrl.NULL_PATIENT+
					"' and p.codpatient <> '"+org.cnio.appform.util.IntrvFormCtrl.TEST_PATIENT+
					"' order by 1";
			
// System.out.println(strQry);

			try {
				tx = hibSes.beginTransaction();
				Query qry = hibSes.createQuery(strQry);
				qry.setEntity("intrv", intrv);
				qry.setEntity("grp", actGrp);
				
				aux = qry.list();
				tx.commit();
			}
			catch (HibernateException ex) {
				if (tx != null)
					tx.rollback();
			}
			finally {
				if (hibSes.isOpen())
					closeHibSession ();
			}
		}
*/
			org.cnio.appform.util.ReportUtil rep = new org.cnio.appform.util.ReportUtil (hibSes);
			aux = rep.getSubjectCodes(intrv, actGrp);
		}
		return aux;
		
	}
	
	
	
	public List<Project>	getProjects () {
		Transaction tx = null;
		List<Project> l = null;
		try {
			String strQry = "from Project";
			openHibSession ();
			
			tx = hibSes.beginTransaction();
			Query qry = hibSes.createQuery(strQry);
			l = qry.list();
			tx.commit();
		}
		catch (HibernateException hibEx) {
			if (tx != null)
				tx.rollback();
		}
		finally {
			if (hibSes.isOpen())
				closeHibSession ();
		}
		
		return l;
	}
	
	
/**
 * This method get all interview questionnaires which name (partially) matches
 * with the param partName
 * @param prjId, the id of the project or study which the interviews have to 
 * belong to
 * @param partName, a part of the questionnaire name
 * @return a list with the interviews for the project prjId which match with partName
 */
	public List<Interview> getInterviews (int prjId, String partName) {
		
		Transaction tx = null;
		List<Interview> l = null;
		openHibSession ();
//		IntrvController intrvCtrl = new IntrvController (hibSes);
		try {
			String strQry = "from Interview i where i.parentPrj=:prj and UPPER(i.name) " +
					"like UPPER('%"+partName+"%') order by i.name";
			openHibSession ();
			tx = hibSes.beginTransaction();
			Project prj = (Project)hibSes.get(Project.class, prjId);
			
// System.out.println("project: "+prj.getId()+":"+prj.getName());
			Query qry = hibSes.createQuery(strQry);
			qry.setEntity("prj", prj);
			l = qry.list();
			
			
			tx.commit();
		}
		catch (HibernateException hibEx) {
			if (tx != null)
				tx.rollback();
		}
		finally {
			if (hibSes.isOpen())
				closeHibSession ();
		}
		
		return l;
	}
	
	
	

/**
 * Gets the sections for the interviews represented by their id
 * @param intrvIds, a comma separated list of ids, ready to use in a sql in 
 * comparison
 * @return
 */
	public List<Object[]> getSectionsIntrv (String intrvIds) {
		
		String strQry = "select i.id, s.id, i.name, s.name, s.sectionOrder " +
		" from Interview i join i.sections s where " +
		"i.id in ("+intrvIds+")"+
		"order by 1, 5";
		
		Transaction tx= null;
		List<Object[]> lSecs = null;
		try {
			openHibSession ();
			tx = hibSes.beginTransaction();
			Query qry = hibSes.createQuery(strQry);
			
			lSecs = qry.list();

			tx.commit();
		}
		catch (HibernateException hibEx) {
			if (tx != null)
				tx.rollback();
hibEx.printStackTrace(System.err);
		}
		finally {
			if (hibSes.isOpen())
				closeHibSession ();
		}
		
		return lSecs;
	}
	
	
	
	
	public List<Object[]> getIntrvStruct (int prjId, String intrvName) {
	/*	
		select i.idinterview, s.idsection, i.name, s.name, s.section_order
		from interview i, section s
		where upper(i.name) like upper('%qes%')
		  and i.idinterview = s.codinterview
		order by 1, 5
	*/	
		String strQry = "select i.id, s.id, i.name, s.name, s.sectionOrder" +
				" from Interview i join i.sections s where " +
				"UPPER(i.name) like UPPER ('%"+intrvName+"%') "+
				"and i.parentPrj=:prj "+
				"order by 1, 5";
		
		
		Transaction tx= null;
		List<Object[]> lSecs = null;
		try {
			openHibSession ();
			tx = hibSes.beginTransaction();
			Project prj = (Project)hibSes.get(Project.class, prjId);
			Query qry = hibSes.createQuery(strQry);
			qry.setEntity("prj", prj);
			lSecs = qry.list();
			tx.commit();
		}
		catch (HibernateException hibEx) {
			if (tx != null)
				tx.rollback();
		}
		finally {
			if (hibSes.isOpen())
				closeHibSession ();
		}
		
		return lSecs;
	}
	
	
	
/**
 * Gets the sections for a interview based on the interview id
 * @param intrvId, the id of the interview to get the sections
 * @return, a list of sections
 */
	public List<Section> getSections (int intrvId) {
		List<Section> lSec = null;
		try {
			openHibSession ();
			Interview intrv = (Interview)hibSes.get(Interview.class, new Integer(intrvId));
			lSec = HibController.SectionCtrl.getSectionsFromIntrv(hibSes, intrv);
		}
		catch (HibernateException hibEx) {
			LogFile.error("QryServlet: Fail to open hibernate session:\t");
			LogFile.error(hibEx.getLocalizedMessage());
			StackTraceElement[] stack = hibEx.getStackTrace();
			LogFile.logStackTrace(stack);
		}
		finally {
			if (hibSes.isOpen())
				closeHibSession ();
		}
		
		return lSec;
	}
	
	
	
/**
 * Get the items for this section using the hibernate utility class
 * @param idSec, the id of the section
 * @return
 */
	public List<AbstractItem> getSectionItems (int idSec) {
	
		List<AbstractItem> items = null;
		try {
			openHibSession ();
			
			items = HibernateUtil.getItems4Section(hibSes, idSec);
		}
		catch (HibernateException hibEx) {
			LogFile.error("QryServlet: Fail to open hibernate session:\t");
			LogFile.error(hibEx.getLocalizedMessage());
			StackTraceElement[] stack = hibEx.getStackTrace();
			LogFile.logStackTrace(stack);
		}
		finally {
			if (hibSes.isOpen()) 
				closeHibSession ();
		}
		return items;
	}
	
	
	
	
	public void openHibSession () throws HibernateException {
		if (hibSes == null || !hibSes.isOpen()) 
			hibSes = HibernateUtil.getSessionFactory().openSession();
		
	}
	
	
	public void closeHibSession () throws HibernateException {
		if (hibSes.isOpen())
			hibSes.close();
	}

}