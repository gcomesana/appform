package org.cnio.appform.entity;


import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import javax.persistence.Entity;
import javax.persistence.PrimaryKeyJoinColumn;
import javax.persistence.Column;
import javax.persistence.OneToMany;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.GeneratedValue;
import static javax.persistence.GenerationType.SEQUENCE;
import javax.persistence.CascadeType;

@Entity
//@PrimaryKeyJoinColumn(name="idansitem")
@PrimaryKeyJoinColumn(name="idenumtype")
public class EnumType extends AnswerItem implements Cloneable {
	
	@Column(name="numitems")
	private Integer numItems;
	
	@OneToMany(mappedBy="parentType", cascade={CascadeType.ALL})
	private List<EnumItem> items;

	
	public EnumType () {
		super ();
		items = new ArrayList<EnumItem>();
	}
	
	public EnumType (String name) {
		super (name);
		items = new ArrayList<EnumItem>();
	}
	
	public Integer getNumItems() {
		return numItems;
	}

	public void setNumItems(Integer numItems) {
		this.numItems = numItems;
	}

	public List<EnumItem> getItems() {
		return items;
	}

	public void setItems(List<EnumItem> items) {
		this.items = items;
	}

	public Object clone () throws CloneNotSupportedException {
		EnumType newEnum = new EnumType (this.getName());
		newEnum.setDescription(this.getDescription());
		
		List<Answer> lAnswers = new ArrayList<Answer>();
		List<QuestionsAnsItems> lQai = new ArrayList<QuestionsAnsItems>();
		newEnum.setAnswers(lAnswers);
		newEnum.setQuestionsAnsItems(lQai);
		for (Iterator<EnumItem> enIt = items.iterator(); enIt.hasNext();) {
			EnumItem ei = enIt.next();
			EnumItem theClone;
			
			theClone = (EnumItem)ei.clone();
			theClone.setParentType(newEnum);
		}
		
		return newEnum;
	}
	
}
