package org.cnio.appform.entity;

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
import javax.persistence.SequenceGenerator;
import javax.persistence.GeneratedValue;
import static javax.persistence.GenerationType.SEQUENCE;
import javax.persistence.OneToMany;
import static javax.persistence.CascadeType.ALL;
import javax.persistence.Table;

@Entity
@Table(name="project")
public class Project implements java.io.Serializable {
	@Id
	@Column(name="idprj")
	@SequenceGenerator(name="SecGenerator", sequenceName = "project_idproject_seq")
	@GeneratedValue(strategy=SEQUENCE, generator = "SecGenerator")
	private Integer id;
	@Column(name="name")
	private String name;
	@Column(name="description")
	private String description;
	
	@Column(name="project_code")
	private String projectCode;
	
	@OneToMany(mappedBy="parentPrj", cascade = ALL)
	private List<Interview> interviews;
	
// One project has several users assigned to it	
	@OneToMany(cascade = { CascadeType.ALL }, fetch = FetchType.LAZY, mappedBy = "project")
	private List<RelPrjAppusers> relPrjAppuserses;
	
	public Project () {
		projectCode = "";
		
		interviews = new ArrayList<Interview>();
		relPrjAppuserses = new ArrayList <RelPrjAppusers>(); 
	}

	public Project (String name, String description, String prjCode) {
		this ();
		
		this.name = name;
		this.description = description;
		this.projectCode = prjCode;
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

	
	public List<Interview> getInterviews () {
		return interviews;
	}

	public void setInterviews(List<Interview> interviews) {
		this.interviews = interviews;
	}
	
	
	public void addInterview (Interview anIntr) {
		anIntr.setProject(this);
	}
	
	
	public String toString () {
		return "Section => id: "+id+"; "+name+". "+interviews.size()+" items";
	}

	public List<RelPrjAppusers> getRelPrjAppuserses() {
		return relPrjAppuserses;
	}

	public void setRelPrjAppuserses(List<RelPrjAppusers> relPrjAppuserses) {
		this.relPrjAppuserses = relPrjAppuserses;
	}

	public String getProjectCode() {
		return projectCode;
	}

	public void setProjectCode(String projectCode) {
		this.projectCode = projectCode;
	}
}
