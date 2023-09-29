SELECT
    TO_CHAR('N') DESTACAR,
    (NVL(PCLANC.VALOR, 0) + NVL(PCLANC.TXPERM, 0)) AS VALOR_JUROS,
    PCLANC.DTVENC,
    PCRATEIOPADRAOCONTA.CODRATEIOCONTA,
    PCRATEIOPADRAOCONTA.DESCRICAO RATEIOCONTA,
    PCLANC.RECNUM,
    PCLANC.RECNUMPRINC,
    PCLANC.DUPLIC,
    (
        DECODE(PCLANC.TIPOPARCEIRO,
            'F', (SELECT FORNECEDOR FROM PCFORNEC WHERE CODFORNEC = PCLANC.CODFORNEC),
            'R', (SELECT NOME FROM PCUSUARI WHERE CODUSUR = PCLANC.CODFORNEC),
            'C', (SELECT CLIENTE FROM PCCLIENT WHERE CODCLI = PCLANC.CODFORNEC),
            'M', (SELECT NOME FROM PCEMPR WHERE MATRICULA = PCLANC.CODFORNEC),
            'L', (SELECT NOME FROM PCEMPR WHERE MATRICULA = PCLANC.CODFORNEC),
            PCLANC.FORNECEDOR)
    ) AS calcNomeParceiro,
    PCLANC.HISTORICO2,
    PCLANC.NOMEFUNC,
    PCLANC.CODCONTA,
    PCCONTA.CONTA,
    PCCONTA.GRUPOCONTA,
    PCGRUPO.GRUPO,
    PCLANC.HISTORICO,
    PCLANC.CODFORNEC,
    PCLANC.TIPOPARCEIRO,
    PCLANC.NUMNOTA,
    NVL(PCLANC.VALOR, 0) AS VALOR,
    NVL(PCLANC.DESCONTOFIN, 0) AS DESCONTOFIN,
    NVL(PCLANC.VALORDEV, 0) AS VALORDEV,
    NVL(PCLANC.VLVARIACAOCAMBIAL, 0) AS VLVARIACAOCAMBIAL,
    PCLANC.DTEMISSAO,
    PCLANC.DTLANC,
    NVL(PCLANC.VPAGO, 0) AS VPAGO,
    NVL(pclanc.TXPERM, 0) AS TXPERM,
    NVL(PCLANC.VPAGOBORDERO, 0) AS VPAGOBORDERO,
    PCLANC.DTBORDER,
    PCLANC.DTPAGTO,
    PCLANC.NUMSEQBORDERO,
    PCLANC.CODFILIAL,
    NVL(PCLANC.VLVARIACAOCAMBIAL, 0) AS VLVARIACAOCAMBIAL,
    NVL(
        (
            SELECT PCCOTACAOMOEDAI.COTACAO
            FROM PCCOTACAOMOEDAI
            WHERE PCCOTACAOMOEDAI.CODIGO = PCLANC.MOEDAESTRANGEIRA
            AND PCCOTACAOMOEDAI.DATACOTACAO = '30/12/1899'
        ), 0
    ) AS COTACAOATUALMOEDAESTRANGEIRA,
    PCLANC.LOCALIZACAO,
    PCLANC.DTMOEDA,
    PCLANC.MOEDA,
    PCLANC.NUMBANCO,
    PCLANC.NUMCHEQUE,
    PCLANC.NUMBORDERO,
    NVL(PCLANC.PRORROG, 0) PRORROG,
    PCLANC.NUMTRANSENT,
    PCLANC.INDICE,
    PCLANC.DTBLOQ,
    PCLANC.NUMNEGOCIACAO,
    PCFORNEC.PRAZOMIN,
    PCFORNEC.ESTADO,
    PCLANC.BOLETO,
    NVL(PCLANC.PARCELA, PCLANC.DUPLIC) AS PARCELA,
    CASE
        WHEN NVL(TRUNC(SYSDATE) - PCLANC.DTVENC, 0) < 0 THEN 0
        ELSE NVL(TRUNC(SYSDATE) - PCLANC.DTVENC, 0)
    END AS ATRASOVENC,
    CASE
        WHEN PCLANC.TIPOPARCEIRO = 'F' THEN
            (SELECT NVL(PRAZOENTREGA, 0) FROM PCFORNEC WHERE CODFORNEC = PCLANC.CODFORNEC)
        ELSE
            0
    END AS PRAZO,
    CASE
        WHEN (
            (NVL(PCLANC.DTLANC - PCLANC.DTEMISSAO, 0)) -
            DECODE(PCLANC.TIPOPARCEIRO, 'F', (SELECT NVL(PRAZOENTREGA, 0) FROM PCFORNEC WHERE CODFORNEC = PCLANC.CODFORNEC), 0)
        ) < 0 THEN
            0
        ELSE
            (
                (NVL(PCLANC.DTLANC - PCLANC.DTEMISSAO, 0)) -
                DECODE(PCLANC.TIPOPARCEIRO, 'F', (SELECT NVL(PRAZOENTREGA, 0) FROM PCFORNEC WHERE CODFORNEC = PCLANC.CODFORNEC), 0)
            )
    END AS ATRASO,
    NVL(PCLANC.DTLANC - PCLANC.DTEMISSAO, 0) AS DIAS,
    PCLANC.NUMTRANSADIANTFOR,
    PCLANC.DTESTORNOBAIXA,
    (PCLANC.DTVENC - PCLANC.DTLANC) AS PRAZOPAGAR,
    'S' AGRUPARPORCODFORNEC,
    PCLANC.CODRECEITA,
    PCLANC.VLISS,
    PCLANC.VLINSS,
    PCLANC.VLIRRF,
    PCLANC.VLPIS,
    PCLANC.VLCOFINS,
    PCLANC.VLCSRF,
    CASE
        WHEN p.STATUSPRESTACAOCONTA = 'AP' THEN 'Aprovado'
        WHEN p.STATUSPRESTACAOCONTA = 'AB' THEN 'Aberta'
        WHEN p.STATUSPRESTACAOCONTA = 'RE' THEN 'Rejeitado'
        WHEN p.STATUSPRESTACAOCONTA = 'CA' THEN 'Cancelado'
        WHEN p.STATUSPRESTACAOCONTA = 'LP' THEN 'Liberado Pagamento'
        WHEN p.STATUSPRESTACAOCONTA = 'FI' THEN 'Finalizado'
        WHEN p.STATUSPRESTACAOCONTA = 'EN' THEN 'Encerrado'
        ELSE ''
    END AS STATUSPRESTACAOCONTA,
    p.NUMPRESTACAOCONTA,
    P.PROJETO,
    P.MOTIVOPRESTACAOCONTA,
    CASE
        WHEN A.STATUSADIANTAMENTO = 'S' THEN 'Solicitado'
        WHEN A.STATUSADIANTAMENTO = 'A' THEN 'Aprovado'
        WHEN A.STATUSADIANTAMENTO = 'R' THEN 'Rejeitado'
        WHEN A.STATUSADIANTAMENTO = 'C' THEN 'Cancelado'
        WHEN A.STATUSADIANTAMENTO = 'L' THEN 'Liberado Pagamento'
        WHEN A.STATUSADIANTAMENTO = 'F' THEN 'Finalizado'
        ELSE ''
    END AS STATUSADIANTAMENTO,
    A.NUMADIANTAMENTO,
    A.VALORADIANTAMENTO
FROM
    PCLANC
LEFT JOIN PCCONTA ON PCLANC.CODCONTA = PCCONTA.CODCONTA
INNER JOIN PCGRUPO ON PCCONTA.GRUPOCONTA = PCGRUPO.CODGRUPO
LEFT JOIN PCFORNEC ON PCLANC.CODFORNEC = PCFORNEC.CODFORNEC
LEFT JOIN PCPRESTACAOCONTA P ON PCLANC.NUMPRESTACAOCONTA = P.NUMPRESTACAOCONTA
LEFT JOIN PCADIANTFUNC A ON PCLANC.NUMADIANTAMENTO = A.NUMADIANTAMENTO
LEFT JOIN PCPEDIDO ON PCLANC.IDCONTROLEEMBARQUE = PCPEDIDO.IDCONTROLEEMBARQUE
LEFT JOIN PCRATEIOCONTAS ON PCLANC.RECNUM = PCRATEIOCONTAS.RECNUM
LEFT JOIN PCRATEIOPADRAOCONTA ON PCRATEIOCONTAS.CODRATEIOCONTA = PCRATEIOPADRAOCONTA.CODRATEIOCONTA
WHERE
    PCLANC.DTVENC >= '01/08/2023'
    AND PCLANC.DTVENC <= '31/08/2023'
    AND EXISTS (
        SELECT 1
        FROM PCLIB
        WHERE CODTABELA = TO_CHAR(1)
            AND (CODIGOA = NVL(PCLANC.CODFILIAL, CODIGOA) OR CODIGOA = '99')
            AND CODFUNC = 16
            AND PCLIB.CODIGOA IS NOT NULL
    )
    AND (PCLANC.DTPAGTO IS NULL)
    AND (
        PCCONTA.CODCONTA NOT IN (SELECT NVL(CODCONTANTPAG, 0) FROM PCCONSUM)
        AND PCCONTA.CODCONTA NOT IN (SELECT NVL(CODCONTRECJUR, 0) FROM PCCONSUM)
        AND PCCONTA.CODCONTA NOT IN (SELECT NVL(CODCONTPAGJUR, 0) FROM PCCONSUM)
    )
    AND NVL(PCLANC.TIPOLANC, 'C') LIKE 'C'
ORDER BY
    PCLANC.DTVENC,
    calcNomeParceiro,
    PCLANC.CODFORNEC,
    PCLANC.CODCONTA,
    PCLANC.RECNUM;
