package org.cnio.appform.entity;

import javax.persistence.Entity;
import javax.persistence.Table;
import javax.persistence.Id;
import javax.persistence.Column;
import javax.persistence.SequenceGenerator;
import javax.persistence.GeneratedValue;
import static javax.persistence.GenerationType.AUTO;
import static javax.persistence.GenerationType.IDENTITY;
import static javax.persistence.GenerationType.SEQUENCE;
import javax.persistence.ManyToOne;
import javax.persistence.JoinColumn;
import javax.persistence.CascadeType;

import org.hibernate.annotations.ForeignKey;

@Entity
@Table(name="user_role")
public class AppuserRole {
@Id
@Column(name="iduser_role")
@SequenceGenerator(sequenceName="user_role_iduser_role_seq", name = "UserRoleSeqGen")
@GeneratedValue(generator="UserRoleSeqGen", strategy = SEQUENCE)
	private Integer id;
//	@ManyToOne (cascade={CascadeType.ALL})

	@ManyToOne (targetEntity=AppUser.class)
	@JoinColumn(name="coduser")
	@ForeignKey(name="fk_userrole_user")
	private AppUser theUser;
	
//	@ManyToOne (cascade={CascadeType.ALL})
	@ManyToOne (targetEntity=Role.class)
	@JoinColumn(name="codrole")
	@ForeignKey(name="fk_userrole_role")
	private Role theRole;
	
	@Column(name="username")
	private String userName;
	
	@Column(name="rolename")
	private String roleName;
	
	public AppuserRole () { }
	
	public AppuserRole (AppUser u, Role r) {
		this ();
		this.theUser = u;
		this.theRole = r;
		
		this.userName = u.getUsername();
		this.roleName = r.getName();
		
// Guarantee referential integrity
		u.getAppuserRoles().add(this);
		r.getAppuserRoles().add(this);
/*		
		anUser.getUserRoles().add(this);
		aRole.getUserRoles().add(this);
*/
/*
 * or, for us
 * this.user.addUserRole(this);
 * this.role.addUserRole(this);
 * because we implement the method
 */		
	}


	public Integer getId() {
		return id;
	}


	public void setId(Integer id) {
		this.id = id;
	}


	public AppUser getTheUser() {
		return theUser;
	}


	public void setTheUser(AppUser theUser) {
		this.theUser = theUser;
		
		theUser.getAppuserRoles().add(this);
	}


	public Role getTheRole() {
		return theRole;
	}


	public void setTheRole(Role theRole) {
		this.theRole = theRole;
		
		theRole.getAppuserRoles().add(this);
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getRoleName() {
		return roleName;
	}

	public void setRoleName(String roleName) {
		this.roleName = roleName;
	}

	
}
