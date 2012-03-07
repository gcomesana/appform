-- sec12: 112 rows
-- sec5: 72 rows
-- sec10: 68 rows


 

-- TEST FOR A JUST NEW PATIENT	
select items.*, pgabis.answer_number,  qai.answer_order, -- pgabis.answer_order,
        pgabis.codpatient, pgabis.idpat, a.thevalue, ai.name, ai.idansitem,
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
    and s.section_order = 1
    and it.idsection = s.idsection
  ) items 
   left join question_ansitem qai on (items.idq = qai.codquestion)
   left join answer_item ai on (qai.codansitem = ai.idansitem)
   left join (
    select *
    from pat_gives_answer2ques pga right join
          patient p on (pga.codpat = p.idpat)
    where p.codpatient = '157011063' -- '157851555'
  ) pgabis on (items.itemid = pgabis.codquestion and pgabis.answer_order = qai.answer_order)
  left join answer a on (pgabis.codanswer = a.idanswer)
order by itemord, answer_number, answer_order;
  
 
delete from patient where codpatient = '157051555'; 

  -- for PREVIEW
/* 
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


select (passwd = crypt ('Lpalenc1a', passwd)) as theCheck 
from appuser u where u.username = 'lpalencia';

*/