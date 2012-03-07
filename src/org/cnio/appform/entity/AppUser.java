package org.cnio.appform.entity;

import java.util.Date;
import java.util.List;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.Collection;
import java.util.ArrayList;

import javax.persistence.CascadeType;
import javax.persistence.FetchType;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Column;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.GeneratedValue;
import static javax.persistence.GenerationType.SEQUENCE;
import javax.persistence.OneToMany;
import static javax.persistence.CascadeType.ALL;
import javax.persistence.Table;

import org.hibernate.annotations.Cascade;
import org.hibernate.annotations.NamedNativeQuery;

import javax.persistence.Basic;

import org.cnio.appform.util.AppUserCtrl;

@Entity
/*
@NamedNativeQuery(name="validateUser", callable=true,
		query="{? = call validate_user (:theusername, :thepasswd)}")
*/
@Table(name="appuser")
public class AppUser implements java.io.Serializable {
	@Id
	@Column(name="iduser")
	@SequenceGenerator(name="UserGenerator", sequenceName = "appuser_iduser_seq")
	@GeneratedValue(strategy=SEQUENCE, generator = "UserGenerator")
	private Integer id;
	@Column(name="username")
	private String username;
	@Column(name="passwd")
	private String passwd;

	@Column(name="country")
	private String country;
	
// The first real name of the user
	@Column(name="firstname")
	private String firstName;
	
// The last name of the user
	@Column(name="lastname")
	private String lastName;
	
// Field to indicated the user was deleted, so, he/she is not allowed to login
	@Column(name="removed")
	private Integer removed;
	
	
	@Column(name="last_passwd_change")
  private Date lastPasswdUpdate;
	
/*
	@Column(name = "loggedin")
	private Integer loggedIn;
*/	
	@Column(name = "loggedfrom")
	private String loggedFrom;
	
	@Column(name = "login_attempts")
	private Integer loginAttempts;
	
	@Column(name = "email")
	private String email;
	
// for the M:N relationship with roles	
	@OneToMany(mappedBy="theUser", cascade={CascadeType.ALL})
	private Collection<AppuserRole> userRoles;
	
//for the M:N relationship with performance	
	@OneToMany(mappedBy="theUser")
	@Cascade(org.hibernate.annotations.CascadeType.SAVE_UPDATE)
	private List<PerfUserHistory> userPerformances;
	
/*One interview instance is done for many users	
	@OneToMany(mappedBy="theUser", cascade={CascadeType.ALL})
	private Collection<UsrPatIntrinst> ternaryItems;
*/	
	
/*This instance is related to a interview, which can be understood as a template	
	@ManyToOne (targetEntity=Hospital.class)
	@JoinColumn(name="codhosp")
	private Hospital theHospital;
*/	
	
// One user creates several interviews => he/she is the owner of this interviews
	@OneToMany(mappedBy="usrOwner", cascade = ALL)
	private List<Interview> interviews;
	
//One user belongs to several user groups (M:N relationship)	
	@OneToMany(cascade = { CascadeType.ALL }, fetch = FetchType.LAZY, mappedBy = "appuser")
	private List<RelGrpAppuser> relGrpAppusrs;	
	
	
//One user can be assigned to several projects	
	@OneToMany(cascade = { CascadeType.ALL }, fetch = FetchType.LAZY, mappedBy = "appuser")
	private List<RelPrjAppusers> relPrjAppuserses;	
	
	
// One user can participate in several interviews to patients
	@OneToMany(fetch = FetchType.LAZY, mappedBy = "appuser")
	@Cascade(org.hibernate.annotations.CascadeType.SAVE_UPDATE)
	private List<Performance> performances;
	
	
	public AppUser () {
		userRoles = new ArrayList<AppuserRole>();
		interviews = new ArrayList<Interview>();
		
		relPrjAppuserses = new ArrayList<RelPrjAppusers>();
		performances = new ArrayList<Performance>();
		
		relGrpAppusrs = new ArrayList<RelGrpAppuser>();
		
		userPerformances = new ArrayList<PerfUserHistory>();
		
		firstName = "";
		lastName = "";
		email = "";
		
		removed = 0;
		loginAttempts = 0;
	}

	
	public AppUser (String username, String passwd) {
		this ();
		
		this.username = username;
		this.passwd = passwd;
	}
	
	
	public AppUser (String username, String passwd, String email) {
		this (username, passwd);
		
		this.email = email;
	}
/*	
	public Section (String username, String passwd, AbstractItem anItem) {
		this ();
		
		sectionOrder = 1;
		this.username = username;
		this.passwd = passwd;
		items.add(anItem);		
	}
	*/
	
	public Integer getId() {
		return id;
	}
	
	public void setId(Integer id) {
		this.id = id;
	}


	public Collection<AppuserRole> getAppuserRoles () {
		return userRoles;
	}

	public void setAppuserRoles (Collection<AppuserRole> userRoles) {
		this.userRoles = userRoles;
	}
	
	public List<Interview> getInterviews() {
		return interviews;
	}

	public void setInterviews(List<Interview> interviews) {
		this.interviews = interviews;
		
	}
	
	public String toString () {
		return "Appuser -> id: "+id+", username: "+username;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPasswd() {
		return passwd;
	}

	public void setPasswd(String passwd) {
		this.passwd = passwd;
	}

	public Collection<AppuserRole> getUserRoles() {
		return userRoles;
	}

	public void setUserRoles(Collection<AppuserRole> userRoles) {
		this.userRoles = userRoles;
	}
/*
	public Collection<UsrPatIntrinst> getTernaryItems() {
		return ternaryItems;
	}

	public void setTernaryItems(Collection<UsrPatIntrinst> ternaryItems) {
		this.ternaryItems = ternaryItems;
	}

	public Hospital getTheHospital() {
		return theHospital;
	}

	public void setTheHospital(Hospital theHospital) {
		this.theHospital = theHospital;
		
		theHospital.getTheUsers().add(this);
	}
*/
	public String getCountry() {
		return country;
	}

	public void setCountry(String country) {
		this.country = country;
	}
	
	
	public Collection<RelGrpAppuser> getRelGrpAppusrs() {
  	return relGrpAppusrs;
  }

	public void setRelGrpAppusrs(List<RelGrpAppuser> relGrpAppusrs) {
  	this.relGrpAppusrs = relGrpAppusrs;
  }

	public List<RelPrjAppusers> getRelPrjAppuserses() {
		return relPrjAppuserses;
	}

	public void setRelPrjAppuserses(List<RelPrjAppusers> relPrjAppuserses) {
		this.relPrjAppuserses = relPrjAppuserses;
	}
	
/**
 * This method get all relationships between this user and all performances
 * he/she has performed any time
 * @return the list of entries in the M:N relation table
 */
	public List<PerfUserHistory> getUserPerformances() {
		return userPerformances;
	}
	
	
	public void setUserPerformances(List<PerfUserHistory> userPerformances) {
		this.userPerformances = userPerformances;
	}
	

/**
 * This method gets the performances started for one user.
 * It can be depreciated on the future as there will be a M:N relationship
 * between performances and users
 * @return the list of performances for this user
 */	
	public List<Performance> getPerformances() {
		return performances;
	}


	public void setPerformances(List<Performance> performances) {
		this.performances = performances;
	}
	

	public String getFirstName() {
		return firstName;
	}


	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}


	public String getLastName() {
		return lastName;
	}


	public void setLastName(String lastName) {
		this.lastName = lastName;
	}


	public Integer getRemoved() {
		return removed;
	}


	public void setRemoved(Integer removed) {
		this.removed = removed;
	}
	
	
/**
 * Handy method to check if this user was removed.
 * @return true if this user is disabled (was removed); false (not removed) 
 * otherwise
 */
	public boolean wasRemoved () {
		return (this.removed == 1);
	}

/*
	public Integer getLoggedIn() {
		return loggedIn;
	}
	
	
	public void setLoggedIn(Integer loggedIn) {
		this.loggedIn = loggedIn;
	}
*/

	public String getLoggedFrom() {
		return loggedFrom;
	}

	public void setLoggedFrom(String loggedFrom) {
		this.loggedFrom = loggedFrom;
	}
	
	

	public Integer getLoginAttempts() {
		return loginAttempts;
	}


	public void setLoginAttempts(Integer loginAttempts) {
		this.loginAttempts = loginAttempts;
	}


	public String getEmail() {
		return email;
	}


	public void setEmail(String email) {
		this.email = email;
	}
	
	
	
	public Date getLastPasswdUpdate() {
    return lastPasswdUpdate;
  }


  public void setLastPasswdUpdate(Date lastPasswdUpdate) {
    this.lastPasswdUpdate = lastPasswdUpdate;
  }
	
	
	
	
	
	
/*
 * Including business logic in here. This is not recommended in the majority
 * of the cases, but here is embedded coz this logic straightly affects the user
 */

/**
 * This is a method to see if this user has admin role among others.
 * @return true if this user has admin role; false otherwise
 */	
	public boolean isAdmin () {
		boolean res = false;
		
		for (Iterator<AppuserRole> it = userRoles.iterator(); it.hasNext();) {
			Role role = it.next().getTheRole();
			if (role.getName().equalsIgnoreCase(AppUserCtrl.ADMIN_ROLE)) {
				res = true;
				break;
			}
		}
		
		return res;
	}

	
/**
 * This is a method to see if this user has editor role among others.
 * @return true if this user has editor role; false otherwise
 */	
	public boolean isEditor () {
		boolean res = false;
		
		for (Iterator<AppuserRole> it = userRoles.iterator(); it.hasNext();) {
			Role role = it.next().getTheRole();
			if (role.getName().equalsIgnoreCase(AppUserCtrl.EDITOR_ROLE)) {
				res = true;
				break;
			}
		}
		
		return res;
	}
	
	
/**
 * This is a method to see if this user has interviewer role among others.
 * @return true if this user has interviewer role; false otherwise
 */	
	public boolean isInterviewer() {
		boolean res = false;
		
		for (Iterator<AppuserRole> it = userRoles.iterator(); it.hasNext();) {
			Role role = it.next().getTheRole();
			if (role.getName().equalsIgnoreCase(AppUserCtrl.INTRVR_ROLE)) {
				res = true;
				break;
			}
		}
		
		return res;
	}	
	
	
/**
 * This is a method to see if this user has guest role among others.
 * @return true if this user has guest role; false otherwise
 */	
	public boolean isGuest () {
		boolean res = false;
		
		for (Iterator<AppuserRole> it = userRoles.iterator(); it.hasNext();) {
			Role role = it.next().getTheRole();
			if (role.getName().equalsIgnoreCase(AppUserCtrl.GUEST_ROLE)) {
				res = true;
				break;
			}
		}
		
		return res;
	}

	
}

