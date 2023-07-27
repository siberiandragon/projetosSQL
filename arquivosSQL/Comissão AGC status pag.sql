
select case when count(*) = 0 then 'EM ABERTO' when sum(case when PCLANC.VPAGOBORDERO is not null and PCLANC.DTASSINATURA is not null then 1 else 0 end) = count(*) then 'PAGO' when sum(case when PCLANC.VPAGOBORDERO is null and PCLANC.DTASSINATURA is null then 1 else 0 end) = count(*) then 'EM ABERTO' else 'PAGO PARCIALMENTE' end as STATUS from PCLANC where (PCLANC.VALOR >= 0 or PCLANC.VPAGO >= 0)   and PCLANC.HISTORICO = '87317'    and PCLANC.CODFORNEC = '525';




select 
  case
    when count(*) = 0 then 'EM ABERTO'
    when SUM(case when PCLANC.VPAGOBORDERO is not null and PCLANC.DTASSINATURA is not null and (PCLANC.DTDESD is null or PCLANC.DTASSINATURA is not null) then 1 else 0 end) = count(*) then 'PAGO'
    when SUM(case when PCLANC.VPAGOBORDERO is null and PCLANC.DTASSINATURA is null and (PCLANC.DTDESD is null or PCLANC.DTASSINATURA is not null) then 1 else 0 end) = count(*) then 'EM ABERTO'
    else 'PAGO PARCIALMENTE'
  end as STATUS
from PCLANC
where (PCLANC.VALOR >= 0 or PCLANC.VPAGO >= 0)
and (PCLANC.DTDESD is null or PCLANC.DTASSINATURA is not null)
and PCLANC.HISTORICO = '85252'
and PCLANC.CODFORNEC = '568'
;
