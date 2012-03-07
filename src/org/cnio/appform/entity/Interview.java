package org.cnio.appform.entity;

import java.io.PrintStream;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.ForeignKey;

@Entity
@Table(name="interview")
public class Interview
  implements Serializable, Cloneable
{

  @Id
  @Column(name="idinterview")
  @SequenceGenerator(name="SecGenerator", sequenceName="interview_idinterview_seq")
  @GeneratedValue(strategy=GenerationType.SEQUENCE, generator="SecGenerator")
  private Integer id;

  @Column(name="name")
  private String name;

  @Column(name="description")
  private String description;

  @Column(name="can_shorten")
  private Integer canShorten;

  @Column(name="can_create_subject")
  private Integer canCreateSubject;
  
  @Column(name="is_sample_intrv")
  private Integer isSampleIntrv;
  

  @ManyToOne(targetEntity=Interview.class)
  @JoinColumn(name="source", nullable=true)
  @ForeignKey(name="fk_cloned_from")
  protected Interview sourceIntrv;
  
  @ManyToOne(targetEntity=Project.class)
  @JoinColumn(name="codprj", nullable=true)
  @ForeignKey(name="fk_interview_is_formed_project")
  private Project parentPrj;

  @ManyToOne(targetEntity=AppUser.class, cascade={javax.persistence.CascadeType.REFRESH})
  @ForeignKey (name="fk_interview_belongs_user")
  @JoinColumn(name="codusr", nullable=true)
  private AppUser usrOwner;

  
  @OneToMany(mappedBy="sourceIntrv", cascade={javax.persistence.CascadeType.MERGE, javax.persistence.CascadeType.PERSIST})
  protected List<Interview> children;

  @OneToMany(mappedBy="intrvOwner", cascade={javax.persistence.CascadeType.ALL})
  private List<AnswerItem> answerItems;

  @OneToMany(mappedBy="parentInt", cascade={javax.persistence.CascadeType.ALL})
  private List<Section> sections;

  @OneToMany(cascade={javax.persistence.CascadeType.ALL}, fetch=FetchType.LAZY, mappedBy="interview")
  private Collection<Performance> performances;

  @OneToMany(cascade={javax.persistence.CascadeType.ALL}, fetch=FetchType.LAZY, mappedBy="intrv")
  private List<RelIntrvGroup> relIntrvGrps;

  public Interview()
  {
    this.sections = new ArrayList();
    this.performances = new ArrayList();

    this.relIntrvGrps = new ArrayList();
    this.children = new ArrayList();
    this.answerItems = new ArrayList();
  }

  public Interview(String name, String description)
  {
  	this ();
    this.name = name;
    this.description = description;
  }

  public Integer getId()
  {
    return this.id;
  }

  public void setId(Integer id) {
    this.id = id;
  }

  public String getName()
  {
    return this.name; }

  public void setName(String name) {
    this.name = name;
  }

  public String getDescription()
  {
    return this.description; }

  public void setDescription(String description) {
    this.description = description;
  }

  public Integer getCanShorten() {
    return this.canShorten;
  }

  public void setCanShorten(Integer canShorten) {
    this.canShorten = canShorten;
  }

  public Integer getCanCreateSubject() {
    return this.canCreateSubject;
  }

  public void setCanCreateSubject(Integer canCreateSubject) {
    this.canCreateSubject = canCreateSubject;
  }

  public Integer getIsSampleIntrv() {
		return isSampleIntrv;
	}

	public void setIsSampleIntrv(Integer isSampleIntrv) {
		this.isSampleIntrv = isSampleIntrv;
	}

	public List<Section> getSections()
  {
    return this.sections;
  }

  public void setSections(List<Section> sections) {
    this.sections = sections;
  }

  public void setProject(Project prj) {
    this.parentPrj = prj;

    prj.getInterviews().add(this);
  }

  public Project getParentProj()
  {
    return this.parentPrj;
  }

  public void setParentPrj(Project parentPrj)
  {
    this.parentPrj = parentPrj;

    parentPrj.getInterviews().add(this);
  }

  public AppUser getUsrOwner()
  {
    return this.usrOwner;
  }

  public void setUsrOwner(AppUser owner) {
    this.usrOwner = owner;

    this.usrOwner.getInterviews().add(this);
  }

  public Collection<Performance> getPerformances() {
    return this.performances;
  }

  public void setPerformances(Collection<Performance> performances) {
    this.performances = performances;
  }

  
  
  public List<RelIntrvGroup> getRelIntrvGrps() {
    return this.relIntrvGrps;
  }

  
  
  public void setRelIntrvGrps(List<RelIntrvGroup> relIntrvGrps) {
    this.relIntrvGrps = relIntrvGrps;
  }
  
  

  public Object clone() throws CloneNotSupportedException {
    Interview intrv = new Interview(this.name, this.description);

    for (Iterator itAi = this.answerItems.iterator(); itAi.hasNext(); ) {
      AnswerItem newAi;
      AnswerItem ai = (AnswerItem)itAi.next();

System.out.println ("Interview.clone: "+ (ai.getId())+" -> "+ai.getName()+
									" ("+ ai.getClass().getName()+" for "+ai.getIntrvOwner().getId()+")");
      
			if (ai instanceof AnswerType) {
//        newAi = (AnswerItem)((AnswerType)ai).clone();
				newAi = (AnswerType)ai.clone();
    	}
      else if (ai instanceof EnumType) {
//        newAi = (AnswerItem)((EnumType)ai).clone();
      	newAi = (EnumType)ai.clone();
      }
      else
      	newAi = (AnswerItem)ai.clone();
      
      newAi.setIntrvOwner(intrv);
/*
System.out.println ("Intrv.clone: AnswerItem: oldId: "+ai.getId()+"; newId: "+
			newAi.getId()+" class: "+ai.getClass().getName());
*/
    }

    for (Iterator iter = this.sections.iterator(); iter.hasNext(); ) {
      Section src = (Section)iter.next();
      Section aux = (Section)src.clone();
      System.out.print("=");
      aux.setInterview(intrv);
    }

    intrv.setParentPrj(getParentProj());
    intrv.setCanCreateSubject(this.canCreateSubject);
    intrv.setCanShorten(this.canShorten);
    intrv.setIsSampleIntrv(this.isSampleIntrv);
    intrv.setId(null);
    intrv.setPerformances(null);
    intrv.setSourceIntrv(this);
    
    return intrv;
  }
  
  

  public Interview getSourceIntrv () {
    return this.sourceIntrv;
  }

  
  public void setSourceIntrv(Interview source) {
    this.sourceIntrv = source;

    if (source != null) {
      this.sourceIntrv = source;
      source.getChildren().add(this);
    }
    else {
      this.sourceIntrv.getChildren().remove(this);
      this.sourceIntrv = null;
    }
  }

  public List<Interview> getChildren()
  {
    return this.children;
  }

  public void setChildren(List<Interview> children)
  {
    this.children = children;
  }

  public void removeChildren() {
    this.children.clear();
  }

  public List<AnswerItem> getAnswerItems()
  {
    return this.answerItems;
  }

  public void setAnswerItems(List<AnswerItem> answerItems)
  {
    this.answerItems = answerItems;
  }

  public void setAnswerItem(AnswerItem ai) {
    if (ai != null) {
      this.answerItems.add(ai);
      ai.setIntrvOwner(this);
    }
  }
}
