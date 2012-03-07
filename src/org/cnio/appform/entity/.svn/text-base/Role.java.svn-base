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
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.GeneratedValue;
import static javax.persistence.GenerationType.SEQUENCE;
import javax.persistence.OneToMany;
import static javax.persistence.CascadeType.ALL;
import javax.persistence.Table;

@Entity
@Table(name="Role")
public class Role {
	@Id
	@Column(name="idrole")
	@SequenceGenerator(name="RoleGenerator", sequenceName = "role_idrole_seq")
	@GeneratedValue(strategy=SEQUENCE, generator = "RoleGenerator")
	private Integer id;
	@Column(name="name")
	private String name;
	@Column(name="description")
	private String description;
	
	@OneToMany(mappedBy="theRole", cascade={CascadeType.ALL})
	private Collection<AppuserRole> userRoles;
	
	public Role () {
		userRoles = new ArrayList<AppuserRole>();
	}

	public Role (String name, String description) {
		this ();
		
		this.name = name;
		this.description = description;
	}
/*	
	public Section (String name, String description, AbstractItem anItem) {
		this ();
		
		sectionOrder = 1;
		this.name = name;
		this.description = description;
		items.add(anItem);		
	}
	*/
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}

	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}

	
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}

	
	public Collection<AppuserRole> getAppuserRoles () {
		return userRoles;
	}

	public void setAppuserRoles (Collection<AppuserRole> userRoles) {
		this.userRoles = userRoles;
	}
	
	
	public String toString () {
		return "Role => id: "+id+"; "+name+". "+name;
	}
}
