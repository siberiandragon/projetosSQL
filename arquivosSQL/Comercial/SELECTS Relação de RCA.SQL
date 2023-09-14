select CODUSUR, NOME, FAX  from PCUSUARI
where (CODUSUR >='1' and CODUSUR <='2000' or CODUSUR='3001')
and CODUSUR not in ('1144','1148','1149')
order by CODUSUR; 



