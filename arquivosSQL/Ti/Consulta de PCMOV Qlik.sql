SELECT 
	F.DTMOV,
	F.CODPROD,
    F.CODFORNEC,
	F.CODOPER,
	F.CODFILIAL,
	F.CODCLI,
	F.CODUSUR,
	F.CODFISCAL,
	F.CODDEVOL,
	F.NUMNOTA,
	F.QT,
	F.PUNIT,
	F.STATUS,
	F.NUMPED,
	F.CUSTOREAL,
	F.VLFRETE,
	F.VLOUTROS,
	F.VLIPI,
	F.VLDESCONTO,
	F.VLOUTRASDESP,
    F.CUSTOULTENT,
    F.QTDEVOL,
    F.PERCOM/100 as PERCOM,
	F.CODICMTAB/100 as CODICMTAB,
    C.CEPCOB,
    S.CODSUPERVISOR,
    (F.CUSTOULTENT * F.QT) + ((F.PERCOM * F.PUNIT)* F.QT) + ((F.CODICMTAB * F.PUNIT)* F.QT) as CUSTO , 
    (F.PUNIT * F.QT) + (F.VLFRETE * F.QT) + (F.VLOUTROS * F.QT) as FATURAMENTO,   
    ((F.CUSTOULTENT * F.QT) + ((F.PERCOM * F.PUNIT)* F.QT) + ((F.CODICMTAB * F.PUNIT)* F.QT)) - ((F.PUNIT * F.QT) + (F.VLFRETE * F.QT) + (F.VLOUTROS * F.QT)) as REC
FROM U_CO1QYD_WI.PCMOV F

LEFT JOIN PCCLIENT C ON C.CODCLI=F.CODCLI
LEFT JOIN PCUSUARI S ON S.CODUSUR=F.CODUSUR

WHERE 
F.CODOPER IN ('S','ED')
AND F.CODFISCAL NOT IN (5117,6117)
AND F.DTCANCEL IS NULL
AND (F.CODDEVOL NOT IN (43) OR F.CODDEVOL IS NULL)
and F.CODUSUR  = '1003'
and F.DTMOV between '01/07/2023' and '31/07/2023';