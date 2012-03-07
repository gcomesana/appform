package org.cnio.appform.jaas;
/*
import javax.persistence.NamedNativeQuery;
import javax.persistence.SqlResultSetMapping;
import javax.persistence.ColumnResult;
*/

import org.cnio.appform.entity.AppUser;

import org.hibernate.Session;
import org.hibernate.HibernateException;
import org.hibernate.Transaction;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
/*
@NamedNativeQuery(name="validateUser", callable=true,
									query="? = call validate_user (:theusername, :thepasswd)", 
									resultClass=Integer.class)
*/
public class AppUserValidation {
	
	private Session hibSes;
	
	public AppUserValidation (Session hibSess) {
		hibSes = hibSess;
	}
	
	
/**
 * This method checks whether or not the password introduced is correct. This
 * is done in this way as the password are encrypted and it has to be decrypt
 * in the database
 * @param username, the name of the user
 * @param passwd, the password as it was introduced
 * @return true if the introduced password is correct; false otherwise
 */
	public boolean valUser (String username, String passwd) {
		Transaction tx = null;
		Query q;
		SQLQuery sqlQ;
		String sqlStr = "select (passwd = crypt (:thePasswd, passwd)) as theCheck " +
										"from appuser u where u.username = :uname";
		
		try {
			tx = hibSes.beginTransaction();
			
			sqlQ = hibSes.createSQLQuery(sqlStr);
//			sqlQ.setString("thePasswd", passwd);
			sqlQ.addScalar("theCheck");
			sqlQ.setParameter("thePasswd", passwd);
			sqlQ.setParameter("uname", username);

			Boolean res = (Boolean)sqlQ.uniqueResult();
// System.out.println("AppUserValidation: result is "+res);
			tx.commit();
			
			return res;
		}
		catch (HibernateException hibEx) {
			if (tx != null)
				tx.rollback();
			
			hibEx.printStackTrace();
			return false;
		}
		
	}

}
