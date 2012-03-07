package org.cnio.appform.entity;

import java.util.List;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.Collection;
import java.util.ArrayList;

import javax.persistence.CascadeType;
import javax.persistence.FetchType;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Column;
import javax.persistence.SequenceGenerator;
import javax.persistence.GeneratedValue;
import static javax.persistence.GenerationType.SEQUENCE;
import javax.persistence.OneToMany;
import static javax.persistence.CascadeType.ALL;
import javax.persistence.Table;

@Entity
@Table(name="Patient")
public class Patient {
	@Id
	@Column(name="idpat") // ojo con el generador, puede ser patient_idpat_seq
	@SequenceGenerator(name="PatientGenerator", sequenceName = "patient_idpatient_seq")
	@GeneratedValue(strategy=SEQUENCE, generator = "PatientGenerator")
	private Integer id;
	@Column(name="name")
	private String name;
	@Column(name="codpatient")
	private String codpatient;
	
	@Column(name="phone")
	private String phone;
	
	@Column(name="numhc")
	private String numHC;
	
	@Column(name="address")
	private String theAddress;
	
	@Column(name="codprj")
	private String codPrj;
	
	@Column(name="codhosp")
	private String codHosp;
	
	@Column(name="cod_type_subject")
	private String codCaseCtrl;
	
	@Column(name="codpat")
	private String codSubject;
	
	
/*One interview instance is done for many users	
	@OneToMany(mappedBy="thePatient", cascade={CascadeType.ALL})
	private Collection<UsrPatIntrinst> ternaryItems;
*/	
	
  @OneToMany(cascade = { CascadeType.ALL }, fetch = FetchType.LAZY, mappedBy = "patient")
	private Collection<Performance> performances;
	
// One patient gives several answers for several questions  
  @OneToMany(cascade = { CascadeType.ALL }, fetch = FetchType.LAZY, mappedBy = "patient")
	private Collection<PatGivesAns2Ques> patAnsQues;
	
	public Patient () {
		patAnsQues = new ArrayList<PatGivesAns2Ques>();
		performances = new ArrayList<Performance>();
		
		codPrj = "";
		codHosp = "";
		codCaseCtrl = "";
		codSubject = "";
	}

	public Patient (String code) {
		this ();
		
		this.codpatient= code;
	}
/*	
	public Section (String username, String passwd, AbstractItem anItem) {
		this ();
		
		sectionOrder = 1;
		this.username = username;
		this.passwd = passwd;
		items.add(anItem);		
	}
	*/
	
		
	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getCodpatient() {
		return codpatient;
	}

	public void setCodpatient(String codpatient) {
		this.codpatient = codpatient;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getNumHC() {
		return numHC;
	}

	public void setNumHC(String numHC) {
		this.numHC = numHC;
	}

	public String getTheAddress() {
		return theAddress;
	}

	public void setTheAddress(String theAddress) {
		this.theAddress = theAddress;
	}
	
	public String toString () {
		return "Patient -> id: "+id+", cod patient: "+codpatient;
	}
/*
	public Collection<UsrPatIntrinst> getTernaryItems() {
		return ternaryItems;
	}

	public void setTernaryItems(Collection<UsrPatIntrinst> ternaryItems) {
		this.ternaryItems = ternaryItems;
	}
*/
	public Collection<Performance> getPerformances() {
		return performances;
	}

	public void setPerformances(Collection<Performance> performances) {
		this.performances = performances;
	}

	public Collection<PatGivesAns2Ques> getPatAnsQues() {
		return patAnsQues;
	}

	public void setPatAnsQues(Collection<PatGivesAns2Ques> patAnsQues) {
		this.patAnsQues = patAnsQues;
	}

	
	public String getCodPrj() {
		return codPrj;
	}

	public void setCodPrj(String codPrj) {
		this.codPrj = codPrj;
	}

	public String getCodHosp() {
		return codHosp;
	}

	public void setCodHosp(String codHosp) {
		this.codHosp = codHosp;
	}

	public String getCodCaseCtrl() {
		return codCaseCtrl;
	}

	public void setCodCaseCtrl(String codCaseCtrl) {
		this.codCaseCtrl = codCaseCtrl;
	}

	public String getCodSubject() {
		return codSubject;
	}

	public void setCodSubject(String codSubject) {
		this.codSubject = codSubject;
	}
}

