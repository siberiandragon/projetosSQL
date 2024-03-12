SELECT L.*
FROM PCLANC L
WHERE 0 = 0
    AND (
        (L.RECNUMPRINC <> L.RECNUM 
         AND L.VALOR > 0 
         AND L.DTASSINATURA IS NULL 
         AND l.VPAGO IS NULL
         AND L.TIPOPARCEIRO = 'R')
        OR
        (L.RECNUMPRINC = L.RECNUM 
         AND L.VALOR > 0 
         AND L.TIPOPARCEIRO = 'R' 
         OR NOT EXISTS (
                         SELECT 1 
                         FROM PCLANC L6 
                         WHERE 0=0
                             AND L6.TIPOPARCEIRO = 'R'
                             AND L6.RECNUMPRINC <> L6.RECNUM 
                             AND L6.RECNUMPRINC = L.RECNUMPRINC
                       )
        )
        AND
        (SELECT SUM(L3.VALOR) - SUM(L3.VPAGO)
         FROM PCLANC L3
         WHERE 0=0
             AND L3.VALOR > 0
             AND L3.TIPOPARCEIRO = 'R'
             AND L3.RECNUMPRINC = L.RECNUMPRINC) = 0
    )
    and L.RECNUMPRINC = L.RECNUM