package  org.cnio.appform.jaas;

/* Security & JAAS imports */
import java.security.Principal;

/**
 * <p>
 * Basic implementation of the Principal class. By implementing our own
 * Principal for our application, we can more easily add and remove
 * instances of our principals in the authenticated Subject during the
 * login and logout process.
 *
 * @see java.security.Principal
 * @author  Paul Feuer and John Musser
 * @version 1.0
 */

public class AppPrincipal implements Principal, java.io.Serializable {

    private String firstName, lastName, username;
    private boolean loggedIn;

    /**
     * Create a <code>AppPrincipal</code> with no
     * user name.
     *
     */
    public AppPrincipal() {
        firstName = "";
        lastName = "";
        username = "";
    }

    /**
     * Create a <code>AppPrincipal</code> using a
     * <code>String</code> representation of the
     * user name.
     *
     * <p>
     *
     * @param name the user identification number (UID) for this user.
     *
     */
    public AppPrincipal(String fName, String lastName, String username) {
        firstName = fName;
        this.lastName = lastName;
        this.username = username;
    }
    
    
    
    public void setLoggedIn (boolean status) {
    	loggedIn = status;
    }
    
    
    public boolean getLoggedIn () {
    	return loggedIn;
    }
    

    /**
     * Compares the specified Object with this
     * <code>AppPrincipal</code>
     * for equality.  Returns true if the given object is also a
     * <code>AppPrincipal</code> and the two
     * AppPrincipals have the same name.
     *
     * <p>
     *
     * @param o Object to be compared for equality with this
     *		<code>AppPrincipal</code>.
     *
     * @return true if the specified Object is equal equal to this
     *		<code>AppPrincipal</code>.
     */
    public boolean equals(Object o) {

        if (o == null)
          return false;

        if (this == o)
          return true;
 
        if (o instanceof AppPrincipal) {
          if (((AppPrincipal) o).getFirstName().equals(firstName) && 
          		((AppPrincipal) o).getLastName().equals(lastName) &&
          		((AppPrincipal) o).getName().equals(username))
            return true;
          
          else
            return false;
        }
        else 
          return false;
    }

    /**
     * Return a hash code for this <code>AppPrincipal</code>.
     *
     * <p>
     *
     * @return a hash code for this <code>AppPrincipal</code>.
     */
    public int hashCode() {
        return firstName.hashCode() + lastName.hashCode();
    }

    /**
     * Return a string representation of this
     * <code>AppPrincipal</code>.
     *
     * <p>
     *
     * @return a string representation of this
     *		<code>AppPrincipal</code>.
     */
    public String toString() {
        return firstName + " " + lastName;
    }

    
	  public String getName () {
//	    return firstName + " " + lastName;
	  	return username;
	  }
    
    
    /**
     * Return the user name for this
     * <code>AppPrincipal</code>.
     *
     * <p>
     *
     * @return the user name for this
     *		<code>AppPrincipal</code>
     */
    public String getFirstName() {
      return firstName;
    }
    
    public String getLastName () {
    	return lastName;
    }
}

