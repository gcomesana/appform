
select s.section_order, s.name, q.codquestion
from interview i, section s, item it, question q
where i.idinterview = 50
  and s.codinterview = i.idinterview
  and it.idsection = s.idsection
  and it.iditem = q.idquestion
order by 1;