package org.cnio.appform.test;

import org.cnio.appform.entity.Section;
import org.cnio.appform.entity.AbstractItem;
import org.cnio.appform.entity.Text;
import org.cnio.appform.entity.Question;
import org.cnio.appform.entity.AnswerType;
import org.cnio.appform.entity.AnswerItem;
import org.cnio.appform.entity.EnumItem;
import org.cnio.appform.entity.EnumType;
import org.cnio.appform.entity.QuestionsAnsItems;

import org.cnio.appform.util.HibernateUtil;
import org.cnio.appform.util.HibController;
import org.cnio.appform.util.LogFile;

import org.hibernate.Session;
import org.hibernate.Criteria;
import org.hibernate.HibernateException;
import org.hibernate.Transaction;
import org.hibernate.criterion.Restrictions;

import static org.hibernate.criterion.Restrictions.*;

import java.util.Collection;
import java.util.Iterator;
import java.util.Hashtable;
import java.util.Enumeration;
import java.util.LinkedList;
import java.util.List;

public class WaterTest {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		Session hibSess = HibernateUtil.getSessionFactory().openSession();
		WaterTest test = new WaterTest ();
		
		try  {
/*			
			java.util.List<AbstractItem> l = HibController.ItemManager.getLastItem(hibSess);
			if (l != null) {
				System.out.println("num results: "+l.size());
				for (AbstractItem ait: l) {
					System.out.println (ait.getId()+"-"+ait.getContent());
				}
			}
*
			AbstractItem ait = HibController.ItemManager.getLastItem(hibSess);
			if (ait != null)
				System.out.println (ait.getId()+"-"+ait.getContent());*/
			test.sampleDataTypes (hibSess);
		}
		catch (Exception unEx) {
			unEx.printStackTrace();
		}
/*
		Collection<Section> lSecs =
									HibController.SectionCtrl.getSectionByName(hibSess, "Agua");
		Iterator<Section> itSec = lSecs.iterator();
		Section newSec = itSec.next();
LogFile.stdout("id: "+newSec.getId()+" - " +newSec.getName());

// Section superquestions aka containers
		Collection<AbstractItem> containers = 
									HibernateUtil.getContainers4Section(hibSess, newSec);
LogFile.stdout("containers: "+containers.size());		
		Iterator<AbstractItem> itCol = containers.iterator();
		AbstractItem container = itCol.next();

// Superquestons' aka Container's children aka questions aka containees
		Collection<AbstractItem> children = 
				HibController.ItemManager.getOrderedContainees(hibSess, container);

LogFile.stdout("numChildren: "+children.size());

//		test.composeCxQstn(hibSess, newSec);
	//							HibernateUtil.getAnswerTypes4Question(hibSess, child);
 
 */
//		test.sampleDataTypes(hibSess);
//		Section newSec = test.composeSection(hibSess);
//		test.composeCxQstn(hibSess, newSec);
		//		HibController.RenderEng.viewSection(hibSess, newSec);
		


		
/*		
		Section sec = (Section)hibSess.createCriteria(Section.class).uniqueResult();
		Collection<AnswerItem> ansItCol = 
											hibSess.createCriteria(AnswerItem.class).list();
		AnswerItem[] ansItArr = (AnswerItem[])ansItCol.toArray(new AnswerItem[0]);
		
		if (sec != null) {
			test.getSectionItemsDet(hibSess, sec);
		} */
		
		
		hibSess.close();
	}
	

	
	private void testJsp (Session hibSes) throws java.io.UnsupportedEncodingException {
		String op = "new",
		t = "ele";
		
		String isText = null,
		content = 
			java.net.URLDecoder.decode("A%20continuaci%C3%B3n%20se%20interrogar%C3%A1%20" +
				"sobre%20gustos%20sesuales", "UTF-8"),
		container = null,
		secId = "100",
		qStr = "t=ele&frmStmt=A%20continuaci%C3%B3n%20se%20interrogar%C3%A1%20" +
				"sobre%20gustos%20sesuales&frmMandatory=1&frmAnswers=51&" +
				"frmAnswers=102&frmNewSec=100";

//		Session hibSes = HibernateUtil.getSessionFactory().openSession();
		boolean res = false;
					
		int secParentId=-1, containerId=-1;
		
		if (secId != null)
			secParentId = Integer.parseInt(secId);
		
		if (container != null)
			containerId = Integer.parseInt(container);
		
		if (isText != null) { 
			Text txt = HibController.ItemManager.createText(hibSes, content, 
																					 				secParentId, containerId);
			if (txt == null)
				res = false;
		}
		else {
			String mandatory = "1",
						 repeat = null;
			
			int iMandatory, iRep;
			iMandatory = (mandatory == null || mandatory.equalsIgnoreCase("0"))? 0: 1;
			iRep = (repeat == null)? 0: 1;
			
			String[] ansItems = {"51","102"};
			int ansItemsLen = (ansItems == null)? 1: ansItems.length;
			int[] ansItemsId = new int [ansItemsLen];

			if (ansItems != null) {
				for (int i=0; i<ansItems.length; i++) 
					ansItemsId[i] = Integer.parseInt(ansItems[i]);
			}
// Create the question with the first answer type item			
			Question newQ = 
				HibController.ItemManager.createQuestion(hibSes, content, ansItemsId[0], 
																	iMandatory, iRep, secParentId, containerId);

			if (newQ != null) {
// Now the rest of answer item types gotta be assigned to the new question
				for (int i=1; i<ansItemsId.length; i++) {
					AnswerItem ai = (AnswerItem)hibSes.get(AnswerItem.class, 
																								 new Long (ansItemsId[i]));
					
					if (ai != null) {
						HibernateUtil.setAnswerType(hibSes, newQ, ai);
						HibernateUtil.setAnswerOrder(newQ, ai, i+1);
					}
				}
			}
			else
				res = false;

		}
		
		hibSes.close();
		
	}
	
	
	private void sampleDataTypes (Session hibSess) {
		String content, aux;
		Transaction tx;
		
		aux = "Label";
		content = "This is a type of answer for representing strings or labels";
		HibernateUtil.createSimpleType(hibSess, aux, content, "");
		
		aux = "Number";
		content = "This is a type of answer for representing simple numbers";
		HibernateUtil.createSimpleType(hibSess, aux, content, "");
/*		
		tx = hibSess.beginTransaction();
		EnumType workDays = new EnumType ();
		aux = "WorkDays";
		workDays.setName(aux);
		content = "This enumeration type contains the workdays";
		workDays.setDescription(content);
		hibSess.save(workDays);
		tx.commit();
*/		
		Hashtable<Integer, String> auxHash = new Hashtable<Integer, String> ();
		auxHash.clear();
		auxHash.put(1, "Yes");
		auxHash.put(2, "No");
		auxHash.put(99, "Unknown");
//		HibController.EnumTypeCtrl.createEnumType (hibSess, "Yes-No (EN)", auxHash);
		
/* 	set the workdays	
		tx = hibSess.beginTransaction(); *
		Criteria crit = hibSess.createCriteria(EnumType.class);
		crit.add(Restrictions.eq("name", "WorkDays"));
		EnumType workDays = (EnumType)crit.uniqueResult();*
		LogFile.stdout("workdays name: "+workDays.getName());
		
		boolean res = 
			HibController.EnumTypeCtrl.addItem2Enum (hibSess, workDays, 
																								"1", "Monday") &&
			HibController.EnumTypeCtrl.addItem2Enum (hibSess, workDays, 
																								"2", "Tuesday") &&
			HibController.EnumTypeCtrl.addItem2Enum (hibSess, workDays, 
																								"3", "Wednesday") &&
			HibController.EnumTypeCtrl.addItem2Enum (hibSess, workDays, 
																								"4", "Thursday") &&
			HibController.EnumTypeCtrl.addItem2Enum (hibSess, workDays, 
																								"5", "Friday");

		if (res) {
			LogFile.stdout("Workdays added succesfully");
			Collection<EnumItem> items = 
												HibController.EnumTypeCtrl.itemsFromEnum (hibSess, 
																																	"WorkDays");
			Iterator<EnumItem> t = items.iterator();
			while (t.hasNext()) {
				EnumItem tmp = t.next();
				LogFile.stdout(tmp.getId()+". "+tmp.getValue());
			}
		}
		else
			LogFile.stderr("Unable to add workdays");
		
				
		// First the enum types
			auxHash.put(1, "January");
			auxHash.put(2, "February");
			auxHash.put(3, "March");
			auxHash.put(4, "April");
			auxHash.put(5, "May");
			auxHash.put(6, "June");
			auxHash.put(7, "July");
			auxHash.put(8, "August");
			auxHash.put(9, "September");
			auxHash.put(10, "October");
			auxHash.put(11, "November");
			auxHash.put(12, "December");
			HibController.EnumTypeCtrl.createEnumType (hibSess, "Months (EN)", auxHash);
			
			int curYear = java.util.Calendar.getInstance().get(java.util.Calendar.YEAR);
			for (int i=1970; i<= curYear; i++) 
				auxHash.put(new Integer(i), Integer.toString(i));
			HibController.EnumTypeCtrl.createEnumType (hibSess, "Years (EN)", auxHash);
			*/
			
	}
	
	
	private void composeCxQstn (Session ses, Section sec) {
// conseguir el n�mero de items para la seccion
// crear la pregunta
// establecer un orden
// a�adirla como componente de la seccion		
// establecer los dos tipos de datos de respuesta
// establecer el orden de la respuestas

		if (ses == null || !ses.isOpen())
			ses = HibernateUtil.getSessionFactory().openSession();
		
		Collection<AbstractItem> colIt = 
														HibernateUtil.getItems4Section(ses, sec);
LogFile.stderr("num of items" + " for "+sec.getName()+": "+colIt.size());

		Transaction tx = ses.beginTransaction();
		String qTxt = "Desde cu�ndo vive en esa direcci�n?";
		Question q = new Question (qTxt);
		q.setItemOrder(new Long (colIt.size()+1));
		q.setParentSec(sec);
		ses.save(q);
		tx.commit();
		
		HibernateUtil.setAnswerType(ses, q, 
																HibernateUtil.getAnswerItem(ses, "Months"));
		HibernateUtil.setAnswerType(ses, q, 
																HibernateUtil.getAnswerItem(ses, "Years"));
		Collection<AnswerItem> colAit = 
															HibernateUtil.getAnswerTypes4Question(ses, q);
		int j=1;
		for (AnswerItem ansIt: colAit) {
			HibernateUtil.setAnswerOrder(q, ansIt, j++);
		}
	}
	
	
/**
 * Compose a particular section and return this one 
 * @param hibSes, the session to perform the transactions
 * @return the section newly created
 */	
	private Section composeSection (Session hibSes) {
		
		Transaction tx = hibSes.getTransaction();
		try {
			tx = (!tx.isActive())? hibSes.beginTransaction(): tx;
			
			AnswerItem qNumType = 
				HibernateUtil.getAnswerItem(hibSes, HibController.TYPE_NUMBER);
			AnswerItem qLabelType = 
				HibernateUtil.getAnswerItem(hibSes, HibController.TYPE_LABEL);
			
			Section waterSec = new Section ("Secci�n D - Agua", 
																			"Consumo y uso del agua");
			waterSec.setSectionOrder(new Integer (3));
			hibSes.save(waterSec);
			tx.commit();
	
	// This text will be composed by several questions to define an address
			Collection<Section> colSec = 
				HibController.SectionCtrl.getSectionByName(hibSes, "Secci�n D - Agua");
			Section aux = colSec.iterator().next();
			Text txt = HibController.ItemManager.createText(hibSes, "D�game su residencia actual", 
																					aux.getId().intValue(), -1);
			
			Question qVia = 
				HibController.ItemManager.createQuestion(hibSes, "Tipo de v�a p�blica", -1, 
																				HibernateUtil.OPTIONAL, 
																				HibernateUtil.SINGLE, aux.getId(), 
																				txt.getId().intValue());
	// the via publica enum type has to be added here later
			
			Question qNumber = 
				HibController.ItemManager.createQuestion(hibSes, "N�mero", 
																			qNumType.getId().intValue(), 0, 0, 
																			aux.getId().intValue(), 
																			txt.getId().intValue());
			Question qBloc = 
				HibController.ItemManager.createQuestion(hibSes, "Bloque", 
																		qLabelType.getId().intValue(), 0, 0, 
																		aux.getId().intValue(), 
																		txt.getId().intValue());
			Question qStairs = 
				HibController.ItemManager.createQuestion(hibSes, "Escalera", 
																		qLabelType.getId().intValue(), 0, 0, 
																		aux.getId().intValue(), 
																		txt.getId().intValue());
			Question qFloor = 
				HibController.ItemManager.createQuestion(hibSes, "Piso", 
																		qNumType.getId().intValue(), 0, 0, 
																		aux.getId().intValue(), 
																		txt.getId().intValue());
			Question qDoor = 
				HibController.ItemManager.createQuestion(hibSes, "Puerta", 
																		qLabelType.getId().intValue(), 0, 0, 
																		aux.getId().intValue(), 
																		txt.getId().intValue());
			
			Question qCity = 
				HibController.ItemManager.createQuestion(hibSes, "Localidad", 
																		qLabelType.getId().intValue(), 0, 0, 
																		aux.getId().intValue(), 
																		txt.getId().intValue());
			Question qCodPost = 
				HibController.ItemManager.createQuestion(hibSes, "C�digo postal", 
																		qNumType.getId().intValue(), 0, 0, 
																		aux.getId().intValue(), 
																		txt.getId().intValue());
	// commit has to be done in order to be able to associate the question with the
	// answer type
	//		tx.commit(); 
			return aux;
		}
		catch (HibernateException hibEx) {
			if (tx != null)
				tx.rollback();
			
			hibEx.printStackTrace();
			return null;
		}
			
	}
	
	
	
	private boolean setItemsOrder (Session hibSes, Collection<AbstractItem> itemCol) {
		Transaction tx = hibSes.getTransaction();
		try {
			tx = (!tx.isActive())? hibSes.beginTransaction(): tx;
			Iterator<AbstractItem> itAbs = itemCol.iterator();
			
			int i = 1;
			while (itAbs.hasNext()) {
				AbstractItem item = itAbs.next();
				
				item.setItemOrder(new Long(i));
				i++;
			}
			return true;
		}
		catch (HibernateException hibEx) {
			if (tx != null)
				tx.rollback();
			
			hibEx.printStackTrace();
			return false;
		}
	}
	
	
	
	
	
	
	private void wasteMethod (Session hibSess) {
	// Superquestons' aka Container's children aka questions aka containees
		Question container = new Question();
		Collection<AbstractItem> children = 
					HibController.ItemManager.getOrderedContainees(hibSess, container);
LogFile.stdout("numChildren: "+children.size());

		Transaction tx = null;
		for (AbstractItem child: children) {
			if (child instanceof Question){
				Collection<AnswerItem> colAnss = 
								HibernateUtil.getAnswerTypes4Question(hibSess, child);
				tx = hibSess.beginTransaction();
				int j=1;
				for (AnswerItem ansIt: colAnss) {
					HibernateUtil.setAnswerOrder((Question)child, ansIt, j++);
				}
				tx.commit();
			}
		}
	}
}
