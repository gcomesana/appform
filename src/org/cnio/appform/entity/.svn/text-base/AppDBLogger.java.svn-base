package org.cnio.appform.entity;

import static javax.persistence.GenerationType.SEQUENCE;

import org.hibernate.annotations.Cascade;

import java.util.Date;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.CascadeType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * Interface class with the applog database entity.
 * 
 * @author MyEclipse Persistence Tools
 */
@Entity
@Table(name = "applog")
public class AppDBLogger implements java.io.Serializable {

	// Fields performance_idperformance_seq
	@Id
	@Column(name="logid") // ojo con el generador
	@SequenceGenerator(name="LoggerGenerator", sequenceName = "applog_logid_seq")
	@GeneratedValue(strategy=SEQUENCE, generator = "LoggerGenerator")
	private Integer id;
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "thetime", 
					columnDefinition="TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL", 
					unique = true, nullable = true, insertable = true, updatable = true, length = 8)
	private Date evTime;
	
	@Column(name = "sessionid", unique = false, nullable = true, insertable = true, updatable = true, length = 256)
	private String sessionId;
	
	@Column(name = "intrvid", unique = false, nullable = true, insertable = true, updatable = true)
	private Integer intrvId;
	
	@Column(name = "patientid", unique = false, nullable = true, insertable = true, updatable = true)
	private Integer patId;
	
	@Column(name = "logmsg", unique = false, nullable = true, insertable = true, updatable = true, length = 256)
	private String message;
	
	@Column(name = "userid", unique = false, nullable = true, insertable = true, updatable = true)
	private Integer userId;

	@Column(name = "lastip", unique = false, nullable = true, insertable = true, updatable = true)
	private String lastIp;
	
	public AppDBLogger() {
		super();
//		evTime = new Date ();
		message = "";
		sessionId = "";
		lastIp = "";
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Date getEvTime() {
		return evTime;
	}

	public void setEvTime(Date evTime) {
		this.evTime = evTime;
	}

	public String getSessionId() {
		return sessionId;
	}

	public void setSessionId(String sessionId) {
		this.sessionId = sessionId;
	}

	public Integer getIntrvId() {
		return intrvId;
	}

	public void setIntrvId(Integer intrvId) {
		this.intrvId = intrvId;
	}

	public Integer getPatId() {
		return patId;
	}

	public void setPatId(Integer patId) {
		this.patId = patId;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public Integer getUserId() {
		return userId;
	}

	public void setUserId(Integer userId) {
		this.userId = userId;
	}

	public String getLastIp() {
		return lastIp;
	}

	public void setLastIp(String lastIp) {
		this.lastIp = lastIp;
	}
	
	
}	
	
	