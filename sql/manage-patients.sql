
select *
from interview i
where i.codprj = 50
  and UPPER(i.name) like UPPER('%isp%') 
order by i.source desc, i.name asc;


select it.content, a.thevalue, q.codquestion as codq, q.idquestion, a.idanswer
from patient p, pat_gives_answer2ques pga, answer a, question q, item it
where p.codpatient = '157011003'
--	and p.idpat = 2432
  and p.idpat = pga.codpat
  and pga.codanswer = a.idanswer
  and pga.codquestion = q.idquestion
  and q.idquestion = it.iditem
--  and a.thevalue <> '9999'
--  and q.codquestion = 'A1'
  and q.idquestion in 
  		(select idquestion from question q, item i, section s, interview it
       where it.idinterview = 50
         and s.codinterview = it.idinterview
         and i.idsection = s.idsection
         and q.idquestion = i.iditem)
order by 3,1;



-- select it.content, a.thevalue, q.codquestion, q.idquestion
-- select a.idanswer
delete from answer where idanswer in (
select a.idanswer
from patient p, pat_gives_answer2ques pga, answer a, question q, item it, performance pf
where p.codpatient = '157301066'
	and p.idpat = 2432
  and p.idpat = pga.codpat
  and pf.codpat = p.idpat
--  and pf.coduser = 750
  and pf.codinterview = 50
  and pga.codanswer = a.idanswer
  and pga.codquestion = q.idquestion
  and q.idquestion = it.iditem
  and q.idquestion in 
  		(select idquestion from question q, item i, section s, interview it
       where it.idinterview = 50 -- 1 = 1
         and s.codinterview = it.idinterview
         and i.idsection = s.idsection
         and q.idquestion = i.iditem)
);


delete 
-- select *
from perf_history ph
where codperf = (select p.idperformance from performance p where p.codpat = 
													(select pt.idpat from patient pt where pt.codpatient = '157301066'
                          	and pt.idpat = 2432) 
                  and p.codinterview = 50);
                      
delete from performance p
where p.codpat = (select pt.idpat from patient pt where pt.codpatient = '157301066'
								and pt.idpat = 2432)
and p.codinterview = 50;


-- CHANGE PATIENT'S PROPERTIES
-- get id for that patient
-- update patient fields
-- update performance table for that patient with the new group


-- get number of answer of a patient, not regarding the interview (just the 
-- entries on pat_gives_answer2question table are taken into consideration
select p.idpat, p.codpatient, pf.last_sec, count (pga.codanswer)
from patient p, pat_gives_answer2ques pga, question q, item it, section s, interview i,
 performance pf
where 1=1 -- i.idinterview = 50
  and s.codinterview = i.idinterview
  and it.idsection = s.idsection
  and q.idquestion = it.iditem
  and pf.codinterview = i.idinterview
  and pf.codpat = p.idpat
  and pga.codquestion = q.idquestion
  and pga.codpat = p.idpat
  and pf.last_sec = 1
  and p.codprj = '157'
group by 1, 2, 3
order by 4;






select g.name as gname, g.idgroup as gid, i.name as intrvname, pj.name as pjname, 
pj.project_code as pjcode, i.idinterview, pt.cod_type_subject as subjtype, 
count (pf.codpat) as countpat 
from performance pf, interview i, appgroup g , patient pt, project pj 
where pf.codpat in (	
	select p.idpat 
  from patient p, pat_gives_answer2ques pga, question q, answer a
  where pga.codanswer = a.idanswer and pga.codquestion = q.idquestion and 
  pga.codpat = p.idpat ) 
and pf.codinterview = i.idinterview 
and pf.codgroup = g.idgroup 
and pf.codpat = pt.idpat 
and pj.idprj = i.codprj 
group by 1, 2, 3, 4, 5, 6, 7 
order by 3, 2, 5;