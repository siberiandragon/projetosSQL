select 
    sum(L.VALOR) as VL_APAGAR
from 
    PCLANC L 
where 0=0
and (
     (L.RECNUMPRINC <> L.RECNUM 
      and L.VALOR > 0 
      and L.DTASSINATURA is null 
      and L.VPAGO is null
      and L.TIPOPARCEIRO = 'R')
       or
     (L.RECNUMPRINC = L.RECNUM 
      and L.VALOR > 0 
      and L.TIPOPARCEIRO = 'R' 
      and L.VPAGO is null
      and not exists (
                      select 1 
                      from PCLANC L2 
                      where L2.RECNUMPRINC <> L2.RECNUM 
                      and L2.RECNUMPRINC = L.RECNUMPRINC
                                              )
     )
    )
    and L.RECNUMPRINC = '89559'
