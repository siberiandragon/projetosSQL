 select P.VALORORIG,
        S.VLTOTAL,
        P.PERCOM2,
        PED.NUMPED,
        R.NUMREGIAO,
        case
             when R.REGIAO like '%CF%' and (P.PERCOM2 = 0 or P.PERCOM2 is null)
             then trunc ((P.VALORORIG / s.VLTOTAL) * (  S.VLTOTAL - (select sum (PI.QT * PR.PVENDA)
                                                                     from PCPEDI PI, PCTABPR PR
                                                                     where 0=0
                                                                     and PI.NUMPED = PED.NUMPED
                                                                     and PR.NUMREGIAO = PED.NUMREGIAO + 1
                                                                     and PI.CODPROD = PR.CODPROD)),2)
             when P.PERCOM2 > 0
             then trunc ((P.PERCOM2 / 100) * P.VALOR, 2)
             else 0
        end as COMISSAO_AGENCIADOR
 from PCPREST P
 join PCNFSAID S on P.NUMTRANSVENDA = S.NUMTRANSVENDA
 join PCPEDC PED on S.NUMTRANSVENDA = PED.NUMTRANSVENDA
 left join PCREGIAO R on PED.NUMREGIAO = R.NUMREGIAO 
 where 0=0
 and P.NUMTRANSVENDA = 261907
 fetch first 1 rows only;
 
 
 --
 
 select sum (PI.QT * PR.PVENDA)
 from PCPEDI PI, PCTABPR PR
 where  0=0
 and PI.NUMPED = 1092010074
 and PR.NUMREGIAO = 5 + 1
 and PI.CODPROD = PR.CODPROD