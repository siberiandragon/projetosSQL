select
       S.CODFILIAL as FILIAL,
       S.NUMNOTA NF,
       U.NUMPED,
       U.CODPROD,
       (select P.CODFAB from PCPRODUT P where P.CODPROD = U.CODPROD) CODFAB,
       (select P.DESCRICAO from PCPRODUT P where P.CODPROD = U.CODPROD) DESCRICAO,
       (select P.EMBALAGEM from PCPRODUT P where P.CODPROD = U.CODPROD) EMBALAGEM,
       decode(max( U.POSICAO ),'F', nvl(
                                        (select case P.TIPOMERC 
                                                 when 'CB'
                                                 then SUM(nvl(M.QT, 0) - nvl( M.QTDEVOL, 0)) 
                                                 else 
                                                 SUM(nvl(M.QTCONT, M.QT) - nvl( M.QTDEVOL, 0)) 
                                                 end 
                                        from PCMOV M
                                        where 0=0
										and M.CODPROD = U.CODPROD  
                                        and M.CODAUXILIAR = U.CODAUXILIAR  
                                        and nvl(M.CODFILIALRETIRA, M.CODFILIAL) in ('2')  
                                        and M.NUMTRANSVENDA in( select PCNFSAID.NUMTRANSVENDA
                                                                    from PCNFSAID
                                                                    where PCNFSAID.NUMPED = U.NUMPED )),0),
        SUM( U.qt )) QT,

        (nvl((select SUM (I.qt)
              from PCPEDI I
              join PCPEDC C on I.NUMPED = C.NUMPED
              where 0=0
		      and C.NUMPEDENTFUT = U.NUMPED
              and C.CONDVENDA = 8
              and I.CODPROD = U.CODPROD),0)
            - nvl((select SUM (M.qt)
                   from PCPEDC C
                   join PCNFSAID S on C.NUMPED = S.NUMPED
                   join PCESTCOM E on S.NUMTRANSVENDA = E.NUMTRANSVENDA   
                   join PCMOV    M on E.NUMTRANSENT = M.NUMTRANSENT  
                   where 0=0
   		           and C.NUMPEDENTFUT = U.NUMPED
   		           and M.CODPROD = U.CODPROD
                                             ),0))  QTENTREGUE,
(SUM( U.qt ))
              - (nvl((select SUM (I.qt)
                      from PCPEDI I
                      join PCPEDC C on I.NUMPED = C.NUMPED
                      where 0=0
		              and C.NUMPEDENTFUT = U.NUMPED
                      and C.CONDVENDA = 8
                      and I.CODPROD = U.CODPROD),0)
                    - nvl((select SUM (M.qt)
                           from PCPEDC C
                           join PCNFSAID S on C.NUMPED = S.NUMPED
                           join PCESTCOM E on S.NUMTRANSVENDA = E.NUMTRANSVENDA   
                           join PCMOV    M on E.NUMTRANSENT = M.NUMTRANSENT  
                           where 0=0
   		                   and C.NUMPEDENTFUT = U.NUMPED
   		                   and M.CODPROD = U.CODPROD
                                                     ),0)) as QT_A_ENTREGAR,
          nvl((select SUM (M.QT)  
          from PCPEDC C
          join PCNFSAID S on C.NUMPED = S.NUMPED
          join PCESTCOM E on S.NUMTRANSVENDA = E.NUMTRANSVENDA   
          join PCMOV    M on E.NUMTRANSENT = M.NUMTRANSENT  
   		  where 0=0
   		  and C.NUMPEDENTFUT = U.NUMPED
   		  and M.CODPROD = U.CODPROD),0) QTDEVOLVIDA 
from PCPEDI U      
join PCPRODUT P on U.CODPROD = P.CODPROD
join PCNFSAID S on U.NUMPED = S.NUMPED  
where 0=0
and U.NUMPED in (select NUMPED 
                 from PCNFSAID 
                 where 0=0
                 and CODFILIAL in ('2')
                 and NUMNOTA in('94005')
             --  and CODCLI in (:CODCLI)
                 and DTFAT between ('01/01/2023') and ('01/01/2024')
                 and CONDVENDA = 7
                 )
and U.CODPROD = P.CODPROD 
group by U.NUMPED,
         U.CODPROD,
		 U.PERDESC, 
		 U.CODAUXILIAR,
		 U.CODFILIALRETIRA,
		 P.TIPOMERC,
		 S.NUMNOTA,
         S.CODFILIAL
order by U.NUMPED ;

--Mark 2 (condição having para ignorar os já entregues e melhora no calculo de Devoluções para considerar as tipo 7 e 8)
select
       S.CODFILIAL as FILIAL,
       S.NUMNOTA NF,
       U.NUMPED,
       U.DATA,
       U.CODPROD,
       (select P.CODFAB from PCPRODUT P where P.CODPROD = U.CODPROD) CODFAB,
       (select P.DESCRICAO from PCPRODUT P where P.CODPROD = U.CODPROD) DESCRICAO,
       (select P.EMBALAGEM from PCPRODUT P where P.CODPROD = U.CODPROD) EMBALAGEM,
       decode(max( U.POSICAO ),'F', nvl(
                                        (select case P.TIPOMERC 
                                                 when 'CB'
                                                 then SUM(nvl(M.QT, 0) - nvl( M.QTDEVOL, 0)) 
                                                 else 
                                                 SUM(nvl(M.QTCONT, M.QT) - nvl( M.QTDEVOL, 0)) 
                                                 end 
                                        from PCMOV M
                                        where 0=0
										and M.CODPROD = U.CODPROD  
                                        and M.CODAUXILIAR = U.CODAUXILIAR  
                                        and nvl(M.CODFILIALRETIRA, M.CODFILIAL) in ('2')  
                                        and M.NUMTRANSVENDA in( select PCNFSAID.NUMTRANSVENDA
                                                                    from PCNFSAID
                                                                    where PCNFSAID.NUMPED = U.NUMPED )),0),
        SUM( U.QT)) QT,

        (nvl((select SUM (I.QT)
              from PCPEDI I
              join PCPEDC C on I.NUMPED = C.NUMPED
              where 0=0
		      and C.NUMPEDENTFUT = U.NUMPED
              and C.CONDVENDA = 8
              and I.CODPROD = U.CODPROD),0)
            - nvl((select SUM (M.qt)
                   from PCPEDC C
                   join PCNFSAID S on C.NUMPED = S.NUMPED
                   join PCESTCOM E on S.NUMTRANSVENDA = E.NUMTRANSVENDA   
                   join PCMOV    M on E.NUMTRANSENT = M.NUMTRANSENT  
                   where 0=0
   		           and C.NUMPEDENTFUT = U.NUMPED
   		           and M.CODPROD = U.CODPROD
                                             ),0))  QTENTREGUE,
(SUM( U.QT))
              - (nvl((select SUM (I.QT)
                      from PCPEDI I
                      join PCPEDC C on I.NUMPED = C.NUMPED
                      where 0=0
		              and C.NUMPEDENTFUT = U.NUMPED
                      and C.CONDVENDA = 8
                      and I.CODPROD = U.CODPROD),0)
                    - nvl((select SUM (M.QT)
                           from PCPEDC C
                           join PCNFSAID S on C.NUMPED = S.NUMPED
                           join PCESTCOM E on S.NUMTRANSVENDA = E.NUMTRANSVENDA   
                           join PCMOV    M on E.NUMTRANSENT = M.NUMTRANSENT  
                           where 0=0
   		                   and C.NUMPEDENTFUT = U.NUMPED
   		                   and M.CODPROD = U.CODPROD
                                                     ),0)) as QT_A_ENTREGAR,
    case 
    when nvl((select SUM (M.QT)  
          from PCPEDC C
          join PCNFSAID S on C.NUMPED = S.NUMPED
          join PCESTCOM E on S.NUMTRANSVENDA = E.NUMTRANSVENDA   
          join PCMOV    M on E.NUMTRANSENT = M.NUMTRANSENT  
   		  where 0=0
   		  and C.NUMPEDENTFUT = U.NUMPED 
   		  and M.CODPROD = U.CODPROD),0) = 0 
    then nvl((select SUM (M.QT)  
          from PCPEDC C
          join PCNFSAID S on C.NUMPED = S.NUMPED
          join PCESTCOM E on S.NUMTRANSVENDA = E.NUMTRANSVENDA   
          join PCMOV    M on E.NUMTRANSENT = M.NUMTRANSENT  
   		  where 0=0
   		  and C.NUMPED = U.NUMPED 
   		  and M.CODPROD = U.CODPROD),0) 
   else  (select SUM (M.QT)  
          from PCPEDC C
          join PCNFSAID S on C.NUMPED = S.NUMPED
          join PCESTCOM E on S.NUMTRANSVENDA = E.NUMTRANSVENDA   
          join PCMOV    M on E.NUMTRANSENT = M.NUMTRANSENT  
   		  where 0=0
   		  and C.NUMPEDENTFUT = U.NUMPED 
   		  and M.CODPROD = U.CODPROD)
   	end QTDEVOLVIDA
   		  
from PCPEDI U      
join PCPRODUT P on U.CODPROD = P.CODPROD
join PCNFSAID S on U.NUMPED = S.NUMPED  
where 0=0
and U.NUMPED in (select NUMPED 
                 from PCNFSAID 
                 where 0=0
                 and CODFILIAL in ('2')
               --  and NUMNOTA in(:NUMNOTA)
               --  and CODCLI in (:CODCLI)
                 and DTFAT between ('01/01/2023') and ('11/12/2023')
                 and CONDVENDA = 7
                      )
and U.CODPROD = P.CODPROD 
group by U.NUMPED,
         U.CODPROD,
		 U.PERDESC, 
		 U.CODAUXILIAR,
		 U.CODFILIALRETIRA,
		 P.TIPOMERC,
		 S.NUMNOTA,
         S.CODFILIAL,
         U.DATA
having (SUM( U.QT))
              - (nvl((select SUM (I.QT)
                      from PCPEDI I
                      join PCPEDC C on I.NUMPED = C.NUMPED
                      where 0=0
		              and C.NUMPEDENTFUT = U.NUMPED
                      and C.CONDVENDA = 8
                      and I.CODPROD = U.CODPROD),0)
                    - nvl((select SUM (M.QT)
                           from PCPEDC C
                           join PCNFSAID S on C.NUMPED = S.NUMPED
                           join PCESTCOM E on S.NUMTRANSVENDA = E.NUMTRANSVENDA   
                           join PCMOV    M on E.NUMTRANSENT = M.NUMTRANSENT  
                           where 0=0
   		                   and C.NUMPEDENTFUT = U.NUMPED
   		                   and M.CODPROD = U.CODPROD
                                                     ),0)) > 0                                                    
order by U.NUMPED 
;
--Mark 3 ( agora ignorando os registros que possuem total QTDEVOLVIDA e QT_A_ENTREGAR iguais)
select
       S.CODFILIAL as FILIAL,
       S.NUMNOTA NF,
       U.NUMPED,
       G.CODCLI,
       G.CLIENTE,
       U.DATA,
       U.CODPROD,
       (select P.CODFAB from PCPRODUT P where P.CODPROD = U.CODPROD) CODFAB,
       (select P.DESCRICAO from PCPRODUT P where P.CODPROD = U.CODPROD) DESCRICAO,
       (select P.EMBALAGEM from PCPRODUT P where P.CODPROD = U.CODPROD) EMBALAGEM,
       decode(max( U.POSICAO ),'F', nvl(
                                        (select case P.TIPOMERC 
                                                 when 'CB'
                                                 then SUM(nvl(M.QT, 0) - nvl( M.QTDEVOL, 0)) 
                                                 else 
                                                 SUM(nvl(M.QTCONT, M.QT) - nvl( M.QTDEVOL, 0)) 
                                                 end 
                                        from PCMOV M
                                        where 0=0
										and M.CODPROD = U.CODPROD  
                                        and M.CODAUXILIAR = U.CODAUXILIAR  
                                        and nvl(M.CODFILIALRETIRA, M.CODFILIAL) in ('2')  
                                        and M.NUMTRANSVENDA in( select PCNFSAID.NUMTRANSVENDA
                                                                    from PCNFSAID
                                                                    where PCNFSAID.NUMPED = U.NUMPED )),0),
        SUM( U.QT)) QT,

        (nvl((select SUM (I.QT)
              from PCPEDI I
              join PCPEDC C on I.NUMPED = C.NUMPED
              where 0=0
		      and C.NUMPEDENTFUT = U.NUMPED
              and C.CONDVENDA = 8
              and I.CODPROD = U.CODPROD),0)
            - nvl((select SUM (M.qt)
                   from PCPEDC C
                   join PCNFSAID S on C.NUMPED = S.NUMPED
                   join PCESTCOM E on S.NUMTRANSVENDA = E.NUMTRANSVENDA   
                   join PCMOV    M on E.NUMTRANSENT = M.NUMTRANSENT  
                   where 0=0
   		           and C.NUMPEDENTFUT = U.NUMPED
   		           and M.CODPROD = U.CODPROD
                                             ),0))  QTENTREGUE,
(SUM( U.QT))
              - (nvl((select SUM (I.QT)
                      from PCPEDI I
                      join PCPEDC C on I.NUMPED = C.NUMPED
                      where 0=0
		              and C.NUMPEDENTFUT = U.NUMPED
                      and C.CONDVENDA = 8
                      and I.CODPROD = U.CODPROD),0)
                    - nvl((select SUM (M.QT)
                           from PCPEDC C
                           join PCNFSAID S on C.NUMPED = S.NUMPED
                           join PCESTCOM E on S.NUMTRANSVENDA = E.NUMTRANSVENDA   
                           join PCMOV    M on E.NUMTRANSENT = M.NUMTRANSENT  
                           where 0=0
   		                   and C.NUMPEDENTFUT = U.NUMPED
   		                   and M.CODPROD = U.CODPROD
                                                     ),0)) as QT_A_ENTREGAR,
    case 
    when nvl((select SUM (M.QT)  
          from PCPEDC C
          join PCNFSAID S on C.NUMPED = S.NUMPED
          join PCESTCOM E on S.NUMTRANSVENDA = E.NUMTRANSVENDA   
          join PCMOV    M on E.NUMTRANSENT = M.NUMTRANSENT  
   		  where 0=0
   		  and C.NUMPEDENTFUT = U.NUMPED 
   		  and M.CODPROD = U.CODPROD),0) = 0 
    then nvl((select SUM (M.QT)  
          from PCPEDC C
          join PCNFSAID S on C.NUMPED = S.NUMPED
          join PCESTCOM E on S.NUMTRANSVENDA = E.NUMTRANSVENDA   
          join PCMOV    M on E.NUMTRANSENT = M.NUMTRANSENT  
   		  where 0=0
   		  and C.NUMPED = U.NUMPED 
   		  and M.CODPROD = U.CODPROD),0) 
   else  (select SUM (M.QT)  
          from PCPEDC C
          join PCNFSAID S on C.NUMPED = S.NUMPED
          join PCESTCOM E on S.NUMTRANSVENDA = E.NUMTRANSVENDA   
          join PCMOV    M on E.NUMTRANSENT = M.NUMTRANSENT  
   		  where 0=0
   		  and C.NUMPEDENTFUT = U.NUMPED 
   		  and M.CODPROD = U.CODPROD)
   	end QTDEVOLVIDA
   		  
from PCPEDI U      
join PCPRODUT P on U.CODPROD = P.CODPROD
join PCNFSAID S on U.NUMPED = S.NUMPED  
join PCCLIENT G on U.CODCLI = G.CODCLI
where 0=0
and U.NUMPED in (select NUMPED 
                 from PCNFSAID 
                 where 0=0
                 and CODFILIAL in ('2')
               --  and NUMNOTA in(:NUMNOTA)
                 and CODCLI in ('29494')
                 and DTFAT between ('01/01/2023') and ('10/12/2023')
                 and CONDVENDA = 7
                      )
and U.CODPROD = P.CODPROD 
group by U.NUMPED,
         U.CODPROD,
		 U.PERDESC, 
		 U.CODAUXILIAR,
		 U.CODFILIALRETIRA,
		 P.TIPOMERC,
		 S.NUMNOTA,
         S.CODFILIAL,
         U.DATA,
         G.CODCLI,
         G.CLIENTE
having (SUM( U.QT))
              - (nvl((select SUM (I.QT)
                      from PCPEDI I
                      join PCPEDC C on I.NUMPED = C.NUMPED
                      where 0=0
		              and C.NUMPEDENTFUT = U.NUMPED
                      and C.CONDVENDA = 8
                      and I.CODPROD = U.CODPROD),0)
                    - nvl((select SUM (M.QT)
                           from PCPEDC C
                           join PCNFSAID S on C.NUMPED = S.NUMPED
                           join PCESTCOM E on S.NUMTRANSVENDA = E.NUMTRANSVENDA   
                           join PCMOV    M on E.NUMTRANSENT = M.NUMTRANSENT  
                           where 0=0
   		                   and C.NUMPEDENTFUT = U.NUMPED
   		                   and M.CODPROD = U.CODPROD
                                                     ),0)) > 0 
and (sum(U.QT)) - (nvl((select SUM(I.QT)
                            from PCPEDI I
                            join PCPEDC C ON I.NUMPED = C.NUMPED
                            where 0 = 0
                            and C.NUMPEDENTFUT = U.NUMPED
                            and C.CONDVENDA = 8
                            and I.CODPROD = U.CODPROD), 0)
                            - nvl((select SUM(M.QT)
                                   from PCPEDC C
                                   join PCNFSAID S on C.NUMPED = S.NUMPED
                                   join PCESTCOM E on S.NUMTRANSVENDA = E.NUMTRANSVENDA
                                   join PCMOV M on E.NUMTRANSENT = M.NUMTRANSENT
                                   where 0 = 0
                                   and C.NUMPEDENTFUT = U.NUMPED
                                   and M.CODPROD = U.CODPROD), 0)) <> 
                           (case 
                                   when nvl((select sum(M.QT)
                                             from PCPEDC C
                                             join PCNFSAID S on C.NUMPED = S.NUMPED
                                             join PCESTCOM E on S.NUMTRANSVENDA = E.NUMTRANSVENDA
                                             join PCMOV M on E.NUMTRANSENT = M.NUMTRANSENT
                                             where 0 = 0
                                             and C.NUMPEDENTFUT = U.NUMPED
                                             and M.CODPROD = U.CODPROD), 0) = 0
                                   then nvl((select sum(M.QT)
                                             from PCPEDC C
                                             join PCNFSAID S on C.NUMPED = S.NUMPED
                                             join PCESTCOM E on S.NUMTRANSVENDA = E.NUMTRANSVENDA
                                             join PCMOV M on E.NUMTRANSENT = M.NUMTRANSENT
                                             where 0 = 0
                                             and C.NUMPED = U.NUMPED
                                             and M.CODPROD = U.CODPROD), 0)
                                   else     (select sum(M.QT)
                                             from PCPEDC C
                                             join PCNFSAID S on C.NUMPED = S.NUMPED
                                             join PCESTCOM E on S.NUMTRANSVENDA = E.NUMTRANSVENDA
                                             join PCMOV M on E.NUMTRANSENT = M.NUMTRANSENT
                                             where 0 = 0
                                             and C.NUMPEDENTFUT = U.NUMPED
                                             and M.CODPROD = U.CODPROD)
                                   end)
                                             or 
                          (case 
                                   when nvl((select SUM(M.QT)
                                             from PCPEDC C
                                             join PCNFSAID S on C.NUMPED = S.NUMPED
                                             join PCESTCOM E on S.NUMTRANSVENDA = E.NUMTRANSVENDA
                                             join PCMOV M on E.NUMTRANSENT = M.NUMTRANSENT
                                             where 0 = 0
                                             and C.NUMPEDENTFUT = U.NUMPED
                                             and M.CODPROD = U.CODPROD), 0) is null then 0
                                   else nvl((select SUM(M.QT)
                                             from PCPEDC C
                                             join PCNFSAID S on C.NUMPED = S.NUMPED
                                             join PCESTCOM E on S.NUMTRANSVENDA = E.NUMTRANSVENDA
                                             join PCMOV M on E.NUMTRANSENT = M.NUMTRANSENT
                                             where 0 = 0
                                             and C.NUMPEDENTFUT = U.NUMPED
                                             and M.CODPROD = U.CODPROD), 0)
                                   end) is null

order by U.NUMPED 