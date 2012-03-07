package org.cnio.appform.test;

import org.cnio.appform.util.*;
import org.cnio.appform.entity.*;

import java.util.*;
import org.hibernate.*;

// import org.cnio.appform.groovy.util.OnePerson;

class RenderTest {

  public static void main(String args[]) {
/*    OnePerson rasheed = new OnePerson ();
    
    rasheed.setFirstName("Rasheed");
    rasheed.setLastName("Wallace");
    rasheed.setAge(33);
    System.out.println ("OnePerson.toString(): "+rasheed.toString());
    System.out.println();
  
    rajon.setFirstName("Rajon");
    rajon.setLastName("Rondo");
    rajon.setAge(24);
    System.out.println (rajon.toString());
*/
  	
  	String answersToRmv = "15690-2-1,15691-2-1,15692-2-1,15696-2-1,15696-2-2,16213-2-1,15693-2-1,15693-2-1,15694-2-1,15695-2-1,15697-2-1,15698-2-1";
  	Session hibSes = HibernateUtil.getSessionFactory().openSession();
  	IntrvFormCtrl ifc = new IntrvFormCtrl (hibSes);
  	
  	boolean res = ifc.removeAnswers(answersToRmv, 3432);
  	
    System.out.println("Remove answers: "+res);
  }
  
  
  
  private void testItems () {
    Session hibSes = HibernateUtil.getSessionFactory().openSession();
    Section sec = (Section) hibSes.get(Section.class, 1150);
    RenderEng render = new RenderEng();
    String patId = "1001"; // 550
    IntrvFormCtrl intrCtrl = new IntrvFormCtrl(hibSes);

    List<AbstractItem> itemsSec = HibernateUtil.getContainers4Section(hibSes,
        sec);

    for (AbstractItem ai : itemsSec) {
      render.clearHtmlStr();
      /*
       * System.out.println("item4sec.jsp: calling render with: ("+ai.getId()+
       * ","+Integer.decode(patId)+") "+ai.getContent());
       */
      render.html4Item(hibSes, ai, Integer.decode(patId), intrCtrl);
      System.out.println(render.getHtmlStr());
    }
  }
}