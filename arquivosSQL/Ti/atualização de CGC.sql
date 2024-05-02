select CODCLI,CODUSUR,SUM(VLATEND) from view_vendas_resumo_faturamento where codusur = 1139 and dtsaida between '01/04/2024' and '30/04/2024' GROUP BY CODCLI,CODUSUR;


select CGCENT from PCCLIENT WHERE CODCLI ='3061' ;

select * from PCMOV where NUMNOTA ='89274';

select * from PCUSUARI;

select * from PCPEDC where NUMNOTA ='52388';

select CODCLI,CGCENT from PCCLIENT where length(CGCENT) = 18;


select CODCLI,CGCCPF from PCCONTATO 
where 0=0
and length(CGCCPF) = 11
and CGCCPF like '[^0-9]';

select * from PCCLIENT where CODCLI =3960;


UPDATE PCCLIENT
SET CGCENT = REGEXP_REPLACE(CGCENT, '[^0-9]')
WHERE length(CGCENT) = 18;

UPDATE PCCONTATO
SET CGCCPF = REGEXP_REPLACE(CGCCPF, '[^0-9]')
WHERE length(CGCCPF) = 14;


SELECT * FROM PCPRODUT WHERE CODPROD ='804';

select C.CODFUNCULTALTER,
       P.NOME,
       C.CLIENTE,
       C.CGCENT,
       C.DTULTALTER
from PCCLIENT C 
join PCEMPR P on C.CODFUNCULTALTER = P.MATRICULA
where C.CODCLI = 3960          