DELIMITER //
CREATE FUNCTION livros_genero(genero VARCHAR(255))
RETURNS INT
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total
    FROM Livro L
    INNER JOIN Genero G ON L.id_genero = G.id
    WHERE G.genero = genero;
    RETURN total;
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION livros_autor(prim_nome VARCHAR(255), ult_nome VARCHAR(255))
RETURNS TEXT
BEGIN
    DECLARE lista_livros TEXT;
    SET lista_livros = '';

    SELECT GROUP_CONCAT(L.titulo) INTO lista_livros
    FROM Livro_Autor LA
    INNER JOIN Livro L ON LA.id_livro = L.id
    INNER JOIN Autor A ON LA.id_autor = A.id
    WHERE A.prim_nome = prim_nome AND A.ult_nome = ult_nome;

    RETURN lista_livros;
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION atual_resumos()
RETURNS INT
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE livro_id INT;

    DECLARE cur CURSOR FOR
    SELECT id
    FROM Livro;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    update_loop: LOOP
        FETCH cur INTO livro_id;

        IF done = 1 THEN
            LEAVE update_loop;
        END IF;

        UPDATE Livro
        SET resumo = CONCAT(resumo, 'Este é um excelente livro!')
        WHERE id = livro_id;
    END LOOP;

    CLOSE cur;

    RETURN 1;
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION livros_editora()
RETURNS DECIMAL(5,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE media DECIMAL(5,2);

    SELECT AVG(editora) INTO media
    FROM (SELECT id_editora, COUNT(*) AS editora
          FROM Livro
          GROUP BY id_editora) AS temp;

    RETURN media;
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION aut_sem_livros()
RETURNS TEXT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE lista_aut_sem_livros TEXT;
    SET lista_aut_sem_livros = '';

    SELECT GROUP_CONCAT(CONCAT(prim_nome, ' ', ult_nome)) INTO lista_aut_sem_livros
    FROM Autor
    WHERE id NOT IN (SELECT DISTINCT id_autor FROM Livro_Autor);

    RETURN lista_aut_sem_livros;
END;
//
DELIMITER ;
