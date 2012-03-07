package org.cnio.appform.entity;

import static javax.persistence.GenerationType.SEQUENCE;

import java.util.ArrayList;
import java.util.Collection;

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


@Entity
@Table(name="simpletypes_view")
public class SimpleTypesView implements java.io.Serializable {
	
	@Id
	@Column (name="idansitem")
	private Integer idAnsitem;
	

	@Column(name="name")
	private String ansItName;

	
/*
	@OneToMany(mappedBy="theAnswerItem", cascade={CascadeType.ALL})
	private Collection<QuestionsAnsItems> questionsAnsItems;
	
	@OneToMany(cascade = { CascadeType.ALL }, fetch = FetchType.LAZY, mappedBy = "answerItem")
	private Collection<Answer> answers; 
*/
	
// Many interviews belong to a project	
	@ManyToOne(targetEntity=Interview.class)
	@JoinColumn(name="codintrv")
	private Interview intrvOwner;
	
	
	public SimpleTypesView () {
		intrvOwner = null;
	}
	
	
	public SimpleTypesView (Interview owner) {
		this ();
		intrvOwner = owner;
	}
	
	
	public Integer getIdAnsitem() {
		return idAnsitem;
	}


	public void setIdAnsitem(Integer idAnsit) {
		this.idAnsitem = idAnsit;
	}


	public String getAnsItName() {
		return ansItName;
	}


	public void setAnsItName(String ansItName) {
		this.ansItName = ansItName;
	}


	public Interview getIntrvOwner() {
		return intrvOwner;
	}


	public void setIntrvOwner(Interview intrvOwner) {
		
		this.intrvOwner = intrvOwner;
/*		
		if (intrvOwner != null) {
			this.intrvOwner = intrvOwner;
			intrvOwner.getAnswerItems().add(this);
		}
		else {
			this.intrvOwner.getAnswerItems().remove(this);
			this.intrvOwner = null;
		}
*/
	}
	
	
	
	public boolean equals (Object o) {
		return false;
	}
}
