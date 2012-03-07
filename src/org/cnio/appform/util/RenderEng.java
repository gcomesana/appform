package org.cnio.appform.util;

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
import org.hibernate.Session;

/**
 * This inner class contains methods to render the questions and answers in a
 * correct way
 * 
 * @author willy
 * 
 */
public class RenderEng {

  private StringBuffer htmlStr = null;
  private Logger myLogger;

  private int preview;

  private int realtime;

  public static final String MISSING_ANSWER = "9999";

  public static final String ITRTD = "<tr><td>";
  public static final String ITRTD_STMT = "<tr><td class=\"upperBorder\">";
  public static final String ITRTD_QUE = "<tr><td class=\"lowerBorder\">";
  public static final String ETRTD = "</td></tr>";

  public static final String ONFOCUS = "intrvFormCtrl.onFocus";
  private String highIni, highEnd;

  public RenderEng() {
    htmlStr = new StringBuffer();
    highIni = "";
    highEnd = "";

    realtime = 0;
  }

  public RenderEng(int rt) {
    this();

    realtime = rt;
  }

  /**
   * Gets all items inside a section
   * 
   * @param hibSes
   *          , the session to perform the transactions
   * @param sec
   *          , the section whose items are gonna be retrieved
   */
  public void viewSection(Session hibSes, Section sec) {
    // i get all items for the section
    // ii if the item is a text, print the text
    /*
     * iii if the item is a question iv print the content v check if it is a
     * grouping question vi if so, get the items for the question and go back ii
     * vii else, print content and render answer as set on the answer item
     */
    LogFile.display(sec.getName());
    LogFile.display(sec.getDescription());

    Collection<AbstractItem> items = HibernateUtil.getContainers4Section(
        hibSes, sec);
    Iterator<AbstractItem> itItem = items.iterator();
    LogFile.display("num of containers in section: " + items.size());
    while (itItem.hasNext()) {
      AbstractItem anItem = itItem.next();
      renderItem(hibSes, anItem);
    }
  }

  public void clearHtmlStr() {
    if (htmlStr == null)
      htmlStr = new StringBuffer();
    else
      htmlStr.delete(0, htmlStr.length());
  }

  public String getHtmlStr() {
    return htmlStr.toString();
  }

  private void addHtmlStr(String html) {
    htmlStr.append(html + "\n");
  }

  private void initLog() throws java.io.IOException {
    myLogger = Logger.getLogger(RenderEng.class.getName());

    myLogger.setLevel(Level.DEBUG);
    /*
     * Instantiate a layout and an appender, assign layout to appender
     * programmatically
     */
    SimpleLayout myLayout = new SimpleLayout();
    Appender myAppender = new FileAppender(myLayout, "appform.log"); // Appender
                                                                     // is
    // Interface
    /* Assign appender to the logger programmatically */
    myLogger.addAppender(myAppender);

    System.setOut(new PrintStream(new BufferedOutputStream(
        new FileOutputStream("appform.log"))));
  }

  /**
   * This method set the private members to properly render the text
   * 
   * @param highlight
   *          , the value to translate the highlight
   */
  private void setHighlight(int highlight) {
    switch (highlight) {
    case AbstractItem.HIGHLIGHT_BOLD:
      highIni = "<b>";
      highEnd = "</b>";
      break;
    case AbstractItem.HIGHLIGHT_ITALIC:
      highIni = "<i>";
      highEnd = "</i>";
      break;
    case AbstractItem.HIGHLIGHT_UNDERLINE:
      highIni = "<u>";
      highEnd = "</u>";
      break;
    case AbstractItem.HIGHLIGHT_ITABOLD:
      highIni = "<i><b>";
      highEnd = "</b></i>";
      break;
    case AbstractItem.HIGHLIGHT_UNDERBOLD:
      highIni = "<u><b>";
      highEnd = "</b></u>";
      break;
    case AbstractItem.HIGHLIGHT_UNDERITAL:
      highIni = "<u><i>";
      highEnd = "</i></u>";
      break;
    case AbstractItem.HIGHLIGHT_FULL:
      highIni = "<b><i><u>";
      highEnd = "</u></i></b>";
      break;

    case AbstractItem.HIGHLIGHT_NORMAL:
    default:
      highIni = "";
      highEnd = "";
      break;
    }
  }

  /**
   * Print the html code for an item, considering its children questions if so
   * 
   * @param hibSes
   * @param ai
   *          , the item (and its children) which is gonna be rendered
   * @param patId
   *          , the patient id (necessary to get the answers)
   * @param intrCtrl
   *          , the controller of the interview to get the answers
   */
  public void html4Item(Session hibSes, AbstractItem ai, Integer patId,
      IntrvFormCtrl intrCtrl) {

    if (ai.getContainees().size() > 0) {
      // Print the parent with its id inside a span tag, get its children and
      // in the case of repeteativity, render its questions separately

      if (ai instanceof Question) {
        int numOfAnswers = intrCtrl.getNumOfAnswers((Question) ai, patId);
        if (numOfAnswers == 0)
          renderQuestion(hibSes, ai);

        else
          // The code contained in the method is exactly what would be here
          renderAnswersPat(hibSes, ai, numOfAnswers, patId, intrCtrl);

        addHtmlStr(ITRTD);
      }
      else {
        setHighlight(ai.getHighlight());
        addHtmlStr(ITRTD + "<span id=\"t" + ai.getId() + "\">" + highIni
            + StringEscapeUtils.escapeHtml(ai.getContent()) + highEnd
            + "</span><br>" + ETRTD);
        addHtmlStr(ITRTD);
      }
      // addHtmlStr("<table bgcolor=\"lightgray\" id=\"t"+ai.getId()+"-children\">");

      if (ai.getRepeatable() != null && ai.getRepeatable() == 1) {
        List<AbstractItem> containees = HibController.ItemManager
            .getOrderedContainees(hibSes, ai);

        renderChildren(hibSes, intrCtrl, ai, containees, patId);
        addHtmlStr(ETRTD
            + "<tr><td align=\"right\"><input type=\"button\" value=\" + \""
            + " name=\"btn-t" + ai.getId() + "\" id=\"btn-t" + ai.getId()
            + "\"" + "	onclick = \"ctrl.addElem('t" + ai.getId() + "')\">");
        addHtmlStr("&nbsp;<input type=\"button\" value=\" - \""
            + " name=\"btn-t" + ai.getId() + "\" id=\"btn-t" + ai.getId()
            + "\"" + "	onclick = \"ctrl.rmvElem('t" + ai.getId() + "')\">");

        addHtmlStr("</td></tr></table>");

        return;
      }
      else
        addHtmlStr("<table bgcolor=\"#FFCC99\" id=\"t" + ai.getId()
            + "-children\">");
    }

    else if (ai.getContainees().size() == 0)
      renderSingleItem(hibSes, ai, patId, intrCtrl);

    else {
      // Caso imposible
      System.out.print("ERROR: Not implemented case -&gt: "
          + StringEscapeUtils.escapeHtml(ai.getContent()) + "<br>");
    }

    Collection<AbstractItem> items = HibController.ItemManager
        .getOrderedContainees(hibSes, ai);
    // LogFile.stderr("num of containees for " +item.getId()+": "+items.size());
    if (items != null && !items.isEmpty()) {
      Iterator<AbstractItem> itItem = items.iterator();
      while (itItem.hasNext())
        html4Item(hibSes, itItem.next(), patId, intrCtrl);

      addHtmlStr(ETRTD + "</table>");
    }
  }

  
  
  /**
   * Renders a question with some answer items already in the database.
   * As there are questions with several answers (repeatable), it is necessary
   * get one answer every time (as the answer can be multiple) in order to do 
   * the right render
   * 
   * @param hibSes, the hibernate session
   * @param ai, the abstract item
   * @param numOfAnswers, the numOf answers (necessary for the multiple answers case)
   * @param patId, the patient id
   * @param intrCtrl, the controller of the interview
   */
  private void renderAnswersPat(Session hibSes, AbstractItem ai,
    int numOfAnswers, Integer patId, IntrvFormCtrl intrCtrl) {
    int numAns = 1;

    List<Object[]> answers = 
          intrCtrl.getAnswers(((Question) ai).getId(), patId, numAns);
    
    while (answers != null && answers.size() > 0) {
      List<AnswerItem> cai = HibernateUtil.getAnswerTypes4Question (hibSes, ai);

      // if (cai.size() > 1) // question with several answers
      setHighlight(ai.getHighlight() == null ? 0 : ai.getHighlight());
      addHtmlStr(ITRTD + highIni
          + StringEscapeUtils.escapeHtml(ai.getContent()) + highEnd + ETRTD);
      // The answeritems are retrieved in the correct order
      int orderCai = 1;
      String inputVal; // this is the value retrieved from database
      String numQuestion = "1"; // this is the number of question as in a list
      String inputName;
      // The list of patterns for this question, if any
      List<QuestionsAnsItems> lQai = HibController.ItemManager.getPatterns(
          hibSes, (Question) ai);
      addHtmlStr(ITRTD);

      for (AnswerItem ansi : cai) {
        // get the answer for this question...
        Object[] answer = null;
        if (answers != null) {
          // This is proficiency: to avoid errors when a question is modified
          // Concurrent changes are not allowed
          try {
            answer = answers.get(orderCai - 1);
          }
          catch (IndexOutOfBoundsException ex) {
            answer = null;
          }
        }

        inputVal = (answer != null) ? (String) answer[1] : "";
        inputVal = (inputVal.equalsIgnoreCase(RenderEng.MISSING_ANSWER)) ? ""
            : inputVal;
        numQuestion = (answer != null) ? Integer.toString(((Integer) answer[2])
            .intValue()) : "1";

        if (ansi instanceof AnswerType) { // simple answer (label, number,
          // decimal)
          AnswerType anst = (AnswerType) ansi;
          String maxLen = "maxlength=\"", maxSize = "size=\"";
          if (ansi.getName().equalsIgnoreCase("number")
              || ansi.getName().equalsIgnoreCase("decimal")) {
            maxLen += "10\"";
            maxSize += "6\"";
          }
          else {
            maxLen += "4192\"";
            maxSize += "24\"";
          }
          // the name of the answer will be like q154-1-1, 154 idquesion
          // the first 1 answer number (to allow repetitivity, next one will be
          // 2)
          // and the last 1 is the answer order besides, we gotta check the
          // value...
          inputName = "q" + ai.getId() + "-" + numQuestion + "-" + orderCai;

          addHtmlStr("&nbsp;<input type=\"text\" name=\"" + inputName
              + "\" id=\"" + inputName + "\" " + maxLen + " " + maxSize
              + " value=\"" + inputVal + "\"");
          // This is to check numbers
          String[] ranges = { "-", "-", "-" };
          String datatype;
          if (ansi.getName().equalsIgnoreCase("number")) {
            String pattern = lQai.remove(0).getPattern();

            if (pattern != null)
              ranges = pattern.split(";");

            datatype = "N";

          }

          else if (ansi.getName().equalsIgnoreCase("decimal")) {
            String pattern = lQai.remove(0).getPattern();
            // String[] ranges = {"-", "-", "-"};

            if (pattern != null)
              ranges = pattern.split(";");

            datatype = "D";
          }
          else
            datatype = "L";
          /*
           * addHtmlStr
           * (" onblur=\"event.stopPropagation();intrvFormCtrl.onBlur(this.name)\""
           * ); addHtmlStr (" onblur=\"event.stopPropagation();" +
           * "intrvFormCtrl.sendItem('L', this)\"");
           */
          // Add the onblur event depending on the datatype and the realtime
          // switch
          // System.out.println("renderAnswersPat: realtime="+realtime);
          if (realtime == 0) {
            if (datatype.equalsIgnoreCase("L"))
              addHtmlStr(" onblur=\"event.stopPropagation();intrvFormCtrl.onBlur(this.name)\"");

            else if (datatype.equalsIgnoreCase("N"))
              addHtmlStr(" onblur=\"event.stopPropagation();intrvFormCtrl.chkNumber(this, '"
                  + ranges[0] + "', '" + ranges[1] + "', '" + ranges[2] + "')\"");

            else
              addHtmlStr(" onblur=\"event.stopPropagation();intrvFormCtrl.chkDecimal(this, '"
                  + ranges[0] + "', '" + ranges[1] + "', '" + ranges[2] + "')\"");
          }
          else {
            if (datatype.equalsIgnoreCase("L"))
              addHtmlStr(" onblur=\"event.stopPropagation();"
                  + "intrvFormCtrl.sendItem('L', this)\"");
            else
              addHtmlStr(" onblur=\"event.stopPropagation();"
                  + "intrvFormCtrl.sendItem('" + datatype + "', this, '"
                  + ranges[0] + "', '" + ranges[1] + "', '" + ranges[2]
                  + "')\"");
          }

          addHtmlStr(" onfocus=\"intrvFormCtrl.onfocus(this.name)\"");
          if (((Question) ai).getMandatory() == 1)
            addHtmlStr(" must=\"1\"");

          addHtmlStr(" />");
        }

        else if (ansi instanceof EnumType) {
          String sel = "selected=\"selected\"";
          List<EnumItem> ceni = HibController.EnumTypeCtrl.getEnumItems(hibSes,
              (EnumType) ansi);
          String selName = "q" + ai.getId() + "-" + numQuestion + "-"
              + orderCai, htmlPiece;
          // Render de <select ...> tag
          htmlPiece = "&nbsp;<select name=\"" + selName + "\" " + "id=\""
              + selName + "\" style=\"width:150px;\"";
          if (realtime == 0)
            htmlPiece += " onblur=\"intrvFormCtrl.onBlur(this.name)\" ";
          else
            htmlPiece += " onblur=\"intrvFormCtrl.sendItem('S', this)\" ";

          if (((Question) ai).getMandatory() == 1)
            htmlPiece += "must=\"1\" ";

          htmlPiece += "onfocus=\"intrvFormCtrl.onfocus(this.name)\">";

          addHtmlStr(htmlPiece);

          // Render the <option ...> tag inside the <select ...> tag
          addHtmlStr("<option value=\"" + RenderEng.MISSING_ANSWER
              + "\"> </option>");
          for (EnumItem eni : ceni) {
            if (eni.getValue().equalsIgnoreCase(inputVal))
              addHtmlStr("<option value=\"" + eni.getValue() + "\" " + sel
                  + " >" + StringEscapeUtils.escapeHtml(eni.getName())
                  + "</option>");
            else
              addHtmlStr("<option value=\"" + eni.getValue() + "\">"
                  + StringEscapeUtils.escapeHtml(eni.getName()) + "</option>");
          }

          addHtmlStr("</select>");
        }
        else {
          addHtmlStr("ERROR: Not implemented case -&gt: "
              + StringEscapeUtils.escapeHtml(ansi.getName()) + "<br>");
        }

        if (orderCai < cai.size()) {
          addHtmlStr("&nbsp;-&nbsp;");
          orderCai++;
        } /*
           * else System.out.println (ETRTD);
           */
      } // end of num of answersItems loop

      if (((Question) ai).getRepeatable().intValue() == 1
          && numOfAnswers == numAns && ai.getContainees().size() == 0) {
        String plusBtn = "<input type=\"button\" name=\"btn-q" + ai.getId()
            + "-" + numQuestion + "-" + orderCai + "\" id=\"btn-q" + ai.getId()
            + "-" + numQuestion + "-" + orderCai + "\" ";
        plusBtn += " onclick=\"ctrl.addElem('q" + ai.getId() + "-"
            + numQuestion + "-" + orderCai + "');\" " + "value = \"+\"/>";

        addHtmlStr("\n");
        addHtmlStr(plusBtn);
      }

      numAns++;
      answers = intrCtrl.getAnswers(((Question) ai).getId(), patId, numAns);
    } // EO while (answers != null...

  }

  /**
   * Renders a question which doesent still have any answer (which implies
   * nothing about it is in the database)
   * 
   * @param hibSes
   *          , the hibernate session
   * @param ai
   *          , the question itself
   */
  private void renderQuestion(Session hibSes, AbstractItem ai) {

    List<AnswerItem> cai = HibernateUtil.getAnswerTypes4Question(hibSes, ai);
    // addHtmlStr ("*** renderQuestion: "+ai.getContent());
    // if (cai.size() > 1) // question with several answers
    if (ai.getHighlight() != null)
      setHighlight(ai.getHighlight());
    addHtmlStr(ITRTD + highIni + StringEscapeUtils.escapeHtml(ai.getContent())
        + highEnd + ETRTD);
    // The answeritems are retrieved in the correct order
    int orderCai = 1;
    addHtmlStr(ITRTD);
    String inputVal;
    String numQuestion = "1";
    String inputName;

    // The list of patterns for this question, if any
    List<QuestionsAnsItems> lQai = HibController.ItemManager.getPatterns(
        hibSes, (Question) ai);
    for (AnswerItem ansi : cai) {

      inputVal = "";
      numQuestion = "1";
      if (ansi instanceof AnswerType) { // simple answer (label,
        // number)
        AnswerType anst = (AnswerType) ansi;
        String maxLen = "maxlength=\"", maxSize = "size=\"";
        if (ansi.getName().equalsIgnoreCase("number")
            || ansi.getName().equalsIgnoreCase("decimal")) {
          maxLen += "10\"";
          maxSize += "6\"";
        }
        else {
          maxLen += "4192\"";
          maxSize += "31\"";
        }
        // the name of the answer will be like q154-1-1, 154 idquesion
        // the first 1 answer number (to allow repetitivity, next one will be 2)
        // and the last 1 is the answer order besides, we gotta check the
        // value...
        // besides, we gotta check the value...
        inputName = "q" + ai.getId() + "-" + numQuestion + "-" + orderCai;
        addHtmlStr("&nbsp;<input type=\"text\" name=\"" + inputName
            + "\" id=\"" + inputName + "\" " + maxLen + " " + maxSize
            + " value=\"" + inputVal + "\"");

        // This is to check numbers
        String[] ranges = { "-", "-", "-" };
        String datatype;
        if (ansi.getName().equalsIgnoreCase("number")) {
          String pattern = lQai.remove(0).getPattern();

          if (pattern != null && pattern.length() > 0)
            ranges = pattern.split(";");

          datatype = "N";
          /*
           * if (realtime == 0) addHtmlStr
           * (" onblur=\"event.stopPropagation();intrvFormCtrl.chkNumber(this, '"
           * + ranges[0]+"', '"+ranges[1]+"', '"+ranges[2]+"')\""); else
           * addHtmlStr (" onblur=\"event.stopPropagation();" +
           * "intrvFormCtrl.sendItem('N', this, '"+
           * ranges[0]+"', '"+ranges[1]+"', '"+ranges[2]+"')\"");
           */
        }

        else if (ansi.getName().equalsIgnoreCase("decimal")) {
          String pattern = lQai.remove(0).getPattern();
          // String[] ranges = {"-", "-", "-"};

          if (pattern != null)
            ranges = pattern.split(";");

          datatype = "D";
          /*
           * addHtmlStr (" onblur=\"intrvFormCtrl.chkDecimal(this '"+
           * ranges[0]+"', '"+ranges[1]+"', '"+ranges[2]+"')\""); addHtmlStr
           * (" onblur=\"intrvFormCtrl.sendItem('D', this '"+
           * ranges[0]+"', '"+ranges[1]+"', '"+ranges[2]+"')\"");
           */
        }
        else
          // normal text
          datatype = "L";

        if (realtime == 0) {
          if (datatype.equalsIgnoreCase("L"))
            addHtmlStr(" onblur=\"event.stopPropagation();intrvFormCtrl.onBlur(this.name)\"");

          else if (datatype.equalsIgnoreCase("N"))
            addHtmlStr(" onblur=\"event.stopPropagation();intrvFormCtrl.chkNumber(this, '"
                + ranges[0] + "', '" + ranges[1] + "', '" + ranges[2] + "')\"");

          else
            addHtmlStr(" onblur=\"event.stopPropagation();intrvFormCtrl.chkDecimal(this, '"
                + ranges[0] + "', '" + ranges[1] + "', '" + ranges[2] + "')\"");
        }
        else {
          if (datatype.equalsIgnoreCase("L"))
            addHtmlStr(" onblur=\"event.stopPropagation();"
                + "intrvFormCtrl.sendItem('L', this)\"");
          else
            addHtmlStr(" onblur=\"event.stopPropagation();"
                + "intrvFormCtrl.sendItem('" + datatype + "', this, '"
                + ranges[0] + "', '" + ranges[1] + "', '" + ranges[2] + "')\"");
        }

        if (((Question) ai).getMandatory() == 1)
          addHtmlStr(" must=\"1\" ");

        addHtmlStr(" onfocus=\"intrvFormCtrl.onfocus(this.name)\"");
        addHtmlStr(" />");
      }

      else if (ansi instanceof EnumType) {
        String sel = "selected=\"selected\"";
        List<EnumItem> ceni = HibController.EnumTypeCtrl.getEnumItems(hibSes,
            (EnumType) ansi);

        String selName = "q" + ai.getId() + "-" + numQuestion + "-" + orderCai, htmlPiece;

        htmlPiece = "&nbsp;<select name=\"" + selName + "\" " + "id=\""
            + selName + "\" style=\"width:150px;\"";
        if (realtime == 0)
          htmlPiece += " onblur=\"intrvFormCtrl.onBlur(this.name)\" ";
        else
          htmlPiece += " onblur=\"intrvFormCtrl.sendItem('S', this)\" ";

        if (((Question) ai).getMandatory() == 1)
          htmlPiece += " must=\"1\" ";

        htmlPiece += "onfocus=\"intrvFormCtrl.onfocus(this.name)\">";
        addHtmlStr(htmlPiece);
        /*
         * addHtmlStr("&nbsp;<select name=\"" + selName +"\" " + "id=\"" +
         * selName + "\" style=\"width:200px;\"" + //
         * " onblur=\"intrvFormCtrl.onBlur(this.name)\" " +
         * " onblur=\"intrvFormCtrl.sendItem ('S', this)\" "+
         * "onfocus=\"intrvFormCtrl.onfocus(this.name)\">");
         */
        addHtmlStr("<option value=\"" + RenderEng.MISSING_ANSWER
            + "\"> </option>");
        for (EnumItem eni : ceni) {
          if (eni.getValue().equalsIgnoreCase(inputVal))
            addHtmlStr("<option value=\"" + eni.getValue() + "\" " + sel + " >"
                + StringEscapeUtils.escapeHtml(eni.getName()) + "</option>");
          else
            addHtmlStr("<option value=\"" + eni.getValue() + "\">"
                + StringEscapeUtils.escapeHtml(eni.getName()) + "</option>");
        }

        addHtmlStr("</select>");
      }
      else {
        addHtmlStr("ERROR: Not implemented case -&gt: "
            + StringEscapeUtils.escapeHtml(ansi.getName()) + "<br>");
      }

      if (orderCai < cai.size()) {
        addHtmlStr("&nbsp;-&nbsp;");
        orderCai++;
      } /*
         * else System.out.println (ETRTD);
         */
    }

    if (((Question) ai).getRepeatable().intValue() == 1
        && ai.getContainees().size() == 0) {
      String plusBtn = "<input type=\"button\" name=\"btn-q" + ai.getId() + "-"
          + numQuestion + "-" + orderCai + "\" id=\"btn-q" + ai.getId() + "-"
          + numQuestion + "-" + orderCai + "\" ";
      plusBtn += " onclick=\"ctrl.addElem('q" + ai.getId() + "-" + numQuestion
          + "-" + orderCai + "');\" " + "value = \"+\"/>";

      addHtmlStr("\n");
      addHtmlStr(plusBtn);
    }
    // System.out.println(htmlStr);
  }

  /**
   * Render the containees
   * 
   * @param parent
   * @param containees
   * @param patId
   */
  private void renderChildren(Session hibSes, IntrvFormCtrl intrCtrl,
      AbstractItem parent, List<AbstractItem> containees, Integer patId) {
    Integer ansNum = 1;
    boolean end = false;
    int numOfAnswers = 1;
    // hay que iterar sobre los containees y,
    // por fuera, sobre el número de preguntas

    while (!end) {

      for (int i = 0; i < containees.size(); i++) {
        AbstractItem child = containees.get(i);
        if (i == 0) {
          String newName = "<table bgcolor=\"#FFCC99\" id=\"t" + parent.getId()
              + "-children\"";
          newName += " name=\"t" + parent.getId() + "-children\">";
          addHtmlStr(newName);
        }

        if (child instanceof Question) {
          // To be able to render correctly the html, the number of answers for
          // this
          // question is got
          // numOfAnswers = intrCtrl.getNumOfAnswers((Question)child, patId);
          numOfAnswers = Math.max(numOfAnswers, 
                                  intrCtrl.getNumOfAnswers((Question) child, patId));

          // this call gets the answers for a question regarding to the answer
          // number (ansNum)
          List<Object[]> answers = 
              intrCtrl.getAnswers(((Question) child).getId(), patId, ansNum);

          List<AnswerItem> anstypes = HibernateUtil.getAnswerTypes4Question(
              HibernateUtil.getSessionFactory().getCurrentSession(), child);
          renderContaineeItem(hibSes, (Question) child, answers, anstypes,
              ansNum);
        }
        else {
          setHighlight(child.getHighlight());
          addHtmlStr(ITRTD + highIni + child.getContent() + highEnd + ETRTD);
        }
      } // EO loop containees.size()
      ansNum++;

      if (ansNum > numOfAnswers) {
        /*
         * addHtmlStr("<tr><td align=\"right\">");
         * addHtmlStr("<input type=\"button\" name=\"btn-t"+
         * parent.getId()+"\" value=\" + \" id=\"btn-t"+
         * parent.getId()+"\" onclick=\"ctrl.addElem('t"
         * +parent.getId()+"')\">"); addHtmlStr(ETRTD);
         * addHtmlStr("</table><br><br>");
         */return;
      }
      else
        addHtmlStr("</table><br>");

    } // EO while answers iteration is over for every containee

  }

  /**
   * Renders a containee item
   * 
   * @param hibSes
   * @param q
   *          , the question
   * @param answers
   *          , the (possible) answers for the question (it can be null)
   * @param anstypes
   *          , the anstypes for the question (this can NOT be null)
   * @param ansNum
   *          , the current number for the question.
   */
  private void renderContaineeItem(Session hibSes, Question q,
      List<Object[]> answers, List<AnswerItem> anstypes, Integer ansNum) {

    setHighlight(q.getHighlight());
    addHtmlStr(ITRTD + highIni + StringEscapeUtils.escapeHtml(q.getContent())
        + highEnd + ETRTD);
    // The answeritems are retrieved in the correct order
    int orderCai = 1;
    String inputVal;
    String numAnswer;
    List<QuestionsAnsItems> lQai = HibController.ItemManager.getPatterns(
        hibSes, q);
    addHtmlStr(ITRTD);
    Object[] oldAnswer = null;
    for (AnswerItem ansi : anstypes) {
      // get the answer for this question...
      Object[] answer = null;
      if (answers != null && answers.size() > 0)
        // to avoid the exception on rendering, we will use the previous
        // question
        // ONLY as joker to be able to render the questionnaire
        if (answers.size() >= orderCai) {
          answer = answers.get(orderCai - 1);
          oldAnswer = answer;
        }
        else
          answer = oldAnswer;

      inputVal = (answer != null) ? (String) answer[1] : "";
      inputVal = (inputVal.equalsIgnoreCase(RenderEng.MISSING_ANSWER)) ? ""
          : inputVal;
      numAnswer = (answer != null) ? Integer.toString(((Integer) answer[2])
          .intValue()) : ansNum.toString();

      if (ansi instanceof AnswerType) { // simple answer (label, number)
        AnswerType anst = (AnswerType) ansi;
        String maxLen = "maxlength=\"", maxSize = "size=\"";
        if (ansi.getName().equalsIgnoreCase("number")
            || ansi.getName().equalsIgnoreCase("decimal")) {
          maxLen += "10\"";
          maxSize += "6\"";
        }
        else {
          maxLen += "4192\"";
          maxSize += "24\"";
        }
        // the name of the answer will be like q154-1-1, 154 idquesion
        // the first 1 answer number (to allow repetitivity, next one will be
        // 2)
        // and the last 1 is the answer order
        // besides, we gotta check the value...
        String inputName = "q" + q.getId() + "-" + numAnswer + "-" + orderCai;
        addHtmlStr("&nbsp;<input type=\"text\" name=\"" + inputName
            + "\" id=\"" + inputName + "\" " + maxLen + " " + maxSize
            + " value=\"" + inputVal + "\"");

        // This is to check numbers
        String datatype;
        String[] ranges = { "-", "-", "-" };
        if (ansi.getName().equalsIgnoreCase("number")) {
          String pattern = lQai.remove(0).getPattern();

          if (pattern != null)
            ranges = pattern.split(";");

          datatype = "N";
          /*
           * addHtmlStr
           * (" onblur=\"event.stopPropagation();intrvFormCtrl.chkNumber(this, '"
           * + ranges[0]+"', '"+ranges[1]+"', '"+ranges[2]+"')\"");
           * 
           * addHtmlStr (" onblur=\"event.stopPropagation();" +
           * "intrvFormCtrl.sendItem('N', this, '"+
           * ranges[0]+"', '"+ranges[1]+"', '"+ranges[2]+"')\"");
           */
        }

        else if (ansi.getName().equalsIgnoreCase("decimal")) {
          String pattern = lQai.remove(0).getPattern();
          // String[] ranges = {"-", "-", "-"};
          if (pattern != null)
            ranges = pattern.split(";");

          datatype = "D";
          /*
           * addHtmlStr (" onblur=\"intrvFormCtrl.chkDecimal(this '"+
           * ranges[0]+"', '"+ranges[1]+"', '"+ranges[2]+"')\"");
           * 
           * addHtmlStr (" onblur=\"event.stopPropagation();" +
           * "intrvFormCtrl.sendItem('D', this, '"+
           * ranges[0]+"', '"+ranges[1]+"', '"+ranges[2]+"')\"");
           */
        }
        else
          datatype = "L";
        // addHtmlStr (" onblur=\"intrvFormCtrl.onBlur(this.name)\"");
        // addHtmlStr (" onblur=\"intrvFormCtrl.sendItem('L', this)\"");

        if (realtime == 0) {
          if (datatype.equalsIgnoreCase("L"))
            addHtmlStr(" onblur=\"event.stopPropagation();intrvFormCtrl.onBlur(this.name)\"");

          else if (datatype.equalsIgnoreCase("N"))
            addHtmlStr(" onblur=\"event.stopPropagation();intrvFormCtrl.chkNumber(this, '"
                + ranges[0] + "', '" + ranges[1] + "', '" + ranges[2] + "')\"");

          else
            addHtmlStr(" onblur=\"event.stopPropagation();intrvFormCtrl.chkDecimal(this, '"
                + ranges[0] + "', '" + ranges[1] + "', '" + ranges[2] + "')\"");
        }
        else { // AUTOSAVING ENABLEDs
          if (datatype.equalsIgnoreCase("L"))
            addHtmlStr(" onblur=\"event.stopPropagation();"
                + "intrvFormCtrl.sendItem('L', this)\"");
          else
            addHtmlStr(" onblur=\"event.stopPropagation();"
                + "intrvFormCtrl.sendItem('" + datatype + "', this, '"
                + ranges[0] + "', '" + ranges[1] + "', '" + ranges[2] + "')\"");
        }
        addHtmlStr(" onfocus=\"intrvFormCtrl.onfocus(this.name)\"");
        if (q.getMandatory() == 1)
          addHtmlStr(" must=\"1\"");

        addHtmlStr(" />");
      }

      else if (ansi instanceof EnumType) {
        String sel = "selected=\"selected\"";
        List<EnumItem> ceni = HibController.EnumTypeCtrl.getEnumItems(
            HibernateUtil.getSessionFactory().getCurrentSession(),
            (EnumType) ansi);

        String selName = "q" + q.getId() + "-" + numAnswer + "-" + orderCai, htmlPiece;

        htmlPiece = "&nbsp;<select name=\"" + selName + "\" " + "id=\""
            + selName + "\" style=\"width:150px;\"";
        if (realtime == 0)
          htmlPiece += " onblur=\"intrvFormCtrl.onBlur(this.name)\" ";
        else
          htmlPiece += " onblur=\"intrvFormCtrl.sendItem('S', this)\" ";

        if (q.getMandatory() == 1)
          htmlPiece += "must=\"1\" ";

        htmlPiece += "onfocus=\"intrvFormCtrl.onfocus(this.name)\">";
        addHtmlStr(htmlPiece);
        /*
         * 
         * addHtmlStr("&nbsp;<select name=\"" + selName +"\" " + "id=\"" +
         * selName + "\" style=\"width:200px;\"" + //
         * " onblur=\"intrvFormCtrl.onBlur(this.name)\" " +
         * " onblur=\"intrvFormCtrl.sendItem('L', this.name)\" " +
         * "onfocus=\"intrvFormCtrl.onfocus(this.name)\" >");
         */
        addHtmlStr("<option value=\"" + RenderEng.MISSING_ANSWER
            + "\"> </option>");
        for (EnumItem eni : ceni) {
          if (eni.getValue().equalsIgnoreCase(inputVal))
            addHtmlStr("<option value=\"" + eni.getValue() + "\" " + sel + " >"
                + StringEscapeUtils.escapeHtml(eni.getName()) + "</option>");
          else
            addHtmlStr("<option value=\"" + eni.getValue() + "\">"
                + StringEscapeUtils.escapeHtml(eni.getName()) + "</option>");
        }

        addHtmlStr("</select>");
      }
      else {
        addHtmlStr("ERROR: Not implemented case -&gt: "
            + StringEscapeUtils.escapeHtml(ansi.getName()) + "<br>");
      }

      if (orderCai < anstypes.size()) {
        addHtmlStr("&nbsp;-&nbsp;");
        orderCai++;
      }/*
        * else System.out.println (ETRTD);
        */
    } // end of num of answers for loop

    if (q.getRepeatable().intValue() == 1) {
      String plusBtn = "<input type=\"button\" name=\"btnPlus\" id=\"btnPlus\"";
      plusBtn += " onclick=\"intrvFormCtrl.repeat(q" + q.getId() + ");\" />";
      addHtmlStr("\n");
      addHtmlStr(plusBtn);
    }

    // addHtmlStr("\nEnd of renderItem");
    addHtmlStr(ETRTD);
  }

  
  
  
  
  private void renderSingleItem(Session hibSes, AbstractItem ai, Integer patId,
      IntrvFormCtrl intrCtrl) {

    if (ai instanceof Text && ai.getContainees().size() == 0) {
      setHighlight(ai.getHighlight());
      addHtmlStr(ITRTD + highIni
          + StringEscapeUtils.escapeHtml(ai.getContent()) + highEnd + "<br>"
          + ETRTD);
      // System.out.println("* "+ai.getContent());
    }

    else if (ai instanceof Question && (ai.getContainees().size() == 0)) {
      int numAns = 1; // index for the answer number
      // To be able to render correctly the html, the number of answers for this
      // question is got
      int numOfAnswers = intrCtrl.getNumOfAnswers((Question) ai, patId);
      if (numOfAnswers == 0) {
        renderQuestion(hibSes, ai);
      }

      else
        // The code contained in the method is exactly what would be here
        renderAnswersPat(hibSes, ai, numOfAnswers, patId, intrCtrl);

    } // Question case

  }
  
  
  

  /**
   * (For debugging purposes only) Renders an item as its answer_item says. This
   * method works in a recursive way to be able to render all items inside one
   * item (superquestions)
   * 
   * @param hibSes
   *          , the session to perform the transaction
   * @param item
   *          , the item which is gonna be rendered
   */
  public void renderItem(Session hibSes, AbstractItem item) {
    if (item instanceof Text) {
      if (((Text) item).getHighlighted() == HibernateUtil.TEXT_HIGHLIGHT)
        LogFile.display("*** HIGHLIGHTED ***");

      LogFile.display(item.getItemOrder() + ". " + item.getContent());
    }

    else if (item instanceof Question) {
      LogFile.display(item.getItemOrder() + ". " + item.getContent());

      // first render the answer items
      Collection<AnswerItem> ansItems = HibernateUtil.getAnswerTypes4Question(
          hibSes, item);
      if (ansItems != null && !ansItems.isEmpty()) {
        Iterator<AnswerItem> itType = ansItems.iterator();

        while (itType.hasNext()) {
          AnswerItem ansIt = itType.next();
          if (ansIt instanceof AnswerType)
            LogFile.display("TextBox for " + ansIt.getName());

          else { // ansIt instanceof EnumType
            LogFile.display("ComboBox for " + ansIt.getName());

            Collection<EnumItem> colEnums = HibController.EnumTypeCtrl
                .getEnumItems(hibSes, (EnumType) ansIt);
            Iterator<EnumItem> itEnums = colEnums.iterator();
            while (itEnums.hasNext()) {
              EnumItem anEnum = itEnums.next();
              LogFile.display(anEnum.getName() + "-" + anEnum.getValue());
            }

          } // else instanceof EnumType
        }
      }
    } // else item is a question

    Collection<AbstractItem> items = HibController.ItemManager
        .getOrderedContainees(hibSes, item);
    // LogFile.stderr("num of containees for " +item.getId()+": "+items.size());
    if (items != null && !items.isEmpty()) {
      LogFile.display("[This is a SuperQuestion with " + items.size()
          + " items]");
      Iterator<AbstractItem> itItem = items.iterator();
      while (itItem.hasNext())
        renderItem(hibSes, itItem.next());

      LogFile.display("[End of Superquestion dump]");
    }

  } // method

}
