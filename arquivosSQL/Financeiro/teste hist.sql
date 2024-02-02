WITH FILIAISREGRA AS(   SELECT F1.CODFILIAL 
        FROM PCCONFFILIAL F1,               
             PCREGRAFILIAL R1               
      WHERE                                 
            R1.CODFILIAL = F1.CODFILIAL     
      AND   R1.CODREGRA = :CODREGRA         
      AND   DECODE(:CONSOLIDAR, 'S', TO_CHAR(F1.CODGRUPOFILIAL), F1.CODFILIAL) IN ( '2','3','4'  )
      AND   F1.ANO = EXTRACT(YEAR FROM TO_DATE(:DATA2))) 

  --PAGAMENTOS / OUTROS RECEBIMENTOS--

 SELECT --SELECIONAR
        L.CODFILIAL                                      AS CODFILIAL,
        L.DTPAGTO                                        AS DATAOPERACAO, --HISTORICO --DOCUMENTO
        R.DTCOMPENSACAO                                  AS DATAOPERACAO1, --HISTORICO --DOCUMENTO
        L.DTESTORNOBAIXA                                 AS DATAOPERACAO2, --HISTORICO --DOCUMENTO
        L.CODFORNEC                                      AS CODFORNEC, --HISTORICO --FILTRO
        DECODE(L.TIPOPARCEIRO,
               'F', F.FORNECEDOR,
               'R', (SELECT TO_CHAR(U.NOME) FROM PCUSUARI U WHERE U.CODUSUR = L.CODFORNEC AND ROWNUM = 1),
               'M', (SELECT TO_CHAR(E.NOME) FROM PCEMPR E WHERE E.MATRICULA = L.CODFORNEC AND ROWNUM = 1),
               'L', (SELECT TO_CHAR(E.NOME) FROM PCEMPR E WHERE E.MATRICULA = L.CODFORNEC AND ROWNUM = 1),
               'C', (SELECT CL.CLIENTE FROM PCCLIENT CL WHERE CL.CODCLI = L.CODFORNEC AND ROWNUM = 1)) AS FORNECEDOR, --HISTORICO
        L.HISTORICO                                      AS HISTORICO, --HISTORICO
        L.HISTORICO2                                     AS HISTORICO2, --HISTORICO
        R.HISTORICO                                      AS HISTORICOMOVBANCO, --HISTORICO
        R.HISTORICO2                                      AS HISTORICOMOVBANCO2, --HISTORICO
        VW_CONTABHIST.HISTORICO                                      AS HISTPERSO, 
        L.RECNUM                                         AS NUMLANCTO, --HISTORICO --DOCUMENTO
        L.NUMNOTA                                        AS NUMNOTA, --HISTORICO --DOCUMENTO
        L.DUPLIC                                         AS DUPLICATA, --HISTORICO
        NVL(L.VALOR, 0)                                  AS VALORTITULO,
        DECODE(NVL(L.VPAGOBORDERO, 0), 0, L.VPAGO, NVL(L.VPAGOBORDERO, L.VPAGO)) AS VALORPAGO,
        NVL(L.DESCONTOFIN, 0) - NVL(L.VLRDESCVERBA, 0) - NVL(L.VLRDESCVERBAMANUAL,0)  AS VALORDESCONTO,
        NVL(L.VLRDESCVERBA, 0)                           AS VALORDESCVERBA,
        L.TXPERM                                         AS VALORJUROS,
        L.NUMNOTADEV                                     AS NUMNOTADEVOLUCAO, --HISTORICO
        L.NUMBANCO                                       AS NUMBANCO, --HISTORICO
        R.CODBANCO                                       AS CODBANCO, --HISTORICO --FILTRO
        R.CODCOB                                         AS CODMOEDA,
        B.NOME                                           AS NOMEBANCOPGTO, --HISTORICO
        L.TIPOPAGTO                                      AS TIPODEPAGAMENTO, --FILTRO --HISTORICO
        L.CODROTINABAIXA                                 AS CODROTINA, --FILTRO
        L.CODCONTA                                       AS CODCONTA, --FILTRO
        L.MOEDA                                          AS MOEDA, --FILTRO
        L.VLIRRF                                         AS VALORIRRF,
        L.VLSESTSENAT                                    AS VALORSESTSENAT,
        NVL(L.NUMTRANS, L.RECNUM)                        AS NUMTRANSOPERACAO, --DOCUMENTO --HISTORICO
        L.TIPOPARCEIRO                                   AS TIPOPARCEIRO, --FILTRO
        L.INDICE                                         AS STATUS,        --FILTRO --HISTORICO
        DECODE(L.NUMTRANSADIANTFOR,NULL,  NVL(R.TIPO, 'X'), 'C' ) AS TIPOLANCAMENTO, --FILTRO
        L.CONTA                                          AS NOMECONTAGERENCIAL, --HISTORICO
        CASE
          WHEN (L.GERAPROVLANCCONTAB = 'N') AND (NVL(:GERAPROVLANCCONTAB,'N') = 'S') THEN 
                   TO_CHAR(L.CONTACONTABIL)   
          WHEN ((L.TIPOPARCEIRO NOT IN ('R', 'C', 'F', 'O', 'M', 'L')) OR
               ((NVL(L.ADIANTAMENTO, 0) = 'S') OR (L.DTPAGADIANTFOR IS NOT NULL) OR
               (L.NUMTRANSADIANTFOR IS NOT NULL))) THEN
            CASE
              WHEN (F.CODCONTACONTABADIANTFOR) IS NOT NULL THEN
                TO_CHAR(F.CODCONTACONTABADIANTFOR)
              WHEN (F.REVENDA IN ('T','X','S')) THEN
                TO_CHAR((SELECT L.CONTACONTABIL
                         FROM PCCONSUM CS
                         WHERE CS.CODCONTAADIANTFOR = L.CODCONTA))
              WHEN (NVL(F.REVENDA,'A') NOT IN ('T','X','S')) THEN
                TO_CHAR((SELECT L.CONTACONTABIL
                        FROM PCCONSUM CS1
                        WHERE CS1.CODCONTAADIANTFOROUTROS = L.CODCONTA))
              ELSE
                TO_CHAR(L.CONTACONTABIL)
            END
          ELSE
            TO_CHAR(L.CONTACONTABIL)
        END AS CODCONTARECEITA, --CONTA
        CASE
          WHEN (L.NUMCHEQUE IS NULL OR SUBSTR(L.NUMCHEQUE, 1, 1) =' ') AND (L.NUMBORDERO IS NOT NULL) THEN 
             'BORD ' ||L.NUMBORDERO
          WHEN (L.NUMBORDERO IS NULL OR SUBSTR(L.NUMBORDERO, 1, 1) = ' ') AND (L.NUMCHEQUE IS NOT NULL) THEN 
             'CH ' ||L.NUMCHEQUE
          ELSE
            CASE
              WHEN NVL(L.NUMNOTA, 0) = 0 THEN
                'LANCTO '|| L.RECNUM
              ELSE
                'NF '|| L.NUMNOTA
            END
        END                                   AS NUMDOCTO, --DOCUMENTO --HISTORICO
        (CASE
          WHEN (L.GERAPROVLANCCONTAB = 'N') AND (NVL(:GERAPROVLANCCONTAB,'N') = 'S') THEN 
             TO_CHAR(L.CONTACONTABIL) 
          WHEN (NVL(L.ADIANTAMENTO, 'N') = 'S') THEN 
            DECODE(NVL(F.CODCONTACONTABADIANTFOR, 0), 0, TO_CHAR(L.CONTACONTABIL), TO_CHAR(F.CODCONTACONTABADIANTFOR)) 
          WHEN ((L.TIPOPARCEIRO NOT IN ('R', 'C', 'F')) AND (NVL(L.ADIANTAMENTO, 'N') = 'N')) THEN 
            TO_CHAR(L.CONTACONTABIL) 
          WHEN (L.NFSERVICO = 'S' AND L.RECNUMPRINC <> L.RECNUM) AND (IMPOSTO = 'S') THEN 
            TO_CHAR(L.CONTACONTABIL)
          WHEN (L.TIPOPARCEIRO = 'R') THEN
            NVL(NVL((SELECT M1.CODREDUZIDO_PC 
                     FROM PCMODELOPC M1 
                    WHERE M1.CODPLANOCONTA = :CODPLANOCONTA 
                      AND M1.CODRCA = L.CODFORNEC 
                      AND ROWNUM = 1), TO_CHAR((SELECT UR.CODCONTAB 
                                                  FROM PCUSUARI UR 
                                                 WHERE UR.CODUSUR = L.CODFORNEC 
                                                   AND ROWNUM = 1))), L.CONTACONTABIL) 
          WHEN (L.TIPOPARCEIRO = 'C') THEN
            NVL(NVL((SELECT M1.CODREDUZIDO_PC 
                     FROM PCMODELOPC M1 
                    WHERE M1.CODPLANOCONTA = :CODPLANOCONTA 
                      AND M1.CODCLI = L.CODFORNEC 
                      AND ROWNUM = 1), TO_CHAR((SELECT CL.CODCONTAB 
                                                  FROM PCCLIENT CL 
                                                 WHERE CL.CODCLI = L.CODFORNEC 
                                                   AND ROWNUM = 1))), L.CONTACONTABIL) 
          ELSE
           NVL((SELECT M1.CODREDUZIDO_PC     
           FROM PCMODELOPC M1                 
           WHERE M1.CODPLANOCONTA = :CODPLANOCONTA   
           AND M1.CODFORNEC = F.CODFORNEC       
           AND ROWNUM = 1), NVL(TO_CHAR(M.CODREDUZIDO_PC), TO_CHAR(TRIM(F.CODCONTAB))))  
        END) AS CODCONTADESPFORNEC, --CONTA
        BM.CODCONTACONTABIL AS CONTACONTABILBANCO, --CONTA 

     (SELECT STATUS                                                     
        FROM PCLANCINTERMEDIARIA L1                                     
       WHERE L1.CODREGRA = :CODREGRA                                    
         AND L1.NUMTRANSOPERACAO = NVL(L.NUMTRANS, L.RECNUM)            
         AND L1.DATAINTEGRACAO BETWEEN '01/10/2023' AND '30/10/2023'                
         AND L1.CODPLANOCONTA = :CODPLANOCONTA                          
         AND L1.CODFILIAL IN (SELECT RF.CODFILIAL FROM PCREGRAFILIAL RF WHERE RF.CODREGRA = L1.CODREGRA) 
         AND ROWNUM = 1) AS TEMINTEGRACAO,                              

        CASE WHEN (NVL(L.VLVARIACAOCAMBIAL,0) > 0) THEN L.VLVARIACAOCAMBIAL 
        ELSE 0 END AS VALORVARIACAOCAMBIALPOSITIVA, 
        CASE WHEN (NVL(L.VLVARIACAOCAMBIAL,0) < 0) THEN ABS(L.VLVARIACAOCAMBIAL) 
        ELSE 0 END AS VALORVARIACAOCAMBIALNEGATIVA, 
        L.NUMCONTRATOCAMBIO AS NUMEROCONTRATO, --HISTORICO 
        SUBSTR(DECODE(L.TIPOPARCEIRO,                                                              
                               'F', (SELECT F1.FORNECEDOR                                        
                                        FROM PCLANC L1, PCFORNEC F1                                
                                       WHERE L1.RECNUM = L.RECNUMPRINC                             
                                         AND L1.CODFORNEC = F1.CODFORNEC                           
                                         AND ROWNUM = 1),                                          
                               'R', (SELECT TO_CHAR(U.NOME)                                      
                                         FROM PCUSUARI U,  PCLANC L1                               
                                        WHERE U.CODUSUR = L1.CODFORNEC                             
                                          AND L1.RECNUM = L.RECNUMPRINC                            
                                          AND ROWNUM = 1),                                         
                               'M', (SELECT TO_CHAR(E.NOME)                                      
                                         FROM PCEMPR E,  PCLANC L1                                 
                                        WHERE E.MATRICULA = L1.CODFORNEC                           
                                          AND L1.RECNUM = L.RECNUMPRINC                            
                                          AND ROWNUM = 1),                                         
                               'L', (SELECT TO_CHAR(E.NOME)                                      
                                         FROM PCEMPR E,  PCLANC L1                                 
                                        WHERE E.MATRICULA = L1.CODFORNEC                           
                                          AND L1.RECNUM = L.RECNUMPRINC                            
                                          AND ROWNUM = 1),                                         
                               'C', (SELECT CL.CLIENTE                                           
                                         FROM PCCLIENT CL, PCLANC L1                               
                                        WHERE CL.CODCLI = L1.CODFORNEC                             
                                          AND L1.RECNUM = L.RECNUMPRINC                            
                                          AND ROWNUM = 1)),1,40)  AS FORNECEDORPRINC, --HISTORICO   
        CASE                                                                                                    
              WHEN (SELECT COUNT(DISTINCT L1.CODFILIAL) FROM PCLANC L1 WHERE L1.NUMTRANS = L.NUMTRANS) >= 1 THEN
                TO_CHAR(B.CODCONTABIL)                                                                          
              ELSE                                                                                              
                '-1'                                                                                          
        END  AS CONTATRANSITORIA,                                                                               
        NVL(BM.CODFILIAL,L.CODFILIAL) AS CODFILIALBANCO,                                                                    
        CASE WHEN ((SELECT COUNT(DISTINCT L1.CODFILIAL)                                                         
                     FROM PCLANC L1                                                                             
                    WHERE L1.NUMTRANS = L.NUMTRANS) > 1) AND :CONSOLIDAR = 'N'  THEN                         
                    'S' ELSE 'N' END AS ERRO_MULTIFILIAL,                                                   
        L.VALORDEV AS VALORDEVOLUCAO                                                                            
,L.VLRDESCVERBAMANUAL AS VALORDESCVERBAMANUAL 
,L.GERAPROVLANCCONTAB AS GERAPROVLANCCONTAB 

 FROM --ABRE
      (SELECT L.CODFILIAL,
              L.DTPAGTO,
              L.HISTORICO,
              L.HISTORICO2,
              L.RECNUM,
              L.NUMNOTA,
              L.DUPLIC,
              L.VALOR,
              L.VALORDEV,
              L.VPAGOBORDERO,
              CASE WHEN ROUND(L.VPAGO - L.DESCONTOFIN, 2) = 0 THEN 0 ELSE L.VPAGO END VPAGO,
              L.DESCONTOFIN,
              L.TXPERM,
              L.NUMNOTADEV,
              L.NUMBANCO,
              L.TIPOPAGTO,
              L.CODROTINABAIXA,
              L.CODCONTA,
              L.MOEDA,
              L.VLIRRF,
              L.VLSESTSENAT,
              L.NUMTRANS,
              L.TIPOPARCEIRO,
              L.INDICE,
              L.NUMCHEQUE,
              L.NUMBORDERO,
              L.ADIANTAMENTO,
              L.DTPAGADIANTFOR,
              L.NUMTRANSADIANTFOR,
              L.NFSERVICO,
              L.RECNUMPRINC,
              L.CODFORNEC,
              L.DTESTORNOBAIXA,
              L.CODFUNCESTORNOBAIXA,
              C.CODCONTACONTRAPARTIDA,
              (SELECT SUM(DECODE(MF.TIPO, 'C', MF.VALOR, MF.VALOR *(-1))) 
               FROM PCLANC L1, PCMOVCRFOR MF, PCVERBA V , VW_CONTABHIST 
               WHERE L1.RECNUM   = L.RECNUM
               AND   L1.RECNUM   = MF.NUMLANC
               AND   MF.NUMVERBA = V.NUMVERBA
               AND   V.ORIGEM    = 'D'
               )  AS VLRDESCVERBA,
(SELECT SUM(DECODE(MF.TIPO, 'C', MF.VALOR, MF.VALOR *(-1))) 
             FROM PCLANC L1, PCMOVCRFOR MF, PCVERBA V, VW_CONTABHIST 
             WHERE L1.RECNUM   = L.RECNUM             
             AND   L1.RECNUM   = MF.NUMLANC           
             AND   MF.NUMVERBA = V.NUMVERBA           
             AND   V.ORIGEM    = 'M'                
             )  AS VLRDESCVERBAMANUAL,
               C.CONTA,
                CASE
                  WHEN (C.CODCONTA = M.CODCONTAGER) THEN
                    M.CODREDUZIDO_PC
                  ELSE
                    TO_CHAR(C.CONTACONTABIL)
                END AS CONTACONTABIL,
               L.NUMCONTRATOCAMBIO, 
               L.VLVARIACAOCAMBIAL,
               CASE
                 WHEN INSTR(L.HISTORICO2, 'PIS') > 0 OR (L.TIPOPARCEIRO = 'F' AND (SELECT CODCONTAPIS FROM PCFORNEC WHERE CODFORNEC = L.CODFORNEC) = L.CODCONTA) THEN
                  'S'
                 WHEN INSTR(L.HISTORICO2, 'COFINS') > 0 OR (L.TIPOPARCEIRO = 'F' AND (SELECT CODCONTACOFINS FROM PCFORNEC WHERE CODFORNEC = L.CODFORNEC) = L.CODCONTA) THEN
                  'S'
                 WHEN ((INSTR(L.HISTORICO2, 'ISS') > 0 ) AND ( LENGTH(TRIM(L.HISTORICO2)) = 3)) OR (L.TIPOPARCEIRO = 'F' AND (SELECT CODCONTAISS FROM PCFORNEC WHERE CODFORNEC = L.CODFORNEC) = L.CODCONTA) THEN
                  'S'
                 WHEN INSTR(L.HISTORICO2, 'INSS') > 0 OR (L.TIPOPARCEIRO = 'F' AND (SELECT CODCONTAINSS FROM PCFORNEC WHERE CODFORNEC = L.CODFORNEC) = L.CODCONTA) THEN
                  'S'
                 WHEN INSTR(L.HISTORICO2, 'CSRF') > 0 OR (L.TIPOPARCEIRO = 'F' AND (SELECT CODCONTACSRF FROM PCFORNEC WHERE CODFORNEC = L.CODFORNEC) = L.CODCONTA) THEN
                  'S'
                 WHEN INSTR(L.HISTORICO2, 'IRRF') > 0 OR (L.TIPOPARCEIRO = 'F' AND (SELECT CODCONTAIRRF FROM PCFORNEC WHERE CODFORNEC = L.CODFORNEC) = L.CODCONTA) THEN
                  'S'
                 ELSE
                  'N'
               END AS IMPOSTO,
               NVL(C.GERAPROVLANCCONTAB,'N') GERAPROVLANCCONTAB, 
               L.CODROTINACAD                                      
       FROM
            PCLANC L, --TABELA
            PCCONTRATOEMPRESTIMO PCE, --TABELA
            PCCONTA C, --TABELA
            PCMODELOPC M, --TABELA
            VW_CONTABHIST,
         PCMOVCR R, 

     FILIAISREGRA FI 

       WHERE L.CODFILIAL IN (FI.CODFILIAL)
       AND L.CODFUNCESTORNOBAIXA IS NULL
       AND L.NUMTRANS  = R.NUMTRANS(+)
       AND VW_CONTABHIST.RECNUM = L.RECNUM
       AND L.DTESTORNOBAIXA IS NULL
       AND   M.CODPLANOCONTA(+) = :CODPLANOCONTA
AND L.NUMSEQCONTRATOEMPRESTIMO = PCE.NUMSEQCONTRATOEMPRESTIMO(+) 
AND (                                                            
          (NVL(L.NUMSEQCONTRATOEMPRESTIMO,0) = 0)                
           OR                                                    
          ( (NVL(L.NUMSEQCONTRATOEMPRESTIMO,0) > 0)              
			 AND (                                                         
			(NVL(PCE.TIPOCONTRATO, '0') NOT IN ('1', '6'))        
 OR ((NVL(PCE.TIPOCONTRATO, '0') IN ('1','6')) AND L.CODROTINABAIXA IN (775,631))) 
		  )                                                           
    )                                                            
       AND   NVL(R.ESTORNO(+),'N') = 'N' 
       AND   NVL(R.CODROTINALANC,0) NOT IN ('1207','1209','402','409','1502','1512','604', /*ROTINALANCVALE*/ '737')
       AND   L.DTPAGTO BETWEEN :DATA1 AND :DATA2
       AND   NVL(L.MOEDA, 'R') = 'R' 
       AND   L.CODCONTA = C.CODCONTA
       AND   L.CODCONTA = M.CODCONTAGER(+)) L,  --FECHA
      PCBANCO B,
      PCFORNEC F,
      PCMODELOPC M,
      PCMOVCR R,
      PCBANCOMOEDA BM,
      PCFILIAL FL
 WHERE L.NUMTRANS  = R.NUMTRANS(+)
 AND   L.NUMBANCO  = B.CODBANCO(+)
 AND   L.CODFORNEC = F.CODFORNEC(+)
 AND   R.CODBANCO  = BM.CODBANCO(+) 
 AND   R.CODCOB    = BM.CODMOEDA(+) 
 AND   BM.CODPLANOCONTA(+) = :CODPLANOCONTA
 AND   M.CODPLANOCONTA(+) = :CODPLANOCONTA
 AND   F.CODFORNEC = M.CODFORNEC(+)
 AND   TRIM(F.CODCONTAB) = TRIM(M.CODREDUZIDO_PC(+))
 AND   NVL(R.ESTORNO(+),'N') = 'N' 
 AND   NVL(R.CODROTINALANC,0) NOT IN ('1207','1209','402','409','1502','1512','604', /*ROTINALANCVALE*/ '737')
 /*CONTABESTORNO*/ AND ((L.CODROTINABAIXA NOT IN ('746','737','1301','1307','3402') AND (NOT(L.CODROTINABAIXA = 1302 AND L.NUMTRANS IS NULL))) OR (L.CODROTINABAIXA = '746' AND NVL(L.NUMTRANSADIANTFOR, 0) > 0 AND NVL(L.VPAGO, 0) > 0))
--AND   L.DTPAGTO = R.DATA(+)
 AND   FL.CODIGO = L.CODFILIAL
 AND   L.DTPAGTO BETWEEN :DATA1 AND :DATA2
