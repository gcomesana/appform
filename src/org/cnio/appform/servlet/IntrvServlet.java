package org.cnio.appform.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.cnio.appform.entity.*;
import org.cnio.appform.util.AppUserCtrl;
import org.cnio.appform.util.HibernateUtil;
import org.cnio.appform.util.IntrvFormCtrl;

import org.hibernate.Session;

import java.util.List;
import java.util.Iterator;
import java.util.Enumeration;

import java.io.PrintWriter;
import java.net.URLDecoder;
import org.json.simple.JSONObject;

/**
 * Servlet implementation class for Servlet: IntrvServlet
 *
 */
 public class IntrvServlet extends javax.servlet.http.HttpServlet implements javax.servlet.Servlet {
   static final long serialVersionUID = 1L;
   
// this is to check whether a subject code is already on database
   static final String PAT_CHK = "patcode";
   
// This is to get user info, mostly the role in order to display a message
// on interview startup to show the role restrictions
   static final String ROLE_CHK = "rolechk"
  	 ;
// This is to retrieve the id of the performance for a subject
   static final String PERF_CHK = "perfchk";
   
   static final String PERF_CRT = "perf"; // create new performance
   static final String PERF_CFG = "perf_cfg"; // create performance history
   static final String APP_CFG = "appcfg"; // create performance configuration
   
   static final String SAVE_JUSTIFY = "save_just";
   
   
  /* (non-Java-doc)
	 * @see javax.servlet.http.HttpServlet#HttpServlet()
	 */
	public IntrvServlet() {
		super();
	}   	
	
	
	
	
	/* (non-Java-doc)
	 * @see javax.servlet.http.HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, 
									HttpServletResponse response) throws ServletException, IOException {
		String what = request.getParameter("what");
		String usrId = request.getParameter("usrid");
		JSONObject jsonOut = new JSONObject ();
		
		HttpSession session = request.getSession(false);
		Session hibSes = HibernateUtil.getSessionFactory().openSession();
		
// CHECKING PATIENT EXISTENCE IN DB
		if (what.equalsIgnoreCase(IntrvServlet.PAT_CHK)) {

			String patcode = request.getParameter("patcode");
			jsonOut.put("patcode", patcode);
			if (patcode != null && patcode.length() > 0) {
				IntrvFormCtrl intrvCtrl = new IntrvFormCtrl (hibSes);
				Patient myPat = intrvCtrl.getPatientFromCode(patcode);
				
				jsonOut.put("is", (myPat == null)?0: 1);
			}
			else 
				jsonOut.put("is", 0);
		} // eo PATIENT_CHK
		
		
// CHECKING ROLE PERMISSIONS
		if (what.equalsIgnoreCase(IntrvServlet.ROLE_CHK)) {
//			String username = request.getParameter("usr");
			
			AppUserCtrl usrCtrl = new AppUserCtrl (hibSes);
			String username = (String)session.getAttribute("user");
			AppUser usr = usrCtrl.getUser(username);
	
System.out.println ("IntrvServlet.doGet: username -> "+username);
			List<Role> roles = usrCtrl.getRoleFromUser(usr);
			String listRoles = "";
			for (Role role: roles) {
				listRoles += role.getName()+",";
			}
			listRoles.substring (0, listRoles.length()-1);
			
			boolean hasPermission = AppUserCtrl.performancePermissions(listRoles, AppUserCtrl.ACTION_U);
			
			jsonOut.put("username", username);
			jsonOut.put("hasPermission", hasPermission? 1: 0);
		}
	
// Performance configuration are formed by the parameters necessary to develop
// de interview performance prior to patient initialization
		if (what.equalsIgnoreCase(IntrvServlet.PERF_CHK)) {
			String patcode = request.getParameter("patcode");
			Integer intrvId = Integer.parseInt(request.getParameter("intrvid"));
			Performance perf;
			
			jsonOut.put("patcode", patcode);
			if (patcode != null && patcode.length() > 0) {
				IntrvFormCtrl intrvCtrl = new IntrvFormCtrl (hibSes);
				
				String jspSess = request.getSession().getId(),
							lastIp = request.getRemoteAddr();
				perf = intrvCtrl.getPerformance(patcode, intrvId, Integer.parseInt(usrId), 
																	jspSess, lastIp);
// It is possible the interview for this patient and interview is the first one
// so, here perf will be null (no perf was performed previously)
// then we have to create a new one
				if (perf == null) {
					perf = intrvCtrl.savePerformance(Integer.parseInt(usrId), jspSess, 
																lastIp, intrvId, patcode, "");
				}
				
				jsonOut.put("perfid", perf==null? -1: perf.getId());
				jsonOut.put("intrvid", intrvId);
				jsonOut.put("usrid", usrId);
			}
			else 
				jsonOut.put("is", 0);
		} // eo PERF_CHK
		
		
// Application configuration
		if (what.equalsIgnoreCase(IntrvServlet.APP_CFG)) {
			Integer usrid = (Integer)session.getAttribute("usrid"); // request.getParameter("usrid");
			Integer intrvid = (Integer)session.getAttribute("intrvId"); // request.getParameter("intrvid");
			
			Interview intrv = (Interview)hibSes.get(Interview.class, intrvid);
// putting questionnaire-related parameters			
			jsonOut.put("usrid", usrid);
			jsonOut.put("intrvid", intrvid);
			jsonOut.put("shrt", intrv.getCanShorten());
			jsonOut.put("crtSubj", intrv.getCanCreateSubject());
			jsonOut.put("prjid", intrv.getParentProj().getId());
			jsonOut.put("prjcode", intrv.getParentProj().getProjectCode());
			
// putting the secondary active group (if it is activated)
			AppUserCtrl usrCtrl = new AppUserCtrl(hibSes);
			AppUser usr = (AppUser)hibSes.get(AppUser.class, usrid);
			AppGroup secGrp = usrCtrl.getSecondaryActiveGroup(usr);
			jsonOut.put("grpid", secGrp == null? null: secGrp.getId());
			jsonOut.put("grpcode", secGrp == null? null: secGrp.getCodgroup());
		}
		
		hibSes.close();
		
		response.setHeader("Content-type", "application/json; charset=UTF-8");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		out.print(jsonOut);
	} 
	
	
	
	
	
	/* (non-Java-doc)
	 * @see javax.servlet.http.HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, 
									HttpServletResponse response) throws ServletException, IOException {
		String what = request.getParameter("what");
		Session hibSes = HibernateUtil.getSessionFactory().openSession();
		JSONObject jsonOut = new JSONObject();
		
	// CREATING A PERFORMANCE	
		if (what.equalsIgnoreCase(IntrvServlet.PERF_CRT)) {
			Integer userId = Integer.parseInt(request.getParameter("usrid")),
						intrvId = Integer.parseInt (request.getParameter("intrvid"));
			
			String whatItem = request.getParameter("type") == null? "subject":"sample";
			String fullPatCode = request.getParameter("patcode");
			String jspSesId = request.getSession().getId();
			String ipAddr = request.getRemoteAddr();
			Patient newPat = null;
			IntrvFormCtrl ctrlForm = new IntrvFormCtrl (hibSes);
	
// Depending on the object, we save different items: subject or sample
			Performance perf = (whatItem.equalsIgnoreCase("subject"))?
				ctrlForm.savePerformance(userId, jspSesId, ipAddr, intrvId, fullPatCode, ""):
				ctrlForm.savePerf4Sample(userId, jspSesId, intrvId, ipAddr, fullPatCode);
			
			if (perf == null) {
				jsonOut.put("res", 0);
				jsonOut.put("msg", "Performance could not be created. Try again and" +
						" contact with the administrators if problems persists");
			}
			else {
				newPat = ctrlForm.getPatientFromCode(fullPatCode);
				
				jsonOut.put("res", 1);
				jsonOut.put("perfid", perf.getId());
				jsonOut.put("patid", newPat.getId());
				jsonOut.put("msg", "A new interview for "+whatItem+" '"+newPat.getCodpatient()+"' was created");
			}
		}
		
			
// CREATING PERFORMANCE HISTORY
// it might be updated later if interview requires
		if (what.equalsIgnoreCase(IntrvServlet.PERF_CFG)) {
			Integer perfId = Integer.parseInt(request.getParameter("perfid"));
			Integer userId = Integer.parseInt(request.getParameter("usrid"));
			String patcode = request.getParameter("patcode");
			
			Performance thePerf = (Performance)hibSes.get(Performance.class, perfId);
			AppUser usr = (AppUser)hibSes.get(AppUser.class, userId);
			
			IntrvFormCtrl intrvCtrl = new IntrvFormCtrl (hibSes);
			boolean res = intrvCtrl.setCurrentPerfUser(usr, thePerf);
			
			jsonOut.put("res", res? 1: 0);
			jsonOut.put("msg", res? "A new entry record for the history of the interview was added":
															"Unable to add new entry record for the history of this interview");
			
// Besides we set the patient id as a session variable from this point on
// This session variable is deleted when a new interview is started
			Patient pat = null;
			pat = intrvCtrl.getPatientFromCode(patcode);
			request.getSession().setAttribute("patId", pat.getId());
			
			Integer lastSec = thePerf.getLastSec ();
			request.getSession().setAttribute ("lastSec", lastSec);
			request.getSession().setAttribute ("currentSec", 2);
			
			String shortParam = request.getParameter("shrtInrv"); 
			Integer shortPerf = 
				Integer.parseInt(shortParam!=null && shortParam.equalsIgnoreCase("1")?"1":"0");
			
			request.getSession().setAttribute("shortPerf", shortPerf);
		}
		
		
// SAVING A JUSTIFICATION WHEN AUTOSAVING IS ON
		if (what.equalsIgnoreCase(IntrvServlet.SAVE_JUSTIFY)) {
			String paramVal = request.getParameter("txt");
			String patId = request.getParameter("patid");
			String intrvId = request.getParameter("intrvid");
			
			if (paramVal != null && patId != null && intrvId != null) {
				String justification = URLDecoder.decode(paramVal, "UTF-8");
				
				IntrvFormCtrl formCtrl = new IntrvFormCtrl (hibSes);
				PerfUserHistory puh = 
					formCtrl.getPerformanceFromIntrv(Integer.decode(patId), Integer.decode(intrvId));
				
				boolean res = formCtrl.justifyShortPerf(puh, justification);
				String msg;
				msg = res? 
						"The justification for this SHORT interview was successfully saved":
							"The justification for this SHORT interview could not be saved";
									
				jsonOut.put("res", res? 1: 0);
				jsonOut.put("patId", Integer.decode(patId));
				jsonOut.put("intrvid", Integer.decode(intrvId));
				jsonOut.put("msg", msg);
			}
			else {
				jsonOut.put("res", 0);
				jsonOut.put("msg", "Insuficient parameters");
			}
		}
		
		hibSes.close();
		
		response.setHeader("Content-type", "application/json; charset=UTF-8");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		out.print(jsonOut);
	}
	
}