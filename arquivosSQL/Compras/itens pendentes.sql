select 
PCPEDI.CODFILIALRETIRA as FILIAL ,
PCPEDC.NUMPED,
PCPEDC.POSICAO,
PCPEDC.CODUSUR,
PCUSUARI.NOME,
PCCLIENT.CLIENTE,
PCPRODUT.CODFAB,
PCPEDI.CODPROD, 
PCPEDI.DATA, 
PCPRODUT.DESCRICAO,
PCMARCA.MARCA, 
PCPEDI.QT as PEDIDO,
PCEST.QTESTGER - PCEST.QTRESERV - PCEST.QTBLOQUEADA AS DISPON�VEL,
case when PCEST.QTEST is null 
then PCPEDI.QT 
else PCPEDI.QT - PCEST.QTEST end as PENDENTE, PCPEDI.POSICAO 
from PCPEDI
join PCEST on (PCPEDI.CODPROD = PCEST.CODPROD and PCPEDI.CODFILIALRETIRA = PCEST.CODFILIAL)
join PCPRODUT on PCPEDI.CODPROD = PCPRODUT.CODPROD 
join PCMARCA on PCPRODUT.CODMARCA = PCMARCA.CODMARCA 
join PCPEDC on PCPEDI.NUMPED = PCPEDC.NUMPED
join PCCLIENT on PCPEDC.CODCLI = PCCLIENT.CODCLI
join PCPEDC on PCPEDI.NUMPED = PCPEDC.NUMPED
join PCUSUARI on PCPEDC.CODUSUR = PCUSUARI.CODUSUR
where 0=0
and PCPEDI.CODFILIALRETIRA in(:CODFILIALRETIRA)
and PCUSUARI.CODUSUR in (:CODUSUR)
and PCCLIENT.CODCLI in(:CODCLI) 
and PCPEDI.POSICAO in ('P','B') 
and PCPEDI.DATA between :DTINI and :DTFIM  
and PCPEDI.QT > coalesce(PCEST.QTEST, 0) 
order by PCPEDI.QT;

--Mark 2 (adicionar o calculo de disponivel no  lugar de QT.PCEST, para olhar apenas o valor disponivel)

select 
       PCPEDI.CODFILIALRETIRA as FILIAL ,
       PCPEDC.NUMPED,
       PCPEDC.POSICAO,
       PCPEDC.CODUSUR,
       PCUSUARI.NOME,
       PCCLIENT.CLIENTE,
       PCPRODUT.CODFAB,
       PCPEDI.CODPROD, 
       PCPEDI.DATA, 
       PCPRODUT.DESCRICAO,
       PCMARCA.MARCA, 
       PCPEDI.QT as PEDIDO, 
       PCEST.QTESTGER - PCEST.QTRESERV - PCEST.QTBLOQUEADA AS DISPONÍVEL,
       case 
           when PCEST.QTEST is null 
           then PCPEDI.QT 
           else PCPEDI.QT - (PCEST.QTESTGER - PCEST.QTRESERV - PCEST.QTBLOQUEADA)
           end as PENDENTE
from PCPEDI
join PCEST on (PCPEDI.CODPROD = PCEST.CODPROD and PCPEDI.CODFILIALRETIRA = PCEST.CODFILIAL)
join PCPRODUT on PCPEDI.CODPROD = PCPRODUT.CODPROD 
join PCMARCA on PCPRODUT.CODMARCA = PCMARCA.CODMARCA 
join PCPEDC on PCPEDI.NUMPED = PCPEDC.NUMPED
join PCCLIENT on PCPEDC.CODCLI = PCCLIENT.CODCLI
join PCPEDC on PCPEDI.NUMPED = PCPEDC.NUMPED
join PCUSUARI on PCPEDC.CODUSUR = PCUSUARI.CODUSUR
where 0=0
and PCPEDI.CODFILIALRETIRA in(:CODFILIALRETIRA)
and PCUSUARI.CODUSUR in ('1003')
and PCCLIENT.CODCLI in(:CODCLI) 
and PCPEDI.POSICAO in ('P','B') 
and PCPEDI.DATA between '23/10/2023' and '25/10/2023'
and PCPEDI.QT > coalesce(PCEST.QTESTGER - PCEST.QTRESERV - PCEST.QTBLOQUEADA, 0) 
order by PCPEDI.QT;