select *
from (
  select *
  from PCLOGALTERACAODADOS
  where DATA >= to_date('09/05/2023', 'DD/MM/YYYY')
)
where rownum < 1000
order by DATA desc;
