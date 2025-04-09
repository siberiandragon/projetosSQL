select pclanc.MOEDAESTRANGEIRA,pclanc.VALORMOEDAESTRANGEIRA,pclanc.DTCOTACAO,pclanc.COTACAO,pclanc.* from pclanc where recnum in ('393065','417397','481609','501383',
'501384');


update pclanc set MOEDAESTRANGEIRA = '1',
                  VALORMOEDAESTRANGEIRA = '40344,745205',
                  DTCOTACAO = '30/12/2024', 
                  COTACAO = '6,1991'
where recnum = '501383'