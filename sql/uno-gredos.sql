select q.codquestion as codqes, p.idpat, a.answer_order, a.thevalue -- , i.item_order, 
-- pga.answer_number, pga.idp_a_q
from patient p, pat_gives_answer2ques pga, answer a, question q --, section s, item i
where p.idpat < 1553 and p.idpat > 1002 -- 350
  and pga.codpat = p.idpat
  and pga.codanswer = a.idanswer
  and pga.codquestion = q.idquestion
  and q.codquestion = 'E3'
--  and q.idquestion = i.iditem
--  and i.idsection = s.idsection
--  and s.idsection = 1150
--  and q.codquestion like 'K%'
-- order by 4, 2, 5;
order by 2, 3;


select q.idquestion, q.codquestion as codq, a.thevalue, a.answer_order as ord, pga.codpat
from pat_gives_answer2ques pga, question q, answer a
where q.idquestion = 51
  and q.idquestion = pga.codquestion
  and a.idanswer = pga.codanswer
order by 5,4;



/**
insert into patient (codpatient, codprj, codhosp, cod_type_subject, codpat) 
select codpatient || 'XX', codprj, codhosp, cod_type_subject, codpat||'XX'
from patient
where idpat > 100 and idpat < 103;
*/

----------------------- 
/**
update patient set codpat = substr (codpat, 1, 5)
where codpat like '%0000';

update patient set codpat = codpat || '00'
where codpatient like '188011___';
*/

-- sacar, para los grupos de repetidos, el paciente y el idquestion que ya está
select pga.codquestion, pga.codpat, pga.answer_number, pga.answer_order, pga.codanswer,
	ans.thevalue
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

delete from patient
where codpatient in ('157082010','157082011','157082012','157082013',
'157082014','157082017','157082018','157081024','157081030',
'157081031','157081032','157081033','157081034','157081035','157081036',
'157081037','157081038','157081039','157081040','157081041',
'157081042','157081043','157081044','157081045','157081046','157081050',
'157081051','157081055','157081056', '157101002','157101003','157102002',
'157091033','157091041','157091042','157091043','157091044',
'157091046','157091049','157092003','157092005','157092010','157092013','157092014'
);

delete from patient
where codpatient in ('157082010','157082011','157082012','157082013','
157082014','157082017','157082018','157081024','157081030',
'157081031','157081032','157081033','157081034','157081035','157081036',
'157081037','157081038','157081039','157081040','157081041',
'157081042','157081043','157081044','157081045','157081046','157081050',
'157081051','157081055','157081056');

delete from patient where codpatient in ('157081042');
