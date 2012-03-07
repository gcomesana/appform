

select p.idpat, substr(p.codpatient, 1, 9) , q.codquestion as codq, it.item_order,
			q.idquestion, pga.answer_number, pga.answer_order, a.idanswer, a.thevalue
from answer a, pat_gives_answer2ques pga, question q, item it, section s, interview i, patient p
where i.idinterview = 2400
  and i.idinterview = s.codinterview
  and s.section_order = 1
  and s.idsection = it.idsection
  and it.iditem = q.idquestion
  and it.item_order <= 5
  and q.idquestion = pga.codquestion
  and pga.codanswer = a.idanswer
  and pga.codpat = p.idpat
order by 2, 4;




select q.idquestion as idq, q.codquestion as codq, qa.codansitem as codait, 
			pga.answer_number as ansnum, pga.answer_order as ansord, it2.item_order as itord,
      pga.idp_a_q, pga.codanswer, pga.codpat
--        it2.content as content
from pat_gives_answer2ques pga, question q, answer a, question_ansitem qa, item it2
where q.idquestion in 
  (select q.idquestion
  from interview i, section s, item it, question q
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

