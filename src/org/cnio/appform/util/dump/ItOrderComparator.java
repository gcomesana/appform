package org.cnio.appform.util.dump;

import java.util.Comparator;

public class ItOrderComparator implements Comparator<String> {

	/**
	 * Compare two keys with the form OOOO.NN.PP where:
	 * - OOOO is the order of the item in the section
	 * - NN is the number of answer for the item at position OOOO
	 * - PP is the order of the answer for the item in position OOOO when the item
	 * has several answers (i.e. amount units - time units)
	 * The comparison is strictly using OOOO, as the position is the only item which
	 * has to be into account
	 * @param o1 - the first object to be compared.
	 * @param o2 - the second object to be compared.
	 * @return a negative integer, zero, or a positive integer as the first 
	 * argument is less than, equal to, or greater than the second. 
	 */
	public int compare(String k1, String k2) {
		
		String[] k1map = k1.split("\\.");
		String[] k2map = k2.split("\\.");
		
		Integer k1ItOrder = Integer.decode(k1map[0]), k2ItOrder = Integer.decode(k2map[0]);
		int itOrderComparison = k1ItOrder.compareTo(k2ItOrder);
		
		if (itOrderComparison == 0) {
			Integer k1AnsOrder = Integer.decode(k1map[2]), 
							k2AnsOrder = Integer.decode(k2map[2]);
			int ansComparison = k1AnsOrder.compareTo (k2AnsOrder);
			return ansComparison;
		}
		else
			return itOrderComparison;
	}

}