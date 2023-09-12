select  
       PCPEDC.NUMPED as PEDIDO,
        PCCLIENT.CLIENTE,
         PCPEDC.DATA as DT_PEDIDO,
          to_char(PCPEDC.DTFIMDIGITACAOPEDIDO, 'HH24:MI:SS') as LIBERADO,
           trunc (PCPEDC.DTINICIALSEP) as EM_SEPARAÇÂO,
            nvl(to_char(PCPEDC.DTEMISSAOMAPA, 'HH24:MI:SS'), '  ') as  INI_SEP,
             trunc(PCPEDC.DTFINALCHECKOUT) as DT_CONFER,
              to_char(PCPEDC.DTFINALCHECKOUT, 'HH24:MI:SS') as CONFERIDO,
               nvl(to_char(PCPEDC.HORAFAT, '00') || ':' || to_char(PCPEDC.MINUTOFAT, '00'), '  ') as FINALIZADO_FAT
from PCPEDC
left join PCNFSAID on PCPEDC.NUMPED = PCNFSAID.NUMPED
left join PCCLIENT on PCPEDC.CODCLI = PCCLIENT.CODCLI
where 0=0 
and PCPEDC.CONDVENDA in ('1','8')
and PCPEDC.POSICAO in ('M','L','F')
and PCPEDC.ORIGEMPED ='R'
and PCPEDC.CODFILIAL = '2'
and trunc(PCPEDC.DTFIMDIGITACAOPEDIDO) = trunc(SYSDATE)
and to_char(PCPEDC.DTFIMDIGITACAOPEDIDO, 'HH24:MI:SS') >= to_char(SYSDATE - 2/24, 'HH24:MI:SS')
;

select  
       PCPEDC.NUMPED as PEDIDO,
        PCCLIENT.CLIENTE,
         PCPEDC.DATA as DT_PEDIDO,
          nvl(to_char(PCPEDC.DTFIMDIGITACAOPEDIDO, 'HH24:MI:SS'), '  ') as LIBERADO,
           nvl(to_char(PCPEDC.DTEMISSAOMAPA, 'HH24:MI:SS'), '  ') as  INI_SEP,
            nvl(to_char(PCPEDC.DTINICIALCHECKOUT, 'HH24:MI:SS'), '  ') as SEPARADO,
             nvl(to_char(PCPEDC.HORAFAT, '00') || ':' || to_char(PCPEDC.MINUTOFAT, '00'), '  ') as FINALIZADO_FAT
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
;


 select  
       PCPEDC.NUMPED as PEDIDO,
         PCPEDC.DATA as DT_PEDIDO,
          nvl(to_char(PCPEDC.DTFIMDIGITACAOPEDIDO, 'HH24:MI:SS'), '  ') as LIBERADO,
           nvl(to_char(PCPEDC.DTEMISSAOMAPA, 'HH24:MI:SS'), '  ') as  INI_SEP,
            nvl(to_char(PCPEDC.DTINICIALCHECKOUT, 'HH24:MI:SS'), '  ') as SEPARADO,
             nvl(to_char(PCPEDC.HORAFAT, '00') || ':' || to_char(PCPEDC.MINUTOFAT, '00'), '  ') as FINALIZADO_FAT
             from PCPEDC
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
;


select distinct POSICAO from PCPEDC

