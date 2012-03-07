package org.cnio.appform.entity;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.Table;
import javax.persistence.Id;
import javax.persistence.Column;
import javax.persistence.SequenceGenerator;
import javax.persistence.GeneratedValue;
import static javax.persistence.GenerationType.AUTO;
import static javax.persistence.GenerationType.IDENTITY;
import static javax.persistence.GenerationType.SEQUENCE;
import javax.persistence.ManyToOne;
import javax.persistence.JoinColumn;
import javax.persistence.CascadeType;

import org.hibernate.annotations.ForeignKey;

@Entity
@Table(name="perf_history")
public class PerfUserHistory {
@Id
@Column(name="iduser_role")
@SequenceGenerator(sequenceName="user_role_iduser_role_seq", name = "UserRoleSeqGen")
@GeneratedValue(generator="UserRoleSeqGen", strategy = SEQUENCE)
	private Integer idhistory;
//	@ManyToOne (cascade={CascadeType.ALL})

	@ManyToOne (targetEntity=AppUser.class)
	@JoinColumn(name="coduser")
	@ForeignKey(name="user_history_fk")
	private AppUser theUser;
	
//	@ManyToOne (cascade={CascadeType.ALL})
	@ManyToOne (targetEntity=Performance.class)
	@JoinColumn(name="codperf")
	@ForeignKey(name="perf_history_fk")
	private Performance performance;
	
	@Column(name="thetimestamp")
	private Date timeStamp;
	
	@Column(name="justification")
  private String justification;
	
	
	/*
	@Column(name="rolename")
	private String roleName;
	*/
	public PerfUserHistory () { }
	
	public PerfUserHistory (AppUser u, Performance p) {
		this ();
		this.theUser = u;
		this.performance = p;
		
// Guarantee referential integrity
//		u.getAppuserRoles().add(this);
		u.getUserPerformances().add(this);
		p.getPerformanceUsers().add(this);
//		r.getAppuserRoles().add(this);

/*
 * or, for us
 * this.user.addUserRole(this);
 * this.role.addUserRole(this);
 * because we implement the method
 */		
	}


	public Integer getId() {
		return idhistory;
	}


	public void setId(Integer id) {
		this.idhistory = id;
	}


	public AppUser getTheUser() {
		return theUser;
	}


	public void setTheUser(AppUser theUser) {
		this.theUser = theUser;
		
		theUser.getUserPerformances().add(this);
	}


	public Performance getPerformance() {
		return performance;
	}

	public void setPerformance(Performance performance) {
		this.performance = performance;
		
		performance.getPerformanceUsers().add(this);
	}

	public Date getTimeStamp() {
		return timeStamp;
	}

	public void setTimeStamp(Date timeStamp) {
		this.timeStamp = timeStamp;
	}

	public String getJustification() {
    return justification;
  }

  public void setJustification(String justification) {
    this.justification = justification;
  }
  
  
  
	
}
