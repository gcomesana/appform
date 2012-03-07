package org.cnio.appform.util.dump;

import java.util.*;
import java.util.regex.Pattern;
import java.io.BufferedWriter;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.math.BigInteger;
import java.nio.charset.Charset;

import org.cnio.appform.entity.AppGroup;
import org.cnio.appform.entity.Interview;
import org.cnio.appform.entity.Project;
import org.cnio.appform.util.AppUserCtrl;
import org.cnio.appform.util.HibernateUtil;
import org.cnio.appform.util.IntrvController;
import org.hibernate.HibernateException;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.Transaction;



/**
 * 
 * This class performs the logic to get a dump as they want. To do that, the 
 * next steps are followed:
 * a- get the repeatable items for the interview and section requested
 * b- get the maximum number of answers for those repeatable items
 * c- get the rest of questions ("normal" questions) for the interview and section
 * d- build up the header of the file based on b and c. keep the header file
 * into a list as reference
 * e- get answers along with order, number and codquestion 
 *
 */
public class NewRetriever {

	private String filePath = "";
	
	private NewWriter dw;
	
	private Hashtable mapVarNames;
	
	public NewRetriever (String path, Hashtable map) {
		filePath = path;
		mapVarNames = map;
		
		dw = new NewWriter (mapVarNames);
	}

	
	
/**
 * Execute an sql query on hibernate and return the result
 * @param sql, the string representing the query and ready to be runned
 */
  private List<Object[]> execQuery (String qryStr) {
     Session myHibSes = HibernateUtil.getSessionFactory().openSession();
     Transaction tx = null;
     List<Object[]> rows = null;

    try {
      tx = myHibSes.beginTransaction();
       SQLQuery sqlQry = myHibSes.createSQLQuery(qryStr);
      
      rows = sqlQry.list();
      tx.commit();
    }
    catch (HibernateException ex) {
      if (tx != null)
        tx.rollback();

      System.out.println(ex.getMessage());
      ex.printStackTrace ();
    }
    finally {
      myHibSes.close();
    }

    return rows;
  }
  
  
  
  
 /**
  * Gets the ids of the repeteable items in the questionnaire intrvId.
  * @param prjCode, the project code
  * @param intrvId, the database id of the interview
  * @param secOrder, the order of the section inside the interview
  * @return a string of comma-separated item ids
  */
  public String getRepeatableItems (String prjCode, 
      															Integer intrvId, Integer secOrder) {
  	String theIds = "";
  	
  	String qry = 
  		"select it.iditem, it.content "+
  		"from interview i, section s, item it, project prj "+
  		"where prj.project_code = '"+prjCode+"' "+
  		"and prj.idprj = i.codprj " +
  		"and s.codinterview = i.idinterview "+
  		"and i.idinterview in ("+intrvId+") "+
  		"and it.idsection = s.idsection "  +
  		"and it.\"repeatable\" = 1";
  	
  	List<Object[]> ids = execQuery (qry);
  	for (Object[] id: ids) {
  		Integer myId = (Integer)id[0];
  		theIds += myId.toString()+",";
  	}
  	
  	if (theIds.length() > 0)
  		theIds = theIds.substring(0, theIds.length()-1);
  	return theIds;
  }
  
  
  
/**
 * This method builds up a "ordered" map with the maximum number of repeatable items
 * found for all patients with the interview intrvId and for the section secOrder
 * For instance, if the section of a interview has two repeatable group of questions,
 * and the maximum number of answers for that repeatable group is 4, then 4 groups
 * of questions will appear in the result.
 * It is clear not all patients will have 4 answers for those questions, but we
 * have to take into account the maximum number.
 * @param prjCode the code of the project
 * @param grpId the database id of the group
 * @param intrvId the database id of the interview
 * @param secOrder the order of the section
 * @return a tree map with header values for repeatable items
 */  
  public TreeMap<String,String> getRepeatHeader (String prjCode, Integer grpId,
	                                  Integer intrvId, Integer sortOrder, Integer secOrder) {
  	String repids = getRepeatableItems (prjCode, intrvId, secOrder);
  	String grpParam = (grpId == null? "1=1 ": "g.idgroup = "+grpId);
  	
  	Comparator <String> comparator = 
  		(sortOrder != null && sortOrder == 1)? new InvKeyComparator (): new KeyComparator ();
  	TreeMap<String,String> hdrFields = new TreeMap<String,String> (comparator);
  	List<String> qCodes = new ArrayList<String>();

// if not repeatable items, avoid the rest of the method as I know the result
// of the query is going to be an empty set
  	if (repids.length() == 0)
  		return hdrFields;
  	
  	String qry = 
  		"select distinct on (5,6,4,3) p.codpatient as codpat, " +
  		"q.idquestion as idq, q.codquestion as codq, "+
			"pga.answer_order as aorder, it.item_order as itorder, count (pga.idp_a_q) as numans "+
			",it.ite_iditem as parent " +
			"from item it, question q, pat_gives_answer2ques pga, patient p"+
			",interview i, section s, performance pf, appgroup g " +
			" where (it.iditem in ("+repids+") or it.ite_iditem in ("+repids+")) "+
   		"and it.iditem = q.idquestion "+
   		"and pga.codquestion = q.idquestion "+
   		"and p.idpat = pga.codpat "+
   		"and i.idinterview = "+intrvId +
   		" and pf.codinterview = i.idinterview "+
   		"and s.section_order = "+secOrder+
   		" and s.codinterview = i.idinterview "+
   		"and it.idsection = s.idsection "+
   		"and "+ grpParam +
   		" and pf.codgroup = g.idgroup "+
   		"and pf.codpat = p.idpat "+
   		"group by 1, 2, 3, 4, 5, 7 order by 5 asc, 6 desc, 4 desc, 3";
  	
// got rows like (codpat, idq, codq, aorder, numans, parent)
  	List<Object[]> res = execQuery (qry);
  	
  	
// old algorithm  	
  	for (Object[] row: res) {
  		Integer order = (Integer)row[3], idq = (Integer)row[1];
  		int	num = ((BigInteger)row[5]).intValue();  // num of answers
  		Integer itOrder = (Integer)row[4]; // item order in the section
  		
  		String codq = (String)row [2]; // cod question
  		
// check whether or not the answer is already in the list
//  		if (qCodes.contains(codq))
//  			continue;
  		
// loop to build up the file header
// first, loop over the num of questions, then loop over the order in the questions
// the, build up the field as codq-numans-ord (like K26_1-1-1, K26_1-1-2, or
// K26_1-2-1, K26_1-2-2,..., K26_1-5-1, K26_1-5-2)
// the question id is included in a list of questions to not repeat the process  		
  		
  		for (int n=1; n<=num; n++) { // number
  			for (int o=1; o<=order; o++) { // order
  				String field = codq+"-"+n+"-"+o,
//  						newkey = n+"."+itOrder+"."+codq+"."+o,
  						key = itOrder+"."+n+"."+o;
  				hdrFields.put(key, field);
  			}
  		}
// this is to avoid looping even when the id appeared before
  		qCodes.add(codq);
  		
  	}
/*  	
System.out.println ("hdrFields with TreeMap");
for (Map.Entry<String, String> entry : hdrFields.entrySet()) {
	String akey = entry.getKey().toString();
System.out.print(akey+"|");
}
System.out.println();  	
*/
  	return hdrFields;
  }
  
  
  
  
 /**
  * Similar to method getRepeatableHeader (...) but this method gets only the 
  * questions which does not have repeatable answers
  * @param prjCode the code of the project
  * @param grpId the database id of the group
  * @param intrvId the database id of the interview
  * @param secOrder the order of the section
  * @return a tree map with header values for the entire section
  */
  public TreeMap<String, String> getHeader (String prjCode, Integer grpId,
      								Integer intrvId, Integer sortOrder, Integer secOrder) {
  	
  	String repids = getRepeatableItems (prjCode, intrvId, secOrder);
  	String repIdsConstraint = repids.length() == 0? "and it.ite_iditem is NULL ": 
  														"and (it.ite_iditem not in ("+repids+") or it.ite_iditem is NULL)";
  						
  	String sql = "select q.codquestion as codq, it.item_order as itorder, qa.answer_order "+
  				"from interview i, section s, item it, question q, question_ansitem qa "+
  				"where i.idinterview = "+intrvId+" "+
  				"and s.section_order = "+secOrder+" "+
  				"and s.codinterview = i.idinterview "+
  				"and it.idsection = s.idsection "+
  				"and it.iditem = q.idquestion "+
  				"and it.\"repeatable\" = 0 "+
  				repIdsConstraint +
  				"and q.idquestion = qa.codquestion "+
  				"order by 2";
  	
  	TreeMap<String, String> fullMap;
  	fullMap = (sortOrder != null && sortOrder == 1)?
  				new TreeMap<String,String> (new InvKeyComparator()):
    				new TreeMap<String,String> (new KeyComparator());
  				
  	fullMap.putAll(getRepeatHeader (prjCode, grpId, intrvId, sortOrder, secOrder));
  	
// with the repeatable questions already on the treemap
// now is time for the "simple" questions, which key is done as
// item_order.num_answer.order_answer
  	List<Object[]> res = execQuery (sql);
  	for (Object[] row: res) {
  		String field = (String)row[0]+"-1-"+row[2]; //codq-num-order, num=1
  		fullMap.put((Integer)row[1]+".1."+row[2], field);
  	}
  	
  	return fullMap;
  }
  
  
  
  
	/**
	 * Get the result set with the form 
	 * (0codpatient, 1grpname, 2intrvname, 3secname, 4codq, 
	 * 	5val, 6secorder, 7itemorder, 8ansorder, 9ansnumber, 10rep)
	 * 
	 * 
	 */
  private List<Object[]> getResultSet (String prjCode, Integer intrvId, Integer grpId,
          												Integer secOrder) {
  	String secParam = (secOrder == null)?"s.section_order ": secOrder.toString();
  	String grpParam = (grpId == null? "1=1 ": "g.idgroup = "+grpId);
  	
     String sqlqry = "select p.codpatient, g.name as grpname, "+
        "i.name as intrvname, s.name as secname, "+
      "q.codquestion as codq, a.thevalue, s.section_order, "+
      "it.item_order, pga.answer_order, pga.answer_number, it.\"repeatable\" as itrep "+
      "from patient p, pat_gives_answer2ques pga, appgroup g,	performance pf, "+
        "question q, answer a, interview i, item it, section s, project pj "+
      "where "+ grpParam +
      " and i.idinterview = "+intrvId +
      " and pj.project_code = '"+prjCode+"' " +
      "and pj.idprj = i.codprj "+
      "and pf.codinterview = i.idinterview "+
      "and pf.codgroup = g.idgroup "+
      "and s.codinterview = i.idinterview "+
      "and pf.codpat = p.idpat "+
      "and pga.codpat = p.idpat "+
      "and pga.codquestion = q.idquestion "+
      "and pga.codanswer = a.idanswer "+
      "and q.idquestion = it.iditem "+
      "and it.idsection = s.idsection " +
      "and s.section_order = " + secParam +
      " order by 1, 7, 10, 8, 5, 9";

     List<Object[]> rows = execQuery (sqlqry);
     return rows;
//     dw.writeRows(csvFile, rows);
  }
  
  
  
  
  /**
	 * Write out a file with the interview data from database parametrized by project,
	 * questionnaire, group and sections.
	 * @param prjCode, the project code
	 * @param intrvId, the interview id (can be redundant...)
	 * @param grpId, the group the interviews are going to belong to
	 * @param the section defined by its order in the questionnaire
	 * @param fileName, the name of the file output
	 */
	  public void getDump (String prjCode, Integer intrvId, Integer grpId, 
	  						Integer orderSec, Integer sortOrder, String fileName) 
	  										throws java.io.FileNotFoundException, java.io.IOException {

	  	BufferedWriter fileOut = new BufferedWriter (
	          new OutputStreamWriter (new FileOutputStream (fileName), Charset.defaultCharset()));
	  	TreeMap<String,String> listMap = getHeader (prjCode, grpId, intrvId, sortOrder, orderSec);
	  	
// Simple console output for the itorder.num.order
System.out.println("listMap before buildResult");
for (Map.Entry<String, String> entry : listMap.entrySet()) {
	String key = entry.getKey();
System.out.print(key+"|");
}
System.out.println();


//write file header

	  	String fileHeader = (mapVarNames == null)? dw.writeHeader(listMap):
	  																					dw.writeMappedHdr (listMap, mapVarNames);
// ver si lo que saca con var names y con codes es lo mismo
// primero s—lo con la cabecera y 
// luego probar con varias secciones y pa’ses
			if (fileHeader == null) {
				System.out.println("An error was found when getting variable names from file");
				System.out.println("Try again without supplying a variable names file");
			}
			else {
				System.out.println ("Writing file header as:");
				System.out.println(fileHeader);
				
		  	fileOut.append (fileHeader);
		  	fileOut.flush();
		  	
		  	List<Object[]> resultSet = getResultSet (prjCode, intrvId, grpId, orderSec);

		  	dw.buildResultSet(listMap, resultSet, fileOut);
			}
	    fileOut.close(); 
	  }
  
	  
	  
  
  /**
   * Interface method to get a dump from project, interview, group names, not ids
   * @param prjName, the name of the project
   * @param intrvName, the name of the interview
   * @param grpName, the name of the group
   * @param orderSec, the section
   * @param fileName, the fileName
   */
	  public void getDump (String prjName, String intrvName, String grpName, 
	  										Integer orderSec, Integer sortOrder, String fileName) 
	  										throws java.io.FileNotFoundException, java.io.IOException {
	  	String prjCode = "";
	  	Integer intrvId, grpId;
	  	
	  	Project prj = null;
	  	Interview intrv = null;
	  	AppGroup grp = null;
	  	
	  	Session hibSes = HibernateUtil.getSessionFactory().openSession();
	  	List<Project> prjs = HibernateUtil.getProjectByName(hibSes, prjName);
	  	if (prjs != null && prjs.size() > 0) {
	  		prj = prjs.get(0);
	  		IntrvController intrvCtrl = new IntrvController (hibSes);
	  		
	  		List<Interview> intrvs = intrvCtrl.getIntr4Proj(prj, intrvName);
	  		if (intrvs != null && intrvs.size() > 0)
	  			intrv = intrvs.get(0);
	  	}
	  	AppUserCtrl usrCtrl = new AppUserCtrl (hibSes);
	  	grp = usrCtrl.getGroupFromName(grpName);
	  	if (hibSes.isOpen())
	  		hibSes.close();
	  	
	  	if (prj == null) {
	  		System.err.println ("A project named '"+prjName+"' was not found");
	  		return;
	  	}
	  	
	  	if (intrv == null) {
	  		System.err.println ("An interview named '"+intrvName+"' for project " +
	  				"'"+prjName+"' was not found");
	  		return;
	  	}
	  	/*
	  	if (grp == null) {
	  		System.err.println ("An group named '"+grpName+"' was not found");
	  		return;
	  	}
	  	*/
	  	prjCode = prj.getProjectCode();
	  	intrvId = intrv.getId();
	  	grpId = grp != null? grp.getId(): null;
	  	
	  	getDump (prjCode, intrvId, grpId, orderSec, sortOrder, fileName);
	  	
	  }
	  
	  
	/*  
	  public void getDump (String prjCode, Integer grpId,
		                                  Integer intrvId, Integer secOrder) 
	  											throws java.io.IOException {
	  	TreeMap <String,String> list = getHeader (prjCode, grpId, intrvId, secOrder);
	  	System.out.println(dw.writeHeader(list));
	  		
	  	List<Object[]> resultSet = getResultSet ("157", 50, 304, 8);
	  	dw.buildResultSet(list, resultSet, null);
	  	
	  }
	*/ 
	  
	  

}

