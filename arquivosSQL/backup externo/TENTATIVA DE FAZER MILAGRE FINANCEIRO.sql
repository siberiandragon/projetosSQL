select distinct  
      A.DTLANC as DT_LANCAMENTO,  
      A.NUMNOTADESC as NF_VINCULADA, 
      A.NUMTRANSVENDA as N_TRANSACAOVENDA,  
      A.CODCLI,
      B.CLIENTE,
      A.DTDESCONTO as DT_VINCULO,
      A.NUMTRANSVENDADESC as N_NUMTRANSVINCULO,
      A.VALOR as VL_CRED,
      P.VPAGO as VL_VINCULADO,
      (select  sum(C2.VALOR)
       from PCCRECLI C2
       where C2.CODCLI = A.CODCLI
       and C2.DTDESCONTO is null
       and C2.DTESTORNO is null
       ) as SALDO,
      (select distinct E.NUMNOTA 
       from PCNFENT E
       where E.NUMTRANSENT = A.NUMTRANSENTDEVCLI
       and E.DTCANCEL is null
       ) as NFcredevol, 
      (select distinct PCMOVCR.CODBANCO || ' - ' || PCBANCO.NOME as BANCO
       from   PCMOVCR, PCBANCO
       where  PCMOVCR.NUMTRANS = A.NUMTRANS
       and    PCMOVCR.CODBANCO = PCBANCO.CODBANCO)as BANCO,
       A.HISTORICO

from PCCRECLI A
left join PCCLIENT B on A.CODCLI = B.CODCLI
left join PCPREST P on A.NUMTRANSVENDADESC = P.NUMTRANSVENDA and A.PRESTRESTCLI = P.PREST
where 0=0
and A.DTLANC between '01/01/2023' and '27/10/2023'
and A.DTDESCONTO between '01/01/2023' and '27/10/2023'
--and A.CODCLI in '208'
--and A.NUMTRANSVENDA = ''
--and A.NUMTRANSVENDADESC = ''
order by NFcredevol