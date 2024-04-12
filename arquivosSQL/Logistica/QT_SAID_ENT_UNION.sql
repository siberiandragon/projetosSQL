SELECT CODFAB
     , CODPROD
     , (sum(QTENTRADA)-sum(QTENTOUTRAS)) QTENTNML
     , (sum(QTSAIDA)-sum(QTSAIDOUTRAS))  QTSAIDNML
     , sum(QTENTOUTRAS) OUTRASENT
     , sum(QTSAIDOUTRAS) OUTRASAID
     , 0 SDINICIAL
     ,0 SDFINAL
FROM (SELECT 
       (select P.CODFAB from PCPRODUT P where P.CODPROD = PCMOV.CODPROD) CODFAB                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
     , CASE 
            WHEN (SUBSTR(PCMOV.CODOPER,1,1) = 'E') OR (SUBSTR(PCMOV.CODOPER,1,1) = 'D') 
            THEN CASE 
                      WHEN (DECODE(NVL(PCMOVCOMPLE.QTRETORNOTV13, 0), 0, NVL(PCMOV.QT, 0), PCMOVCOMPLE.QTRETORNOTV13) > 0) 
                      THEN  DECODE(NVL(PCMOVCOMPLE.QTRETORNOTV13, 0), 0, NVL(PCMOV.QT, 0), PCMOVCOMPLE.QTRETORNOTV13)                                                                                                                              
         END
       ELSE
            CASE 
                WHEN (DECODE(NVL(PCMOVCOMPLE.QTRETORNOTV13, 0), 0, NVL(PCMOV.QT, 0), PCMOVCOMPLE.QTRETORNOTV13) < 0) 
                THEN NVL((DECODE(NVL(PCMOVCOMPLE.QTRETORNOTV13, 0), 0, NVL(PCMOV.QT, 0), PCMOVCOMPLE.QTRETORNOTV13)*(-1)),0)
         END
       END QTENTRADA
     , CASE WHEN (SUBSTR(PCMOV.CODOPER,1,1) = 'S') OR (SUBSTR(PCMOV.CODOPER,1,1) = 'R') 
            THEN CASE 
                     WHEN (PCMOV.QT > 0)
                     THEN NVL(PCMOV.QT*(-1),0)
            END
            ELSE
            CASE 
                 WHEN (PCMOV.QT < 0) 
                 THEN NVL(PCMOV.QT,0)
            END
            END QTSAIDA,
        CASE 
            WHEN PCMOV.CODOPER = 'EI'
            THEN CASE 
                      WHEN (DECODE(NVL(PCMOVCOMPLE.QTRETORNOTV13, 0), 0, NVL(PCMOV.QT, 0), PCMOVCOMPLE.QTRETORNOTV13) > 0) 
                      THEN  DECODE(NVL(PCMOVCOMPLE.QTRETORNOTV13, 0), 0, NVL(PCMOV.QT, 0), PCMOVCOMPLE.QTRETORNOTV13)                                                                                                                              
         END
       ELSE
            CASE 
                WHEN (DECODE(NVL(PCMOVCOMPLE.QTRETORNOTV13, 0), 0, NVL(PCMOV.QT, 0), PCMOVCOMPLE.QTRETORNOTV13) < 0) 
                THEN NVL((DECODE(NVL(PCMOVCOMPLE.QTRETORNOTV13, 0), 0, NVL(PCMOV.QT, 0), PCMOVCOMPLE.QTRETORNOTV13)*(-1)),0)
         END
       END QTENTOUTRAS,
        CASE
            WHEN PCMOV.CODOPER = 'SI'
            THEN CASE 
                     WHEN (PCMOV.QT > 0)
                     THEN NVL(PCMOV.QT*(-1),0)
            END
            ELSE
            CASE 
                 WHEN (PCMOV.QT < 0) 
                 THEN NVL(PCMOV.QT,0)
            END
            END QTSAIDOUTRAS,
            0 SDINICIAL,
            0 SDFINAL
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
     ) 
group by CODFAB,
         CODPROD
         
 

 union

SELECT 
        CODFAB,
        CODPROD,
        0 QTENTNML,
        0 QTSAIDNML,
        0 OUTRASENT,
        0 OUTRASAID,
        SDINICIAL1,
        SDFINAL1
   FROM (     
SELECT  CODFAB,
        CODPROD,
        0 QTENTNML,
        0 QTSAIDNML,
        0 OUTRASENT,
        0 OUTRASAID,
        0 QTINICIAL,
        0 QTFINAL,                                                                                                                                       
        SDINICIAL1,                                                                   
       (NVL(SDINICIAL1, 0) + 
        NVL(QTENTRADA, 0) + 
        NVL(QTSAIDA, 0)) SDFINAL1                                    
 FROM (SELECT 
              PCEST.QTESTGER,                                                      
               SUM(CASE                                                             
                       WHEN (SUBSTR(PCMOV.CODOPER, 1, 1) = 'E') OR (SUBSTR(PCMOV.CODOPER, 1, 1) = 'D') 
                       THEN  CASE                                                          
                                 WHEN DECODE(NVL(PCMOVCOMPLE.QTRETORNOTV13, 0),0, NVL(PCMOV.QT, 0),PCMOVCOMPLE.QTRETORNOTV13) > 0 
                                 THEN DECODE(NVL(PCMOVCOMPLE.QTRETORNOTV13, 0),0, NVL(PCMOV.QT, 0),PCMOVCOMPLE.QTRETORNOTV13)                          
                             END                                                           
                       ELSE                                                           
                             CASE                                                          
                                 WHEN (PCMOV.QT < 0) 
                                 THEN  NVL((PCMOV.QT * (-1)), 0)                                  
                             END                                                           
                   END) QTENTRADA,                                                  
               SUM(CASE                                                             
                     WHEN (SUBSTR(PCMOV.CODOPER, 1, 1) = 'S') OR (SUBSTR(PCMOV.CODOPER, 1, 1) = 'R') 
                     THEN  CASE                                                          
                               WHEN (PCMOV.QT > 0) 
                               THEN  NVL(PCMOV.QT * (-1), 0)                                    
                           END                                                           
                     ELSE                                                           
                         CASE                                                          
                             WHEN (PCMOV.QT < 0) 
                             THEN NVL(PCMOV.QT, 0)                                           
                           END                                                           
                   END) QTSAIDA                                                     
               ,NVL((SELECT QTESTGER                                              
                     FROM PCHISTEST                                               
                    WHERE CODPROD in('4041')                                     
                      AND CODFILIAL = '4'                                  
                      AND ROWNUM = 1                                              
                      AND TRUNC(DATA) = '29/02/2024'),                              
                   0) SDINICIAL1,
                   PCMOV.CODPROD AS CODPROD,
                   PCPRODUT.CODFAB AS CODFAB                                                   
          FROM PCMOV,
               PCEST,
               PCPRODUT,
               PCMOVCOMPLE                                  
         WHERE PCMOV.CODPROD in ('4041')                                            
           AND PCMOV.NUMTRANSITEM = PCMOVCOMPLE.NUMTRANSITEM(+)                     
           AND NVL(PCMOVCOMPLE.MOVEST, 'S') = 'S'                               
           AND PCMOV.CODPROD = PCPRODUT.CODPROD                                     
           AND PCEST.CODPROD = PCMOV.CODPROD                                        
           AND PCEST.CODFILIAL = NVL(PCMOV.CODFILIALNF, PCMOV.CODFILIAL)            
           AND TRUNC(PCMOV.DTMOV) BETWEEN '01/03/2024' AND '31/03/2024'                        
           AND NVL(PCMOV.CODFILIALNF, PCMOV.CODFILIAL) = '4'                 
           AND PCMOV.STATUS IN ('B', 'AB')                                      
           AND (NOT EXISTS                                                          
                (SELECT NUMPED                                                      
                   FROM PCPEDC                                                      
                  WHERE 0=0
                  and NUMPED = DECODE(PCMOV.CODOPER, 'EP', -1, 'SP', -1, PCMOV.NUMPED) 
                  AND CONDVENDA = 7) OR (SUBSTR(PCMOV.CODOPER, 1, 1) = 'E'))    
                  AND NOT EXISTS                                                           
                                (SELECT DISTINCT (PCNFSAID.NUMTRANSVENDA)                                  
                                 FROM PCNFSAID, PCPRODUT                                           
                                 WHERE 0=0
                                 AND PCNFSAID.NUMTRANSVENDA = PCMOV.NUMTRANSVENDA                 
                                 AND PCMOV.CODOPER = 'S'                                        
                                 AND PCNFSAID.CONDVENDA IN (4, 7, 14)                             
                                 AND PCMOV.CODPROD = PCPRODUT.CODPROD                             
                                 AND PCPRODUT.TIPOMERC = 'CB')                                  
                                 AND NOT (PCMOV.CODOPER IN ('EA', 'SA') AND                           
                                 PCMOVCOMPLE.NUMINVENT IS NOT NULL)                                  
                                 AND NOT (FERRAMENTAS.F_BUSCARPARAMETRO_ALFA('DEVOLVESIMPLESREMTV13TOTAL',PCMOV.CODFILIAL,'N') = 'S' 
                                 AND PCMOV.ROTINACAD LIKE '%1332%'
                                 AND NVL(PCMOVCOMPLE.QTRETORNOTV13,0) = 0)                                                           
                                 AND NOT EXISTS 
                                               (SELECT NUMNOTA 
                                                FROM PCNFSAID 
                                                WHERE 0=0
                                                AND NUMTRANSVENDA = PCMOV.NUMTRANSVENDA 
                                                AND SITUACAONFE IN (110,205,301,302,303))                                                       
GROUP BY PCEST.QTESTGER,
         PCPRODUT.CODFAB,
         PCMOV.CODPROD) )
