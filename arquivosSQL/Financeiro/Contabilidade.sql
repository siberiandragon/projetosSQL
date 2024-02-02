select 
      L.RECNUM,
      L.CODFORNEC,
      F.FORNECEDOR,
      L.DTEMISSAO,
      L.VALOR,
      L.DTLANC,
     (nvl(L.VALOR, 0) + nvl(L.TXPERM, 0) + nvl(L.VLVARIACAOCAMBIAL, 0) -        
      nvl(L.VALORDEV,0) -                                                       
      nvl(L.DESCONTOFIN,0) ) as VL_UTIL_ADT,
      nvl(L.VALORDEV, 0) VALORDEV,
      nvl(L.DESCONTOFIN, 0) DESCONTOFIN,
      nvl(L.TXPERM, 0) TXPERMJURUS,
      L.DTVENC,
      L.DTPAGTO,
      L.DTCOMPETENCIA,
      L.NUMNOTA,
      L.HISTORICO,
      L.HISTORICO2,
      L.NUMTRANSENT,
      L.CODCONTA,
      L.TIPOPARCEIRO,
      L.LOCALIZACAO,
      L.VPAGO,
      L.NUMBORDERO,
      L.CODFILIAL,
      TIPOPAGTO
from PCLANC L
left join PCFORNEC F on L.CODFORNEC = F.CODFORNEC 
join PCCONTA C on L.CODCONTA = C.CODCONTA      
where 0=0
and L.DTLANC between '01/01/2024' and '20/01/2024'
and L.VALOR >= 0                                                                
and L.DTCANCEL is null                                                        
--and --Script para retornar apenas registros com permissão rotina 131  
--exists( select 1                                                 
--           from PCLIB                                             
--          where CODTABELA = to_char(1)                           
--            and(CODIGOA   = nvl(L.CODFILIAL, CODIGOA) or CODIGOA = '99') 
--            and CODFUNC   = CODUSUARIOLOGADO                                    
--            and PCLIB.CODIGOA is not null)                                                                 
and((nvl(L.CODROTINABAIXA, 0) <> 737)  
and((nvl(L.CODROTINABAIXA, 0) <> 750) or ((L.CODCONTA = (select CODCONTAADIANTFOR from PCCONSUM)) or (L.CODCONTA = (select CODCONTAADIANTFOROUTROS from PCCONSUM))))) 
and ((L.CODCONTA = (select CODCONTAADIANTFOR from PCCONSUM)) or (L.CODCONTA = (select CODCONTAADIANTFOROUTROS from PCCONSUM))) 
and F.DTEXCLUSAO is null 
and L.CODFILIAL in ('2')
and L.DTESTORNOBAIXA is null

order by L.RECNUM
;      
      SELECT * FROM PCLANC