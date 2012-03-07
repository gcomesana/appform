package org.cnio.appform.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

/**
 * Expects entity.
 * 
 * @author MyEclipse Persistence Tools
 */
@Entity
@Table(name = "expects", schema = "public", uniqueConstraints = {})
public class Expects implements java.io.Serializable {

	// Fields

	private Integer idexpects;
	private Question question;
	private AnswerItem answerItem;

	// Constructors

	/** default constructor */
	public Expects() {
	}

	/** full constructor */
	public Expects(Integer idexpects, Question question, AnswerItem answerItem) {
		this.idexpects = idexpects;
		this.question = question;
		this.answerItem = answerItem;
	}

	// Property accessors
	@Id
	@Column(name = "idexpects", unique = true, nullable = false, insertable = true, updatable = true)
	public Integer getIdexpects() {
		return this.idexpects;
	}

	public void setIdexpects(Integer idexpects) {
		this.idexpects = idexpects;
	}

	@ManyToOne(cascade = {}, fetch = FetchType.LAZY)
	@JoinColumn(name = "codquestion", unique = false, nullable = false, insertable = true, updatable = true)
	public Question getQuestion() {
		return this.question;
	}

	public void setQuestion(Question question) {
		this.question = question;
	}

	@ManyToOne(cascade = {}, fetch = FetchType.LAZY)
	@JoinColumn(name = "codansitem", unique = false, nullable = false, insertable = true, updatable = true)
	public AnswerItem getAnswerItem() {
		return this.answerItem;
	}

	public void setAnswerItem(AnswerItem answerItem) {
		this.answerItem = answerItem;
	}

}