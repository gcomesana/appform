package org.cnio.appform.entity;


import java.util.List;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.ArrayList;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Column;
import javax.persistence.SequenceGenerator;
import javax.persistence.GeneratedValue;
import static javax.persistence.GenerationType.SEQUENCE;
import javax.persistence.OneToMany;
import static javax.persistence.CascadeType.ALL;
import javax.persistence.Table;
import static javax.persistence.InheritanceType.JOINED;
import javax.persistence.Inheritance;
import javax.persistence.ManyToOne;
import javax.persistence.JoinColumn;
import javax.persistence.CascadeType;

import org.hibernate.annotations.ForeignKey;


@Entity
@Table(name="item")
@Inheritance(strategy=JOINED)
public abstract class AbstractItem {
	@Id
	@Column(name="iditem")
	@GeneratedValue(strategy=SEQUENCE, generator = "AbsItemSeqGen")
	@SequenceGenerator(sequenceName="item_iditem_seq", name = "AbsItemSeqGen")
	protected Long id;
	
	@Column(name="item_order")
	protected Long itemOrder;
	
	@Column(name="content")
	protected String content;
	
	@Column(name="repeatable")
	protected Integer repeatable;
	
	@Column(name="highlight")
	protected Integer highlight;

@ManyToOne(targetEntity=AbstractItem.class)
@JoinColumn(name="ite_iditem") // this actually is the foreign key column
@ForeignKey(name="fk_item_contains_item")
	protected AbstractItem container;
	
// @OneToMany(mappedBy="container", cascade={CascadeType.ALL})
@OneToMany(mappedBy="container", cascade={CascadeType.MERGE, CascadeType.PERSIST})
	protected List<AbstractItem> containees;
	

@ManyToOne(targetEntity=Section.class)
@JoinColumn(name="idsection")
@ForeignKey(name="fk_item_is_formed_section")
	protected Section parentSec;
	

// Final public variables to represent the decorations for this item
// The code is as follows:
/* 0. no decorations, normal
 * 1. bold
 * 2. italic
 * 4. underline
 * 3. (1+2) italic+bold
 * 5. (1+4) bold+underline
 * 6. (2+4) italic+underline
 * 7. (1+2+4) all of them
 */
	public static final int HIGHLIGHT_NORMAL = 0;
	public static final int HIGHLIGHT_BOLD = 1;
	public static final int HIGHLIGHT_ITALIC = 2;
	public static final int HIGHLIGHT_UNDERLINE	= 4;
	
	public static final int HIGHLIGHT_ITABOLD	= 3;
	public static final int HIGHLIGHT_UNDERBOLD	= 5;
	public static final int HIGHLIGHT_UNDERITAL	= 6;
	public static final int HIGHLIGHT_FULL	= 7;
	
	public AbstractItem () { 
		containees = new ArrayList<AbstractItem>();
		container = null;
		highlight = HIGHLIGHT_NORMAL;
	}
	
	public AbstractItem (String content){
		this();
		this.content = content;
	}
	
	
	public AbstractItem (String content, Integer order, Section parent){
		this (content);
		itemOrder = new Long (order);
		parentSec = parent;
		
		parent.getItems().add(this);
	}
	
	public AbstractItem (String content, Section parent) {
		this (content);
		parentSec = parent;
		
		parent.getItems().add(this);
	}
	

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getItemOrder() {
		return itemOrder;
	}

	public void setItemOrder(Long itemOrder) {
		this.itemOrder = itemOrder;
	}

	public String getContent() {
		return content;
	}
	
	public Integer getRepeatable() {
		return repeatable;
	}
	public void setRepeatable(Integer repeteable) {
		this.repeatable = repeteable;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public AbstractItem getContainer() {
		return container;
	}

	
	public void setContainer(AbstractItem container) {
		if (container != null) {
			this.container = container;
			container.getContainees().add(this);
		}
		else {
			this.container.getContainees().remove(this);
			this.container = null;
		}
	}
	

	public List<AbstractItem> getContainees() {
		return containees;
	}

	public void setContainees(List<AbstractItem> containees) {
		this.containees = containees;
	}

	public void removeContainees () {
		containees.clear();
	}
	
	
	public Section getParentSec() {
		return parentSec;
	}

	public void setParentSec(Section parentSec) {
				
		if (parentSec != null)  {
			this.parentSec = parentSec;
			parentSec.getItems().add(this);
		}
		else  {
			this.parentSec.getItems().remove(this);
			this.parentSec = null;
		}
		
// This is to set the section for the grandchildren and deeper relatives		
		for (Iterator<AbstractItem> it = getContainees().iterator();
		 			it.hasNext();) {
			AbstractItem child = it.next();
			child.setParentSec(parentSec);
		}
	}

	public Integer getHighlight() {
		return highlight;
	}

	public void setHighlight(Integer highlight) {
		this.highlight = highlight;
	}
}
