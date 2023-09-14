SELECT COALESCE(NULLIF('NF-e: ' || NVL(PCPEDC.NUMNOTA, '0') || ' | COD.AGC: ' || NVL(PCPEDC.CODCONTATO, '0') || ' | AGC: ' || NVL(PCCONTATO.NOMECONTATO, '0'), 'NF-e: 0 | COD.AGC: 0 | AGC: 0'), 'NÃO POSSUI AGENCIADOR') AS Resultado
from PCPEDC
join PCCONTATO on PCPEDC.CODCONTATO = PCCONTATO.CODCONTATO 
where NUMNOTA ='87079';

--
select 
  case 
    when (select count(*) from PCPEDC where CODCONTATO is null and NUMNOTA='870791') is null THEN
      'NF-e: ' || PCPEDC.NUMNOTA || ': NÃO POSSUI AGENCIADOR'
    when (select count(*) from PCPEDC where  NUMNOTA='870791') = (select 1 from PCPEDC where NUMNOTA = '870791') then
      'N° NOTA INEXISTENTE'
    else
      'NF-e: ' || PCPEDC.NUMNOTA || ' | COD.AGC: ' || PCPEDC.CODCONTATO || ' | AGC: ' || PCCONTATO.NOMECONTATO
  end as Resultado
from PCPEDC
left join PCCONTATO on PCPEDC.CODCONTATO = PCCONTATO.CODCONTATO
where NUMNOTA='870791';



select 
  case 
    when  PCPEDC.CODCONTATO  is null then 
      'NF-e: ' || PCPEDC.NUMNOTA || ': NÃO POSSUI AGENCIADOR'
    when  (select case when count(*) = 0 then 600 else count(*) end as Result 
      from PCPEDC where 
        NUMNOTA = ('') 
     or NUMPED = ('1114001911')
     and PCPEDC.CODCONTATO is not null and PCPEDC.NUMNOTA is not null)
     = 600 then
      'N° NOTA INEXISTENTE'
    when NUMNOTA = 0 then 
      'N° PADRÃO'
    else
      'NF-e: ' || PCPEDC.NUMNOTA || ' | COD.AGC: ' || PCPEDC.CODCONTATO || ' | AGC: ' || PCCONTATO.NOMECONTATO
  end as Resultado
from PCPEDC
left join PCCONTATO on PCPEDC.CODCONTATO = PCCONTATO.CODCONTATO
where  
NUMNOTA = ('')
or NUMPED = ('1114001911')
fetch first 1 rows only 
;