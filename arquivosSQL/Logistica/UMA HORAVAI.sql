SELECT (select P.CODFAB from PCPRODUT P where P.CODPROD = PCMOV.CODPROD) CODFAB
     , PCMOV.CODPROD
     , (SELECT max(QTENTNML) 
        FROM VW_QTENTNML WHERE CODPROD = PCMOV.CODPROD AND CODFILIAL = PCMOV.CODFILIAL AND DTMOV BETWEEN '01/03/2024' AND '31/03/2024' ) QTENTNML
     , (sum(QTSAIDA)-sum(QTSAIDOUTRAS))  QTSAIDNML
     , sum(QTENTOUTRAS) OUTRASENT
     , sum(QTSAIDOUTRAS) OUTRASAID
     , PCMOV.CODPROD
  FROM PCMOV
     , PCEMPR
     , PCCLIENT
     , PCFORNEC
     , PCPRODUT
     , PCMOVCOMPLE
 WHERE 0=0
   AND PCMOV.CODPROD in( '4041')    
   AND PCMOV.CODPROD = PCPRODUT.CODPROD
   AND PCMOV.NUMTRANSITEM = PCMOVCOMPLE.NUMTRANSITEM(+)
   AND NVL(PCMOVCOMPLE.MOVEST, 'S') = 'S' 
   AND PCMOV.CODFORNEC = PCFORNEC.CODFORNEC(+)
   AND PCMOV.CODFUNCLANC = PCEMPR.MATRICULA(+)
   --AND PCMOV.CODUSUR = PCEMPR.MATRICULA(+)
   AND PCMOV.CODCLI = PCCLIENT.CODCLI(+)                                                                                                                           
   AND TRUNC(PCMOV.DTMOV) BETWEEN '01/03/2024' AND '31/03/2024'                                                                                                               
   AND NVL(PCMOV.CODFILIALNF, PCMOV.CODFILIAL) = '4'                                                                                                        
   AND PCMOV.STATUS IN ('B','AB')                                                                                                                              
   AND ( NOT EXISTS                                                                                                                                                
   (SELECT NUMPED 
    FROM PCPEDC 
    WHERE NUMPED = DECODE(PCMOV.CODOPER, 'EP', -1, 'SP',-1, PCMOV.NUMPED) 
    AND CONDVENDA = 7) OR (SUBSTR(PCMOV.CODOPER,1,1) = 'E')) 
    AND NOT EXISTS (SELECT DISTINCT (PCNFSAID.NUMTRANSVENDA)                                                                                                        
                    FROM PCNFSAID, PCPRODUT                                                                                                                                 
                    WHERE PCNFSAID.NUMTRANSVENDA = PCMOV.NUMTRANSVENDA                                                                                                       
                    AND PCNFSAID.CODFILIAL = PCMOV.CODFILIAL                                                                                                               
                    AND PCMOV.CODOPER = 'S'                                                                                                                              
                    AND PCNFSAID.CONDVENDA IN (4, 7, 14)                                                                                                                   
                    AND PCMOV.CODPROD = PCPRODUT.CODPROD                                                                                                                   
                    AND PCPRODUT.TIPOMERC = 'CB')                                                                                                                        
                    AND NOT (PCMOV.CODOPER IN ('EA','SA') AND                                                                                                                   
                    PCMOVCOMPLE.NUMINVENT IS NOT NULL)                                                                                                                     
                    AND NOT (FERRAMENTAS.F_BUSCARPARAMETRO_ALFA('DEVOLVESIMPLESREMTV13TOTAL',PCMOV.CODFILIAL,'N') = 'S' 
                    AND PCMOV.ROTINACAD LIKE '%1332%' AND NVL(PCMOVCOMPLE.QTRETORNOTV13,0) = 0)                                                                                                                                           
                    AND NOT EXISTS (SELECT NUMNOTA FROM PCNFSAID WHERE NUMTRANSVENDA = PCMOV.NUMTRANSVENDA AND SITUACAONFE IN (110,205,301,302,303))                                                                                                                                                            
      
group by CODFAB,
         PCMOV.CODPROD
         
