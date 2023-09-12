 select ( select DUPLIC 
          from PCPREST
          where 0=0
          and NUMTRANSVENDA ='191305'
          or DUPLIC = '53159'
          and PREST ='1'
          fetch first 1 rows only) as DUPLICATA,               
        D.NUMTRANSVENDADEST as N_TRANSACAO_ORIG,                                         
        D.NUMTRANSVENDAORIG as N_TRANSACAO_DES,
        P.DUPLIC as DUPLICATA_ORIG                                    
  from PCDESD D
join PCPREST P on D.NUMTRANSVENDAORIG = P.NUMTRANSVENDA                          
where 0=0  
and NUMTRANSVENDADEST = '191305'  
and PRESTORIG = '1'     
or P.DUPLIC ='53159'         
union                                      
 select ( select DUPLIC 
          from PCPREST
          where 0=0
          and NUMTRANSVENDA ='191305'
          or DUPLIC = '53159'
          and PREST ='1'
          fetch first 1 rows only) as DUPLICATA,              
       D.NUMTRANSVENDADEST,                                       
       D.NUMTRANSVENDAORIG,
       P.DUPLIC as DUPLICATA_ORIG                                        
  from PCDESD D
join PCPREST P on D.NUMTRANSVENDAORIG = P.NUMTRANSVENDA                           
where 0=0
and NUMTRANSVENDADEST = '191305'  
and PRESTDEST = '1'      
or P.DUPLIC ='53159'            
union                                      
 select ( select DUPLIC 
          from PCPREST
          where 0=0
          and NUMTRANSVENDA ='191305'
          or DUPLIC = '53159'
          and PREST ='1'
          fetch first 1 rows only) as DUPLICATA,                
       M.NUMTRANSVENDADEST,                                          
       M.NUMTRANSVENDAORIG,
       P.DUPLIC as DUPLICATA_ORIG                                
  from PCDESDMAP M
join PCPREST P on M.NUMTRANSVENDAORIG = P.NUMTRANSVENDA                         
where 0=0
and NUMTRANSVENDADEST = '191305'  
and PRESTORIG = '1'  
or P.DUPLIC ='53159'
                
union                                      
 select ( select DUPLIC 
          from PCPREST
          where 0=0
          and NUMTRANSVENDA ='191305'
          or DUPLIC = '53159'
          and PREST ='1'
          fetch first 1 rows only) as DUPLICATA,                
       M.NUMTRANSVENDADEST,                                          
       M.NUMTRANSVENDAORIG,
       P.DUPLIC as DUPLICATA_ORIG                                     
  from PCDESDMAP M
join PCPREST P on M.NUMTRANSVENDAORIG = P.NUMTRANSVENDA                 
where 0=0 
and NUMTRANSVENDADEST = '191305'
or P.DUPLIC ='53159'
   
   ;
   
   
 select * from PCDESD where NUMTRANSVENDAORIG ='191305'
 ;

select duplic from pcprest where numtransvenda ='191305' and PREST ='1';



select 
--NUMTRANSVENDADEST(TRANS ORIGINAL)
--NUMTRANSVENDAORIG(TRANS MESCLAGEM)

