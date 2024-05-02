select
       CODCLI,
       CLIENTE,
       CODUSUR,
       VENDEDOR,
       max(TESTE) TOTAL
from(
select 
       V.CODCLI,
       C.CLIENTE,
       V.CODUSUR,
       U.NOME VENDEDOR,
       (sum(nvl(V.VLATEND,0))) teste
from view_vendas_resumo_faturamento V
LEFT join PCCLIENT C on V.CODCLI = C.CODCLI
left join VW_COMISSAO_AGENCIADA W on V.NUMTRANSVENDA = W.NUMTRANSVENDA
left join PCCONTATO T on C.CGCENT = T.CGCCPF
join PCUSUARI U on  V.CODUSUR = U.CODUSUR
where 0=0
and V.CODUSUR in ('1139')
and V.DTSAIDA between SYSDATE - 60 and SYSDATE
and C.SITUACAOECOMMERCEUNILEVER <> 'NAO'
group by V.CODCLI,
         C.CLIENTE,
         V.CODUSUR,
         U.NOME,
         W.CODUSUR2
       
union 

select 
       C.CODCLI,
       C.CLIENTE,
       W.CODVENDEDOR CODUSUR,
       W.VENDEDOR,
       (sum(nvl(W.VALOR,0))) teste
from VW_COMISSAO_AGENCIADA W
join PCCLIENT C on W.CGCCPF = C.CGCENT
where 0=0
and W.CODVENDEDOR in ('1139')
and W.DTSAIDA between SYSDATE - 60 and SYSDATE
and C.SITUACAOECOMMERCEUNILEVER <> 'NAO'
group by C.CODCLI,
         C.CLIENTE,
         W.CODVENDEDOR,
         W.VENDEDOR,
         W.CODUSUR2
       
)
condicao
where TESTE < 2000
group by CODCLI,
        CLIENTE,
        CODUSUR,
        VENDEDOR
        
order by CLIENTE