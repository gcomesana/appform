

select q.idquestion as idq, q.codquestion as codq, qa.codansitem as codait, 
			pga.answer_number as ansnum, pga.answer_order as ansord, it2.item_order as itord,
      pga.idp_a_q, pga.codanswer, pga.codpat
--        it2.content as content
from pat_gives_answer2ques pga, question q, answer a, question_ansitem qa, item it2
where q.idquestion in 
  (select q.idquestion
  from interview i, section s, item it, question qº
  where s.codinterview = i.idinterview
    and i.idinterview = 50
    and it.idsection = s.idsection 
    and q.idquestion = it.iditem
    and it.ite_iditem is not null
    and s.section_order = 12
  )
  and pga.codquestion = q.idquestion
  and pga.codanswer = a.idanswer
  and pga.codpat = 1009 -- 550 -- 850 -- 103
--  and a.thevalue = '9999'
  and q.idquestion = it2.iditem
  and it2.ite_iditem is not null
  and qa.codquestion = q.idquestion
  and qa.answer_order = a.answer_order   
order by ansnum, itord, ansord;


/* ------------------------------------------------------------------------ */
--- 1553 = 012058; 1151 = 011058; 1352 = 021030; 102 = 011030
select q.codquestion as codqes, a.answer_order, a.thevalue, i.item_order, 
pga.answer_number, pga.idp_a_q
from patient p, pat_gives_answer2ques pga, answer a, question q, section s, item i
where p.idpat = 650 -- 1151 -- 1553
  and pga.codpat = p.idpat
  and pga.codanswer = a.idanswer
  and pga.codquestion = q.idquestion
  and q.idquestion = i.iditem
  and i.idsection = s.idsection
  and s.idsection = 150 -- 1150
--  and (q.codquestion like 'K1%' or q.codquestion like 'K2%')
order by 4, 2, 5;




select ai.name, ei.idenumitem, ei.name, ei.thevalue
from enumitem ei, enumtype et, answer_item ai
where ei.codenumtype = et.idenumtype
  and (upper(ei.name) like 'NS%' or upper(ei.name) like 'DK%' or
  		 upper(ei.name) = 'KA' 	or upper(ei.name) = 'NA' or
       upper(ei.name) = 'NC')
  and ei.thevalue <> '8888'
  and ai.idansitem = et.idenumtype;
  
  
select *
from enumitem e
where upper(e.name) like upper('NS%') or upper(e.name) like upper('%sabe') 
			or upper(e.name) like upper('DK%') or upper(e.name) like upper('%know%');


select a.idanswer, a.thevalue, et.idenumtype, ai.name as ansit, ei.name as enumit
from answer a, answer_item ai, enumtype et, enumitem ei
where a.codansitem = ai.idansitem
	and a.idanswer = 1327
  and ai.idansitem = et.idenumtype
  and ei.codenumtype = et.idenumtype
  and (upper(ei.name) like 'NS%' or upper(ei.name) like 'DK%' or
  		 upper(ei.name) = 'KA' 	or upper(ei.name) = 'NA' or
       upper(ei.name) = 'NC' or upper(ei.name) = 'NOT KNOWN' or
       upper(ei.name) like upper('%know%'))
  and a.thevalue like '7%';
  



select it.content, it.item_order, it.iditem, s.section_order
from section s, item it
where s.idsection = 1252
  and s.idsection = it.idsection
order by 2;


-- get simple questions
select q.codquestion as codq, it.item_order as itorder, qa.answer_order 
from interview i, section s, item it, question q, question_ansitem qa 
where i.idinterview = 50 
and s.section_order = 10 
and s.codinterview = i.idinterview 
and it.idsection = s.idsection 
and it.iditem = q.idquestion 
and it."repeatable" = 0 
and (it.ite_iditem not in (1675,1665,1650,861,1617,1470,1603,1469,870,5517,5570,2209,1713,2224)  
  or it.ite_iditem is NULL) 
and q.idquestion = qa.codquestion 
order by 2;


-- repeatable items
select distinct on (5,6,4,3) p.codpatient as codpat, q.idquestion as idq, 
q.codquestion as codq, pga.answer_order as aorder, it.item_order as itorder, 
count (pga.idp_a_q) as numans 
from item it, question q, pat_gives_answer2ques pga, patient p,interview i, 
  section s, performance pf, appgroup g
where (it.iditem in (1675,1665,1650,861,1617,1470,1603,1469,870,5517,5570,2209,1713,2224) 
  or it.ite_iditem in (1675,1665,1650,861,1617,1470,1603,1469,870,5517,5570,2209,1713,2224)) 
-- where (it.iditem in (2224) or it.ite_iditem in (2224))
  and it.iditem = q.idquestion 
  and pga.codquestion = q.idquestion 
  and p.idpat = pga.codpat 
  and i.idinterview = 50 
  and pf.codinterview = i.idinterview 
  and s.section_order = 10
  and s.codinterview = i.idinterview 
  and it.idsection = s.idsection 
  and 1=1  
  and pf.codgroup = g.idgroup 
  and pf.codpat = p.idpat 
group by 1, 2, 3, 4, 5 
order by 5 asc, 6 desc, 4 desc, 3;
  




-- MULTIPLE ANSWERS CURATION QUERIES !!!!!
-- valores de respuestas para una misma posicion de respuesta para una pregunta para un paciente
select p.codpatient, a.thevalue, pga.*	
from pat_gives_answer2ques pga, answer a, patient p
where pga.codquestion= 2222
and pga.answer_number = 1 
and pga.answer_order = 3
and pga.codpat= 3030
and pga.codpat = p.idpat
and pga.codanswer = a.idanswer
order by pga.answer_number, pga.answer_order, pga.answer_grp;

-- generalizado: 
-- valores de respuesta para una misma posicion de respuesta donde éste
-- el número de respuestas sea mayor que 1

-- select pga.codpat, pga.codquestion, a.thevalue, subq.ansord, subq.ansnum, subq.anscount
select p.codpatient, i.name, s.section_order, q.idquestion as idq,
 q.codquestion as codq, a.thevalue, pga.answer_order, pga.answer_number, subq.anscount
from pat_gives_answer2ques pga, answer a, question q, item it, section s, interview i, patient p,
(
select pga.codquestion as idq, pga.codpat as codpat, pga.answer_order as ansord, 
		pga.answer_number as ansnum, count (pga.codanswer) as anscount
from pat_gives_answer2ques pga
group by 1, 2, 3, 4
having count (pga.codanswer) > 1
order by 2, 4, 3
) subq

where pga.codpat = subq.codpat
  and pga.codquestion = subq.idq
  and pga.answer_number = subq.ansnum
  and pga.answer_order = subq.ansord
  and pga.codanswer = a.idanswer
  and pga.codpat = p.idpat
  and pga.codquestion = q.idquestion
  and q.idquestion = it.iditem
  and it.idsection = s.idsection
  and i.idinterview = s.codinterview
order by 1, 2, 3, 5, 8, 7;



-- lista de preguntas con varias respuestas para una misma posicion.
-- el número de respuestas para la posicion está en el último campo
select pga.codquestion as idq, pga.codpat as codpat, pga.answer_order as ansord, 
		pga.answer_number as ansnum, a.thevalue as ansval, count (pga.codanswer) as anscount
from pat_gives_answer2ques pga, answer a
where pga.codanswer = a.idanswer
group by 1, 2, 3, 4, 5
having count (pga.codanswer) > 1
order by 1, 2, 4, 3; -- order by 4, 6, 7, 1;


-- (el campo count es el numero de respuestas que anda produciendo almorranas)
select /* pga.codpat as idpat */ p.codpatient, pga.codquestion as idq, q.codquestion as codq,
    count (pga.codanswer), pga.answer_number, pga.answer_order
from pat_gives_answer2ques pga, question q, patient p
where pga.codquestion = q.idquestion
  and pga.codpat = p.idpat
group by p.codpatient, pga.codquestion, pga.answer_number, pga.answer_order, codq
having count (codanswer) > 1
-- order by 3, 1, 4; -- ordena primero por codigo de pregunta
order by 1, 3, 4; -- ordena primero por codigo de paciente


-- [OPTIMIZACION: lo mismo pero con todas las respuestas 9999 o iguales (subconsulta o algo)]
select main.codpat, i.name as interview, s.name as section, q.codquestion as codques, 
		main.ansnum, main.ansord, main.ansval, main.mycount
--  into table multipleanswers 
from interview i, section s, item it, question q,
(
  select pga.codquestion as codq, p.codpatient as codpat, pga.answer_order as ansord, 
    pga.answer_number as ansnum, a.thevalue as ansval, p.idpat as idpat, count (a.thevalue) as mycount
  from pat_gives_answer2ques pga, answer a, patient p,
  --    interview i, section s, item it, question q
  (
    select pga.codquestion as idq, pga.codpat as codpat, pga.answer_order as ansord, 
        pga.answer_number as ansnum, count (pga.codanswer) as anscount
    from pat_gives_answer2ques pga, multipleanswers ma
    where ma.codpat = pga.codpat
      and ma.codquestion = pga.codquestion
      and ma.answer_number = pga.answer_number
      and ma.answer_order = pga.answer_order
      and ma.codanswer = pga.codanswer
    group by 1, 2, 3, 4
    having count (pga.codanswer) > 1
    order by 2, 4, 3
  ) subq
  where pga.codpat = subq.codpat
    and pga.codquestion = subq.idq
    and pga.answer_number = subq.ansnum
    and pga.answer_order = subq.ansord
    and pga.codanswer = a.idanswer
    and pga.codpat = p.idpat
  group by 1, 2, 3, 4, 5, 6
) main
where main.codq = q.idquestion
  and q.idquestion = it.iditem
  and it.idsection = s.idsection
  and s.codinterview = i.idinterview
-- union
-- select * from multipleanswers 
order by 1, 2, 3, 5, 6;







-- sacar, para los grupos de repetidos, el paciente y el idquestion que ya está
select pga.codquestion, pga.codpat, pga.answer_number, pga.answer_order, pga.codanswer,
	ans.thevalue, ans.datecreated, ans.lastupdated
-- into multipleanswers
from pat_gives_answer2ques pga, answer ans, 
(
select pga.codquestion as idq, pga.codpat as codpat, pga.answer_order as ansord, 
    pga.answer_number as ansnum, count (pga.codanswer) as anscount
from pat_gives_answer2ques pga, answer a
where pga.codanswer = a.idanswer
group by 1, 2, 3, 4
having count (pga.codanswer) > 1
order by 2, 4, 3
) subq
where pga.codquestion = subq.idq
  and pga.codpat = subq.codpat
  and pga.answer_number = subq.ansnum
  and pga.answer_order = subq.ansord
  and pga.codanswer = ans.idanswer
order by 1, 2, 3, 4 , 7, 8;


-- delete from answer where idanswer=3170829;
-- delete from answer where idanswer=3170830;

select pga.codquestion as idq, pga.codpat as codpat, pga.answer_order as ansord, 
    pga.answer_number as ansnum, count (pga.codanswer) as anscount
from pat_gives_answer2ques pga, multipleanswers ma
where ma.codpat = pga.codpat
  and ma.codquestion = pga.codquestion
  and ma.answer_number = pga.answer_number
  and ma.answer_order = pga.answer_order
  and ma.codanswer = pga.codanswer
group by 1, 2, 3, 4
having count (pga.codanswer) > 1
order by 1, 2, 4, 3;


-- get answers from codpatient, intrv name, sec name, ord, num and cod question
select p.codpatient,  i.name, s.name as section, q.codquestion as codques, 
	pga.answer_number, pga.answer_order, a.thevalue
from interview i, section s, item it, question q, patient p, answer a,
	pat_gives_answer2ques pga
where i.name = 'QES_Español'
  and i.idinterview = 50
  and s.codinterview = i.idinterview
  and s.name = 'D. Agua'
  and it.idsection = s.idsection
  and it.iditem = q.idquestion
  and q.codquestion = 'D1_5'
  and p.codpatient = '157081006'
  and p.idpat = pga.codpat
  and pga.codquestion = q.idquestion
  and pga.answer_number = 1
  and pga.answer_order = 1
  and pga.codanswer = a.idanswer;