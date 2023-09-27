select * from PCPREST 
where 
--NUMTRANSVENDA = '184253'
DUPLIC = '51833'
and PREST ='11'
order by PREST asc;

update PCPREST set OPERACAO = 'S' where DUPLIC = '51833' and PREST ='11';


select * from PCPREST 
where 
NUMTRANSVENDA = '184253'