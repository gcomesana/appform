package org.cnio.appform.entity;

import javax.persistence.Entity;
import javax.persistence.OneToMany;
import javax.persistence.PrimaryKeyJoinColumn;
import javax.persistence.Column;
import javax.persistence.Table;
import javax.persistence.CascadeType;
import javax.persistence.FetchType;

import java.util.Collection;
import java.util.Iterator;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name="question")
//@PrimaryKeyJoinColumn(name="coditem")
@PrimaryKeyJoinColumn(name="idquestion")
public class Question extends AbstractItem implements Cloneable {
/*	@Column(name="mandatory")
	private Integer mandatory; */
	@Column(name="repeatable")
	private Integer repeatable;

// This column means a question either can or cant be deleted from the admin
// Primarily, this is the method to avoid the Patient code can be deleted
	@Column(name="mandatory")
	private Integer mandatory;
	
	@Column(name="codquestion")
	private String codquestion;

	@OneToMany(mappedBy="theQuestion", cascade={CascadeType.ALL})
	private List<QuestionsAnsItems> questionAnsItems;
	
/*	
	@OneToMany(mappedBy="question", cascade={CascadeType.ALL})
	private Collection<Answer> answers;
*/	
	
// Ternary relationship: one question is responded by several users with
// several questions
	@OneToMany(cascade = { CascadeType.ALL }, fetch = FetchType.LAZY, mappedBy = "question")
	private Collection<PatGivesAns2Ques> patAnsQues;
	
	public Question () {
		super ();
		questionAnsItems = new ArrayList<QuestionsAnsItems>();
//		answers = new ArrayList<Answer>();
		patAnsQues = new ArrayList<PatGivesAns2Ques>();
		
		repeatable = 0;
		mandatory = 0;
	}
	
	
	
	public Question (String content) {
		super (content);
		questionAnsItems = new ArrayList<QuestionsAnsItems>();
//		answers = new ArrayList<Answer>();
		repeatable = 0;
		mandatory = 0;
	}
	
	
	public Question (String content, String codQues) {
		this (content);
		
		this.codquestion = codQues;
	}

	
	public Integer getRepeatable() {
		return repeatable;
	}
	public void setRepeatable(Integer repeteable) {
		this.repeatable = repeteable;
	}

	public List<QuestionsAnsItems> getQuestionAnsItems() {
		return questionAnsItems;
	}

	public void setQuestionAnsItems(List<QuestionsAnsItems> questionAnsItems) {
		this.questionAnsItems = questionAnsItems;
	}

/*
	public Collection<Answer> getAnswers() {
		return answers;
	}

	public void setAnswers(Collection<Answer> answers) {
		this.answers = answers;
	}
*/


	public Collection<PatGivesAns2Ques> getPatAnsQues() {
		return patAnsQues;
	}



	public void setPatAnsQues(Collection<PatGivesAns2Ques> patAnsQues) {
		this.patAnsQues = patAnsQues;
	}



	public String getCodquestion() {
		return codquestion;
	}



	public void setCodquestion(String codquestion) {
		this.codquestion = codquestion;
	}



	public Integer getMandatory() {
		return mandatory;
	}


	public void setMandatory(Integer mandatory) {
		this.mandatory = mandatory;
	}
		
	
	public Object clone () throws CloneNotSupportedException {
		Question newQ = new Question (this.content, this.codquestion);
// clone method is not possible to be used here because the method just make a
// shallow copy of the object, holding the references to the lists
// then, when iteranting the lists, throws some concurrentmodificationexception
// because we dont have a actually new list, it is the same through the 
// reference
//		Question newQ = (Question)this.clone();
		newQ.setId(null);
		newQ.setHighlight(this.highlight);
		newQ.setItemOrder(this.itemOrder);
		newQ.setRepeatable(this.repeatable);
		newQ.setMandatory(this.mandatory);
		
		newQ.setPatAnsQues(new ArrayList<PatGivesAns2Ques>());
		
// M:N relationship replication steps:
// 1. new object list creation and member of this class assignment
// 2. cloned question assignment for each element in this list
// 3. we dont have the answer items to assign to the other element of the
//	QuestionsAnsItems and, therefore, the AnsItems side is pointing to the
//	"old" AnswerItem
		List<QuestionsAnsItems> lqa = new ArrayList<QuestionsAnsItems> ();
//		List<QuestionsAnsItems> lqa = newQ.getQuestionAnsItems();
/*		
		for (Iterator<QuestionsAnsItems> qaiIt = questionAnsItems.iterator(); 
					qaiIt.hasNext();) {
			QuestionsAnsItems qai = qaiIt.next(), qaiClone;
			qaiClone = (QuestionsAnsItems)qai.clone();
			qaiClone.setTheQuestion(newQ);
			
			lqa.add(qaiClone);
		}
*/		
		lqa.addAll(this.questionAnsItems);
		for (int i=0; i<lqa.size(); i++) {
			QuestionsAnsItems aux = (QuestionsAnsItems)lqa.get(i).clone();
			aux.setTheQuestion(newQ);
			lqa.set(i, aux);
			System.out.print("=");
		}
		
//		newQ.setQuestionAnsItems(lqa);
		
// cloning the containees		
		for (Iterator<AbstractItem> iter=containees.iterator(); iter.hasNext();) {
			AbstractItem item = (AbstractItem)iter.next();
			AbstractItem newOne;
			if (item instanceof Question) {
				newOne = (AbstractItem)((Question)item).clone();
//				((Question)newOne).setPatAnsQues(new ArrayList<PatGivesAns2Ques>());
//				((Question)newOne).setQuestionAnsItems(((Question)item).getQuestionAnsItems());
			}
			else
				newOne = (AbstractItem)((Text)item).clone();
			
			newOne.setContainer(newQ);
			System.out.print("=");
		}
		
// setting references for answer items and so
		return newQ;
	}
}
