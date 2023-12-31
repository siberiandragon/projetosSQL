    select PCPEDC.CODFILIAL,
            PCPEDC.DATA,
             PCPEDC.NUMPED,
              PCNFSAID.DTSAIDA,
               PCNFSAID.NUMNOTA, 
                PCCLIENT.CLIENTE,
                 PCNFSAID.VLTOTAL
    from PCPEDC
    join PCNFSAID on PCPEDC.NUMPED = PCNFSAID.NUMPED
    left join PCCLIENT on PCPEDC.CODCLI = PCCLIENT.CODCLI
    where 
    PCNFSAID.DTSAIDA
    between
    '01/07/2023'
    and 
    '04/08/2023'
    and 
    PCPEDC.CONDVENDA = '7' 
    and not exists (
        select 1
        from PCPEDC 
        left join PCNFSAID on PCPEDC.NUMPED = PCNFSAID.NUMPED
        where PCPEDC.CONDVENDA = '8'
        and PCPEDC.NUMPEDENTFUT = PCPEDC.NUMPED
    )
    and PCPEDC.NUMPED = '1092002402';            

    SELECT PCPEDC.CODFILIAL,
           PCPEDC.DATA,
           PCPEDC.NUMPED,
           PCNFSAID.DTSAIDA,
           PCNFSAID.NUMNOTA,
           PCCLIENT.CLIENTE,
           PCNFSAID.VLTOTAL
    FROM PCPEDC
    JOIN PCNFSAID ON PCPEDC.NUMPED = PCNFSAID.NUMPED
    LEFT JOIN PCCLIENT ON PCPEDC.CODCLI = PCCLIENT.CODCLI
    WHERE PCNFSAID.DTSAIDA BETWEEN '01/05/2023' AND '04/08/2023'
    AND PCPEDC.CONDVENDA = '7' 
    AND NOT EXISTS (
        SELECT 1
        FROM PCPEDC 
        WHERE PCPEDC.CONDVENDA = '8'
        AND PCPEDC.NUMPEDENTFUT = PCPEDC.NUMPED
        and PCPEDC.NUMPED = '1092002402'
    )
    and PCPEDC.NUMPED = '1092002402'
;

select NUMPEDENTFUT from PCPEDC
where NUMNOTA = '17480';



NUMPEDENTFUT