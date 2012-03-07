package org.cnio.appform.jaas;

import java.security.Principal;

public class AppPrincipalRole implements Principal {


  private String rolename;

  /**
   * Create a <code>AppPrincipal</code> with no
   * user name.
   *
   */
  public AppPrincipalRole () {
      rolename = "";
  }

  /**
   * Create a <code>AppPrincipalRole</code> using a
   * <code>String</code> representation of the
   * user name.
   *
   * <p>
   *
   * @param name the user identification number (UID) for this user.
   *
   */
  public AppPrincipalRole(String fName) {
      rolename = fName;
  }
  
  
  
  /**
   * Compares the specified Object with this
   * <code>AppPrincipal</code>
   * for equality.  Returns true if the given object is also a
   * <code>AppPrincipalRole</code> and the two
   * AppPrincipalRoles have the same name.
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
 
        if (o instanceof AppPrincipalRole) {
          if (((AppPrincipalRole) o).getName().equals(rolename))
            return true;
          
          else
            return false;
        }
        else 
          return false;
    }

    /**
   * Return a hash code for this <code>AppPrincipalRole</code>.
   *
   * <p>
   *
   * @return a hash code for this <code>AppPrincipalRole</code>.
   */
  public int hashCode() {
      return rolename.hashCode();
  }

  /**
   * Return a string representation of this
   * <code>AppPrincipalRole</code>.
   *
   * <p>
   *
   * @return a string representation of this
   *		<code>AppPrincipalRole</code>.
   */
  public String toString() {
      return rolename;
  }

  
  public String getName () {
    return rolename;
  }
  
}


