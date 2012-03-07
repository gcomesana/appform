<%-- <?xml version="1.0" encoding="UTF-8" ?> --%>
<%@page language="java" contentType="text/html;charset=UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@page import="org.hibernate.Session, java.util.Collection, 
								java.util.Iterator, java.util.ArrayList, 
								java.util.Enumeration, java.util.List,
								org.json.simple.*"  %>
								
<%@page import="org.cnio.appform.entity.*, 
								org.cnio.appform.util.HibernateUtil,
								org.cnio.appform.util.HibController,
								org.cnio.appform.util.AppUserCtrl" %>
<!-- editelem.jsp -->
<%-- editelem.jsp?t=ele&op=new --%>
<%-- editelem.jsp?t=ele&op=new&spid=secId 
		where spid is the id of the parent section --%>
<%-- editelem.jsp?t=ele&op=upd&frmid=id&spid=secId --%>
<%--
Create or edit an element, text or question, assigning its section and element
parent if suitable.  
To set the parents (container and section), the rule so far is gonna be:
- select a section for container
- via ajax (or not) get the questions for that section
so, while the section is not selected, the container has to be disabled
--%>

<%
	String theId = request.getParameter("frmid"),
				 secId = request.getParameter("spid"),
				 op = request.getParameter("op");
/*
	theId = "2501";
	secId = "1501";
	op = "upd";
*/	
	List<AnswerItem> answersCol;
	List<Section> sectionsCol;
	List<AbstractItem> containees = null, containers = null;
	
	String myRoles = (String)session.getAttribute ("roles");
	boolean isAdmin = (myRoles.compareToIgnoreCase(AppUserCtrl.ADMIN_ROLE) == 0);

//	Session hibSes = HibernateUtil.getSessionFactory().openSession();

// This is here in the case of some is (very) wrong as the second parameter 
// shoud be an interview object. This is "fixed" just below when is checked for
// null the section id
	answersCol = HibernateUtil.getAnswerItems (hibSes, (Interview)null);
	pageContext.setAttribute ("anstypes", answersCol);
	
	sectionsCol = HibController.SectionCtrl.getSectionByName(hibSes, "");
	pageContext.setAttribute("sections", sectionsCol);
	
// The interview the item belongs to
	Interview intrv = null;
	pageContext.setAttribute("codQues", "");
	pageContext.setAttribute ("frmid", "");
	pageContext.setAttribute ("qCodeclon", 0);
	if (secId != null) {
		Section theSection = 
				(Section)hibSes.get(Section.class, Integer.decode(secId)); 
		pageContext.setAttribute("section", theSection);
		
		intrv = theSection.getParentIntr ();
// System.out.println("this intrv: "+intrv == null? "crap": intrv.getName());
		pageContext.setAttribute("interview", intrv);
		sectionsCol = HibController.SectionCtrl.getSectionsFromIntrv (hibSes, intrv);
		pageContext.setAttribute ("sections", sectionsCol);
		
		answersCol = HibernateUtil.getAnswerItems (hibSes, intrv);
		pageContext.setAttribute ("anstypes", answersCol);
//		sectionsCol = theSection.getParentIntr().getSections();

		containers = HibernateUtil.getItems4Section (hibSes, theSection.getId());
	}
	pageContext.setAttribute("containers", containers);
//	pageContext.setAttribute("disabled", "disabled=\"false\"");
	pageContext.setAttribute("op", op);
	
	if (theId != null) {
// content, type, answertype(s), section parent, element parent are gotta be
// retrieved for this element id
		int intId = Integer.parseInt (theId);
		AbstractItem parentIt;
		Section parentSec;
		AbstractItem theItem = 
					HibController.ItemManager.getItemById (hibSes, intId);
		
		containees = 
					HibController.ItemManager.getOrderedContainees (hibSes, theItem);
		
		pageContext.setAttribute ("item", theItem);
		pageContext.setAttribute("containees", containees);
		pageContext.setAttribute("section", "");
		pageContext.setAttribute("container", "");
		pageContext.setAttribute("frmid", theId);
		pageContext.setAttribute("repeat", "");
		pageContext.setAttribute("mandatory", "");
		pageContext.setAttribute ("mandatoryDis", "");
		
		if (theItem.getRepeatable() != null &&  theItem.getRepeatable() != 0)
			pageContext.setAttribute("repeat", "checked=\"checked\"");
		
		if (theItem instanceof Text) {
			pageContext.setAttribute ("isText", true);
			pageContext.setAttribute("itemType", "T");
			pageContext.setAttribute("mandatoryDis", "disabled=\"true\"");
			if (!isAdmin)
				pageContext.setAttribute ("disabled", "disabled=\"true\"");
		}
		else { // so, it is instanceof Question
			pageContext.setAttribute ("isText", false);
			pageContext.setAttribute("itemType", "Q");
			pageContext.setAttribute ("disabled", "");
			
			if (((Question)theItem).getMandatory() != null &&  
					((Question)theItem).getMandatory() != 0)
				pageContext.setAttribute("mandatory", "checked=\"checked\"");
			
			List<AnswerItem> col = 
				HibController.ItemManager.getAnswerTypes4Question(hibSes, theItem);
						
			if (col != null) {
				pageContext.setAttribute("itemAnswers", col);
				List<QuestionsAnsItems> lQai = 
							HibController.ItemManager.getPatterns(hibSes, (Question)theItem);
/* 
patterns are in the form MIN,MAX,EXC so we have to
 retrieve them and store them for further use
				ArrayList<String> myPatterns = new ArrayList<String> ();
				Iterator<QuestionsAnsItems> itQai = lQai.iterator();
				for (QuestionsAnsItems qai: lQai) {
					String pattern = qai.getPattern();
					
				}
*/				
				pageContext.setAttribute ("patterns", lQai);
			}
			pageContext.setAttribute ("codQues", ((Question)theItem).getCodquestion());
		}
		
		parentIt = theItem.getContainer ();
		parentSec = theItem.getParentSec ();
		intrv = parentSec.getParentIntr();
		
		pageContext.setAttribute ("interview", intrv);
		pageContext.setAttribute ("isClon", "");
		pageContext.setAttribute ("aCodeClon", 0);
		if (intrv.getSourceIntrv() != null && !isAdmin) {
			pageContext.setAttribute ("isClon", "disabled=\"disabled\"");
			pageContext.setAttribute ("qCodeClon", 1);
		}
		
		pageContext.setAttribute ("section", parentSec);
		pageContext.setAttribute ("container", parentIt);
		
		pageContext.setAttribute ("boldChk", "");
		pageContext.setAttribute ("italicChk", "");
		pageContext.setAttribute ("underChk", "");

// protection against null exception if, by chance, highlight attribute is null
		if (theItem.getHighlight() == null)
			theItem.setHighlight(AbstractItem.HIGHLIGHT_NORMAL);

		if (theItem.getHighlight() == AbstractItem.HIGHLIGHT_BOLD ||
				theItem.getHighlight() == AbstractItem.HIGHLIGHT_ITABOLD ||
				theItem.getHighlight() == AbstractItem.HIGHLIGHT_UNDERBOLD ||
				theItem.getHighlight() == AbstractItem.HIGHLIGHT_FULL)
			pageContext.setAttribute ("boldChk", "checked=\"checked\"");
		
		if (theItem.getHighlight() == AbstractItem.HIGHLIGHT_ITALIC ||
				theItem.getHighlight() == AbstractItem.HIGHLIGHT_ITABOLD ||
				theItem.getHighlight() == AbstractItem.HIGHLIGHT_UNDERITAL ||
				theItem.getHighlight() == AbstractItem.HIGHLIGHT_FULL)
			pageContext.setAttribute ("italicChk", "checked=\"checked\"");
		
		if (theItem.getHighlight() == AbstractItem.HIGHLIGHT_UNDERLINE ||
				theItem.getHighlight() == AbstractItem.HIGHLIGHT_UNDERITAL ||
				theItem.getHighlight() == AbstractItem.HIGHLIGHT_UNDERBOLD ||
				theItem.getHighlight() == AbstractItem.HIGHLIGHT_FULL)
			pageContext.setAttribute ("underChk", "checked=\"checked\"");
	} // theId != null
	
// If the element is to be created for this clone interview
// then all answertypes can be added
	pageContext.setAttribute ("btnAddDis", "");
	/*
	if (theId == null && intrv.getSourceIntrv() != null)
		pageContext.setAttribute ("btnAddDis", "");
	else
		pageContext.setAttribute ("btnAddDis", "disabled=\"disabled\"");
	*/
// this is to avoid cloning in all cases. should be removed anytime
	pageContext.setAttribute("isClon", "");

//	hibSes.close();
%>
<!-- cloned?: ${isClon} -->

<!-- **************** START CONTENT AREA (REGION b)**************** -->		 
<div id='regionAdmB'>

<h3>Element Edition
<c:if test="${not empty section}"> - Section '${section.name}'</c:if></h3>
<form name="frmItem" id="frmItem">
<input type="hidden" name="itemType" id="itemType" value="${itemType}" />

<table width="100%" cellpadding="0" cellspacing="0" border="0">
<tr><td align="center">
	<input type="hidden" name="t" value="ele" />
	<c:if test="${not empty frmid}">
	<input type="hidden" name="frmid" value="${frmid}"/>
	</c:if>
<table width="95%" cellpadding="3" cellspacing="0" id="elemtable" border="1px">
	<tr bgcolor="lightgray"><td colspan="4">Element statement</td></tr>
	<tr>
		<td height="61" colspan="3">
			<c:if test="${not empty item}">
			<textarea cols="80" name="frmStmt" id="frmStmt" rows="3" wrap="soft" 
					style="width:95%;"<c:if test="${empty item}">onclick="formCtrl.clearTextarea(this);"</c:if> 
			>${item.content}
			</textarea>
			</c:if>
			<c:if test="${empty item}">
			<textarea cols="80" name="frmStmt" id="frmStmt" rows="3" wrap="soft" style="width:95%;"
					<c:if test="${empty item}">onclick="formCtrl.clearTextarea(this);"</c:if> 
			>Statement text...</textarea>
			</c:if><br>
		</td>
		<td>
			<table border="0">
			<tr>
				<td><b>Bold</b></td>
				<td><input type="checkbox" name="frmChkBold" id="frmChkBold" ${boldChk}/></td>
			</tr>
			<tr>
				<td><i>Italic</i></td>
				<td> <input type="checkbox" name="frmChkItalic" id="frmChkItalic" ${italicChk} /></td>
			</tr>
			<tr>
				<td><u>Underline</u></td>
				<td><input type="checkbox" name="frmChkUnder" id="frmChkUnder" ${underChk} /></td>
			</tr>
			</table>
		</td>
	</tr>
	<tr bgcolor="lightgray">
		<td colspan="4">Element type</td>
<!-- <td colspan="2">About question</td> -->
	</tr>
	<tr>
		<td colspan="4">
			<input type="checkbox" name="frmChkTxt" id="frmChkTxt" ${isClon}
				<c:if test="${isText}">checked="true"</c:if> onchange="formCtrl.typeChange(this.form);"/>
			<span id="titText" onmouseover="Tip('Check to make just a text without accepting answers')"
							onmouseout="UnTip ();">Just text</span> 
			
			<input type="checkbox" name="frmChkRep" id="frmChkRep" ${isClon}
							${repeat} >
			<span id="titRepeteable" 
				onmouseover="Tip('Check to make this question (and children) able to accept more than one answer');"
				onmouseout="UnTip ();">Repeatable</span>
				
			<input type="checkbox" name="frmMandatory" id="frmMandatory" ${isClon} ${mandatory} ${mandatoryDis}>
			<span id="titMandatory" 
				onmouseover="Tip('Check to make this question (and children) mandatory or obligatory for all sort of interviews');"
				onmouseout="UnTip ();">Obligatory</span>
			
		</td>
	</tr>
<%-- // rows to set the code of question in the case of it is necessary --%>
	<tr bgcolor="lightgray">
		<td colspan="4">
			<span onmouseover="Tip('Give a code to this question in order to identify it');"
				onmouseout="UnTip();">Question code</span>
		<!-- 
			<div id="supernote-note-noteCodQue" class="snp-mouseoffset notedefault">
				 <a name="noteCodQue"></a>
				 Write here the code of the question as is in the specification document
			</div>
		-->
		</td>
<!-- <td colspan="2">About question</td> -->
	</tr>
	<tr>
		<td colspan="4">
			<input type="text" name="frmCodQues" id="frmCodQues" maxlength="16" size="10"
				value="${codQues}" ${isClon} onmouseout="UnTip();"
				onmouseover="Tip('Give a code to this question in order to identify it');"
				onblur="formCtrl.chkQuestionCode (this, ${frmid}, ${qCodeClon}, ${interview.id})">
			
		</td>
	</tr>
		
	<tr>
		<td colspan="4" bgcolor="lightgray">Answer type&nbsp;
		(<a href="javascript:formCtrl.newType(${interview.id});" style="text-decoration:none;color:blue">Manage enum types</a>)
		</td>
	</tr>
<%--
	In order to synchronize the Number types with their ranges, we use a count
--%>	
	<tr>
		<td colspan="4">
		<table id="tblTypes" width="100%" cellpadding="3" cellspacing="0" border="0">
		<tr>
			<td width="42%" valign="middle" align="right" >
				<select name="frmAnswerTypes" size="3" id="frmAnswerTypes" 
							multiple="multiple" ${isClon}	style="width: 85%;" ${disabled}>
					<c:forEach items="${anstypes}" var="aType">
						<option value="${aType.id}">${aType.name}</option>
					</c:forEach>
				</select>
			</td>
			
			<td width="8%" valign="middle" align="center">
			<%-- 
			<input type="button" name="btnAddType" id="btnAddType" value="-&gt;"
						 ${disabled} onclick="formCtrl.addType(this.form);" ${isClon}/>
		  --%>
		  <input type="button" name="btnAddType" id="btnAddType" value="-&gt;"
						 ${btnAddDis} onclick="formCtrl.addType(this.form);" ${isClon}/>
			</td>
			<td xcolspan="2" valign="middle" align="left" width="42%">
			<select name="frmAnswers" size="3" id="frmAnswers" ${isClon}
						style="width: 85%;"	${disabled} onclick="formCtrl.activateSelected (this);">
				<c:if test="${not empty itemAnswers}">
					<c:set var="contNumb" value="1"/>
					<c:forEach items="${itemAnswers}" var="aType">
						<c:set var="optName" value="${aType.name}"/>

						<c:if test="${aType.name eq 'Number' || aType.name eq 'Decimal'}">
							<c:set var="optName" value="${optName} (${contNumb})"/>
							<c:set var="contNumb" value="${contNumb+1}" />
						</c:if>
						<c:set var="optName" value="${fn:trim(optName)}" />
						<option value="${aType.id}"
							onmouseover="Tip(\"${optName}\");"
							onmouseout="UnTip ();">${optName}</option>
					</c:forEach>
				</c:if>
			</select>
			</td>
			
			<td valign="top" align="left">
			<input type="button" name="btnRmvType" id="btnRmvType" value="Remove" 
						${isClon} style="height: 80%;vertical-align: bottom;" ${disabled} 
						onclick="formCtrl.rmvAnswer(this.form);"/>
			</td>
		</tr>

<!-- trying to build the range boxes -->
		<c:if test="${not empty patterns}">
			<c:set var="contNumb" value="1"/>
			<c:forEach items="${patterns}" var="aPattern">
				<c:set var="fstComma" value="${fn:indexOf(aPattern.pattern, ';')}" />
				<c:set var="strLen" value = "${fn:length(aPattern.pattern)}" />
				
				<c:set var="minVal" value="${fn:substring(aPattern.pattern, 0, fstComma)}" />
				<c:set var="minVal" value="${(minVal == '-')?'': minVal}" />
				<c:set var="endPatt" value = "${fn:substring(aPattern.pattern, fstComma+1, strLen)}" />
				<c:set var="sndComma" value="${fn:indexOf(endPatt, ';')}" />
				
				<c:set var="maxVal" value="${fn:substring(endPatt, 0, sndComma)}"/>
				<c:set var="maxVal" value="${(maxVal == '-')?'': maxVal}" />
				<c:set var="strLen" value="${fn:length(endPatt)}" />
				<c:set var="excVal" value="${fn:substring(endPatt, sndComma+1, strLen)}" />
				<c:set var="excVal" value="${(excVal == '-')?'': excVal}" />
				
				<c:set var="typeName" value="${itemAnswers[contNumb-1].name}"/>
				<c:if test="${fn:containsIgnoreCase(typeName, 'Number')}">
					<c:set var="chkRange" value="formCtrl.chkRange('N', this)"/>
				</c:if> 
				<c:if test="${fn:containsIgnoreCase(typeName, 'Decimal')}">
					<c:set var="chkRange" value="formCtrl.chkRange('D', this)"/>
				</c:if>
				
				<tr id="trRange${contNumb}">
					<td colspan="2">&nbsp;</td>
					<td colspan="2" valign="bottom">
					(${contNumb}) Range <input type="text" id="frmmin${contNumb}" name="frmmin${contNumb}" 
								value="${minVal}" size="5" maxlength="16" ${isClon} 
								onblur="${chkRange}"/>
			-&nbsp;<input type="text" id="frmmax${contNumb}" name="frmmax${contNumb}" 
							value="${maxVal}" size="5" maxlength="16" ${isClon} 
							onblur="${chkRange}"/>
			&nbsp;:Except <input type="text" id="frmexc${contNumb}" name="frmexc${contNumb}" 
							value="${excVal}" size="5" maxlength="32" ${isClon} 
							onblur="${chkRange}"/>
					</td>
				</tr>
				<c:set var="contNumb" value="${contNumb+1}"/>
			</c:forEach>
		</c:if>
		
<%-- 		
		<c:if test="${not empty itemAnswers}">	
			<c:set var="contNumb" value="1"/>
			<c:forEach items="${itemAnswers}" var="aType">
				<c:if test="${aType.name eq 'Number'}">
					<tr id="trRange${contNumb}">
					<td colspan="2">&nbsp;</td>
					<td colspan="2" valign="bottom">
					(${contNumb}) Range <input type="text" id="frmmin${contNumb}" name="frmmin${contNumb}" value="" size="7" maxlenght="5"/>
			-&nbsp;<input type="text" id="frmmax${contNumb}" name="frmmax${contNumb}" value="" size="7" maxlenght="5"/>
			:&nbsp;Exception <input type="text" id="frmexc${contNumb}" name="frmexc${contNumb}" value="" size="7" maxlenght="5"/>
					</td>
					</tr>
					<c:set var="contNumb" value="${contNumb+1}"/>
				</c:if>
			</c:forEach>
		</c:if>
--%>		
<!-- 		
		<tr id="trRange" style="visibility: collapse;">
		<td colspan="2">&nbsp;</td>
		<td colspan="2" valign="bottom">
		Range <input type="text" name="min1" value="" size="7" maxlenght="5"/>
&nbsp;-&nbsp;&nbsp;<input type="text" name="max1" value="" size="7" maxlenght="5"/>
&nbsp;:&nbsp;Exception <input type="text" name="exc1" value="" size="7" maxlenght="5"/>
		</td>
		</tr>
-->		
		</table>
		</td>
	</tr>
	
	<tr bgcolor="lightgray">
		<td height="auto" colspan="2" valign="top">Parent section</td>
		<td height="auto" colspan="2" valign="top">Parent element</td>
	</tr>
	
	<tr>
		<td width="25%" valign="top">Current:<br/> 
			<c:if test="${not empty section}"><b>${section.name} (${section.id})</b></c:if>
			<input type="hidden" name="frmCurSec" value="${section.id}" id="frmCurSec"/>
		</td>
		<td width="25%" valign="top">New:
			<select name="frmNewSec" id="frmNewSec" ${isClon}>
				<option value="-1">Choose one...</option>
				<c:forEach items="${sections}" var="aSec">
					<c:if test="${aSec.id ne section.id}">
					<option value="${aSec.id}">${aSec.name}</option>
					</c:if>
				</c:forEach>
			</select>
		</td>
		<td width="25%" valign="top">Current:<br /> 
			<c:if test="${not empty container}"><b>${container.content} (${container.id})</b></c:if>
		</td>
		<td valign="top" width="25%">New:
			<select name="frmNewParent" id="frmNewParent" ${isClon} 
					<c:if test="${empty section}">disabled="true"</c:if>>
				<option value="-1">Choose one...</option>
				<c:if test="${not empty container}">
				<option value="0">Remove</option>
				</c:if>
				<c:forEach items="${containers}" var="container">
					<option value="${container.id}">${container.content}</option>
				</c:forEach>
			</select>		
		</td>
		
	</tr>
	<tr><td colspan="4" height="5px"></td></tr>
	
	<tr bgcolor="lightgray">
		<td height="20px" colspan="4">
		Elements contained in this item:&nbsp;
		</td>
	</tr>
	<tr>
		<td colspan="4">
		<table style="width:100%">
			<tr><td rowspan="3" width="85%">
				<c:if test="${empty containees}">
					<i>No elements contained in</i>
				</c:if>
				<c:if test="${not empty containees}">
					<select name="frmContainees" id="frmContainees" size="4" style="width:100%">
						<c:forEach items="${containees}" var="containee">
							<option value="${containee.id}">${containee.content}</option>
						</c:forEach>
					</select>
				</c:if>
			</td>
			<td align="center">
				<c:if test="${not empty containees}">
					<input type="button" name="btnUp" id="btnUp" value="  Up  "
						onclick="formCtrl.moveUp(this.form.frmContainees);"/>
				</c:if>
				</td>
			</tr>
			
			<tr><td align="center">
				<c:if test="${not empty containees}">
				<input type="button" name="btnDown" id="btnDown" value=" Down "
					onclick="formCtrl.moveDown(this.form.frmContainees);"/>
				</c:if>
			</td></tr>
			<tr><td align="center">
				<c:if test="${not empty containees}">
				<input type="button" name="btnReord" id="btnReord" value=" Re-sort "
					onclick="formCtrl.onRearrange(this.form.frmContainees, 'ele');"/>
				</c:if>
			</td></tr>
		</table>
		
		
		</td>
	</tr>
	<tr>
		<td height="auto" colspan="4" align="right">
		<c:if test="${op eq 'new'}">
		<input type="button" name="btnOk" id="btnOk" value=" Save " 
					onclick="formCtrl.onSave (this.form);"/>
		</c:if>
		<c:if test="${op eq 'upd' || op eq 'det'}">
		<input type="button" name="btnOk" id="btnOk" value=" Update " 
					onclick="formCtrl.onUpdate (this.form);"/>
		</c:if>
		<input type="button" name="btnCan" id="btnCan" value=" Cancel " 
					onclick="formCtrl.onCancel (this.form);"/>
		</td>
	</tr>
</table>
</form>	

</td>
</tr>
</table>
</div> <!-- regionB -->
<!-- ****************** END CONTENT AREA (REGION B) ***************** -->
