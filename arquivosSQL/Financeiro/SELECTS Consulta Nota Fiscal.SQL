SELECT 
      DISTINCT N.NUMNOTA,
      N.SITUACAONFE,
      M.CODFISCAL,
      N.DTFAT,
      NVL(N.CODCLINF,N.CODCLI) CODCLI,
      N.TIPOEMPRESA, 
      N.CGC,
      N.IEENT,            
      M.CODPROD,
      C.NITEMXML, 
      T.MENSAGEM,
      M.DESCRICAO,
      M.NBM,
      M.SITTRIBUT,
      M.QT,
      M.QTUNIT,
      round(round(M.qtcont * (nvl(M.punitcont,0) - nvl(M.st,0) - nvl(M.vlipi,0)),2) + round((nvl(M.qtcont,0) * nvl(M.st,0)),2) + round((nvl(M.qtcont,0) * nvl(M.vlipi,0)),2) +
      round((nvl(M.qtcont,0) * nvl(M.vloutros,0)),2) + decode(N.chavenfe, null, nvl(M.qtcont,0) * NVL(M.VLACRESCIMOPF, 0), 0) +  round((nvl(M.qtcont,0) * nvl(M.vlfrete,0)),2),2) VLITEM,
      case when n.codcob = 'TRAN' then 0 else NVL(C.VLSUBTOTDESCONTO, M.VLDESCONTO) end AS VLDESCONTO,
      round(round(M.qtcont * (nvl(M.punitcont,0) - nvl(M.st,0) - nvl(M.vlipi,0)),2) + round((nvl(M.qtcont,0) * nvl(M.st,0)),2) + round((nvl(M.qtcont,0) * nvl(M.vlipi,0)),2) +
      round(round((nvl(M.qtcont,0) * nvl(M.vloutros,0)),2) + decode(N.chavenfe, null, nvl(M.qtcont,0) * NVL(M.VLACRESCIMOPF, 0), 0) +  round((nvl(M.qtcont,0) * nvl(M.vlfrete,0)),2),2)  -NVL(C.VLSUBTOTDESCONTO, M.VLDESCONTO),2) AS VLLIQUIDO,
      M.Percbasered as BASE,
      0.00 AS REDUC,
      ROUND(M.BASEICMS*M.QT ,2)BASEICMS,
      M.PERCICM,
      ROUND(C.VLICMS*QT,2) VLICMS,
      M.BASEICST,
      ROUND(M.ST*QT,2),
      M.ALIQICST,
      M.CODSITTRIBPISCOFINS,
      M.PERPIS, 
      M.VLPIS,
      M.CODSITTRIBPISCOFINS,
      M.PERCOFINS,
      M.VLCOFINS,
      M.PERCIPI,
      ROUND(M.VLIPI*QT,2) VLIPI,
      round(m.qt*M.VLOUTRASDESP,2) OUTRAS_DESPESAS,
      :DATA1,
      :DATA2  
 
FROM PCNFSAID N,
     PCMOV M,
     PCTRIBUT T,
     PCMOVCOMPLE C
WHERE  N.NUMTRANSVENDA = M.NUMTRANSVENDA
AND M.NUMTRANSITEM = C.NUMTRANSITEM
AND    N.NUMNOTA = M.NUMNOTA
AND    T.CODST = M.CODST
AND    M.DTMOV BETWEEN :DATA1  AND :DATA2
AND    NVL(N.CODFILIALNF, N.CODFILIAL) = '1'
AND    (M.TRIBFEDERAL IS NOT NULL OR 'N' = 'N')
AND    N.ESPECIE = 'NF'
AND    M.QTCONT > 0
--AND    M.DTCANCEL IS NULL
AND    M.STATUS IN ('A', 'AB')
--AND N.TIPOEMPRESA IS NOT NULL
ORDER BY M.CODPROD