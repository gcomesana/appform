



select pga.codquestion, pga.codanswer, pga.answer_order, pga.answer_number
from pat_gives_answer2ques pga
where pga.codpat = 1100 -- 350
and pga.codquestion in (
select q.idquestion
from interview i, section s, item it, question q
where i.idinterview = 50
  and s.codinterview = i.idinterview
  and it.idsection = s.idsection
  and it.iditem = q.idquestion
)
order by 1, 4, 3;







-- all questions for a interview (50) and a patient (157011038)
SELECT s.name, q.idquestion, q.codquestion as codq, pga.answer_number as ansnum, 
	pga.answer_order as ansord, a.thevalue as val, s.section_order, it.item_order
from interview i, section s, patient p, item it, question q,
		performance pf, pat_gives_answer2ques pga, answer a
where i.idinterview = 50
  and s.codinterview = i.idinterview
  and it.idsection = s.idsection
  and q.idquestion = it.iditem
  and p.codpatient = '157011038'
  and pf.codinterview = i.idinterview
  and pf.codpat = p.idpat
  and pga.codquestion = q.idquestion
  and pga.codpat = p.idpat
  and pga.codanswer = a.idanswer
-- order by 5, 2, 6, 3;
order by 7, 4, 8, 5;



-- questions-answers for a interview (50) patient and section (9)
select p.codpatient, g.name as grpname, i.name as intrvname, s.name as secname, 
q.codquestion as codq, a.thevalue, s.section_order, it.item_order, 
pga.answer_order, pga.answer_number, it."repeatable" as itrep,
ai.name, ai.idansitem, p.idpat, s.idsection
from patient p, pat_gives_answer2ques pga, appgroup g, performance pf, 
question q, answer a, interview i, item it, section s, project pj,
 question_ansitem qa, answer_item ai 
where 1=1  
	and i.idinterview = 50 
  and pj.project_code = '157' 
  and pj.idprj = i.codprj 
  and pf.codinterview = i.idinterview 
  and pf.codgroup = g.idgroup 
  and s.codinterview = i.idinterview 
  and pf.codpat = p.idpat 
  and pga.codpat = p.idpat 
  and p.codpatient = '157081003' -- '157011001'
  and pga.codquestion = q.idquestion 
  and pga.codanswer = a.idanswer 
  
  and q.idquestion = qa.codquestion
  and qa.codansitem = ai.idansitem
  and a.codansitem = ai.idansitem
  and ai.codintrv = i.idinterview
  
  and q.idquestion = it.iditem 
  and it.idsection = s.idsection 
  and s.section_order = 2
order by 1, 7, 10, 8, 5, 9;




-- Sacar todos los elementos de una seccion con sus respuestas si son preguntas,
-- incluso aunque las preguntas no tengan respuestas
-- It means: elems in tables question (and item) but not related answer in pga
-- select it.item_order, it.content, q.codquestion as codq
select pat_items_answer.itemord, pat_items_answer.content, pat_items_answer.highlight,
	pat_items_answer.codq, pat_items_answer.codanswer, pat_items_answer.codpat,
	pat_items.answer_number, pat_items.answer_order, pat_items.thevalue,
  pat_items_answer.itparent, pat_items_answer.itemid, pat_items_answer.itrep, 
  pat_items_answer.secname, pat_items_answer.secid, pat.codpatient
from
(((
  select *
  from (  
  select it.item_order as itemord, it.content as content, q.codquestion as codq,
    it.iditem as itemid, it.highlight as highlight, it.ite_iditem as itparent,
    it."repeatable" as itrep, q.idquestion as idq,
    s.name as secname, s.idsection as secid
  from question q right join item it on (it.iditem = q.idquestion), section s,
  	interview i, project p
  where 1 = 1 -- it.idsection = 200
  	and p.project_code = '157'
    and p.idprj = i.codprj
    and i.idinterview = s.codinterview
    and s.section_order = 5
	  and it.idsection = s.idsection
  ) items left join (
    select *
    from pat_gives_answer2ques pga
    where pga.codpat = 3060 -- 3060 -> 75 rows || 350 -> 72 rows
  ) pgabis on (items.itemid = pgabis.codquestion)
  
) pat_items left join patient pat on (pat_items.codpat = pat.idpat)) 

left join answer a on (pat_items.codanswer = a.idanswer)) pat_items_answer
order by itemord, answer_number, answer_order;



  
  
  -- for PREVIEW
  select items.*, 1 as answer_number, qai.answer_order, '15700000000' as codpatient,
			20 as idpat, '9999' as thevalue, ai.name, ai.idansitem, qai.pattern, 
		qai.answer_order as answer_order
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
    ) items 
	  left join question_ansitem qai on (items.itemid = qai.codquestion)
	  left join answer_item ai on (qai.codansitem = ai.idansitem)
--	  left join patient p on (pgabis.codpat = p.idpat)
order by itemord, answer_order;


