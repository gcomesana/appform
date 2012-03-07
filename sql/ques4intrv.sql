-- mirar las preguntas de una entrevista y sus tipos asociados
/*
select qai.codquestion, qai.codansitem
from interview i, section s, item it, question q, question_ansitem qai
where i.idinterview = s.codinterview
	and i.idinterview = 1301
	and s.idsection = it.idsection
	and it.iditem = q.idquestion
	and q.idquestion = qai.codquestion
order by 1;
*/
-- respuestas de la intrv 50 cuyo ansitem tiene interview null
select count (a.idanswer)
from interview i, section s, item it, question q, pat_gives_answer2ques p, 
			answer a, answer_item ai
where i.idinterview = 50
  and s.codinterview = i.idinterview
  and it.idsection = s.idsection
  and q.idquestion = it.iditem
  and p.codquestion = q.idquestion
  and p.codanswer = a.idanswer
  and a.codansitem = ai.idansitem
  and ai.codintrv is null;


-- respuestas para una entrevista
/*
select count (a.idanswer)
from answer a, pat_gives_answer2ques p
where a.idanswer = p.codanswer
  and p.codquestion in (select qai.codquestion
						from interview i, section s, item it, question q, question_ansitem qai
						where i.idinterview = s.codinterview
							and i.idinterview = 50
							and s.idsection = it.idsection
							and it.iditem = q.idquestion
							and q.idquestion = qai.codquestion
						)
*/


/*
select p.codquestion, a.idanswer, a.thevalue, a.codansitem
from pat_gives_answer2ques p, answer a
where p.codquestion in (51,53)
  and p.codanswer = a.idanswer
*/  
/*
-- updates the answers (only the codansitem not the value
update answer set codansitem = 1401
where codansitem = 101
and idanswer in (
	select codanswer
	from pat_gives_answer2ques
	where codquestion in (51,53)
);
*/

/*
-- update the codansitem to relate the question with the ansitem
update question_ansitem set codansitem = 1401
where codansitem = 101
  and codquestion in (51,53);
*/