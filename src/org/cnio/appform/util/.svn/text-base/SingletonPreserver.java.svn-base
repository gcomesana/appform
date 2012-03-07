package org.cnio.appform.util;

import java.util.HashSet;

public class SingletonPreserver implements Runnable {

//This keeps this class and everything it references from
  // being garbage-collected
  private static SingletonPreserver lifeLine = new SingletonPreserver();

  // Since this class won't be garbage-collected, neither
  // will this HashSet or the object that it references.
  private static HashSet protectedSet = new HashSet();

  private SingletonPreserver() {
      new Thread(this).start();
  }  // constructor()

  public synchronized void run() {
      try {
          wait();
      }  catch (InterruptedException e) {
      }  // try
  }  // run()

  /**
   * Garbage collection of objects passed to this method
   * will be prevented until they are passed to the
   * unpreserveObject method.
   */
  public static void preserveObject(Object o) {
      protectedSet.add(o);
  }  // preserveObject()
  /**
   * Objects passed to this method lose the protection
   * from garbage collection.
   */
  public static void unpreserveObject(Object o) {
      protectedSet.remove(o);
  } // unpreserveObject(Object)

}
