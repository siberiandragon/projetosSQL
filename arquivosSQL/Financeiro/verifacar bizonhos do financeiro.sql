select * from pccrecli where codcli = '';
select * from pclanc where pclanc.numtrans = 19027;
select * from pcprest where numtransvenda = 197273;
select * from pcestcom where numtransent = 19027;
select numnota, codcli, pcnfsaid.condvenda
from pcnfsaid where numtransvenda = 197273;
select * from pcpedc where numnota = 54256;
select numnota from pcpedc where numped ='1114003383';
select * from PCNFSAID where numnota = 91776;
select vltotger from pcnfent where numnota = 780;
select * from pcnfent where numnota = 780;
select cliente from pcclient where codcli = 639;


select S.CONDVENDA 
from PCNFSAID S 
left join PCESTCOM C on S.NUMTRANSVENDA = C.NUMTRANSVENDA
left join PCNFENT E  on C.NUMTRANSENT = E.NUMTRANSENT 
where S.NUMNOTA = 55182;


select S.CODFILIAL FILIAL,
       S.NUMNOTA NFE,
       S.NUMTRANSVENDA,
       S.DTSAIDA,
       S.VLTOTAL,
       S.CODFUNCLANC MATRICULA,
       U.NOME,
       case 
       when S.GERACP = 'S'
       then 'FOI GERADO DESPESAS'
       else 'FOI GERADO CONTAS A RECEBER'
       end DESPESAS,
       case 
       when S.DTCANCEL is not null
       then 'S'
       else 'N'
       end NF_CANCELADA,
       S.DTCANCEL,
       case 
       when S.DTDEVOL is not null
       then 'S'
       else 'N'
       end NF_DEVOLVIDA,
       S.DTDEVOL,
       S.CODDEVOL,
       V.MOTIVO
       
from PCNFSAID S 
join PCCLIENT P on S.CODCLI = P.CODCLI
join PCEMPR U   on S.CODFUNCLANC = U.MATRICULA
left join PCTABDEV V on S.CODDEVOL = V.CODDEVOL
where S.GERACP = 'S'
and S.CONDVENDA = '9'

