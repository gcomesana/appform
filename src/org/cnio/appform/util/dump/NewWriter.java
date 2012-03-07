package org.cnio.appform.util.dump;

import java.io.BufferedWriter;
import java.util.regex.Pattern;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.LinkedHashMap;
import java.util.Hashtable;

public class NewWriter {
	
  private final String CSV_SEP = "|";
//  private Regex regexNum = new Regex ("(\\d+)")
//	  private val regexLab = new Regex ("^[a-zA-Z]+[\\w|\\p{Punct}]+$")
//  private val regexLab = new Regex ("(\\D+)")

  private String regexNum = "(\\d+)";
  private String regexDec = "(-?\\d+[\\.\\d+])";
  private String regexLab = "(\\D+)";
  
  private Hashtable mapNames;
  
  public NewWriter (Hashtable map) {
  	mapNames = map;
  }
  
  
/**
 * Writes out the header for the csv file. The fields are not determined and
 * as a guard to stop writing out is set as the change of patient code (or the end of
 * rowset).
 * @param rows the whole rowset.
 */
  public String writeHeader (List<Object[]> rows) {
    // This is ONLY for the header
     StringBuilder out = new StringBuilder ();
     Object[] aRow = rows.get(0);
     String patRef = (String)aRow[0];

// System.out.println ("Writing file header as:");
out.append("subject"+CSV_SEP+"group"+CSV_SEP+"interview"+CSV_SEP+"section"+CSV_SEP);
     Object[] innRow = aRow;
    for (Object[] row: rows) {
// System.out.println ("codques: "+innRow[4]);
      innRow = row;
      if (((String)innRow[0]).equalsIgnoreCase(patRef))
        out.append(innRow[4]+CSV_SEP);
    }
    out.setCharAt(out.length()-1, '\n');

    return out.toString();
  }

  
  
/**
 * Build up a custom csv header file from a map. Each of the TreeMap keys have
 * the form of itemOrder.codQ-ansNum-ordNum. itemOrder is there to keep the 
 * order of the questionnaires, but it is removed when yielding the file header
 * @param rows, actually it is a map with values = ""
 * @return a string which will be the header of the csv file
 */
  public String writeHeader (TreeMap<String,String> rows) {
    // This is ONLY for the header
     StringBuilder out = new StringBuilder ();
     
// System.out.println ("Writing file header as:");
out.append("subject"+CSV_SEP+"group"+CSV_SEP+"interview"+CSV_SEP+"section"+CSV_SEP);
		for (Map.Entry<String, String> entry : rows.entrySet()) {
//		    System.out.println(entry.getKey() + "/" + entry.getValue());
			String val = entry.getValue();
//		    out.append(entry.getKey()+CSV_SEP);
			out.append(val+CSV_SEP);
		} 
    out.setCharAt(out.length()-1, '\n');

    return out.toString();
  }
  
  
  public String writeHeader (LinkedHashMap<String,String> rows) {
    // This is ONLY for the header
    StringBuilder out = new StringBuilder ();
    
//System.out.println ("Writing file header as:");
out.append("subject"+CSV_SEP+"group"+CSV_SEP+"interview"+CSV_SEP+"section"+CSV_SEP);
		for (Map.Entry<String, String> entry : rows.entrySet()) {
//		    System.out.println(entry.getKey() + "/" + entry.getValue());
			String val = entry.getValue();
//		    out.append(entry.getKey()+CSV_SEP);
			out.append(val+CSV_SEP);
		} 
   out.setCharAt(out.length()-1, '\n');

   return out.toString();
  }
  
  
  

/**
 * Gets the varname which is going to be in the file header.
 * The variable names are the values of the hashtable, whereas the keya are like
 * a qCode, XXXX-N-O, where N=1. The qCode param here is a normal question code,
 * but it can have N > 1 when repeatable questions. Then, in order to accomodate
 * the new variable names with repeatable questions, the N part of the variable
 * name has to be the same that is in the qCode parameter
 * COMPARISON IS CASE-INSENSITIVE (SO K14A-1-1==K14a-1-1)
 * 
 * @param qCode, the question code like XXXX-N-O, where XXXX is the true question
 * code as defined in the form builder
 * @param vars, the hashtable for the variable names, where the keys are like
 * XXXX-1-O, XXXX the question code as explained above
 * @return the variable name to be placed in the file header
 */
  private String getRightVarName (String qCode, Hashtable<String,String> vars) {
// first: convert qCode like I3a_1-2-2 into I3a_1-1-2
  	String parts[] = qCode.split("-");
  	String numAnswer = parts[1];
  	qCode = parts[0]+"-1-"+parts[2];
  	
  	String varname = vars.get(qCode);
  	
// this is to prevent exceptions. As the variable names file is read working around
// malformed lines, it can be a question code without variable name (there are no
// such a pair in the hashtable). then, when looking up the hashtable, the returned
// value gets null
  	if (varname == null) {
  		System.err.println("No variable name for '"+qCode+"'");
  		return null;
  	}
  	parts = varname.split("-");
//  	varname = parts[0]+"-"+numAnswer+"-"+parts[2];
  	if (Integer.decode(numAnswer) == 1)
  		varname = parts[0];
  	else
  		varname = parts[0]+"-"+numAnswer;
  	
  	return varname;
  }
  
  
  
/**
 * Build up a custom csv header file based on a treemap (which keeps the fields in
 * the appropriate order) and a hash to map the codes in the treemap into the
 * corresponding variable names and loaded from a file
 * @param rows, this one represents the ordered set of question codes
 * @param mapVars, a hashtable with the mapping between the question codes and
 * the variable names.
 * @return the header of the csv file where the field labels are modified variable
 * names
 */
  public String writeMappedHdr (TreeMap<String,String> rows, Hashtable<String,String> mapVars) {
  	StringBuilder out = new StringBuilder ();
    
//  	System.out.println ("Writing file header as:");
  	out.append("subject"+CSV_SEP+"group"+CSV_SEP+"interview"+CSV_SEP+"section"+CSV_SEP);
  	
  	for (Map.Entry<String, String> entry : rows.entrySet()) {
  		String val = entry.getValue();
  		String varName = getRightVarName (val, mapVars);
  		val = (varName == null? val: varName);
  		if (val == null)
  			return null;
  			
  		out.append(val+CSV_SEP);
  	}
  	out.setCharAt(out.length()-1, '\n');
  	
  	return out.toString();
  }
  
  
  
  
  public String writeMappedHdr (LinkedHashMap<String,String> rows, Hashtable<String,String> mapVars) {
  	StringBuilder out = new StringBuilder ();
    
//  	System.out.println ("Writing file header as:");
  	out.append("subject"+CSV_SEP+"group"+CSV_SEP+"interview"+CSV_SEP+"section"+CSV_SEP);
  	
  	for (Map.Entry<String, String> entry : rows.entrySet()) {
  		String val = entry.getValue();
  		String varName = getRightVarName (val, mapVars);
  		val = (varName == null? val: varName);
  		if (val == null)
  			return null;
  			
  		out.append(val+CSV_SEP);
  	}
  	out.setCharAt(out.length()-1, '\n');
  	
  	return out.toString();
  }
  

  

  public void writeRows (BufferedWriter file, List<Object[]> rows) throws java.io.IOException {

     StringBuilder out = new StringBuilder ();
     String patRef = "";
System.out.println ("Writing out rows ("+rows.size()+" rows)");
			

    for (Object[] aRow: rows) {
    	Object[] innRow = aRow;
    	String grpName = "", intrvName = "", secName = "";
    	
      if (((String)innRow[0]).equalsIgnoreCase(patRef) == false) {
  //finish the previous subject and start the next one (if so)
        if (out.length() != 0) {
//            out.replace(out.size-3, out.size, "\n")
//          out.setCharAt(out.length()-1, '\n');
//            print (out.toString)
//        	out.deleteCharAt(out.length()-1);
        	out.setCharAt(out.length()-1, '\n');
          file.write(out.toString());
          file.flush();
          out.delete(0, out.length());
        }
        
        patRef = (String)innRow[0];
        grpName = (String)innRow[1];
        intrvName = (String)innRow[2];
        secName = (String)innRow[3];

        out.append(patRef+CSV_SEP);
        out.append("\""+grpName+"\""+CSV_SEP);
        out.append("\""+intrvName+"\""+CSV_SEP);
        out.append("\""+secName+"\""+CSV_SEP);
      } // eo new patient detected

      String ansVal = (String)innRow[5];
      
      if (Pattern.matches(regexLab, ansVal))
      	ansVal = "\""+ansVal+"\"";
      
      
      out.append(ansVal+CSV_SEP);
    }

    System.out.println ();
    file.write(out.toString());
    file.flush();
  }
  
  
  
  
/**
 * This method writes out the results in the file in the correct place, which is,
 * matching with the file header (it means, matching answers with questions)
 * @param codes
 * @param rs
 * @param file
 */
  public void buildResultSet (TreeMap<String,String> codes, List<Object[]> rs,
  														BufferedWriter file) throws java.io.IOException {
  	
  	StringBuilder out = new StringBuilder ();
  	String patRef = "";
  	int countPats = 0;
  	
  	
// As the treemap is going to be used and it is the same than used when 
// yielding the header, it is better clear the values
  	for (Map.Entry<String, String> entry : codes.entrySet()) 
  	  codes.put(entry.getKey(), "");
  	
  	
// loop over the resultset  	
  	for (Object[] row: rs) {
  		Object[] innRow = row;
    	String grpName = "", intrvName = "", secName = "";
    	
      if (((String)innRow[0]).equalsIgnoreCase(patRef) == false) {
//finish the previous subject and start the next one (if so)
        if (out.length() > 0) { // spit everything
        	
        	for (Map.Entry<String, String> entry : codes.entrySet()) {
        	  out.append(entry.getValue()+CSV_SEP);
        	  codes.put(entry.getKey(), "");
        	}

        	out.setCharAt(out.length()-1, '\n');
// System.out.println(out.toString());
					if (file != null) {
						file.append(out.toString());
	          file.flush();
					}
					countPats++;
          out.delete(0, out.length());
        }
        patRef = (String)innRow[0];
        grpName = (String)innRow[1];
        intrvName = (String)innRow[2];
        secName = (String)innRow[3];

        out.append(patRef+CSV_SEP);
        out.append("\""+grpName+"\""+CSV_SEP);
        out.append("\""+intrvName+"\""+CSV_SEP);
        out.append("\""+secName+"\""+CSV_SEP);
      } // eo new patient detected

      String ansVal = (String)innRow[5], codq = (String)innRow[4];
      Integer num = (Integer)innRow[9], ord = (Integer)innRow[8]; 
      Integer itOrd = (Integer)innRow[7];
//      String keyField = itOrd+"."+codq+"-"+num+"-"+ord;
      String keyField = itOrd+"."+num+"."+ord;
      String newkeyField = num+"."+itOrd+"."+codq+"."+ord;
      
      
      if (Pattern.matches(regexLab, ansVal))
      	ansVal = "\""+ansVal+"\"";
      
      if (codes.containsKey(keyField))
      	codes.put(keyField, ansVal);
      else
      	System.err.println("No key for question: "+keyField);
      
//      out.append(ansVal+CSV_SEP);
    } // EO for row
  	
  	
// here i have to write the very last subject retrieved
  	if (out.length() > 0) { // spit everything
    	
    	for (Map.Entry<String, String> entry : codes.entrySet()) {
    	  out.append(entry.getValue()+CSV_SEP);
    	  codes.put(entry.getKey(), "");
    	}

    	out.setCharAt(out.length()-1, '\n');
//System.out.println(out.toString());
			if (file != null) {
				file.append(out.toString());
        file.flush();
			}
			countPats++;
    }
  	System.out.println ("Total subjects collected: "+countPats);
  }
}
