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
and (VALOR >= 0 or VPAGO >= 0);



SELECT
*
FROM PCLANC
WHERE CODFORNEC = '145'
AND HISTORICO LIKE ('%86798%')
--AND VPAGO is null
--and VALOR >=0;
;

SELECT
  PCLANC.*,
  CASE
    WHEN VPAGO IS NULL AND DTPAGTO IS NULL AND COUNT(*) OVER () = 1 THEN 'EM ABERTO'
    WHEN VPAGOBORDERO IS NOT NULL AND DTASSINATURA IS NOT NULL AND VALOR = (
      SELECT VALOR
      FROM PCLANC
      WHERE CODFORNEC = '145'
      and HISTORICO LIKE ('%86386%')
      AND (VALOR >= 0 OR VPAGO >= 0)
    --  AND DTDESD IS NOT NULL
  --    AND DTASSINATURA IS NOT NULL
      ORDER BY DTPAGTO ASC
      FETCH FIRST 1 ROW ONLY
    ) THEN 'PAGO'
    WHEN VPAGOBORDERO IS NOT NULL AND DTASSINATURA IS NOT NULL THEN 'PAGO PARCIALMENTE'
  END AS STATUS
FROM PCLANC
WHERE CODFORNEC = '145'
and HISTORICO = '86386'
AND (VALOR >= 0 OR VPAGO >= 0)
AND (DTDESD IS NULL OR DTASSINATURA IS NOT NULL)
-- FETCH FIRST 1 ROW ONLY
;




select
  case
    when count(*) = 0 then 'EM ABERTO'
    when sum(case when PCLANC.VPAGOBORDERO is not null and PCLANC.DTASSINATURA is not null then 1 else 0 end) = count(*) then 'PAGO'
    when sum(case when PCLANC.VPAGOBORDERO is null and PCLANC.DTASSINATURA is null then 1 else 0 end) = count(*) then 'EM ABERTO'
    else 'PAGO PARCIALMENTE'
  end as STATUS
from PCLANC
where (PCLANC.VALOR >= 0 or PCLANC.VPAGO >= 0)
  and
  PCLANC.HISTORICO = '88097'
  and PCLANC.CODFORNEC = '145';


--'2134' '16565' (PAGO)
--'75'   '84752' (PARCIAL)
--'530'  '86512' (EM ABERTO/ bordero não assinado)
--'2006' '48607' (EM ABERTO/ sem titulos inclusos)
--14130680000172

select * from PCFORNEC 
where CODFORNEC = '568';

select PCFORNEC.CODFORNEC from PCCONTATO
join PCFORNEC on PCCONTATO.CGCCPF = PCFORNEC.CGC
where PCCONTATO.CGCCPF='14130680000172'
and PCCONTATO.CODCONTATO='1551';


select PCFORNEC.CODFORNEC
from  PCCONTATO
join PCFORNEC on regexp_replace(PCCONTATO.CGCCPF, '[^0-9]', '') = PCFORNEC.CGC
where PCCONTATO.CGCCPF = '08067399000130'
and PCCONTATO.CODCONTATO = '1234'
;

select * from PCCONTATO
where CODCONTATO='1123'
--and
--CGCCPF='7659256000154';
;

select * from PCCONTATO
where length(CGCCPF) = 11;

select * from PCLANC
where length(HISTORICO) = 5;

UPDATE PCLANC
SET HISTORICO = 'COMISSÃO - NF ' || REGEXP_SUBSTR(HISTORICO, '\d+')
WHERE HISTORICO LIKE '%COMISSÃO - NF%';

UPDATE PCLANC
SET HISTORICO = REGEXP_REPLACE(HISTORICO, 'COMISSÃO - NF (\d+)', '\1')
WHERE HISTORICO LIKE '%COMISSÃO - NF%';


update PCLANC
set HISTORIC

select PCFORNEC.CODFORNEC
from  PCCONTATO
join PCFORNEC on regexp_replace(PCCONTATO.CGCCPF, '[^0-9]', '') = PCFORNEC.CGC
where PCCONTATO.CGCCPF = '07659256000154'
and PCCONTATO.CODCONTATO = '756';

select * from PCFORNEC;

 -- Value :=consultaSQL(' select case when sum(case when VPAGOBORDERO is not null and DTASSINATURA is not null then 1 else 0 end) = count(*) then 'PAGO'    when sum(case when VPAGOBORDERO is null and DTASSINATURA is null then 1 else 0 end) = count(*) then 'EM ABERTO'    else 'PAGO PARCIALMENTE'  end as STATUS from PCLANC where CODFORNEC = '''++''' and  HISTORICO like ('''+ +''')  and (VALOR >= 0 or VPAGO >= 0);
 select * from PCLANC;
 
 select * from PCCONTATO 
 where CODCLI='18800' 
 ;
 

select * from PCCONTATO
where length(CGCCPF) = 15;

update PCCONTATO
SET CGCCPF = SUBSTR(CGCCPF, 2)
WHERE LENGTH(CGCCPF) = 12;

UPDATE PCCONTATO
SET CGCCPF = CONCAT('0', REGEXP_REPLACE(CGCCPF, '[^0-9]', ''))
WHERE LENGTH(CGCCPF) = 10;

UPDATE PCFORNEC
SET CGC = CONCAT('0', REGEXP_REPLACE(CGC, '[^0-9]', ''))
WHERE LENGTH(CGC) = 13;



 select 
   case 
   when count(*) = 0 then 'EM ABERTO' 
   when SUM(case when PCLANC.VPAGOBORDERO is not null and PCLANC.DTASSINATURA is not null and (PCLANC.DTDESD is null or PCLANC.DTASSINATURA is not null) then 1 else 0 end) = count(*) then 'PAGO'
    when SUM(case when PCLANC.VPAGOBORDERO is null and PCLANC.DTASSINATURA is null and (PCLANC.DTDESD is null or PCLANC.DTASSINATURA is not null) then 1 else 0 end) = count(*) then 'EM ABERTO' else 'PAGO PARCIALMENTE' end as STATUS
     from PCLANC
     join  VW_COMISSAO_AGENCIADA on PCLANC.HISTORICO = VW_COMISSAO_AGENCIADA.NUMNOTA
      where (PCLANC.VALOR >= 0 or PCLANC.VPAGO >= 0) and (PCLANC.DTDESD is null or PCLANC.DTASSINATURA is not null) and PCLANC.HISTORICO = '48790' and PCLANC.CODFORNEC = '460' ;
   
   
select * from PCLANC
where HISTORICO ='16565';

select * from VW_COMISSAO_AGENCIADA
where NUMNOTA = '16565';


--MARK 2 (alteração na condição de  PAGO PARCIALMENTE, para contornar a não inclusão dos titulos na PCLANC mas a necessidade de referêncialos)
select 
    case
        when (select count(*) from PCLANC where HISTORICO = '87693') <> (select count(*) from VW_COMISSAO_AGENCIADA where NUMNOTA = '87693') then 'PAGO PARCIALMENTE'
        when count(*) = 0 then 'EM ABERTO' 
        when sum(case when PCLANC.VPAGOBORDERO is null and PCLANC.DTASSINATURA is null and (PCLANC.DTDESD is null or PCLANC.DTASSINATURA is not null) then 1 else 0 end) = count(*) then 'EM ABERTO' 
        else 'PAGO' 
   end as STATUS
from 
    PCLANC
where 
    (PCLANC.VALor >= 0 or PCLANC.VPAGO >= 0) 
    and (PCLANC.DTDESD is null or PCLANC.DTASSINATURA is not null) 
    and PCLANC.HISTORICO = '87693' 
    and PCLANC.CODFORNEC = '530'
    group by PCLANC.HISTORICO
    ;

--MARK 2.1( projeto para trazer o valor das parcelas em aberto referente a nota e a parcela consultada)
select 
     case when (select count(*) from PCLANC where HISTORICO = '48790') <> (select count(*) from VW_COMISSAO_AGENCIADA where NUMNOTA = '48790') then VW_COMISSAO_AGENCIADA.VALOR
     else 0
end STSAS
from PCLANC
join VW_COMISSAO_AGENCIADA on PCLANC.HISTORICO = VW_COMISSAO_AGENCIADA.NUMNOTA
where 
    (PCLANC.VALOR >= 0 or PCLANC.VPAGO >= 0) 
    and (PCLANC.DTDESD is null or PCLANC.DTASSINATURA is not null) 
    and PCLANC.HISTORICO = '48790' 
    and PCLANC.CODFORNEC = '460'
    and VW_COMISSAO_AGENCIADA.PREST ='3'
    fetch first 1 rows only;

--MARK 3 (adição de mais condições referente ao retornos nulos da tabela PCLANC e a referência da mesma com VW_COMISSAO_AGENCIADA para gerar o resultadod e PAGO PARCIALMENTE)
select 
    case
        when count(*) = 0 then 'EM ABERTO'
        when (select count(*) from PCLANC where HISTORICO = '87079') <> (select count(*) from VW_COMISSAO_AGENCIADA where NUMNOTA = '87079') and EXISTS (select 1 from PCLANC where HISTORICO = '87079') then 'PAGO PARCIALMENTE'
        when sum(case when PCLANC.VPAGOBORDERO is not null and PCLANC.DTASSINATURA is not null then 1 else 0 end) = count(*) then 'PAGO'
        when (select count(*) from VW_COMISSAO_AGENCIADA where NUMNOTA = '87079' and (VPAGO is null or VPAGO = 0)) = (select count(*) from VW_COMISSAO_AGENCIADA where NUMNOTA = '87079') then 'EM ABERTO'
        when sum(case when PCLANC.VPAGOBORDERO is null and PCLANC.DTASSINATURA is null then 1 else 0 end) = count(*) then 'EM ABERTO' 
        else 'PAsGO' 
   end as EM_ABERTO
from 
    PCLANC
where 
    (PCLANC.VALOR >= 0 or PCLANC.VPAGO >= 0) 
    and 
    (PCLANC.DTDESD is null or PCLANC.DTASSINATURA is not null) 
    and 
    PCLANC.HISTORICO = '87079' 
    or
    PCLANC.CODFORNEC = '163'
    group by 
    PCLANC.HISTORICO
   -- fetch first 1 rows only
;

--MARK 4 (alteração para considerar a situação da quitação da nota de venda, mas não da comissão. aguardando possiveis retornos de novas situações)
select 
    case
        when count(*) = 0 then 'EM ABERTO'
        when (select count(*) from PCLANC where HISTORICO = '85194') <> (select count(*) from VW_COMISSAO_AGENCIADA where NUMNOTA = '85194') and EXISTS (select 1 from PCLANC where HISTORICO = '85194') then 'PAGO PARCIALMENTE'
        when (select count(*) from PCLANC where HISTORICO = '85194' and PCLANC.VPAGOBORDERO is not null and PCLANC.DTASSINATURA is not null) = 1 then 'PAGO'
        when (select count(*) from VW_COMISSAO_AGENCIADA where NUMNOTA = '85194' and (VPAGO is null or VPAGO = 0)) = (select count(*) from VW_COMISSAO_AGENCIADA where NUMNOTA = '85194') then 'EM ABERTO'
        when sum(case when PCLANC.VPAGOBORDERO is null and PCLANC.DTASSINATURA is null then 1 else 0 end) = count(*) then 'EM ABERTO' 
        else 'EM ABERTO' 
   end as EM_ABERTO
from 
    PCLANC
where 
    (PCLANC.VALOR >= 0 or PCLANC.VPAGO >= 0) 
    or 
    (PCLANC.DTDESD is null or PCLANC.DTASSINATURA is not null) 
    and 
    PCLANC.HISTORICO = '85194' 
    or
    PCLANC.CODFORNEC = '145'
    group by 
    PCLANC.HISTORICO
    fetch first 1 rows only
;