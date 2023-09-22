select * from pccrecli where codcli = 5784;
select * from pclanc where pclanc.NUMTRANS = 19027;
select * from pcprest where numtransvenda = 197273;

select * from pcestcom where numtransent = 19027;

select NUMNOTA, codcli, pcnfsaid.CONDVENDA
from pcnfsaid
where numtransvenda = 197273;


select * from PCPEDC where NUMNOTA ='54256';


select NUMN from PCPEDC where NUMPED ='1114003383'