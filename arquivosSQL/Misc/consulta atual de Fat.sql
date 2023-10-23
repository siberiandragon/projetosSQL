select S.CODUSUR,sum(S.VLTOTAL)
from PCNFSAID S
join PCPEDC P on S.NUMNOTA = P.NUMNOTA
where 0=0
and S.CONDVENDA in ('1','7')
and P.POSICAO = 'F'
and S.DTCANCEL is null
and S.DTSAIDA between '01/09/2023' and '30/09/2023'
and S.CODUSUR IN ('1003','1011','1032','1062','1063','1065','1078','1139','1151','1152','6000')
group by S.CODUSUR;

select S.CODUSUR,sum(S.VLTOTAL)
from PCNFSAID S
join PCPEDC P on S.NUMNOTA = P.NUMNOTA
where 0=0
and S.CONDVENDA in ('1','7')
and P.POSICAO = 'F'
and S.DTCANCEL is null
and S.DTSAIDA between '01/09/2023' and '30/09/2023'
and S.CODSUPERVISOR = '3'
group by S.CODUSUR
order by S.CODUSUR;
