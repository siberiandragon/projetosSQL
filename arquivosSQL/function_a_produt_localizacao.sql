create or replace FUNCTION A_PRODUT_LOCALIZACAO( XCODPROD PCPRODUT.CODPROD%TYPE, XCODFILIAL PCPRODUT.CODFILIAL%TYPE, XLOCALIZACAO PCPRODUT.DESCRICAO2%TYPE ) 

RETURN VARCHAR2 
IS

PRAGMA AUTONOMOUS_TRANSACTION;

XMENSAGEM VARCHAR(300) := 'ALGO ACONTECEU';
v_contadorPROD int := 0;

BEGIN

    BEGIN
    
    -- VALIDA SE EXISTE UM PRODUTO COM O CODIGO INFORMADO
        SELECT 
            COUNT(CODPROD) INTO v_contadorPROD
        FROM
            PCPRODUT
        WHERE 
            PCPRODUT.CODPROD = X.CODPROD;
       
       IF v_contadorPROD = 1 THEN
            IF XLOCALIZACAO IS NOT NULL THEN
                IF XCODFILIAL = 2 THEN
                XMENSAGEM:= 'NÃO EXISTE TITULO PENDETE PARA ESSA TRANSAÇÃO OU JA FOI APROVADO ANTERIORMENTE';
                    UPDATE 
                        PCPRODUT
                    SET 
                        DESCRICAO2 = XLOCALIZACAO
                    WHERE 
                        CODPROD = XCODPROD;
                               
                    COMMIT; 
                    XMENSAGEM:= 'PRODUTO ATUALIZADO COM SUCESSO';
                ELSIF XCODFILIAL = 3 THEN
                    UPDATE 
                        PCPRODUT
                    SET 
                        DESCRICAO3 = XLOCALIZACAO
                    WHERE 
                        CODPROD = XCODPROD;
                               
                    COMMIT; 
                    XMENSAGEM:= 'PRODUTO ATUALIZADO COM SUCESSO';
                ELSIF XCODFILIAL = 4 THEN
                    UPDATE 
                	PCPRODUT
                    SET 
                        DESCRICAO4 = XLOCALIZACAO
                    WHERE 
                        CODPROD = XCODPROD;
                               
                    COMMIT; 
                    XMENSAGEM:= 'PRODUTO ATUALIZADO COM SUCESSO';
                ELSE
                   XMENSAGEM:= 'FILIAL INVALIDA'; 
                END IF;
            ELSE 
                XMENSAGEM:= 'A LOCALIZACAO NÃO PODE SER VAZIA';
            END IF;
        ELSE
             XMENSAGEM:= 'NENHUM PRODUTO LOCALIZADO COM O CODIGO INFORMADO';
         
        END IF;
        
    EXCEPTION
        
        WHEN OTHERS THEN

            RAISE_APPLICATION_ERROR(-20001, ('ERRO AO ATUALIZAR PRODUTO') );
        
        END;

    RETURN XMENSAGEM;

END;