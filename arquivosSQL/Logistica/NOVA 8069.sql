SELECT 
       CODFILIALRETIRA FILIAL,
       NUMNOTA N_NOTA,
       NUMPED, 
       CODCLI,
       CLIENTE,
       DATA,
       CODPROD,
       CODFAB,
       DESCRICAO, 
       EMBALAGEM, 
       UNIDADE, 
       SUM(NVL(QT, 0)) QT, 
       --MAX(NVL(PVENDA, 0)) PVENDA, 
       --SUM(VLTOTAL) VLTOTAL, 
       SUM(QTFUTURA) QTFUTURA, 
       --MAX(PVENDAFUTURA) PVENDAFUTURA, 
       --SUM(VLTOTALFUTURA) VLTOTALFUTURA, 
       SUM(QT - QTFUTURA - (QTDEVOL7 - QTDEVOL8)) AS QT_A_ENTREGAR, 
       MAX(QTDEVOL7) AS QTDEVOL7, 
       MAX(QTDEVOL8) AS QTDEVOL8 
       FROM (SELECT TIPO7.CODFILIALRETIRA,
               TIPO7.NUMNOTA,
               TIPO7.NUMPED, 
               TIPO7.CODCLI,
               TIPO7.CLIENTE,
               TIPO7.DATA,
               TIPO7.CODPROD,
               TIPO7.CODFAB,
               TIPO7.DESCRICAO, 
               TIPO7.EMBALAGEM, 
               TIPO7.UNIDADE,  
               SUM(NVL(TIPO7.QT, 0)) QT, 
               --MAX(NVL(TIPO7.PVENDA, 0)) PVENDA, 
               --SUM(TIPO7.VLTOTAL) VLTOTAL, 
               0 QTFUTURA, 
               --0 PVENDAFUTURA, 
               --0 VLTOTALFUTURA, 
               MAX(QTDEVOL) AS  QTDEVOL7,
               0            AS QTDEVOL8
               FROM (SELECT CODPROD,
                       NUMNOTA,
                       DATA,
                       CODFILIALRETIRA,
                       NUMPED, 
                       CODCLI,
                       CLIENTE,
                       CODFAB,
                       DESCRICAO, 
                       EMBALAGEM, 
                       UNIDADE, 
                       SUM(NVL(QT, 0)) QT, 
                       --MAX(NVL(PVENDA, 0)) PVENDA, 
                       --SUM(VLTOTAL) VLTOTAL, 
                       0 QTFUTURA, 
                       --0 PVENDAFUTURA, 
                       --0 VLTOTALFUTURA, 
                       SUM(QTDEVOL) AS  QTDEVOL
                         FROM (SELECT PCPEDI.CODPROD, 
                               PCPEDC.NUMNOTA,
                               PCPEDC.DATA,
                               PCPEDI.CODFILIALRETIRA,
                               PCPEDI.NUMPED,
                               PCPEDC.CODCLI,
                               PCCLIENT.CLIENTE,
                               PCPRODUT.CODFAB,
                               PCPRODUT.DESCRICAO, 
                               PCPRODUT.EMBALAGEM, 
                               PCPRODUT.UNIDADE, 
                               PCPEDI.QT, 
                               --PCPEDI.PVENDA, 
                               --(NVL(PCPEDI.QT, 0) * NVL(PCPEDI.PVENDA, 0)) VLTOTAL, 
                               0 QTFUTURA, 
                               --0 PVENDAFUTURA, 
                               --0 VLTOTALFUTURA, 
                               ( NVL((SELECT SUM (pcmov.qt)
                                         FROM pcestcom, pcmov
                                          WHERE pcestcom.numtransent = pcmov.numtransent
                                          AND pcmov.numped = pcpedc.numped
                                          AND pcmov.codprod = pcprodut.codprod
                                          AND PCMOV.DTCANCEL IS NULL
                                          AND pcmov.codprod = PCPEDI.codprod AND PCMOV.NUMSEQ = PCPEDI.NUMSEQ),0)) AS QTDEVOL
                          FROM PCPEDI,
                               PCPEDC,
                             PCPRODUT,
                             PCUSUARI,
                             PCCLIENT 
                         WHERE 0=0 
                           and PCPEDI.CODPROD = PCPRODUT.CODPROD 
                           AND PCPEDC.NUMPED = PCPEDI.NUMPED 
                           AND PCPEDC.CODUSUR = PCUSUARI.CODUSUR
                           AND PCPEDC.CODCLI = PCCLIENT.CODCLI 
                           AND PCPEDC.CONDVENDA = 7 
                           AND PCPEDC.DATA >= '05/03/2023'
                           AND PCPEDC.DATA <= '04/04/2024'
                           --and PCPEDI.CODFILIALRETIRA in ('3','2')
                           --and PCPEDC.CODCLI in ('20261','19185')    
                           AND ((PCPEDC.NUMNOTA=16096) 
                           OR (PCPEDC.NUMCUPOM=16096))
                           AND TRUNC(PCPEDC.DATA) >= '03/05/2023'
                           AND TRUNC(PCPEDC.DATA) <= '04/04/2024'

AND PCPEDC.POSICAO IN ('','M','L','B','P','F','')
 ) 
                 GROUP BY CODPROD,
                          NUMNOTA,
                             DATA,
                           NUMPED, 
                           CODCLI, 
                          CLIENTE, 
                  CODFILIALRETIRA,
                           CODFAB,
                        DESCRICAO, 
                        EMBALAGEM,
                          UNIDADE) TIPO7 
 
         GROUP BY TIPO7.CODPROD,
                  TIPO7.NUMNOTA,
                  TIPO7.DATA,
                  TIPO7.CODFILIALRETIRA, 
                  TIPO7.NUMPED,                 
                  TIPO7.CODCLI,
                  TIPO7.CLIENTE,
                  TIPO7.CODFAB,
                  TIPO7.DESCRICAO, 
                  TIPO7.EMBALAGEM, 
                  TIPO7.UNIDADE 
 
        UNION 
 
SELECT
      TIPO8.CODFILIALRETIRA,
      TIPO8.NUMNOTA,
      TIPO8.NUMPED, 
      TIPO8.CODCLI,
      TIPO8.CLIENTE,
      TIPO8.DATA,
      TIPO8.CODPROD,
      TIPO8.CODFAB,
      TIPO8.DESCRICAO, 
      TIPO8.EMBALAGEM, 
      TIPO8.UNIDADE, 
      0 QT, 
      --0 PVENDA, 
      --0 VLTOTAL, 
      SUM(NVL(TIPO8.QTFUTURA, 0)) QTFUTURA, 
      --MAX(NVL(TIPO8.PVENDAFUTURA, 0)) PVENDAFUTURA, 
      --SUM(TIPO8.VLTOTALFUTURA) VLTOTALFUTURA,
      0                AS QTDEVOL7,
      MAX((QTDEVOL))   AS QTDEVOL8
      FROM (SELECT CODPROD,
                       NUMNOTA,
                       DATA,
                       CODFILIALRETIRA,
                       NUMPED, 
                       CODCLI,
                       CLIENTE,
                       CODFAB,
                       DESCRICAO, 
                       EMBALAGEM, 
                       UNIDADE, 
                       0 QT, 
                       --0 PVENDA, 
                       --0 VLTOTAL, 
                       SUM(QTFUTURA) QTFUTURA, 
                       --MAX(PVENDAFUTURA) PVENDAFUTURA, 
                       --SUM(VLTOTALFUTURA) VLTOTALFUTURA, 
                       SUM(NVL(QTDEVOL,0)) AS QTDEVOL 
                         FROM (SELECT PCPEDI.CODPROD, 
                               PCPEDC.NUMNOTA,
                               PCPEDC.DATA,
                               PCPEDI.CODFILIALRETIRA,
                               PCPEDC.CODCLI,
                               PCCLIENT.CLIENTE,
                               PCPRODUT.CODFAB,
                               PCPRODUT.DESCRICAO, 
                               PCPRODUT.EMBALAGEM, 
                               PCPRODUT.UNIDADE, 
                               PCPEDC.NUMPEDENTFUT AS NUMPED, 
                               0 QT, 
                               --0 PVENDA, 
                               --0 VLTOTAL, 
                               PCPEDI.QT AS QTFUTURA, 
                               --PCPEDI.PVENDA AS PVENDAFUTURA, 
                               --(NVL(PCPEDI.QT, 0) * NVL(PCPEDI.PVENDA, 0)) AS VLTOTALFUTURA, 
                               ( NVL((SELECT SUM (pcmov.qt)
                                         FROM pcestcom, pcmov
                                          WHERE pcestcom.numtransent = pcmov.numtransent
                                          AND pcmov.numped = pcpedc.numped
                                          AND pcmov.codprod = pcprodut.codprod
                                          AND PCMOV.DTCANCEL IS NULL
                                          AND pcmov.codprod = PCPEDI.codprod  AND PCMOV.NUMSEQ = PCPEDI.NUMSEQ),0)) AS QTDEVOL
                          FROM PCPEDI,
                               PCPEDC,
                             PCPRODUT,
                             PCUSUARI,
                             PCCLIENT
                         WHERE PCPEDI.CODPROD = PCPRODUT.CODPROD 
                           AND PCPEDC.NUMPED = PCPEDI.NUMPED 
                           AND PCPEDC.CODUSUR = PCUSUARI.CODUSUR 
                           AND PCPEDC.CODCLI = PCCLIENT.CODCLI
                           AND PCPEDC.CONDVENDA = 8 
                           AND PCPEDC.NUMPEDENTFUT IS NOT NULL 
                           --and PCPEDI.CODFILIALRETIRA in ('3','2')
                           --and PCPEDC.CODCLI in ('20261','19185')                           
                           AND ((PCPEDC.NUMNOTA=16096) 
                           OR  (PCPEDC.NUMCUPOM=16096))
                           AND TRUNC(PCPEDC.DATA) >= '03/05/2023'
                           AND TRUNC(PCPEDC.DATA) <= '04/04/2024'
                           AND PCPEDC.POSICAO IN ('','M','L','B','P','F','')
 )
                 GROUP BY CODPROD,
                          NUMNOTA,
                             DATA,
                           CODCLI, 
                          CLIENTE, 
                           NUMPED, 
                  CODFILIALRETIRA, 
                           CODFAB, 
                        DESCRICAO,
                        EMBALAGEM,
                          UNIDADE) TIPO8 
 
         GROUP BY TIPO8.CODPROD,
                  TIPO8.NUMNOTA,
                  TIPO8.DATA,
                  TIPO8.CODFILIALRETIRA, 
                  TIPO8.NUMPED,
                  TIPO8.CODCLI,
                  TIPO8.CLIENTE,
                  TIPO8.CODFAB,
                  TIPO8.DESCRICAO, 
                  TIPO8.EMBALAGEM, 
                  TIPO8.UNIDADE) 
 
 WHERE 1 = 1 
 
 GROUP BY CODPROD,
          NUMNOTA, 
             DATA,
           NUMPED, 
          CLIENTE,
           CODCLI, 
  CODFILIALRETIRA, 
           CODFAB,
        DESCRICAO,
        EMBALAGEM,
          UNIDADE 
          
 ORDER BY      QT,
          CODPROD,
        DESCRICAO,
        EMBALAGEM,
          UNIDADE; 
          
-- Mark 2 ( Modifica��o nos campos de SALDO, A_ENTREGAR e QTFURUTA. e inclus�o da condi��o do CASE de A_ENTREGAR como um filtro de where, para trazer apenas os resultados que ainda possuem itens para ser entregues

select *
from (
    select 
       CODFILIALRETIRA FILIAL,
       NUMNOTA N_NOTA,
       NUMPED, 
       CODCLI,
       CLIENTE,
       DATA,
       CODPROD,
       CODFAB,
       DESCRICAO, 
       EMBALAGEM, 
       UNIDADE, 
       decode(sum(QT),0,sum(QTFUTURA),sum(QT)) as QT, 
        case 
            when sum(QT - QTFUTURA - (QTDEVOL7 - QTDEVOL8)) <= 0 
            then 0
            when  decode(sum(QT),0,sum(QTFUTURA),sum(QT)) - sum(QTDEVOL7 - QTDEVOL8)  > 0
            then decode(sum(QT),0,sum(QTFUTURA),sum(QT)) - sum(QTDEVOL7 - QTDEVOL8)
            when  decode(sum(QT),0,sum(QTFUTURA),sum(QT)) - sum(QTDEVOL7 - QTDEVOL8)  <= 0
            then 0
            else decode(sum(QT),0,sum(QTFUTURA),sum(QT))
        end as A_ENTREGAR,
       --MAX(NVL(PVENDA, 0)) PVENDA, 
       --SUM(VLTOTAL) VLTOTAL, 
       SUM(NVL(QTFUTURA, 0)) AS QTFUTURA,
       --MAX(PVENDAFUTURA) PVENDAFUTURA, 
       --SUM(VLTOTALFUTURA) VLTOTALFUTURA, 
       SUM(QT - QTFUTURA - (QTDEVOL7 - QTDEVOL8)) AS SALDO, 
       MAX(QTDEVOL7) AS QTDEVOL7, 
       MAX(QTDEVOL8) AS QTDEVOL8 
    from (
        select 
            TIPO7.CODFILIALRETIRA,
            TIPO7.NUMNOTA,
            TIPO7.NUMPED, 
            TIPO7.CODCLI,
            TIPO7.CLIENTE,
            TIPO7.DATA,
            TIPO7.CODPROD,
            TIPO7.CODFAB,
            TIPO7.DESCRICAO, 
            TIPO7.EMBALAGEM, 
            TIPO7.UNIDADE,  
            sum(nvl(TIPO7.QT, 0)) as QT, 
            0 as QTFUTURA, 
            max(QTDEVOL) as QTDEVOL7,
            0 as QTDEVOL8
        from (
            select 
                CODPROD,
                NUMNOTA,
                DATA,
                CODFILIALRETIRA,
                NUMPED, 
                CODCLI,
                CLIENTE,
                CODFAB,
                DESCRICAO, 
                EMBALAGEM, 
                UNIDADE, 
                sum(nvl(QT, 0)) as QT, 
                0 as QTFUTURA, 
                sum(QTDEVOL) as QTDEVOL
            from (
                select 
                    PCPEDI.CODPROD, 
                    PCPEDC.NUMNOTA,
                    PCPEDC.DATA,
                    PCPEDI.CODFILIALRETIRA,
                    PCPEDI.NUMPED,
                    PCPEDC.CODCLI,
                    PCCLIENT.CLIENTE,
                    PCPRODUT.CODFAB,
                    PCPRODUT.DESCRICAO, 
                    PCPRODUT.EMBALAGEM, 
                    PCPRODUT.UNIDADE, 
                    PCPEDI.QT, 
                    ( nvl((select sum(PCMOV.qt)
                        from PCESTCOM, PCMOV
                        where PCESTCOM.NUMTRANSENT = PCMOV.NUMTRANSENT
                        and PCMOV.NUMPED = PCPEDC.NUMPED
                        and PCMOV.CODPROD = PCPRODUT.CODPROD
                        and PCMOV.DTCANCEL IS NULL
                        and PCMOV.CODPROD = PCPEDI.CODPROD and PCMOV.NUMSEQ = PCPEDI.NUMSEQ),0)) as QTDEVOL
                from 
                    PCPEDI,
                    PCPEDC,
                    PCPRODUT,
                    PCUSUARI,
                    PCCLIENT 
                where 
                    PCPEDI.CODPROD = PCPRODUT.CODPROD 
                    and PCPEDC.NUMPED = PCPEDI.NUMPED 
                    and PCPEDC.CODUSUR = PCUSUARI.CODUSUR
                    and PCPEDC.CODCLI = PCCLIENT.CODCLI 
                    and PCPEDC.CONDVENDA = 7 
                    and PCPEDC.DATA between ('01/01/2023') and ('09/04/2024')
                    --and PCPEDI.CODFILIALRETIRA in (:CODFILIAL)
                    --and PCPEDC.CODCLI in ('17724')    
                    AND PCPEDC.NUMNOTA in ('24724')
                    --or (PCPEDC.NUMCUPOM=:NUMNOTA))
                    and TRUNC(PCPEDC.DATA) between ('01/01/2023') and ('09/04/2024')
                    and PCPEDC.POSICAO in ('','M','L','B','P','F','')
            ) 
            group by 
                CODPROD,
                NUMNOTA,
                DATA,
                NUMPED, 
                CODCLI, 
                CLIENTE, 
                CODFILIALRETIRA,
                CODFAB,
                DESCRICAO, 
                EMBALAGEM,
                UNIDADE
        ) TIPO7 
        group by 
            TIPO7.CODPROD,
            TIPO7.NUMNOTA,
            TIPO7.DATA,
            TIPO7.CODFILIALRETIRA, 
            TIPO7.NUMPED,                 
            TIPO7.CODCLI,
            TIPO7.CLIENTE,
            TIPO7.CODFAB,
            TIPO7.DESCRICAO, 
            TIPO7.EMBALAGEM, 
            TIPO7.UNIDADE 

        UNION 

        select 
            TIPO8.CODFILIALRETIRA,
            TIPO8.NUMNOTA,
            TIPO8.NUMPED, 
            TIPO8.CODCLI,
            TIPO8.CLIENTE,
            TIPO8.DATA,
            TIPO8.CODPROD,
            TIPO8.CODFAB,
            TIPO8.DESCRICAO, 
            TIPO8.EMBALAGEM, 
            TIPO8.UNIDADE, 
            0 QT, 
            sum(nvl(TIPO8.QTFUTURA, 0)) QTFUTURA, 
            0 as QTDEVOL7,
            max((QTDEVOL)) as QTDEVOL8
        from (
            select 
                CODPROD,
                NUMNOTA,
                DATA,
                CODFILIALRETIRA,
                NUMPED, 
                CODCLI,
                CLIENTE,
                CODFAB,
                DESCRICAO, 
                EMBALAGEM, 
                UNIDADE, 
                0 QT, 
                sum(QTFUTURA) QTFUTURA, 
                sum(nvl(QTDEVOL,0)) as QTDEVOL 
            from (
                select 
                    PCPEDI.CODPROD, 
                    PCPEDC.NUMNOTA,
                    PCPEDC.DATA,
                    PCPEDI.CODFILIALRETIRA,
                    PCPEDC.CODCLI,
                    PCCLIENT.CLIENTE,
                    PCPRODUT.CODFAB,
                    PCPRODUT.DESCRICAO, 
                    PCPRODUT.EMBALAGEM, 
                    PCPRODUT.UNIDADE, 
                    PCPEDC.NUMPEDENTFUT as NUMPED, 
                    0 QT, 
                    PCPEDI.QT as QTFUTURA, 
                    ( nvl((select sum (PCMOV.qt)
                        from PCESTCOM, PCMOV
                        where PCESTCOM.NUMTRANSENT = PCMOV.NUMTRANSENT
                        and PCMOV.NUMPED = PCPEDC.NUMPED
                        and PCMOV.CODPROD = PCPRODUT.CODPROD
                        and PCMOV.DTCANCEL IS NULL
                        and PCMOV.CODPROD = PCPEDI.CODPROD  
						and PCMOV.NUMSEQ = PCPEDI.NUMSEQ),0)) as QTDEVOL
                from 
                    PCPEDI,
                    PCPEDC,
                    PCPRODUT,
                    PCUSUARI,
                    PCCLIENT
                where 
                    PCPEDI.CODPROD = PCPRODUT.CODPROD 
                    and PCPEDC.NUMPED = PCPEDI.NUMPED 
                    and PCPEDC.CODUSUR = PCUSUARI.CODUSUR 
                    and PCPEDC.CODCLI = PCCLIENT.CODCLI
                    and PCPEDC.CONDVENDA = 8 
                    and PCPEDC.NUMPEDENTFUT is not null 
                    --and PCPEDI.CODFILIALRETIRA in (:CODFILIAL)
                    --and PCPEDC.CODCLI in ('17724')    
                    AND PCPEDC.NUMNOTA in (select NUMNOTA from PCPEDC where NUMPEDENTFUT = (select O.NUMPED from PCPEDC O where 0=0
                    and O.NUMNOTA in ('24724')
                    ))
                    --AND PCPEDC.NUMNOTA in ('24724')
                    --or (PCPEDC.NUMCUPOM=:NUMNOTA))
                    and TRUNC(PCPEDC.DATA)  between ('01/01/2023') and ('09/04/2024')
                    and PCPEDC.POSICAO in ('','M','L','B','P','F','')
            )
            group by 
                CODPROD,
                NUMNOTA,
                DATA,
                CODCLI, 
                CLIENTE, 
                NUMPED, 
                CODFILIALRETIRA, 
                CODFAB, 
                DESCRICAO,
                EMBALAGEM,
                UNIDADE
        ) TIPO8 
        group by 
            TIPO8.CODPROD,
            TIPO8.NUMNOTA,
            TIPO8.DATA,
            TIPO8.CODFILIALRETIRA, 
            TIPO8.NUMPED,
            TIPO8.CODCLI,
            TIPO8.CLIENTE,
            TIPO8.CODFAB,
            TIPO8.DESCRICAO, 
            TIPO8.EMBALAGEM, 
            TIPO8.UNIDADE
    ) 
    group by 
        CODFILIALRETIRA,
        NUMNOTA, 
        NUMPED, 
        CODCLI,
        CLIENTE,
        DATA,
        CODPROD,
        CODFAB,
        DESCRICAO, 
        EMBALAGEM, 
        UNIDADE 
) condicao
where A_ENTREGAR > 0 
order by 
        CODPROD,
		DESCRICAO,
		EMBALAGEM,
		UNIDADE;
		
	

--Mark 3 ( Algo na Mark 2 n�o batia e sempre que tententei dar um jeitinho s� piorava.
--         Ent�o retornei como base a consulta do search feito no relat�rio Entrega.Fut da RT 335 
--         Com isso adicionei novamente os campos necess�rios e criei a condi��o de A_RECEBER sobre a consulta
--         Para trazer apenas os resultados importantes para o relat�rio, sem a necessidade de retirar a consist�ncia da consulta sobre a nota)
select *
from (
select        
       CODFILIALRETIRA FILIAL,
       NUMNOTA N_NOTA,
       NUMPED, 
       CODCLI,
       CLIENTE,
       DATA,
       CODPROD,
       CODFAB,
       DESCRICAO, 
       EMBALAGEM, 
       UNIDADE, 
       sum(nvl(QT, 0)) QT, 
       --sum(QTFUTURA) QTFUTURA, 
       --sum(QT - QTFUTURA - (QTDEVOL7 - QTDEVOL8) ) as QTSALDO, 
            case 
                when sum(QT - QTFUTURA - (QTDEVOL7 - QTDEVOL8)) <= 0 
                then 0
                when  decode(sum(QT),0,sum(QTFUTURA),sum(QT)) - sum(QTDEVOL7 - QTDEVOL8)  > 0
                then decode(sum(QT),0,sum(QTFUTURA),sum(QT)) - sum(QTDEVOL7 - QTDEVOL8)
                when  decode(sum(QT),0,sum(QTFUTURA),sum(QT)) - sum(QTDEVOL7 - QTDEVOL8)  <= 0
                then 0
                else decode(sum(QT),0,sum(QTFUTURA),sum(QT))
            end as A_ENTREGAR,
       max(QTDEVOL7) as QTDEVOL7, 
       max(QTDEVOL8) as QTDEVOL8 
  from (select TIPO7.CODFILIALRETIRA,
            TIPO7.NUMNOTA,
            TIPO7.NUMPED, 
            TIPO7.CODCLI,
            TIPO7.CLIENTE,
            TIPO7.DATA,
            TIPO7.CODPROD,
            TIPO7.CODFAB,
            TIPO7.DESCRICAO, 
            TIPO7.EMBALAGEM, 
            TIPO7.UNIDADE,  
            sum(nvl(TIPO7.QT, 0)) QT, 
            0 QTFUTURA, 
            max(QTDEVOL) as  QTDEVOL7,
            0         as QTDEVOL8
            from (select  CODPROD,
                          NUMNOTA,
                          DATA,
                          CODFILIALRETIRA,
                          NUMPED, 
                          CODCLI,
                          CLIENTE,
                          CODFAB,
                          DESCRICAO, 
                          EMBALAGEM, 
                          UNIDADE, 
                          sum(NVL(QT, 0)) QT, 
                          0 QTFUTURA, 
                          sum(QTDEVOL) as  QTDEVOL
                          from (select PCPEDI.CODPROD, 
                                       PCPEDC.NUMNOTA,
                                       PCPEDC.DATA,
                                       PCPEDI.CODFILIALRETIRA,
                                       PCPEDC.NUMPED,
                                       PCPEDC.CODCLI,
                                       PCCLIENT.CLIENTE,
                                       PCPRODUT.CODFAB,
                                       PCPRODUT.DESCRICAO, 
                                       PCPRODUT.EMBALAGEM, 
                                       PCPRODUT.UNIDADE, 
                                       PCPEDI.QT,  
                                       PCPEDI.PVENDA, 
                                      (NVL(PCPEDI.QT, 0) * NVL(PCPEDI.PVENDA, 0)) VLTOTAL, 
                                       0 QTFUTURA, 
                                       0 PVENDAFUTURA, 
                                       0 VLTOTALFUTURA, 
                                      (NVL((select sum(pcmov.qt)
                                            from PCESTCOM,
                                                 PCMOV
                                            where 0=0
											and PCESTCOM.NUMTRANSENT = PCMOV.NUMTRANSENT
                                            and PCMOV.NUMPED = PCPEDC.NUMPED
                                            and PCMOV.CODPROD = PCPRODUT.CODPROD
                                            and PCMOV.DTCANCEL is null
                                            and PCMOV.CODPROD = PCPEDI.CODPROD 
                                            and PCMOV.NUMSEQ = PCPEDI.NUMSEQ),0)) as QTDEVOL
                                            from PCPEDI,
                                                 PCPEDC,
                                                 PCPRODUT,
                                                 PCUSUARI,
                                                 PCCLIENT
                                            where 0=0 
                                            and PCPEDI.CODPROD = PCPRODUT.CODPROD 
                                            and PCPEDC.NUMPED = PCPEDI.NUMPED 
                                            and PCPEDC.CODUSUR = PCUSUARI.CODUSUR 
                                            and PCPEDC.CODCLI = PCCLIENT.CODCLI
                                            and PCPEDC.CONDVENDA = 7 
                                            and PCPEDC.DATA between '11/03/2023' and '10/04/2024'
                                            and TRUNC(PCPEDC.DATA) between '11/03/2023' and '10/04/2024'
                                            and PCPEDC.NUMNOTA in ('17485')
                                            and PCPEDC.POSICAO in ('','M','L','B','P','F','')
                                            ) 
                group by CODPROD,
                         NUMNOTA,
                         DATA,
                         NUMPED, 
                         CODCLI, 
                         CLIENTE, 
                         CODFILIALRETIRA,
                         CODFAB,
                         DESCRICAO, 
                         EMBALAGEM,
                         UNIDADE) TIPO7 
 
   group by TIPO7.CODPROD,
            TIPO7.NUMNOTA,
            TIPO7.DATA,
            TIPO7.CODFILIALRETIRA, 
            TIPO7.NUMPED,                 
            TIPO7.CODCLI,
            TIPO7.CLIENTE,
            TIPO7.CODFAB,
            TIPO7.DESCRICAO, 
            TIPO7.EMBALAGEM, 
            TIPO7.UNIDADE 
 
        UNION 
 
        select 
            TIPO8.CODFILIALRETIRA,
            TIPO8.NUMNOTA,
            TIPO8.NUMPED, 
            TIPO8.CODCLI,
            TIPO8.CLIENTE,
            TIPO8.DATA,
            TIPO8.CODPROD,
            TIPO8.CODFAB,
            TIPO8.DESCRICAO, 
            TIPO8.EMBALAGEM, 
            TIPO8.UNIDADE, 
            0 QT,
            sum(NVL(TIPO8.QTFUTURA, 0)) QTFUTURA, 
            0 as QTDEVOL7,
            max((QTDEVOL)) as QTDEVOL8
            from (select CODPROD,
                         NUMNOTA,
                         DATA,
                         CODFILIALRETIRA,
                         NUMPED, 
                         CODCLI,
                         CLIENTE,
                         CODFAB,
                         DESCRICAO, 
                         EMBALAGEM, 
                         UNIDADE, 
                         0 QT, 
                         sum(QTFUTURA) QTFUTURA, 
                         sum(NVL(QTDEVOL,0)) as QTDEVOL 
                         from (select PCPEDI.CODPROD, 
                                      PCPEDC.NUMNOTA,
                                      PCPEDC.DATA,
                                      PCPEDI.CODFILIALRETIRA,
                                      PCPEDC.CODCLI,
                                      PCCLIENT.CLIENTE,
                                      PCPRODUT.CODFAB,
                                      PCPRODUT.DESCRICAO, 
                                      PCPRODUT.EMBALAGEM, 
                                      PCPRODUT.UNIDADE, 
                                      PCPEDC.NUMPEDENTFUT as NUMPED, 
                                      0 QT, 
                                      PCPEDI.QT as QTFUTURA, 
                                     (NVL((select sum (pcmov.qt)
                                           from PCESTCOM,
                                                PCMOV
                                           where 0=0
										   and PCESTCOM.NUMTRANSENT = PCMOV.NUMTRANSENT
                                           and PCMOV.NUMPED = PCPEDC.NUMPED
                                           and PCMOV.CODPROD = PCPRODUT.CODPROD
                                           and PCMOV.DTCANCEL is null
                                           and PCMOV.codprod = PCPEDI.CODPROD  
                                           and PCMOV.NUMSEQ = PCPEDI.NUMSEQ),0)) as QTDEVOL
                                           from PCPEDI,
                                                PCPEDC,
                                                PCPRODUT,
                                                PCUSUARI,
                                                PCCLIENT
                                           where 0=0
                                           and PCPEDI.CODPROD = PCPRODUT.CODPROD 
                                           and PCPEDC.NUMPED = PCPEDI.NUMPED 
                                           and PCPEDC.CODUSUR = PCUSUARI.CODUSUR 
                                           and PCPEDC.CODCLI = PCCLIENT.CODCLI
                                           and PCPEDC.CONDVENDA = 8 
                                           and PCPEDC.NUMPEDENTFUT is not null 
                                           and TRUNC(PCPEDC.DATA) between '11/03/2023' and '10/04/2024'
                                           and PCPEDC.NUMNOTA in ('17485')
                                           and PCPEDC.POSICAO in ('','M','L','B','P','F','')
                                           )
                  group by CODPROD,
                           NUMNOTA,
                           DATA,
                           CODCLI, 
                           CLIENTE, 
                           NUMPED, 
                           CODFILIALRETIRA, 
                           CODFAB,  
                           DESCRICAO,
                           EMBALAGEM, 
                           UNIDADE) TIPO8 
 
   group by TIPO8.CODPROD,
            TIPO8.NUMNOTA,
            TIPO8.DATA,
            TIPO8.CODFILIALRETIRA, 
            TIPO8.NUMPED,
            TIPO8.CODCLI,
            TIPO8.CLIENTE,
            TIPO8.CODFAB,
            TIPO8.DESCRICAO, 
            TIPO8.EMBALAGEM, 
            TIPO8.UNIDADE) 
 
 where 1 = 1 
 
group by CODFILIALRETIRA,
         NUMNOTA, 
         NUMPED, 
         CODCLI,
         CLIENTE,
         DATA,
         CODPROD,
         CODFAB,
         DESCRICAO, 
         EMBALAGEM, 
         UNIDADE
          
order by CODPROD,
         DESCRICAO,
         EMBALAGEM,
         UNIDADE 
)condicao 
where A_ENTREGAR > 0

order by CODPROD,
         DESCRICAO,
         EMBALAGEM,
         UNIDADE;
         
-- Mark 4 (inclusão da condição NUMPED not in, procurando ignorar numpeds que possuem resultado de tipo 8 onde tenham status pendente)
select *
from (
select        
       CODFILIALRETIRA FILIAL,
       NUMNOTA N_NOTA,
       NUMPED, 
       CODCLI,
       CLIENTE,
       DATA,
       CODPROD,
       CODFAB,
       DESCRICAO, 
       EMBALAGEM, 
       UNIDADE, 
       sum(nvl(QT, 0)) QT, 
       --sum(QTFUTURA) QTFUTURA, 
       --sum(QT - QTFUTURA - (QTDEVOL7 - QTDEVOL8) ) as QTSALDO, 
            case 
                when sum(QT - QTFUTURA - (QTDEVOL7 - QTDEVOL8)) <= 0 
                then 0
                when  decode(sum(QT),0,sum(QTFUTURA),sum(QT)) - sum(QTDEVOL7 - QTDEVOL8)  > 0
                then decode(sum(QT),0,sum(QTFUTURA),sum(QT)) - sum(QTDEVOL7 - QTDEVOL8)
                when  decode(sum(QT),0,sum(QTFUTURA),sum(QT)) - sum(QTDEVOL7 - QTDEVOL8)  <= 0
                then 0
                else decode(sum(QT),0,sum(QTFUTURA),sum(QT))
            end as A_ENTREGAR,
       max(QTDEVOL7) as QTDEVOL7, 
       max(QTDEVOL8) as QTDEVOL8
          
  from (select TIPO7.CODFILIALRETIRA,
            TIPO7.NUMNOTA,
            TIPO7.NUMPED, 
            TIPO7.CODCLI,
            TIPO7.CLIENTE,
            TIPO7.DATA,
            TIPO7.CODPROD,
            TIPO7.CODFAB,
            TIPO7.DESCRICAO, 
            TIPO7.EMBALAGEM, 
            TIPO7.UNIDADE,  
            '0'  POSICAO,
            sum(nvl(TIPO7.QT, 0)) QT, 
            0 QTFUTURA, 
            max(QTDEVOL) as  QTDEVOL7,
            0         as QTDEVOL8
            from (select  CODPROD,
                          NUMNOTA,
                          DATA,
                          CODFILIALRETIRA,
                          NUMPED, 
                          CODCLI,
                          CLIENTE,
                          CODFAB,
                          DESCRICAO, 
                          EMBALAGEM, 
                          UNIDADE, 
                          0 POSICAO,
                          sum(NVL(QT, 0)) QT, 
                          0 QTFUTURA, 
                          sum(QTDEVOL) as  QTDEVOL
                          from (select PCPEDI.CODPROD, 
                                       PCPEDC.NUMNOTA,
                                       PCPEDC.DATA,
                                       PCPEDI.CODFILIALRETIRA,
                                       PCPEDC.NUMPED,
                                       PCPEDC.CODCLI,
                                       PCCLIENT.CLIENTE,
                                       PCPRODUT.CODFAB,
                                       PCPRODUT.DESCRICAO, 
                                       PCPRODUT.EMBALAGEM, 
                                       PCPRODUT.UNIDADE,
                                       0 POSICAO, 
                                       PCPEDI.QT,  
                                       PCPEDI.PVENDA, 
                                      (NVL(PCPEDI.QT, 0) * NVL(PCPEDI.PVENDA, 0)) VLTOTAL, 
                                       0 QTFUTURA, 
                                       0 PVENDAFUTURA, 
                                       0 VLTOTALFUTURA, 
                                      (NVL((select sum(pcmov.qt)
                                            from PCESTCOM,
                                                 PCMOV
                                            where 0=0
											and PCESTCOM.NUMTRANSENT = PCMOV.NUMTRANSENT
                                            and PCMOV.NUMPED = PCPEDC.NUMPED
                                            and PCMOV.CODPROD = PCPRODUT.CODPROD
                                            and PCMOV.DTCANCEL is null
                                            and PCMOV.CODPROD = PCPEDI.CODPROD 
                                            and PCMOV.NUMSEQ = PCPEDI.NUMSEQ),0)) as QTDEVOL
                                            from PCPEDI,
                                                 PCPEDC,
                                                 PCPRODUT,
                                                 PCUSUARI,
                                                 PCCLIENT
                                            where 0=0 
                                            and PCPEDI.CODPROD = PCPRODUT.CODPROD 
                                            and PCPEDC.NUMPED = PCPEDI.NUMPED 
                                            and PCPEDC.CODUSUR = PCUSUARI.CODUSUR 
                                            and PCPEDC.CODCLI = PCCLIENT.CODCLI
                                            and PCPEDC.CONDVENDA = 7 
                                            and PCPEDC.DATA between '01/01/2023' and '10/04/2024'
                                            and TRUNC(PCPEDC.DATA) between '01/01/2023' and '10/04/2024'
                                            --and PCPEDC.NUMNOTA in ('102854')
                                            --and PCPEDC.CODCLI = 31496
                                            and PCPEDC.POSICAO in ('','M','L','B','P','F','')
                                            ) 
                group by CODPROD,
                         NUMNOTA,
                         DATA,
                         NUMPED, 
                         CODCLI, 
                         CLIENTE, 
                         CODFILIALRETIRA,
                         CODFAB,
                         DESCRICAO, 
                         EMBALAGEM,
                         UNIDADE) TIPO7 
 
   group by TIPO7.CODPROD,
            TIPO7.NUMNOTA,
            TIPO7.DATA,
            TIPO7.CODFILIALRETIRA, 
            TIPO7.NUMPED,                 
            TIPO7.CODCLI,
            TIPO7.CLIENTE,
            TIPO7.CODFAB,
            TIPO7.DESCRICAO, 
            TIPO7.EMBALAGEM, 
            TIPO7.UNIDADE 
 
        UNION 
 
        select 
            TIPO8.CODFILIALRETIRA,
            TIPO8.NUMNOTA,
            TIPO8.NUMPED, 
            TIPO8.CODCLI,
            TIPO8.CLIENTE,
            TIPO8.DATA,
            TIPO8.CODPROD,
            TIPO8.CODFAB,
            TIPO8.DESCRICAO, 
            TIPO8.EMBALAGEM, 
            TIPO8.UNIDADE, 
            TIPO8.POSICAO,
            0 QT,
            sum(NVL(TIPO8.QTFUTURA, 0)) QTFUTURA, 
            0 as QTDEVOL7,
            max((QTDEVOL)) as QTDEVOL8
            from (select CODPROD,
                         NUMNOTA,
                         DATA,
                         CODFILIALRETIRA,
                         NUMPED, 
                         CODCLI,
                         CLIENTE,
                         CODFAB,
                         DESCRICAO, 
                         EMBALAGEM, 
                         UNIDADE, 
                         POSICAO,
                         0 QT, 
                         sum(QTFUTURA) QTFUTURA, 
                         sum(NVL(QTDEVOL,0)) as QTDEVOL 
                         from (select PCPEDI.CODPROD, 
                                      PCPEDC.NUMNOTA,
                                      PCPEDC.DATA,
                                      PCPEDI.CODFILIALRETIRA,
                                      PCPEDC.CODCLI,
                                      PCCLIENT.CLIENTE,
                                      PCPRODUT.CODFAB,
                                      PCPRODUT.DESCRICAO, 
                                      PCPRODUT.EMBALAGEM, 
                                      PCPRODUT.UNIDADE, 
                                      PCPEDI.POSICAO,
                                      PCPEDC.NUMPEDENTFUT as NUMPED, 
                                      0 QT, 
                                      PCPEDI.QT as QTFUTURA, 
                                     (NVL((select sum (pcmov.qt)
                                           from PCESTCOM,
                                                PCMOV
                                           where 0=0
										   and PCESTCOM.NUMTRANSENT = PCMOV.NUMTRANSENT
                                           and PCMOV.NUMPED = PCPEDC.NUMPED
                                           and PCMOV.CODPROD = PCPRODUT.CODPROD
                                           and PCMOV.DTCANCEL is null
                                           and PCMOV.codprod = PCPEDI.CODPROD  
                                           and PCMOV.NUMSEQ = PCPEDI.NUMSEQ),0)) as QTDEVOL
                                           from PCPEDI,
                                                PCPEDC,
                                                PCPRODUT,
                                                PCUSUARI,
                                                PCCLIENT
                                           where 0=0
                                           and PCPEDI.CODPROD = PCPRODUT.CODPROD 
                                           and PCPEDC.NUMPED = PCPEDI.NUMPED 
                                           and PCPEDC.CODUSUR = PCUSUARI.CODUSUR 
                                           and PCPEDC.CODCLI = PCCLIENT.CODCLI
                                           and PCPEDC.CONDVENDA = 8 
                                           and PCPEDC.NUMPEDENTFUT is not null 
                                           and TRUNC(PCPEDC.DATA) between '01/01/2023' and '10/04/2024'
                                           --and PCPEDC.NUMNOTA in ('102854')
                                           --and PCPEDC.CODCLI = 31496
                                           and PCPEDC.POSICAO in ('','M','L','B','P','F','')
                                           )
                  group by CODPROD,
                           NUMNOTA,
                           DATA,
                           CODCLI, 
                           CLIENTE, 
                           NUMPED, 
                           CODFILIALRETIRA, 
                           CODFAB,  
                           DESCRICAO,
                           EMBALAGEM, 
                           UNIDADE,
                           POSICAO) TIPO8 
 
   group by TIPO8.CODPROD,
            TIPO8.NUMNOTA,
            TIPO8.DATA,
            TIPO8.CODFILIALRETIRA, 
            TIPO8.NUMPED,
            TIPO8.CODCLI,
            TIPO8.CLIENTE,
            TIPO8.CODFAB,
            TIPO8.DESCRICAO, 
            TIPO8.EMBALAGEM, 
            TIPO8.UNIDADE,
            TIPO8.POSICAO) 
 
 where 1 = 1 
 
group by CODFILIALRETIRA,
         NUMNOTA, 
         NUMPED, 
         CODCLI,
         CLIENTE,
         DATA,
         CODPROD,
         CODFAB,
         DESCRICAO, 
         EMBALAGEM, 
         UNIDADE,
         POSICAO
          
order by CODPROD,
         DESCRICAO,
         EMBALAGEM,
         UNIDADE 
)condicao 
where A_ENTREGAR > 0
and NUMPED not in (
 select NUMPED
    from (
 select            CODPROD,
                   NUMNOTA,
                   DATA,
                   CODFILIALRETIRA,
                   NUMPED, 
                   CODCLI,
                   CLIENTE,
                   CODFAB,
                   DESCRICAO, 
                   EMBALAGEM, 
                   UNIDADE, 
                   POSICAO,
                   0 QT, 
                   sum(QTFUTURA) QTFUTURA, 
                   sum(NVL(QTDEVOL,0)) as QTDEVOL 
                   from (select PCPEDI.CODPROD, 
                         PCPEDC.NUMNOTA,
                         PCPEDC.DATA,
                         PCPEDI.CODFILIALRETIRA,
                         PCPEDC.CODCLI,
                         PCCLIENT.CLIENTE,
                         PCPRODUT.CODFAB,
                         PCPRODUT.DESCRICAO, 
                         PCPRODUT.EMBALAGEM, 
                         PCPRODUT.UNIDADE, 
                         PCPEDI.POSICAO,
                         PCPEDC.NUMPEDENTFUT as NUMPED, 
                         0 QT, 
                         PCPEDI.QT as QTFUTURA, 
                         (NVL((select sum (pcmov.qt)
                               from PCESTCOM,
                                    PCMOV
                               where 0=0
							   and PCESTCOM.NUMTRANSENT = PCMOV.NUMTRANSENT
                               and PCMOV.NUMPED = PCPEDC.NUMPED
                               and PCMOV.CODPROD = PCPRODUT.CODPROD
                               and PCMOV.DTCANCEL is null
                               and PCMOV.codprod = PCPEDI.CODPROD  
                               and PCMOV.NUMSEQ = PCPEDI.NUMSEQ),0)) as QTDEVOL
                      from PCPEDI,
                           PCPEDC,
                           PCPRODUT,
                           PCUSUARI,
                           PCCLIENT
                      where 0=0
                           and PCPEDI.CODPROD = PCPRODUT.CODPROD 
                           and PCPEDC.NUMPED = PCPEDI.NUMPED 
                           and PCPEDC.CODUSUR = PCUSUARI.CODUSUR 
                           and PCPEDC.CODCLI = PCCLIENT.CODCLI
                           and PCPEDC.CONDVENDA = 8 
                           and PCPEDC.NUMPEDENTFUT is not null 
                           and TRUNC(PCPEDC.DATA) between '01/01/2023' and '10/04/2024'
                           --and PCPEDC.NUMNOTA in ('102854')
                           --and PCPEDC.CODCLI = 31496
                           and PCPEDC.POSICAO in ('P')
            ) subconsulta
            group by CODPROD,
                     NUMNOTA,
                     DATA,
                     CODCLI, 
                     CLIENTE, 
                     NUMPED, 
                     CODFILIALRETIRA, 
                     CODFAB,  
                     DESCRICAO,
                     EMBALAGEM, 
                     UNIDADE,
                     POSICAO
    ) subconsulta
)

order by CODPROD,
         DESCRICAO,
         EMBALAGEM,
         UNIDADE;
         
         
--Mark 5 (Sinceramente sei nem oque dizer sobre as alterações, a consulta inteira foi reformulada para conseguir garantir os valores de QTFUTURA e QTDEDVOL8
--        tivessem seus valores corretos e agrupados conforme a consulta principal. foi preciso se desfazer do union e criar uma subconsulta para cada um dos 
--        dois campos, feito em conjunto com a correlação entre NUMPEDENTFUT e CODPROD das subconsultas com NUMPED e CODPROD da principal. isso deixa o codigo 
--        um pouco lento mas garante o agrupamento.          

select *
from (
select        
       CODFILIALRETIRA FILIAL,
       NUMNOTA N_NOTA,
       NUMPED, 
       CODCLI,
       CLIENTE,
       DATA,
       CODPROD,
       CODFAB,
       DESCRICAO, 
       EMBALAGEM, 
       UNIDADE, 
       sum(nvl(QT, 0)) QT, 
       --sum(QTFUTURA) QTFUTURA, 
       --sum(QT - QTFUTURA - (QTDEVOL7 - QTDEVOL8)) as QTSALDO, 
            case 
                when sum(nvl(QT,0) - nvl(QTFUTURA,0) - (nvl(QTDEVOL7,0) - nvl(QTDEVOL8,0))) <= 0 
                then 0
                else sum(nvl(QT,0) - nvl(QTFUTURA,0) - (nvl(QTDEVOL7,0) - nvl(QTDEVOL8,0)))
            end as A_ENTREGAR,
       max(QTDEVOL7) as QTDEVOL7, 
       sum(nvl(QTDEVOL8,0)) as QTDEVOL8
          
  from (select TIPO7.CODFILIALRETIRA,
               TIPO7.NUMNOTA,
               TIPO7.NUMPED, 
               TIPO7.CODCLI,
               TIPO7.CLIENTE,
               TIPO7.DATA,
               TIPO7.CODPROD,
               TIPO7.CODFAB,
               TIPO7.DESCRICAO, 
               TIPO7.EMBALAGEM, 
               TIPO7.UNIDADE,  
               sum(nvl(TIPO7.QT, 0)) QT, 
               TIPO7.QTFUTURA, 
                max(QTDEVOL) as  QTDEVOL7,
                max(QTDEVOL8) as QTDEVOL8
            from (select  CODPROD,
                          NUMNOTA,
                          DATA,
                          CODFILIALRETIRA,
                          NUMPED, 
                          CODCLI,
                          CLIENTE,
                          CODFAB,
                          DESCRICAO, 
                          EMBALAGEM, 
                          UNIDADE, 
                          sum(NVL(QT, 0)) QT, 
                          QTFUTURA, 
                          sum(QTDEVOL8) as QTDEVOL8,
                          sum(QTDEVOL) as  QTDEVOL
                          from (select PCPEDI.CODPROD, 
                                       PCPEDC.NUMNOTA,
                                       PCPEDC.DATA,
                                       PCPEDI.CODFILIALRETIRA,
                                       PCPEDC.NUMPED,
                                       PCPEDC.CODCLI,
                                       PCCLIENT.CLIENTE,
                                       PCPRODUT.CODFAB,
                                       PCPRODUT.DESCRICAO, 
                                       PCPRODUT.EMBALAGEM, 
                                       PCPRODUT.UNIDADE,
                                       PCPEDI.QT,  
                                       PCPEDI.PVENDA, 
                                      (NVL(PCPEDI.QT, 0) * NVL(PCPEDI.PVENDA, 0)) VLTOTAL, 
                                      (NVL((select sum(pcmov.qt)
                                            from PCESTCOM,
                                                 PCMOV
                                            where 0=0
											and PCESTCOM.NUMTRANSENT = PCMOV.NUMTRANSENT
                                            and PCMOV.NUMPED = PCPEDC.NUMPED
                                            and PCMOV.CODPROD = PCPRODUT.CODPROD
                                            and PCMOV.DTCANCEL is null
                                            and PCMOV.CODPROD = PCPEDI.CODPROD 
                                            and PCMOV.NUMSEQ = PCPEDI.NUMSEQ),0)) as QTDEVOL,
                                            (select sum(QTDEVOL8)from (
SELECT 
    TIPO8.CODFILIALRETIRA,
    MAX(TIPO8.NUMNOTA) AS NUMNOTA,
    TIPO8.NUMPED, 
    TIPO8.CODCLI,
    TIPO8.CLIENTE,
    MAX(TIPO8.DATA) AS DATA,
    TIPO8.CODPROD,
    TIPO8.CODFAB,
    TIPO8.DESCRICAO, 
    TIPO8.EMBALAGEM, 
    TIPO8.UNIDADE, 
    0 AS QT,
    SUM(NVL(TIPO8.QTFUTURA, 0)) AS QTFUTURA, 
    0 AS QTDEVOL7,
    SUM(nvl(QTDEVOL8,0)) AS QTDEVOL8
FROM (
    SELECT 
        CODPROD,
        NUMNOTA,
        DATA,
        CODFILIALRETIRA,
        NUMPED, 
        CODCLI,
        CLIENTE,
        CODFAB,
        DESCRICAO, 
        EMBALAGEM, 
        UNIDADE, 
        0 AS QT, 
        SUM(QTFUTURA) AS QTFUTURA, 
        0 AS QTDEVOL7,
        sum(nvl(QTDEVOL,0)) AS QTDEVOL8 
    FROM (
select                   CODPROD,
                         NUMNOTA,
                         DATA,
                         CODFILIALRETIRA,
                         NUMPED, 
                         CODCLI,
                         CLIENTE,
                         CODFAB,
                         DESCRICAO, 
                         EMBALAGEM, 
                         UNIDADE, 
                         0 QT, 
                         sum(QTFUTURA) QTFUTURA, 
                         sum(NVL(QTDEVOL,0)) as QTDEVOL 
                         from (select PI.CODPROD, 
                                      PE.NUMNOTA,
                                      PE.DATA,
                                      PI.CODFILIALRETIRA,
                                      PE.CODCLI,
                                      PCCLIENT.CLIENTE,
                                      PCPRODUT.CODFAB,
                                      PCPRODUT.DESCRICAO, 
                                      PCPRODUT.EMBALAGEM, 
                                      PCPRODUT.UNIDADE, 
                                      PE.NUMPEDENTFUT as NUMPED, 
                                      0 QT, 
                                      PI.QT as QTFUTURA, 
                                     (NVL((select sum (pcmov.qt)
                                           from PCESTCOM,
                                                PCMOV
                                           where 0=0
										   and PCESTCOM.NUMTRANSENT = PCMOV.NUMTRANSENT
                                           and PCMOV.NUMPED = PE.NUMPED
                                           and PCMOV.CODPROD = PCPRODUT.CODPROD
                                           and PCMOV.DTCANCEL is null
                                           and PCMOV.codprod = PI.CODPROD  
                                           and PCMOV.NUMSEQ = PI.NUMSEQ),0)) as QTDEVOL
                                           from PCPEDI PI,
                                                PCPEDC PE,
                                                PCPRODUT,
                                                PCUSUARI,
                                                PCCLIENT
                                           where 0=0
                                           and PI.CODPROD = PCPRODUT.CODPROD 
                                           and PE.NUMPED = PI.NUMPED 
                                           and PE.CODUSUR = PCUSUARI.CODUSUR 
                                           and PE.CODCLI = PCCLIENT.CODCLI
                                           and PE.CONDVENDA = 8 
                                           and PE.NUMPEDENTFUT = PCPEDC.NUMPED
                                           and PI.CODPROD = PCPEDI.CODPROD
                                           and PE.NUMPEDENTFUT is not null 
                                           and TRUNC(PE.DATA) between '01/01/2023' and '17/04/2024'
                                          -- and PCPEDC.NUMPED = 1122004907
                                           and PE.POSICAO in ('','M','L','B','P','F','')
                                           )
                  group by CODPROD,
                           NUMNOTA,
                           DATA,
                           CODCLI, 
                           CLIENTE, 
                           NUMPED, 
                           CODFILIALRETIRA, 
                           CODFAB,  
                           DESCRICAO,
                           EMBALAGEM, 
                           UNIDADE
    ) 
    GROUP BY 
        CODPROD,
        NUMNOTA,
        DATA,
        CODCLI, 
        CLIENTE, 
        NUMPED, 
        CODFILIALRETIRA, 
        CODFAB,  
        DESCRICAO,
        EMBALAGEM, 
        UNIDADE
) TIPO8 
GROUP BY 
    TIPO8.CODPROD,
    TIPO8.CODFILIALRETIRA, 
    TIPO8.NUMPED,
    TIPO8.CODCLI,
    TIPO8.CLIENTE,
    TIPO8.CODFAB,
    TIPO8.DESCRICAO, 
    TIPO8.EMBALAGEM, 
    TIPO8.UNIDADE) )QTDEVOL8,
(select sum(QTFUTURA) 
from (
SELECT 
    TIPO8.CODFILIALRETIRA,
    MAX(TIPO8.NUMNOTA) AS NUMNOTA,
    TIPO8.NUMPED, 
    TIPO8.CODCLI,
    TIPO8.CLIENTE,
    MAX(TIPO8.DATA) AS DATA,
    TIPO8.CODPROD,
    TIPO8.CODFAB,
    TIPO8.DESCRICAO, 
    TIPO8.EMBALAGEM, 
    TIPO8.UNIDADE, 
    0 AS QT,
    SUM(NVL(TIPO8.QTFUTURA, 0)) AS QTFUTURA, 
    0 AS QTDEVOL7,
    SUM(QTDEVOL8) AS QTDEVOL8
FROM (
    SELECT 
        CODPROD,
        NUMNOTA,
        DATA,
        CODFILIALRETIRA,
        NUMPED, 
        CODCLI,
        CLIENTE,
        CODFAB,
        DESCRICAO, 
        EMBALAGEM, 
        UNIDADE, 
        0 AS QT, 
        SUM(QTFUTURA) AS QTFUTURA, 
        0 AS QTDEVOL7,
        MAX(QTDEVOL) AS QTDEVOL8 
    FROM (
select                   CODPROD,
                         NUMNOTA,
                         DATA,
                         CODFILIALRETIRA,
                         NUMPED, 
                         CODCLI,
                         CLIENTE,
                         CODFAB,
                         DESCRICAO, 
                         EMBALAGEM, 
                         UNIDADE, 
                         0 QT, 
                         sum(QTFUTURA) QTFUTURA, 
                         sum(NVL(QTDEVOL,0)) as QTDEVOL 
                         from (select PI.CODPROD, 
                                      PE.NUMNOTA,
                                      PE.DATA,
                                      PI.CODFILIALRETIRA,
                                      PE.CODCLI,
                                      PCCLIENT.CLIENTE,
                                      PCPRODUT.CODFAB,
                                      PCPRODUT.DESCRICAO, 
                                      PCPRODUT.EMBALAGEM, 
                                      PCPRODUT.UNIDADE, 
                                      PE.NUMPEDENTFUT as NUMPED, 
                                      0 QT, 
                                      PI.QT as QTFUTURA, 
                                     (NVL((select sum (pcmov.qt)
                                           from PCESTCOM,
                                                PCMOV
                                           where 0=0
										   and PCESTCOM.NUMTRANSENT = PCMOV.NUMTRANSENT
                                           and PCMOV.NUMPED = PCPEDC.NUMPED
                                           and PCMOV.CODPROD = PCPRODUT.CODPROD
                                           and PCMOV.DTCANCEL is null
                                           and PCMOV.codprod = PCPEDI.CODPROD  
                                           and PCMOV.NUMSEQ = PCPEDI.NUMSEQ),0)) as QTDEVOL
                                           from PCPEDI PI,
                                                PCPEDC PE,
                                                PCPRODUT,
                                                PCUSUARI,
                                                PCCLIENT
                                           where 0=0
                                           and PI.CODPROD = PCPRODUT.CODPROD 
                                           and PE.NUMPED = PI.NUMPED 
                                           and PE.CODUSUR = PCUSUARI.CODUSUR 
                                           and PE.CODCLI = PCCLIENT.CODCLI
                                           and PE.CONDVENDA = 8 
                                           and PE.NUMPEDENTFUT = PCPEDC.NUMPED
                                           and PI.CODPROD = PCPEDI.CODPROD
                                           and PE.NUMPEDENTFUT is not null 
                                           and TRUNC(PE.DATA) between '01/01/2023' and '17/04/2024'
                                          -- and PCPEDC.NUMPED = 1122004907
                                           and PE.POSICAO in ('','M','L','B','P','F','')
                                           )
                  group by CODPROD,
                           NUMNOTA,
                           DATA,
                           CODCLI, 
                           CLIENTE, 
                           NUMPED, 
                           CODFILIALRETIRA, 
                           CODFAB,  
                           DESCRICAO,
                           EMBALAGEM, 
                           UNIDADE,
                           QTFUTURA
    ) 
    GROUP BY 
        CODPROD,
        NUMNOTA,
        DATA,
        CODCLI, 
        CLIENTE, 
        NUMPED, 
        CODFILIALRETIRA, 
        CODFAB,  
        DESCRICAO,
        EMBALAGEM, 
        UNIDADE,
        QTFUTURA
) TIPO8 
GROUP BY 
    TIPO8.CODPROD,
    TIPO8.CODFILIALRETIRA, 
    TIPO8.NUMPED,
    TIPO8.CODCLI,
    TIPO8.CLIENTE,
    TIPO8.CODFAB,
    TIPO8.DESCRICAO, 
    TIPO8.EMBALAGEM, 
    TIPO8.UNIDADE,
    TIPO8.QTFUTURA))QTFUTURA
                                            from PCPEDI,
                                                 PCPEDC,
                                                 PCPRODUT,
                                                 PCUSUARI,
                                                 PCCLIENT
                                            where 0=0 
                                            and PCPEDI.CODPROD = PCPRODUT.CODPROD 
                                            and PCPEDC.NUMPED = PCPEDI.NUMPED 
                                            and PCPEDC.CODUSUR = PCUSUARI.CODUSUR 
                                            and PCPEDC.CODCLI = PCCLIENT.CODCLI
                                            and PCPEDC.CONDVENDA = 7 
                                            and TRUNC(PCPEDC.DATA) between '01/01/2023' and '17/04/2024'
                                            --and PCPEDC.NUMPED = 1122004907
                                            --and PCPEDI.CODPROD = 107
                                            --and PCPEDC.NUMNOTA in ('102854')
                                            --and PCPEDC.CODCLI = 31496
                                            and PCPEDC.POSICAO in ('','M','L','B','P','F','')
                                            ) 
                group by CODPROD,
                         NUMNOTA,
                         DATA,
                         NUMPED, 
                         CODCLI, 
                         CLIENTE, 
                         CODFILIALRETIRA,
                         CODFAB,
                         DESCRICAO, 
                         EMBALAGEM,
                         UNIDADE,
                         QTFUTURA) TIPO7 
 
   group by TIPO7.CODPROD,
            TIPO7.NUMNOTA,
            TIPO7.DATA,
            TIPO7.CODFILIALRETIRA, 
            TIPO7.NUMPED,                 
            TIPO7.CODCLI,
            TIPO7.CLIENTE,
            TIPO7.CODFAB,
            TIPO7.DESCRICAO, 
            TIPO7.EMBALAGEM, 
            TIPO7.UNIDADE,
            TIPO7.QTFUTURA
 
) 
 
 where 1 = 1 
 
group by CODFILIALRETIRA,
         NUMNOTA, 
         NUMPED, 
         CODCLI,
         CLIENTE,
         DATA,
         CODPROD,
         CODFAB,
         DESCRICAO, 
         EMBALAGEM, 
         UNIDADE,
         QTFUTURA
          
order by CODPROD,
         DESCRICAO,
         EMBALAGEM,
         UNIDADE 
)condicao 
where A_ENTREGAR > 0
and NUMPED not in (
 select NUMPED
    from (
 select            CODPROD,
                   NUMNOTA,
                   DATA,
                   CODFILIALRETIRA,
                   NUMPED, 
                   CODCLI,
                   CLIENTE,
                   CODFAB,
                   DESCRICAO, 
                   EMBALAGEM, 
                   UNIDADE, 
                   POSICAO,
                   0 QT, 
                   sum(QTFUTURA) QTFUTURA, 
                   sum(NVL(QTDEVOL,0)) as QTDEVOL 
                   from (select PCPEDI.CODPROD, 
                         PCPEDC.NUMNOTA,
                         PCPEDC.DATA,
                         PCPEDI.CODFILIALRETIRA,
                         PCPEDC.CODCLI,
                         PCCLIENT.CLIENTE,
                         PCPRODUT.CODFAB,
                         PCPRODUT.DESCRICAO, 
                         PCPRODUT.EMBALAGEM, 
                         PCPRODUT.UNIDADE, 
                         PCPEDI.POSICAO,
                         PCPEDC.NUMPEDENTFUT as NUMPED, 
                         0 QT, 
                         PCPEDI.QT as QTFUTURA, 
                         (NVL((select sum (pcmov.qt)
                               from PCESTCOM,
                                    PCMOV
                               where 0=0
							   and PCESTCOM.NUMTRANSENT = PCMOV.NUMTRANSENT
                               and PCMOV.NUMPED = PCPEDC.NUMPED
                               and PCMOV.CODPROD = PCPRODUT.CODPROD
                               and PCMOV.DTCANCEL is null
                               and PCMOV.codprod = PCPEDI.CODPROD  
                               and PCMOV.NUMSEQ = PCPEDI.NUMSEQ),0)) as QTDEVOL
                      from PCPEDI,
                           PCPEDC,
                           PCPRODUT,
                           PCUSUARI,
                           PCCLIENT
                      where 0=0
                           and PCPEDI.CODPROD = PCPRODUT.CODPROD 
                           and PCPEDC.NUMPED = PCPEDI.NUMPED 
                           and PCPEDC.CODUSUR = PCUSUARI.CODUSUR 
                           and PCPEDC.CODCLI = PCCLIENT.CODCLI
                           and PCPEDC.CONDVENDA = 8 
                           and PCPEDC.NUMPEDENTFUT is not null 
                           and TRUNC(PCPEDC.DATA) between '01/01/2023' and '17/04/2024'
                           --and PCPEDC.NUMNOTA in ('102854')
                           --and PCPEDC.CODCLI = 31496
                           and PCPEDC.POSICAO in ('P')
            ) subconsulta
            group by CODPROD,
                     NUMNOTA,
                     DATA,
                     CODCLI, 
                     CLIENTE, 
                     NUMPED, 
                     CODFILIALRETIRA, 
                     CODFAB,  
                     DESCRICAO,
                     EMBALAGEM, 
                     UNIDADE,
                     POSICAO,
                     QTFUTURA
    ) subconsulta
)

order by CODPROD,
         DESCRICAO,
         EMBALAGEM,
         UNIDADE 
