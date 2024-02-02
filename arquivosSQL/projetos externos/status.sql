select 
       L.CODFILIAL FILIAL,
       L.RECNUM ID,
       L.RECNUMPRINC IDPRINC,
       L.DUPLIC PREST,
       L.DTLANC,
       L.CODFORNEC,
       L.FORNECEDOR,
       L.DTVENC,
       L.VALOR,
       L.DTPAGTO,
       L.VPAGO,
       L.DTASSINATURA,
       L.ASSINATURA,
       case 
       when (select count(*) from PCLANC L2
                             where 0=0
                             and L2.DTASSINATURA is not null 
                             and L2.VPAGO  is not null 
                             and L2.VPAGO > 0 
                             and L2.VALOR > 0 
                             and L2.RECNUMPRINC = L.RECNUMPRINC
                             and L2.DUPLIC = L.DUPLIC
                             ) = 1
       then 'PAGO'
       when (select count(*) from PCLANC L3 
                             where 0=0
                             and L3.DTASSINATURA is not null 
                             and L3.VPAGO  is not null and L.VPAGO > 0      
                             and L3.RECNUMPRINC = L.RECNUMPRINC
                             and L3.DUPLIC = L.DUPLIC
                             ) = 1
       then 'PARCIALMENTE PAGO'
       when (select count(*) from PCLANC L4 
                             where 0=0
                             and L4.RECNUMPRINC = L.RECNUMPRINC
                             and L4.DUPLIC = L.DUPLIC
                             and L.VALOR <> 0
                             ) = 1
                             and L.DTASSINATURA is null 
       then 'EM ABERTO'
       else 'A BAIXAR OU DESDOBRADO'
       end STATUS
from PCLANC L 
where  0=0
and L.RECNUMPRINC = '89364'
--and L.DUPLIC = '1'
--and L.CODFORNEC in ('3002')
--and L.CODFILIAL in ('2','3','4')
and L.DTLANC between '01/12/2023' and '30/12/2023'
and L.TIPOPARCEIRO = 'R'
   