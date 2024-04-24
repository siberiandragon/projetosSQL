SELECT CODFAB
     , CODPROD
     , (sum(QTENTRADA)-sum(QTENTOUTRAS)) QTENTNML
     , (sum(QTSAIDA)-sum(QTSAIDOUTRAS))  QTSAIDNML
     , sum(QTENTOUTRAS) OUTRASENT
     , sum(QTSAIDOUTRAS) OUTRASAID
     ,(select SDINICIAL FROM (SELECT 
              E2.QTESTGER,                                                      
               SUM(CASE                                                             
                       WHEN (SUBSTR(M2.CODOPER, 1, 1) = 'E') OR (SUBSTR(M2.CODOPER, 1, 1) = 'D') 
                       THEN  CASE                                                          
                                 WHEN DECODE(NVL(C2.QTRETORNOTV13, 0),0, NVL(M2.QT, 0),C2.QTRETORNOTV13) > 0 
                                 THEN DECODE(NVL(C2.QTRETORNOTV13, 0),0, NVL(M2.QT, 0),C2.QTRETORNOTV13)                          
                             END                                                           
                       ELSE                                                           
                             CASE                                                          
                                 WHEN (M2.QT < 0) 
                                 THEN  NVL((M2.QT * (-1)), 0)                                  
                             END                                                           
                   END) QTENTRADA,                                                  
               SUM(CASE                                                             
                     WHEN (SUBSTR(M2.CODOPER, 1, 1) = 'S') OR (SUBSTR(M2.CODOPER, 1, 1) = 'R') 
                     THEN  CASE                                                          
                               WHEN (M2.QT > 0) 
                               THEN  NVL(M2.QT * (-1), 0)                                    
                           END                                                           
                     ELSE                                                           
                         CASE                                                          
                             WHEN (M2.QT < 0) 
                             THEN NVL(M2.QT, 0)                                           
                           END                                                           
                   END) QTSAIDA                                                     
               ,NVL((SELECT QTESTGER                                              
                     FROM PCHISTEST                                               
                    WHERE 0=0
                      AND CODPROD in( '4041')                                         
                      AND CODFILIAL = '4'                                  
                      AND ROWNUM = 1                                              
                      AND TRUNC(DATA) = TO_DATE('01/03/2024', 'DD/MM/YYYY') - 1),                              
                   0) SDINICIAL                                                   
          FROM PCMOV M2,
               PCEST E2,
               PCPRODUT P2,
               PCMOVCOMPLE C2                                  
         WHERE 0=0
           AND M2.CODPROD =  4041                                             
           AND M2.NUMTRANSITEM = C2.NUMTRANSITEM(+)                     
           AND NVL(C2.MOVEST, 'S') = 'S'                               
           AND M2.CODPROD = P2.CODPROD                                     
           AND E2.CODPROD = M2.CODPROD                                        
           AND E2.CODFILIAL = NVL(M2.CODFILIALNF, M2.CODFILIAL)            
           AND TRUNC(M2.DTMOV) BETWEEN '01/03/2024' AND '31/03/2024'                         
           AND NVL(M2.CODFILIALNF, M2.CODFILIAL) = '4'                 
           AND M2.STATUS IN ('B', 'AB')                                      
           AND (NOT EXISTS                                                          
                (SELECT NUMPED                                                      
                   FROM PCPEDC P2                                                      
                  WHERE 0=0
                  and P2.NUMPED = DECODE(M2.CODOPER, 'EP', -1, 'SP', -1, M2.NUMPED) 
                  AND P2.CONDVENDA = 7) OR (SUBSTR(M2.CODOPER, 1, 1) = 'E'))    
                  AND NOT EXISTS                                                           
                                (SELECT DISTINCT (S2.NUMTRANSVENDA)                                  
                                 FROM PCNFSAID S2,
                                      PCPRODUT P3                                           
                                 WHERE 0=0
                                 AND S2.NUMTRANSVENDA = M2.NUMTRANSVENDA                 
                                 AND M2.CODOPER = 'S'                                        
                                 AND S2.CONDVENDA IN (4, 7, 14)                             
                                 AND M2.CODPROD = P3.CODPROD                             
                                 AND P3.TIPOMERC = 'CB')                                  
                                 AND NOT (M2.CODOPER IN ('EA', 'SA') AND                           
                                 C2.NUMINVENT IS NOT NULL)                                  
                                 AND NOT (FERRAMENTAS.F_BUSCARPARAMETRO_ALFA('DEVOLVESIMPLESREMTV13TOTAL',M2.CODFILIAL,'N') = 'S' 
                                 AND M2.ROTINACAD LIKE '%1332%'
                                 AND NVL(C2.QTRETORNOTV13,0) = 0)                                                           
                                 AND NOT EXISTS 
                                               (SELECT NUMNOTA 
                                                FROM PCNFSAID S3
                                                WHERE 0=0
                                                AND S3.NUMTRANSVENDA = M2.NUMTRANSVENDA 
                                                AND S3.SITUACAONFE IN (110,205,301,302,303))                                                       
GROUP BY E2.QTESTGER)) QTINICIAL
       ,(select(NVL(SDINICIAL, 0) + 
         NVL(QTENTRADA, 0) + 
         NVL(QTSAIDA, 0)) SDFINAL   
         FROM (SELECT 
              E3.QTESTGER,                                                      
               SUM(CASE                                                             
                       WHEN (SUBSTR(M3.CODOPER, 1, 1) = 'E') OR (SUBSTR(M3.CODOPER, 1, 1) = 'D') 
                       THEN  CASE                                                          
                                 WHEN DECODE(NVL(C3.QTRETORNOTV13, 0),0, NVL(M3.QT, 0),C3.QTRETORNOTV13) > 0 
                                 THEN DECODE(NVL(C3.QTRETORNOTV13, 0),0, NVL(M3.QT, 0),C3.QTRETORNOTV13)                          
                             END                                                           
                       ELSE                                                           
                             CASE                                                          
                                 WHEN (M3.QT < 0) 
                                 THEN  NVL((M3.QT * (-1)), 0)                                  
                             END                                                           
                   END) QTENTRADA,                                                  
               SUM(CASE                                                             
                     WHEN (SUBSTR(M3.CODOPER, 1, 1) = 'S') OR (SUBSTR(M3.CODOPER, 1, 1) = 'R') 
                     THEN  CASE                                                          
                               WHEN (M3.QT > 0) 
                               THEN  NVL(M3.QT * (-1), 0)                                    
                           END                                                           
                     ELSE                                                           
                         CASE                                                          
                             WHEN (M3.QT < 0) 
                             THEN NVL(M3.QT, 0)                                           
                           END                                                           
                   END) QTSAIDA                                                     
               ,NVL((SELECT QTESTGER                                              
                     FROM PCHISTEST                                               
                    WHERE 0=0
                      AND CODPROD in( '4041')                                  
                      AND CODFILIAL = '4'                                  
                      AND ROWNUM = 1                                              
                      AND TRUNC(DATA) = TO_DATE('01/03/2024', 'DD/MM/YYYY') - 1),                              
                   0) SDINICIAL                                                   
          FROM PCMOV M3,
               PCEST E3,
               PCPRODUT P4,
               PCMOVCOMPLE C3                                  
         WHERE 0=0
           AND M3.CODPROD = 4041                                              
           AND M3.NUMTRANSITEM = C3.NUMTRANSITEM(+)                     
           AND NVL(C3.MOVEST, 'S') = 'S'                               
           AND M3.CODPROD = P4.CODPROD                                     
           AND E3.CODPROD = M3.CODPROD                                        
           AND E3.CODFILIAL = NVL(M3.CODFILIALNF, M3.CODFILIAL)            
           AND TRUNC(M3.DTMOV) BETWEEN '01/03/2024' AND '31/03/2024'                          
           AND NVL(M3.CODFILIALNF, M3.CODFILIAL) = '4'                 
           AND M3.STATUS IN ('B', 'AB')                                      
           AND (NOT EXISTS                                                          
                (SELECT NUMPED                                                      
                   FROM PCPEDC P3                                                     
                  WHERE 0=0
                  and P3.NUMPED = DECODE(M3.CODOPER, 'EP', -1, 'SP', -1, M3.NUMPED) 
                  AND P3.CONDVENDA = 7) OR (SUBSTR(M3.CODOPER, 1, 1) = 'E'))    
                  AND NOT EXISTS                                                           
                                (SELECT DISTINCT (S4.NUMTRANSVENDA)                                  
                                 FROM PCNFSAID S4,
                                      PCPRODUT P5                                          
                                 WHERE 0=0
                                 AND S4.NUMTRANSVENDA = M3.NUMTRANSVENDA                 
                                 AND M3.CODOPER = 'S'                                        
                                 AND S4.CONDVENDA IN (4, 7, 14)                             
                                 AND M3.CODPROD = P5.CODPROD                             
                                 AND P5.TIPOMERC = 'CB')                                  
                                 AND NOT (M3.CODOPER IN ('EA', 'SA') AND                           
                                 C3.NUMINVENT IS NOT NULL)                                  
                                 AND NOT (FERRAMENTAS.F_BUSCARPARAMETRO_ALFA('DEVOLVESIMPLESREMTV13TOTAL',M3.CODFILIAL,'N') = 'S' 
                                 AND M3.ROTINACAD LIKE '%1332%'
                                 AND NVL(C3.QTRETORNOTV13,0) = 0)                                                           
                                 AND NOT EXISTS 
                                               (SELECT NUMNOTA 
                                                FROM PCNFSAID S5 
                                                WHERE 0=0
                                                AND S5.NUMTRANSVENDA = M3.NUMTRANSVENDA 
                                                AND S5.SITUACAONFE IN (110,205,301,302,303))                                                       
GROUP BY E3.QTESTGER)) QTFINAL
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
            END QTSAIDOUTRAS
     , PCMOV.CODPROD
  FROM PCMOV
     , PCEMPR
     , PCCLIENT
     , PCFORNEC
     , PCPRODUT
     , PCMOVCOMPLE
 WHERE 0=0
   AND PCMOV.CODPROD =('4041')    
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
         CODPROD;
         
--- ta indo


select * from 
     (SELECT CODFAB
     , CODPROD
     , (sum(QTENTRADA)-sum(QTENTOUTRAS)) QTENTNML
     , (sum(QTSAIDA)-sum(QTSAIDOUTRAS))  QTSAIDNML
     , sum(QTENTOUTRAS) OUTRASENT
     , sum(QTSAIDOUTRAS) OUTRASAID
     , QTINICIAL
     , QTFINAL
       FROM (SELECT 
                    (select P.CODFAB from PCPRODUT P where P.CODPROD = M6.CODPROD) CODFAB                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
     ,      CASE 
            WHEN (SUBSTR(M6.CODOPER,1,1) = 'E') OR (SUBSTR(M6.CODOPER,1,1) = 'D') 
            THEN CASE 
                      WHEN (DECODE(NVL(C6.QTRETORNOTV13, 0), 0, NVL(M6.QT, 0), C6.QTRETORNOTV13) > 0) 
                      THEN  DECODE(NVL(C6.QTRETORNOTV13, 0), 0, NVL(M6.QT, 0), C6.QTRETORNOTV13)                                                                                                                              
         END
       ELSE
            CASE 
                WHEN (DECODE(NVL(C6.QTRETORNOTV13, 0), 0, NVL(M6.QT, 0), C6.QTRETORNOTV13) < 0) 
                THEN NVL((DECODE(NVL(C6.QTRETORNOTV13, 0), 0, NVL(M6.QT, 0), C6.QTRETORNOTV13)*(-1)),0)
         END
       END QTENTRADA
     , CASE WHEN (SUBSTR(M6.CODOPER,1,1) = 'S') OR (SUBSTR(M6.CODOPER,1,1) = 'R') 
            THEN CASE 
                     WHEN (M6.QT > 0)
                     THEN NVL(M6.QT*(-1),0)
            END
            ELSE
            CASE 
                 WHEN (M6.QT < 0) 
                 THEN NVL(M6.QT,0)
            END
            END QTSAIDA,
        CASE 
            WHEN M6.CODOPER = 'EI'
            THEN CASE 
                      WHEN (DECODE(NVL(C6.QTRETORNOTV13, 0), 0, NVL(M6.QT, 0), C6.QTRETORNOTV13) > 0) 
                      THEN  DECODE(NVL(C6.QTRETORNOTV13, 0), 0, NVL(M6.QT, 0), C6.QTRETORNOTV13)                                                                                                                              
         END
       ELSE
            CASE 
                WHEN (DECODE(NVL(C6.QTRETORNOTV13, 0), 0, NVL(M6.QT, 0), C6.QTRETORNOTV13) < 0) 
                THEN NVL((DECODE(NVL(C6.QTRETORNOTV13, 0), 0, NVL(M6.QT, 0), C6.QTRETORNOTV13)*(-1)),0)
         END
       END QTENTOUTRAS,
        CASE
            WHEN M6.CODOPER = 'SI'
            THEN CASE 
                     WHEN (M6.QT > 0)
                     THEN NVL(M6.QT*(-1),0)
            END
            ELSE
            CASE 
                 WHEN (M6.QT < 0) 
                 THEN NVL(M6.QT,0)
            END
            END QTSAIDOUTRAS
     , M6.CODPROD
          ,(select SDINICIAL FROM (SELECT 
              E2.QTESTGER,                                                      
               SUM(CASE                                                             
                       WHEN (SUBSTR(M2.CODOPER, 1, 1) = 'E') OR (SUBSTR(M2.CODOPER, 1, 1) = 'D') 
                       THEN  CASE                                                          
                                 WHEN DECODE(NVL(C2.QTRETORNOTV13, 0),0, NVL(M2.QT, 0),C2.QTRETORNOTV13) > 0 
                                 THEN DECODE(NVL(C2.QTRETORNOTV13, 0),0, NVL(M2.QT, 0),C2.QTRETORNOTV13)                          
                             END                                                           
                       ELSE                                                           
                             CASE                                                          
                                 WHEN (M2.QT < 0) 
                                 THEN  NVL((M2.QT * (-1)), 0)                                  
                             END                                                           
                   END) QTENTRADA,                                                  
               SUM(CASE                                                             
                     WHEN (SUBSTR(M2.CODOPER, 1, 1) = 'S') OR (SUBSTR(M2.CODOPER, 1, 1) = 'R') 
                     THEN  CASE                                                          
                               WHEN (M2.QT > 0) 
                               THEN  NVL(M2.QT * (-1), 0)                                    
                           END                                                           
                     ELSE                                                           
                         CASE                                                          
                             WHEN (M2.QT < 0) 
                             THEN NVL(M2.QT, 0)                                           
                           END                                                           
                   END) QTSAIDA                                                     
               ,NVL((SELECT QTESTGER                                              
                     FROM PCHISTEST                                               
                    WHERE 0=0
                      AND CODPROD = M6.CODPROD                                         
                      AND CODFILIAL = '4'                                  
                      AND ROWNUM = 1                                              
                      AND TRUNC(DATA) = TO_DATE('01/03/2024', 'DD/MM/YYYY') - 1),                              
                   0) SDINICIAL                                                   
          FROM PCMOV M2,
               PCEST E2,
               PCPRODUT P2,
               PCMOVCOMPLE C2                                  
         WHERE 0=0
           AND M2.CODPROD =  M6.CODPROD                                              
           AND M2.NUMTRANSITEM = C2.NUMTRANSITEM(+)                     
           AND NVL(C2.MOVEST, 'S') = 'S'                               
           AND M2.CODPROD = P2.CODPROD                                     
           AND E2.CODPROD = M2.CODPROD                                        
           AND E2.CODFILIAL = NVL(M2.CODFILIALNF, M2.CODFILIAL)            
           AND TRUNC(M2.DTMOV) BETWEEN '01/03/2024' AND '31/03/2024'                         
           AND NVL(M2.CODFILIALNF, M2.CODFILIAL) = '4'                 
           AND M2.STATUS IN ('B', 'AB')                                      
           AND (NOT EXISTS                                                          
                (SELECT NUMPED                                                      
                   FROM PCPEDC P2                                                      
                  WHERE 0=0
                  and P2.NUMPED = DECODE(M2.CODOPER, 'EP', -1, 'SP', -1, M2.NUMPED) 
                  AND P2.CONDVENDA = 7) OR (SUBSTR(M2.CODOPER, 1, 1) = 'E'))    
                  AND NOT EXISTS                                                           
                                (SELECT DISTINCT (S2.NUMTRANSVENDA)                                  
                                 FROM PCNFSAID S2,
                                      PCPRODUT P3                                           
                                 WHERE 0=0
                                 AND S2.NUMTRANSVENDA = M2.NUMTRANSVENDA                 
                                 AND M2.CODOPER = 'S'                                        
                                 AND S2.CONDVENDA IN (4, 7, 14)                             
                                 AND M2.CODPROD = P3.CODPROD                             
                                 AND P3.TIPOMERC = 'CB')                                  
                                 AND NOT (M2.CODOPER IN ('EA', 'SA') AND                           
                                 C2.NUMINVENT IS NOT NULL)                                  
                                 AND NOT (FERRAMENTAS.F_BUSCARPARAMETRO_ALFA('DEVOLVESIMPLESREMTV13TOTAL',M2.CODFILIAL,'N') = 'S' 
                                 AND M2.ROTINACAD LIKE '%1332%'
                                 AND NVL(C2.QTRETORNOTV13,0) = 0)                                                           
                                 AND NOT EXISTS 
                                               (SELECT NUMNOTA 
                                                FROM PCNFSAID S3
                                                WHERE 0=0
                                                AND S3.NUMTRANSVENDA = M2.NUMTRANSVENDA 
                                                AND S3.SITUACAONFE IN (110,205,301,302,303))                                                       
GROUP BY E2.QTESTGER)) QTINICIAL
       ,(select(NVL(SDINICIAL, 0) + 
         NVL(QTENTRADA, 0) + 
         NVL(QTSAIDA, 0)) SDFINAL   
         FROM (SELECT 
              E3.QTESTGER,                                                      
               SUM(CASE                                                             
                       WHEN (SUBSTR(M3.CODOPER, 1, 1) = 'E') OR (SUBSTR(M3.CODOPER, 1, 1) = 'D') 
                       THEN  CASE                                                          
                                 WHEN DECODE(NVL(C3.QTRETORNOTV13, 0),0, NVL(M3.QT, 0),C3.QTRETORNOTV13) > 0 
                                 THEN DECODE(NVL(C3.QTRETORNOTV13, 0),0, NVL(M3.QT, 0),C3.QTRETORNOTV13)                          
                             END                                                           
                       ELSE                                                           
                             CASE                                                          
                                 WHEN (M3.QT < 0) 
                                 THEN  NVL((M3.QT * (-1)), 0)                                  
                             END                                                           
                   END) QTENTRADA,                                                  
               SUM(CASE                                                             
                     WHEN (SUBSTR(M3.CODOPER, 1, 1) = 'S') OR (SUBSTR(M3.CODOPER, 1, 1) = 'R') 
                     THEN  CASE                                                          
                               WHEN (M3.QT > 0) 
                               THEN  NVL(M3.QT * (-1), 0)                                    
                           END                                                           
                     ELSE                                                           
                         CASE                                                          
                             WHEN (M3.QT < 0) 
                             THEN NVL(M3.QT, 0)                                           
                           END                                                           
                   END) QTSAIDA                                                     
               ,NVL((SELECT QTESTGER                                              
                     FROM PCHISTEST                                               
                    WHERE 0=0
                      AND CODPROD = M6.CODPROD                                  
                      AND CODFILIAL = '4'                                  
                      AND ROWNUM = 1                                              
                      AND TRUNC(DATA) = TO_DATE('01/03/2024', 'DD/MM/YYYY') - 1),                              
                   0) SDINICIAL                                                   
          FROM PCMOV M3,
               PCEST E3,
               PCPRODUT P4,
               PCMOVCOMPLE C3                                  
         WHERE 0=0
           AND M3.CODPROD = M6.CODPROD                                              
           AND M3.NUMTRANSITEM = C3.NUMTRANSITEM(+)                     
           AND NVL(C3.MOVEST, 'S') = 'S'                               
           AND M3.CODPROD = P4.CODPROD                                     
           AND E3.CODPROD = M3.CODPROD                                        
           AND E3.CODFILIAL = NVL(M3.CODFILIALNF, M3.CODFILIAL)            
           AND TRUNC(M3.DTMOV) BETWEEN '01/03/2024' AND '31/03/2024'                          
           AND NVL(M3.CODFILIALNF, M3.CODFILIAL) = '4'                 
           AND M3.STATUS IN ('B', 'AB')                                      
           AND (NOT EXISTS                                                          
                (SELECT NUMPED                                                      
                   FROM PCPEDC P3                                                     
                  WHERE 0=0
                  and P3.NUMPED = DECODE(M3.CODOPER, 'EP', -1, 'SP', -1, M3.NUMPED) 
                  AND P3.CONDVENDA = 7) OR (SUBSTR(M3.CODOPER, 1, 1) = 'E'))    
                  AND NOT EXISTS                                                           
                                (SELECT DISTINCT (S4.NUMTRANSVENDA)                                  
                                 FROM PCNFSAID S4,
                                      PCPRODUT P5                                          
                                 WHERE 0=0
                                 AND S4.NUMTRANSVENDA = M3.NUMTRANSVENDA                 
                                 AND M3.CODOPER = 'S'                                        
                                 AND S4.CONDVENDA IN (4, 7, 14)                             
                                 AND M3.CODPROD = P5.CODPROD                             
                                 AND P5.TIPOMERC = 'CB')                                  
                                 AND NOT (M3.CODOPER IN ('EA', 'SA') AND                           
                                 C3.NUMINVENT IS NOT NULL)                                  
                                 AND NOT (FERRAMENTAS.F_BUSCARPARAMETRO_ALFA('DEVOLVESIMPLESREMTV13TOTAL',M3.CODFILIAL,'N') = 'S' 
                                 AND M3.ROTINACAD LIKE '%1332%'
                                 AND NVL(C3.QTRETORNOTV13,0) = 0)                                                           
                                 AND NOT EXISTS 
                                               (SELECT NUMNOTA 
                                                FROM PCNFSAID S5 
                                                WHERE 0=0
                                                AND S5.NUMTRANSVENDA = M3.NUMTRANSVENDA 
                                                AND S5.SITUACAONFE IN (110,205,301,302,303))                                                       
GROUP BY E3.QTESTGER)) QTFINAL
  FROM PCMOV M6
     , PCEMPR E6
     , PCCLIENT I2
     , PCFORNEC F2
     , PCPRODUT P6
     , PCMOVCOMPLE C6 
 WHERE 0=0
   AND M6.CODPROD =('4047')    
   AND M6.CODPROD = P6.CODPROD
   AND M6.NUMTRANSITEM = C6.NUMTRANSITEM(+)
   AND NVL(C6.MOVEST, 'S') = 'S' 
   AND M6.CODFORNEC = F2.CODFORNEC(+)
   AND M6.CODFUNCLANC = E6.MATRICULA(+)
   --AND M6.CODUSUR = E6.MATRICULA(+)
   AND M6.CODCLI = I2.CODCLI(+)                                                                                                                           
   AND TRUNC(M6.DTMOV) BETWEEN '01/03/2024' AND '31/03/2024'                                                                                                               
   AND NVL(M6.CODFILIALNF, M6.CODFILIAL) = '4'                                                                                                        
   AND M6.STATUS IN ('B','AB')                                                                                                                              
   AND ( NOT EXISTS                                                                                                                                                
   (SELECT P4.NUMPED 
    FROM PCPEDC P4
    WHERE P4.NUMPED = DECODE(M6.CODOPER, 'EP', -1, 'SP',-1, M6.NUMPED) 
    AND P4.CONDVENDA = 7) OR (SUBSTR(M6.CODOPER,1,1) = 'E')) 
    AND NOT EXISTS (SELECT DISTINCT (S6.NUMTRANSVENDA)                                                                                                        
                    FROM PCNFSAID S6,
                         PCPRODUT P7                                                                                                                                 
                    WHERE S6.NUMTRANSVENDA = M6.NUMTRANSVENDA                                                                                                       
                    AND S6.CODFILIAL = M6.CODFILIAL                                                                                                               
                    AND M6.CODOPER = 'S'                                                                                                                              
                    AND S6.CONDVENDA IN (4, 7, 14)                                                                                                                   
                    AND M6.CODPROD = P7.CODPROD                                                                                                                   
                    AND P7.TIPOMERC = 'CB')                                                                                                                        
                    AND NOT (M6.CODOPER IN ('EA','SA') AND                                                                                                                   
                    C6.NUMINVENT IS NOT NULL)                                                                                                                     
                    AND NOT (FERRAMENTAS.F_BUSCARPARAMETRO_ALFA('DEVOLVESIMPLESREMTV13TOTAL',M6.CODFILIAL,'N') = 'S' 
                    AND M6.ROTINACAD LIKE '%1332%' AND NVL(C6.QTRETORNOTV13,0) = 0)                                                                                                                                           
                    AND NOT EXISTS (SELECT S7.NUMNOTA FROM PCNFSAID S7 WHERE S7.NUMTRANSVENDA = M6.NUMTRANSVENDA AND S7.SITUACAONFE IN (110,205,301,302,303))                                                                                                                                                            
     )
       
group by CODFAB,
         CODPROD,
         QTINICIAL,
         QTFINAL                                                                                                                                      
         )
  
