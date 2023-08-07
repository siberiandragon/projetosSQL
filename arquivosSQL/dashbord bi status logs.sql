select     
      PCPEDC.NUMPED as PEDIDO,
        PCCLIENT.CLIENTE,
         PCPEDC.DATA as DT_PEDIDO,
         'P - ' || to_char(PCPEDC.DTFIMDIGITACAOPEDIDO, 'HH24:MI' ||'.') as LIBERADO,
         'P - ' || to_char(PCPEDC.DTFIMDIGITACAOPEDIDO, 'HH24:MI' ||'.') as LIBERADODT,
           trunc (PCPEDC.DTINICIALSEP) as EM_SEPARAÇÂO,
         'S - ' || to_char(PCPEDC.DTEMISSAOMAPA, 'HH24:MI' || '.') as  INI_SEP,
         'S - ' || to_char(PCPEDC.DTEMISSAOMAPA, 'HH24:MI' || '.') as  INI_SEP_DT,
             trunc(PCPEDC.DTFINALCHECKOUT) as DT_CONFER,
         'C - ' || to_char(PCPEDC.DTFINALCHECKOUT, 'HH24:MI' || '.') as CONFERIDO,
         'C - ' || to_char(PCPEDC.DTFINALCHECKOUT, 'HH24:MI' || '.') as CONFERIDODT,
         'F - ' || to_char(PCPEDC.HORAFAT, '00') || ':' || to_char(PCPEDC.MINUTOFAT, '00' ||'.') as FINALIZADO_FAT,
         'F - ' || to_char(PCPEDC.HORAFAT, '00') || ':' || to_char(PCPEDC.MINUTOFAT, '00' ||'.') as FINALIZADO_FAT_DT
from PCPEDC
left join PCNFSAID on PCPEDC.NUMPED = PCNFSAID.NUMPED
left join PCCLIENT on PCPEDC.CODCLI = PCCLIENT.CODCLI
where 
PCPEDC.CONDVENDA in ('1','8')
and
PCPEDC.POSICAO in ('M','L','F')
and 
PCPEDC.ORIGEMPED ='R'
and
PCPEDC.CODFILIAL = '2'
and
trunc(PCPEDC.DTFIMDIGITACAOPEDIDO) = trunc(SYSDATE)
and
to_char(PCPEDC.DTFIMDIGITACAOPEDIDO, 'HH24:MI:SS') >= to_char(SYSDATE - 2/24, 'HH24:MI:SS')

