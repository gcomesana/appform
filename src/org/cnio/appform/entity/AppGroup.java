package org.cnio.appform.entity;

import static javax.persistence.GenerationType.SEQUENCE;

import java.util.HashSet;
import java.util.Set;
import java.util.Collection;
import java.util.List;
import java.util.ArrayList;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.ForeignKey;

/**
 * Appgroup entity.
 * 
 * @author MyEclipse Persistence Tools
 */
@Entity
@Table(name = "appgroup")
public class AppGroup implements java.io.Serializable {

	// Fields 
	@Id
	@Column(name="idgroup")
	@SequenceGenerator(sequenceName="appgroup_idgroup_seq", name = "GroupSeqGen")
	@GeneratedValue(generator="GroupSeqGen", strategy = SEQUENCE)
	private Integer id;
	@Column(name = "name", unique = false, nullable = true, insertable = true, updatable = true, length = 128)
	private String name;
	@Column(name = "codgroup", unique = false, nullable = true, insertable = true, updatable = true, length = 128)
	private String codgroup;
	
	@Column(name = "tmpl_holder", unique = false, nullable = false, insertable = true, updatable = true)
	private Integer tmplHolder;
	
	
// Parent-children relationship implementation. UNUSED AT 06.08.2008	
	@ManyToOne(targetEntity=AppGroup.class)
	@JoinColumn(name="parent") // this actually is the foreign key columng
	@ForeignKey(name="fk_parent_group")
	private AppGroup container;
	
//Parent-children relationship implementation. UNUSED AT 06.08.2008	
	@ManyToOne(targetEntity=GroupType.class)
	@JoinColumn(name="codgroup_type") // this actually is the foreign key columng
	@ForeignKey(name="fk_grouptype")
	private GroupType type;
	
		
	// @OneToMany(mappedBy="container", cascade={CascadeType.ALL})
	@OneToMany(mappedBy="container")
	private List<AppGroup> containees;
	
	@OneToMany(cascade = { CascadeType.ALL }, fetch = FetchType.LAZY, mappedBy = "appgroup")
	private Collection<RelGrpAppuser> relGrpAppusrs;
	
	@OneToMany(mappedBy="group")
	private List<Performance> performances;

	
//One interview CAN belong to several user groups (M:N relationship)	
	@OneToMany(cascade = { CascadeType.ALL }, fetch = FetchType.LAZY, mappedBy = "appgroup")
	private List<RelIntrvGroup> relGrpIntrvs;	
	
	// Constructors

	/** default constructor */
	public AppGroup() {
		relGrpAppusrs = new ArrayList<RelGrpAppuser>(); // for users
		containees = new ArrayList<AppGroup>(); // for hierarchical strategy
		relGrpIntrvs = new ArrayList<RelIntrvGroup>(); // for interviews for this group
		performances = new ArrayList<Performance>();
	}

	/** minimal constructor */
	public AppGroup(String name) {
		this ();
		this.name = name;
		tmplHolder = 0;
	}
	
	
	public AppGroup (String name, Integer tmplHolder) {
		this (name);
		this.tmplHolder = tmplHolder;
	}
	

	// Property accessors
	public Integer getId() {
		return this.id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	
	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	
	public String getCodgroup() {
		return this.codgroup;
	}

	public void setCodgroup(String codgroup) {
		this.codgroup = codgroup;
	}
	
	
	public AppGroup getContainer() {
		return container;
	}

	
	public void setContainer(AppGroup container) {
		if (container != null) {
			this.container = container;
			container.getContainees().add(this);
		}/*
		else {
			this.container.getContainees().remove(this);
			this.container = null;
		}*/
	}
	
	
	public List<AppGroup> getContainees() {
		return containees;
	}

	public void setContainees(List<AppGroup> containees) {
		this.containees = containees;
	}

	public void removeContainees () {
		containees.clear();
	}

	
	public Collection<RelGrpAppuser> getRelGrpAppusrs() {
		return this.relGrpAppusrs;
	}

	public void setRelGrpAppusrs(Collection<RelGrpAppuser> relGrpAppusrs) {
		this.relGrpAppusrs = relGrpAppusrs;
	}

	
	public Integer getTmplHolder() {
		return tmplHolder;
	}

	
	public void setTmplHolder(Integer tmplHolder) {
		this.tmplHolder = tmplHolder;
	}

	
	public List<RelIntrvGroup> getRelGrpIntrvs() {
		return relGrpIntrvs;
	}

	public void setRelGrpIntrvs(List<RelIntrvGroup> relGrpIntrvs) {
		this.relGrpIntrvs = relGrpIntrvs;
	}

	public GroupType getType() {
		return type;
	}

	public void setType(GroupType type) {
		if (type != null) {
			this.type = type;
			type.getGroups().add(this);
		}
		
	}

	public List<Performance> getPerformances() {
		return performances;
	}

	public void setPerformances(List<Performance> performances) {
		this.performances = performances;
	}
	
	public void setPerformance (Performance perf) {
		if (perf != null) {
			perf.setGroup(this);
			performances.add(perf);
		}
	}
	
	
	public boolean equals (AppGroup g) {
		return g.getId() == this.getId();
	}

}