package org.cnio.appform.entity;

import java.util.List;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.Collection;
import java.util.ArrayList;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Column;
import javax.persistence.SequenceGenerator;
import javax.persistence.GeneratedValue;
import static javax.persistence.GenerationType.SEQUENCE;
import javax.persistence.OneToMany;
import static javax.persistence.CascadeType.ALL;
import javax.persistence.Table;

@Entity
@Table(name="Hospital")
public class Hospital implements java.io.Serializable {
	@Id
	@Column(name="idhosp")
	@SequenceGenerator(name="UserGenerator", sequenceName = "appuser_iduser_seq")
	@GeneratedValue(strategy=SEQUENCE, generator = "UserGenerator")
	private Integer id;
	
	@Column(name="name")
	private String name;
	
// the code of the hospital as is in the spec document 
	@Column(name="hospcod")
	private Integer hospCod;

	
//One hospital has many users	
	@OneToMany(mappedBy="theHospital", cascade={CascadeType.ALL})
	private Collection<AppUser> theUsers;
	
	public Hospital () {
		theUsers = new ArrayList<AppUser>();
	}

	public Hospital (String name, Integer code) {
		this ();
		
		this.name = name;
		this.hospCod = code;
	}	
	
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Integer getHospCod() {
		return hospCod;
	}

	public void setHospCod(Integer hospCod) {
		this.hospCod = hospCod;
	}

	public Collection<AppUser> getTheUsers() {
		return theUsers;
	}

	public void setTheUsers(Collection<AppUser> theUsers) {
		this.theUsers = theUsers;
	}

	
	public Integer getId() {
		return id;
	}
	
	public void setId(Integer id) {
		this.id = id;
	}

	

}
