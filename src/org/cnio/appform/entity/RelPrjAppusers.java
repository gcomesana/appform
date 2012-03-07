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
 * RelPrjAppusers entity.
 * 
 * @author MyEclipse Persistence Tools
 */
@Entity
@Table(name = "rel_prj_appusers")
public class RelPrjAppusers implements java.io.Serializable {

	// Fields rel_prj_appusers_idprj_usrs_seq
	@Id
	@Column(name="idprj_usrs")
	@SequenceGenerator(sequenceName="rel_grp_appusr_idgrp_usr_seq", name = "GroupUsrSeqGen")
	@GeneratedValue(generator="GroupUsrSeqGen", strategy = SEQUENCE)
	private Integer id;
	
	@ManyToOne(cascade = {}, fetch = FetchType.LAZY)
	@JoinColumn(name = "codprj", unique = false, nullable = false, insertable = true, updatable = true)
	@ForeignKey(name="fk_rel_prj__rel_prj_a_project")
	private Project project;
	
	@ManyToOne(cascade = {}, fetch = FetchType.LAZY)
	@JoinColumn(name = "coduser", unique = false, nullable = false, insertable = true, updatable = true)
	@ForeignKey(name="fk_rel_prj__rel_prj_a_appuser")
	private AppUser appuser;

	// Constructors

	/** default constructor */
	public RelPrjAppusers() {
	}

	/** full constructor */
	public RelPrjAppusers(Project project, AppUser appuser) {
		this.project = project;
		this.appuser = appuser;
		
		project.getRelPrjAppuserses().add(this);
		appuser.getRelPrjAppuserses().add(this);
	}

	// Property accessors
	public Integer getId() {
		return this.id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	
	public Project getProject() {
		return this.project;
	}

	public void setProject(Project project) {
		this.project = project;
		
		project.getRelPrjAppuserses().add(this);
	}

	
	public AppUser getAppuser() {
		return this.appuser;
	}

	public void setAppuser(AppUser appuser) {
		this.appuser = appuser;
		
		appuser.getRelPrjAppuserses().add(this);
	}

}