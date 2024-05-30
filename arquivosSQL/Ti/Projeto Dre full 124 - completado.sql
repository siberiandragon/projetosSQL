select to_number(TRANSACAO) TRANSACAO,
       to_number(CODFILIAL) CODFILIAL,
       to_char(DTVENC, 'DD/MM/YYYY') DTVENC,
       to_char(DTPAG, 'DD/MM/YYYY') DTPAG,
       to_char(DTPAG, 'MM') DTPAG_MES,
       to_char(DTPAG, 'YYYY') DTPAG_ANO,
       to_number(CODCLI) CODCLI,
       to_char(CLIENTE) CLIENTE,
       to_number(VLTOTAL) VLTOTAL,
       to_number(CMV) CMV,
       to_number(CODCONTA) CODCONTA,
       to_char(CONTA) CONTA
       
from (
with WithPrest as (
    select 
        P.*,
        row_number() over (partition by P.NUMTRANSVENDA order by P.NUMTRANSVENDA) as NT
    from PCPREST P
)
select  S.NUMTRANSVENDA TRANSACAO,
        S.CODFILIAL,
        max(WP.DTVENC) DTVENC,
        max(WP.DTPAG) DTPAG,
        to_char(max(WP.DTVENC),'MM') DTPAG_MES,
        to_char(max(WP.DTPAG),'YYYY') DTPAG_ANO,
        C.CODCLI,
        C.CLIENTE,
        sum(nvl(S.VLATEND,0)) VLTOTAL, 
        sum(nvl(S.VLCUSTOFINB,0))*(-1) CMV  ,     
        case 
             when S.ESPECIE = 'NS'
             then '108'
             else '101'
        end  CODCONTA,
        case 
             when S.ESPECIE = 'NS'
             then 'VENDA DE SERVIÇOS'
             else 'VENDA DE PRODUTOS'
        end  CONTA                               
from VIEW_VENDAS_RESUMO_FATURAMENTO S     
join PCNFSAID S2 on S.NUMTRANSVENDA = S2.NUMTRANSVENDA 
join CONTAS_DRE D on S2.CODCONT = D.CODCONTA
left join WithPrest WP on S.NUMTRANSVENDA = WP.NUMTRANSVENDA and WP.NT = 1 join PCCLIENT C on S2.CODCLI = C.CODCLI
where 0=0
and nvl (S.CONDVENDA, -1) in (-1, 1, 5, 7, 9, 11, 14) 
and nvl(S.CODFISCAL,0) not in (522, 622, 722, 532, 632, 732)
and S.DTCANCEL is null 
and S.ESPECIE not in ('CO')
and (S.DTSAIDA >= '01/04/2024')
and (S.DTSAIDA <= '30/04/2024')
group by S.NUMTRANSVENDA,
         S.CODFILIAL,
         C.CODCLI,
         C.CLIENTE,
         S.ESPECIE
  
union all

select NUMTRANSENT TRANSACAO,
       CODFILIAL,
       DTVENC,
       DTPAGTO,
       DTPAGTOMES,
       DTPAGTOANO,
       CODCLI,
       CLIENTE,
       VLTOTAL,
       null CMV,
       CODCONTA,
       CONTA
       
from ( 
with WithLanc as (
    select 
        L.*,
        row_number() over (partition by L.NUMTRANSENT order by L.NUMTRANSENT) as NTE
    from PCLANC L
)
select  DEVOL.NUMTRANSENT,
        DEVOL.CODFILIAL,
        max(WL.DTVENC) DTVENC,
        max(WL.DTPAGTO) DTPAGTO,
        to_char(max(WL.DTVENC),'MM') DTPAGTOMES,
        to_char(max(WL.DTVENC),'YYYY') DTPAGTOANO,
        DEVOL.CODCLI,
        DEVOL.CLIENTE,
        sum(nvl(DEVOL.VLDEVOLUCAO,0))* -1 VLTOTAL,
        null CMV,
        '105' CODCONTA,
        'DEVOLUCAO' CONTA
from VIEW_DEVOL_RESUMO_FATURAMENTO DEVOL
left join WithLanc WL on DEVOL.NUMTRANSENT = WL.NUMTRANSENT and WL.NTE = 1 join PCCLIENT C on DEVOL.CODCLI = C.CODCLI
where 0=0
and DEVOL.DTENT between '01/04/2024' and '30/04/2024'
and DEVOL.CONDVENDA not in (4, 8, 10, 13, 20, 98, 99)
group by DEVOL.NUMTRANSENT,
          DEVOL.CODFILIAL,
          DEVOL.CODCLI,
          DEVOL.CLIENTE

union all

select * from (
with WithLanc as (
    select 
        L.*,
        row_number() over (partition by L.NUMTRANSENT order by L.NUMTRANSENT) as NTE
    from PCLANC L
) 
 select AVULSA.NUMTRANSENT,
        AVULSA.CODFILIAL,
        max(WL.DTVENC) DTVENC,
        max(WL.DTPAGTO) DTPAGTO,
        to_char(max(WL.DTVENC),'MM') DTPAGTOMES,
        to_char(max(WL.DTVENC),'YYYY') DTPAGTOANO,
        AVULSA.CODCLI,
        AVULSA.CLIENTE,
        sum(nvl(AVULSA.VLTOTAL,0)) * -1 VLAVULSA,
        null CMV,
        '105' CODCONTA,
        'DEVOLUCAO' CONTA
from VIEW_DEVOL_RESUMO_FATURAVULSA AVULSA
left join WithLanc WL on AVULSA.NUMTRANSENT = WL.NUMTRANSENT and WL.NTE = 1 join PCCLIENT C on AVULSA.CODCLI = C.CODCLI
where 0=0
and AVULSA.DTENT between '01/04/2024' and '30/04/2024'
group by AVULSA.NUMTRANSENT,
         AVULSA.CODFILIAL,
         AVULSA.CODCLI,
         AVULSA.CLIENTE

  )
 )
)


union all


select to_number(TRANSACAO) TRANSACAO,
       to_number(CODFILIAL) CODFILIAL,
       to_char(DTVENC, 'DD/MM/YYYY') DTVENC,
       to_char(DTPAG, 'DD/MM/YYYY') DTPAG,
       to_char(DTPAG, 'MM') DTPAG_MES,
       to_char(DTPAG, 'YYYY') DTPAG_ANO,
       to_number(CODCLI) CODCLI,
       to_char(CLIENTE) CLIENTE,
       to_number(VLTOTAL) VLTOTAL,
       to_number(CMV) CMV,
       to_number(CODCONTA) CODCONTA,
       to_char(CONTA) CONTA
from (
select RECNUM TRANSACAO,
       CODFILIAL,
       DTVENC,
       DTPAGTO DTPAG,
       DTPAGTOMES,
       DTPAGTOANO,
       CODCLI,
       CLIENTE,
       SUM(nvl(VPAGO,0)) VLTOTAL,
       CMV,
       CODCONTA,
       CONTA
from ( 
select  PCLANC.RECNUM, 
        PCLANC.DTVENC,
        PCLANC.DTPAGTO, 
        to_char((PCLANC.DTVENC),'MM') DTPAGTOMES,
        to_char((PCLANC.DTVENC),'YYYY') DTPAGTOANO,
        (decode(PCLANC.DTPAGTO, NULL, PCLANC.VALOR, (decode(nvl(PCLANC.VPAGO,0),0,decode(PCLANC.DESCONTOFIN, PCLANC.VALOR, PCLANC.VALOR, decode(PCLANC.VALORDEV, PCLANC.VALOR, PCLANC.VALOR, 0)),nvl(PCLANC.VPAGO,0) + nvl(PCLANC.VALORDEV,0)) * (1)))) * (-1) VPAGO,
         decode(PCLANC.TIPOPARCEIRO,
         'F', (select CODFORNEC from PCFORNEC where CODFORNEC = PCLANC.CODFORNEC), 
         'R', (select CODUSUR from PCUSUARI where CODUSUR = PCLANC.CODFORNEC), 
         'M', (select MATRICULA from PCEMPR where MATRICULA = PCLANC.CODFORNEC), 
         'L', (select MATRICULA from PCEMPR where MATRICULA = PCLANC.CODFORNEC), 
         'C', (select CODCLI from PCCLIENT where CODCLI = PCLANC.CODFORNEC), 
         '0') as  CODCLI,
         decode(PCLANC.TIPOPARCEIRO,
         'F', (select FORNECEDOR from PCFORNEC where CODFORNEC = PCLANC.CODFORNEC), 
         'R', (select NOME from PCUSUARI where CODUSUR = PCLANC.CODFORNEC), 
         'M', (select NOME from PCEMPR where MATRICULA = PCLANC.CODFORNEC), 
         'L', (select NOME from PCEMPR where MATRICULA = PCLANC.CODFORNEC), 
         'C', (select CLIENTE from PCCLIENT where CODCLI = PCLANC.CODFORNEC), 
         'OUTROS') as  CLIENTE,
         PCLANC.CODFILIAL,
         PCLANC.CODCONTA,
         PCCONTA.CONTA,
         null CMV
from PCLANC,
     PCNFSAID,
     PCCONSUM,
     PCCONTA
where 0=0
and PCLANC.CODCONTA = PCCONTA.CODCONTA
and PCCONTA.GRUPOCONTA in ('201','202','250','301','302','303','304','305','306','307','401','402','403','404','405','406','501')
and (nvl(PCCONTA.INVESTIMENTO,'N') <> 'S')
and nvl(PCLANC.CODROTINABAIXA,0) <> 737
and (select COUNT(C.NUMSEQCONTRATOEMPRESTIMO) 
     from PCCONTRATOEMPRESTIMO C, PCLANC LC 
     where 0=0
     and C.NUMSEQCONTRATOEMPRESTIMO = LC.NUMSEQCONTRATOEMPRESTIMO 
     and C.TIPOCONTRATO = 6 
     and nvl(LC.CODROTINABAIXA,0) = 772 
     and LC.RECNUM = PCLANC.RECNUM) = 0 
     and PCLANC.NUMTRANSVENDA = PCNFSAID.NUMTRANSVENDA(+)
     and nvl(PCNFSAID.CONDVENDA, 0) not in (10, 20, 98, 99) 
     and ((nvl(PCNFSAID.CODFISCAL,0) not in (522,622,722,532,632,732) )
     or  (to_char(PCLANC.CODCONTA) = (select VALOR 
                                      from PCPARAMFILIAL 
                                      where 0=0 
                                      and NOME = 'CON_CODCONTRECJUR') )
          )
     and (select COUNT(D.NUMTRANSENT) 
          from PCESTCOM D, PCNFSAID N 
          where 0=0
          and D.NUMTRANSENT = PCLANC.NUMTRANSENT 
          and D.DTESTORNO = PCLANC.DTLANC 
          and D.NUMTRANSVENDA = N.NUMTRANSVENDA 
          and N.CONDVENDA in (20)) = 0 
     and  ( --realizados                 
          ((PCLANC.DTPAGTO is not null)   
     and  (PCLANC.DTPAGTO >= '01/04/2024' ) 
     and  (PCLANC.DTPAGTO <= '30/04/2024' )    
     and  nvl(PCLANC.VPAGO,0) <> 0
          )                                 
      or    --previstos                 
          ((PCLANC.DTPAGTO is null)       
     and  (PCLANC.DTVENC >= '01/04/2024' )  
     and  (PCLANC.DTVENC <= '30/04/2024' )     
     and  nvl(PCLANC.VALOR,0) <> 0)
          )          
	 
union 

select BA.RECNUM 
      ,BA.DTVENC
      ,BA.DTPAGTO 
      ,to_char((BA.DTVENC),'MM') DTPAGTOMES
      ,to_char((BA.DTVENC),'YYYY') DTPAGTOANO
      ,BA.VPAGO + nvl(BA.VLVARIACAOCAMBIAL, 0) as VPAGO 
      ,decode(BA.TIPOPARCEIRO 
             ,'F',(select CODFORNEC from PCFORNEC where CODFORNEC = BA.CODFORNEC) 
             ,'R',(select CODUSUR from PCUSUARI where CODUSUR = BA.CODFORNEC) 
             ,'M',(select MATRICULA from PCEMPR where MATRICULA = BA.CODFORNEC) 
             ,'L',(select MATRICULA from PCEMPR where MATRICULA = BA.CODFORNEC) 
             ,'C',(select CODCLI from PCCLIENT where CODCLI = BA.CODFORNEC) 
             ,'0') as CODCLI 
      ,decode(BA.TIPOPARCEIRO 
             ,'F',(select FORNECEDOR from PCFORNEC where CODFORNEC = BA.CODFORNEC) 
             ,'R',(select NOME from PCUSUARI where CODUSUR = BA.CODFORNEC) 
             ,'M',(select NOME from PCEMPR where MATRICULA = BA.CODFORNEC) 
             ,'L',(select NOME from PCEMPR where MATRICULA = BA.CODFORNEC) 
             ,'C',(select CLIENTE from PCCLIENT where CODCLI = BA.CODFORNEC) 
             ,'OUTROS') as CLIENTE 
      ,BA.CODFILIAL 
      ,BA.CODCONTA
      ,PCCONTA.CONTA
      ,null CMV
  from PCLANCADIANTFORNEC A 
      ,PCLANC LA --LANCAMENTO DO ADIANTAMENTO 
      ,PCLANC BA --BAIXA DO ADIANTAMENTO 
      ,PCCONTA 
      ,PCCONSUM 
 where 0=0
   and A.RECNUMADIANTAMENTO = LA.RECNUM 
   and PCCONTA.GRUPOCONTA in ('401','402','403','404','405','406','501')
   and A.RECNUMPAGTO = BA.RECNUM 
   and A.DTESTORNO is null 
   and PCCONTA.CODCONTA = LA.CODCONTA 
   and A.DTLANC BETWEEN '01/04/2024' and '30/04/2024' 
   and ((LA.CODCONTA = PCCONSUM.CODCONTAADIANTFOR) OR 
       (LA.CODCONTA = PCCONSUM.CODCONTAADIANTFOROUTROS)) 
   and BA.DTPAGTO is not null 
   and BA.DTESTORNOBAIXA is null 
 ) 
group by RECNUM ,
         CODFILIAL,
         DTVENC,
         DTPAGTO,
         DTPAGTOMES,
         DTPAGTOANO,
         CODCLI,
         CLIENTE,
         CMV,
         CODCONTA,
         CONTA 
 

)