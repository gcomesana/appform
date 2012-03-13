package org.cnio.appform.util.dump;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintStream;
import java.util.Hashtable;

public class DBDump
{
  public static final String QRY_NORMAL = "normal";
  public static final String QRY_TOTALS = "totals";
  public static final String QRY_ALL_TOTALS = "alltotals";
  public static final String QRY_QUES_TOTALS = "questotals";
  private String prjName = "";
  private String intrvName = "";
  private String grpName = "";
  private Integer orderSec = Integer.valueOf(-1);
  private String[] codQues = new String[64];
  private String qryType = "normal";
  private String fileName = "";
  private int sortOrd = 0;

  private int fileErr = 0;
  private Hashtable<String, String> varsmap; // in the case a variable names file is provided
  private final String VARS_SEP = ";";
  private final int ERR_FNF = 1;

  public static String PATH_2_DUMP = "/Users/bioinfo/Development/Projects/appform/custom-dumps";

  public DBDump (String prj, String intrv, String grp, Integer orderSec, Integer sortOrder, String qCodes, String qrytype, String file, String fileVars)
  {
    this.prjName = prj;
    this.intrvName = intrv;
    this.grpName = grp;
    this.orderSec = orderSec;
    this.sortOrd = sortOrder.intValue();
    this.fileName = file;
    this.qryType = qrytype;
    this.codQues = qCodes.split(",");

    this.varsmap = buildMap(fileVars);
  }
  

  
  public DBDump(String fileVars) {
    if ((fileVars != null) && (fileVars.length() > 0))
      this.varsmap = buildMap(fileVars);
  }

  
  
  public DBDump() {
  
  }

  
  
  
 /**
  * Build a map with the variable names file if provided
  * @param filename, the variable names file name
  * @return a map with the mapping defined in the variable names file
  */ 
  private Hashtable<String, String> buildMap(String filename) {
    Hashtable map = new Hashtable();
    int order = 1;
    
    try {
      BufferedReader reader = new BufferedReader(new FileReader(filename));
      String line = reader.readLine(); String oldQCode = "";

      line = reader.readLine();
      while (line != null) {
        String[] pair = line.split(";");

        if (pair.length < 2) {
          line = reader.readLine();
        }
        else {
          if ((pair[0].equals("")) || (pair[1].equals(""))) {
            return null;
          }

          order = (pair[0].equalsIgnoreCase(oldQCode)) ? order + 1 : 1;
          String pairKey = pair[0] + "-1-" + order;
          String pairVal = pair[1] + "-1-" + order;
          map.put(pairKey, pairVal);

          oldQCode = pair[0];
          line = reader.readLine();
        }
      }
    }
    catch (FileNotFoundException fnfEx) {
      this.fileErr = 1;
      return null;
    }
    catch (IOException ioEx) {
      return null;
    }

    return map;
  }

  
  
  
  public Hashtable<String, String> getVarsmap() {
    return this.varsmap;
  }

  
  public void setVarsMap(String fileVars) {
    if ((fileVars != null) && (fileVars.length() > 0)) {
      this.varsmap.clear();
      this.varsmap = buildMap(fileVars);
    }
  }

  public void setPrjName(String prjName) {
    this.prjName = prjName;
  }

  public void setIntrvName(String intrvName) {
    this.intrvName = intrvName;
  }

  public void setGrpName(String grpName) {
    this.grpName = grpName;
  }

  public String[] getCodQues() {
    return this.codQues;
  }

  public void setCodQues(String codQues) {
    this.codQues = codQues.split(",");
  }

  public String getQryType() {
    return this.qryType;
  }

  public void setQryType(String qryType) {
    this.qryType = qryType;
  }

  public void setOrderSec(Integer orderSec) {
    this.orderSec = orderSec;
  }

  public void setFileName(String fileName) {
    this.fileName = fileName;
  }
  

  public void spitInfo() {
    String questions = "";
    System.out.println("Getting data with parameters:");
    System.out.println("\tProject: " + this.prjName);
    System.out.println("\tQuestionnaire: " + this.intrvName);
    System.out.println("\tGroup: " + this.grpName);
    System.out.println("\tSection: " + this.orderSec);
    System.out.println("\tQuery type: " + this.qryType);
    
    if (this.codQues.length > 0) {
      for (int i = 0; i < this.codQues.length; ++i) {
        questions = questions + this.codQues[i] + ",";
      }
      questions = questions.substring(0, questions.length() - 1);
      System.out.println("\tQuestions: " + questions);
    }

    System.out.println("\tOutput file: " + this.fileName);
    if ((this.varsmap == null) || (this.varsmap.size() == 0))
      System.out.println("No Variable Names file provided");
  }

  
  
  
  public int dump() {
    DataRetriever retriever = new DataRetriever(PATH_2_DUMP, this.varsmap);
    try {
      spitInfo();

      if (this.qryType.equalsIgnoreCase("totals")) {
        retriever.getTotals(this.fileName);
      }
      
      if (this.qryType.equalsIgnoreCase("alltotals")) {
        retriever.getAllTotals(this.fileName);
      }
      
      if (this.qryType.equalsIgnoreCase("normal") || this.qryType.length() == 0) {
      	String prjName = this.prjName;
      	String intrvName = this.intrvName;
      	String grpName = this.grpName;
      	int orderSec = this.orderSec;
      	int sortOrd = Integer.valueOf(this.sortOrd);
      	String myFilename = this.fileName;
      	
        retriever.getDump(prjName, intrvName, grpName, orderSec, sortOrd, myFilename);
      }
      
      if (this.qryType.equalsIgnoreCase("questotals"))
        retriever.getQuestionTotals(this.fileName, this.prjName, this.intrvName, this.codQues);
    }
    catch (FileNotFoundException ex) {
      System.err.println("The directory to store the dump file does not exists");
      return -1;
    }
    catch (IOException ioEx) {
      System.err.println(ioEx.getMessage());
      return -2;
    }

    return 0;
  }
  
}