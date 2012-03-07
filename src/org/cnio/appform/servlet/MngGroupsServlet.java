package org.cnio.appform.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Iterator;
import java.util.List;

import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.cnio.appform.entity.AppDBLogger;
import org.cnio.appform.entity.AppGroup;
import org.cnio.appform.entity.AppUser;
import org.cnio.appform.entity.GroupType;
import org.cnio.appform.util.AppUserCtrl;
import org.cnio.appform.util.HibernateUtil;
import org.cnio.appform.util.LogFile;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;

public class MngGroupsServlet extends HttpServlet implements Servlet {
	
	
	
	public void init() {
		
	}

	
	
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		Iterator i$;
		AppGroup grp;
		String json = "";

		String what = request.getParameter("what");
		String strUsrid = request.getParameter("usrid");
		Integer usrid = Integer.valueOf(Integer.parseInt(strUsrid));
		HttpSession httpSes = request.getSession();

		Session hibSes = HibernateUtil.getSessionFactory().openSession();
		AppUserCtrl usrCtrl = new AppUserCtrl(hibSes);

		if (what.equalsIgnoreCase("s")) {
			Integer mainGrpId = (Integer)httpSes.getAttribute("primaryGrpId");
			List secGrps = usrCtrl.getSecondaryGroups(usrid.intValue(), mainGrpId);
			
			json = json + "{\"groups\":[";
			for (i$ = secGrps.iterator(); i$.hasNext();) {
				grp = (AppGroup) i$.next();
				json = json + "{\"id\":" + grp.getId() + ", \"name\":\""
						+ grp.getName() + "\"," + "\"cod\":\"" + grp.getCodgroup() + "\"},";
			}

			json = json.substring(0, json.length() - 1) + "]}";
		}

		if (what.equalsIgnoreCase("p")) {
			List mainGrps = usrCtrl.getPrimaryGroups(usrid.intValue());
			json = json + "{\"groups\":[";
			for (i$ = mainGrps.iterator(); i$.hasNext();) {
				grp = (AppGroup) i$.next();
				json = json + "{\"id\":" + grp.getId() + ", \"name\":\""
						+ grp.getName() + "\"," + "\"cod\":\"" + grp.getCodgroup() + "\"},";
			}

			json = json.substring(0, json.length() - 1) + "]}";
		}
		
		if (what.equalsIgnoreCase("pg")) {
			List mainGrps = usrCtrl.getPrimaryGroups();
			json = json + "{\"groups\":[";
			for (i$ = mainGrps.iterator(); i$.hasNext();) {
				grp = (AppGroup) i$.next();
				json = json + "{\"id\":" + grp.getId() + ", \"name\":\""
						+ grp.getName() + "\"," + "\"cod\":\"" + grp.getCodgroup() + "\"},";
			}

			json = json.substring(0, json.length() - 1) + "]}";
		}

		response.setHeader("Content-type", "application/json; charset=UTF-8");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		out.print(json);
	}
	
	
	
	

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		Integer usrId = (Integer) request.getSession().getAttribute("usrid");
		Integer grpId = Integer.valueOf(Integer.parseInt(request
				.getParameter("grpid")));
		String intrvId = request.getParameter("intrvid");
		String json = "{\"res\":0,\"msg\":\"at least, this is a json response\"}";
		String groupName = "groupName";

		HttpSession mySes = request.getSession();

		Session hibSes = HibernateUtil.getSessionFactory().openSession();

		AppUserCtrl usrCtrl = new AppUserCtrl(hibSes);
		AppUser user = (AppUser) hibSes.get(AppUser.class, usrId);
		AppGroup grp = (AppGroup) hibSes.get(AppGroup.class, grpId);
		groupName = grp.getName();
		String grpTypeName = grp.getType().getName();

		boolean success = usrCtrl.setActiveGroup(user, grp, Integer.valueOf(1));

		if (success) {
			String msgLog;
			json = "{\"res\":1,\"msg\":\"New active group is '" + groupName + "'\",";
			json = json + "\"intrv\":" + intrvId + "}";
			if (grpTypeName.equalsIgnoreCase("COUNTRY")) {
				mySes.setAttribute("primaryGrpId", grpId);
				mySes.setAttribute("primaryGrpName", groupName);

				msgLog = "User '" + user.getUsername() + "' has selected '" + groupName
						+ "' as primary active group";
			}
			else {
				mySes.setAttribute("secondaryGrpId", grpId);
				mySes.setAttribute("secondaryGrpName", groupName);

				msgLog = "User '" + user.getUsername() + "' has selected '" + groupName
						+ "' as secondary active group";
			}

			Transaction tx = null;
			try {
				tx = hibSes.beginTransaction();

				AppDBLogger sessionLog = new AppDBLogger();
				sessionLog.setUserId(usrId);
				sessionLog.setSessionId(mySes.getId());
				sessionLog.setMessage(msgLog);
				sessionLog.setLastIp(request.getRemoteAddr());
				hibSes.save(sessionLog);

				tx.commit();
			}
			catch (HibernateException ex) {
				if (tx != null) {
					tx.rollback();
				}
				LogFile.error("Fail to log user group selection:\t");
				LogFile.error("userId=" + usrId + "; sessionId=" + mySes.getId());
				LogFile.error(ex.getLocalizedMessage());
				StackTraceElement[] stack = ex.getStackTrace();
				LogFile.logStackTrace(stack);
			}
			finally {
				hibSes.close();
			}
		}
		else {
			json = "{\"res\":0,\"msg\":\"New group activation could not be performed. Contact with <a href=\\\"mailto:gcomesana@cnio.es\\\">administrator</a> to report and solve this issue\"}";
		}

		response.setHeader("Content-type", "application/json; charset=UTF-8");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
System.out.println ("MngGroupsServlet.doPost: json="+json);
		out.print(json);
	}
	
	

	public String getServletInfo() {
		return super.getServletInfo();
	}
}