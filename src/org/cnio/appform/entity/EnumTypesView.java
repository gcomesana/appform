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
@Table(name="enumtypes_view")
public class EnumTypesView implements java.io.Serializable {
	
	@Column (name="idansit")
	private Integer idAnsit;
	
	@Id
	@Column (name="idenitem")
	private Integer idEnumItem;
	
	@Column(name="ansitname")
	private String ansItName;

	@Column(name="typename") // the NAME of the item in the enumerated type
	private String typeName;
	
	@Column(name="typevalue") // the VALUE of the item in the enumerated type
	private String typeValue;
	
	@Column(name="theorder")
	private Integer theOrder;
	
	
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
	
	
	public EnumTypesView () {
		intrvOwner = null;
	}
	
	
	public EnumTypesView (Interview owner) {
		this ();
		intrvOwner = owner;
	}
	
	
	public Integer getIdAnsit() {
		return idAnsit;
	}


	public void setIdAnsit(Integer idAnsit) {
		this.idAnsit = idAnsit;
	}


	public Integer getIdEnumItem() {
		return idEnumItem;
	}


	public void setIdEnumItem(Integer idEnumItem) {
		this.idEnumItem = idEnumItem;
	}


	public String getAnsItName() {
		return ansItName;
	}


	public void setAnsItName(String ansItName) {
		this.ansItName = ansItName;
	}


	public String getTypeName() {
		return typeName;
	}


	public void setTypeName(String typeName) {
		this.typeName = typeName;
	}


	public String getTypeValue() {
		return typeValue;
	}


	public void setTypeValue(String typeValue) {
		this.typeValue = typeValue;
	}


	public Integer getTheOrder() {
		return theOrder;
	}


	public void setTheOrder(Integer theOrder) {
		this.theOrder = theOrder;
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
