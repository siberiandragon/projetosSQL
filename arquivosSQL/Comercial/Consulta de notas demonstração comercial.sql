
select 
       S.CONDVENDA TIPO_VENDA,
       decode(S.CONDVENDA,9, 'DEMONSTRAÇÃO', S.CONDVENDA) VENDA,       
       S.NUMNOTA NOTA_SAIDA,
       S.DTFAT,
       S.VLTOTAL VALOR_VENDA, 
       S.CLIENTE,       
       S.CODUSUR RCA,
       U.NOME,
       S.OBS,
       E.NUMNOTA NOTA_DEVOL, 
       E.DTENT,
       C.VLDEVOLUCAO VALOR_DEVOLUCAO,
       C.HISTORICO OBS_CANCEL_DEVOL,
       case 
       when S.DTCANCEL is not null
       then 'NOTA CANCELADA'
       else to_char(S.DTCANCEL)
       end OBS_CANCEL_VENDA       
from PCNFSAID S
left join PCESTCOM C on S.NUMTRANSVENDA = C.NUMTRANSVENDA
left join PCNFENT E on C.NUMTRANSENT = E.NUMTRANSENT
join PCUSUARI U on S.CODUSUR = U.CODUSUR
where 0=0
and S.DTFAT between '01/09/2023' and '30/09/2023'
and S.CODUSUR in ('1011')
and S.CODFILIAL in ('2','3')
and S.CODCLI in ('17810')
and S.NUMNOTA = '1001'
or  E.NUMNOTA = '2002'
and S.CONDVENDA = '9'

;
