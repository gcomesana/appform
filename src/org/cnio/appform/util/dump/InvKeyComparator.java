package org.cnio.appform.util.dump;

import java.util.Comparator;

public class InvKeyComparator implements Comparator<String> {

	/**
	 * Compare to strings with the form NN.RRR.QQQQ.OO, where the different parts of
	 * the expected key are as follows:
	 * _ NN number of answer
	 * _ RRR order of the item in the questionnaire
	 * _ QQQQ is the cod question, such as XXXX
	 * _ OO is the order of the answer
	 * 
	 * So, k1 is greater than k2 if the different parts of k1 are greater than
	 * the same parts in k2, where QQQQ is a string and the rest of parts are numbers
	 * @param o1 - the first object to be compared.
	 * @param o2 - the second object to be compared.
	 * @return a negative integer, zero, or a positive integer as the first 
	 * argument is less than, equal to, or greater than the second. 
	 */
	public int compare(String k1, String k2) {
		
		String[] k1map = k1.split("\\.");
		String[] k2map = k2.split("\\.");
		
		Integer k1Id = Integer.decode(k1map[1]), k2Id = Integer.decode(k2map[1]);
		int idComparison = k1Id.compareTo(k2Id); 
		if (idComparison == 0) {
			Integer k1num = Integer.decode(k1map[0]), k2num = Integer.decode(k2map[0]);
			int numComparison = k1num.compareTo(k2num); 
			if (numComparison == 0) {
				Integer k1ord = Integer.decode(k1map[2]), k2ord = Integer.decode(k2map[2]);
				
				return k1ord.compareTo(k2ord);
			}
			else 
				return numComparison;
		}
		else
			return idComparison;
	}

}