 select P.VALORORIG,
        S.VLTOTAL,
        (select sum(PI.QT * PR.PVENDA) as TOTAL
                                                                     from PCPEDI PI
                                                                     join PCPEDC PE on PI.NUMPED = PE.NUMPED
                                                                     join PCPRECO PR on PI.CODPROD = PR.CODPROD and PR.NUMREGIAO = PE.NUMREGIAO + 1
                                                                     where 0=0
                                                                     and PI.NUMPED = PED.NUMPED
                                                                     and PR.DATAALTER = (
                                                                                          select max(PR2.DATAALTER)
                                                                                          from PCPRECO PR2 
                                                                                          where PR2.CODPROD = PI.CODPROD
                                                                                          and PR2.NUMREGIAO = PE.NUMREGIAO + 1
                                                                                          and PR2.DATAALTER <= PE.DATA)) TOTALPSD,
        P.PERCOM2,
        PED.NUMPED,
        R.NUMREGIAO,
        case
             when R.REGIAO like '%CF%' and (P.PERCOM2 = 0 or P.PERCOM2 is null)
             then trunc ((P.VALORORIG / s.VLTOTAL) * (  S.VLTOTAL - (select sum(PI.QT * PR.PVENDA) as TOTAL
                                                                     from PCPEDI PI
                                                                     join PCPEDC PE on PI.NUMPED = PE.NUMPED
                                                                     join PCPRECO PR on PI.CODPROD = PR.CODPROD and PR.NUMREGIAO = PE.NUMREGIAO + 1
                                                                     where 0=0
                                                                     and PI.NUMPED = PED.NUMPED
                                                                     and PR.DATAALTER = (
                                                                                          select max(PR2.DATAALTER)
                                                                                          from PCPRECO PR2 
                                                                                          where PR2.CODPROD = PI.CODPROD
                                                                                          and PR2.NUMREGIAO = PE.NUMREGIAO + 1
                                                                                          and PR2.DATAALTER <= PE.DATA))),2)
             when P.PERCOM2 > 0
             then trunc ((P.PERCOM2 / 100) * P.VALOR, 2)
             else 0
        end as COMISSAO_AGENCIADOR
 from PCPREST P
 join PCNFSAID S on P.NUMTRANSVENDA = S.NUMTRANSVENDA
 join PCPEDC PED on S.NUMTRANSVENDA = PED.NUMTRANSVENDA
 left join PCREGIAO R on PED.NUMREGIAO = R.NUMREGIAO 
 where 0=0
 and P.NUMTRANSVENDA = 336790
 fetch first 1 rows only;
 
 
 --
 
 select sum (PI.QT * PR.PVENDA)
 from PCPEDI PI, PCTABPR PR
 where  0=0
 and PI.NUMPED = 1003009438
 and PR.NUMREGIAO = 1 + 1
 and PI.CODPROD = PR.CODPROD;
 
 select sum(PI.QT * PR.PVENDA) as TOTAL
from PCPEDI PI
join PCPEDC PE on PI.NUMPED = PE.NUMPED
join PCPRECO PR on PI.CODPROD = PR.CODPROD and PR.NUMREGIAO = PE.NUMREGIAO + 1
where 0=0
and PI.NUMPED = 1003009438
and PR.DATAALTER = (
select max(PR2.DATAALTER)
from PCPRECO PR2 
where PR2.CODPROD = PI.CODPROD
and PR2.NUMREGIAO = PE.NUMREGIAO + 1
and PR2.DATAALTER <= PE.DATA);


SELECT * FROM PCNFSAID WHERE NUMPED = 1003009438;