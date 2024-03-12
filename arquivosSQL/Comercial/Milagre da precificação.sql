
SELECT ((PCTABPR.PTABELA) -
       ((nvl(EST.CUSTOULTENT, 0) -  nvl(PCTRIBUT.PERDESCCUSTO, 0)) + 
       ((PCTABPR.PTABELA * nvl(PCTRIBUT.CODICMTAB, 0)) / 100)  + 
       (PCTABPR.PTABELA * nvl(PCPRODUT.PCOMREP1, 0)) / 100) +
       nvl(PCREGIAO.VLFRETEKG, 0)) / (PCTABPR.PTABELA) * 100 M_Precificacao
       
FROM PCREGIAO                                             
      , PCTABPR                                              
      , PCTRIBUT                                             
      , PCEST EST                                            
      , PCPRODUT                                             
      , PCFILIAL                                           
      , PCFORNEC                                           
      , PCPRODFILIAL                                       
      , PCCONSUM                                          
      , PCTABTRIB                                          
   WHERE ((PCREGIAO.STATUS NOT IN ('I')) OR (PCREGIAO.STATUS IS NULL))                                      
    AND PCTABPR.CODPROD     = PCPRODUT.CODPROD                                                                
    AND PCTABPR.NUMREGIAO   = PCREGIAO.NUMREGIAO                                                              
    AND PCTABPR.CODPROD   = 3451.000000              
    AND PCPRODUT.CODFORNEC  = PCFORNEC.CODFORNEC  
    AND PCPRODFILIAL.CODPROD   = EST.CODPROD      
    AND PCPRODFILIAL.CODFILIAL = EST.CODFILIAL    
    AND EST.CODFILIAL     = PCFILIAL.CODIGO       
    AND PCTABPR.CODPROD     = EST.CODPROD                                                                   
    AND DECODE(NVL(PCREGIAO.CODFILIAL,'99'),'99', '2', PCREGIAO.CODFILIAL) = EST.CODFILIAL
   AND  (PCTABTRIB.CODFILIALNF = DECODE(NVL(PCREGIAO.CODFILIAL,'99'),'99',                              
   EST.CODFILIAL,PCREGIAO.CODFILIAL))                                                                       
   AND PCTABTRIB.UFDESTINO   = PCREGIAO.UF                                                                  
   AND PCTABTRIB.CODPROD     = PCTABPR.CODPROD                                                              
   AND PCTABTRIB.CODST       = PCTRIBUT.CODST  
   AND PCTABPR.NUMREGIAO IN(8)                                                     
ORDER BY PCTABPR.NUMREGIAO 