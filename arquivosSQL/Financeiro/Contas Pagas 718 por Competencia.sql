SELECT 
  TABELA.TIPO,
  TABELA.DTPAGTO,
  TABELA.DTVENC,
  TABELA.RECNUM,
  TABELA.CODCONTA,
  TABELA.CONTA,
  TABELA.HISTORICO,
  TABELA.HISTORICO2,
  NVL(TABELA.HISTORICO, '') || ' - ' || NVL(TABELA.HISTORICO2, '') AS HISTORICOCOMPLETO,
  TABELA.ASSINATURA,
  TABELA.CODFORNEC,
  TABELA.TIPOPARCEIRO,
  TABELA.NUMNOTA,
  TABELA.VALOR,
  TABELA.DESCONTOFIN,
  TABELA.VALORDEV,
  TABELA.TXPERM,
  TABELA.VLVARIACAOCAMBIAL,
  TABELA.VALORPAGAR,
  TABELA.VPAGO,
  TABELA.VPAGOBORDERO,
  TABELA.LOCALIZACAO,
  TABELA.NUMNEGOCIACAO,
  TABELA.TIPOPAGTO,
  TABELA.NUMBANCO,
  TABELA.NUMCHEQUE,
  TABELA.NUMBORDERO,
  TABELA.GRUPOCONTA,
  TABELA.NOMEFUNC,
  TABELA.DUPLIC,
  TABELA.CODFILIAL,
  TABELA.NUMTRANSADIANTFOR,
  TABELA.NOME,
  TABELA.COTACAO,
  TABELA.VALORMOEDAESTRANG,
  TABELA.MOEDAESTRANGEIRA,
  TABELA.NOMEMOEDAESTRANGEIRA,
  TABELA.COTACAOBAIXA,
  TABELA.VALORCOTACAOBAIXA,
  TABELA.VALOR_DIF_ENT_SAIDA,
  TABELA.NUMDIIMPORTACAO,
  TABELA.CONTACONTABIL,
  TABELA.NUMCONTRATOCAMBIO,
  TABELA.NUMTRANS_PCMOVCR,
  SUM(TABELA.VALOLIQUIDO) AS VALOLIQUIDO,
  TABELA.BLOQUEADO,
  TABELA.CODPROJETO,
  TABELA.NUMTRANS,
  TABELA.TIPOPAGAMENTO,
  TABELA.PARCEIRO,
  TABELA.VALORUTILIZADO,
  TABELA.VALORRESTANTE,
  TABELA.DTCOMPENSACAO,
  TABELA.VALORPAGO,
  TABELA.STATUSPRESTACAOCONTA,
  TABELA.NUMPRESTACAOCONTA,
  TABELA.PROJETO,
  TABELA.MOTIVOPRESTACAOCONTA,
  TABELA.STATUSADIANTAMENTO,
  TABELA.NUMADIANTAMENTO,
  TABELA.VALORADIANTAMENTO,
  TABELA.PARCELA
FROM (
  SELECT DISTINCT
    DECODE(PCMOVCR.TIPO, 'C', 'D', NULL, 'D', 'D') AS TIPO,
    PCLANC.DTPAGTO,
    PCLANC.DTVENC,
    PCLANC.RECNUM,
    PCLANC.CODCONTA,
    PCCONTA.CONTA,
    PCLANC.HISTORICO,
    PCLANC.ASSINATURA,
    PCLANC.HISTORICO2,
    PCLANC.CODFORNEC,
    PCLANC.TIPOPARCEIRO,
    PCLANC.NUMNOTA,
    PCLANC.PARCELA,
    (
      SELECT MAX(M.DTCOMPENSACAO)
      FROM PCMOVCR M
      WHERE M.NUMTRANS = PCLANC.NUMTRANS
    ) AS DTCOMPENSACAO,
    DECODE(NVL(PCLANC.ADIANTAMENTO, 'N'), 'N', 0, NVL(PCLANC.VLRUTILIZADOADIANTFORNEC, 0) + NVL(PCLANC.VLVARIACAOCAMBIAL, 0)) VALORUTILIZADO,
    DECODE(NVL(PCLANC.ADIANTAMENTO, 'N'), 'N', 0, NVL(PCLANC.VALOR, 0) - (NVL(PCLANC.VLRUTILIZADOADIANTFORNEC, 0) + NVL(PCLANC.VLVARIACAOCAMBIAL, 0))) VALORRESTANTE,
    NVL(PCLANC.VALOR, 0) VALOR,
    (
      CASE WHEN NVL(PCLANC.VALOR, 0) < 0 THEN ABS(NVL(PCLANC.DESCONTOFIN, 0)) * (-1) ELSE NVL(PCLANC.DESCONTOFIN, 0) END
    ) DESCONTOFIN,
    NVL(PCLANC.VALORDEV, 0) VALORDEV,
    NVL(PCLANC.TXPERM, 0) TXPERM,
    NVL(PCLANC.VLVARIACAOCAMBIAL, 0) VLVARIACAOCAMBIAL,
    (
      CASE WHEN PCLANC.DTPAGTO IS NULL THEN
        (
          NVL(PCLANC.VALOR, 0) + NVL(PCLANC.TXPERM, 0) - NVL(PCLANC.DESCONTOFIN, 0) - NVL(PCLANC.VALORDEV, 0) + NVL(PCLANC.VLVARIACAOCAMBIAL, 0)
        )
      ELSE NVL(PCLANC.VALOR, 0) - NVL(PCLANC.VALORDEV, 0) END
    ) AS VALORPAGAR,
    NVL(PCLANC.VPAGO, 0) AS VPAGO,
    NVL(PCLANC.VPAGOBORDERO, PCLANC.VPAGO) AS VPAGOBORDERO,
    PCLANC.LOCALIZACAO,
    PCLANC.NUMNEGOCIACAO,
    PCLANC.TIPOPAGTO,
    NVL(PCLANC.NUMBANCO, 0) AS NUMBANCO,
    PCLANC.NUMCHEQUE,
    NVL(PCLANC.NUMBORDERO, 0) AS NUMBORDERO,
    PCCONTA.GRUPOCONTA,
    PCLANC.NOMEFUNC,
    PCLANC.DUPLIC,
    PCLANC.CODFILIAL,
    NVL(PCLANC.NUMTRANSADIANTFOR, 0) AS NUMTRANSADIANTFOR,
    PCEMPR.NOME,
    NVL(PCLANC.COTACAO, 0) AS COTACAO,
    (PCLANC.VALOR / GREATEST(NVL(PCLANC.COTACAO, 0), 1)) VALORMOEDAESTRANG,
    PCLANC.MOEDAESTRANGEIRA,
    (
      SELECT PCCOTACAOMOEDAC.MOEDA
      FROM PCCOTACAOMOEDAC
      WHERE PCCOTACAOMOEDAC.CODIGO = PCLANC.MOEDAESTRANGEIRA
    ) AS NOMEMOEDAESTRANGEIRA,
    NVL(PCLANC.COTACAOBAIXA, 0) AS COTACAOBAIXA,
    ((PCLANC.VALOR / GREATEST(NVL(PCLANC.COTACAO, 0), 1)) * NVL(PCLANC.COTACAOBAIXA, 0)) AS VALORCOTACAOBAIXA,
    PCLANC.VALOR - ((PCLANC.VALOR / GREATEST(NVL(PCLANC.COTACAO, 0), 1)) * NVL(PCLANC.COTACAOBAIXA, 0)) AS VALOR_DIF_ENT_SAIDA,
    PCLANC.NUMDIIMPORTACAO,
    PCCONTA.CONTACONTABIL,
    PCLANC.NUMCONTRATOCAMBIO,
    PCMOVCR.NUMTRANS NUMTRANS_PCMOVCR,
    ((NVL(PCLANC.VALOR, 0) + NVL(PCLANC.TXPERM, 0) - NVL(PCLANC.VALORDEV, 0)) - NVL(PCLANC.DESCONTOFIN, 0) + NVL(PCLANC.VLVARIACAOCAMBIAL, 0)) AS VALOLIQUIDO,
    PCLANC.INDICE AS BLOQUEADO,
    PCLANC.CODPROJETO,
    PCLANC.NUMTRANS,
    CASE
      WHEN (SELECT COUNT(*) FROM PCLANC L WHERE L.RECNUM = PCLANC.RECNUM AND NUMBORDERO <> 0 AND NUMBORDERO IS NOT NULL) > 0 THEN 'Border�'
      WHEN (SELECT COUNT(*) FROM PCLANC L WHERE L.RECNUM = PCLANC.RECNUM AND NUMCHEQUE <> '0' AND NUMCHEQUE IS NOT NULL) > 0 THEN 'Cheque'
    END AS TIPOPAGAMENTO,
    NVL(
      DECODE(
        PCLANC.TIPOPARCEIRO,
        'C', FCLI.CLIENTE,
        'F', FFOR.FORNECEDOR,
        'R', FUSU.NOME,
        'M', FEMP.NOME,
        'L', FEMP.NOME,
        'O', NVL(PCLANC.FORNECEDOR, 'Outros Fornecedores')
      ), 'N�o Identificado'
    ) PARCEIRO,
    NVL(PCLANC.VALOR, 0) -
    CASE WHEN NVL(PCLANC.VALOR, 0) < 0 THEN ABS(NVL(PCLANC.DESCONTOFIN, 0)) * (-1) ELSE NVL(PCLANC.DESCONTOFIN, 0) END -
    NVL(PCLANC.VALORDEV, 0) + NVL(PCLANC.TXPERM, 0) + NVL(PCLANC.VLVARIACAOCAMBIAL, 0) VALORPAGO,
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
    PCLANC,
    PCCONTA,
    PCEMPR,
    PCPEDIDO,
    PCCONSUM,
    PCMOVCR,
    PCPRESTACAOCONTA P,
    PCADIANTFUNC A,
    PCCLIENT FCLI,
    PCFORNEC FFOR,
    PCUSUARI FUSU,
    PCEMPR FEMP --Parceiros
  WHERE
    (PCLANC.CODCONTA = PCCONTA.CODCONTA(+))
    AND PCLANC.DTPAGTO IS NOT NULL
    AND PCLANC.NUMPRESTACAOCONTA = P.NUMPRESTACAOCONTA(+)
    AND PCLANC.NUMADIANTAMENTO = A.NUMADIANTAMENTO(+)
    AND PCLANC.CODFUNCBAIXA = PCEMPR.MATRICULA(+)
    AND PCLANC.IDCONTROLEEMBARQUE = PCPEDIDO.IDCONTROLEEMBARQUE(+)
    AND PCLANC.NUMTRANS = PCMOVCR.NUMTRANS(+)
    AND NVL(PCMOVCR.ESTORNO, 'N') = 'N'
    AND PCLANC.CODFORNEC = FCLI.CODCLI(+)
    AND PCLANC.CODFORNEC = FFOR.CODFORNEC(+)
    AND PCLANC.CODFORNEC = FUSU.CODUSUR(+)
    AND PCLANC.CODFORNEC = FEMP.MATRICULA(+)
    AND PCLANC.CODCONTA NOT IN (SELECT NVL(CODCONTRECJUR, 0) FROM PCCONSUM)
    AND PCLANC.TIPOPARCEIRO = 'F'
    AND PCMOVCR.DTCOMPENSACAO >= '01/08/2023'
    AND PCMOVCR.DTCOMPENSACAO <= '31/08/2023'
    AND PCLANC.DTESTORNOBAIXA IS NULL
    AND PCLANC.HISTORICO <> 'REF.CANCEL.BORDERO JA BAIXADO'
    AND PCLANC.HISTORICO <> 'REF.CANCEL.CHEQUE JA BAIXADO'
    AND NVL(PCLANC.CODROTINABAIXA, 0) NOT IN (737)
    AND PCLANC.CODFILIAL IN ('2', '3', '4')
    AND PCLANC.CODCONTA NOT IN (SELECT NVL(CODCONTAJUSTEEST, 0) FROM PCCONSUM)
    AND (PCLANC.CODCONTA NOT IN (SELECT NVL(CODCONTRECJUR, 0) FROM PCCONSUM))
    AND (PCLANC.CODCONTA NOT IN (SELECT NVL(CODCONTDESCCONC, 0) FROM PCCONSUM))
    AND NVL(PCLANC.VPAGO, 0) > 0
    AND (
      (PCLANC.NUMBORDERO IS NOT NULL)
      OR (PCLANC.NUMCHEQUE IS NOT NULL)
      OR (DECODE(PCLANC.NUMBANCO, 0, '', PCLANC.NUMBANCO) IS NOT NULL)
      OR (SUBSTR(PCMOVCR.HISTORICO2, 0, 17) = 'VL.PAGTO.CF.CAIXA')
      OR PCLANC.CODROTINABAIXA IN (631, 638, 772, 1238)
    )
    AND (NVL(PCLANC.HISTORICO2, 'X0XOXX0XXLXX') <> 'PAGTO COM ADIANT. FORNEC')
    AND (NVL(PCLANC.TIPOPAGTO, 'X0L') <> 'CRE')
    AND PCLANC.NUMTRANS IS NOT NULL
    AND NVL(PCLANC.CODROTINABAIXA, 0) NOT IN (1103)
    AND PCLANC.CODCONTA <> PCCONSUM.CODCONTASOBRACAIXA
    AND (
      (SELECT COUNT(*)
      FROM PCLIB
      WHERE CODFUNC = 16.000000
      AND CODTABELA = 10
      AND CODIGOA IN (SELECT CODIGOCENTROCUSTO FROM PCRATEIOCENTROCUSTO WHERE RECNUM = PCLANC.RECNUM)) > 0
      OR NOT EXISTS (
        SELECT CODIGOCENTROCUSTO
        FROM PCRATEIOCENTROCUSTO
        WHERE RECNUM = PCLANC.RECNUM
      )
    )
) TABELA
WHERE
  1 = 1
  AND TABELA.DTCOMPENSACAO >= '01/08/2023'
  AND TABELA.DTCOMPENSACAO <= '31/08/2023'
GROUP BY
  TABELA.TIPO,
  TABELA.DTPAGTO,
  TABELA.DTVENC,
  TABELA.RECNUM,
  TABELA.NUMTRANS,
  TABELA.CODCONTA,
  TABELA.CONTA,
  TABELA.HISTORICO,
  TABELA.DTCOMPENSACAO,
  TABELA.ASSINATURA,
  TABELA.HISTORICO2,
  TABELA.CODFORNEC,
  TABELA.TIPOPARCEIRO,
  TABELA.NUMNOTA,
  TABELA.VALOR,
  TABELA.DESCONTOFIN,
  TABELA.VALORDEV,
  TABELA.TXPERM,
  TABELA.VLVARIACAOCAMBIAL,
  TABELA.VALORPAGAR,
  TABELA.VPAGO,
  TABELA.VPAGOBORDERO,
  TABELA.LOCALIZACAO,
  TABELA.CODPROJETO,
  TABELA.NUMNEGOCIACAO,
  TABELA.TIPOPAGTO,
  TABELA.NUMBANCO,
  TABELA.NUMCHEQUE,
  TABELA.NUMBORDERO,
  TABELA.GRUPOCONTA,
  TABELA.BLOQUEADO,
  TABELA.NOMEFUNC,
  TABELA.DUPLIC,
  TABELA.CODFILIAL,
  TABELA.NUMTRANSADIANTFOR,
  TABELA.NOME,
  TABELA.COTACAO,
  TABELA.VALORMOEDAESTRANG,
  TABELA.MOEDAESTRANGEIRA,
  TABELA.NOMEMOEDAESTRANGEIRA,
  TABELA.COTACAOBAIXA,
  TABELA.VALORCOTACAOBAIXA,
  TABELA.VALOR_DIF_ENT_SAIDA,
  TABELA.NUMDIIMPORTACAO,
  TABELA.CONTACONTABIL,
  TABELA.NUMCONTRATOCAMBIO,
  TABELA.NUMTRANS_PCMOVCR,
  TABELA.NUMTRANS,
  TABELA.TIPOPAGAMENTO,
  TABELA.VALORUTILIZADO,
  TABELA.VALORRESTANTE,
  TABELA.PARCEIRO,
  TABELA.VALORPAGO,
  TABELA.STATUSPRESTACAOCONTA,
  TABELA.NUMPRESTACAOCONTA,
  TABELA.PROJETO,
  TABELA.MOTIVOPRESTACAOCONTA,
  TABELA.STATUSADIANTAMENTO,
  TABELA.NUMADIANTAMENTO,
  TABELA.VALORADIANTAMENTO,
  TABELA.PARCELA
ORDER BY
  TABELA.DTPAGTO,
  PARCEIRO