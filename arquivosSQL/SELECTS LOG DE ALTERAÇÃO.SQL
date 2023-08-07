select DATA,CODFUNC, CODROTINA,TABELA,COLUNA, VALORALFA
from (
  select *
  from PCLOGALTERACAODADOS
  where DATA >= to_date('10/05/2023', 'DD/MM/YYYY') and  CODIGO='1122000295'
)
where rownum < 1000
order by DATA desc;


select * from PCLOGALTERACAODADOS
where CODROTINA ='605'