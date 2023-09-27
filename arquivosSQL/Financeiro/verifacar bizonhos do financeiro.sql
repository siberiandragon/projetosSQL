select * from pccrecli where codcli = '';
select * from pclanc where pclanc.numtrans = 19027;
select * from pcprest where numtransvenda = 197273;
select * from pcestcom where numtransent = 19027;
select numnota, codcli, pcnfsaid.condvenda
from pcnfsaid
where numtransvenda = 197273;
select * from pcpedc where numnota = 54256;
select numnota from pcpedc where numped ='1114003383';
select * from PCNFSAID where numnota = 91776;
select vltotger from pcnfent where numnota = 780;
select * from pcnfent where numnota = 780;
select cliente from pcclient where codcli = 639;