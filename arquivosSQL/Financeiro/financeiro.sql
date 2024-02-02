select * from pclanc where recnum in('119881', '3292');

select  l.* from pclanc l where l.dtvenc between '01/10/2023' and '31/10/2023' order by l.dtlanc ;

select * from pclanc where recnum = 73822;

select 
L.DTLANC as EMISSAO,
L.CODFORNEC,
F.FORNECEDOR,
L.NUMTRANSENT as TRANSACAO,
L.CODCONTA,
C.CONTA as Desc_CONTA,
L.NUMNOTA as NF,
L.RECNUM as LANCTO,
L.DTVENC as VENCIMENTO,
L.VALOR,
L.NFSERVICO      
from PCLANC L
join PCCONTA C on L.CODCONTA = C.CODCONTA 
left join PCFORNEC F on L.CODFORNEC = F.CODFORNEC
where 0=0
and L.CODFORNEC = '13332'
and nvl(L.DTCOMPETENCIA, L.DTLANC) <= '30/09/2023'
and (L.DTPAGTO is null or L.DTPAGTO > '30/09/2023')
and (L.NFSERVICO = 'S' 
or L.CODCONTA in( '100001', '100002','4010003'))
order by L.CODFORNEC
;

order by L.DTLANC  ;


SELECT * FROM PCFORNEC WHERE CODFORNEC = 8