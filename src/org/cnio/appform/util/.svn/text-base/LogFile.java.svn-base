
package org.cnio.appform.util;


/**
 * User: willy
 * Date: 31-may-2007
 * Time: 18:06:29
 */
import org.apache.log4j.Level;
import org.apache.log4j.Logger;
import org.apache.log4j.Appender;
import org.apache.log4j.FileAppender;
import org.apache.log4j.SimpleLayout;

// import org.cnio.appform.entity.AppDBLogger;

import java.io.IOException;

public class LogFile {
//    private static Logger logger = Logger.getLogger(LogClass.class);
	private static Logger logger = Logger.getLogger(LogFile.class);
    private static String appenderName;
    private static boolean initialized = false;
    
//    private static org.apache.log4j.Logger log = Logger.getLogger(LogClass.class);
/*
    static {
      try {
          logger = Logger.getLogger("Logger");
          logger.setLevel(Level.DEBUG);
          logger.addAppender(new FileAppender (new SimpleLayout(),
                             "appender.log", true));
          appenderName = "appender.log";
          
      }
      catch (IOException ex) {
          ex.printStackTrace();
      }
    }
*/
    
    public static boolean isInitialized () {
    	return initialized;
    }
  
 
/*
    public static void init (Class theClass) {
    	if (!initialized) {
    		try {
          logger = Logger.getLogger(theClass);
          logger.setLevel(Level.DEBUG);
          logger.addAppender(new FileAppender (new SimpleLayout(),
                             "appform.log", true));
          appenderName = "appform.log";
          
	      }
	      catch (IOException ex) {
	          ex.printStackTrace();
	      }
    	}
    	initialized = true;
    }
*/
    
    
    public static void logStackTrace (StackTraceElement[] exc) {
    	String logMsg = "Uncaught exception:\n";
    	for (int i=0; i<exc.length; i++) {
    		StackTraceElement elem = exc[i];
    		
    		logMsg += "\t at "+elem.getClassName()+"."+elem.getMethodName()+":"+
    						elem.getLineNumber()+"\n";
    	}
    	logger.error(logMsg);
    }
    
    
    
    public static Logger getLogger () {
    	return logger;
    }
    
    
    public static void debug (String data) {
        logger.debug(data);
    }

    
    public static void info (String data) {
        logger.info(data);
    }


    public static void error (String data) {
        logger.error(data.toUpperCase());
    }


    public static void setLogfile (String newName) {
//    	logger.removeAllAppenders();
    	try {
    		if (logger != null) {
    				logger.removeAppender(appenderName);
            logger.addAppender(new FileAppender (new SimpleLayout(),
                                                 newName, true));
        }
    		else {
    			logger = Logger.getLogger(LogFile.class);
          logger.setLevel(Level.DEBUG);
          logger.addAppender(new FileAppender (new SimpleLayout(),
                             									newName, true));
    		}
    		appenderName = newName;
    	}
      catch (IOException ex) {
         ex.printStackTrace ();
      }
    }
    
    
/*    
    public static void log2db (Integer patid, Integer usrid, 
    										Integer intrvid, String logmsg, String sessionid) {
    	
    	AppLog dbLog = new AppLog ();
    	dbLog.setIntrvId(intrvid);
    	dbLog.setLogMsg(logmsg);
    	dbLog.setSessionId(sessionid);
    	dbLog.setPatId(patid);
    	dbLog.setUserId(usrid);
    }
*/
    
    public static void stderr (String msg) {
    	System.err.println(msg);
    }
    
    public static void stdout (String msg) {
    	System.out.println(msg);
//    	logger.info("stdout: "+msg);
    }
    
    public static void display (String msg) {
    	System.out.println(msg.toUpperCase());
//    	logger.info(msg.toUpperCase());
    }
}

