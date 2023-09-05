select * from PCPREST 
where 
NUMTRANSVENDA = '12810'
--DUPLIC = '61645'
and PREST ='4'
order by PREST asc;

update PCPREST set OPERACAO = 'S' where NUMTRANSVENDA = '12810' and PREST ='4'