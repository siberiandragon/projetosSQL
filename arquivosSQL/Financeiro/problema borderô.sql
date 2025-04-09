select dtcancel, numtrans, c.* from pclanc c where numbordero = 6134 order by c.dtcancel;
SELECT DTCANCEL, P. * FROM PCLANC P WHERE NUMTRANSENT = 47743 AND DUPLIC = '1' ORDER BY RECNUM;
SELECT * FROM PCLOGALTERACAODADOS WHERE OBSERVACOES LIKE '%375949%';
--UPDATE PCLANC SET NUMBORDERO = NULL,
--                  DTBORDER = NULL,
--                  VPAGOBORDERO = NULL,
--                  NUMBANCO = NULL,
--                  ASSINATURA = NULL, 
--                  DTASSINATURA = NULL, 
--                  TIPOPAGTO = NULL
--WHERE RECNUM = 375949;
