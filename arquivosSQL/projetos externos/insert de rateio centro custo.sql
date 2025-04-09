insert into pcrateiocentrocusto (
    RECNUM,
    CODCONTA,
    VALOR,
    PERCRATEIO,
    DTLANC,
    CONTRAPARTIDA,
    RECNUMPRINC,
    CODFILIAL,
    CODIGOCENTROCUSTO,
    ROTINAINSERT,
    LANCIMPRETIDO
)
select
    P.RECNUM,
    P.CODCONTA,
    P.VALOR,
    P.PRCRATEIOUTILIZADO,
    P.DTLANC,
    'N' as CONTRAPARTIDA,
    P.RECNUMPRINC,
    P.CODFILIAL,
    '1.1.2' as CODIGOCENTROCUSTO,
    'ORUBE_MANUAL' as ROTINAINSERT,
    'N' as LANCIMPRETIDO
from pclanc P
where P.tipoparceiro = 'R'
and P.dtlanc > '25/05/2024';

select * from pcrateiocentrocusto where rotinainsert = 'TOAD 13.3.0.181' order by dtlanc desc;

select PRCRATEIOUTILIZADO from pclanc where tipoparceiro = 'R' and dtlanc > '12/05/2024';

update pclanc set PRCRATEIOUTILIZADO = '100' where tipoparceiro = 'R' and dtlanc > '12/06/2024';
