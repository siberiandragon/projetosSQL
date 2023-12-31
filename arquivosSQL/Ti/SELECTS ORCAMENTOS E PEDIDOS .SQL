select * from PCORCAVENDAC;
select * from PCEMPR;
select * from PCUSUARI;
select * from PCPEDC;

select * from PCORCAVENDAI where NUMORCA='1094000011';

select CODUSUR, PCUSUARI.NOME, PCUSUARI.CODFILIAL, count(0) from PCORCAVENDAI;

select CODUSUR, NOME, CODFILIAL from PCUSUARI;  

--VERIFICAR PEDIDOS EMITIDOS (SEM RCA)
select PCPEDC.CODEMITENTE, PCEMPR.NOME, PCEMPR.CODFILIAL as FILIAL, count(distinct PCPEDC.NUMPED) as PEDIDOS 
from PCPEDC
join PCEMPR on PCPEDC.CODEMITENTE = PCEMPR.MATRICULA and PCPEDC.CODFILIAL = PCEMPR.CODFILIAL 
where PCPEDC.DATAPEDCLI >= '01/04/2023' and PCPEDC.DATAPEDCLI <= '03/04/2023' and PCEMPR.CODFILIAL = '2'
group by PCPEDC.CODEMITENTE, PCEMPR.NOME, PCEMPR.CODFILIAL 
order by count(distinct PCPEDC.NUMPED) desc; 

--VERIFICAR PEDIDOS EMITIDOS (COM RCA)
select PCPEDC.CODUSUR, PCEMPR.NOME, PCEMPR.CODFILIAL as FILIAL, count(distinct PCPEDC.NUMPED) as PEDIDOS 
from PCPEDC
join PCEMPR on PCPEDC.CODUSUR = PCEMPR.CODUSUR and PCPEDC.CODFILIAL = PCEMPR.CODFILIAL 
where PCPEDC.DATAPEDCLI >= '01/04/2023' and PCPEDC.DATAPEDCLI <= '03/04/2023' and PCEMPR.CODFILIAL<> '2'
group by PCPEDC.CODUSUR, PCEMPR.NOME, PCEMPR.CODFILIAL 
order by count(distinct PCPEDC.NUMPED) desc;


--VERIFICAR PEDIDOS EMITIDOS (SEM RCA)
select CODEMITENTE,PCEMPR.NOME, PCEMPR.CODFILIAL as FILIAL, count(0) as PEDIDOS from PCPEDC
join PCEMPR ON PCPEDC.CODEMITENTE = PCEMPR.MATRICULA and PCPEDC.CODFILIAL = PCEMPR.CODFILIAL  
where PCPEDC.DATAPEDCLI >= '01/04/2023' and PCPEDC.DATAPEDCLI <= '03/04/2023' and PCEMPR.CODFILIAL<> '2'
group by CODEMITENTE, NOME, PCEMPR.CODFILIAL 
order by 4 desc; 

--VERIFICAR ORÇAMENTOS EMITIDOS (COM RCA)
select CODEMITENTE, PCUSUARI.CODUSUR as RCA, PCUSUARI.NOME, PCUSUARI.CODFILIAL as FILIAL, count(C.CODEMITENTE) as PROPOSTAS 
from PCORCAVENDAC C
join PCUSUARI on C.CODUSUR = PCUSUARI.CODUSUR
where C.DATA >= '01/04/2023' and C.DATA <= '06/04/2023' and PCUSUARI.CODFILIAL <> '99'
group by C.CODEMITENTE, PCUSUARI.CODUSUR, PCUSUARI.NOME, PCUSUARI.CODFILIAL 
order by count(C.CODEMITENTE) desc;

--VERIFICAR ORÇAMENTOS EMITIDOS (SEM RCA) 
select CODEMITENTE, PCUSUARI.NOME, PCUSUARI.CODFILIAL as FILIAL, count(C.CODEMITENTE) as PROPOSTAS
from PCORCAVENDAC C
join PCUSUARI on C.CODUSUR = PCUSUARI.CODUSUR
where C.DATA >= '01/04/2023' and C.DATA <= '06/04/2023' and PCUSUARI.CODFILIAL <> '99'
group by C.CODEMITENTE, PCUSUARI.NOME, PCUSUARI.CODFILIAL 
order by count(C.CODEMITENTE) desc;
  

--VERIFICAR ORCAMENTOS E PEDIDOS (BY SERGIO COV.)
  SELECT CODEMITENTE, E.NOME,
NVL(MAX (DECODE (T, 'O', QTD, NULL)),0) "ORÇAMENTO",
NVL(MAX (DECODE (T, 'P', QTD, NULL)),0) "PEDIDO"
FROM (
   SELECT * FROM (
      SELECT 'P' T, CODEMITENTE, COUNT(0) QTD FROM PCPEDC where PCPEDC.DATA >='01/04/2023' and PCPEDC.DATA <='10/04/2023' GROUP BY CODEMITENTE
      UNION
      SELECT 'O' T, CODEMITENTE, COUNT(0) QTD FROM PCORCAVENDAC where PCORCAVENDAC.DATA >='01/04/2023' and PCORCAVENDAC.DATA <='10/04/2023' GROUP BY CODEMITENTE
   )
) DADOS, PCEMPR E
WHERE DADOS.CODEMITENTE = E.MATRICULA 
GROUP BY CODEMITENTE, E.NOME
ORDER BY PEDIDO desc
;






      

