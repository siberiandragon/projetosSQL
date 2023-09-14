select E.CODFILIAL,
       P.MODULO, 
       P.RUA, 
       P.NUMERO, 
       P.APTO,
       P.CODPROD,
       P.DV,
       P.DESCRICAO,
       P.CODAUXILIAR,
       P.CODFAB, 
       P.EMBALAGEM, 
       P.PONTOREPOSICAO,
       P.PONTOREPOSICAOCX,
       P.LASTROPAL,
       P.ALTURAPAL,
       P.QTTOTPAL,
       P.CAPACIDADEPICKING,
       P.UNIDADE,
        case 
          when E.CODFILIAL ='2'
          then 'OLI ' || E.MODULO || '.' || E.RUA ||  '.' || E.APTO ||  '.' || E.NUMERO 
          when E.CODFILIAL ='3'
          then 'REC ' || E.MODULO || '.' || E.RUA ||  '.' || E.APTO ||  '.' || E.NUMERO 
          when E.CODFILIAL ='4'
          then 'NAT ' || E.MODULO || '.' || E.RUA ||  '.' || E.APTO ||  '.' || E.NUMERO 
          else 'NDA'
         
END ENDERECO
       
from   PCPRODUT P
join PCEST E on P.CODPROD = E.CODPROD
where 1 = 1
 and P.CODPROD = '804'
 and E.CODFILIAL = '4'
 order by P.CODPROD