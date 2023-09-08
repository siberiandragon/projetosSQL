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
