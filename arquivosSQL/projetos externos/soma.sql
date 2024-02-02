       select 
            sum(L.VALOR) 
        from PCLANC L 
        where 0=0
            and L.RECNUMPRINC <> L.RECNUM 
            and L.VALOR > 0 
            and L.DTASSINATURA is null 
            and L.TIPOPARCEIRO = 'R' 
            and L.RECNUMPRINC = 89364;