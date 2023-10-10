select M.DTMOV as Data_fat,
       I.NOME as RCA, 
       M.NUMNOTA as NFe,
       R.CGCENT as CNPJ,
       R.CLIENTE as Razao_Social,
       D.DESCRICAO as Unidade, 
       S.DESCRICAO as Segmento,
       M.CODINTERNO as Cod_Fab, 
       P.DESCRICAO as Descricao,
       M.MARCA,
       M.QT as Qtde,
       M.PUNIT as Vl_Unit,
       (M.PUNIT * M.QT) as TOTAL,
       M.PERCDESC as Desconto,
       C.DESCRICAO as Cobranca,
       E.OBSENTREGA1
from PCMOV M
join PCNFSAID N on M.NUMNOTA = N.NUMNOTA
join PCCLIENT R on M.CODCLI = R.CODCLI
join PCDEPTO  D on M.CODEPTO = D.CODEPTO
join PCSECAO  S on M.CODSEC = S.CODSEC
join PCPRODUT P on M.CODPROD = P.CODPROD
join PCPLPAG  C on N.CODPLPAG = C.CODPLPAG
join PCPEDC   E on N.NUMNOTA = E.NUMNOTA
join PCMARCA  M on P.CODMARCA = M.CODMARCA
join PCUSUARI I on M.CODUSUR = I.CODUSUR
where 
M.CODMARCA = '2'
and R.CGCENT in 
('99999999999999',
'99999999999999',
'99999999999999',
'99999999999999',
'99999999999999',
'99999999999999',
'99999999999999',
'99999999999999',
'99999999999999',
'99999999999999',
'99999999999999',
'99999999999999',
'99999999999999',
'99999999999999',
'99999999999999',
'99999999999999',
'99999999999999',
'99999999999999',
'99999999999999',
'99999999999999',
'99999999999999',
'99999999999999',
'99999999999999',
'99999999999999',
'99999999999999',
'99999999999999',
'99999999999999',
'99999999999999')      
and M.DTMOV between '01/05/2023' and '28/08/2023'
and M.CODFILIAL in ('3')
and M.CODCLI in ('3187')
and I.CODUSUR in ('1077')
and I.CODSUPERVISOR in ('3')  
order by M.CODINTERNO;


select CGCENT from PCCLIENT WHERE CODCLI ='3061' ;

select * from PCMOV where NUMNOTA ='89274';

select * from PCUSUARI;

select * from PCPEDC where NUMNOTA ='52388';

select CODCLI,CGCENT from PCCLIENT where length(CGCENT) = 18;

select * from PCCLIENT where CODCLI =1654;


UPDATE PCCLIENT
SET CGCENT = REGEXP_REPLACE(CGCENT, '[^0-9]')
WHERE length(CGCENT) = 18;


SELECT * FROM PCPRODUT WHERE CODPROD ='804'






