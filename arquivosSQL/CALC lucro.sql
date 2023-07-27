select 
case when greatest(nvl(PCPEDC.VLATEND, 0)-nvl(pcpedc.vlfrete,0)-nvl(pcpedc.vloutrasdesp,0), 0) = 0 then -100 else
      decode (nvl (pcpedc.vlatend, 0)
                   ,0, 0
                   ,round (  (((pcpedc.vlatend-nvl(pcpedc.vlfrete,0)-nvl(pcpedc.vloutrasdesp,0)) - nvl(pcpedc.vlcustofin,0)) / (pcpedc.vlatend-nvl(pcpedc.vlfrete,0)-nvl(pcpedc.vloutrasdesp,0))
                             )
                            * 100
                          ,2)
                   ) end as clperlucro

from pcpedc  where pcpedc.codusur = '9999'
and pcpedc.data between '01/07/2023' and '17/07/2023' and  NUMPED='9999999999' ;