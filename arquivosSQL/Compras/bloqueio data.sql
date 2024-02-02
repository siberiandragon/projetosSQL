
SELECT CODFILIAL,
       CODPROD,
       NUMLOTE,
       TIPO_BLOQUEIO,
       CODIGO_BLOQUEIO,
       QT,
       DATA_BLOQUEIO,
       ROTINA_RESPONSAVEL
  FROM (SELECT PCPRODAVARIA.CODFILIAL,
               PCPRODAVARIA.CODPROD,
               PCPRODAVARIA.NUMLOTE,
               'LANÇAMENTO_AVARIA' AS TIPO_BLOQUEIO,
               NVL(PCPRODAVARIA.CODAVARIA, 0) AS CODIGO_BLOQUEIO,
               NVL((CASE
                     WHEN PCPRODAVARIA.NUMLOTE IS NULL THEN
                      (SUM(NVL(PCPRODAVARIA.QT, 0)) -
                      NVL((SELECT SUM(NVL(PCGRUPOAVARIA.QT, 0))
                             FROM PCGRUPOAVARIA
                            WHERE PCGRUPOAVARIA.CODPROD = PCPRODAVARIA.CODPROD
                              AND PCGRUPOAVARIA.CODFILIAL =
                                  PCPRODAVARIA.CODFILIAL
                              AND NVL(PCGRUPOAVARIA.CODAVARIA, 0) =
                                  NVL(PCPRODAVARIA.CODAVARIA, 0)
                              AND PCGRUPOAVARIA.CODMOTIVOAVARIA =
                                  NVL(PCPRODAVARIA.CODMOTIVOAVARIA, 0)
                              AND PCGRUPOAVARIA.STATUS IN ('A', 'P')),
                           0))
                     ELSE
                      (SUM(NVL(PCPRODAVARIA.QT, 0)) -
                      NVL((SELECT SUM(NVL(PCGRUPOAVARIA.QT, 0))
                             FROM PCGRUPOAVARIA
                            WHERE PCGRUPOAVARIA.CODPROD = PCPRODAVARIA.CODPROD
                              AND PCGRUPOAVARIA.CODFILIAL =
                                  PCPRODAVARIA.CODFILIAL
                              AND NVL(PCGRUPOAVARIA.CODAVARIA, 0) =
                                  NVL(PCPRODAVARIA.CODAVARIA, 0)
                              AND PCGRUPOAVARIA.CODMOTIVOAVARIA =
                                  NVL(PCPRODAVARIA.CODMOTIVOAVARIA, 0)
                              AND PCGRUPOAVARIA.NUMLOTE = PCPRODAVARIA.NUMLOTE
                              AND PCGRUPOAVARIA.STATUS IN ('A', 'P')),
                           0))
                   END),
                   0) AS QT,
               PCPRODAVARIA.DATA AS DATA_BLOQUEIO,
               '1182' AS ROTINA_RESPONSAVEL
          FROM PCPRODAVARIA
         WHERE 0=0
           --AND PCPRODAVARIA.CODPROD = 804
           AND PCPRODAVARIA.CODFILIAL IN ('2','3','4')
         GROUP BY PCPRODAVARIA.CODFILIAL,
                  PCPRODAVARIA.CODPROD,
                  PCPRODAVARIA.NUMLOTE,
                  PCPRODAVARIA.CODAVARIA,
                  PCPRODAVARIA.CODMOTIVOAVARIA,
                  PCPRODAVARIA.DATA
        HAVING(CASE
          WHEN PCPRODAVARIA.NUMLOTE IS NULL THEN
           (SUM(NVL(PCPRODAVARIA.QT, 0)) -
           NVL((SELECT SUM(NVL(PCGRUPOAVARIA.QT, 0))
                  FROM PCGRUPOAVARIA
                 WHERE PCGRUPOAVARIA.CODPROD = PCPRODAVARIA.CODPROD
                   AND PCGRUPOAVARIA.CODFILIAL =
                       PCPRODAVARIA.CODFILIAL
                   AND NVL(PCGRUPOAVARIA.CODAVARIA, 0) =
                       NVL(PCPRODAVARIA.CODAVARIA, 0)
                   AND PCGRUPOAVARIA.CODMOTIVOAVARIA =
                       NVL(PCPRODAVARIA.CODMOTIVOAVARIA, 0)
                   AND PCGRUPOAVARIA.STATUS IN ('A', 'P')),
                0))
          ELSE
           (SUM(NVL(PCPRODAVARIA.QT, 0)) -
           NVL((SELECT SUM(NVL(PCGRUPOAVARIA.QT, 0))
                  FROM PCGRUPOAVARIA
                 WHERE PCGRUPOAVARIA.CODPROD = PCPRODAVARIA.CODPROD
                   AND PCGRUPOAVARIA.CODFILIAL =
                       PCPRODAVARIA.CODFILIAL
                   AND NVL(PCGRUPOAVARIA.CODAVARIA, 0) =
                       NVL(PCPRODAVARIA.CODAVARIA, 0)
                   AND PCGRUPOAVARIA.CODMOTIVOAVARIA =
                       NVL(PCPRODAVARIA.CODMOTIVOAVARIA, 0)
                   AND PCGRUPOAVARIA.NUMLOTE = PCPRODAVARIA.NUMLOTE
                   AND PCGRUPOAVARIA.STATUS IN ('A', 'P')),
                0))
        END) > 0
        UNION ALL
        SELECT PCGRUPOAVARIA.CODFILIAL,
               PCGRUPOAVARIA.CODPROD,
               PCGRUPOAVARIA.NUMLOTE,
               'GRUPO_AVARIA' AS TIPO_BLOQUEIO,
               PCGRUPOAVARIA.CODGRUPO AS CODIGO_BLOQUEIO,
               PCGRUPOAVARIA.QT AS QT,
               PCGRUPOAVARIA.DATAGRUPO AS DATA_BLOQUEIO,
               '1182' AS ROTINA_RESPONSAVEL
          FROM PCGRUPOAVARIA
         WHERE 0=0
          -- AND PCGRUPOAVARIA.CODPROD = 804
           AND PCGRUPOAVARIA.CODFILIAL IN ('2','3','4')
           AND PCGRUPOAVARIA.STATUS IN ('A', 'P')
        UNION ALL
        SELECT C.CODFILIAL,
               I.CODPROD,
               I.NUMLOTE,
               'NUMBONUS' TIPO_BLOQUEIO,
               I.NUMBONUS AS CODIGO_BLOQUEIO,
               I.QTNF AS QT,
               C.DATABONUS AS DATA_BLOQUEIO,
               '1106' AS ROTINA_RESPONSAVEL
          FROM PCBONUSC C, PCBONUSI I
         WHERE 0=0
           AND C.NUMBONUS = I.NUMBONUS
          -- AND I.CODPROD = 804
           AND C.CODFILIAL IN ('2','3','4')
           AND C.DTFECHAMENTO IS NULL
           AND C.DTCANCEL IS NULL
           AND NVL(C.LIBERAESTENTMERC, 'N') = 'N'
           AND TRUNC(C.DTMONTAGEM) > TRUNC(SYSDATE - 90)
           AND NVL(C.UTILIZOUPREENT, 'N') = 'N'
        UNION ALL
        SELECT E.CODFILIAL,
               E.CODPROD,
               '' AS NUMLOTE,
               'BLOQUEIO 266' AS TIPO_BLOQUEIO,
               E.CODDEVOL AS CODIGO_BLOQUEIO,
               NVL(E.QTBLOQUEADA, 0) - SUM(NVL(B.QT, 0)),
               SYSDATE AS DATA_BLOQUEIO,
               '266' AS ROTINA_RESPONSAVEL
          FROM PCEST E,
               (SELECT PCPRODAVARIA.CODFILIAL,
                       PCPRODAVARIA.CODPROD,
                       NVL((CASE
                             WHEN PCPRODAVARIA.NUMLOTE IS NULL THEN
                              (SUM(NVL(PCPRODAVARIA.QT, 0)) -
                              NVL((SELECT SUM(NVL(PCGRUPOAVARIA.QT, 0))
                                     FROM PCGRUPOAVARIA
                                    WHERE PCGRUPOAVARIA.CODPROD =
                                          PCPRODAVARIA.CODPROD
                                      AND PCGRUPOAVARIA.CODFILIAL =
                                          PCPRODAVARIA.CODFILIAL
                                      AND NVL(PCGRUPOAVARIA.CODAVARIA, 0) =
                                          NVL(PCPRODAVARIA.CODAVARIA, 0)
                                      AND PCGRUPOAVARIA.CODMOTIVOAVARIA =
                                          NVL(PCPRODAVARIA.CODMOTIVOAVARIA, 0)
                                      AND PCGRUPOAVARIA.STATUS IN ('A', 'P')),
                                   0))
                             ELSE
                              (SUM(NVL(PCPRODAVARIA.QT, 0)) -
                              NVL((SELECT SUM(NVL(PCGRUPOAVARIA.QT, 0))
                                     FROM PCGRUPOAVARIA
                                    WHERE PCGRUPOAVARIA.CODPROD =
                                          PCPRODAVARIA.CODPROD
                                      AND PCGRUPOAVARIA.CODFILIAL =
                                          PCPRODAVARIA.CODFILIAL
                                      AND NVL(PCGRUPOAVARIA.CODAVARIA, 0) =
                                          NVL(PCPRODAVARIA.CODAVARIA, 0)
                                      AND PCGRUPOAVARIA.CODMOTIVOAVARIA =
                                          NVL(PCPRODAVARIA.CODMOTIVOAVARIA, 0)
                                      AND PCGRUPOAVARIA.NUMLOTE =
                                          PCPRODAVARIA.NUMLOTE
                                      AND PCGRUPOAVARIA.STATUS IN ('A', 'P')),
                                   0))
                           END),
                           0) AS QT
                  FROM PCPRODAVARIA
                 WHERE 0=0
              --     AND PCPRODAVARIA.CODPROD = 804
                   AND PCPRODAVARIA.CODFILIAL IN ('2','3','4')
                 GROUP BY PCPRODAVARIA.CODFILIAL,
                          PCPRODAVARIA.CODPROD,
                          PCPRODAVARIA.NUMLOTE,
                          PCPRODAVARIA.CODAVARIA,
                          PCPRODAVARIA.CODMOTIVOAVARIA
                HAVING(CASE
                  WHEN PCPRODAVARIA.NUMLOTE IS NULL THEN
                   (SUM(NVL(PCPRODAVARIA.QT, 0)) -
                   NVL((SELECT SUM(NVL(PCGRUPOAVARIA.QT, 0))
                          FROM PCGRUPOAVARIA
                         WHERE PCGRUPOAVARIA.CODPROD =
                               PCPRODAVARIA.CODPROD
                           AND PCGRUPOAVARIA.CODFILIAL =
                               PCPRODAVARIA.CODFILIAL
                           AND NVL(PCGRUPOAVARIA.CODAVARIA, 0) =
                               NVL(PCPRODAVARIA.CODAVARIA, 0)
                           AND PCGRUPOAVARIA.CODMOTIVOAVARIA =
                               NVL(PCPRODAVARIA.CODMOTIVOAVARIA, 0)
                           AND PCGRUPOAVARIA.STATUS IN ('A', 'P')),
                        0))
                  ELSE
                   (SUM(NVL(PCPRODAVARIA.QT, 0)) -
                   NVL((SELECT SUM(NVL(PCGRUPOAVARIA.QT, 0))
                          FROM PCGRUPOAVARIA
                         WHERE PCGRUPOAVARIA.CODPROD =
                               PCPRODAVARIA.CODPROD
                           AND PCGRUPOAVARIA.CODFILIAL =
                               PCPRODAVARIA.CODFILIAL
                           AND NVL(PCGRUPOAVARIA.CODAVARIA, 0) =
                               NVL(PCPRODAVARIA.CODAVARIA, 0)
                           AND PCGRUPOAVARIA.CODMOTIVOAVARIA =
                               NVL(PCPRODAVARIA.CODMOTIVOAVARIA, 0)
                           AND PCGRUPOAVARIA.NUMLOTE =
                               PCPRODAVARIA.NUMLOTE
                           AND PCGRUPOAVARIA.STATUS IN ('A', 'P')),
                        0))
                END) > 0
                UNION ALL
                SELECT PCGRUPOAVARIA.CODFILIAL,
                       PCGRUPOAVARIA.CODPROD,
                       PCGRUPOAVARIA.QT AS QT
                  FROM PCGRUPOAVARIA
                 WHERE 0=0
                --   AND PCGRUPOAVARIA.CODPROD = 804
                   AND PCGRUPOAVARIA.CODFILIAL IN ('2','3','4')
                   AND PCGRUPOAVARIA.STATUS IN ('A', 'P')
                UNION ALL
                SELECT C.CODFILIAL, I.CODPROD, I.QTNF AS QT
                  FROM PCBONUSC C, PCBONUSI I
                 WHERE 0=0
                   AND C.NUMBONUS = I.NUMBONUS
                  -- AND I.CODPROD = 804
                   AND C.CODFILIAL IN ('2','3','4')
                   AND C.DTFECHAMENTO IS NULL
                   AND C.DTCANCEL IS NULL
                   AND NVL(C.LIBERAESTENTMERC, 'N') = 'N'
                   AND TRUNC(C.DTMONTAGEM) > TRUNC(SYSDATE - 90)
                   AND NVL(C.UTILIZOUPREENT, 'N') = 'N') B
         WHERE 0=0 
         --  AND E.CODPROD = 804
           AND E.CODFILIAL IN ('2','3','4')
           AND E.CODPROD = B.CODPROD(+)
           AND E.CODFILIAL = B.CODFILIAL(+)
         GROUP BY E.CODPROD, E.CODFILIAL, E.QTBLOQUEADA, E.CODDEVOL
        HAVING(NVL(E.QTBLOQUEADA, 0) - SUM(NVL(B.QT, 0))) > 0)
 ORDER BY CODPROD 