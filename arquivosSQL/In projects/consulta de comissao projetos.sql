select 
  P3.CODFILIAL AS FILIAL,
  S.DTSAIDA AS DATA,
  P3.NUMNOTA AS N_NOTA,
  P3.CODCLI,
  C.CLIENTE,
  S.VLTOTAL,
  (S.VLTOTAL - nvl(S.VLDEVOLUCAO, 0)) AS LIQD,
  S.DTDEVOL,
  S.VLDEVOLUCAO,
  P3.CODUSUR AS RCA,
  U.NOME AS NOME,

  case 
      when P3.CODUSUR2 is not null then P3.CODUSUR2
      when P3.CODUSUR2 is null and P3.CODUSUR3 is not null then P3.CODUSUR3
      when P3.CODUSUR2 is null and P3.CODUSUR3 is null then P3.CODUSUR4
      else null
  end AS RCA_PRO_1,
  
  case 
      when P3.CODUSUR2 is not null then U2.NOME
      when P3.CODUSUR2 is null and P3.CODUSUR3 is not null then U3.NOME
      when P3.CODUSUR2 is null and P3.CODUSUR3 is null then U4.NOME
      else null
  end AS PRO_1,
  
  ROUND((S.VLTOTAL - nvl(S.VLDEVOLUCAO, 0)) *
    (case 
       when ((case when P3.CODUSUR2 is not null then 1 else 0 end) +
             (case when P3.CODUSUR3 is not null then 1 else 0 end) +
             (case when P3.CODUSUR4 is not null then 1 else 0 end)) = 1 
       then 0.002
       when ((case when P3.CODUSUR2 is not null then 1 else 0 end) +
             (case when P3.CODUSUR3 is not null then 1 else 0 end) +
             (case when P3.CODUSUR4 is not null then 1 else 0 end)) = 2 
       then 0.001
       when ((case when P3.CODUSUR2 is not null then 1 else 0 end) +
             (case when P3.CODUSUR3 is not null then 1 else 0 end) +
             (case when P3.CODUSUR4 is not null then 1 else 0 end)) = 3 
       then 0.0006
    else 0
    end)
  ,2) AS COMISSAO_PROFISSIONAL,
  
  case 
    when P3.CODUSUR2 is not null then 
         case 
           when P3.CODUSUR3 is not null then P3.CODUSUR3
           when P3.CODUSUR3 is null then P3.CODUSUR4
         end
    when P3.CODUSUR2 is null then 
         case 
           when P3.CODUSUR3 is not null then P3.CODUSUR4
           else null
         end
    else null
  end AS RCA_PRO_2,
  
  case 
    when P3.CODUSUR2 is not null then 
         case 
           when P3.CODUSUR3 is not null then U3.NOME
           when P3.CODUSUR3 is null then U4.NOME
         end
    when P3.CODUSUR2 is null then 
         case 
           when P3.CODUSUR3 is not null then U4.NOME
           else null
         end
    else null
  end AS PRO_2,
  
  case 
    when ((case when P3.CODUSUR2 is not null then 1 else 0 end) +
          (case when P3.CODUSUR3 is not null then 1 else 0 end) +
          (case when P3.CODUSUR4 is not null then 1 else 0 end)) >= 2 
    then ROUND((S.VLTOTAL - nvl(S.VLDEVOLUCAO, 0)) *
         (case 
            when ((case when P3.CODUSUR2 is not null then 1 else 0 end) +
                  (case when P3.CODUSUR3 is not null then 1 else 0 end) +
                  (case when P3.CODUSUR4 is not null then 1 else 0 end)) = 1 
            then 0.002
            when ((case when P3.CODUSUR2 is not null then 1 else 0 end) +
                  (case when P3.CODUSUR3 is not null then 1 else 0 end) +
                  (case when P3.CODUSUR4 is not null then 1 else 0 end)) = 2 
            then 0.001
            when ((case when P3.CODUSUR2 is not null then 1 else 0 end) +
                  (case when P3.CODUSUR3 is not null then 1 else 0 end) +
                  (case when P3.CODUSUR4 is not null then 1 else 0 end)) = 3 
            then 0.0006
            else 0
          end)
    ,2)
    else null
  end AS COMISSAO_PROFISSIONAL2,
  
  case 
    when P3.CODUSUR2 is not null and P3.CODUSUR3 is not null and P3.CODUSUR4 is not null 
    then P3.CODUSUR4
    else null
  end AS RCA_PRO_3,
  
  case 
    when P3.CODUSUR2 is not null and P3.CODUSUR3 is not null and P3.CODUSUR4 is not null 
    then U4.NOME
    else null
  end AS PRO_3,
  
  
  case 
    when ((case when P3.CODUSUR2 is not null then 1 else 0 end) +
          (case when P3.CODUSUR3 is not null then 1 else 0 end) +
          (case when P3.CODUSUR4 is not null then 1 else 0 end)) = 3 
    then ROUND((S.VLTOTAL - nvl(S.VLDEVOLUCAO, 0)) *
         (case 
            when ((case when P3.CODUSUR2 is not null then 1 else 0 end) +
                  (case when P3.CODUSUR3 is not null then 1 else 0 end) +
                  (case when P3.CODUSUR4 is not null then 1 else 0 end)) = 3 
            then 0.0006
            else 0
          end)
    ,2)
    else null
  end AS COMISSAO_PROFISSIONAL3
  
from PCPEDC P3
join PCNFSAID S on P3.NUMTRANSVENDA = S.NUMTRANSVENDA 
join PCUSUARI U on P3.CODUSUR = U.CODUSUR
left join PCUSUARI U2 on P3.CODUSUR2 = U2.CODUSUR
left join PCUSUARI U3 on P3.CODUSUR3 = U3.CODUSUR
left join PCUSUARI U4 on P3.CODUSUR4 = U4.CODUSUR
join PCCLIENT C on P3.CODCLI = C.CODCLI
where 0=0
  and P3.POSICAO = 'F'
  and S.DTSAIDA between :DTINI and :DTFIM
  and S.CODFILIAL in (:CODFILIAL)
  and S.NUMNOTA in (:NUMNOTA)
  and S.TIPOMOVGARANTIA is null
  and (P3.CODUSUR2 is not null or P3.CODUSUR3 is not null or P3.CODUSUR4 is not null)
  and S.CONDVENDA in ('1', '7');
