-- Criação da tabela comissao_venda
CREATE TABLE dbo.comissao_venda (
    id BIGINT NOT NULL PRIMARY KEY,
    habilitado BIT,
    criado_por BIGINT,
    data_criacao DATE,
    data_ultima_modificacao DATE,
    ultima_modificacao_por BIGINT,
    versao BIGINT,
    aprovacao BIT,
    aprovacao_comercial BIT,
    aprovacao_financeiro BIT,
    data_aprovacao_comercial DATE,
    data_aprovacao_financeiro DATE,
    motivo_rejeicao NVARCHAR(1000),
    numero_transacao_venda NVARCHAR(255),
    prestacao NVARCHAR(255),
    rejeitada BIT,
    responsavel_aprovacao_comercial NVARCHAR(255),
    responsavel_aprovacao_financeiro NVARCHAR(255),
    tipo_comissao NVARCHAR(255),
    valor_comissao_selecionada FLOAT,
    emails_aprovacao NVARCHAR(255)
);

-- Inserção de um registro na tabela comissao_venda
INSERT INTO dbo.comissao_venda (
    id, 
    habilitado,
    criado_por,
    data_criacao, 
    data_ultima_modificacao, 
    ultima_modificacao_por, 
    versao, 
    aprovacao,
    aprovacao_comercial, 
    aprovacao_financeiro, 
    data_aprovacao_comercial, 
    data_aprovacao_financeiro, 
    motivo_rejeicao,
    numero_transacao_venda, 
    prestacao, 
    rejeitada, 
    responsavel_aprovacao_comercial, 
    responsavel_aprovacao_financeiro,
    tipo_comissao, 
    valor_comissao_selecionada, 
    emails_aprovacao
) VALUES (
1,                        -- id
1,                        -- habilitado
NULL,                     -- criado_por
'2023-11-07',             -- data_criacao
'2023-11-07',             -- data_ultima_modificacao
NULL,                     -- ultima_modificacao_por
2,                        -- versao
1,                        -- aprovacao
1,                        -- aprovacao_comercial
1,                        -- aprovacao_financeiro
'2023-11-07',             -- data_aprovacao_comercial
'2023-11-07',             -- data_aprovacao_financeiro
NULL,                     -- motivo_rejeicao
'199686',                 -- numero_transacao_venda
'1',                      -- prestacao
0,                        -- rejeitada
NULL,                     -- responsavel_aprovacao_comercial
NULL,                     -- responsavel_aprovacao_financeiro
'comissao_com_nfe',       -- tipo_comissao
268.40,                   -- valor_comissao_selecionada
NULL                      -- emails_aprovacao

);

-- Criação da tabela relacionamento_comissao_venda_lancamento
CREATE TABLE dbo.relacionamento_comissao_venda_lancamento (
    id BIGINT NOT NULL PRIMARY KEY,
    habilitado BIT,
    recnum BIGINT,
    comissao_venda_id BIGINT,
    FOREIGN KEY (comissao_venda_id) REFERENCES dbo.comissao_venda(id)
);

-- Inserção de um registro na tabela relacionamento_comissao_venda_lancamento
INSERT INTO dbo.relacionamento_comissao_venda_lancamento (
    id, 
    habilitado, 
    recnum, 
    comissao_venda_id
) VALUES (
    1,                        -- id
    1,                        -- habilitado
    12345,                    -- recnum
    1                         -- comissao_venda_id

);

-- Criação da tabela usuario
CREATE TABLE dbo.usuario (
    id BIGINT NOT NULL PRIMARY KEY,
    habilitado BIT,
    criado_por BIGINT,
    data_criacao DATE,
    data_ultima_modificacao DATE,
    ultima_modificacao_por BIGINT,
    versao BIGINT,
    nome NVARCHAR(100) NOT NULL,
    password NVARCHAR(255) NOT NULL,
    username NVARCHAR(255) NOT NULL,
    senha_temporaria NVARCHAR(255)
);

-- Inserção de um registro na tabela usuario
INSERT INTO dbo.usuario (
    id,
    habilitado, 
    criado_por, 
    data_criacao, 
    data_ultima_modificacao, 
    ultima_modificacao_por, 
    versao,
    nome, 
    password, 
    username, 
    senha_temporaria
) VALUES (
1,                        -- id
1,                        -- habilitado
NULL,                     -- criado_por
'2023-11-07',             -- data_criacao
'2023-11-07',             -- data_ultima_modificacao
NULL,                     -- ultima_modificacao_por
1,                        -- versao
'felipe',                 -- nome
'senha123',               -- password
'felipe.s',               -- username
NULL                      -- senha_temporaria

);

-- Criação da tabela usuario_roles
CREATE TABLE dbo.usuario_roles (
    usuario_id BIGINT NOT NULL,
    roles NVARCHAR(255),
    PRIMARY KEY (usuario_id, roles),
    FOREIGN KEY (usuario_id) REFERENCES dbo.usuario(id)
);

-- Inserção de um registro na tabela usuario_roles
INSERT INTO dbo.usuario_roles (
    usuario_id, 
    roles
) VALUES (
    1,              --usuario_id
    'Admin'         --roles
);
