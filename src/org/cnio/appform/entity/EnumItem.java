package org.cnio.appform.entity;

import javax.persistence.Entity;
import javax.persistence.Table;
import javax.persistence.Id;
import javax.persistence.Column;
import javax.persistence.SequenceGenerator;
import javax.persistence.GeneratedValue;
import static javax.persistence.GenerationType.SEQUENCE;
import javax.persistence.ManyToOne;
import javax.persistence.JoinColumn;

import org.hibernate.annotations.ForeignKey;

@Entity
@Table(name="enumitem")
public class EnumItem implements Cloneable {
	@Id
	@Column(name="idenumitem")
	@SequenceGenerator(sequenceName="enumitem_idenumitem_seq", name = "EnumItSeqGen")
	@GeneratedValue(generator="EnumItSeqGen", strategy = SEQUENCE)
	private Integer id;
	@Column(name="name")
	private String name;
	@Column(name="description")
	private String description;
	@Column(name="thevalue")
	private String value;
	@Column(name="listorder")
	private Integer listOrder;
	
	@ManyToOne(targetEntity=EnumType.class)
//	@JoinColumn(name="idenumtype")
	@JoinColumn(name="codenumtype")
	@ForeignKey(name="fk_enumitem_contains_enumtype")
	private EnumType parentType;

	
	public EnumItem () { }
	
	public EnumItem (String name, String value) {
		this.name = name;
		this.value = value;
	}
	
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

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

	public EnumType getParentType() {
		return parentType;
	}

	public void setParentType(EnumType parentType) {
		this.parentType = parentType;
		
		parentType.getItems().add(this);
	}

	public Integer getListOrder() {
  	return listOrder;
  }

	public void setListOrder(Integer listOrder) {
  	this.listOrder = listOrder;
  }
	
	
	public Object clone () throws CloneNotSupportedException {
		EnumItem ei = new EnumItem (this.name, this.value);
		ei.setListOrder(this.listOrder);
		
		return ei;
	}
	
}
