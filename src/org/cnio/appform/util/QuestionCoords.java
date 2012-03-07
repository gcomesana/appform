package org.cnio.appform.util;


public class QuestionCoords {
	public Integer questionId;
	public String ansVal;
	public Integer ansOrder;
	public Integer ansNumber;
	
	public Integer idanswer;
	public Integer patId;
	public Integer idAnsItem;
	
	
	public QuestionCoords () {
		
	}
	
	
	public QuestionCoords (Integer qId, int ansNumber, int ansOrder) {
		questionId = qId;
		this.ansOrder = ansOrder;
		this.ansNumber = ansNumber;
	}
	
	
	
	public boolean equals (Object obj) {
		if (obj != null) {
			QuestionCoords qc = (QuestionCoords)obj;
			if (qc.ansNumber == null) {
				if (qc.ansOrder != null && this.questionId.compareTo(qc.questionId) == 0 && 
						this.ansOrder.compareTo(qc.ansOrder) == 0) 
					return true;
			}	
			
			else if (qc.ansNumber != null && qc.ansOrder != null &&
							this.questionId.compareTo(qc.questionId) == 0 && 
							this.ansNumber.compareTo(qc.ansNumber) == 0 &&
							this.ansOrder.compareTo(qc.ansOrder) == 0) 
					return true;
				
			else
					return false;
		} // EO first if
		return false;
	}
	
	
	public String toString () {
	
		String msg = "qId: "+questionId+"; num: "+ansNumber+"; ord: "+ansOrder;
		msg += "; ansVal: "+ansVal+"; idAns: "+idanswer+"; patId: "+patId;
		msg += "; idAnsItem: "+idAnsItem;
		
		return msg;
	}
	
} 
//////EO QuestionCoords ///////////////////////////////////////////////////////