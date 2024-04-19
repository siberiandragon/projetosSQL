  select
  PCPEDC.CODUSUR,
  PCUSUARI.NOME,
  to_char(nvl(PCUSUARI.VLVENDAPREV,0), '9G999G999G999D99', 'NLS_NUMERIC_CHARACTERS = '',.''') as META,
  to_char(PCNFENT.VLTOTAL, '9G999G999G999D99', 'NLS_NUMERIC_CHARACTERS = '',.''') as TOTAL_DEVL,
  to_char(TOTAL_PCPEDC.VLATEND, '9G999G999G999D99', 'NLS_NUMERIC_CHARACTERS = '',.''') as TOTAL,
  (select
    to_char((sum(S.FATURAMENTO - S.CUSTO) / sum(S.FATURAMENTO)) * 100,'9G999G999G999D99','NLS_NUMERIC_CHARACTERS = '',.') as MARG 
from  (
    select
        F.CODUSUR,
        sum((F.CUSTOULTENT * F.QT) + (((F.PERCOM/100) * F.PUNIT) * F.QT) + (((F.CODICMTAB/100) * F.PUNIT) * F.QT)) as CUSTO,
        sum((F.PUNIT * F.QT) + (nvl(F.VLFRETE, 0) * F.QT) + (nvl(F.VLOUTROS, 0) * F.QT)) as FATURAMENTO,
        sum((F.PUNIT * F.QT) + (nvl(F.VLFRETE, 0) * F.QT) + (nvl(F.VLOUTROS, 0) * F.QT)
        - (F.CUSTOULTENT * F.QT) - (((F.PERCOM/100) * F.PUNIT) * F.QT) - (((F.CODICMTAB/100) * F.PUNIT) * F.QT)) as REC
    from
        PCMOV F
        left join PCCLIENT C on C.CODCLI = F.CODCLI
        left join PCUSUARI S on S.CODUSUR = F.CODUSUR
    where
        F.DTMOV between (:DATINI) and (:DATFIM)
        and F.CODOPER in ('S')
        and F.CODFISCAL not in (5117, 6117)
        and F.DTCANCEL is null
        and (F.CODDEVOL not in (43) or F.CODDEVOL is null)
        and F.CODFILIAL in (:CODFILIAL)
        and F.CODUSUR in (:RCA)

    group by
        F.CODUSUR

    union all

    select
        F.CODUSUR,
        sum(-((F.CUSTOULTENT * F.QT) + (((F.PERCOM/100) * F.PUNIT) * F.QT) + (((F.CODICMTAB/100) * F.PUNIT) * F.QT))) as CUSTO,
        sum(-((F.PUNIT * F.QT) + (nvl(F.VLFRETE, 0) * F.QT) + (nvl(F.VLOUTROS, 0) * F.QT))) as FATURAMENTO,
        sum(-((F.PUNIT * F.QT) + (nvl(F.VLFRETE, 0) * F.QT) + (nvl(F.VLOUTROS, 0) * F.QT))
        - ((F.CUSTOULTENT * F.QT) + (((F.PERCOM/100) * F.PUNIT) * F.QT) + (((F.CODICMTAB/100) * F.PUNIT) * F.QT))) as REC
    from
        PCMOV F
        left join PCCLIENT C on C.CODCLI = F.CODCLI
        left join PCUSUARI S on S.CODUSUR = F.CODUSUR
    where   0=0
        and F.DTMOV between (:DATINI) and (:DATFIM)
        and F.CODOPER in ('ED')
        and F.CODFISCAL not in (5117, 6117)
        and F.DTCANCEL is null
        and (F.CODDEVOL not in (43) or F.CODDEVOL is null)
        and F.CODFILIAL in (:CODFILIAL)
        and F.CODUSUR in (:RCA) 
    group by
        F.CODUSUR
) S
group by
    S.CODUSUR) as MARGEM,
  to_char(coalesce(SUM(COMISSAO_AGENCIADOR), 0), '9G999G999G999D99', 'NLS_NUMERIC_CHARACTERS = '',.''') as TOTAL_AGC,
  to_char((TOTAL_PCPEDC.VLATEND  - coalesce (PCNFENT.VLTOTAL,0) - coalesce(SUM(COMISSAO_AGENCIADOR), 0)), '9G999G999G999D99', 'NLS_NUMERIC_CHARACTERS = '',.''') as LIQD,
  to_char((TOTAL_PCPEDC.VLATEND  - coalesce (PCNFENT.VLTOTAL,0) - coalesce(SUM(COMISSAO_AGENCIADOR), 0)) * 0.005, '9G999G999G999D99', 'NLS_NUMERIC_CHARACTERS = '',.''') as comissao
    -- to_char((TOTAL_PCPEDC.VLATEND  - coalesce (PCNFENT.VLTOTAL,0) - coalesce(SUM(COMISSAO_AGENCIADOR), 0)) * 0.0025, '9G999G999G999D99', 'NLS_NUMERIC_CHARACTERS = '',.''') as comissao_margem,
    -- to_char((((((((TOTAL_PCPEDC.VLATEND  - coalesce (PCNFENT.VLTOTAL,0) - coalesce(SUM(COMISSAO_AGENCIADOR), 0)) * 0.005) + 
    --  (TOTAL_PCPEDC.VLATEND - coalesce (PCNFENT.VLTOTAL,0) - coalesce(SUM(COMISSAO_AGENCIADOR), 0)) * 0.0025))))
    -- + case when SUM(COMISSAO_AGENCIADOR) is null then 1 else 0 end), '9G999G999G999D99', 'NLS_NUMERIC_CHARACTERS = '',.''') as comissao_margem_meta,
    -- to_char((TOTAL_PCPEDC.VLATEND  - coalesce (PCNFENT.VLTOTAL,0) - coalesce(SUM(COMISSAO_AGENCIADOR), 0)) * 0.0025, '9G999G999G999D99', 'NLS_NUMERIC_CHARACTERS = '',.''') as comissao_meta,
    --  to_char((((((((TOTAL_PCPEDC.VLATEND  - coalesce (PCNFENT.VLTOTAL,0) - coalesce(SUM(COMISSAO_AGENCIADOR), 0)) * 0.005) + 
    --  (TOTAL_PCPEDC.VLATEND  - coalesce (PCNFENT.VLTOTAL,0) - coalesce(SUM(COMISSAO_AGENCIADOR), 0)) * 0.0025) + 
    -- (TOTAL_PCPEDC.VLATEND  - coalesce (PCNFENT.VLTOTAL,0) - coalesce(SUM(COMISSAO_AGENCIADOR), 0)) * 0.0025)))) 
    -- + case when SUM(COMISSAO_AGENCIADOR) is null then 1 else 0 end, '9G999G999G999D99', 'NLS_NUMERIC_CHARACTERS = '',.''') as comissao_TOTAL
from
  PCPEDC
left join PCNFSAID on PCPEDC.NUMPED = PCNFSAID.NUMPED
left join VW_COMISSAO_AGENCIADA on PCPEDC.NUMTRANSVENDA = VW_COMISSAO_AGENCIADA.NUMTRANSVENDA
join PCUSUARI on PCPEDC.CODUSUR = PCUSUARI.CODUSUR
join
  (
    select VW_FT.CODUSUR,sum(VW_FT.VLATEND) as VLATEND 
    from view_vendas_resumo_faturamento  VW_FT
    where VW_FT.CODUSUR in (:RCA)
    and VW_FT.DTSAIDA between (:DATINI) and (:DATFIM)
    and VW_FT.CONDVENDA in ('1','7')
    and VW_FT.CODFILIAL  in (:CODFILIAL)
    group by VW_FT.CODUSUR
  ) TOTAL_PCPEDC on PCPEDC.CODUSUR = TOTAL_PCPEDC.CODUSUR
left join
  (
select 
      PCNFENT.CODUSURDEVOL,
      sum(PCNFENT.VLTOTAL) as VLTOTAL
from 
    PCNFENT
left join PCESTCOM on PCNFENT.NUMTRANSENT = PCESTCOM.NUMTRANSENT
left join PCTABDEV on PCNFENT.CODDEVOL = PCTABDEV.CODDEVOL
left join PCCLIENT on PCNFENT.CODFORNEC = PCCLIENT.CODCLI
left join PCEMPR on PCNFENT.CODMOTORISTADEVOL = PCEMPR.MATRICULA
left join PCUSUARI on PCNFENT.CODUSURDEVOL = PCUSUARI.CODUSUR
left join PCSUPERV on PCUSUARI.CODSUPERVisOR = PCSUPERV.CODSUPERVisOR
left join PCEMPR FUNC on PCNFENT.CODFUNCLANC = FUNC.MATRICULA
left join PCNFSAID on PCESTCOM.NUMTRANSVENDA = PCNFSAID.NUMTRANSVENDA
left join PCDEVConSUM on PCNFENT.NUMTRANSENT = PCDEVConSUM.NUMTRANSENT
WHERE  
    PCNFENT.DTENT between (:DATINI) and (:DATFIM)
    and PCNFENT.TIPODESCARGA in ('6','7','T') 
    and nvl(PCNFENT.OBS, 'X') <> 'NF CANCELADA'
    and PCNFENT.CODFISCAL in ('131','132','231','232','199','299') 
    and ((nvl(PCNFSAID.CONDVENDA, 0) in ('1', '7') and PCESTCOM.NUMTRANSVENDA = PCNFSAID.NUMTRANSVENDA)
         or (PCNFENT.VLTOTGER is null and PCNFENT.CODUSURDEVOL in (:RCA)))
    and PCNFENT.CODDEVOL in (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,47,52,55)
    and PCNFENT.CODUSURDEVOL in (:RCA) 
group by 
PCNFENT.CODUSURDEVOL
  ) PCNFENT on PCPEDC.CODUSUR = PCNFENT.CODUSURDEVOL
    where
      PCPEDC.DTFAT between  (:DATINI) and (:DATFIM)
      and PCPEDC.POSICAO = 'F'
      and PCPEDC.CODFILIAL in (:CODFILIAL)
      and PCPEDC.CODUSUR in (:RCA)
      and PCNFSAID.TIPOMOVGARANTIA is null
      and PCNFSAID.CONDVENDA in ('1','7')
group by
  PCPEDC.CODUSUR,
  PCUSUARI.NOME,
  TOTAL_PCPEDC.VLATEND,
  PCNFENT.VLTOTAL,
  PCUSUARI.VLVENDAPREV
order by
  PCPEDC.CODUSUR asc;