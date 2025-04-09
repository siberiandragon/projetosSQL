select pccontroi.codrotina,
       pccontroi.codusuario,
       pcempr.nome,
       pccontroi.codcontrole,
       pccontroi.acesso,
       pcrotinai.descricao nomecontrole
  from pccontroi
  join pcrotinai
on pccontroi.codcontrole = pcrotinai.codcontrole
   and pccontroi.codrotina = pcrotinai.codrotina
  left join pcempr
on pccontroi.codusuario = pcempr.matricula
 where 0 = 0
--AND PCCONTROI.CODROTINA = '931'
--AND PCCONTROI.CODCONTROLE = '4'
   and pccontroi.codusuario not in ( '9',
                                     '16' )
   and pccontroi.acesso = 'S'
   and ( pcrotinai.descricao = 'Permitir criar/editar layout relatório'
    or pcrotinai.descricao = 'Permitir alterar layout editável'
    or pcrotinai.descricao = 'Permitir alterar relatório editável' )
 order by pccontroi.codusuario;

select c.codusuario,
       e.nome,
       c.codrotina,
       c.acesso,
       c.codbanco,
       c.codmoeda,
       c.codepto
  from pccontro c
  left join pcempr e
on c.codusuario = e.matricula
 where 0 = 0
   and c.codrotina = '1209'
   and c.acesso = 'S'
 order by c.codusuario;


--UPDATE PCCONTROI SET ACESSO = 'N' WHERE CODROTINA = '604' and CODCONTROLE = '4' and CODUSUARIO not in ('9','13','16','17','18','33','120','148')
--UPDATE PCCONTRO SET ACESSO = 'N' WHERE CODROTINA = '1209' and CODUSUARIO not in ('9','13','16','17','18','33','120','148')

update pccontroi
   set
   acesso = 'N'
 where acesso = 'S'
   and codusuario not in ( '9',
                           '16' )
   and exists (
   select 1
     from pcrotinai
    where pcrotinai.codcontrole = pccontroi.codcontrole
      and pcrotinai.codrotina = pccontroi.codrotina
      and ( pcrotinai.descricao = 'Permitir criar/editar layout relatório'
       or pcrotinai.descricao = 'Permitir alterar layout editável'
       or pcrotinai.descricao = 'Permitir alterar relatório editável' )
);