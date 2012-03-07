package org.cnio.appform.util.render;


import java.io.BufferedOutputStream;
import java.io.FileOutputStream;
import java.io.PrintStream;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.log4j.Appender;
import org.apache.log4j.FileAppender;
import org.apache.log4j.Level;
import org.apache.log4j.Logger;
import org.apache.log4j.SimpleLayout;
import org.cnio.appform.entity.AbstractItem;
import org.cnio.appform.entity.AnswerItem;
import org.cnio.appform.entity.AnswerType;
import org.cnio.appform.entity.EnumItem;
import org.cnio.appform.entity.EnumType;
import org.cnio.appform.entity.Question;
import org.cnio.appform.entity.QuestionsAnsItems;
import org.cnio.appform.entity.Section;
import org.cnio.appform.entity.Text;

import org.hibernate.HibernateException;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.ScrollableResults;
import org.hibernate.ScrollMode;
import org.hibernate.Transaction;


public class FormRender {

	private final String PARAM_INTRV = "$idIntrv";
	private final String PARAM_PRJ = "$prjCode";
	private final String PARAM_CODPAT = "$codPat";
	private final String PARAM_SEC_ORDER =  "$secOrd";
	
	
	private String theQry = 
		"select p.codpatient as codpatient, g.name as grpname, i.name as intrvname, " +
		"s.name as secname, '' as codq, '' as theanswer, s.section_order as secord, " +
		"it.item_order as itemord, 1 as ansord, 1 as ansnum, it.\"repeatable\" as itrep," +
		"it.ite_iditem as itparent, it.iditem as itemId, it.content as stmt, " +
		"it.highlight as style " +
		"from patient p, appgroup g, performance pf, interview i, item it, section s, " +
		"project pj, text tx " +
		"where i.idinterview = $idIntrv " +
		"and pj.project_code = '$prjCode' " +
		"and pj.idprj = i.codprj " +
		"and pf.codinterview = i.idinterview " +
		"and pf.codgroup = g.idgroup " +
		"and s.codinterview = i.idinterview " +
		"and pf.codpat = p.idpat " +
		"and p.codpatient = '$codPat' " +
		"and it.idsection = s.idsection " +
		"and it.iditem = tx.idtext " +
		"and s.section_order = $secOrd " +
		"union " +
		"select p.codpatient as codpatient, g.name as grpname, i.name as intrvname, " +
		"s.name as secname, q.codquestion as codq, a.thevalue as theanswer, " +
		"s.section_order as secord, it.item_order as itemord, " +
		"pga.answer_order as ansord, pga.answer_number as ansnum, " +
		"it.\"repeatable\" as itrep, it.ite_iditem as itparent, it.iditem as itemId, " +
		"it.content as stmt, it.highlight as style " +
		"from patient p, pat_gives_answer2ques pga, appgroup g, performance pf, " +
		"question q, answer a, interview i, item it, section s, project pj  " +
		"where 1=1" +
		" and i.idinterview = $idIntrv " +
		" and pj.project_code = '$prjCode'" +
		" and pj.idprj = i.codprj " +
		" and pf.codinterview = i.idinterview" +
		" and pf.codgroup = g.idgroup" +
		" and s.codinterview = i.idinterview" +
		" and pf.codpat = p.idpat" +
		" and pga.codpat = p.idpat" +
		" and p.codpatient = '$codPat'" +
		" and pga.codquestion = q.idquestion" +
		" and pga.codanswer = a.idanswer" +
		" and q.idquestion = it.iditem" +
		" and it.idsection = s.idsection" +
		" and s.section_order = $secOrd" +
		" order by secord, ansnum, itemord, ansord; ";

	
	
	private Session hibSess;
	
	public FormRender (Session hibSes) {
		hibSess = hibSes;
	}
	
	
	
/**
 * Custom constructor to set up the query parameters
 * @param intrvId, the id of the interview
 * @param prjCode, the code (not the database id) of the project/study
 * @param codPat, the n-digit patient code
 * @param secOrd, the order of the section
 */	
	public FormRender (Session theSess, int intrvId, String prjCode, String codPat, 
										int secOrd) {
		this (theSess);
		
		theQry = theQry.replace(PARAM_INTRV, (new Integer(intrvId)).toString());
		theQry = theQry.replace(PARAM_PRJ, prjCode);
		theQry = theQry.replace(PARAM_CODPAT, codPat);
		theQry = theQry.replace(PARAM_SEC_ORDER, (new Integer(secOrd)).toString());
	}
	

	
/**
 * Execute the query for the items returning a cursor to scroll the results
 * without bringing the whole resultset into memory
 * @return a ScrollableResults object, which is a cursor positioned at the first 
 * item
 */
	private ScrollableResults execQuery () {
		Transaction tx = null;
		ScrollableResults cursor = null;
		
		try {
			tx = hibSess.beginTransaction();
			SQLQuery sqlQry = hibSess.createSQLQuery(this.theQry);
			
			cursor = sqlQry.scroll();
			tx.commit();
		}
		catch (HibernateException hibEx) {
			if (tx != null)
				tx.rollback();
			
			System.out.println ("FormRender.execQuery: "+hibEx.getMessage());
		}
		
		return cursor;
	}
	
	
	
	
	
	public void render () throws HibernateException {
	
		
		
	}
	
}
