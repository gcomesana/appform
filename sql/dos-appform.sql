-- question/interview from an answer row
select q.idquestion as idq, q.codquestion as codq, t.name as intrname, 
           p.idpat as idpat, p.codpatient as codpat, pf.idperformance as idperf,
           u.username as thename, u.iduser as usrid, ph.thetimestamp
--    into mydata
from question q, pat_gives_answer2ques pg, answer a, item i, 
    section s, interview t, patient p, performance pf, appuser u, perf_history ph
where pg.codanswer = a.idanswer
  and a.idanswer = 5630
  and pg.codquestion = q.idquestion
  and q.idquestion = i.iditem
  and i.idsection = s.idsection
  and s.codinterview = t.idinterview
  and pg.codpat = p.idpat
  and pf.codpat = p.idpat
  and pf.codinterview = t.idinterview -- this check is neccessary as, one idpat corresponds with several performids
  and pf.coduser = u.iduser
  and pf.idperformance = ph.codperf
  and ph.coduser = u.iduser;

/* number of questions for one section */
select p.idpat, p.codpatient, count (q.idquestion) as numcodq
from patient p, pat_gives_answer2ques pga, -- appgroup g, 
performance pf, 
		question q, answer a, interview i, item it, section s
where 1 = 1
--  and g.idgroup = 304
  and i.idinterview = 50
  and pf.codinterview = i.idinterview
  and s.codinterview = i.idinterview
  and pf.codpat = p.idpat
--  and pf.codgroup = g.idgroup
  and pga.codpat = p.idpat
  and pga.codquestion = q.idquestion
  and pga.codanswer = a.idanswer
  and q.idquestion = it.iditem
  and it.idsection = s.idsection
  and s.section_order = 12
  and p.codpatient <> '15700000000'
  and p.codpatient <> '1570110009'
  and p.codpatient <> '15769696969'
group by p.codpatient, p.idpat
order by 3 desc, 2;





-- answer items for a question qId and an order
select qai.*
from question q, question_ansitem qai, answer_item ai
where q.idquestion = 2053
  and qai.codquestion = q.idquestion
  and qai.codansitem = ai.idansitem
  and qai.answer_order = 2
order by qai.answer_order;



select distinct theqs.*, pga.answer_number, pga.codanswer
from pat_gives_answer2ques pga
right join (
  select q.idquestion, q.codquestion as codq, it.item_order as itorder, 
  		qai.answer_order as ansorder, qai.codansitem
  from interview i, section s, item it, question q, question_ansitem qai
  where i.idinterview = 50
    and s.codinterview = i.idinterview
    and s.section_order = 1
    and it.idsection = s.idsection
    and q.idquestion = it.iditem
    and q.idquestion = qai.codquestion
) theqs on (pga.codquestion = theqs.idquestion) -- and pga.codpat = 3060) -- 352 -- 7300
where pga.codpat = 352 -- 3060
order by theqs.itorder, pga.answer_number, theqs.ansorder;




select pga.codquestion, pga.codpat, pga.answer_number, pga.answer_order, pga.codanswer,
  ans.thevalue, ans.datecreated, ans.lastupdated
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
order by 1, 2, 3, 4;


  
insert into answer (thevalue, answer_order, codansitem)
values ('9999', 2, 1480);

insert into pat_gives_answer2ques (codpat, codanswer, codquestion, answer_number, answer_order)
values (451, 3869, 2053, 1, 2);