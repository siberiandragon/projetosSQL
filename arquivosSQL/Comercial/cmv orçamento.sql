 select round(((VL_CMV - VLATEND)/VLATEND) * -100,2) as lucro_total_orca 
 from 
(
 select      
        ((select  sum(nvl(I.VLCUSTOFIN,0) * nvl(I.QT,0)) 
          from PCORCAVENDAI I
          where 0=0
          and I.NUMORCA = P.NUMORCA 
                                    )  - nvl((select sum(nvl(I.ST,0) * nvl(I.QT,0)) 
                                              from PCORCAVENDAI I 
                                              where I.NUMORCA = P.NUMORCA) ,0) 
         ) as Vl_CMV, P.VLATEND
   from PCORCAVENDAC P
where 0=0
and P.CODFILIAL in ('2')
and P.DTCANCEL is null
and P.NUMORCA = 1078006642
)