SELECT 	RECNUM, 
		RECNUMPRINC, 
		DTLANC,
		CODFILIAL,
		TIPOLANC,
		INDICE, 
		MOEDA,
		CODCONTA,
		HISTORICO,
		HISTORICO2, 
		TIPOPARCEIRO,
		CODFORNEC,
		TO_CHAR(NUMNOTA) NUMNOTA,
		DUPLIC,
		DTVENC,
		VALOR,
		NUMCODBARRA, 
		NUMNOTADEV,
		VALORDEV, 
		DESCONTOFIN,
		TXPERM, 
		PRORROG,
		DTEMISSAO,
		LOCALIZACAO,
		NOMEFUNC,
		NUMTRANSENT, 
		FROTA_CODPRACA,
		FROTA_QTLITROS,
		FROTA_NUMCAR,
		FROTA_CODVEICULO,
		FROTA_COMISSAO,
		FROTA_DTABASTECE, 
		FROTA_KMABASTECE, 
		NVL(NFSERVICO,'N') NFSERVICO,
		CODPROJETO,DTCOMPETENCIA,
		VLISS,
		VLINSS,
		VLCSRF,
		VLIRRF,
		VLPIS,
		VLCOFINS,
		NVL(BOLETO,'N') BOLETO, 
		NVL(UTILIZOURATEIOCONTA, 'N') UTILIZOURATEIOCONTA, 
		NVL(PRCRATEIOUTILIZADO, 100) PRCRATEIOUTILIZADO, 
		COTACAO, 
		DTCOTACAO, 
		MOEDAESTRANGEIRA, 
		CODRECEITA, 
		FORMAPGTO, 
		VRECEITABRUTA, 
		PERCRECEITABRUTA, 
		PARCELA,
		NUMPARCELAMENTO, 
		NUMSEQPARCELAMENTO, 
		NUMNEGOCIACAO, 
		FORNECEDOR, 
		CODSERVICOSPEDEFD, 
		TIPOSERVICO, 
		OPCAOPAGAMENTOIPVA, 
		IDENTIFICADORFGTS,
		LACREDIGCONECSOCIAL,
		NUMBANCO,
		NUMCCDESTDOC,
		NUMAGDESTDOC,
		NUMDVDESTDOC,
		DVAG,
		VALORMOEDAESTRANGEIRA,
		CODSERVICOSPEDIRPF,
		CODSERVICOSPEDIRPJ,
		REINFEVENTOR4040,
		CODSERVICOSPEDBNI
  FROM 	PCLANC         
 WHERE 	RECNUM= 84968 