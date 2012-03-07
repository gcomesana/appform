package org.cnio.appform.util.dump;

import java.util.Comparator;

public class KeyComparator implements Comparator<String> {

	/**
	 * Compare to strings with the form RRRR.NN.OO, where the different parts of
	 * the expected key are numbers. So, k1 > k2 if:
	 * - RRRR1 > RRRR2 or
	 * - RRRR1 == RRRR2 && NN1 > NN2 or
	 * - RRRR1 == RRRR2 && NN1 == NN2 && OO1 > OO2
	 * where 
	 * _ RRRR is the item order (to keep the order on questionnaire)
	 * _ NN is the number of answer when repeatable questions happens
	 * _ OO is the order of the answers in a question (such as m - cm)
	 * 
	 * @param o1 - the first object to be compared.
	 * @param o2 - the second object to be compared.
	 * @return a negative integer, zero, or a positive integer as the first 
	 * argument is less than, equal to, or greater than the second. 
	 */
	public int compare(String k1, String k2) {
		
		String[] k1map = k1.split("\\.");
		String[] k2map = k2.split("\\.");
		
		Integer k1ItOrd = Integer.decode(k1map[0]), k2ItOrd = Integer.decode(k2map[0]);
		int itOrdComparison = k1ItOrd.compareTo(k2ItOrd); 
		if (itOrdComparison == 0) {
			Integer k1num = Integer.decode(k1map[1]), k2num = Integer.decode(k2map[1]);
			int numComparison = k1num.compareTo(k2num); 
			if (numComparison == 0) {
				Integer k1ord = Integer.decode(k1map[2]), k2ord = Integer.decode(k2map[2]);
				
				return k1ord.compareTo(k2ord);
			}
			else 
				return numComparison;
		}
		else
			return itOrdComparison;
	}

}