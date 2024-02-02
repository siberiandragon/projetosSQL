SELECT L.RECNUMPRINC,L.*
FROM PCLANC L
WHERE 0 = 0
    AND 
        (L.RECNUMPRINC = L.RECNUM 
         AND L.VALOR > 0 
         AND L.DTASSINATURA IS NULL 
         AND L.TIPOPARCEIRO = 'R'
         or
        (SELECT SUM(L3.VALOR) - SUM(L3.VPAGO)
         FROM PCLANC L3
         WHERE L3.RECNUMPRINC <> L3.RECNUM
             AND L3.VALOR > 0
             AND L3.TIPOPARCEIRO = 'R'
             AND L3.RECNUMPRINC = L.RECNUMPRINC) = (select sum(L8.VALOR)
                                                    from PCLANC L8
                                                    WHERE L8.RECNUMPRINC <> L8.RECNUM
             AND L8.VALOR > 0
             AND L8.TIPOPARCEIRO = 'R'
             AND L8.RECNUMPRINC = L.RECNUMPRINC)
    ) 
    and L.RECNUMPRINC = L.RECNUM
    and L.VPAGO is null
    and L.DTASSINATURA is null
and L.RECNUMPRINC = 89309 and L.DUPLIC = 4
