DELIMITER //
CREATE PROCEDURE sp_ListarAutores()
BEGIN
    SELECT * FROM Autor;
END //
DELIMITER ;
CALL sp_ListarAutores();


DELIMITER //
CREATE PROCEDURE sp_LivrosPorCategoria(IN categoria_nome VARCHAR(100))
BEGIN
    SELECT Livro.Titulo, Autor.Nome, Autor.Sobrenome
    FROM Livro
    INNER JOIN Categoria ON Livro.Categoria_ID = Categoria.Categoria_ID
    INNER JOIN Autor_Livro ON Livro.Livro_ID = Autor_Livro.Livro_ID
    INNER JOIN Autor ON Autor_Livro.Autor_ID = Autor.Autor_ID
    WHERE Categoria.Nome = categoria_nome;
END //
DELIMITER ;
CALL sp_LivrosPorCategoria('Romance');

DELIMITER //
CREATE PROCEDURE sp_ContarLivrosPorCategoria(IN categoria_nome VARCHAR(100), OUT total_livros INT)
BEGIN
    SELECT COUNT(*) INTO total_livros
    FROM Livro
    INNER JOIN Categoria ON Livro.Categoria_ID = Categoria.Categoria_ID
    WHERE Categoria.Nome = categoria_nome;
END //
    
DELIMITER ;
SET @resultado = 0;
CALL sp_ContarLivrosPorCategoria('Romance', @resultado);
SELECT @resultado;


DELIMITER //
CREATE PROCEDURE sp_VerificarLivrosCategoria(IN categoria_nome VARCHAR(100), OUT possui_Livros BOOLEAN)
BEGIN
    DECLARE total INT;
    
    SELECT COUNT(*) INTO total
    FROM Livro
    INNER JOIN Categoria ON Livro.Categoria_ID = Categoria.Categoria_ID
    WHERE Categoria.Nome = categoria_nome;
    
    IF total > 0 THEN
        SET possui_livros = TRUE;
    ELSE
        SET possui_livros = FALSE;
    END IF;
END //

DELIMITER ;
CALL sp_VerificarLivrosCategoria('Romance', @resultado);
SELECT @resultado;


DELIMITER //
CREATE PROCEDURE sp_LivrosAteAno(IN ano_limite INT)
BEGIN
    SELECT Titulo, Ano_Publicacao
    FROM Livro
    WHERE Ano_Publicacao <= ano_limite;
END //

DELIMITER ;
CALL sp_LivrosAteAno(2010);


DELIMITER //
CREATE PROCEDURE sp_TitulosPorCategoria(IN categoria_nome VARCHAR(100))
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE livro_titulo VARCHAR(255);
    DECLARE cur CURSOR FOR
        SELECT Livro.Titulo
        FROM Livro
        INNER JOIN Categoria ON Livro.Categoria_ID = Categoria.Categoria_ID
        WHERE Categoria.Nome = categoria_nome;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;
    FETCH cur INTO livro_titulo;

    WHILE NOT done DO
        SELECT livro_titulo AS 'Título do Livro';
        FETCH cur INTO livro_titulo;
    END WHILE;

    CLOSE cur;
END //

DELIMITER ;
CALL sp_TitulosPorCategoria('Romance');


DELIMITER //
CREATE PROCEDURE sp_AdicionarLivro(
    IN titulo_livro VARCHAR(255),
    IN editora_id INT,
    IN ano_publicacao INT,
    IN numero_paginas INT,
    IN categoria_id INT,
    OUT mensagem VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR 1062
    BEGIN
        SET mensagem = 'Negado. O titulo já existe';
    END;

    INSERT INTO Livro (Titulo, Editora_ID, Ano_Publicacao, Numero_Paginas, Categoria_ID)
    VALUES (titulo_livro, editora_id, ano_publicacao, numero_paginas, categoria_id);
    
    SET mensagem = 'Livro adicionado.';
END //

DELIMITER ;
CALL sp_AdicionarLivro('História de Roma', 1, 1995, 400, 4, @mensagem);
SELECT @mensagem;
CALL sp_AdicionarLivro('Livro Novo', 2, 2023, 333, 2, @mensagem);
SELECT @mensagem;


DELIMITER //
CREATE PROCEDURE sp_AutorMaisAntigo(OUT nome_autor VARCHAR(255))
BEGIN
    SELECT CONCAT(Nome, ' ', Sobrenome) INTO nome_autor
    FROM Autor
    WHERE Data_Nascimento = (SELECT MIN(Data_Nascimento) FROM Autor);
END //

DELIMITER ;
CALL sp_AutorMaisAntigo(@nome_autor);
SELECT @nome_autor;


DELIMITER //
CREATE PROCEDURE sp_LivrosPorCategoria(IN categoriaNome VARCHAR(100))
BEGIN
    -- Declare um cursor para percorrer os resultados da consulta.
    DECLARE done INT DEFAULT FALSE;
    DECLARE titulo VARCHAR(255);

    -- Crie um cursor que seleciona os títulos dos livros de uma categoria específica.
    DECLARE cur CURSOR FOR
    SELECT Livro.Titulo
    FROM Livro
    INNER JOIN Categoria ON Livro.Categoria_ID = Categoria.Categoria_ID
    WHERE Categoria.Nome = categoriaNome;

    -- Defina um manipulador para tratar o caso em que nenhum resultado é encontrado.
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Abra o cursor.
    OPEN cur;

    -- Inicie um loop para recuperar os títulos dos livros.
    read_loop: LOOP
        -- Tente buscar um título do cursor.
        FETCH cur INTO titulo;

        -- Verifique se todos os registros foram lidos.
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Se um título foi recuperado, selecione-o.
        SELECT titulo;
    END LOOP;

    -- Feche o cursor.
    CLOSE cur;
END //
DELIMITER ;

DELIMITER//
CREATE PROCEDURE sp_LivrosESeusAutores()
BEGIN
    SELECT Livro.Titulo, CONCAT(Autor.Nome, ' ', Autor.Sobrenome) AS 'Nome do Autor'
    FROM Livro
    INNER JOIN Autor_Livro ON Livro.Livro_ID = Autor_Livro.Livro_ID
    INNER JOIN Autor ON Autor_Livro.Autor_ID = Autor.Autor_ID;
END //

DELIMITER ;
CALL sp_LivrosESeusAutores();
