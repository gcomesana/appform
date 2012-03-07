package org.cnio.appform.entity;

import static javax.persistence.GenerationType.SEQUENCE;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.ForeignKey;

/**
 * PatGivesAnswer2ques entity.
 * 
 * @author MyEclipse Persistence Tools
 */
@Entity
@Table(name = "pat_gives_answer2ques", schema = "public", uniqueConstraints = {})
public class PatGivesAns2Ques implements java.io.Serializable {

	// Fields
	@Id
	@Column(name = "idp_a_q")
	@SequenceGenerator(name="PatAnsQuesGenerator", sequenceName = "pat_gives_answer2ques_idp_a_q_seq")
	@GeneratedValue(strategy=SEQUENCE, generator = "PatAnsQuesGenerator")
	private Integer id;
	
	@ManyToOne(cascade = {}, fetch = FetchType.LAZY)
	@JoinColumn(name = "codquestion", unique = false, nullable = true, insertable = true, updatable = true)
	@ForeignKey(name="fk_pat_give_rel_ques__question")
	private Question question;

	@ManyToOne(cascade = {}, fetch = FetchType.LAZY)
	@JoinColumn(name = "codanswer", unique = false, nullable = true, insertable = true, updatable = true)
	@ForeignKey(name="fk_pat_give_rel_ans_p_answer")
	private Answer answer;
	
	@ManyToOne(cascade = {}, fetch = FetchType.LAZY)
	@JoinColumn(name = "codpat", unique = false, nullable = true, insertable = true, updatable = true)
	@ForeignKey(name="fk_pat_give_rel_pat_a_patient")
	private Patient patient;
	
	@Column(name = "answer_number", unique = false, nullable = true, insertable = true, updatable = true)
	private Integer answerNumber;
	
	@Column(name = "answer_order", unique = false, nullable = true, insertable = true, updatable = true)
	private Integer answerOrder;

	@Column(name = "answer_grp", unique = false, nullable = true, insertable = true, updatable = true)
	private Integer answerGrp;
	// Constructors

	/** minimal constructor */
	public PatGivesAns2Ques() {
	}

/** Handy constructor to build the ternary relationship */	
	public PatGivesAns2Ques(Question question, Answer answer, Patient patient) {
		this.question = question;
		this.answer = answer;
		this.patient = patient;
		
// Assure bidirectional referential integrity
		question.getPatAnsQues().add(this);
		answer.getPatAnsQues().add(this);
		patient.getPatAnsQues().add(this);
	}
	
	/** full constructor */
	public PatGivesAns2Ques(Question question, Answer answer,
	    Patient patient, Integer answerNumber, Integer answerOrder) {
		this.question = question;
		this.answer = answer;
		this.patient = patient;
		this.answerNumber = answerNumber;
		this.answerOrder = answerOrder;
	}

	// Property accessors
	
	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	
	public Integer getIdpAQ() {
		return this.id;
	}

	public void setIdpAQ(Integer idpAQ) {
		this.id = idpAQ;
	}

	
	public Question getQuestion() {
		return this.question;
	}

	public void setQuestion(Question question) {
		this.question = question;
	}

	public Answer getAnswer() {
		return this.answer;
	}

	public void setAnswer(Answer answer) {
		this.answer = answer;
	}

	public Patient getPatient() {
		return this.patient;
	}

	public void setPatient(Patient patient) {
		this.patient = patient;
	}

	public Integer getAnswerNumber() {
		return this.answerNumber;
	}

	public void setAnswerNumber(Integer answerNumber) {
		this.answerNumber = answerNumber;
	}

	public Integer getAnswerOrder() {
		return this.answerOrder;
	}

	public void setAnswerOrder(Integer answerOrder) {
		this.answerOrder = answerOrder;
	}

		public Integer getAnswerGrp() {
		return answerGrp;
	}

	public void setAnswerGrp(Integer answerGrp) {
		this.answerGrp = answerGrp;
	}

}