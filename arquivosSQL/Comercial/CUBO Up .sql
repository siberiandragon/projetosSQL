--Coisa linda do pai (cubo de vendas com base no usuario logado)
select 
  PCCLIENT.CODCLI,
  max(PCUSUARI.NOME) as RCA,
  max(PCCLIENT.CLIENTE) as CLIENTE,
  to_char(PCCLIENT.LIMCRED - nvl((
    select SUM(nvl(P1.VALOR, 0)) - SUM(nvl(P1.VPAGO, 0))
    from PCPREST P1
    where P1.CODCLI = PCCLIENT.CODCLI
    and P1.DTPAG IS NULL
    and P1.CODCOB <> 'DESD'
    and P1.DTPAG IS NULL
  ), 0), '9G999G999G999D99', 'NLS_NUMERIC_CHARACTERS = '',.''') as CRED_DISP,
  to_char(max(PCCLIENT.LIMCRED), '9G999G999G999D99', 'NLS_NUMERIC_CHARACTERS = '',.''') as LIMITE_CRED,
  max(PCCLIENT.DTULTCOMP) as ULTIMA_COMPRA,
  CASE
    when trunc((SYSDATE - max(PCCLIENT.DTULTCOMP)) / 365) > 0 then
      trunc((SYSDATE - max(PCCLIENT.DTULTCOMP)) / 365) || ' ANO(S) E ' || MOD(trunc(SYSDATE - max(PCCLIENT.DTULTCOMP)), 365) || ' DIA(S) '
    else 
      trunc(SYSDATE - max(PCCLIENT.DTULTCOMP)) || ' DIA(S)'
  end DIAS_SEM_COMPRA,
  (
    select to_char(SUM(PCPEDC.VLATEND), '9G999G999G999D99', 'NLS_NUMERIC_CHARACTERS = '',.''')
    from PCPEDC
    where PCPEDC.CODCLI = PCCLIENT.CODCLI
      and EXTRACT(MONTH from PCPEDC.DATA) = EXTRACT(MONTH from ADD_MONTHS(SYSDATE, -1))
      and EXTRACT(YEAR from PCPEDC.DATA) = EXTRACT(YEAR from ADD_MONTHS(SYSDATE, -1))
      and PCPEDC.POSICAO = 'F'
  ) as MES_ANTERIOR,
  (
    select to_char(SUM(PCPEDC.VLATEND), '9G999G999G999D99', 'NLS_NUMERIC_CHARACTERS = '',.''')
    from PCPEDC
    where PCPEDC.CODCLI = PCCLIENT.CODCLI
      and EXTRACT(MONTH from PCPEDC.DATA) = EXTRACT(MONTH from SYSDATE)
      and EXTRACT(YEAR from PCPEDC.DATA) = EXTRACT(YEAR from SYSDATE)
      and PCPEDC.POSICAO = 'F'
  ) as MES_ATUAL,
  (
    select to_char(SUM(PCPEDC.VLATEND), '9G999G999G999D99', 'NLS_NUMERIC_CHARACTERS = '',.''')
    from PCPEDC
    where PCPEDC.CODCLI = PCCLIENT.CODCLI
      and EXTRACT(YEAR from PCPEDC.DATA) = EXTRACT(YEAR from SYSDATE)
      and PCPEDC.POSICAO = 'F'
  ) as ANO_ATUAL,
  (
    select to_char(SUM(PCPEDC.VLATEND), '9G999G999G999D99', 'NLS_NUMERIC_CHARACTERS = '',.''')
    from PCPEDC
    where PCPEDC.CODCLI = PCCLIENT.CODCLI
      and EXTRACT(YEAR from PCPEDC.DATA) = EXTRACT(YEAR from ADD_MONTHS(SYSDATE, -11))
      and PCPEDC.POSICAO = 'F'
  ) as ANO_ANTERIOR   
from
  PCCLIENT
  join PCPEDC ON PCCLIENT.CODCLI = PCPEDC.CODCLI
  join PCUSUARI ON PCPEDC.CODUSUR = PCUSUARI.CODUSUR
  join PCNFSAID ON PCCLIENT.CODCLI = PCNFSAID.CODCLI
  join PCEMPR ON PCUSUARI.CODUSUR = PCEMPR.CODUSUR
  join PCROTINA ON PCEMPR.MATRICULA  = PCEMPR.MATRICULA 
where
  PCPEDC.CODUSUR = PCUSUARI.CODUSUR
  and 
  PCEMPR.MATRICULA = CODUSUARIOLOGADO
  and 
  PCROTINA.CODIGO = '8026'
  and
  to_char(PCPEDC.DATA, 'YYYY') = to_char(SYSDATE, 'YYYY')
group by
  PCCLIENT.CODCLI,
  PCCLIENT.LIMCRED
ORDER BY
  CRED_DISP DESC,
  max(PCCLIENT.DTULTCOMP),
  PCCLIENT.CODCLI;
  
  
  
--MARK 4 (altera��o para trazer todos os clientes do CODUSUR)  
select 
  PCCLIENT.CODCLI,
  max(PCEMPR.NOME) as RCA,
  max(PCCLIENT.CLIENTE) as CLIENTE,
  to_char(PCCLIENT.LIMCRED - nvl((
    select SUM(nvl(P1.VALOR, 0)) - SUM(nvl(P1.VPAGO, 0))
    from PCPREST P1
    where P1.CODCLI = PCCLIENT.CODCLI
      and P1.DTPAG IS NULL
      and P1.CODCOB <> 'DESD'
      and P1.DTPAG IS NULL ), 0), '9G999G999G999D99', 'NLS_NUMERIC_CHARACTERS = '',.''') as CRED_DISP,
  to_char(nvl(max(PCCLIENT.LIMCRED), 0), '9G999G999G999D99', 'NLS_NUMERIC_CHARACTERS = '',.''') as LIMITE_CRED,
  nvl(max(PCCLIENT.DTULTCOMP), '01/01/2000') as ULTIMA_COMPRA,
  CASE
    when trunc((SYSDATE - nvl(max(PCCLIENT.DTULTCOMP), SYSDATE)) / 365) > 0 then
      trunc((SYSDATE - nvl(max(PCCLIENT.DTULTCOMP), SYSDATE)) / 365) || ' ANO(S) E ' || MOD(trunc(SYSDATE - nvl(max(PCCLIENT.DTULTCOMP), SYSDATE)), 365) || ' DIA(S) '
    else 
      trunc(SYSDATE - nvl(max(PCCLIENT.DTULTCOMP), SYSDATE)) || ' DIA(S)'
  end DIAS_SEM_COMPRA,
  nvl((select 
    to_char(SUM(nvl(PCNFSAID.VLTOTAL, 0)), '9G999G999G999D99', 'NLS_NUMERIC_CHARACTERS = '',.''')
    from PCNFSAID
    where PCNFSAID.CODCLI = PCCLIENT.CODCLI
      and EXTRACT(MONTH from PCNFSAID.DTSAIDA) = EXTRACT(MONTH from ADD_MONTHS(SYSDATE, -1))
      and EXTRACT(YEAR from PCNFSAID.DTSAIDA) = EXTRACT(YEAR from ADD_MONTHS(SYSDATE, -1))
  ), 0) as MES_ANTERIOR,
  nvl((select
    to_char(SUM(nvl(PCNFSAID.VLTOTAL, 0)), '9G999G999G999D99', 'NLS_NUMERIC_CHARACTERS = '',.''')
    from PCNFSAID
    where PCNFSAID.CODCLI = PCCLIENT.CODCLI
      and EXTRACT(MONTH from PCNFSAID.DTSAIDA) = EXTRACT(MONTH from SYSDATE)
      and EXTRACT(YEAR from PCNFSAID.DTSAIDA) = EXTRACT(YEAR from SYSDATE)
  ), 0) as MES_ATUAL,
  nvl((select
    to_char(SUM(nvl(PCNFSAID.VLTOTAL, 0)), '9G999G999G999D99', 'NLS_NUMERIC_CHARACTERS = '',.''')
    from PCNFSAID
    where PCNFSAID.CODCLI = PCCLIENT.CODCLI
      and EXTRACT(YEAR from PCNFSAID.DTSAIDA) = EXTRACT(YEAR from SYSDATE)
  ), 0) as ANO_ATUAL,
  nvl((select  
    to_char(SUM(nvl(PCNFSAID.VLTOTAL, 0)), '9G999G999G999D99', 'NLS_NUMERIC_CHARACTERS = '',.''')
    from PCNFSAID
    join PCCLIENT on PCNFSAID.CODCLI = PCCLIENT.CODCLI
    where 
    EXTRACT(YEAR from PCNFSAID.DTSAIDA) = EXTRACT(YEAR from ADD_MONTHS(SYSDATE, -11))
  ), 0) as ANO_ANTERIOR
from
  PCCLIENT
  left join PCEMPR on PCCLIENT.CODUSUR1 = PCEMPR.CODUSUR
  left join PCNFSAID on PCCLIENT.CODCLI = PCNFSAID.CODCLI
  join PCROTINA on PCEMPR.MATRICULA = PCEMPR.MATRICULA
where
  PCEMPR.MATRICULA = '25' -- Substitua pelo valor da matr�cula do vendedor em quest�o
  and PCROTINA.CODIGO = '8026'
  and (PCNFSAID.DTSAIDA is null or EXTRACT(YEAR from PCNFSAID.DTSAIDA) = EXTRACT(YEAR from SYSDATE))
group by
  PCCLIENT.CODCLI,
  PCCLIENT.LIMCRED,
  PCCLIENT.CODUSUR1
order by
  CRED_DISP desc,
  max(PCCLIENT.DTULTCOMP),
  PCCLIENT.CODCLI;
  
  
  
--MARK 5 (mudan�a para to_number em meses e ano/faturamento)
select 
  PCCLIENT.CODCLI,
  max(PCEMPR.NOME) as RCA,
  max(PCCLIENT.CLIENTE) as CLIENTE,
  to_char(PCCLIENT.LIMCRED - nvl((
    select SUM(nvl(P1.VALOR, 0)) - SUM(nvl(P1.VPAGO, 0))
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
  ), 0)) as MES_ANTERIOR,
to_number(nvl((select
    SUM(nvl(PCNFSAID.VLTOTAL, 0))
    from PCNFSAID
    where PCNFSAID.CODCLI = PCCLIENT.CODCLI
      and EXTRACT(MONTH from PCNFSAID.DTSAIDA) = EXTRACT(MONTH from SYSDATE)
      and EXTRACT(YEAR from PCNFSAID.DTSAIDA) = EXTRACT(YEAR from SYSDATE)
  ), 0)) as MES_ATUAL,
to_number(nvl((select
    SUM(nvl(PCNFSAID.VLTOTAL, 0))
    from PCNFSAID
    where PCNFSAID.CODCLI = PCCLIENT.CODCLI
      and EXTRACT(YEAR from PCNFSAID.DTSAIDA) = EXTRACT(YEAR from SYSDATE)
  ), 0)) as ANO_ATUAL,
to_number(nvl((select  
    SUM(nvl(PCNFSAID.VLTOTAL, 0))
    from PCNFSAID
    join PCCLIENT on PCNFSAID.CODCLI = PCCLIENT.CODCLI
    where 
    EXTRACT(YEAR from PCNFSAID.DTSAIDA) = EXTRACT(YEAR from ADD_MONTHS(SYSDATE, -11))
  ), 0)) as ANO_ANTERIOR
from
  PCCLIENT
  left join PCEMPR on PCCLIENT.CODUSUR1 = PCEMPR.CODUSUR
  left join PCNFSAID on PCCLIENT.CODCLI = PCNFSAID.CODCLI
  join PCROTINA on PCEMPR.MATRICULA = PCEMPR.MATRICULA
where
  PCEMPR.MATRICULA = '25' -- Substitua pelo valor da matr�cula do vendedor em quest�o
  and PCROTINA.CODIGO = '8026'
  and (PCNFSAID.DTSAIDA is null or EXTRACT(YEAR from PCNFSAID.DTSAIDA) = EXTRACT(YEAR from SYSDATE))
group by
  PCCLIENT.CODCLI,
  PCCLIENT.LIMCRED,
  PCCLIENT.CODUSUR1
order by
  CRED_DISP desc,
  max(PCCLIENT.DTULTCOMP),
  PCCLIENT.CODCLI;

  --versão 2024

  select 
  C.CODCLI,
  max(R.NOME) as RCA,
  max(C.CLIENTE) as CLIENTE,
  A.RAMO,
  C.CGCENT as CNPJ,
  C.TELENT as CELULAR,
  C.TELCOB as TELEFONE,
  C.MUNICCOB as MUNICIP,
  C.ESTCOB as  UF,
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
    -- and EXTRACT(YEAR from T4.DTSAIDA) = EXTRACT(YEAR from ADD_MONTHS(SYSDATE, -2))
     and T4.TIPOMOVGARANTIA is null
     and T4.CONDVENDA in ('1','7')
  ), 0)) as ANO_ANTERIOR
from
  PCCLIENT C
  left join PCEMPR R on C.CODUSUR1 = R.CODUSUR
  left join PCNFSAID S on C.CODCLI = S.CODCLI
  join PCROTINA I on R.MATRICULA = R.MATRICULA
  left join PCATIVI A on S.CODATV1 = A.CODATIV
where  0=0
  and  R.MATRICULA in ('43') 
  --and  PCNFSAID.CODATV1 in (:CODATV)    
  and  I.CODIGO = '8040'
  --and (PCNFSAID.DTSAIDA is null or EXTRACT(YEAR from PCNFSAID.DTSAIDA) = EXTRACT(YEAR from SYSDATE))
group by
  C.CODCLI,
  C.LIMCRED,
  C.CODUSUR1,
  A.RAMO,
  C.TELENT,
  C.TELCOB,
  C.MUNICCOB,
  C.ESTCOB, 
  C.CGCENT
order by
ANO_ANTERIOR DESC;