<%--<?xml version="1.0" encoding="UTF-8" ?> --%>
<%@ page language="java" contentType="text/html;charset=UTF-8"
    pageEncoding="UTF-8"%>
        
<%@page import="org.hibernate.Session, org.hibernate.Transaction,
							  org.hibernate.HibernateException, java.util.Collection, 
								java.util.Iterator, java.util.ArrayList, java.util.Vector, 
								java.util.Enumeration, java.util.Hashtable,
								java.net.URLDecoder"  %>
								
<%@page import="org.cnio.appform.entity.AbstractItem,
								org.cnio.appform.entity.EnumType,
								org.cnio.appform.entity.Section, org.cnio.appform.entity.Interview,
								org.cnio.appform.entity.AnswerItem,
								org.cnio.appform.entity.Question, org.cnio.appform.entity.Text,
								org.cnio.appform.util.HibernateUtil,
								org.cnio.appform.util.HibController,
								org.cnio.appform.util.IntrvController" %>


<%-- this is to add/update a section from editsec.jsp page --%>
<%--
  Enumeration params = request.getParameterNames();

  while (params.hasMoreElements()) {
    String paramName = (String) params.nextElement();
    String paramValues[] = request.getParameterValues(paramName);

    if (paramValues.length == 1) {
      out.println(paramName+"="+URLDecoder.decode(paramValues[0], "UTF-8"));
    }
    else {
      out.print(paramName+"=");
      for (int i=0; i < paramValues.length; i++) {
          if (i > 0) 
          		out.print(',');
          out.print(URLDecoder.decode(paramValues[i], "UTF-8"));
      }
      out.println();
    }
  }
--%>
								
<%-- newtype.jsp?typename=name&elements=key 1@val1,key 2@val2,... --%>
<%
	String name = URLDecoder.decode(request.getParameter ("typename"), "UTF-8");
	String typeIdStr = URLDecoder.decode(request.getParameter ("typeid"), "UTF-8");
	String elems[] = request.getParameterValues("elements");
	String errMsg = null;
	String intrvId = request.getParameter("intrvId");
	final String PERC_CODE = "%", PERC_ALT = "Yy]";
	
// all this stuff is to prevent the %25 string, which is the "escaped" % sign
// but something is wrong when, if you dont prevent it, it fails
	for (int i=0; i < elems.length; i++) {
		String elem = elems[i];
		int percent = elem.indexOf(PERC_CODE);
		if (percent != -1)
			elems[i] = elem.replaceAll(PERC_CODE, PERC_ALT);
	}
	
	for(int ielem=0;ielem<elems.length;ielem++) {
		elems[ielem]=URLDecoder.decode(elems[ielem],"UTF-8");
		int percentAlt = elems[ielem].indexOf(PERC_ALT);
		if (percentAlt != -1)
			
			elems[ielem] = elems[ielem].replaceAll(PERC_ALT, "%");
	}
	
	Hashtable<Integer,String> enumItems = new Hashtable<Integer,String>();
	Vector<String> names = new Vector<String>(), 
							vals = new Vector<String>();
	
// try to get the id of the type
	Long typeId = new Long (-1);
	if (typeIdStr!=null && typeIdStr.length()>0 && !typeIdStr.equalsIgnoreCase("-1"))
		typeId = Long.decode(typeIdStr);
	
	Session hibSes = HibernateUtil.getSessionFactory().openSession();
	Interview intrv = (Interview)hibSes.get(Interview.class, Integer.decode(intrvId));
	IntrvController intrCtrl = new IntrvController (hibSes);
	boolean isIntrvClon = intrCtrl.isClon(Integer.decode(intrvId));
	boolean res = true;

// out.println(elems.length+"<br/>");	
	for (int i=0; i<elems.length; i++) {
		int pos=elems[i].lastIndexOf(":");
		String itemName = elems[i].substring(0,pos), itemVal = elems[i].substring(pos+1);
//		Integer val = Integer.decode(pair[1]);
//out.println(itemName+":"+val);		
//		enumItems.put(val, itemName);
		names.addElement(itemName);
		vals.addElement(itemVal);
//		out.println(elems[i]+"<br/>");
	}

System.out.println("newtype.jsp: typeId: "+typeId.longValue()+"; isClon? "+isIntrvClon);	
// create a new type because the currid in the newtype.jsp is -1
// if one type is selected, this parameter should be an id
	if (typeId.longValue() == -1L) { // && !isIntrvClon) {
		res = HibController.EnumTypeCtrl.createEnumType (hibSes, intrv, isIntrvClon, name, names, vals);
		if (res) {
			Collection<AnswerItem> ansItems = 
						HibernateUtil.getAnswerItems(hibSes, intrv);
			for (AnswerItem ait: ansItems) {
				if (ait.getName().equalsIgnoreCase(name)) 
					typeId = ait.getId();
			}
		}
	}
	else { // typeId is the id of some known type (previously created)
		EnumType myType = (EnumType)hibSes.get(EnumType.class, typeId);
		
// warning: here this condition may have to be relaxed with the types translation	
		if (myType != null) {
//			boolean typeIsUsed = HibernateUtil.isTypeUsed(hibSes, myType);
//			if (!typeIsUsed)
			res = HibController.EnumTypeCtrl.editEnumType(hibSes, myType, name, names, vals);
			if (res == false)
				errMsg = "Unable to update the type with name '"+name+"'("+typeId+")";
/*			
			else {
				res = false;
				errMsg = "Type " + myType.getName() + " can not be updated. "+ 
				"It is already in use";
			}*/
		}
		else {
			res = false;
			errMsg = "Unable to update the type with name '"+name+"'("+typeId+")";
		}
		
	}
	hibSes.close();
	
	if (res)
		out.print("{\"res\":1,\"id\":"+typeId+",\"name\":\""+name.replace("\"", "\\\"")+"\"}");
	else
		out.print("{\"res\":0,\"msg\":\""+errMsg+"\"}");
//out.println("Name:"+name);
	
%>