
SELECT titulo FROM livros;
SELECT nome, nascimento FROM autores WHERE YEAR(nascimento) < 1900;
SELECT l.titulo
FROM livros l
JOIN autores a ON l.autor_id = a.id
WHERE a.nome = 'J.K. Rowling';
SELECT alunos.nome
FROM alunos
INNER JOIN matriculas ON alunos.id = matriculas.aluno_id
WHERE matriculas.curso = 'Engenharia de Software';
SELECT produto, SUM(receita) as receita_total
FROM vendas
GROUP BY produto;
SELECT a.nome, COUNT(l.id) as numero_livros
FROM autores a
LEFT JOIN livros l ON a.id = l.autor_id
GROUP BY a.nome;
