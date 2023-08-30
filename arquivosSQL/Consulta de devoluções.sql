select 
    PCNFENT.CODFILIALNF as FILIAL,
    PCNFENT.NUMNOTA as NOTA, 
    PCNFENT.NUMTRANSENT,
    PCNFENT.CODFUNCLANC as FUNCLANC,
    FUNC.NOME NOMEFUNCLANC,
    PCNFENT.DTENT,
    PCNFENT.DTSAIDA,
    PCNFENT.CODUSURDEVOL as RCA,
    PCUSUARI.NOME as NOME_RCA,
    PCCLIENT.CODCLI,
    nvl(PCDEVConSUM.CLIENTE, PCCLIENT.CLIENTE) CLIENTE,
    PCNFENT.CODDEVOL,
    PCTABDEV.MOTIVO, 
    PCNFENT.OBS,
    decode(PCNFENT.VLTOTAL, 0, PCESTCOM.VLDEVOLUCAO, PCNFENT.VLTOTAL) as VLTOTAL,
    case 
        when PCNFENT.VLTOTGER is null 
		then 'CREDITO AO CLIENTE N�O GERADO'
        else to_char(PCNFENT.VLTOTGER)
    end as CREDITO_CLI
from 
    PCNFENT
left join PCESTCOM on PCNFENT.NUMTRANSENT = PCESTCOM.NUMTRANSENT
left join PCTABDEV on PCNFENT.CODDEVOL = PCTABDEV.CODDEVOL
left join PCCLIENT on PCNFENT.CODFORNEC = PCCLIENT.CODCLI
left join PCEMPR on PCNFENT.CODMOTORISTADEVOL = PCEMPR.MATRICULA
left join PCUSUARI on PCNFENT.CODUSURDEVOL = PCUSUARI.CODUSUR
left join PCSUPERV on PCUSUARI.CODSUPERVISOR = PCSUPERV.CODSUPERVisOR
left join PCEMPR FUNC on PCNFENT.CODFUNCLANC = FUNC.MATRICULA
left join PCNFSAID on PCESTCOM.NUMTRANSVENDA = PCNFSAID.NUMTRANSVENDA
left join PCDEVCONSUM on PCNFENT.NUMTRANSENT = PCDEVCONSUM.NUMTRANSENT
where  
    PCNFENT.DTENT between '01/08/2023' and '18/08/2023'
    and PCNFENT.TIPODESCARGA in ('6','7','T') 
    and nvl(PCNFENT.OBS, 'X') <> 'NF CANCELADA'
    and PCNFENT.CODFISCAL in ('131','132','231','232','199','299') 
    and ((nvl(PCNFSAID.CONDVENDA, 0) in ('1', '7','9') and PCESTCOM.NUMTRANSVENDA = PCNFSAID.NUMTRANSVENDA)
         or (PCNFENT.VLTOTGER is null and PCNFENT.CODUSURDEVOL = '1039'))
    and PCNFENT.CODDEVOL in (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,47,52,55)
    and PCNFENT.CODUSURDEVOL in ('1078')
    and PCNFENT.CODFILIALNF in ('2','3','4')
group by 
    PCNFENT.NUMNOTA,
    PCNFENT.CODFUNCLANC,
    PCNFENT.DTENT,
    PCNFENT.DTSAIDA,                                           
    PCNFENT.CODDEVOL,
    PCNFENT.OBS,
    PCTABDEV.MOTIVO,
    PCNFENT.NUMTRANSENT,                                            
    nvl(PCNFENT.TOTPESO, 0),
    PCNFENT.CODFILIALNF,
    PCCLIENT.CODCLI,                                                 
    nvl(PCDEVCONSUM.CLIENTE, PCCLIENT.CLIENTE) ,
    nvl(PCDEVCONSUM.CIDADE, PCCLIENT.MUNICENT),                        
    nvl(PCDEVCONSUM.ENDERECO, PCCLIENT.ENDERENT),
    nvl(PCDEVCONSUM.TELEFONE, PCCLIENT.TELENT),                       
    PCNFENT.CODUSURDEVOL,
    PCNFENT.ROTINALANC,
    PCNFENT.CODMOTORISTADEVOL,                                            
    PCEMPR.NOME,
    PCUSUARI.NOME,
    PCUSUARI.CODSUPERVISOR,
    PCSUPERV.NOME,
    FUNC.NOME,
    PCNFENT.CODFILIAL,
    PCNFENT.VLFRETE, 
    PCNFENT.VLOUTRAS,
    PCNFENT.VLTOTAL,
    PCESTCOM.VLDEVOLUCAO,
    PCNFENT.CODFORNEC,
    PCNFSAID.NUMCAR,
    PCNFENT.VLTOTGER                       
order by 
    PCNFENT.NUMNOTA;

--Mark 2 (personalizado para vendedores)
select 
    PCNFENT.CODFILIALNF as FILIAL,
    PCNFENT.NUMNOTA as NOTA, 
    PCNFENT.NUMTRANSENT,
    PCNFENT.CODFUNCLANC as FUNCLANC,
    FUNC.NOME NOMEFUNCLANC,
    PCNFENT.DTENT,
    PCNFENT.DTSAIDA,
    U.NOME as NOME_RCA,
    PCNFENT.CODUSURDEVOL as RCA,
    PCCLIENT.CODCLI,
    nvl(PCDEVConSUM.CLIENTE, PCCLIENT.CLIENTE) CLIENTE,
    PCNFENT.CODDEVOL,
    PCTABDEV.MOTIVO, 
    PCNFENT.OBS,
    decode(PCNFENT.VLTOTAL, 0, PCESTCOM.VLDEVOLUCAO, PCNFENT.VLTOTAL) as VLTOTAL,
    case 
        when PCNFENT.VLTOTGER is null 
		then 'CREDITO AO CLIENTE N�O GERADO'
        else to_char(PCNFENT.VLTOTGER)
    end as CREDITO_CLI
from 
    PCNFENT
left join PCESTCOM on PCNFENT.NUMTRANSENT = PCESTCOM.NUMTRANSENT
left join PCTABDEV on PCNFENT.CODDEVOL = PCTABDEV.CODDEVOL
left join PCCLIENT on PCNFENT.CODFORNEC = PCCLIENT.CODCLI
left join PCEMPR on PCNFENT.CODMOTORISTADEVOL = PCEMPR.MATRICULA
--left join PCSUPERV on PCUSUARI.CODSUPERVISOR = PCSUPERV.CODSUPERVISOR
left join PCEMPR FUNC on PCNFENT.CODFUNCLANC = FUNC.MATRICULA
left join PCNFSAID on PCESTCOM.NUMTRANSVENDA = PCNFSAID.NUMTRANSVENDA
left join PCDEVCONSUM on PCNFENT.NUMTRANSENT = PCDEVCONSUM.NUMTRANSENT
left join PCUSUARI U on PCNFENT.CODUSURDEVOL = U.CODUSUR
left join PCEMPR   P on U.CODUSUR = P.CODUSUR
left join PCROTINA R on P.MATRICULA  = P.MATRICULA 
where  
    PCNFENT.DTENT between '01/08/2023' and '18/08/2023'
    and PCNFENT.TIPODESCARGA in ('6','7','T') 
    and nvl(PCNFENT.OBS, 'X') <> 'NF CANCELADA'
    and PCNFENT.CODFISCAL in ('131','132','231','232','199','299') 
    and ((nvl(PCNFSAID.CONDVENDA, 0) in ('1', '7','9') and PCESTCOM.NUMTRANSVENDA = PCNFSAID.NUMTRANSVENDA)
         or (PCNFENT.VLTOTGER is null and PCNFENT.CODUSURDEVOL = U.CODUSUR))
    and PCNFENT.CODDEVOL in (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,47,52,55)
    and PCNFENT.CODUSURDEVOL = U.CODUSUR
    and P.MATRICULA = '56'
    and R.CODIGO = '8047'
    and PCNFENT.CODFILIALNF in ('2','3','4')
group by 
    PCNFENT.NUMNOTA,
    PCNFENT.CODFUNCLANC,
    PCNFENT.DTENT,
    PCNFENT.DTSAIDA,                                           
    PCNFENT.CODDEVOL,
    PCNFENT.OBS,
    PCTABDEV.MOTIVO,
    PCNFENT.NUMTRANSENT,                                            
    nvl(PCNFENT.TOTPESO, 0),
    PCNFENT.CODFILIALNF,
    PCCLIENT.CODCLI,                                                 
    nvl(PCDEVCONSUM.CLIENTE, PCCLIENT.CLIENTE) ,
    nvl(PCDEVCONSUM.CIDADE, PCCLIENT.MUNICENT),                        
    nvl(PCDEVCONSUM.ENDERECO, PCCLIENT.ENDERENT),
    nvl(PCDEVCONSUM.TELEFONE, PCCLIENT.TELENT),                       
    PCNFENT.CODUSURDEVOL,
    PCNFENT.ROTINALANC,
    PCNFENT.CODMOTORISTADEVOL,                                            
    P.NOME,
    U.NOME,
    --PCUSUARI.CODSUPERVISOR,
    --PCSUPERV.NOME,
    FUNC.NOME,
    PCNFENT.CODFILIAL,
    PCNFENT.VLFRETE, 
    PCNFENT.VLOUTRAS,
    PCNFENT.VLTOTAL,
    PCESTCOM.VLDEVOLUCAO,
    PCNFENT.CODFORNEC,
    PCNFSAID.NUMCAR,
    PCNFENT.VLTOTGER                       
order by 
    PCNFENT.NUMNOTA;
