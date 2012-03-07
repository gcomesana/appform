-- MISSING QUESTIONS FOR RecogidaMuestrasES (2400) FOR THESE PATIENTS
select v.thetime, v.intrvid, v.logmsg
from applog v
where v.logmsg like '%157011003%' 
/*
  or v.logmsg like '%performance% %188011015%' 
	or v.logmsg like '%performance% %188011022%' 
	or v.logmsg like '%performance% %188011251%' 
	or v.logmsg like '%performance% %188011275%' 
	or v.logmsg like '%performance% %188011315%' 
	or v.logmsg like '%performance% %188011359%' 
	or v.logmsg like '%performance% %188011370%' 
*/
order by v.thetime;

select v.thetime, v.intrvid, v.logmsg
from applog v
where v.logmsg like '%Samples%'
order by v.thetime desc;

select v.thetime, v.intrvid, v.logmsg
from applog v
where v.logmsg like '%Recogida%'
order by v.thetime desc;

-- pacientes de IsBlac 188 y Hospital del Mar
select p.idpat, p.codpatient, p.c_date
from patient p
where p.codpatient like '18801%'
  and length (p.codpatient) > 9
-- and length (p.codpatient) <= 9
order by 3, 2;


-- pacientes con entrevista hecha para 2400 (Recogida_Orina/Muestra)
select p.idpat, p.codpatient, p.c_date, pf.date_ini
from performance pf, patient p
where pf.codinterview = 2400 -- 3700 
  and pf.codpat = p.idpat
  and p.codpatient like '18801%'-- and length (p.codpatient) > 9
order by 3;



-- número de respuestas de cada paciente para 2400
select p.idpat, p.codpatient, count (pga.codanswer)
from pat_gives_answer2ques pga, patient p
where pga.codpat in (
	select distinct p.idpat
	from performance pf, patient p
	where pf.codinterview = 2500
  	and pf.codpat = p.idpat
)
  and pga.codpat = p.idpat
group by 1, 2
-- having count (pga.codanswer) > 1
order by 2;


-- contenido de la secction D de la entrevista 2400
/*
select p.idpat as idpat, p.codpatient as codpat, pf.date_ini as dateIni
from patient p, performance pf
where p.codprj = '188'
  and p.idpat = pf.codpat
  and pf.codinterview = 2400
except 
*/
select distinct p.idpat, p.codpatient, pf.date_ini::varchar -- , q.codquestion as codq, a.thevalue, pga.answer_order, pga.answer_number
from pat_gives_answer2ques pga, answer a, patient p, performance pf,
  section s, item it, question q
where s.idsection = 3350
  and it.idsection = s.idsection
  and q.idquestion = it.iditem
  and pga.codquestion = q.idquestion
  and pga.codanswer = a.idanswer
  and pga.codpat = p.idpat
  and pf.codpat = p.idpat
  and pf.codinterview = 2400
--  and pga.answer_order = 1
order by 3, 2;



-- pacientes que NO tienen contestada alguna pregunta para la seccion 1 de 2400
select p.idpat, p.codpatient, p.c_date --, 0 as answers
from patient p
where p.codpatient like '18801%'
  and length (p.codpatient) > 9
except
select p.idpat, p.codpatient, p.c_date --, count (pga.codanswer) as answers
from section s, item it, question q, pat_gives_answer2ques pga, patient p
where s.codinterview = 2400
  and s.section_order = 4
  and it.idsection = s.idsection
  and q.idquestion = it.iditem
  and pga.codquestion = q.idquestion
  and pga.codpat = p.idpat
--  and length (p.codpatient) = 9
group by p.idpat, p.codpatient, p.c_date
order by 2;