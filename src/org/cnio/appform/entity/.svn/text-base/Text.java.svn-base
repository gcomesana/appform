package org.cnio.appform.entity;

import java.util.Iterator;

import javax.persistence.Entity;
import javax.persistence.SecondaryTable;
import javax.persistence.PrimaryKeyJoinColumn;
import javax.persistence.Column;


@Entity
//@PrimaryKeyJoinColumn(name="coditem")
@PrimaryKeyJoinColumn(name="idtext")
public class Text extends AbstractItem implements Cloneable {
	private Integer highlighted;

	public Text () {
		super ();
	}
	
	public Text (String content) {
		super (content);
	}
	
	
	public Integer getHighlighted() {
		return highlighted;
	}

	public void setHighlighted(Integer highlighted) {
		this.highlighted = highlighted;
	}
	
	public Object clone () throws CloneNotSupportedException {
		Text newTxt = new Text (this.content);
		newTxt.setId(null);
		newTxt.setHighlight(this.highlight);
		newTxt.setItemOrder(this.itemOrder);
		newTxt.setRepeatable(this.repeatable);
		
		
// cloning the containees
		for (Iterator<AbstractItem> iter=containees.iterator(); iter.hasNext();) {
			AbstractItem item = (AbstractItem)iter.next();
			AbstractItem newOne;
			if (item instanceof Question)
				newOne = (AbstractItem)((Question)item).clone();
			
			else
				newOne = (AbstractItem)((Text)item).clone();
			
			newOne.setContainer(newTxt);
			System.out.print("=");
		}
		
		return newTxt;
	}
}
