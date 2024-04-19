
select
  PCPEDC.CODUSUR,
  PCUSUARI.NOME,
  to_char(nvl(PCUSUARI.VLVENDAPREV,0), '9G999G999G999D99', 'NLS_NUMERIC_CHARACTERS = '',.''') as META,
  to_char(PCNFENT.VLTOTAL, '9G999G999G999D99', 'NLS_NUMERIC_CHARACTERS = '',.''') as TOTAL_DEVL,
  to_char(TOTAL_PCPEDC.VLATEND, '9G999G999G999D99', 'NLS_NUMERIC_CHARACTERS = '',.''') as TOTAL,
  (select to_char((sum(S.FATURAMENTO - S.CUSTO) / sum(S.FATURAMENTO)) * 100,'9G999G999G999D99','NLS_NUMERIC_CHARACTERS = '',.') as MARG 
    from  
       ( 
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
          left join PCEMPR   P on S.CODUSUR = P.CODUSUR
          left join PCROTINA R on PCEMPR.MATRICULA = PCEMPR.MATRICULA 
            where
            F.CODOPER in ('S')
            and F.CODFISCAL not in (5117, 6117)
            and F.DTCANCEL is null
            and (F.CODDEVOL not in (43) or F.CODDEVOL is null)
            and F.CODUSUR = S.CODUSUR
            and P.MATRICULA = CODUSUARIOLOGADO
            and R.CODIGO = '8035'
            and F.CODFILIAL in ('2','3','4')
            and F.DTMOV between (:DATINI) and (:DATFIM)
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
      left join PCEMPR   P on S.CODUSUR = P.CODUSUR
      left join PCROTINA R on PCEMPR.MATRICULA  = PCEMPR.MATRICULA 
        where
        F.CODOPER in ('ED')
        and F.CODFISCAL not in (5117, 6117)
        and F.DTCANCEL is null
        and (F.CODDEVOL not in (43) or F.CODDEVOL is null)
        and F.CODUSUR = S.CODUSUR
        and P.MATRICULA = CODUSUARIOLOGADO
        and R.CODIGO = '8035'
        and F.CODFILIAL in ('2','3','4')
        and F.DTMOV between (:DATINI) and (:DATFIM)
        group by
        F.CODUSUR
) S
group by
    S.CODUSUR) as MARGEM,
  to_char(coalesce(SUM(COMISSAO_AGENCIADOR), 0), '9G999G999G999D99', 'NLS_NUMERIC_CHARACTERS = '',.''') as TOTAL_AGC,
  to_char((TOTAL_PCPEDC.VLATEND  - coalesce (PCNFENT.VLTOTAL,0) - coalesce(SUM(COMISSAO_AGENCIADOR), 0)), '9G999G999G999D99', 'NLS_NUMERIC_CHARACTERS = '',.''') as LIQD,
  to_char((TOTAL_PCPEDC.VLATEND  - coalesce (PCNFENT.VLTOTAL,0) - coalesce(SUM(COMISSAO_AGENCIADOR), 0)) * 0.005, '9G999G999G999D99', 'NLS_NUMERIC_CHARACTERS = '',.''') as comissao
from
  PCPEDC
left join PCNFSAID on PCPEDC.NUMPED = PCNFSAID.NUMPED
left join VW_COMISSAO_AGENCIADA on PCPEDC.NUMTRANSVENDA = VW_COMISSAO_AGENCIADA.NUMTRANSVENDA
join PCUSUARI on PCPEDC.CODUSUR = PCUSUARI.CODUSUR
join PCEMPR on PCUSUARI.CODUSUR = PCEMPR.CODUSUR
join PCROTINA on PCEMPR.MATRICULA  = PCEMPR.MATRICULA 
join
  (
    select VW_FT.CODUSUR,sum(VW_FT.VLATEND) as VLATEND 
    from view_vendas_resumo_faturamento  VW_FT
    where VW_FT.CODUSUR in (:RCA)
    and VW_FT.DTSAIDA between (:DATINI) and (:DATFIM)
    and VW_FT.CONDVENDA in ('1','7')
    and VW_FT.CODFILIAL in ('2','3','4')
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
  left join PCEMPR FUNC on PCNFENT.CODFUNCLANC = FUNC.MATRICULA
  left join PCNFSAID on PCESTCOM.NUMTRANSVENDA = PCNFSAID.NUMTRANSVENDA
  left join PCDEVCONSUM on PCNFENT.NUMTRANSENT = PCDEVCONSUM.NUMTRANSENT
  left join PCUSUARI S on S.CODUSUR = PCNFENT.CODUSURDEVOL
  left join PCEMPR   P on S.CODUSUR = P.CODUSUR
  left join PCROTINA R on P.MATRICULA  = P.MATRICULA 
    where  0=0
    and PCNFENT.DTENT between (:DATINI) and (:DATFIM)
    and PCNFENT.TIPODESCARGA in ('6','7','T') 
    and nvl(PCNFENT.OBS, 'X') <> 'NF CANCELADA'
    and PCNFENT.CODFISCAL in ('131','132','231','232','199','299') 
    and ((nvl(PCNFSAID.CONDVENDA, 0) in ('1', '7') and PCESTCOM.NUMTRANSVENDA = PCNFSAID.NUMTRANSVENDA)
         or (PCNFENT.VLTOTGER is null and PCNFENT.CODUSURDEVOL = S.CODUSUR))
    and PCNFENT.CODDEVOL in (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,47,52,55)
    and PCNFENT.CODUSURDEVOL = S.CODUSUR
    and P.MATRICULA = CODUSUARIOLOGADO
    and R.CODIGO = '8035'
    and PCNFENT.CODFILIALNF in ('2','3','4')
    group by 
    PCNFENT.CODUSURDEVOL                     
  ) PCNFENT on PCPEDC.CODUSUR = PCNFENT.CODUSURDEVOL
      where
      PCPEDC.POSICAO = 'F'
      and PCPEDC.DTFAT
      between (:DATINI) and (:DATFIM)
      and PCPEDC.CODFILIAL in ('2','3','4')
      and PCPEDC.CODUSUR = PCUSUARI.CODUSUR
      and PCEMPR.MATRICULA = CODUSUARIOLOGADO
      and PCROTINA.CODIGO = '8035'
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