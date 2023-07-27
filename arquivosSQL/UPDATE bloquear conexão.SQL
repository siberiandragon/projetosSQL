select * from PCEMPR

update PCEMPR set NUMCONEXOESATUAL='0' 
where MATRICULA not in('1','9','16');