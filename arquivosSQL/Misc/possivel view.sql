SELECT
    PCPEDI.CODPROD,
    PCPRODUT.DESCRICAO,
    PCPRODUT.EMBALAGEM,
    PCPRODUT.UNIDADE,
    SUM(PCPEDI.QT) AS QT_TOTAL,
    PCPEDI.PVENDA,
    SUM(NVL(PCPEDI.QT, 0) * NVL(PCPEDI.PVENDA, 0)) AS VLTOTAL,
    SUM(NVL(PCPEDC.QTDEVOL, 0)) AS QTDEVOL
FROM
    PCPEDI
INNER JOIN PCPEDC ON PCPEDI.NUMPED = PCPEDC.NUMPED
INNER JOIN PCPRODUT ON PCPEDI.CODPROD = PCPRODUT.CODPROD
LEFT JOIN (
    SELECT
        pcmov.codprod,
        SUM(pcmov.qt) AS QTDEVOL
    FROM
        pcestcom
    INNER JOIN pcmov ON pcestcom.numtransent = pcmov.numtransent
    INNER JOIN PCPEDI ON pcmov.numped = PCPEDI.NUMPED
                     AND pcmov.codprod = PCPEDI.codprod
                     AND pcmov.numseq = PCPEDI.numseq
    WHERE
        pcmov.dtcancel IS NULL
    GROUP BY
        pcmov.codprod
) PCPEDC ON PCPEDI.CODPROD = PCPEDC.CODPROD
INNER JOIN PCUSUARI ON PCPEDC.CODUSUR = PCUSUARI.CODUSUR
WHERE
    PCPEDC.CONDVENDA = 7
    AND PCPEDC.DATA BETWEEN TO_DATE('08/05/2023', 'DD/MM/YYYY') AND TO_DATE('04/04/2024', 'DD/MM/YYYY')
    AND (PCPEDC.NUMNOTA = 51357 OR PCPEDC.NUMCUPOM = 51357)
    AND TRUNC(PCPEDC.DATA) BETWEEN TO_DATE('08/05/2023', 'DD/MM/YYYY') AND TO_DATE('04/04/2024', 'DD/MM/YYYY')
    AND PCPEDC.POSICAO IN ('', 'F', '')
GROUP BY
    PCPEDI.CODPROD,
    PCPRODUT.DESCRICAO,
    PCPRODUT.EMBALAGEM,
    PCPRODUT.UNIDADE,
    PCPEDI.PVENDA;