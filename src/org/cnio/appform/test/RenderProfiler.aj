package org.cnio.appform.test;

import org.cnio.appform.util.*;
import org.aspectj.lang.*;

import java.io.IOException;
import java.util.Hashtable;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;

import java.util.logging.*;

public aspect RenderProfiler {
  
  private Hashtable<String,MethodInfo> methods = new Hashtable<String, MethodInfo>();
  private Logger logger = Logger.getLogger("profiling");
  // concerns
/*
  pointcut profileMethods():
		execution (* org.cnio.appform.util.RenderEng.*(..)) &&
		!within (RenderProfiler);
*/
  pointcut profileHtml4Item ():
        execution (* org.cnio.appform.util.RenderEng.renderAnswersPat (..)) &&
        !within (RenderProfiler);
  
  pointcut profileConstructor (): 
    execution (org.cnio.appform.util.RenderEng.new (int)) &&
    !within (RenderProfiler);
  
  
  pointcut profileGetAnswers ():
        execution (* org.cnio.appform.util.IntrvFormCtrl.getAnswers (..)) &&
        !within (RenderProfiler);
  
  
  
  // advices  
  before(): profileConstructor () {
    Signature sg = thisJoinPointStaticPart.getSignature();
    FileHandler fh;
    
    try {
System.out.println ("creating file for: "+sg.getName());
      fh = new FileHandler ("logs/theprofile.txt");
      Formatter myFormatter = (new Formatter () {
        public String format(LogRecord record) {
          return record.getLevel() + ": "
              + record.getMessage() + "\n";
        }
      });
      
      fh.setFormatter(myFormatter);
      logger.addHandler(fh);
    }
    catch (SecurityException e) {
      e.printStackTrace(System.err);
    }
    catch (IOException e) {
      e.printStackTrace(System.err);
    }
    
    System.out.println ("Reseting data on constructor call..." +
        sg.getName()+":"+sg.getDeclaringTypeName());
    
//    logger.log(Level.INFO, "Reseting data on constructor call..." +  sg.getName()+":"+sg.getDeclaringTypeName());
    for (Map.Entry<String, MethodInfo> method: methods.entrySet()) {
      MethodInfo mi = method.getValue();
      mi.reset();
    }
  }
  
  
  
  
  before(): profileHtml4Item () {
    Signature sg = thisJoinPoint.getSignature();
    
    beforeMethods (sg);
  }

  
  before(): profileGetAnswers () {
    Signature sg = thisJoinPoint.getSignature();
    beforeMethods (sg);
  }
  
  
  
// Before entering in any method defined in the profileMethods concern,
/* execute what is inside before advice
  before(): profileMethods () {
    Signature sg = thisJoinPoint.getSignature();
    
    beforeMethods (sg);
  }
*/  
  
  

// After entering in any method defined in the profileMethods concern,
/* execute what is inside before advice
  after(): profileMethods () {
    long endTime = System.currentTimeMillis();
    Signature sg = thisJoinPoint.getSignature();
    
    afterMethods (sg, endTime);
  }

*/  
  after(): profileHtml4Item () {
    long endTime = System.currentTimeMillis();
    Signature sg = thisJoinPoint.getSignature();
    
    afterMethods (sg, endTime);
  }

  
  
  after(): profileGetAnswers () {
    long endTime = System.currentTimeMillis();
    Signature sg = thisJoinPoint.getSignature();
    
    afterMethods (sg, endTime);
  }
  
  
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////  
  
  private void beforeMethods (Signature sg) {
    MethodInfo mi;
    
    if (methods.containsKey(sg.getName()))
      mi = methods.get(sg.getName());
    
    else
      mi = new MethodInfo (sg.getName());
    
    mi.setIniTime(System.currentTimeMillis());
    mi.setEndTime(0);
    int counter = mi.incCounter();
/*    
    Object[] argsVal = thisJoinPoint.getArgs();
    for (int i=0; i<argsVal.length; i++) {
      mi.addArg(new Integer (i+1), argsVal[i].toString());
    }
*/    
    methods.put(sg.getName(), mi);
    System.out.println ("[Entering '"+sg.getName()+"']: "+ counter);
    logger.log(Level.INFO, "[Entering '"+sg.getName()+"']: "+ counter);
    
  }
  
  
  
  
  private void afterMethods (Signature sg, long endTime) {
    MethodInfo mi = methods.get(sg.getName());
    long lapsus = endTime - mi.getIniTime();
    mi.setEndTime(endTime);
    mi.accumTime(lapsus);
    methods.put(sg.getName(), mi);
    
    logger.log(Level.INFO, "[Leaving '"+sg.getName()+"']: "+lapsus+"ms; ACCUM: "+
        mi.getAccumTime()+"ms; CALLS: "+mi.getCounter());
    System.out.println ("[Leaving '"+sg.getName()+"']: "+lapsus+"ms; ACCUM: "+
        mi.getAccumTime()+"ms; CALLS: "+mi.getCounter());
  }

}
