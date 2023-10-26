DELIMITER //
CREATE TRIGGER inserir_trigger
AFTER INSERT ON Clientes
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (mensagem) VALUES (CONCAT('Novo cliente em', NOW()));
END;
//
DELIMITER ;
DELIMITER //
CREATE TRIGGER exclusao_trigger
BEFORE DELETE ON Clientes
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (mensagem) VALUES (CONCAT('Exclusão de um cliente, ', OLD.nome, ' em ', NOW()));
END;
//
DELIMITER ;
DELIMITER //
CREATE TRIGGER atualiza_trigger
BEFORE UPDATE ON Clientes
FOR EACH ROW
BEGIN
    IF NEW.nome IS NULL OR NEW.nome = '' THEN
        INSERT INTO Auditoria (mensagem) VALUES (CONCAT('Nome do cliente', OLD.nome, ' atualizado para ', NEW.nome, 'em ', NOW()));
    END IF;
END;
//
DELIMITER ;
DELIMITER //
CREATE TRIGGER decrementa_estoque
AFTER INSERT ON Pedidos
FOR EACH ROW
BEGIN
    UPDATE Produtos
    SET estoque = estoque - NEW.quantidade
    WHERE id = NEW.produto_id;
    IF (SELECT estoque FROM Produtos WHERE id = NEW.produto_id) < 5 THEN
        INSERT INTO Auditoria (mensagem) VALUES (CONCAT('O produto', (SELECT nome FROM Produtos WHERE id = NEW.produto_id), ' está com menos de 5 unidades em ', NOW()));
    END IF;
END;
//
DELIMITER ;
