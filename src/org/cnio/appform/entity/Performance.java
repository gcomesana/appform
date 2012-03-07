package org.cnio.appform.entity;

import static javax.persistence.GenerationType.SEQUENCE;

import org.hibernate.annotations.Cascade;
import org.hibernate.annotations.ForeignKey;

import java.util.Date;
import java.util.List;
import java.util.ArrayList;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.CascadeType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * Performance entity.
 * 
 * @author MyEclipse Persistence Tools
 */
@Entity
@Table(name = "performance")
public class Performance implements java.io.Serializable {

	// Fields performance_idperformance_seq
	@Id
	@Column(name="idperformance") // ojo con el generador
	@SequenceGenerator(name="PerformanceGenerator", sequenceName = "performance_idperformance_seq")
	@GeneratedValue(strategy=SEQUENCE, generator = "PerformanceGenerator")
	private Integer id;
	
	@ManyToOne(fetch = FetchType.LAZY)
//	@Cascade(org.hibernate.annotations.CascadeType.LOCK)
	@JoinColumn(name = "coduser", unique = false, nullable = true, insertable = true, updatable = true)
	@ForeignKey(name="fk_performa_rel_appus_appuser")
	private AppUser appuser;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "codinterview", unique = false, nullable = true, insertable = true, updatable = true)
	@ForeignKey(name="fk_performa_rel_intrv_intervie")
	private Interview interview;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "codpat", unique = false, nullable = true, insertable = true, updatable = true)
	@ForeignKey(name="fk_performa_rel_pat_p_patient")
	private Patient patient;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "codgroup", unique = false, nullable = true, insertable = true, updatable = true)
	@ForeignKey(name="fk_performa_rel_group")
	private AppGroup group;
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "date_ini", unique = false, nullable = true, insertable = true, updatable = true, length = 8)
	private Date dateIni;
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "date_end", unique = false, nullable = true, insertable = true, updatable = true, length = 8)
	private Date dateEnd;
	
	@Column(name = "place", unique = false, nullable = true, insertable = true, updatable = true, length = 256)
	private String place;
	
	@Column(name = "num_order", unique = false, nullable = true, insertable = true, updatable = true)
	private Integer numOrder;
	
	@Column(name = "last_sec", unique = false, nullable = true, insertable = true, updatable = true)
	private Integer lastSec;
	
	
//for the M:N relationship with users
	@OneToMany(mappedBy="performance")
	@Cascade(org.hibernate.annotations.CascadeType.SAVE_UPDATE)
	private List<PerfUserHistory> performanceUsers;

	// Constructors

	/** default constructor */
	public Performance() {
		this.lastSec = 1;
	}

	/** minimal constructor */
	public Performance(Integer idperformance) {
		this.id = idperformance;
	}

	/** full constructor */
	public Performance(AppUser appuser, Interview interview, 
										Patient patient, AppGroup group) {
		this ();
		this.appuser = appuser;
		this.interview = interview;
		this.patient = patient;
		this.group = group;
		
	// Guarantee referential integrity (see QuestionsAnsItems.java)
		appuser.getPerformances().add(this);
		interview.getPerformances().add(this);
		patient.getPerformances().add(this);
		group.getPerformances().add(this);
		
		performanceUsers = new ArrayList<PerfUserHistory>();
		dateIni = new Date ();
		
	}

	// Property accessors
	public Integer getId() {
		return this.id;
	}

	public void setId(Integer idperformance) {
		this.id = idperformance;
	}

	public AppUser getAppuser() {
		return this.appuser;
	}

	public void setAppuser(AppUser appuser) {
		this.appuser = appuser;
		if (appuser != null)
			appuser.getPerformances().add(this);
	}

	public Interview getInterview() {
		return this.interview;
	}

	public void setInterview(Interview interview) {
		this.interview = interview;
		
		interview.getPerformances().add(this);
	}

	public Patient getPatient() {
		return this.patient;
	}

	public void setPatient(Patient patient) {
		this.patient = patient;
		
		patient.getPerformances().add(this);
	}

	public Date getDateIni() {
		return this.dateIni;
	}

	public void setDateIni(Date dateIni) {
		this.dateIni = dateIni;
	}

	public String getPlace() {
		return this.place;
	}

	public void setPlace(String place) {
		this.place = place;
	}

	public Integer getNumOrder() {
		return this.numOrder;
	}

	public void setNumOrder(Integer numOrder) {
		this.numOrder = numOrder;
	}

	public Date getDateEnd() {
		return this.dateEnd;
	}

	public void setDateEnd(Date dateEnd) {
		this.dateEnd = dateEnd;
	}

	public Integer getLastSec() {
		return lastSec;
	}

	public void setLastSec(Integer lastSec) {
		if (lastSec > this.lastSec)
			this.lastSec = lastSec;
	}

	public AppGroup getGroup() {
		return group;
	}

	public void setGroup(AppGroup group) {
		this.group = group;
	}

	public List<PerfUserHistory> getPerformanceUsers() {
		return performanceUsers;
	}

	public void setPerformanceUsers(List<PerfUserHistory> performanceUsers) {
		this.performanceUsers = performanceUsers;
	}

}