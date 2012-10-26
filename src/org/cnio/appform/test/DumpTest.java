package org.cnio.appform.test;

import java.io.IOException;

import org.cnio.appform.util.dump.*;

public class DumpTest {

	public static void main (String[] args) {
		String prj = "PanGen-Eu";
		String intrv = "RecogidaMuestra_ES_PG";
		String grp = null;
		Integer orderSec = 1;
		Integer sortOrder = 1;
		
//		String fileName = "/Users/bioinfo/Development/dbdumps/aliquotsnew-isblac.props";
		String fileName = "/Users/bioinfo/Development/deploy/appform/batch/Part_pangen.props";
		
		try {
			MainDump md = new MainDump ();
			md.publicBatch(fileName);
		}
		catch (IOException ex) {
			ex.printStackTrace();
		}
	}
	
	
}
