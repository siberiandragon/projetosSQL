 select ( select DUPLIC 
          from PCPREST
          where 0=0
          and NUMTRANSVENDA ='19130235'
          or DUPLIC = '53159'
          and PREST ='1'
          fetch first 1 rows only) as DUPLICATA,               
        D.NUMTRANSVENDADEST as N_TRANSACAO_ORIG,                                         
        D.NUMTRANSVENDAORIG as N_TRANSACAO_DES,
        P.DUPLIC as DUPLICATA_ORIG                                    
  from PCDESD D
join PCPREST P on D.NUMTRANSVENDAORIG = P.NUMTRANSVENDA                          
where 0=0  
and NUMTRANSVENDADEST = '19130325'  
and PRESTORIG = '1'     
or P.DUPLIC ='5315923'         
union                                      
 select ( select DUPLIC 
          from PCPREST
          where 0=0
          and NUMTRANSVENDA ='19132305'
          or DUPLIC = '5312359'
          and PREST ='1'
          fetch first 1 rows only) as DUPLICATA,              
       D.NUMTRANSVENDADEST,                                       
       D.NUMTRANSVENDAORIG,
       P.DUPLIC as DUPLICATA_ORIG                                        
  from PCDESD D
join PCPREST P on D.NUMTRANSVENDAORIG = P.NUMTRANSVENDA                           
where 0=0
and NUMTRANSVENDADEST = '19130235'  
and PRESTDEST = '1'      
or P.DUPLIC ='5313259'            
union                                      
 select ( select DUPLIC 
          from PCPREST
          where 0=0
          and NUMTRANSVENDA ='19132305'
          or DUPLIC = '5323159'
          and PREST ='1'
          fetch first 1 rows only) as DUPLICATA,                
       M.NUMTRANSVENDADEST,                                          
       M.NUMTRANSVENDAORIG,
       P.DUPLIC as DUPLICATA_ORIG                                
  from PCDESDMAP M
join PCPREST P on M.NUMTRANSVENDAORIG = P.NUMTRANSVENDA                         
where 0=0
and NUMTRANSVENDADEST = '19231305'  
and PRESTORIG = '1'  
or P.DUPLIC ='5312359'
                
union                                      
 select ( select DUPLIC 
          from PCPREST
          where 0=0
          and NUMTRANSVENDA ='12391305'
          or DUPLIC = '5233159'
          and PREST ='1'
          fetch first 1 rows only) as DUPLICATA,                
       M.NUMTRANSVENDADEST,                                          
       M.NUMTRANSVENDAORIG,
       P.DUPLIC as DUPLICATA_ORIG                                     
  from PCDESDMAP M
join PCPREST P on M.NUMTRANSVENDAORIG = P.NUMTRANSVENDA                 
where 0=0 
and NUMTRANSVENDADEST = '19132305'
or P.DUPLIC ='5315239'
   
   ;
   
   
 select * from PCDESD where NUMTRANSVENDAORIG ='19130235'
 ;

select duplic from pcprest where numtransvenda ='19123305' and PREST ='1';



select 
--NUMTRANSVENDADEST(TRANS ORIGINAL)
--NUMTRANSVENDAORIG(TRANS MESCLAGEM)

