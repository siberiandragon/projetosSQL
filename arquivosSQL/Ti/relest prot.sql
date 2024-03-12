with NEO AS (
    select '01|RELEST|100|' || replace(to_char(to_date(E.DTGERACAO, 'DD/MM/YY'), 'YYYY/MM/DD'), '/', '') || replace(to_char(SYSDATE,'HH24MISS'), '/', '') || '|' ||
                           replace(to_char(to_date(E.DTGERACAO, 'DD/MM/YY'), 'YYYY/MM/DD'), '/', '') || replace(to_char(SYSDATE,'HH24MI'), '/', '') || '|' ||
                           replace(to_char(to_date(E.DTGERACAO, 'DD/MM/YY'), 'YYYY/MM/DD'), '/', '')|| '|' ||
                           replace(to_char(to_date(E.DTGERACAO, 'DD/MM/YY'), 'YYYY/MM/DD'), '/', '')|| '|' ||
       (case 
           when E.CODFILIAL = '2' then (select CGC from PCFILIAL where CODIGO = '2')
           when E.CODFILIAL = '3' then (select CGC from PCFILIAL where CODIGO = '3')                                                                                                      
           when E.CODFILIAL = '4' then (select CGC from PCFILIAL where CODIGO = '4')
           else E.CODFILIAL 
       end) || '|82901000000127' as Neogrid
    from PCHISTEST E
    join PCPRODUT P on E.CODPROD = P.CODPROD
    where 0=0
    and E.DATA = '04/03/2024'
    and E.CODFILIAL = '2'
    and P.CODMARCA = '2'
    and E.CODFILIAL in ('2')
and P.CODFORNEC in ('12946','12810','12879','13224','13163','13092','13884')
and P.OBS2 <> 'FL'
and P.TIPOMERC ='L'
and P.CODAUXILIAR is not null
fetch first 1 rows only
)
select * from NEO
union all
select '02|' || replace(to_char(to_date(E.DTGERACAO, 'DD/MM/YY'), 'YYYY/MM/DD'), '/', '')|| '|' || E.CODPROD || '|' || E.CODAUXILIAR || '|' || E.QTEST || '|' || '0.00' AS est
from PCHISTEST E
join PCPRODUT P on E.CODPROD = P.CODPROD
where 0=0
and E.DATA = '04/03/2024'
and E.CODFILIAL in ('2')
and P.CODMARCA = '2'
and P.CODFORNEC in ('12946','12810','12879','13224','13163','13092','13884')
and P.OBS2 <> 'FL'
and p.TIPOMERC ='L'
and P.CODAUXILIAR is not null
