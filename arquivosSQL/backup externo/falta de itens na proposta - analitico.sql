select
       I.CODFILIALRETIRA,
       I.NUMORCA,
       I.CODCLI,
       C.CLIENTE,
       I.DATA,
       I.CODPROD,
       P.CODFAB,
       P.DESCRICAO,
      (select
       count(*) as Total
       from PCORCAVENDAI I2
       join PCPRODUT P2 on I2.CODPROD = P2.CODPROD
       join PCCLIENT C2 on I2.CODCLI = C2.CODCLI
       where 0=0
       and I2.QTDIASENTREGAITEM >= '1'
       and I2.DATA between ('01/10/2023') and ('30/10/2023')
       and I2.CODFILIALRETIRA = I.CODFILIALRETIRA
       and I2.CODPROD = I.CODPROD ) as Total
from PCORCAVENDAI I
join PCPRODUT P on I.CODPROD = P.CODPROD
join PCCLIENT C on I.CODCLI = C.CODCLI
where 0=0
and I.QTDIASENTREGAITEM >= '1'
and I.DATA between ('01/10/2023') and ('30/10/2023')
--and I.CODFILIALRETIRA in ('2','3','4')
--and I.CODPROD in ('804','1','306','5300')
order by Total desc;

--Mark 2 

select
       I.CODFILIALRETIRA as FILIAL,
       I.CODFILIALRETIRA as FILIAL_,
       I.NUMORCA as N_PROPOSTA, 
       I.CODUSUR,
       U.NOME,
       I.CODCLI,
       C.CLIENTE,
       I.DATA,
       I.CODPROD,
       P.CODFAB,
       P.DESCRICAO,
       I.QT,
       P.DESCRICAO as PRODUTO,
      (select
       count(*) as Total
       from PCORCAVENDAI I2
       join PCPRODUT P2 on I2.CODPROD = P2.CODPROD
       join PCCLIENT C2 on I2.CODCLI = C2.CODCLI
       where 0=0
       and I2.QTDIASENTREGAITEM >= '1'
       and I2.DATA  between (:DATINI) and (:DATFIM)
       and I2.CODFILIALRETIRA = I.CODFILIALRETIRA
       and I2.CODPROD = I.CODPROD 
       and I2.CODUSUR = I.CODUSUR
       ) as Total,
       (select
       count(*) as Total
       from PCORCAVENDAI I2
       join PCPRODUT P2 on I2.CODPROD = P2.CODPROD
       join PCCLIENT C2 on I2.CODCLI = C2.CODCLI
       where 0=0
       and I2.QTDIASENTREGAITEM >= '1'
       and I2.DATA  between (:DATINI) and (:DATFIM)
       and I2.CODFILIALRETIRA = I.CODFILIALRETIRA
       and I2.CODPROD = I.CODPROD 
       and I2.CODUSUR = I.CODUSUR
       ) as Total_
from PCORCAVENDAI I
join PCPRODUT P on I.CODPROD = P.CODPROD
join PCCLIENT C on I.CODCLI = C.CODCLI
join PCUSUARI U on I.CODUSUR = U.CODUSUR
where 0=0
and I.QTDIASENTREGAITEM >= '1'
and I.DATA between (:DATINI) and (:DATFIM)
and I.CODFILIALRETIRA in (:CODFILIAL)
and I.CODPROD in (:CODPROD)
and I.CODUSUR in (:CODUSUR)
order by Total desc;
