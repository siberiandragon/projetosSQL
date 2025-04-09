select proxnumlanc
  from pcconsum;
select proxnumlanc + 1
  from pcconsum
 where rownum = 1;

-- Realizar o INSERT manualmente
insert into pclanc (
   recnum,
   dtlanc,
   codconta,
   codfornec,
   historico,
   numnota,
   valor,
   dtvenc,
   codfilial,
   indice,
   dtemissao,
   tipoparceiro,
   codfornecprinc,
   recnumprinc,
   numtransvenda,
   dtcompetencia,
   agendamento,
   codrotinacad,
   codrotinaalt,
   parcela,
   fornecedor,
   codrotinaversaocad,
   codrotinaversaoalt,
   tiposervico,
   prcrateioutilizado
)
   select '365961' as recnum,                           -- RECNUM deve ser consultado no banco postgres
          dtsaida as datalanc,                       -- DATALANC
          '4020004' as codconta,                     -- CODCONTA
          codusur2 as codfornec,                     -- CODFORNEC
          cobranca as historico,                     -- HISTORICO
          numnota,                                   -- N�mero da nota
          comissao_com_credito as valor,             -- VALOR ( DE ACORDO COM OQUE FOI APROVADO)
          dtvenc,                                    -- Data de vencimento
          codfilial,                                 -- C�digo da filial
          'A' as indice,                             -- INDICE
          dtsaida as dtemissao,                      -- DTEMISSAO
          'R' as tipoparceiro,                       -- TIPOPARCEIRO
          codusur2 codfornecprinc,                   -- CODFORNECPRINC
          '365961' recnumprinc,                         -- RECNUMPRINC deve ser consultado no banco postgres da mesma forma que recnum
          numtransvenda,                             -- N�mero da transa��o
          dtsaida as dtcompetencia,                  -- Data de compet�ncia
          'N' as agendamento,                        -- AGENDAMENTO
          'JDBC Thin Client' as codrotinacad,        -- CODROTINACAD
          'JDBC Thin Client' as codrotinaalt,        -- CODROTINAALT
          prest as parcela,                          -- PARCELA
          nomecontato as fornecedor,                 -- FORNECEDOR
          'JDBC Thin Client' as codrotinaversaocad,  -- CODROTINAVERSAOCAD
          'JDBC Thin Client' as codrotinaversaoalt,  -- CODROTINAVERSAOALT
          '99' as tiposervico,                       -- Tipo de servi�o
          '100' as prcrateioutilizado                -- PRC rateio utilizado

     from vw_comissao_agenciada_try
    where 0 = 0
      and numtransvenda = '318215'
      and prest = 2;


select *
  from pclanc
 where recnum = 434786;


select *
  from vw_comissao_agenciada_try
 where numnota = 113249
   and prest = 1;

--delete from pclanc where recnum = 434786;