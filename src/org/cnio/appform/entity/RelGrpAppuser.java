package org.cnio.appform.entity;

import static javax.persistence.GenerationType.SEQUENCE;

import javax.persistence.CascadeType;
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
 * RelGrpAppusr entity.
 * 
 * @author MyEclipse Persistence Tools
 */
@Entity
@Table(name = "rel_grp_appusr")
public class RelGrpAppuser implements java.io.Serializable {

	// Fields
	@Id
	@Column(name="idgrp_usr")
	@SequenceGenerator(sequenceName="rel_grp_appusr_idgrp_usr_seq", name = "GroupUsrSeqGen")
	@GeneratedValue(generator="GroupUsrSeqGen", strategy = SEQUENCE)
	private Integer id;
	
	@ManyToOne(cascade = {}, fetch = FetchType.LAZY)
	@JoinColumn(name = "codgroup", unique = false, nullable = false)
	@ForeignKey(name="fk_rel_grp__rel_grp_a_appgroup")
	private AppGroup appgroup;
	
	@ManyToOne(cascade = {}, fetch = FetchType.LAZY)
	@JoinColumn(name = "coduser", unique = false, nullable = false)
	@ForeignKey(name="fk_rel_grp__rel_grp_a_appuser")
	private AppUser appuser;
	
	@Column(name="active")
	private Integer active;	


	// Constructors

	/** default constructor */
	public RelGrpAppuser() {
		active = 0;
	}

	/** full constructor */
	public RelGrpAppuser(AppGroup appgroup, AppUser appuser) {
		this ();
		this.appgroup = appgroup;
		this.appuser = appuser;
		
		appgroup.getRelGrpAppusrs().add(this);
		appuser.getRelGrpAppusrs().add(this);
	}

	// Property accessors
	public Integer getId() {
		return this.id;
	}

	public void setId(Integer idgrpUsr) {
		this.id = idgrpUsr;
	}

	public AppGroup getAppgroup() {
		return this.appgroup;
	}

	public void setAppgroup(AppGroup appgroup) {
		if (appgroup != null) {
			this.appgroup = appgroup;
		
			appgroup.getRelGrpAppusrs().add(this);
		}
	}

	
	public AppUser getAppuser() {
		return this.appuser;
	}

	
	public void setAppuser(AppUser appuser) {
		if (appuser != null) {
			this.appuser = appuser;
		
			appuser.getRelGrpAppusrs().add(this);
		}
	}

	public Integer getActive() {
		return active;
	}

	public void setActive(Integer active) {
		this.active = active;
	}

}