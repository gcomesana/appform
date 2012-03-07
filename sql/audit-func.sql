
/*
 * this get logmsg from applog. this one gets the performance for the user, 
 * which is useful to get when the interview was performed
 */
select v.thetime, v.intrvid, v.logmsg
from applog v
where -- v.logmsg like '%performance% %partici% %3900%'
v.logmsg like '%performance% %157031003%'
order by v.thetime;


/*
 * Gets the sections which have answer for any of their questions for 
 * a particular patient and for a interview.
 * Ex:
 * pat  idsection section_order name
 * 157972251 2700  1 INTRODUCTION
 * 157972251 2701  2 SECTION 1. DEMOGRAPHICS
 */
select distinct p.codpatient as pat, s.idsection, s.section_order, s.name
from patient p, pat_gives_answer2ques pga, answer a, item it, section s, question q,
interview i
where p.codpatient like '157972251%'
  and pga.codpat = p.idpat
  and pga.codanswer = a.idanswer
  and pga.codquestion = q.idquestion
  and q.idquestion = it.iditem
  and it.idsection = s.idsection
  and s.codinterview = 2100 -- 50 -- 4152
  and s.codinterview = i.idinterview
--  and i.codprj = 50 -- 101
order by 3;




/*
 * Gets the number of sections for each patient in subquery and for an
 * interview (2100 in this case, QES_Ireland). Can be restricted
 * or configurated. The patients, in this case, are the patientes belonging to
 * a hostpitals from Ireland (country id 5 in db)
 * The sections here are intended as the sections which have at least one answer
 * for any of their questions
 * Ex (filtered for sections with less than 13 sections):
 * pat  sections
	157801002 12
	157801099 7
	157851110 7
	157881019 5
	157911001 7
	157951167 5
	157952041 5
	157972040 5
	157972094 5
	157972251 2
 */
select s.pat, count (*) as sections
from (
select distinct p.codpatient as pat, s.idsection, s.section_order, s.name
from patient p, pat_gives_answer2ques pga, answer a, item it, section s, question q
-- ,interview i
where 1 = 1 -- p.codpatient like '157011003%'
  and p.idpat in (select pa.idpat
          from patient pa
          where pa.codhosp in (
              select gr.codgroup
              from appgroup gr
              where gr.parent = 5
      ))     
  and pga.codpat = p.idpat
  and pga.codanswer = a.idanswer
  and pga.codquestion = q.idquestion
  and q.idquestion = it.iditem
  and it.idsection = s.idsection
  and s.codinterview = 2100 -- 50 -- 4152
--  and s.codinterview = i.idinterview
--  and i.codprj = 50 -- 101
) s
group by s.pat
order by 1;




/*
 * Answers for a patient which value is different than 9999 (this can be removed)
 * and for a particular interview
 * Ex:
 * codpatient name        section_order idquestion  codqes  item_order  thevalue
	157801002 SECTION 8. COFFEE /TEA  9 9878  E1  3 2
	157801002 SECTION 8. COFFEE /TEA  9 9877  E5  10  1
	157801002 SECTION 8. COFFEE /TEA  9 9883  E6  12  12
	157801002 SECTION 8. COFFEE /TEA  9 9884  E7  13  7777
	157801002 SECTION 8. COFFEE /TEA  9 9886  E8  15  5
	157801002 SECTION 8. COFFEE /TEA  9 9886  E8  15  1
 */
select p.codpatient, s.name, s.section_order, q.idquestion, q.codquestion as codqes, it.item_order, a.thevalue
from patient p, pat_gives_answer2ques pga, answer a, item it, section s, question q
where (p.codpatient = '157801002') -- or p.codpatient = '157081015') 
  and pga.codpat = p.idpat
  and pga.codanswer = a.idanswer
  and pga.codquestion = q.idquestion
  and q.idquestion = it.iditem
  and it.idsection = s.idsection
  and a.thevalue <> '9999'
--  and s.section_order = 9
  and s.codinterview = 2100 -- 50 -- 4152 -- 3900
order by 1,3,6;




