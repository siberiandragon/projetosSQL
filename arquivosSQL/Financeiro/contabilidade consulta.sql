select L.RECNUM as N_LANCAMENTO,
       A.NUMTRANSVENDADESC as N_TRANSACAO,
       A.NUMNOTADESC as NUMNOTA,
       L.CODCONTA, 
       C.CONTA,
       F.CODCLI,
       F.CLIENTE
       
from PCLANC L
join PCCONTA C on L.CODCONTA = C.CODCONTA
left join PCCLIENT F on L.CODFORNEC = F.CODCLI
left join PCCRECLI A on L.RECNUM = A.NUMLANC
where 0=0
and L.RECNUM ='10246'
;

select G.GRUPO,
       C.CODCONTA,
       regexp_replace(C.CONTA, '\([^)]*\)', '') as CONTA,
       C.TIPO,
       C.CONTACONTABIL,
       M.CODCONTA_PC,
       M.NOME_CONTA,
       case 
       when C.CODCONTA = '100012'
       then 'PAGAMENTO DE ' || regexp_replace(C.CONTA, '\([^)]*\)', '') || to_char(trunc(L.DTCOMPETENCIA, 'MM'), 'MM/YYYY')
       when C.CODCONTA in('100010','4010003')
       then 'PAGAMENTO DE ' || L.NUMNOTA || ' | ' || F.FORNECEDOR
       when C.CODCONTA in('100001','100022')
       then 'PAGAMENTO DE ' || L.NUMNOTA || ' | ' || L.PREST || ' | ' || F.FORNECEDOR
       when C.CODCONTA = '100015'
       then 'PAGAMENTO DE ' || regexp_replace(C.CONTA, '\([^)]*\)', '') || to_char(trunc(L.DTCOMPETENCIA, 'MM'), 'MM/YYYY')
       when C.CODCONTA = '100020'
       then 'DEVOLUÇÂO REF NF ' || L.NUMNOTA || ' | ' || F.FORNECEDOR
       when C.CODCONTA = '100002'
       then 'PAGAMENTO DE NF ' || L.NUMNOTA || '|'  || L.PREST ||' | ' || F.FORNECEDOR     
       when C.CODCONTA = '100016'
       then 'PAGAMENTO DE ICMS ' || to_char(trunc(L.DTCOMPETENCIA, 'MM'), 'MM/YYYY')        
       when C.CODCONTA = '100014'
       then 'PAGAMENTO DE IRPJ ' || to_char(trunc(L.DTCOMPETENCIA, 'MM'), 'MM/YYYY')    
       when C.CODCONTA = '100023'
       then 'PAGAMENTO DE NF ' || L.NUMNOTA || '|'  || L.PREST || ' | ' || F.FORNECEDOR
       when C.CODCONTA = '100011'
       then 'PAGAMENTO DE PIS ' ||  to_char(trunc(L.DTCOMPETENCIA, 'MM'), 'MM/YYYY')
       when C.CODCONTA = '100021'
       then C.CONTA || L.NUMNOTA || ' | ' || F.FORNECEDOR  
       when C.CODCONTA = '100017'   
       then 'PAGAMENTO DE ICMS ST ' ||  to_char(trunc(L.DTCOMPETENCIA, 'MM'), 'MM/YYYY') 
       when C.CODCONTA = '105'   
       then 'DEVOLUÇÃO REF NF ' || L.NUMNOTA ||  ' | ' || F.FORNECEDOR    
       when C.CODCONTA = '107'   
       then 'RECEBIMENTO DE NF ' || L.NUMNOTA ||  ' | ' || F.FORNECEDOR                 
       when C.CODCONTA = '108'   
       then 'RECEBIMENTO DE NF ' || L.NUMNOTA ||  ' | ' || F.FORNECEDOR 
       when C.CODCONTA = '101'   
       then 'RECEBIMENTO DE NF ' || L.NUMNOTA ||  ' | ' || F.FORNECEDOR   
       when C.CODCONTA = '201008'   
       then 'RECEBIMENTO DE ' || C.CONTA ||L.NUMNOTA ||  ' | ' || F.FORNECEDOR   
       when C.CODCONTA = '201007'   
       then 'RECEBIMENTO DE ' || C.CONTA ||L.NUMNOTA ||  ' | ' || F.FORNECEDOR   
       when C.CODCONTA = '201011'   
       then 'RECEBIMENTO DE ' || C.CONTA ||L.NUMNOTA ||  ' | ' || F.FORNECEDOR   
       when C.CODCONTA = '201014'   
       then 'RECEBIMENTO DE ' || C.CONTA || L.NUMNOTA ||  ' | ' || F.FORNECEDOR   
       when C.CODCONTA = '2010018'   
       then C.CONTA || ' | ' || F.FORNECEDOR   
       when C.CODCONTA = '2010003'   
       then 'RECEBIMENTO REF ' || C.CONTA || L.NUMNOTA ||  ' | ' || F.FORNECEDOR    
       when C.CODCONTA = '2010002'   
       then 'RECEBIMENTO REF ' || C.CONTA || L.NUMNOTA ||  ' | ' || F.FORNECEDOR 
       when C.CODCONTA = '2010013'   
       then 'RECEBIMENTO REF ' || C.CONTA || L.NUMNOTA ||  ' | ' || F.FORNECEDOR   
       when C.CODCONTA = '2020012'   
       then 'RECEBIMENTO DE ' || C.CONTA || L.NUMNOTA ||  ' | ' || F.FORNECEDOR            
       when C.CODCONTA = '2020007'   
       then C.CONTA || ' | ' || L.NUMNOTA ||  ' | ' || F.FORNECEDOR  
       when C.CODCONTA = '2020011'   
       then 'RECEBIMENTO DE NF' || L.NUMNOTA ||  ' | ' || F.FORNECEDOR   
       when C.CODCONTA = '2020010'   
       then 'RECEBIMENTO DE NF' || L.NUMNOTA ||  ' | ' || F.FORNECEDOR  
       when C.CODCONTA = '2020008'   
       then 'RECEBIMENTO DE NF' || L.NUMNOTA ||  ' | ' || F.FORNECEDOR  
       when C.CODCONTA = '2020009'   
       then 'RECEBIMENTO DE NF' || L.NUMNOTA ||  ' | ' || F.FORNECEDOR      
       when C.CODCONTA = '3010006'   
       then 'PAGAMENTO DE ' || L.NUMNOTA || ' | ' || L.PREST || ' | ' || F.FORNECEDOR    
       when C.CODCONTA = '3010003'   
       then 'PAGAMENTO DE ' || L.NUMNOTA || ' | ' || L.PREST || ' | ' || F.FORNECEDOR    
       when C.CODCONTA = '3010002'   
       then 'PAGAMENTO DE ' || L.NUMNOTA || ' | ' || L.PREST || ' | ' || F.FORNECEDOR       
       when C.CODCONTA = '3040011'   
       then 'PAGAMENTO DE ' || L.NUMNOTA || ' | ' || L.PREST || ' | ' || F.FORNECEDOR
       when C.CODCONTA = '3040017'   
       then 'PAGAMENTO DE ' || L.NUMNOTA || ' | ' || L.PREST || ' | ' || F.FORNECEDOR
       when C.CODCONTA = '3040023'   
       then 'PAGAMENTO DE ' || L.NUMNOTA || ' | ' || L.PREST || ' | ' || F.FORNECEDOR
       when C.CODCONTA = '3040013'   
       then 'PAGAMENTO DE ' || L.NUMNOTA || ' | ' || L.PREST || ' | ' || F.FORNECEDOR
       when C.CODCONTA = '3040028'   
       then 'PAGAMENTO DE ' || L.NUMNOTA || ' | ' || L.PREST || ' | ' || F.FORNECEDOR     
       when C.CODCONTA = '4020005'   
       then 'PAGAMENTO DE ' || L.NUMNOTA || ' | ' || L.PREST || ' | ' || F.FORNECEDOR                
       when C.CODCONTA = '4020004'   
       then 'PAGAMENTO DE ' || C.CONTA || ' | ' ||L.NUMNOTA ||  ' | ' || F.FORNECEDOR 
       when C.CODCONTA = '4020006'   
       then 'RECEBIMENTO DE ' || C.CONTA || ' | ' ||L.NUMNOTA 
       when C.CODCONTA = '4020002'   
       then 'RECEBIMENTO DE NF ' ||L.NUMNOTA || ' | ' || L.PREST ||  ' | ' || F.FORNECEDOR  
       when C.CODCONTA = '4020017'   
       then 'RECEBIMENTO DE ' ||L.NUMNOTA || ' | ' || L.PREST 
       when C.CODCONTA = '4040003'   
       then 'RECEBIMENTO DE NF ' ||L.NUMNOTA || ' | ' || L.PREST ||  ' | ' || F.FORNECEDOR  
       when C.CODCONTA = '4040005'   
       then 'RECEBIMENTO DE NF ' ||L.NUMNOTA || ' | ' || L.PREST ||  ' | ' || F.FORNECEDOR  
       when C.CODCONTA = '4040007'   
       then 'RECEBIMENTO DE NF ' ||L.NUMNOTA || ' | ' || L.PREST ||  ' | ' || F.FORNECEDOR  
       when C.CODCONTA = '4040006'   
       then 'RECEBIMENTO DE NF ' ||L.NUMNOTA || ' | ' || L.PREST ||  ' | ' || F.FORNECEDOR  
       when C.CODCONTA = '4040001'   
       then 'RECEBIMENTO DE NF ' ||L.NUMNOTA || ' | ' || L.PREST ||  ' | ' || F.FORNECEDOR  
       when C.CODCONTA = '4050003'   
       then 'RECEBIMENTO DE NF ' ||L.NUMNOTA || ' | ' || L.PREST ||  ' | ' || F.FORNECEDOR  
       when C.CODCONTA = '4050001'   
       then 'RECEBIMENTO DE NF ' ||L.NUMNOTA || ' | ' || L.PREST ||  ' | ' || F.FORNECEDOR  
       when C.CODCONTA = '4050002'   
       then 'RECEBIMENTO DE NF ' ||L.NUMNOTA || ' | ' || L.PREST ||  ' | ' || F.FORNECEDOR  
       when C.CODCONTA = '4020002'   
       then 'RECEBIMENTO DE NF ' ||L.NUMNOTA || ' | ' || L.PREST ||  ' | ' || F.FORNECEDOR  
       when C.CODCONTA in ('4060019', '4060022', '4060025', '4060010', '4060014', '4060020',
        '4060021', '4060023', '4060024', '4060026', '4060002', '4060004', '4060005', '4060007',
        '4060006', '4060008','4060013', '4060018', '4060016', '4060015', '4060017', '4060001', 
        '4060003', '4060009', '4060011', '4060012')   
       then 'RECEBIMENTO DE ' || C.CONTA || ' | ' ||L.PREST 
       when C.CODCONTA = '5010007'   
       then 'RECEBIMENTO DE NF ' ||L.NUMNOTA || ' | ' || L.PREST ||  ' | ' || F.FORNECEDOR                                                                                                                                                                                                   
       else 'NDd'
       end HISTORICO
 from PCLANC L
 left join PCCONTA C on L.CODCONTA = C.CODCONTA
 left join PCGRUPO G on C.GRUPOCONTA = G.CODGRUPO
 left join PCMODELOPC M on C.CONTACONTABIL = M.CODREDUZIDO_PC
 left join PCFORNEC F on L.CODFORNEC = F.CODFORNEC
 where L.RECNUM ='67188';

