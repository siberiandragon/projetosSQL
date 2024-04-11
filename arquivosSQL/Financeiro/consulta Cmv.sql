
 SELECT PCPEDC.NUMPED, PCPEDC.CODCLI, PCCLIENT.CLIENTE, PCPEDC.PRAZOMEDIO NUMDIAS,
        PCPEDC.CODUSUR,PCUSUARI.NOME AS RCA, PCPEDC.DATA,
(NVL(DECODE(PCPEDC.CONDVENDA,5, 0 ,6, 0, 11, 0, 12, 0 ,PCPEDC.VLATEND  - NVL(PCPEDC.VLFRETE,0)   - NVL((SELECT  SUM(NVL(I.ST,0) * NVL(I.QT,0)) FROM PCPEDI I WHERE I.NUMPED = PCPEDC.NUMPED AND NVL(I.BONIFIC, 'N') = 'N'),0) 
 ),0) ) AS VLATEND,                 
 (NVL(DECODE(PCPEDC.CONDVENDA,5, 0 ,6, 0, 11, 0, 12, 0 ,PCPEDC.VLATEND  - NVL(PCPEDC.VLFRETE,0)  - NVL((SELECT  SUM(NVL(I.ST,0) * NVL(I.QT,0)) FROM PCPEDI I WHERE I.NUMPED = PCPEDC.NUMPED AND NVL(I.BONIFIC, 'N') = 'N'),0) 
),0))  - ((SELECT  SUM(NVL(I.VLCUSTOFIN,0) * NVL(I.QT,0)) FROM PCPEDI I WHERE I.NUMPED = PCPEDC.NUMPED AND I.DATA BETWEEN TO_DATE('03/11/2023','DD/MM/YYYY') AND TO_DATE('03/11/2023','DD/MM/YYYY') )  - NVL((SELECT  SUM(NVL(I.ST,0) * NVL(I.QT,0)) FROM PCPEDI I WHERE I.NUMPED = PCPEDC.NUMPED) ,0) 
) VLLUCRO,      
        DECODE(PCPEDC.CONDVENDA,5,0 ,6,0, 11,0, 12,0 ,PCPEDC.VLTABELA  - NVL(PCPEDC.VLFRETE,0) - NVL(PCPEDC.VLBONIFIC,0)  - NVL((SELECT  SUM(NVL(I.ST,0) * NVL(I.QT,0)) FROM PCPEDI I WHERE I.NUMPED = PCPEDC.NUMPED AND NVL(I.BONIFIC, 'N') = 'N'),0) 
) AS VLTABELA,         
  (DECODE(PCPEDC.CONDVENDA, 5 ,NVL(NVL(PCPEDC.VLBONIFIC,0)  - NVL((SELECT  SUM(NVL(I.ST,0) * NVL(I.QT,0)) FROM PCPEDI I WHERE I.NUMPED = PCPEDC.NUMPED AND NVL(I.BONIFIC, 'N') = 'N'),0) 
,PCPEDC.VLTABELA  - NVL((SELECT  SUM(NVL(I.ST,0) * NVL(I.QT,0)) FROM PCPEDI I WHERE I.NUMPED = PCPEDC.NUMPED AND NVL(I.BONIFIC, 'N') = 'N'),0) 
)                         
                          , 6 ,NVL(PCPEDC.VLBONIFIC  - NVL((SELECT  SUM(NVL(I.ST,0) * NVL(I.QT,0)) FROM PCPEDI I WHERE I.NUMPED = PCPEDC.NUMPED AND NVL(I.BONIFIC, 'N') = 'N'),0) 
,PCPEDC.VLTABELA  - NVL((SELECT  SUM(NVL(I.ST,0) * NVL(I.QT,0)) FROM PCPEDI I WHERE I.NUMPED = PCPEDC.NUMPED AND NVL(I.BONIFIC, 'N') = 'N'),0) 
)                         
                             ,11,NVL(PCPEDC.VLBONIFIC  - NVL((SELECT  SUM(NVL(I.ST,0) * NVL(I.QT,0)) FROM PCPEDI I WHERE I.NUMPED = PCPEDC.NUMPED AND NVL(I.BONIFIC, 'N') = 'N'),0) 
,PCPEDC.VLTABELA  - NVL((SELECT  SUM(NVL(I.ST,0) * NVL(I.QT,0)) FROM PCPEDI I WHERE I.NUMPED = PCPEDC.NUMPED AND NVL(I.BONIFIC, 'N') = 'N'),0) 
)                         
                             ,1,NVL(PCPEDC.VLBONIFIC,0)  - (SELECT  SUM(NVL(I.ST,0) * NVL(I.QT,0)) FROM PCPEDI I WHERE I.NUMPED = PCPEDC.NUMPED AND NVL(I.BONIFIC, 'N') <> 'N')       

                             ,14,NVL(PCPEDC.VLBONIFIC,0)  - (SELECT  SUM(NVL(I.ST,0) * NVL(I.QT,0)) FROM PCPEDI I WHERE I.NUMPED = PCPEDC.NUMPED AND NVL(I.BONIFIC, 'N') <> 'N')       

                             ,12,NVL(PCPEDC.VLBONIFIC  - NVL((SELECT  SUM(NVL(I.ST,0) * NVL(I.QT,0)) FROM PCPEDI I WHERE I.NUMPED = PCPEDC.NUMPED AND NVL(I.BONIFIC, 'N') = 'N'),0) 
,PCPEDC.VLTABELA  - NVL((SELECT  SUM(NVL(I.ST,0) * NVL(I.QT,0)) FROM PCPEDI I WHERE I.NUMPED = PCPEDC.NUMPED AND NVL(I.BONIFIC, 'N') = 'N'),0) 
),0)) VLBONIF,            
 ((SELECT  SUM(NVL(I.VLCUSTOFIN,0) * NVL(I.QT,0)) FROM PCPEDI I WHERE I.NUMPED = PCPEDC.NUMPED AND I.DATA BETWEEN TO_DATE('03/11/2023','DD/MM/YYYY') AND TO_DATE('03/11/2023','DD/MM/YYYY') )  - NVL((SELECT  SUM(NVL(I.ST,0) * NVL(I.QT,0)) FROM PCPEDI I WHERE I.NUMPED = PCPEDC.NUMPED) ,0) 
) VLCUSTOFIN,
        PCPEDC.CODSUPERVISOR,NVL(PCSUPERV.NOME, '* NAO VINCULADO *') AS SUPERVISOR, 
        PCPEDC.CODEMITENTE,
        (SELECT PCEMPR.NOME FROM PCEMPR WHERE PCEMPR.MATRICULA = PCPEDC.CODEMITENTE) EMITENTE,
        PCPEDC.CODCOB,
        (SELECT PCCOB.COBRANCA FROM PCCOB WHERE PCCOB.CODCOB = PCPEDC.CODCOB) COBRANCA,
        PCPEDC.NUMREGIAO,
        (SELECT PCREGIAO.REGIAO FROM PCREGIAO WHERE PCREGIAO.NUMREGIAO = PCPEDC.NUMREGIAO) REGIAO,
        NVL(PCPEDC.NUMCAIXA,0) NUMCAIXA,
        PCPEDC.CODPLPAG,
        PCPLPAG.DESCRICAO PLANOPAGTO
       ,(NVL(PCPEDC.VLOUTRASDESP,0)) VLOUTRASDESP
       ,(NVL(PCPEDC.VLFRETE,0)) VLFRETE
 ,0 VLCMVANTESAPLVERBA
 ,0 VLLUCROANTESAPLVERBA
   FROM PCCLIENT, PCUSUARI, PCSUPERV, PCPLPAG, PCPEDC, PCPRACA
  WHERE PCPEDC.CODPLPAG = PCPLPAG.CODPLPAG
    AND PCPEDC.CODPRACA = PCPRACA.CODPRACA(+)
    AND PCPEDC.POSICAO IN ('L','M','B','P','F','C') 
  AND PCPEDC.CONDVENDA NOT IN (4, 8, 10, 13, 20, 98, 99)
 AND PCPEDC.DTCANCEL IS NULL
 AND PCPEDC.CODCLI= PCCLIENT.CODCLI
 AND PCPEDC.CODUSUR= PCUSUARI.CODUSUR
 AND PCPEDC.CODSUPERVISOR= PCSUPERV.CODSUPERVISOR(+)
  AND PCPEDC.DATA BETWEEN TO_DATE('03/11/2023','DD/MM/YYYY') AND TO_DATE('03/11/2023','DD/MM/YYYY')
 AND PCPEDC.CODFILIAL IN(2,'3','4')
  AND PCPEDC.POSICAO = 'F' 
ORDER BY PCSUPERV.CODSUPERVISOR,PCPEDC.CODUSUR,PCPEDC.VLATEND DESC 