select * from VW_COMISSAO_AGENCIADA;

select CODFORNEC, NUMNOTA, DUPLIC, VALOR, VPAGO, NUMTRANSENT  from PCLANC
where CODFORNEC='124'
and DTPAGTO
between
to_date('01/06/2023', 'DD/MM/YYYY')  
and
to_date('10/07/2023', 'DD/MM/YYYY')
and 
(VALOR >=0 and VPAGO >=0)
and DTBORDER is null
;


select * from PCLANC
where CODFORNEC='75'
and DTPAGTO
between
to_date('01/06/2000', 'DD/MM/YYYY')  
and
to_date('10/07/2050', 'DD/MM/YYYY')
and 
(VALOR >=0 and VPAGO >=0)
--and DTBORDER is null
;


select CODFORNEC, NUMNOTA, DUPLIC, VALOR, VPAGO, NUMTRANSENT  from PCLANC
where CODFORNEC='124'
and DTPAGTO
between
to_date('01/06/2023', 'DD/MM/YYYY')  
and
to_date('10/07/2023', 'DD/MM/YYYY')
and 
(VALOR >=0 and VPAGO >=0)
and DTBORDER is null
and instr (DUPLIC, '2') > 0
;
--RECNUM(lançamento)

select * from VW_COMISSAO_AGENCIADA
where NUMNOTA='84752';

select * from PCLANC
where CODFORNEC='75'
and HISTORICO like ('%84752%')
and (VALOR >= 0 and VPAGO >= 0) 