-- all form items parametrized by interview, section, project and patient
-- first part is for text items, second for quetion items
select p.codpatient as codpatient, g.name as grpname, i.name as intrvname, s.name as secname, 
'' as codq, '' as theanswer, -1 as idans,  s.section_order as secord, 
it.item_order as itemord, 1 as ansord, 1 as ansnum, it."repeatable" as itrep,
it.ite_iditem as itparent, it.iditem as itemId, s.idsection as secId, p.idpat as patId,
it.content as stmt, it.highlight as style, -1 as qai_ansord, '' as ranges
from patient p, appgroup g, performance pf, interview i, item it, section s, project pj, text tx
where i.idinterview = 50 
  and pj.project_code = '157' 
  and pj.idprj = i.codprj 
  and pf.codinterview = i.idinterview 
  and pf.codgroup = g.idgroup 
  and s.codinterview = i.idinterview 
  and pf.codpat = p.idpat 
  and p.codpatient = '157081003' -- '157011063' -- '157081003'
  and it.idsection = s.idsection
  and it.iditem = tx.idtext
  and s.section_order = 5 -- 10 -- 12
-- order by 7, 10, 8, 5, 9;  
  
union
select p.codpatient as codpatient, g.name as grpname, i.name as intrvname, s.name as secname, 
q.codquestion as codq, a.thevalue as theanswer, ansitem.idansitem as idans, s.section_order as secord, 
it.item_order as itemord, pga.answer_order as ansord, pga.answer_number as ansnum, 
it."repeatable" as itrep, it.ite_iditem as itparent, it.iditem as itemId, 
s.idsection as secId, p.idpat as patId, it.content as stmt,
it.highlight as style, qai.answer_order as qai_ansord, qai.pattern as ranges
from patient p, pat_gives_answer2ques pga, appgroup g, performance pf, 
question q, answer a, interview i, item it, section s, project pj, 
answer_item ansitem, question_ansitem qai
where 1=1  
	and i.idinterview = 50 
  and pj.project_code = '157'
  and pj.idprj = i.codprj 
  and pf.codinterview = i.idinterview 
  and pf.codgroup = g.idgroup 
  and s.codinterview = i.idinterview 
  and pf.codpat = p.idpat 
  and pga.codpat = p.idpat 
  and p.codpatient = '157081003' -- '157081003'
  and pga.codquestion = q.idquestion 
  and pga.codanswer = a.idanswer 
  and q.idquestion = it.iditem
  and it.idsection = s.idsection 
  and s.section_order = 5 -- 10 -- 12
  
  and a.codansitem = ansitem.idansitem
  and ansitem.codintrv = 50
  
  and qai.codansitem = ansitem.idansitem
  and qai.codquestion = q.idquestion
  and qai.answer_order = pga.answer_order
  
-- order by 7, 10, 8, 5, 9;
order by secord, ansnum, itemord, ansord, qai_ansord; 





-- ====== this is only a test

select items.*, pgabis.answer_number, pgabis.answer_order, pgabis.codpatient, pgabis.idpat, a.thevalue,
		ai.name, ai.idansitem
  from (  
    select it.item_order as itemord, it.content as content, q.codquestion as codq,
      it.iditem as itemid, it.highlight as highlight, it.ite_iditem as itparent,
      it."repeatable" as itrep, q.idquestion as idq,
      s.name as secname, s.idsection as secid
    from question q right join item it on (it.iditem = q.idquestion), section s,
  	interview i
    where 1 = 1 -- it.idsection = 200
    	and i.idinterview = 50
      and i.idinterview = s.codinterview
      and s.section_order = 5
      and it.idsection = s.idsection
    ) items left join (
      select *
      from pat_gives_answer2ques pga, patient p
-- 2993 (157011063); 3060 (157081003) -> 75 rows || 350 (157011024) -> 72 rows      
      where pga.codpat = p.idpat
      	and p.codpatient = '157011063'
    ) pgabis on (items.itemid = pgabis.codquestion) 
	  left join answer a on (pgabis.codanswer = a.idanswer)
	  left join question_ansitem qai on (pgabis.codquestion = qai.codquestion and pgabis.answer_order = qai.answer_order)
	  left join answer_item ai on (qai.codansitem = ai.idansitem)
--	  left join patient p on (pgabis.codpat = p.idpat)
order by itemord, answer_number, answer_order;