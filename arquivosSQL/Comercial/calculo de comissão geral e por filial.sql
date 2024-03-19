select U.CODUSUR, 
       U.NOME ,
       U.VLVENDAPREV ,
       (select SUM(VLVENDAPREV)
       from PCUSUARI U2 
       where U2.TIPOVEND = U.TIPOVEND
       and U2.CODSUPERVISOR = U.CODSUPERVISOR) TOTAL
       from pcusuari U 
       where U.TIPOVEND ='I' 
       and U.CODSUPERVISOR  in('4') ;
       
       select SUM(U.VLVENDAPREV) 
       from PCUSUARI U
       left join PCEMPR E on U.CODUSUR = E.CODUSUR
       where 0=0
       and U.TIPOVEND = 'I'
       and E.SITUACAO = 'A'  
;

