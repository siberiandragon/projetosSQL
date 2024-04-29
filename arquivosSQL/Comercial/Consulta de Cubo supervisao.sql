select 
  PCCLIENT.CODCLI,
   max(PCEMPR.NOME) as RCA,
   max(PCCLIENT.CLIENTE) as CLIENTE,
    PCATIVI.RAMO,
     PCCLIENT.TELENT as CELULAR,
      PCCLIENT.TELCOB as TELEFONE,
      PCCLIENT.MUNICCOB as MUNICIP,
       PCCLIENT.ESTCOB as  UF,
       to_char(PCCLIENT.LIMCRED - nvl((select SUM(nvl(P1.VALOR, 0)) - SUM(nvl(P1.VPAGO, 0))
from PCPREST P1
where P1.CODCLI = PCCLIENT.CODCLI
      and P1.DTPAG IS NULL
      and P1.CODCOB <> 'DESD'
      and P1.DTPAG IS NULL ), 0), '9G999G999G999D99', 'NLS_NUMERIC_CHARACTERS = '',.''') as CRED_DISP,
  to_char(nvl(max(PCCLIENT.LIMCRED), 0), '9G999G999G999D99', 'NLS_NUMERIC_CHARACTERS = '',.''') as LIMITE_CRED,
  nvl(max(PCCLIENT.DTULTCOMP), '31/12/9999') as ULTIMA_COMPRA,
  case
    when trunc((SYSDATE - nvl(max(PCCLIENT.DTULTCOMP), SYSDATE)) / 365) > 0 then
      trunc((SYSDATE - nvl(max(PCCLIENT.DTULTCOMP), SYSDATE)) / 365) || ' ANO(S) E ' || MOD(trunc(SYSDATE - nvl(max(PCCLIENT.DTULTCOMP), SYSDATE)), 365) || ' DIA(S) '
    else 
      trunc(SYSDATE - nvl(max(PCCLIENT.DTULTCOMP), SYSDATE)) || ' DIA(S)'
  end DIAS_SEM_COMPRA,
to_number(nvl((select 
    SUM(nvl(PCNFSAID.VLTOTAL, 0))
    from PCNFSAID
    where PCNFSAID.CODCLI = PCCLIENT.CODCLI
      and EXTRACT(MONTH from PCNFSAID.DTSAIDA) = EXTRACT(MONTH from ADD_MONTHS(SYSDATE, -1))
      and EXTRACT(YEAR from PCNFSAID.DTSAIDA) = EXTRACT(YEAR from ADD_MONTHS(SYSDATE, -1))
      and PCNFSAID.TIPOMOVGARANTIA is null
      and PCNFSAID.CONDVENDA in ('1','7')
  ), 0)) as MES_ANTERIOR,
to_number(nvl((select
    SUM(nvl(PCNFSAID.VLTOTAL, 0))
    from PCNFSAID
    where PCNFSAID.CODCLI = PCCLIENT.CODCLI
      and EXTRACT(MONTH from PCNFSAID.DTSAIDA) = EXTRACT(MONTH from SYSDATE)
      and EXTRACT(YEAR from PCNFSAID.DTSAIDA) = EXTRACT(YEAR from SYSDATE)
      and PCNFSAID.TIPOMOVGARANTIA is null
      and PCNFSAID.CONDVENDA in ('1','7')
  ), 0)) as MES_ATUAL,
to_number(nvl((select
    SUM(nvl(PCNFSAID.VLTOTAL, 0))
    from PCNFSAID
    where PCNFSAID.CODCLI = PCCLIENT.CODCLI
      and EXTRACT(YEAR from PCNFSAID.DTSAIDA) = EXTRACT(YEAR from SYSDATE)
      and PCNFSAID.TIPOMOVGARANTIA is null
      and PCNFSAID.CONDVENDA in ('1','7')
  ), 0)) as ANO_ATUAL,
to_number(nvl((select  
    SUM(nvl(PCNFSAID.VLTOTAL, 0))
    from PCNFSAID
    join PCCLIENT on PCNFSAID.CODCLI = PCCLIENT.CODCLI
    where 
    EXTRACT(YEAR from PCNFSAID.DTSAIDA) = EXTRACT(YEAR from ADD_MONTHS(SYSDATE, -11))
     and PCNFSAID.TIPOMOVGARANTIA is null
     and PCNFSAID.CONDVENDA in ('1','7')
  ), 0)) as ANO_ANTERIOR
from
  PCCLIENT
  left join PCEMPR on PCCLIENT.CODUSUR1 = PCEMPR.CODUSUR
  left join PCNFSAID on PCCLIENT.CODCLI = PCNFSAID.CODCLI
  join PCROTINA on PCEMPR.MATRICULA = PCEMPR.MATRICULA
  left join PCATIVI on PCNFSAID.CODATV1 = PCATIVI.CODATIV
where 
       PCEMPR.MATRICULA in (:MATRICULA) and
       PCNFSAID.CODATV1 in (:CODATV)    and
       PCROTINA.CODIGO = '8026'
  and (PCNFSAID.DTSAIDA is null or EXTRACT(YEAR from PCNFSAID.DTSAIDA) = EXTRACT(YEAR from SYSDATE))
group by
  PCCLIENT.CODCLI,
  PCCLIENT.LIMCRED,
  PCCLIENT.CODUSUR1,
  PCATIVI.RAMO,
  PCCLIENT.TELENT,
  PCCLIENT.TELCOB,
  PCCLIENT.MUNICCOB,
  PCCLIENT.ESTCOB
order by
  CRED_DISP desc,
  max(PCCLIENT.DTULTCOMP),
  PCCLIENT.CODCLI;
  

--Mark 2 (Troca dos campos de UF e CIDADE para a tabela PCCIDADE e inclusão dos filtros UF e CODCIDADE)
--nos filtros foi necessário criar a view VW_UF para poder fazer consulta de UF pelo relatório
select 
  C.CODCLI,
  max(R.NOME) as RCA,
  max(C.CLIENTE) as CLIENTE,
  A.RAMO,
  C.CGCENT as CNPJ,
  C.TELENT as CELULAR,
  C.TELCOB as TELEFONE,
  L.CODCIDADE as COD_IBGE,
  L.NOMECIDADE as MUNICIP,
  L.UF,
  to_char(C.LIMCRED - nvl((select sum(nvl(P1.VALOR, 0)) - sum(nvl(P1.VPAGO, 0))
from PCPREST P1
where 0=0
and P1.CODCLI = C.CODCLI
and P1.DTPAG is null
and P1.CODCOB <> 'DESD'
and P1.DTPAG is null ), 0), '9G999G999G999D99', 'NLS_NUMERIC_CHARACTERS = '',.''')as CRED_DISP,
  to_char(nvl(max(C.LIMCRED), 0), '9G999G999G999D99', 'NLS_NUMERIC_CHARACTERS = '',.''') as LIMITE_CRED,
  nvl(max(C.DTULTCOMP), '31/12/9999') as ULTIMA_COMPRA,
  case
    when trunc((SYSDATE - nvl(max(C.DTULTCOMP), SYSDATE)) / 366) > 0 
    then trunc((SYSDATE - nvl(max(C.DTULTCOMP), SYSDATE)) / 366) || ' ANO(S) E ' || MOD(trunc(SYSDATE - nvl(max(C.DTULTCOMP), SYSDATE)), 366) || ' DIA(S) '
    else trunc(SYSDATE - nvl(max(C.DTULTCOMP), SYSDATE)) || ' DIA(S)'
  end DIAS_SEM_COMPRA,
to_number(nvl((select 
    sum(nvl(T1.VLTOTAL, 0))
    from PCNFSAID T1
    where 0=0
      and T1.CODCLI = C.CODCLI
      and EXTRACT(MONTH from T1.DTSAIDA) = EXTRACT(MONTH from ADD_MONTHS(SYSDATE, -1))
      and EXTRACT(YEAR from T1.DTSAIDA) = EXTRACT(YEAR from ADD_MONTHS(SYSDATE, -1))
      and T1.TIPOMOVGARANTIA is null
      and T1.CONDVENDA in ('1','7')
  ), 0)) as MES_ANTERIOR,
to_number(nvl((select
    SUM(nvl(T2.VLTOTAL, 0))
    from PCNFSAID T2
    where 0=0
      and T2.CODCLI = C.CODCLI
      and EXTRACT(MONTH from T2.DTSAIDA) = EXTRACT(MONTH from SYSDATE)
      and EXTRACT(YEAR from T2.DTSAIDA) = EXTRACT(YEAR from SYSDATE)
      and T2.TIPOMOVGARANTIA is null
      and T2.CONDVENDA in ('1','7')
  ), 0)) as MES_ATUAL,
to_number(nvl((select
    SUM(nvl(T3.VLTOTAL, 0))
    from PCNFSAID T3
    where 0=0
      and T3.CODCLI = C.CODCLI
      and EXTRACT(YEAR from T3.DTSAIDA) = EXTRACT(YEAR from SYSDATE)
      and T3.TIPOMOVGARANTIA is null
      and T3.CONDVENDA in ('1','7')
  ), 0)) as ANO_ATUAL,
to_number(nvl((select  
    SUM(nvl(T4.VLTOTAL, 0))
    from PCNFSAID T4
    where 0=0 
     and T4.CODCLI = C.CODCLI
    -- and EXTRACT(YEAR from T4.DTSAIDA) = EXTRACT(YEAR from ADD_MONTHS(SYSDATE, -2)) --parou de funcionar na virada do ano
     and T4.TIPOMOVGARANTIA is null
     and T4.CONDVENDA in ('1','7')
  ), 0)) as ANO_ANTERIOR
from
  PCCLIENT C
  left join PCEMPR R on C.CODUSUR1 = R.CODUSUR
  left join PCNFSAID S on C.CODCLI = S.CODCLI
  join PCROTINA I on R.MATRICULA = R.MATRICULA
  left join PCATIVI A on S.CODATV1 = A.CODATIV
  left join PCCIDADE L on C.CODCIDADE = L.CODCIDADE
where  0=0
  and  R.MATRICULA in (35) 
  --and  PCNFSAID.CODATV1 in (:CODATV)    
  and  L.UF in ('PE')                   --se necessário, usar a view VW_UF ( possui as UF sem repetições)
  --and  L.CODCIDADE in ('12713')
  and  I.CODIGO = '8040'
  --and (PCNFSAID.DTSAIDA is null or EXTRACT(YEAR from PCNFSAID.DTSAIDA) = EXTRACT(YEAR from SYSDATE)) --parou de funcionar na virada do ano
group by
  C.CODCLI,
  C.LIMCRED,
  C.CODUSUR1,
  A.RAMO,
  C.TELENT,
  C.TELCOB,
  L.CODCIDADE,
  L.NOMECIDADE,
  L.UF,
  C.ESTENT, 
  C.CGCENT
order by
ANO_ANTERIOR DESC;