select distinct * from ( 
select 
  PCLANC.CODFILIAL,
  PCLANC.RECNUM,
  coalesce(PCLANC.DTEMISSAO,PCLANC.DTLANC) DTEMISSAO, 
  PCLANC.DTVENC,
  PCLANC.DTPAGTO, 
  PCLANC.CODFORNEC,     
         DECODE(PCLANC.TIPOPARCEIRO,
         'F', (select  FORNECEDOR from PCFORNEC where CODFORNEC = PCLANC.CODFORNEC), 
         'R', (select  NOME from PCUSUARI where CODUSUR = PCLANC.CODFORNEC), 
         'M', (select  NOME from PCEMPR where MATRICULA = PCLANC.CODFORNEC), 
         'L', (select  NOME from PCEMPR where MATRICULA = PCLANC.CODFORNEC), 
         'C', (select  CLIENTE from PCCLIENT where CODCLI = PCLANC.CODFORNEC), 
         'OUTROS') as  FORNECEDOR,
        case 
    when CONTAS_DRE.TIPODC = 'C' and PCLANC.VALOR < 0   
    then PCLANC.VALOR * -1
    when CONTAS_DRE.TIPODC = 'D' and PCLANC.VALOR > 0   
    then PCLANC.VALOR * -1
    else PCLANC.VALOR
end as VALOR
,
  PCLANC.CODCONTA,
  CONTAS_DRE.CONTA
from PCLANC,
     PCNFSAID,
 	 PCCONTA, 
	 PCCONSUM, 
	 CONTAS_DRE
where  0=0
      and exists(select 1 from CONTAS_DRE R where R.CODCONTA = PCLANC.CODCONTA)
      and PCLANC.CODCONTA = PCCONTA.CODCONTA
      and (nvl(PCCONTA.INVESTIMENTO,'N') <> 'S')
      and PCLANC.HISTORICO NOT LIKE ('%ESTORNO%')
      and nvl(PCLANC.CODROTINABAIXA,0) <> 737
      and PCLANC.CODCONTA = CONTAS_DRE.CODCONTA
      and PCLANC.NUMTRANSVENDA = PCNFSAID.NUMTRANSVENDA(+)
     -- and PCLANC.CODCONTA = '2020007'  --SELECIONAR CONTA
     -- and PCLANC.RECNUM = '193332'
      and nvl (PCNFSAID.CONDVENDA, 0) NOT IN (10, 20, 98, 99) 
      and (( nvl(PCNFSAID.CODFISCAL,0) NOT IN (522,622,722,532,632,732) )
       or ( TO_CHAR(PCLANC.CODCONTA) = (select VALOR from PCPARAMFILIAL where NOME = 'CON_CODCONTRECJUR') )
          )
      and (not exists (select D.NUMTRANSENT                     
                       from PCESTCOM D, PCNFSAID N              
                       where D.NUMTRANSENT = PCLANC.NUMTRANSENT 
                       and D.DTESTORNO = PCLANC.DTLANC 
                       and D.NUMTRANSVENDA = N.NUMTRANSVENDA    
                       and N.CONDVENDA IN (20)))                
     and  ( --REALIZADOS                 
     ((PCLANC.DTPAGTO is not null)   
  -- and PCLANC.DTPAGTO between '01/02/2024' and '11/03/2024'     
     and  nvl(PCLANC.VPAGO,0) <> 0
     )                                 
     or --PREVISTOS                 
     ((PCLANC.DTPAGTO is null)       
  -- and PCLANC.DTVENC between '01/02/2024' and '11/03/2024'     
     and  nvl(PCLANC.VALOR,0) <> 0       
     ))                               
  -- and PCLANC.CODFILIAL = '4'
UNION 
select 
       BA.CODFILIAL  
      ,BA.RECNUM
      ,BA.DTEMISSAO
      ,BA.DTVENC
      ,BA.DTPAGTO 
      ,BA.CODFORNEC
      ,DECODE(BA.TIPOPARCEIRO 
             ,'F' 
             ,(select FORNECEDOR 
                from PCFORNEC 
               where CODFORNEC = BA.CODFORNEC) 
             ,'R' 
             ,(select  NOME from PCUSUARI where CODUSUR = BA.CODFORNEC) 
             ,'M' 
             ,(select  NOME from PCEMPR where MATRICULA = BA.CODFORNEC) 
             ,'L' 
             ,(select  NOME from PCEMPR where MATRICULA = BA.CODFORNEC) 
             ,'C' 
             ,(select  CLIENTE from PCCLIENT where CODCLI = BA.CODFORNEC) 
             ,'OUTROS') as FORNECEDOR 
             ,case 
              when CONTAS_DRE.TIPODC = 'C' and BA.VALOR < 0   
              then BA.VALOR * -1
              when CONTAS_DRE.TIPODC = 'D' and BA.VALOR > 0   
              then BA.VALOR * -1
              else BA.VALOR
              end as VALOR
             ,BA.CODCONTA
             ,CONTAS_DRE.CONTA
      
  from PCLANCADIANTFORNEC A 
      ,PCLANC LA --LANCAMENTO DO ADIANTAMENTO 
      ,PCLANC BA --BAIXA DO ADIANTAMENTO 
      ,PCCONTA 
      ,PCCONSUM 
      ,CONTAS_DRE
 where 0=0
   and A.RECNUMADIANTAMENTO = LA.RECNUM 
   and ((LA.CODCONTA = PCCONSUM.CODCONTAADIANTFOR) or 
   (LA.CODCONTA = PCCONSUM.CODCONTAADIANTFOROUTROS)) 
   and A.RECNUMPAGTO = BA.RECNUM 
   and BA.CODCONTA = CONTAS_DRE.CODCONTA
   and A.DTESTORNO is null 
   and PCCONTA.CODCONTA = LA.CODCONTA  
   and BA.DTPAGTO is not null 
   and exists(select 1 from CONTAS_DRE R where R.CODCONTA = BA.CODCONTA) -- FIXA AS CONTAS EXISTENTES NA TABELA PERSONALIZADA
 -- and BA.CODFILIAL = '4' 
 -- and   A.DTLANC between '01/02/2024' and '11/03/2024'
 -- and BA.RECNUM = '193332'
 -- and BA.CODCONTA = '2020007' 
   and BA.DTESTORNOBAIXA is null 
 ) 
order by VALOR desc 