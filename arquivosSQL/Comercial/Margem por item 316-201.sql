
select case  when (select A.AGRUPAMENTO from PCORCAVENDAC A where A.NUMORCA = '1003004832') = 'S'
        then (select trunc(((PCTABPR.PTABELA) -
        ((nvl(EST.CUSTOULTENT, 0) -  nvl(PCTRIBUT.PERDESCCUSTO, 0)) + 
        ((PCTABPR.PTABELA * nvl(PCTRIBUT.CODICMTAB, 0)) / 100)  + 
        (PCTABPR.PTABELA * nvl(PCPRODUT.PCOMREP1, 0)) / 100) +
        nvl(PCREGIAO.VLFRETEKG, 0)) / (PCTABPR.PTABELA) * 100, 4)
        from PCREGIAO                                             
      , PCTABPR                                              
      , PCTRIBUT                                             
      , PCEST EST                                            
      , PCPRODUT                                             
      , PCFILIAL                                           
      , PCFORNEC                                           
      , PCPRODFILIAL                                       
      , PCCONSUM                                          
      , PCTABTRIB              
      , PCORCAVENDAC
      , PCORCAVENDAI                            
    where ((PCREGIAO.STATUS not in ('I')) OR (PCREGIAO.STATUS is null))                                      
    and PCTABPR.CODPROD     = PCPRODUT.CODPROD                                                                
    and PCTABPR.NUMREGIAO   = PCREGIAO.NUMREGIAO
    and PCORCAVENDAI.CODPROD = PCTABPR.CODPROD
    and PCORCAVENDAC.NUMORCA = PCORCAVENDAI.NUMORCA                                                                           
    and PCPRODUT.CODFORNEC  = PCFORNEC.CODFORNEC  
    and PCPRODFILIAL.CODPROD   = EST.CODPROD      
    and PCPRODFILIAL.CODFILIAL = EST.CODFILIAL    
    and EST.CODFILIAL     = PCFILIAL.CODIGO       
    and PCTABPR.CODPROD     = EST.CODPROD                                                                   
   and  (PCTABTRIB.CODFILIALNF = DECODE(nvl(PCREGIAO.CODFILIAL,'99'),'99',                              
   EST.CODFILIAL,PCREGIAO.CODFILIAL))                                                                       
   and PCTABTRIB.UFDESTINO   = PCREGIAO.UF                                                                  
   and PCTABTRIB.CODPROD     = PCTABPR.CODPROD                                                              
   and PCTABTRIB.CODST       = PCTRIBUT.CODST  
   and DECODE(nvl(PCREGIAO.CODFILIAL,'99'),'99', '2', PCREGIAO.CODFILIAL) = EST.CODFILIAL
   and PCTABPR.CODPROD   = '804'
   and PCTABPR.NUMREGIAO = (select C.NUMREGIAO 
                            from PCORCAVENDAC A 
                            join PCTABPRCLI C on A.CODCLI = C.CODCLI and C.CODFILIALNF = A.CODFILIAL 
                            where A.NUMORCA = '1003005387' 
                             )                                                      
   fetch first 1 rows only )
        else (select 0-0 from PCORCAVENDAC  fetch first 1 rows only)
        end M_Precificacao
       
from PCREGIAO                                             
      , PCTABPR                                              
      , PCTRIBUT                                             
      , PCEST EST                                            
      , PCPRODUT                                             
      , PCFILIAL                                           
      , PCFORNEC                                           
      , PCPRODFILIAL                                       
      , PCCONSUM                                          
      , PCTABTRIB              
      , PCORCAVENDAC 
      , PCORCAVENDAI                            
   where ((PCREGIAO.STATUS not in ('I')) OR (PCREGIAO.STATUS is null))                                      
    and PCTABPR.CODPROD     = PCPRODUT.CODPROD                                                                
    and PCTABPR.NUMREGIAO   = PCREGIAO.NUMREGIAO
    and PCORCAVENDAI.CODPROD = PCTABPR.CODPROD
    and PCORCAVENDAC.NUMORCA = PCORCAVENDAI.NUMORCA                                                                           
    and PCPRODUT.CODFORNEC  = PCFORNEC.CODFORNEC  
    and PCPRODFILIAL.CODPROD   = EST.CODPROD      
    and PCPRODFILIAL.CODFILIAL = EST.CODFILIAL    
    and EST.CODFILIAL     = PCFILIAL.CODIGO       
    and PCTABPR.CODPROD     = EST.CODPROD                                                                   
    and  (PCTABTRIB.CODFILIALNF = DECODE(nvl(PCREGIAO.CODFILIAL,'99'),'99',                              
    EST.CODFILIAL,PCREGIAO.CODFILIAL))                                                                       
   and PCTABTRIB.UFDESTINO   = PCREGIAO.UF                                                                  
   and PCTABTRIB.CODPROD     = PCTABPR.CODPROD                                                              
   and PCTABTRIB.CODST       = PCTRIBUT.CODST  
   and DECODE(nvl(PCREGIAO.CODFILIAL,'99'),'99', '2', PCREGIAO.CODFILIAL) = EST.CODFILIAL
   and PCTABPR.CODPROD   = '804'
   and PCTABPR.NUMREGIAO = (select C.NUMREGIAO 
                            from PCORCAVENDAC A 
                            join PCTABPRCLI C on A.CODCLI = C.CODCLI and C.CODFILIALNF = A.CODFILIAL 
                            where A.NUMORCA = '1003005387') fetch first 1 rows only;