select F.CODUSUR,
  to_char(sum((F.CUSTOULTENT * F.QT) + (((F.PERCOM/100) * F.PUNIT)* F.QT) + (((F.CODICMTAB/100) * F.PUNIT)* F.QT)), 
  '9G999G999G999D99', 'NLS_NUMERIC_CHARACTERS = '',.''') as CUSTO,
 to_char(sum((F.PUNIT * F.QT) + (nvl(F.VLFRETE, 0) * F.QT) + (nvl(F.VLOUTROS, 0) * F.QT)), '9G999G999G999D99', 'NLS_NUMERIC_CHARACTERS = '',.''') as FATURAMENTO,
 to_char(sum((F.PUNIT * F.QT) + (nvl(F.VLFRETE, 0) * F.QT) + (nvl(F.VLOUTROS, 0) * F.QT)) - sum((F.CUSTOULTENT * F.QT) + (((F.PERCOM/100) * F.PUNIT)* F.QT) + (((F.CODICMTAB/100) * F.PUNIT)* F.QT)), '9G999G999G999D99', 'NLS_NUMERIC_CHARACTERS = '',.''') as REC

  FROM U_CO1QYD_WI.PCMOV F

LEFT JOIN PCCLIENT C ON C.CODCLI=F.CODCLI
LEFT JOIN PCUSUARI S ON S.CODUSUR=F.CODUSUR

WHERE 
F.CODOPER IN ('S')
AND F.CODFISCAL NOT IN (5117,6117)
AND F.DTCANCEL IS NULL
AND (F.CODDEVOL NOT IN (43) OR F.CODDEVOL IS NULL)
and F.CODUSUR  = '1114'
and F.DTMOV between '01/07/2023' and '31/07/2023'
group by F.CODUSUR;


-- consulta 1
select F.CODUSUR,
       to_char(sum((F.CUSTOULTENT * F.QT) + (((F.PERCOM/100) * F.PUNIT) * F.QT) + (((F.CODICMTAB/100) * F.PUNIT) * F.QT)), '9G999G999G999D99', 'NLS_NUMERIC_CHARACTERS = '',.''') as CUSTO,
       to_char(sum((F.PUNIT * F.QT) + (nvl(F.VLFRETE, 0) * F.QT) + (nvl(F.VLOUTROS, 0) * F.QT)), '9G999G999G999D99', 'NLS_NUMERIC_CHARACTERS = '',.''') as FATURAMENTO,
       to_char(sum((F.PUNIT * F.QT) + (nvl(F.VLFRETE, 0) * F.QT) + (nvl(F.VLOUTROS, 0) * F.QT)) - sum((F.CUSTOULTENT * F.QT) + (((F.PERCOM/100) * F.PUNIT) * F.QT) + (((F.CODICMTAB/100) * F.PUNIT) * F.QT)), '9G999G999G999D99', 'NLS_NUMERIC_CHARACTERS = '',.''') as REC
  from PCMOV F
       left join PCCLIENT C on C.CODCLI = F.CODCLI
       left join PCUSUARI S on S.CODUSUR = F.CODUSUR
 where F.CODOPER IN ('S')
       and F.CODFISCAL NOT IN (5117, 6117)
       and F.DTCANCEL IS NULL
       and (F.CODDEVOL NOT IN (43) or F.CODDEVOL IS NULL)
       and F.CODUSUR = '1114'
       and F.DTMOV between ('01/07/2023') and ('31/07/2023')
 group by F.CODUSUR
;

--consulta 2
select F.CODUSUR,
       to_char(sum((F.CUSTOULTENT * F.QT) + (((F.PERCOM/100) * F.PUNIT) * F.QT) + (((F.CODICMTAB/100) * F.PUNIT) * F.QT)) * -1, '9G999G999G999D99', 'NLS_NUMERIC_CHARACTERS = '',.''') as CUSTO,
       to_char(sum((F.PUNIT * F.QT) + (nvl(F.VLFRETE, 0) * F.QT) + (nvl(F.VLOUTROS, 0) * F.QT)) * -1, '9G999G999G999D99', 'NLS_NUMERIC_CHARACTERS = '',.''') as FATURAMENTO,
       to_char((sum((F.PUNIT * F.QT) + (nvl(F.VLFRETE, 0) * F.QT) + (nvl(F.VLOUTROS, 0) * F.QT)) - sum((F.CUSTOULTENT * F.QT) + (((F.PERCOM/100) * F.PUNIT) * F.QT) + (((F.CODICMTAB/100) * F.PUNIT) * F.QT))) * -1, '9G999G999G999D99', 'NLS_NUMERIC_CHARACTERS = '',.''') as REC
  from PCMOV F
       left join PCCLIENT C on C.CODCLI = F.CODCLI
       left join PCUSUARI S on S.CODUSUR = F.CODUSUR
 where F.CODOPER in ('ED')
       and F.CODFISCAL not in (5117, 6117)
       and F.DTCANCEL is null
       and (F.CODDEVOL not in (43) or F.CODDEVOL IS NULL)
       and F.CODUSUR = '1114'
       and F.DTMOV between ('01/07/2023') and ('31/07/2023')
 group by F.CODUSUR;
 
 
 -- juntar as 2
 
 SELECT
    S.CODUSUR,
    TO_CHAR(
        SUM(S.CUSTO),
        '9G999G999G999D99',
        'NLS_NUMERIC_CHARACTERS = '',.'
    ) AS CUSTO,
    TO_CHAR(
        SUM(S.FATURAMENTO),
        '9G999G999G999D99',
        'NLS_NUMERIC_CHARACTERS = '',.'
    ) AS FATURAMENTO,
    TO_CHAR(
        SUM(S.FATURAMENTO - S.CUSTO),
        '9G999G999G999D99',
        'NLS_NUMERIC_CHARACTERS = '',.'
    ) AS REC
FROM  (
    SELECT
        F.CODUSUR,
        SUM(
            (F.CUSTOULTENT * F.QT) + (((F.PERCOM/100) * F.PUNIT) * F.QT) + (((F.CODICMTAB/100) * F.PUNIT) * F.QT)
        ) AS CUSTO,
        SUM(
            (F.PUNIT * F.QT) + (NVL(F.VLFRETE, 0) * F.QT) + (NVL(F.VLOUTROS, 0) * F.QT)
        ) AS FATURAMENTO,
        SUM(
            (F.PUNIT * F.QT) + (NVL(F.VLFRETE, 0) * F.QT) + (NVL(F.VLOUTROS, 0) * F.QT)
            - (F.CUSTOULTENT * F.QT) - (((F.PERCOM/100) * F.PUNIT) * F.QT) - (((F.CODICMTAB/100) * F.PUNIT) * F.QT)
        ) AS REC
    FROM
        PCMOV F
        LEFT JOIN PCCLIENT C ON C.CODCLI = F.CODCLI
        LEFT JOIN PCUSUARI S ON S.CODUSUR = F.CODUSUR
    WHERE
        F.CODOPER IN ('S')
        AND F.CODFISCAL NOT IN (5117, 6117)
        AND F.DTCANCEL IS NULL
        AND (F.CODDEVOL NOT IN (43) OR F.CODDEVOL IS NULL)
        AND F.CODUSUR = '1114'
        AND F.DTMOV BETWEEN TO_DATE('01/07/2023', 'DD/MM/YYYY') AND TO_DATE('31/07/2023', 'DD/MM/YYYY')
    GROUP BY
        F.CODUSUR

    UNION ALL

    SELECT
        F.CODUSUR,
        SUM(
            -((F.CUSTOULTENT * F.QT) + (((F.PERCOM/100) * F.PUNIT) * F.QT) + (((F.CODICMTAB/100) * F.PUNIT) * F.QT))
        ) AS CUSTO,
        SUM(
            -((F.PUNIT * F.QT) + (NVL(F.VLFRETE, 0) * F.QT) + (NVL(F.VLOUTROS, 0) * F.QT))
        ) AS FATURAMENTO,
        SUM(
            -((F.PUNIT * F.QT) + (NVL(F.VLFRETE, 0) * F.QT) + (NVL(F.VLOUTROS, 0) * F.QT))
            - ((F.CUSTOULTENT * F.QT) + (((F.PERCOM/100) * F.PUNIT) * F.QT) + (((F.CODICMTAB/100) * F.PUNIT) * F.QT))
        ) AS REC
    FROM
        PCMOV F
        LEFT JOIN PCCLIENT C ON C.CODCLI = F.CODCLI
        LEFT JOIN PCUSUARI S ON S.CODUSUR = F.CODUSUR
    WHERE
        F.CODOPER IN ('ED')
        AND F.CODFISCAL NOT IN (5117, 6117)
        AND F.DTCANCEL IS NULL
        AND (F.CODDEVOL NOT IN (43) OR F.CODDEVOL IS NULL)
        AND F.CODUSUR = '1114'
        AND F.DTMOV BETWEEN TO_DATE('01/07/2023', 'DD/MM/YYYY') AND TO_DATE('31/07/2023', 'DD/MM/YYYY')
    GROUP BY
        F.CODUSUR
) S
GROUP BY
    S.CODUSUR;
    
-- finalmente

select
    S.CODUSUR,
    to_char(sum(S.CUSTO),'9G999G999G999D99','NLS_NUMERIC_CHARACTERS = '',.') as CUSTO,
    to_char(sum(S.FATURAMENTO),'9G999G999G999D99','NLS_NUMERIC_CHARACTERS = '',.') as FATURAMENTO,
    to_char(sum(S.FATURAMENTO - S.CUSTO),'9G999G999G999D99','NLS_NUMERIC_CHARACTERS = '',.') as REC,
    to_char((sum(S.FATURAMENTO - S.CUSTO) / sum(S.FATURAMENTO)) * 100,'9G999G999G999D99','NLS_NUMERIC_CHARACTERS = '',.') as MARG 
from  (
    select
        F.CODUSUR,
        sum((F.CUSTOULTENT * F.QT) + (((F.PERCOM/100) * F.PUNIT) * F.QT) + (((F.CODICMTAB/100) * F.PUNIT) * F.QT)) as CUSTO,
        sum((F.PUNIT * F.QT) + (nvl(F.VLFRETE, 0) * F.QT) + (nvl(F.VLOUTROS, 0) * F.QT)) as FATURAMENTO,
        sum((F.PUNIT * F.QT) + (nvl(F.VLFRETE, 0) * F.QT) + (nvl(F.VLOUTROS, 0) * F.QT)
        - (F.CUSTOULTENT * F.QT) - (((F.PERCOM/100) * F.PUNIT) * F.QT) - (((F.CODICMTAB/100) * F.PUNIT) * F.QT)) as REC
    from
        PCMOV F
        left join PCCLIENT C on C.CODCLI = F.CODCLI
        left join PCUSUARI S on S.CODUSUR = F.CODUSUR
    where
        F.CODOPER in ('S')
        and F.CODFISCAL not in (5117, 6117)
        and F.DTCANCEL is null
        and (F.CODDEVOL not in (43) or F.CODDEVOL is null)
        and F.CODUSUR in ('1011','1114')
        and F.DTMOV between ('01/07/2023') and ('31/07/2023')
    group by
        F.CODUSUR

    union all

    select
        F.CODUSUR,
        sum(-((F.CUSTOULTENT * F.QT) + (((F.PERCOM/100) * F.PUNIT) * F.QT) + (((F.CODICMTAB/100) * F.PUNIT) * F.QT))) as CUSTO,
        sum(-((F.PUNIT * F.QT) + (nvl(F.VLFRETE, 0) * F.QT) + (nvl(F.VLOUTROS, 0) * F.QT))) as FATURAMENTO,
        sum(-((F.PUNIT * F.QT) + (nvl(F.VLFRETE, 0) * F.QT) + (nvl(F.VLOUTROS, 0) * F.QT))
        - ((F.CUSTOULTENT * F.QT) + (((F.PERCOM/100) * F.PUNIT) * F.QT) + (((F.CODICMTAB/100) * F.PUNIT) * F.QT))) as REC
    from
        PCMOV F
        left join PCCLIENT C on C.CODCLI = F.CODCLI
        left join PCUSUARI S on S.CODUSUR = F.CODUSUR
    where
        F.CODOPER in ('ED')
        and F.CODFISCAL not in (5117, 6117)
        and F.DTCANCEL is null
        and (F.CODDEVOL not in (43) or F.CODDEVOL is null)
        and F.CODUSUR in ('1011','1114')
        and F.DTMOV between ('01/07/2023') and ('31/07/2023')
    group by
        F.CODUSUR
) S
group by
    S.CODUSUR;