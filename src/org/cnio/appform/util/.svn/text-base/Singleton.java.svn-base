package org.cnio.appform.util;

import java.util.List;
import java.util.ArrayList;

public class Singleton {
	private static Singleton instance = new Singleton ();

/**
 * The list of users currently connected
 */
	private List<String> users; 

	
/**
 * This private constructor is defined so the compiler
 * won't generate a default public constructor.
 */
	private Singleton () {  
		users = new ArrayList<String> ();
	} 
	
	
/**
 * Return a reference to the only instance of this class.
 */
	public static Singleton getInstance() {
	  return instance;
	} // getInstance()
	
	
/**
 * Add an user to the list of logged users
 * @param username
 */
	public void addUser (String username) {
		users.add(username);
System.out.println("Singleton.addUser: "+username);
	}
	
	
/**
 * Checks if username is logged
 * @param username, the user 
 * @return true if the user username is logged; otherwise it returns false
 */
	public boolean isLogged (String username) {
System.out.println("Singleton.islogged: "+username+":"+users.contains(username));
		return users.contains(username);
	}
	
	
/**
 * Remove an element of the list based on their content
 * @param username
 */
	public void rmvUser (String username) {
		users.remove(username);
System.out.println("Singleton.rmvUser: "+username);
	}
	
	
	
/**
 * Return the number of users
 * @return the number of users
 */
	public int numUsers () {
		return users.size();
	}
	
	
	
	public List<String> getLoggedUsers () {
		return users;
	}
	
	
	
	public void clearUsers () {
		try {
			users.clear();
		}
		catch (UnsupportedOperationException uopEx) {
			System.err.println ("Unable to clear users on session");
			uopEx.printStackTrace(System.err);
		}
	}
	
	
	
	public void printUsrs() {
		System.out.println("Users currently logged:");
		for (String user: users) {
			System.out.println(user);
		}
	}
}
