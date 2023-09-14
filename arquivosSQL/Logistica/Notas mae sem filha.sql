select p7.CODFILIAL as FILIAL,
            p7.DATA as DATA_PEDIDO,
             PCNFSAID.NUMNOTA as NOTA,
              p7.NUMPED as PEDIDO,
               PCUSUARI.NOME,
                PCNFSAID.DTSAIDA as DATA_NOTA,
                 PCCLIENT.CLIENTE,
                  PCNFSAID.VLTOTAL as TOTAL
from PCPEDC p7
left join PCNFSAID on p7.NUMPED = PCNFSAID.NUMPED
left join PCCLIENT on p7.CODCLI = PCCLIENT.CODCLI
left join PCUSUARI on p7.CODUSUR = PCUSUARI.CODUSUR
where 
    p7.CONDVENDA = '7'
    and p7.NUMPED not in (
        select p8.NUMPEDENTFUT
        from PCPEDC p8
        where p8.CONDVENDA = '8'
    )
and
p7.DATA 
between 
'01/07/2023'
and 
'07/07/2023'
and p7.POSICAO in ('M','F','L')
and PCNFSAID.DTDEVOL is null
and PCNFSAID.DTCANCEL is null;

--MARK 2 (pre-venda)
select p7.CODFILIAL as FILIAL,
            p7.DATA as DATA_PEDIDO,
             PCNFSAID.NUMNOTA as NOTA,
              p7.NUMPED as PEDIDO,
               PCUSUARI.NOME,
                PCNFSAID.DTSAIDA as DATA_NOTA,
                 PCCLIENT.CLIENTE,
                  PCNFSAID.VLTOTAL as TOTAL
from PCPEDC p7
left join PCNFSAID on p7.NUMPED = PCNFSAID.NUMPED
left join PCCLIENT on p7.CODCLI = PCCLIENT.CODCLI
left join PCUSUARI on p7.CODUSUR = PCUSUARI.CODUSUR
where 
    p7.CONDVENDA = '7'
    and p7.NUMPED not in (
        select p8.NUMPEDENTFUT
        from PCPEDC p8
        where p8.CONDVENDA = '8'
    )
and
p7.DATA 
between 
'01/07/2023'
and 
'07/07/2023'
and p7.CODUSUR = '1062'
and p7.POSICAO in ('M','F','L')
and PCNFSAID.DTDEVOL is null
and PCNFSAID.DTCANCEL is null;

