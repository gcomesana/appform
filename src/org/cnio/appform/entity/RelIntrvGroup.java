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
 * RelGrpAppusr entity.
 * 
 * @author MyEclipse Persistence Tools
 */
@Entity
@Table(name = "intrv_group")
public class RelIntrvGroup implements java.io.Serializable {

	// Fields
	@Id
	@Column(name="idintrv_group")
	@SequenceGenerator(sequenceName="intrv_group_idintrv_group_seq", name = "IntrvGroupSeqGen")
	@GeneratedValue(generator="IntrvGroupSeqGen", strategy = SEQUENCE)
	private Integer id;
	
	@ManyToOne(cascade = {}, fetch = FetchType.LAZY)
	@JoinColumn(name = "codgroup", unique = false, nullable = false, insertable = true, updatable = true)
	@ForeignKey(name="fk_intrvgroup_group")
	private AppGroup appgroup;
	
	@ManyToOne(cascade = {}, fetch = FetchType.LAZY)
	@JoinColumn(name = "codintrv", unique = false, nullable = false, insertable = true, updatable = true)
	@ForeignKey(name="fk_intrvgroup_intrv")
	private Interview intrv;

	// Constructors

	/** default constructor */
	public RelIntrvGroup () {
	}

	/** full constructor */
	public RelIntrvGroup (AppGroup appgroup, Interview intrv) {
		this.appgroup = appgroup;
		this.intrv = intrv;
		
		appgroup.getRelGrpIntrvs().add(this);
		intrv.getRelIntrvGrps().add(this);
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
		this.appgroup = appgroup;
		
		appgroup.getRelGrpIntrvs().add(this);
	}

	
	public Interview getIntrv() {
		return this.intrv;
	}

	public void setIntrv(Interview intrv) {
		this.intrv = intrv;
		
		intrv.getRelIntrvGrps().add(this);
	}

}