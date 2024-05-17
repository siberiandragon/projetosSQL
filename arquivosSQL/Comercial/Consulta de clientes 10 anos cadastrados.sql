select to_date(C.DTCADASTRO, 'DD/MM/YY') DT_CADASTRO,
       C.CODUSUR1 RCA,
       U.NOME,
       C.CODCLI,
       C.CLIENTE,
       C.CGCENT,
       A.RAMO,
       to_number(nvl((select SUM(nvl(T2.VLTOTAL, 0))
                      from PCNFSAID T2
                      where 0=0
                      and T2.CODCLI = C.CODCLI
                      and EXTRACT(MONTH from T2.DTSAIDA) = EXTRACT(MONTH from SYSDATE)
                      and EXTRACT(YEAR from T2.DTSAIDA) = EXTRACT(YEAR from SYSDATE)
                      and T2.TIPOMOVGARANTIA is null
                      and T2.CONDVENDA in ('1','7')
                ), 0)) as MES_ATUAL,
       to_number(nvl((select sum(nvl(T1.VLTOTAL, 0))
                      from PCNFSAID T1
                      where 0=0
                      and T1.CODCLI = C.CODCLI
                      and EXTRACT(MONTH from T1.DTSAIDA) = EXTRACT(MONTH from ADD_MONTHS(SYSDATE, -1))
                      and EXTRACT(YEAR from T1.DTSAIDA) = EXTRACT(YEAR from ADD_MONTHS(SYSDATE, -1))
                      and T1.TIPOMOVGARANTIA is null
                      and T1.CONDVENDA in ('1','7')
                ), 0)) as MES_ANTERIOR,
       to_number(nvl((select sum(nvl(T1.VLTOTAL, 0))
                      from PCNFSAID T1
                      where 0=0
                      and T1.CODCLI = C.CODCLI
                      and EXTRACT(MONTH from T1.DTSAIDA) = EXTRACT(MONTH from ADD_MONTHS(SYSDATE, -2))
                      and EXTRACT(YEAR from T1.DTSAIDA) = EXTRACT(YEAR from ADD_MONTHS(SYSDATE, -2))
                      and T1.TIPOMOVGARANTIA is null
                      and T1.CONDVENDA in ('1','7')
                ), 0)) as MES_ANTERIOR_2,
       to_number(nvl((select sum(nvl(T1.VLTOTAL, 0))
                      from PCNFSAID T1
                      where 0=0
                      and T1.CODCLI = C.CODCLI
                      and EXTRACT(MONTH from T1.DTSAIDA) = EXTRACT(MONTH from ADD_MONTHS(SYSDATE, -3))
                      and EXTRACT(YEAR from T1.DTSAIDA) = EXTRACT(YEAR from ADD_MONTHS(SYSDATE, -3))
                      and T1.TIPOMOVGARANTIA is null
                      and T1.CONDVENDA in ('1','7')
                ), 0)) as MES_ANTERIOR_3
from PCCLIENT C
left join PCUSUARI U on C.CODUSUR1 = U.CODUSUR
left join PCATIVI  A on C.CODATV1 = A.CODATIV
where  0=0
--and C.CODUSUR1 in ('')
--and U.CODSUPERVISOR in ('')
and EXTRACT(YEAR from C.DTCADASTRO) = EXTRACT(YEAR from ADD_MONTHS(SYSDATE, -120));




