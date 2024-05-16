select * from 
     (select CODFAB
     , CODPROD
     , DESCRICAO
     , (sum(nvl(QTENTRADA,0))-sum(nvl(QTENTOUTRAS,0))) QTENTNML
     , (sum(nvl(QTSAIDA,0))-sum(nvl(QTSAIDOUTRAS,0)))  QTSAIDNML
     , sum(nvl(QTENTOUTRAS,0)) OUTRASENT
     , sum(nvl(QTSAIDOUTRAS,0)) OUTRASAID
     , QTINICIAL
     , QTFINAL
     , CUSTOULTENTFIN ULT_CUSTO_FINANCEIRO
       from (select 
                   (select P.CODFAB from PCPRODUT P where P.CODPROD = M6.CODPROD) CODFAB                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
     ,      case 
                 when (substr(M6.CODOPER,1,1) = 'E') or (substr(M6.CODOPER,1,1) = 'D') 
                 then 
                      case 
                           when (decode(nvl(C6.QTRETORNOTV13, 0), 0, nvl(M6.QT, 0), C6.QTRETORNOTV13) > 0) 
                           then  decode(nvl(C6.QTRETORNOTV13, 0), 0, nvl(M6.QT, 0), C6.QTRETORNOTV13)                                                                                                                              
                      end
                  else
            case 
                 when (decode(nvl(C6.QTRETORNOTV13, 0), 0, nvl(M6.QT, 0), C6.QTRETORNOTV13) < 0) 
                 then nvl((decode(nvl(C6.QTRETORNOTV13, 0), 0, nvl(M6.QT, 0), C6.QTRETORNOTV13)*(-1)),0)
            end
end QTENTRADA
       ,    case 
                 when (substr(M6.CODOPER,1,1) = 'S') or (substr(M6.CODOPER,1,1) = 'R') 
                 then 
                      case 
                           when (M6.QT > 0)
                           then nvl(M6.QT*(-1),0)
                      end
                 else
            case 
                 when (M6.QT < 0) 
                 then nvl(M6.QT,0)
            end
end QTSAIDA,
            case 
                 when M6.CODOPER = 'EI'
                 then
                      case 
                           when (decode(nvl(C6.QTRETORNOTV13, 0), 0, nvl(M6.QT, 0), C6.QTRETORNOTV13) > 0) 
                           then  decode(nvl(C6.QTRETORNOTV13, 0), 0, nvl(M6.QT, 0), C6.QTRETORNOTV13)                                                                                                                              
                      end
                 else
            case 
                when (decode(nvl(C6.QTRETORNOTV13, 0), 0, nvl(M6.QT, 0), C6.QTRETORNOTV13) < 0) 
                then nvl((decode(nvl(C6.QTRETORNOTV13, 0), 0, nvl(M6.QT, 0), C6.QTRETORNOTV13)*(-1)),0)
            end
end QTENTOUTRAS,
            case
                 when M6.CODOPER = 'SI'
                 then 
                      case 
                           when (M6.QT > 0)
                           then nvl(M6.QT*(-1),0)
                      end
                 else
            case 
                 when (M6.QT < 0) 
                 then nvl(M6.QT,0)
            end
end QTSAIDOUTRAS
     , M6.CODPROD
     ,(select SDINICIAL 
       from (select E2.QTESTGER,                                                      
            sum(case                                                             
                     when (substr(M2.CODOPER, 1, 1) = 'E') or (substr(M2.CODOPER, 1, 1) = 'D') 
                     then 
                          case                                                          
                               when decode(nvl(C2.QTRETORNOTV13, 0),0, nvl(M2.QT, 0),C2.QTRETORNOTV13) > 0 
                               then decode(nvl(C2.QTRETORNOTV13, 0),0, nvl(M2.QT, 0),C2.QTRETORNOTV13)                          
                          end                                                           
                     else                                                           
                          case                                                          
                               when (M2.QT < 0) 
                               then  nvl((M2.QT * (-1)), 0)                                  
                          end                                                           
end) QTENTRADA,                                                  
            sum(case 
                     when (substr(M2.CODOPER,1,1) = 'S') or (substr(M2.CODOPER,1,1) = 'R') 
                     then
                          case 
                               when (M2.QT > 0) 
                               then nvl(M2.QT*(-1),0)
                          end
                     else
                case 
                     when (M2.QT < 0) 
                     then nvl(M2.QT,0)
                end
end) QTSAIDA                                                   
,nvl((select QTESTGER                                              
      from PCHISTEST                                               
      where 0=0
      and CODPROD = M6.CODPROD                                         
      and CODFILIAL = '4'                                  
      and rownum = 1                                              
      and trunc(DATA)= to_date ('01/05/2024', 'DD/MM/YYYY') - 1),0) SDINICIAL                                                   
from PCMOV M2,
     PCEST E2,
     PCPRODUT P2,
     PCMOVCOMPLE C2                                  
where 0=0
and M2.CODPROD =  M6.CODPROD                                              
and M2.NUMTRANSITEM = C2.NUMTRANSITEM(+)                     
and nvl(C2.MOVEST, 'S') = 'S'                               
and M2.CODPROD = P2.CODPROD                                     
and E2.CODPROD = M2.CODPROD                                        
and E2.CODFILIAL = nvl(M2.CODFILIALNF, M2.CODFILIAL)            
and trunc(M2.DTMOV) between '01/05/2024' and '10/05/2024'                         
and nvl(M2.CODFILIALNF, M2.CODFILIAL) = '4'                 
and M2.STATUS in ('B', 'AB')                                      
and (not exists                                                          
              (select NUMPED                                                      
                   from PCPEDC P2                                                      
                   where 0=0
                   and P2.NUMPED = decode(M2.CODOPER, 'EP', -1, 'SP', -1, M2.NUMPED) 
                   and P2.CONDVENDA = 7) or (substr(M2.CODOPER, 1, 1) = 'E'))    
                   and not exists                                                           
                                 (select distinct (S2.NUMTRANSVENDA)                                  
                                 from PCNFSAID S2,
                                      PCPRODUT P3                                           
                                 where 0=0
                                 and S2.NUMTRANSVENDA = M2.NUMTRANSVENDA                 
                                 and M2.CODOPER = 'S'                                        
                                 and S2.CONDVENDA in (4, 7, 14)                             
                                 and M2.CODPROD = P3.CODPROD                             
                                 and P3.TIPOMERC = 'CB')                                  
                                 and not (M2.CODOPER in ('EA', 'SA') and                           
                                 C2.NUMINVENT is not null)                                  
                                 and not (FERRAMENTAS.F_BUSCARPARAMETRO_ALFA('DEVOLVESIMPLESREMTV13TOTAL',M2.CODFILIAL,'N') = 'S' 
                                 and M2.ROTINACAD LIKE '%1332%'
                                 and nvl(C2.QTRETORNOTV13,0) = 0)                                                           
                                 and not exists 
                                               (select NUMNOTA 
                                                from PCNFSAID S3
                                                where 0=0
                                                and S3.NUMTRANSVENDA = M2.NUMTRANSVENDA 
                                                and S3.SITUACAONFE in (110,205,301,302,303))                                                       
group by E2.QTESTGER)) QTINICIAL
       ,(select(nvl(SDINICIAL, 0) + 
         nvl(QTENTRADA, 0) + 
         nvl(QTSAIDA, 0)) SDFINAL   
         from (select 
              E3.QTESTGER,                                                      
               sum(case                                                             
                       when (substr(M3.CODOPER, 1, 1) = 'E') or (substr(M3.CODOPER, 1, 1) = 'D') 
                       then  case                                                          
                                 when decode(nvl(C3.QTRETORNOTV13, 0),0, nvl(M3.QT, 0),C3.QTRETORNOTV13) > 0 
                                 then decode(nvl(C3.QTRETORNOTV13, 0),0, nvl(M3.QT, 0),C3.QTRETORNOTV13)                          
                             end                                                           
                       else                                                           
                             case                                                          
                                 when (M3.QT < 0) 
                                 then  nvl((M3.QT * (-1)), 0)                                  
                             end                                                           
end) QTENTRADA,                                                  
               sum(case                                                             
                     when (substr(M3.CODOPER, 1, 1) = 'S') or (substr(M3.CODOPER, 1, 1) = 'R') 
                     then  case                                                          
                               when (M3.QT > 0) 
                               then  nvl(M3.QT * (-1), 0)                                    
                           end                                                           
                     else                                                           
                         case                                                          
                             when (M3.QT < 0) 
                             then nvl(M3.QT, 0)                                           
                           end                                                           
end) QTSAIDA                                                     
,nvl((select QTESTGER                                              
      from PCHISTEST                                               
      where 0=0
      and CODPROD = M6.CODPROD                                  
      and CODFILIAL = '4'                                  
      and rownum = 1                                              
      and trunc(DATA) = to_date('01/05/2024','DD/MM/YYYY') - 1),0) SDINICIAL                                               
from PCMOV M3,
     PCEST E3,
     PCPRODUT P4,
     PCMOVCOMPLE C3                                 
where 0=0
and M3.CODPROD = M6.CODPROD                                              
and M3.NUMTRANSITEM = C3.NUMTRANSITEM(+)                     
and nvl(C3.MOVEST, 'S') = 'S'                               
and M3.CODPROD = P4.CODPROD                                     
and E3.CODPROD = M3.CODPROD                                        
and E3.CODFILIAL = nvl(M3.CODFILIALNF, M3.CODFILIAL)            
and trunc(M3.DTMOV) between '01/05/2024' and '31/05/2024'                          
and nvl(M3.CODFILIALNF, M3.CODFILIAL) = '4'                 
and M3.STATUS in ('B', 'AB')                                      
and (not exists                                                          
                (select NUMPED                                                      
                   from PCPEDC P3                                                     
                   where 0=0
                   and P3.NUMPED = decode(M3.CODOPER, 'EP', -1, 'SP', -1, M3.NUMPED) 
                   and P3.CONDVENDA = 7) or (substr(M3.CODOPER, 1, 1) = 'E'))    
                   and not exists                                                           
                                (select distinct (S4.NUMTRANSVENDA)                                  
                                 from PCNFSAID S4,
                                      PCPRODUT P5                                          
                                 where 0=0
                                 and S4.NUMTRANSVENDA = M3.NUMTRANSVENDA                 
                                 and M3.CODOPER = 'S'                                        
                                 and S4.CONDVENDA in (4, 7, 14)                             
                                 and M3.CODPROD = P5.CODPROD                             
                                 and P5.TIPOMERC = 'CB')                                  
                                 and not (M3.CODOPER in ('EA', 'SA') and                           
                                 C3.NUMINVENT is not null)                                  
                                 and not (FERRAMENTAS.F_BUSCARPARAMETRO_ALFA('DEVOLVESIMPLESREMTV13TOTAL',M3.CODFILIAL,'N') = 'S' 
                                 and M3.ROTINACAD LIKE '%1332%'
                                 and nvl(C3.QTRETORNOTV13,0) = 0)                                                           
                                 and not exists 
                                               (select NUMNOTA 
                                                from PCNFSAID S5 
                                                where 0=0
                                                and S5.NUMTRANSVENDA = M3.NUMTRANSVENDA 
                                                and S5.SITUACAONFE in (110,205,301,302,303))                                                       
                               
group by E3.QTESTGER)) QTFINAL,
P6.DESCRICAO,
B.CUSTOULTENTFIN
  from PCMOV M6
     , PCEMPR E6
     , PCCLIENT I2
     , PCFORNEC F2
     , PCPRODUT P6
     , PCMOVCOMPLE C6 
     , PCEST B
 where 0=0
   --and M6.CODPROD =('4047')    
   and M6.CODPROD = P6.CODPROD
   and M6.NUMTRANSITEM = C6.NUMTRANSITEM(+)
   and B.CODPROD = M6.CODPROD
   and B.CODFILIAL = M6.CODFILIAL 
   and nvl(C6.MOVEST, 'S') = 'S' 
   and M6.CODFORNEC = F2.CODFORNEC(+)
   and M6.CODFUNCLANC = E6.MATRICULA(+)
   --and M6.CODUSUR = E6.MATRICULA(+)
   and M6.CODCLI = I2.CODCLI(+)                                                                                                                           
   and trunc(M6.DTMOV) between '01/05/2024' and '31/05/2024'                                                                                                               
   and nvl(M6.CODFILIALNF, M6.CODFILIAL) = '2'                                                                                                        
   and M6.STATUS in ('B','AB')                                                                                                                              
   and ( not exists                                                                                                                                                
   (select P4.NUMPED 
    from PCPEDC P4
    where 0=0
    and P4.NUMPED = decode(M6.CODOPER, 'EP', -1, 'SP',-1, M6.NUMPED) 
    and P4.CONDVENDA = 7) or (substr(M6.CODOPER,1,1) = 'E')) 
    and not exists (select distinct (S6.NUMTRANSVENDA)                                                                                                        
                    from PCNFSAID S6,
                         PCPRODUT P7                                                                                                                                 
                    where 0=0
                    and S6.NUMTRANSVENDA = M6.NUMTRANSVENDA                                                                                                       
                    and S6.CODFILIAL = M6.CODFILIAL                                                                                                               
                    and M6.CODOPER = 'S'                                                                                                                              
                    and S6.CONDVENDA in (4, 7, 14)                                                                                                                   
                    and M6.CODPROD = P7.CODPROD                                                                                                                   
                    and P7.TIPOMERC = 'CB')                                                                                                                        
                    and not (M6.CODOPER in ('EA','SA') and                                                                                                                   
                    C6.NUMINVENT is not null)                                                                                                                     
                    and not (FERRAMENTAS.F_BUSCARPARAMETRO_ALFA('DEVOLVESIMPLESREMTV13TOTAL',M6.CODFILIAL,'N') = 'S' 
                    and M6.ROTINACAD like '%1332%' and nvl(C6.QTRETORNOTV13,0) = 0)                                                                                                                                           
                    and not exists (select S7.NUMNOTA 
                                    from PCNFSAID S7 
                                    where 0=0
                                    and S7.NUMTRANSVENDA = M6.NUMTRANSVENDA 
                                    and S7.SITUACAONFE in (110,205,301,302,303))                                                                                                                                                            
     )
       
group by CODFAB,
         CODPROD,
         QTINICIAL,
         QTFINAL,
         DESCRICAO,
         CUSTOULTENTFIN                                                                                                                                     
         )
  
