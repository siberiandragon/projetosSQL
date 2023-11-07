select G.GRUPO,
       C.CODCONTA,
       regexp_replace(C.CONTA, '\([^)]*\)', '') as CONTA,
       C.TIPO,
       C.CONTACONTABIL,
       M.CODCONTA_PC PLANO_CONTA,
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
       then 'DEVOLU픈O REF NF ' || L.NUMNOTA || ' | ' || F.FORNECEDOR
       when C.CODCONTA = '100002'
       then 'PAGAMENTO DE NF ' || L.NUMNOTA || '|'  || L.PREST ||' | ' || F.FORNECEDOR 
       when C.CODCONTA in ('100003','3020017', '3040008', '3040010', '3040024', 
                           '3040025', '3040026', '3040027', '3050001', '3050007', 
                           '3050010', '3060001', '3060002', '3060003', '3060004', 
                           '3060005', '3060006', '3060007', '3060008', '3060009', 
                           '3060010', '3060014', '3060015', '3060016', '3060017', 
                           '4020001', '4050004', '4050005', '5010001', '5010002', 
                           '5010003', '5010004', '5010008', '5010011', '5010014')
       then 'PAGAMENTO DE NF ' || L.NUMNOTA || '|'  || L.PREST ||' | ' || F.FORNECEDOR            
       when C.CODCONTA = '100016'
       then 'PAGAMENTO DE ICMS ' || to_char(trunc(L.DTCOMPETENCIA, 'MM'), 'MM/YYYY')        
       when C.CODCONTA = '100014'
       then 'PAGAMENTO DE IRPJ ' || to_char(trunc(L.DTCOMPETENCIA, 'MM'), 'MM/YYYY')    
       when C.CODCONTA = '100023'
       then 'PAGAMENTO DE NF ' || L.NUMNOTA || '|'  || L.PREST || ' | ' || F.FORNECEDOR
       when C.CODCONTA = '100011'
       then 'PAGAMENTO DE PIS ' ||  to_char(trunc(L.DTCOMPETENCIA, 'MM'), 'MM/YYYY')
       when C.CODCONTA = '3020016'
       then 'VALOR REF ' || C.CONTA || ' | '||  to_char(trunc(L.DTCOMPETENCIA, 'MM'), 'MM/YYYY')       
       when C.CODCONTA = '100021'
       then C.CONTA || L.NUMNOTA || ' | ' || F.FORNECEDOR  
       when C.CODCONTA in ('100026','100027','100030')
       then C.CONTA ||'REF NF ' || L.NUMNOTA || ' | ' || F.FORNECEDOR       
       when C.CODCONTA = '100017'   
       then 'PAGAMENTO DE ICMS ST ' ||  to_char(trunc(L.DTCOMPETENCIA, 'MM'), 'MM/YYYY') 
       when C.CODCONTA = '105'   
       then 'DEVOLU플O REF NF ' || L.NUMNOTA ||  ' | ' || F.FORNECEDOR    
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
       then 'RECEBIMENTO DE ' || C.CONTA ||L.NUMNOTA ||  ' | ' || F.FORNECEDOR   
       when C.CODCONTA = '2010018'   
       then C.CONTA || ' | ' || F.FORNECEDOR   
       when C.CODCONTA = '2010003'   
       then 'RECEBIMENTO REF '|| C.CONTA ||L.NUMNOTA ||  ' | ' || F.FORNECEDOR    
       when C.CODCONTA = '2010017'   
       then C.CONTA ||  ' | ' || L.NUMNOTA ||  ' | ' || F.FORNECEDOR    
       when C.CODCONTA = '2010020'   
       then C.CONTA ||  ' | ' || L.NUMNOTA ||  ' | ' || F.FORNECEDOR               
       when C.CODCONTA = '2010002'   
       then 'RECEBIMENTO REF ' || C.CONTA || L.NUMNOTA ||  ' | ' || F.FORNECEDOR 
       when C.CODCONTA = '2010013'   
       then 'RECEBIMENTO REF ' || C.CONTA || L.NUMNOTA ||  ' | ' || F.FORNECEDOR   
       when C.CODCONTA = '2020012'   
       then 'RECEBIMENTO DE '  || C.CONTA || L.NUMNOTA ||  ' | ' || F.FORNECEDOR 
       when C.CODCONTA = '2020006'   
       then 'JUROS' || ' | ' || L.NUMNOTA ||  ' | ' || F.FORNECEDOR         
       when C.CODCONTA in ('2020005','302013','302014','3020003','3020006','3020007',
                           '3020010','4020018')
       then 'VALOR REF ' || C.CONTA
       when C.CODCONTA = '2010012'   
       then 'RECEITA REF ' || C.CONTA    
       when C.CODCONTA = '3020005'   
       then 'PAGAMENTO DE ' || C.CONTA           
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
       when C.CODCONTA = '2020012'   
       then 'RECEBIMENTO DE ' || C.CONTA || ' | ' || L.NUMNOTA ||  ' | ' || F.FORNECEDOR  
       when C.CODCONTA = '250998'   
       then 'PAGAMENTO DE ADIANTAMENTO DE FORNECEDOR  '|| ' | ' || L.NUMTRANSADIANTFOR ||  ' | ' || F.FORNECEDOR    
       when C.CODCONTA = '250999'   
       then 'PAGAMENTO DE ADIANTAMENTO DE FORNECEDOR  '|| ' | ' || L.NUMTRANSADIANTFOR ||  ' | ' || F.FORNECEDOR           
       when C.CODCONTA = '4010005'   
       then 'PAGAMENTO DE ADIANTAMENTO DE FORNECEDOR  '|| ' | ' || L.NUMTRANSADIANTFOR ||  ' | ' || F.FORNECEDOR                     
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
       when C.CODCONTA = '4030003'
       then C.CONTA || ' DEVOLU플O FINANCIAMENTO LOSANGO ' ||L.NUMNOTA ||  ' | ' || F.FORNECEDOR
       when C.CODCONTA = '4030002'
       then C.CONTA || ' DEVOLU플O FINANCIAMENTO SANTANDER ' ||L.NUMNOTA ||  ' | ' || F.FORNECEDOR                   
       when C.CODCONTA in ('4030004','4030005','4030006','4030007')
       then C.CONTA || ' DEVOLU플O DE DEMONSTRA플O ' ||L.NUMNOTA ||  ' | ' || F.FORNECEDOR        
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
                           '4060021', '4060023', '4060024', '4060026', '4060002', '4060004',
                           '4060005', '4060007', '4060006', '4060008', '4060013', '4060018', 
                           '4060016', '4060015', '4060017', '4060001', '4060003', '4060009', 
                           '4060011', '4060012')   
       then 'RECEBIMENTO DE ' || C.CONTA || ' | ' ||L.PREST 
       when C.CODCONTA = '5010007'   
       then 'RECEBIMENTO DE NF ' ||L.NUMNOTA || ' | ' || L.PREST ||  ' | ' || F.FORNECEDOR    
       when C.CODCONTA in ('3030001', '3030002', '3030003', '3030004')
       then C.CONTA
       when C.CODCONTA in ('3070001', '3070004', '3070007', '3070013', '3070015',
                           '3070002', '3070003', '3070005', '3070011', '3070012', 
                           '3070009', '3070008', '3070006', '3070014', '4020016')   
       then 'PAGAMENTO DE ' ||C.CONTA || ' | ' || 'Max.Prest: ' || (select max(L.PREST) from PCLANC where RECNUM = 4872 ) 
       when C.CODCONTA = '4020015'   
       then 'PAGAMENTO DE ' ||C.CONTA || ' | ' || F.FORNECEDOR    
       when C.CODCONTA in ('4010001', '4010006', '4020007', '4020012', '4020008',
                           '3040001', '3040002', '3040003', '3040004', '3040006', 
                           '3040007', '3040012', '3040014', '3040018', '3040019', 
                           '3040020', '3040021', '3050004', '3050008', '3060012',
                           '3060013', '5010010')
       then 'PAGAMENTO DE ' ||C.CONTA || ' | ' || to_char(trunc(L.DTCOMPETENCIA, 'MM'), 'MM/YYYY')   
       when C.CODCONTA in ('3050006', '3040005', '3040009', '3040015')   
       then 'PAGAMENTO DE ' ||C.CONTA || ' | ' || L.NUMNOTA   
       when C.CODCONTA in ('3040016', '3050003', '3050005')   
       then 'PAGAMENTO DE ' ||C.CONTA || ' | ' || L.NUMNOTA || ' | ' || L.PREST 
       when C.CODCONTA in ('5010012', '5010013')  
       then 'PAGAMENTO DE ' ||C.CONTA || ' | ' || L.PREST        
       when C.CODCONTA = '5010009'  
       then 'PAGAMENTO DE ' ||C.CONTA || ' | ' || L.NUMNOTA || ' | ' || L.PREST || ' | ' || F.FORNECEDOR      
       when C.CODCONTA = '3060011'   
       then 'PAGAMENTO DE ' ||C.CONTA || ' | ' || L.NUMNOTA || ' | ' || F.FORNECEDOR         
       when C.CODCONTA = '3020018'   
       then 'VARIA플O CAMBIAL REF ' || L.NUMNOTA 
       when C.CODCONTA = '3020012'   
       then 'VALOR REF ' ||C.CONTA || ' | ' || L.NUMCHEQUE || ' | ' || F.FORNECEDOR                                                                                                                                                                                                                                                      
       else 'NDd'
       end HISTORICO
 from PCLANC L
 left join PCCONTA C on L.CODCONTA = C.CODCONTA
 left join PCGRUPO G on C.GRUPOCONTA = G.CODGRUPO
 left join PCMODELOPC M on C.CONTACONTABIL = M.CODREDUZIDO_PC
 left join PCFORNEC F on L.CODFORNEC = F.CODFORNEC
 where 0=0
-- and L.RECNUM = 4872;

