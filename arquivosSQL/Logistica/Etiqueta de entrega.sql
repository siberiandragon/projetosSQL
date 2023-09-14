with numeros as (
  select level as repeticao
  from dual
  connect by level <= (select max(NUMVOLUME) 
  from PCNFSAID where NUMNOTA = '89532' 
  and CODFILIALNF = '2' 
  and ESPECIE = 'NF' 
  and DTCANCEL is null)
)
select S.NUMNOTA N_NOTA,
       S.NUMVOLUME,
       numeros.repeticao VOLUMES,
       C.CLIENTE,
       C.ENDERENT ENDERECO,
       C.BAIRROENT BAIRRO,
       C.MUNICENT CIDADE,
       C.CEPENT CEP,
       C.ESTENT UF,
       F.FORNECEDOR TRANSPORTADORA
from PCNFSAID S
join PCCLIENT C on S.CODCLI = C.CODCLI
left join PCFORNEC F on S.CODFORNECFRETE = F.CODFORNEC
join numeros on numeros.repeticao <= S.NUMVOLUME
where S.NUMNOTA = '89532'
  and S.CODFILIALNF = '2'
  and S.ESPECIE = 'NF'
  and S.DTCANCEL is null;

--Mark 2 (ajuste para atender a situação onde o endereço de entrega muda por meio de alteração legitima do vendedor)
with numeros as (
  select level as repeticao
  from dual
  connect by level <= (select max(NUMVOLUME) 
  from PCNFSAID where NUMNOTA = '91041' 
  and CODFILIALNF = '2' 
  and ESPECIE = 'NF' 
  and DTCANCEL is null)
)
select S.NUMNOTA N_NOTA,
       S.NUMVOLUME,
       numeros.repeticao VOLUMES,
       C.CLIENTE,
       case
       when P.CODENDENTCLI is not null
       then (select A.ENDERENT from PCCLIENTENDENT A join PCPEDC P on A.CODENDENTCLI = P.CODENDENTCLI where P.NUMNOTA ='91041') 
       else C.ENDERENT 
       end as ENDERECO,
        case
        when P.CODENDENTCLI is not null
        then (select A.BAIRROENT from PCCLIENTENDENT A join PCPEDC P on A.CODENDENTCLI = P.CODENDENTCLI where P.NUMNOTA ='91041') 
        else C.BAIRROENT 
        end as BAIRRO,
         case
         when P.CODENDENTCLI is not null
         then (select A.MUNICENT from PCCLIENTENDENT A join PCPEDC P on A.CODENDENTCLI = P.CODENDENTCLI where P.NUMNOTA ='91041') 
         else C.MUNICENT 
         end as CIDADE,
          case
          when P.CODENDENTCLI is not null
          then (select A.CEPENT from PCCLIENTENDENT A join PCPEDC P on A.CODENDENTCLI = P.CODENDENTCLI where P.NUMNOTA ='91041') 
          else C.CEPENT 
          end as CEP,
           case
           when P.CODENDENTCLI is not null
           then (select A.ESTENT from PCCLIENTENDENT A join PCPEDC P on A.CODENDENTCLI = P.CODENDENTCLI where P.NUMNOTA ='91041') 
           else C.ESTENT 
           end as UF,
    F.FORNECEDOR as TRANSPORTADORA
from PCNFSAID S
join PCCLIENT C on S.CODCLI = C.CODCLI
left join PCFORNEC F on S.CODFORNECFRETE = F.CODFORNEC
join numeros on numeros.repeticao <= S.NUMVOLUME
join PCPEDC P on S.NUMNOTA = P.NUMNOTA
left join PCCLIENTENDENT A on P.CODENDENTCLI = A.CODENDENTCLI
where S.NUMNOTA = '91041'
and S.CODFILIALNF = '2'
and S.ESPECIE = 'NF'
and S.DTCANCEL is null;
 
--mark3 (modificado para atender os possiveis valores nulos de NUMNOTA que o report builder e os relatórios. // quando o campo de dados não é informado, a linha de comando do mesmo é deletada)
with numeros as (
  select level as repeticao
  from dual
  connect by level <= (select max(NUMVOLUME) 
  from PCNFSAID 
  where 0=0
  and NUMNOTA = ('91041') 
  and CODFILIALNF in ('2')
  and ESPECIE = 'NF' 
  and DTCANCEL is null)
)
select S.NUMNOTA N_NOTA,
       S.NUMVOLUME,
       numeros.repeticao VOLUMES,
       C.CLIENTE,
       case
       when P.CODENDENTCLI is not null
       then (select A.ENDERENT
             from PCCLIENTENDENT A join PCPEDC P on A.CODENDENTCLI = P.CODENDENTCLI
             where 0=0 
             and P.NUMNOTA =('91041')
            )  
       else C.ENDERENT 
       end as ENDERECO,
        case
        when P.CODENDENTCLI is not null
        then (select A.BAIRROENT
              from PCCLIENTENDENT A 
              join PCPEDC P on A.CODENDENTCLI = P.CODENDENTCLI 
              where 0=0
              and P.NUMNOTA =('91041')
              ) 
        else C.BAIRROENT 
        end as BAIRRO,
         case
         when P.CODENDENTCLI is not null
         then (select A.MUNICENT 
         from PCCLIENTENDENT A join PCPEDC P on A.CODENDENTCLI = P.CODENDENTCLI 
         where 0=0
               and P.NUMNOTA =('91041')
              ) 
         else C.MUNICENT 
         end as CIDADE,
          case
          when P.CODENDENTCLI is not null
          then (select A.CEPENT 
          from PCCLIENTENDENT A join PCPEDC P on A.CODENDENTCLI = P.CODENDENTCLI
          where 0=0
                and P.NUMNOTA =('91041')
              ) 
          else C.CEPENT 
          end as CEP,
           case
           when P.CODENDENTCLI is not null
           then (select A.ESTENT 
           from PCCLIENTENDENT A join PCPEDC P on A.CODENDENTCLI = P.CODENDENTCLI 
           where 0=0
                 and P.NUMNOTA =('91041')
           ) 
           else C.ESTENT 
           end as UF,
    F.FORNECEDOR as TRANSPORTADORA
from PCNFSAID S
join PCCLIENT C on S.CODCLI = C.CODCLI
left join PCFORNEC F on S.CODFORNECFRETE = F.CODFORNEC
join numeros on numeros.repeticao <= S.NUMVOLUME
join PCPEDC P on S.NUMNOTA = P.NUMNOTA
left join PCCLIENTENDENT A on P.CODENDENTCLI = A.CODENDENTCLI
where 0=0
and S.NUMNOTA = ('91041')
and S.CODFILIALNF in ('2')
and S.ESPECIE = 'NF'
and S.DTCANCEL is null;