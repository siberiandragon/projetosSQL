SELECT 'N' AS SELECIONADO,
       PCMANIFDESTINATARIO.CODIGO,
       TO_NUMBER(SUBSTR(PCMANIFDESTINATARIO.CHAVENFE, 26, 9)) NUMNOTA,
       SUBSTR(PCMANIFDESTINATARIO.CHAVENFE, 23, 3) SERIE,
       PCMANIFDESTINATARIO.DATAEMISSAO,
       NVL(PCMANIFDESTINATARIO.DATAENTRADA, '') AS DATAENTRADA,
      -- DECODE(NVL(PCNFENT.CODFILIALNF, PCNFENT.CODFILIAL),
         --     PCMANIFDESTINATARIO.CODFILIAL,
         --     NVL(PCNFENT.DTENT, ''),
         --     '') AS DTENT,
       PCMANIFDESTINATARIO.NOME AS FORNECEDOR,
       PCFORNEC.CODFORNEC,
       PCMANIFDESTINATARIO.CNPJCPF,       
       NVL(PCMANIFDESTINATARIO.SITCONFIRMACAODEST, 0) AS SITUACAOMANIF,
       NVL(PCMANIFDESTINATARIO.SITCONFIRMACAODESTANT, 0) AS SITUACAOMANIFANT,
       PCMANIFDESTINATARIO.VLTOTALNFE,
       PCMANIFDESTINATARIO.CHAVENFE,
       PCMANIFDESTINATARIO.DATARECEBDOCUMENTO,
       DECODE(PCMANIFDESTINATARIO.SITUACAONFE,
              1,
              'USO AUTORIZADO',
              2,
              'DENEGADA',
              3,
              'CANCELADA') AS SITUACAONFE,
       DECODE(PCMANIFDESTINATARIO.TIPODOCUMENTO,
              0,
              'NF-e',
              1,
              'CANCELAMENTO',
              2,
              'CC-e') AS TIPODOC,
       DECODE(PCMANIFDESTINATARIO.AMBIENTE,
              'H',
              'HOMOLOGACAO',
              'P',
              'PRODUCAO') AS AMBIENTE,
       PCMANIFDESTINATARIO.JUSTIFICATIVA,
       NVL(PCNFENT.ESPECIE, 'X') AS ESPECIE,
       NVL(PCNFENT.NUMTRANSENT, 0) AS NUMTRANSENT
--Atenção ao alterar ou identar codigos apos o where pois o select é alterado dinamincamente também
  FROM PCFILIAL, PCFORNEC PCFORNEC2, PCMANIFDESTINATARIO, PCFORNEC, PCNFENT

 WHERE 0=0
   and PCMANIFDESTINATARIO.CODFILIAL IN  ('2')
   and PCMANIFDESTINATARIO.CNPJCPF = REPLACE(REPLACE(REPLACE(PCFORNEC.CGC(+), '.', ''), '/', ''), '-', '')
   and PCMANIFDESTINATARIO.CHAVENFE = PCNFENT.CHAVENFE(+)
   and PCMANIFDESTINATARIO.DATAENTRADA is null
   and PCMANIFDESTINATARIO.DATAEMISSAO = PCNFENT.DTEMISSAO(+)---new
   ------------ATENÇÃO COM O CODIGO ABAIXC-----------------                                                                                  
   --subselect abaixo serve para não apresentar notas onde a filial é apenas o transportador da nota, e não o destinatario                   
   and nvl((select pcfornec.cgc
             from pcnfsaid, pcfornec, pcclient
            where pcnfsaid.codfornecfrete = pcfornec.codfornec
              and nvl(pcnfsaid.codfilialnf, pcnfsaid.codfilial) = PCMANIFDESTINATARIO.CODFILIAL
              and exists (select 1 from pcfilial where cgc = pcfornec.cgc)
              and pcnfsaid.codcli = pcclient.codcli
              and pcnfsaid.chavenfe = PCMANIFDESTINATARIO.CHAVENFE
              and pcnfsaid.especie = 'NF'----new
              and pcnfsaid.numnota = TO_NUMBER(SUBSTR(PCMANIFDESTINATARIO.CHAVENFE, 26, 9))----new
              and REPLACE(REPLACE(REPLACE(pcfornec.cgc, '.', ''), '/', ''), '-', '') <> REPLACE(REPLACE(REPLACE(pcclient.cgcent, '.', ''), '/', ''), '-', '')), 'X') <> pcfilial.cgc
   AND NOME IS NOT NULL
   AND VLTOTALNFE IS NOT NULL
   ----------Se for o Op. Logistico não mostrar notas do destinatário ----------                                                             
   AND PCMANIFDESTINATARIO.CHAVENFE NOT IN
       (SELECT I.CHAVENFE
          FROM PCCONHECIMENTOFRETEI I, PCNFSAID S
         WHERE I.CHAVENFE = PCMANIFDESTINATARIO.CHAVENFE
           AND NVL(s.CODFILIALNF, s.CODFILIAL) = PCMANIFDESTINATARIO.CODFILIAL
           AND S.NUMTRANSVENDA = I.NUMTRANSCONHEC
           AND NVL(S.ESPECIE, 'NF') IN ('CO', 'CT', 'CE'))
---------------------------------------------------------                                                                                 
 AND (('VALIDO'  = NVL(PCFORNEC.CGC,'VALIDO'))OR (PCFORNEC.CODFORNEC =  (SELECT MAX(PCFORNEC.CODFORNEC) FROM PCFORNEC  WHERE PCMANIFDESTINATARIO.CNPJCPF = REPLACE(REPLACE(REPLACE(PCFORNEC.CGC,'.',''), '/',''),'-','') )))   
AND NVL(PCMANIFDESTINATARIO.DATAEMISSAO, PCNFENT.DTEMISSAO) BETWEEN '15/03/2024' AND '15/03/2024'
AND NVL(PCMANIFDESTINATARIO.SITCONFIRMACAODEST, 0) IN (0,1,2,3,4)
AND (SUBSTR(PCMANIFDESTINATARIO.CHAVENFE, 7, 14)) <> REPLACE(REPLACE(REPLACE(NVL(PCFORNEC2.CGC, PCFILIAL.CGC),'.',''), '/',''),'-','') 
AND PCFORNEC2.CODFORNEC = PCFILIAL.CODFORNEC
AND PCFILIAL.CODIGO = PCMANIFDESTINATARIO.CODFILIAL
AND NVL(especie, 'X') <> 'OE' 
ORDER BY NUMNOTA 