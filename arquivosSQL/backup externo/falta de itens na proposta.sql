select 
    I.CODPROD,
    P.CODFAB,
    P.DESCRICAO,
    count(*) as Total
from PCORCAVENDAI I
join PCPRODUT P on I.CODPROD = P.CODPROD
where 0=0
and I.QTDIASENTREGAITEM >= '1'
and I.DATA between (:DATINI) and (:DATFIM)
and I.CODFILIALRETIRA in (:CODFILIAL)
and I.CODPROD in (:CODPROD)
group by I.CODPROD, P.DESCRICAO, P.CODFAB
order by Total desc;