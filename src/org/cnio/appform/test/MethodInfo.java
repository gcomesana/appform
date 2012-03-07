package org.cnio.appform.test;

import java.util.*;

public class MethodInfo implements Comparable<String> {
  private String name;
  private long timeIni;
  private long timeEnd;
  private long timeAccum;
  
// keep pair argName-argValue for every method call
  private Hashtable<Integer, String> theArgs;
  
// Number of times this method was called
  private int counter;
  
  
  public MethodInfo () {
    theArgs = new Hashtable<Integer,String>();
    name = "";
    timeAccum = 0;
  }
  
  
  public MethodInfo (String methodName) {
    this ();
    name = methodName;
  }
  
  
  
  public int incCounter () {
    counter ++;
    return counter;
  }
  
  
  public int resetCounter () {
    counter = 0;
    return counter;
  }
  
  
  public int getCounter () {
    return counter;
  }
  
  
  public long setIniTime (long beginning) {
    timeIni = beginning;
    return timeIni;
  }
  
  public long getIniTime () {
    return timeIni;
  }
  
  
  public long setEndTime (long finish) {
    timeEnd = finish;
    return timeEnd;
  }
  
  public long getEndTime () {
    return timeEnd;
  }
  
  
  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }
  
  
  public long accumTime (long newLap) {
    timeAccum += newLap;
    return timeAccum;
  }
  
  
  public long getAccumTime () {
    return timeAccum;
  }
  
  
  public Hashtable<Integer,String> addArg (Integer pos, String val) {
    theArgs.put(pos, val);
    
    return theArgs;
  }
  
  
  public int compareTo (String methodName) {
    int res = name.compareTo(methodName);
    
    return res;
  }
  
  
  public boolean equals (MethodInfo mo) {
    if (mo.getName().equals(name))
      return true;
    
    return false;
  }
  
  
  
  public void reset () {
    timeIni = 0;
    timeEnd = 0;
    timeAccum = 0;
    counter = 0;
  }

}
