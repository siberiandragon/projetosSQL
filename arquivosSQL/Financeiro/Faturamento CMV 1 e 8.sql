 select P.CODFILIAL,
        N.DTSAIDA as Dt_EMISSAO,    
        N.NUMNOTA as N_NOTA,       
        N.CODCLI,
        T.CLIENTE,
       (nvl(decode(P.CONDVENDA,5, 0 ,6, 0, 11, 0, 12, 0 ,P.VLATEND  - nvl(P.VLFRETE,0) - nvl((select sum(nvl(I.ST,0) * nvl(I.QT,0)) 
                                                                                              from PCPEDI I 
                                                                                              where I.NUMPED = P.NUMPED and nvl(I.BONIFIC, 'N') = 'N'),0) ),0) 
) as VL_VENDA,  
P.PERDESC as DESCON_PERC,       
        ((select  sum(nvl(I.VLCUSTOFIN,0) * nvl(I.QT,0)) 
          from PCPEDI I
          where I.NUMPED = P.NUMPED 
          and I.DATA between (:DTINI) and (:DTFIM) )  - nvl((select sum(nvl(I.ST,0) * nvl(I.QT,0)) 
                                                                     from PCPEDI I 
                                                                     where I.NUMPED = P.NUMPED) ,0) 
) as Vl_CMV,
P.CONDVENDA as TV
   from PCPEDC P
join PCPLPAG G on P.CODPLPAG = G.CODPLPAG
left join PCPRACA C on P.CODPRACA = C.CODPRACA
join PCCLIENT T on P.CODCLI = T.CODCLI
join PCUSUARI U on P.CODUSUR = U.CODUSUR
join PCSUPERV S on P.CODSUPERVISOR = S.CODSUPERVISOR
join PCNFSAID N on P.NUMNOTA = N.NUMNOTA
where 0=0
and P.CODFILIAL in (:CODFILIAL)
and P.CONDVENDA in (:CONDVENDA)
and P.DTCANCEL is null
and P.DATA between (:DTINI) and (:DTFIM)
and P.POSICAO = 'F' 
order by S.CODSUPERVISOR,
         P.CODUSUR,
         P.VLATEND desc 