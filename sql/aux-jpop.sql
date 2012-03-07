


-- get header values for NOT REPEATABLE items (for normal items)
select q.codquestion as codq, it.item_order, qa.answer_order, it.ite_iditem
from interview i, section s, item it, question q, question_ansitem qa
where i.idinterview = 50
  and s.section_order = 2
  and s.codinterview = i.idinterview
  and it.idsection = s.idsection
  and it.iditem = q.idquestion
--  and it."repeatable" = 0 -- removed to allow repeatable questions as parents
  and (it.ite_iditem not in (861, 1469, 1470, 1603, 1617, 870, 5517,
		 			5570, 1713, 2209, 2224, 1650, 1665, 1675) 
       or it.ite_iditem is NULL)
  and q.idquestion = qa.codquestion
order by 2, 3;



-- IRISH MISSINGS!!!
select distinct p.codpatient, i.name as intrvname, s.name as secname, 
	q.codquestion as codq, a.thevalue, s.section_order, it.item_order, 
  pga.answer_order, pga.answer_number, it."repeatable" as itrep
from patient p, pat_gives_answer2ques pga, performance pf, 
	question q, answer a, interview i, item it, section s -- , project pj 
where 1=1 -- p.idpat in (2426, 2553, 2921, 3492)
	and i.idinterview = 2100 
--  and pj.project_code = '157' 
--  and pj.idprj = i.codprj 
  and pf.codinterview = i.idinterview 
  and pf.codpat = 2426 -- p.idpat 
  and pga.codpat = 2426 -- p.idpat 
  and pga.codquestion = q.idquestion 
  and pga.codanswer = a.idanswer 
  and s.codinterview = i.idinterview 
  and q.idquestion = it.iditem 
  and it.idsection = s.idsection 
  and s.section_order = 5
order by 1, 7, 10, 8, 5, 9;


/* fix 8 in QES-D3 (1227) and/or QES-D2-order2 (703) */
update answer set thevalue='8888'
where answer.thevalue = '98'
  and answer.idanswer in (select a.idanswer
from pat_gives_answer2ques pga, answer a
where pga.codquestion = 1230
  and pga.codanswer = a.idanswer
  and a.thevalue = '98');



-- ====== this is only a test

select items.*, pgabis.answer_number, qai.answer_order, pgabis.codpatient, pgabis.idpat, a.thevalue,
		ai.name, ai.idansitem, qai.pattern
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
      and s.section_order = 10
      and it.idsection = s.idsection
    ) items left join (
      select *
      from pat_gives_answer2ques pga, patient p
-- 2993 (157011063); 3060 (157081003) -> 75 rows || 350 (157011024) -> 72 rows      
      where pga.codpat = p.idpat
      	and p.codpatient = '15700000000'
    ) pgabis on (items.itemid = pgabis.codquestion) 
	  left join answer a on (pgabis.codanswer = a.idanswer)
	  left join question_ansitem qai on (pgabis.codquestion = qai.codquestion 
    																and pgabis.answer_order = qai.answer_order)
	  left join answer_item ai on (qai.codansitem = ai.idansitem)
--	  left join patient p on (pgabis.codpat = p.idpat)
order by itemord, answer_number, answer_order;



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
      and s.section_order = 1
      and it.idsection = s.idsection
    ) items 
	  left join question_ansitem qai on (items.itemid = qai.codquestion)
	  left join answer_item ai on (qai.codansitem = ai.idansitem)
--	  left join patient p on (pgabis.codpat = p.idpat)
order by itemord, answer_order;





-- TEST FOR A JUST NEW PATIENT	
select items.*, pgabis.answer_number,  qai.answer_order, -- pgabis.answer_order,
        pgabis.codpatient, pgabis.idpat, a.idanswer, a.thevalue, ai.name, ai.idansitem,
        qai.pattern
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
    and s.section_order = 2
    and it.idsection = s.idsection
  ) items 
   left join question_ansitem qai on (items.idq = qai.codquestion)
   left join answer_item ai on (qai.codansitem = ai.idansitem)
   left join (
    select *
    from pat_gives_answer2ques pga right join
          patient p on (pga.codpat = p.idpat)
    where p.codpatient = '157081555'
  ) pgabis on (items.itemid = pgabis.codquestion and pgabis.answer_order = qai.answer_order)
  left join answer a on (pgabis.codanswer = a.idanswer)
order by itemord, answer_number, answer_order;





select items.*, qai.answer_order
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
    and s.section_order = 1
    and it.idsection = s.idsection
  ) items 
   left join question_ansitem qai on (items.idq = qai.codquestion)
   left join answer_item ai on (qai.codansitem = ai.idansitem)
   left join (
    select *
    from pat_gives_answer2ques pga right join
          patient p on (pga.codpat = p.idpat)
    where p.codpatient = '157051555'
  ) pgabis on (items.itemid = pgabis.codquestion and pgabis.ar_order = qai.answer_order);



delete from patient where codpatient='157051555';


ALTER TABLE appform.public.question
ADD constraint fk_question_isa_item
FOREIGN KEY (idquestion) 
REFERENCES public.item(iditem);



select (passwd = crypt (:thePasswd, passwd))
from appuser u;
