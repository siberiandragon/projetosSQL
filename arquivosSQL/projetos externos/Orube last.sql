SELECT
    CASE
        WHEN (SELECT SUM(L2.valor) - SUM(L2.vpago)
              FROM PCLANC L2
              WHERE L2.RECNUMPRINC <> L2.RECNUM
                AND L2.VALOR > 0
                AND L2.TIPOPARCEIRO = 'R'
                AND L2.RECNUMPRINC = L.RECNUMPRINC
              GROUP BY L2.RECNUMPRINC) = 0 
        THEN 'PAGO'
        WHEN (SELECT SUM(L3.VALOR) - SUM(L3.VPAGO)
              FROM PCLANC L3
              WHERE L3.RECNUMPRINC <> L3.RECNUM
                AND L3.VALOR > 0
                AND L3.TIPOPARCEIRO = 'R'
                AND L3.RECNUMPRINC = L.RECNUMPRINC) <> 0
        THEN 'PARCIALEMTE PAGO'
        ELSE 'ABERTO'
    END AS STATUS
FROM
    PCLANC L
where 0=0
and (
     (L.RECNUMPRINC <> L.RECNUM 
      and L.VALOR > 0 
      and L.DTASSINATURA is null 
      and L.TIPOPARCEIRO = 'R')
       or
     (L.RECNUMPRINC = L.RECNUM 
      and L.VALOR > 0 
      and L.TIPOPARCEIRO = 'R' 
      or not exists (
                      select 1 
                      from PCLANC L6 
                      where L6.RECNUMPRINC <> L6.RECNUM 
                      and L6.RECNUMPRINC = L.RECNUMPRINC
                                              )
     )
    )
    and L.RECNUMPRINC = '89525'
    fetch first 1 rows only;
