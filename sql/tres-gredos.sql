select items.*, pgabis.answer_number, pgabis.answer_order,
        pgabis.codpatient, pgabis.idpat, a.thevalue, ai.name, ai.idansitem,
        qai.answer_order as qansord, qai.pattern
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
  ) items left join question_ansitem qai on (items.idq = qai.codquestion)
          left join answer_item ai on (qai.codansitem = ai.idansitem)
   left join (
    select *
    from pat_gives_answer2ques pga right join
          patient p on (pga.codpat = p.idpat)
    where p.codpatient = '157051556'
  ) pgabis on (items.itemid = pgabis.codquestion and pgabis.answer_order = qai.answer_order)
  left join answer a on (pgabis.codanswer = a.idanswer)
order by itemord, answer_number, answer_order;


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