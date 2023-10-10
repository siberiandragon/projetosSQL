create or replace view VW_COMISSAO_AGENCIADA_TRY as
with TRIGUN as (
    select 
    cast(CLI.FANTASIA as varchar(120)) as FANTASIA,
    cast(CLI.CLIENTE  as varchar(120)) as CLIENTE,
    PED.OBS1,
    PED.OBS2,
    R.REGIAO,
    S.CODFILIAL,
    S.NUMNOTA,
    U.NOMECONTATO,
    U.CODCONTATO,
    U.CARGO as CODUSUR2,
    S.NUMTRANSVENDA,
    S.VLTOTAL - S.VLFRETE as VLVENDA_ITENS,
    S.VLTABELA - S.VLFRETE as VLTABELA_ITENS,
    S.CODCLI,
    P.CODUSUR2 as USUR2_ATUAL,
    P.DTPAG,
    P.DTESTORNO,
    P.DTPAGCOMISSAO,
    P.DTPAGCOMISSAO2,
    P.DTPAGCOMISSAO3,
    P.DTPAGCOMISSAO4,
    P.DTVENC,
    S.DTSAIDA,
    P.DUPLIC,
    P.PREST,
    P.CODCOB,
    P.CODCOBORIG,
    COB.COBRANCA,
    P.VALOR,
    P.VALORORIG,
    P.VPAGO,
    S.VLFRETE,
    S.VLTOTAL,
    S.VLTABELA,
    P.NUMTRANSENTDEVCLI,
    case 
        when VALOR < 0
        then P.OBSFINANC 
        else '' 
        end as OBSFINANC,
        
    case
        when P.NUMTRANSENTDEVCLI is not null 
        then (select SUM(PUNITCONT*QTCONT) from PCMOV where NUMTRANSENT = P.NUMTRANSENTDEVCLI)
        when S.DTDEVOL is not null
        then S.VLDEVOLUCAO
        end as VLDEVOLVIDO,
    P.DTDEVOL as DTDEVOLPARCIAL,
    trunc( ( (P.VALORORIG/(S.VLTOTAL)) * (S.VLTABELA) * ((USUR.PERCENT2)/100)) / P.VALORORIG,5)*100  as percom,
    USUR.PERCENT2 as COM_VENDEDOR,
    USUR.CODUSUR as CODVENDEDOR,
    USUR.NOME as VENDEDOR,
    
    case 
        when P.DTPAGCOMISSAO is null 
        then trunc(( (P.VALORORIG/(s.VLTOTAL)) * (S.VLTABELA) * ((USUR.PERCENT2)/100)) , 2)
        else 0
        end as COMISSAO_VENDEDOR,
        
    case 
        when (P.CODCOB in ('DEVP','DEVT')) 
        then '4-DEVOLUÇÕES'
        when P.VPAGO is not null and P.DTPAG is not null 
        then '1-FATURAS QUITADAS'
        when P.VPAGO is null and P.DTPAG is null and P.DTVENC < SYSDATE 
        then '3-FATURAS VENCIDAS (CLIENTES EM ABERTO)'
        when P.VPAGO is null and P.DTPAG is null and P.DTVENC >= SYSDATE 
        then '2-FATURAS A VENCER'
        end as STATUS,
        
    case 
        when P.COMA_STATUSAPRV = 'C' then 'PAGO COM CREDITO'
        when P.COMA_STATUSAPRV = 'D' then 'PAGO COM NFE'
        when P.COMA_STATUSAPRV = 'E' then 'PAGO SEM NFE'
        when P.COMA_STATUSAPRV = 'A' then 'APROVADA PENDENTE PG'
        when P.COMA_STATUSAPRV = 'R' then 'REPROVADA'
        when P.COMA_STATUSAPRV is null then 'PENDENTE APROVAÇÃO'
        else 'DESCONHECIDO'
        end as STATUSAPRV, 
        
    case 
        when (P.CODUSUR2 is null or P.CODUSUR2 = 0) and P.PERCOM2 =0 
        then 'PENDENTE'
        else 'APROVADO'
        end as APROVACAO,
    
    case
        when R.REGIAO LIKE '%CF%' and (P.PERCOM2 = 0 OR P.PERCOM2 is null)  
        then trunc((P.VALORORIG/s.VLTOTAL) * ( S.VLTOTAL - 
                                                           ( select SUM(PI.QT*PR.PVENDA)
                                                             from
                                                             PCPEDI PI,
                                                             PCTABPR PR
                                                             where 
                                                             PI.NUMPED = PED.NUMPED
                                                             and PR.NUMREGIAO = PED.NUMREGIAO+1
                                                             and PI.CODPROD = PR.CODPROD
                                                             ) ),2)
        when P.PERCOM2 > 0 
        then trunc( (P.PERCOM2/100)*P.VALOR,2 ) 
        else 0 
        end as COMISSAO_AGENCIADOR,
    
    case 
        when R.REGIAO LIKE '%CF%' and (P.PERCOM2 = 0 OR P.PERCOM2 is null) 
        then trunc(( S.VLTOTAL - 
                                ( select SUM(PI.QT*PR.PVENDA)
                                  from
                                  PCPEDI PI,
                                  PCTABPR PR
                                  where 
                                  PI.NUMPED = PED.NUMPED
                                  and PR.NUMREGIAO = PED.NUMREGIAO+1
                                  and PI.CODPROD = PR.CODPROD
                                  ) ) / S.VLTOTAL,5)*100
        
        when P.PERCOM2 > 0 then P.PERCOM2      
        else 0 end as PERCOM2,
    
    case  
        when PED.COMA_VLTABPSD is not null 
        then PED.COMA_VLTABPSD
        when R.REGIAO LIKE '%CF%' 
        then  
            ( select SUM(PI.QT*PR.PVENDA)
              from
              PCPEDI PI,
              PCTABPR PR
              where 
              PI.NUMPED = PED.NUMPED
              and PR.NUMREGIAO = PED.NUMREGIAO+1
              and PI.CODPROD = PR.CODPROD)
        else 0
        end as VL45REGIAO2,
    
    P.COMA_DTPAGCOM,
    P.COMA_DTAPROV,
    
    case
        when S.DTDEVOL is not null and S.VLDEVOLUCAO = S.VLTOTAL  and P.CODCOB = 'CRED' 
        then 'DEV TOTAL COM CREDITO'
        when S.DTDEVOL is not null and S.VLDEVOLUCAO = S.VLTOTAL 
        then 'DEV TOTAL'
        when S.DTDEVOL is not null and S.VLDEVOLUCAO < S.VLTOTAL 
        then 'DEV PARCIAL' 
        when P.DTDEVOL is not null and S.VLDEVOLUCAO < S.VLTOTAL and P.CODCOB = 'CRED' 
        then 'DEV PARCIAL COM CREDITO'
        when P.DTDEVOL is not null and S.VLDEVOLUCAO < S.VLTOTAL 
        then 'DEV PARCIAL'
        else 'SEM DEVOL'
        end as STATUS_DEV,
    
    case 
        when S.DTDEVOL is not null 
        then S.DTDEVOL
        when S.DTDEVOL is null and P.DTDEVOL is not null 
        then P.DTDEVOL
        else null
        end as DTDEVOL

from 
    PCCONTATO U 
    inner join PCPEDC PED on PED.CODCONTATO = U.CODCONTATO
    inner join PCPREST P on P.NUMTRANSVENDA = PED.NUMTRANSVENDA 
        and P.NUMPED = PED.NUMPED 
        and P.CODCLI = PED.CODCLI
    inner join PCNFSAID S on S.NUMTRANSVENDA = PED.NUMTRANSVENDA
    inner join PCUSUARI USUR on USUR.CODUSUR = s.CODUSUR
    inner join PCCLIENT CLI on CLI.CODCLI = P.CODCLI
    inner join PCCOB COB on COB.CODCOB = P.CODCOBORIG
    inner join PCREGIAO R on R.NUMREGIAO = PED.NUMREGIAO
   
where 
    U.TIPOCONTATO = 'P'
    and s.DTCANCEL is null
    --and (S.DTDEVOL is null)
    and S.CONDVENDA in (1,7)
    and S.DTCANCEL is null
    and P.TIPOESTORNO is null
    and (case when P.CODCOB = 'DEVP' and P.VPAGO > 0 then 'INVALID' 
              when P.CODCOB in ('CARC','CHDV', 'JUR', 'VALE', 'CANC', 'TR', 'BNF', 'BNFT', 'BNFR', 'BNTR', 'BNRP') then 'INVALID'
              when P.CODCOB = 'DESD' and P.CODCOBORIG in ('CARV', 'CARD','CARP') and P.VPAGO = 0 then 'VALID'
              when P.CODCOB = 'DESD' and (select X.CARTAO from PCCOB X where X.CODCOB = P.CODCOBORIG ) = 'N' then 'INVALID'
              else 'VALID' end) = 'VALID'
Order by
    U.NOMECONTATO, P.DUPLIC, P.PREST, CLI.FANTASIA 
)

select 
    FANTASIA,
    CLIENTE,
    OBS1,
    OBS2,
    REGIAO,
    CODFILIAL,
    NUMNOTA,
    NOMECONTATO,
    CODCONTATO,
    CODUSUR2,
    NUMTRANSVENDA,
    VLVENDA_ITENS,
    VLTABELA_ITENS,
    CODCLI,
    USUR2_ATUAL,
    DTPAG,
    DTESTORNO,
    DTPAGCOMISSAO,
    DTPAGCOMISSAO2,
    DTPAGCOMISSAO3,
    DTPAGCOMISSAO4,
    DTVENC,
    DTSAIDA,
    DUPLIC,
    PREST,
    CODCOB,
    CODCOBORIG,
    COBRANCA,
    VALOR,
    VALORORIG,
    VPAGO,
    VLFRETE,
    VLTOTAL,
    VLTABELA,
    NUMTRANSENTDEVCLI,
    OBSFINANC,
    VLDEVOLVIDO,
    DTDEVOLPARCIAL,
    PERCOM,
    COM_VENDEDOR,
    CODVENDEDOR,
    VENDEDOR,
    COMISSAO_VENDEDOR,
    case 
        when CODFILIAL = 4
        then round(COMISSAO_AGENCIADOR * 0.85, 2)
        else round(COMISSAO_AGENCIADOR * 0.75, 2)
        end as COMISSAO_COM_NFE,
    case 
        when CODFILIAL = 4
        then round(COMISSAO_AGENCIADOR * 0.4, 2)
        else round(COMISSAO_AGENCIADOR * 0.4, 2)
        end as COMISSAO_SEM_NFE,
    case 
        when CODFILIAL = 4 
        then round(COMISSAO_AGENCIADOR * 0.9, 2)
        else round(COMISSAO_AGENCIADOR * 0.75, 2)
        end as COMISSAO_COM_CREDITO,
    STATUS,
    STATUSAPRV,
    APROVACAO
from 
    TRIGUN
order by
    NOMECONTATO, DUPLIC, PREST, FANTASIA;
