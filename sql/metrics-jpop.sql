
-- seleccionar las entrevistas (QES) hechas y el usuario que la hizo
-- para cada una obtener los valores de las preguntas de Introduction y
-- el Int_Duration


-- hay solo 1151 pats
-- select distinct p.codpatient, g.name, it.name, q.codquestion, a.thevalue, subq.qcod, subq.ansval
select distinct g.name, lower(subq.ansval), count (a.thevalue)
from answer a, question q, item i, patient p, pat_gives_answer2ques pga,
 section s, interview it, performance pf, appgroup g,
(
	select p.codpatient as codpat, a.idanswer as idans, a.thevalue as ansval, 
  		q.idquestion as idques, q.codquestion as qcod
  from patient p, pat_gives_answer2ques pga, answer a, question q, item i
  where p.idpat = pga.codpat
    and a.idanswer = pga.codanswer
    and q.idquestion = pga.codquestion
  --  and q.codquestion in ('Interviewer', 'Int_Duration')
    and q.codquestion = 'Interviewer'
    and i.iditem = q.idquestion
) subq
where p.idpat = pga.codpat
  and p.codpatient = subq.codpat
  and a.idanswer = pga.codanswer
  and q.idquestion = pga.codquestion
--  and q.codquestion in ('Interviewer', 'Int_Duration')
  and q.codquestion = 'Int_Duration'
  and i.iditem = q.idquestion
  and i.idsection = s.idsection
  and it.idinterview = s.codinterview
  
  and p.idpat = pf.codpat
  and it.idinterview = pf.codinterview
  and pf.codgroup = g.idgroup
group by 1, 2
order by 1;





-- hay 1222 respuestas (1217 pats, 5 respuestas repes) a la pregunta interview para otros tantos pacientes
select distinct p.codpatient -- , it.name, a.idanswer, a.thevalue, q.idquestion
from patient p, pat_gives_answer2ques pga, answer a, question q, item i,
	section s, interview it
where p.idpat = pga.codpat
  and a.idanswer = pga.codanswer
  and q.idquestion = pga.codquestion
--  and q.codquestion in ('Interviewer', 'Int_Duration')
  and q.codquestion = 'Int_Duration'
  and i.iditem = q.idquestion
  and i.idsection = s.idsection
  and s.codinterview = it.idinterview
order by 1;


