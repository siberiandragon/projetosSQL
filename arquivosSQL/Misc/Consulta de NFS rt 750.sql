SELECT DISTINCT
         PCLANC.RECNUM,
         PCLANC.DTLANC,  
         PCLANC.DTVENC,
         PCLANC.DTEMISSAO,         
         PCLANC.NUMNOTA,
         NVL(PCLANC.DUPLIC, 1) AS DUPLIC, 
         PCLANC.VALOR,                 
         PCLANC.CODFILIAL,                       
         PCLANC.CODCONTA,         
         (SELECT CONTA FROM PCCONTA WHERE CODCONTA = PCLANC.CODCONTA) CONTA,         
         PCLANC.HISTORICO,         
         NVL(PCLANC.NFSERVICO,'N') AS NFSERVICO,
		 PCLANC.FUNCBLOQ,
		 PCLANC.OBSBLOQ,
		 PCLANC.DTBLOQ
FROM
PCLANC,
PCCONTA,
PCRATEIOPADRAOCONTA,
PCRATEIOCONTAS,
PCPROJETO,
PCVEICUL                                                 
WHERE 0=0
AND PCLANC.CODCONTA = PCCONTA.CODCONTA   
AND PCLANC.CODFILIAL IN (DECODE((SELECT COUNT(*) 
                                 FROM PCLIB WHERE CODFUNC=16    
								 AND CODTABELA=1 
								 AND CODIGOA='99'),0,(SELECT CODIGOA 
								                      FROM PCLIB     
													  WHERE CODTABELA=1 
													  AND CODFUNC=16 
													  AND CODIGOA= PCLANC.CODFILIAL),PCLANC.CODFILIAL))
AND PCLANC.RECNUM = PCRATEIOCONTAS.RECNUM(+)
AND PCRATEIOCONTAS.CODRATEIOCONTA = PCRATEIOPADRAOCONTA.CODRATEIOCONTA(+)  
AND PCCONTA.GRUPOCONTA IN(SELECT DISTINCT (PCGRUPO.CODGRUPO) 
                          FROM PCGRUPO, 
						       PCLIB 
					      WHERE (((PCGRUPO.CODGRUPO <> 9999) 
AND EXISTS  (SELECT L.CODIGON  
             FROM PCLIB L  
			 WHERE L.CODTABELA = PCLIB.CODTABELA 
			 AND L.CODFUNC = PCLIB.CODFUNC 
			 AND L.CODIGON = 9999)) 
OR ((PCGRUPO.CODGRUPO IN (SELECT L.CODIGON 
                          FROM PCLIB L 
						  WHERE L.CODTABELA = 6 
						  AND L.CODFUNC = PCLIB.CODFUNC)) 
AND NOT EXISTS (SELECT L.CODIGON 
                FROM PCLIB L  
				WHERE L.CODTABELA = PCLIB.CODTABELA 
				AND L.CODFUNC = PCLIB.CODFUNC 
				AND L.CODIGON = 9999))) 
AND PCLIB.CODTABELA = 6            
AND PCLIB.CODFUNC = 16 )  
AND (((TIPOPARCEIRO = 'F') 
AND (EXISTS (SELECT L.CODIGON 
             FROM PCLIB L 
			 WHERE L.CODTABELA = 3 
			 AND L.CODFUNC = 16                
			 AND ((L.CODIGON = PCLANC.CODFORNEC)
			 OR (L.CODIGON = '999999')))))
OR (TIPOPARCEIRO <> 'F'))                        
AND PCLANC.CODFILIAL IN  ( '2' )
AND PCLANC.DTLANC BETWEEN '15/03/2024' AND '15/03/2024' 
AND NOT ((PCLANC.VPAGO = 0)
AND PCLANC.NFSERVICO = 'S'
AND (PCLANC.DTESTORNOBAIXA IS NOT NULL))  
AND PCLANC.CODPROJETO = PCPROJETO.CODPROJETO(+)  
AND PCLANC.FROTA_CODVEICULO = PCVEICUL.CODVEICULO(+)   
ORDER BY RECNUM 