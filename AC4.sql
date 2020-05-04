use LMS

--1- Em um único SELECT exiba o nome do(s) professor(es) que deram nota 2 nas ACs 1
--entregues no primeiro semestre de 2015 (exiba apenas uma vez o nome de cada
--professor)

SELECT  
    PROFESSOR.NOME, 
    ENTREGA.DTENTREGA, 
    ENTREGA.TITULO, 
    ENTREGA.NOTA
FROM ENTREGA
    JOIN PROFESSOR ON PROFESSOR.ID = ENTREGA.IDPROFESSOR
    JOIN ALUNO ON ALUNO.ID = ENTREGA.IDALUNO
WHERE (ENTREGA.DTENTREGA BETWEEN '2015-01-01' AND '2015-06-30' AND ENTREGA.TITULO = 'AC 1' AND ENTREGA.NOTA = 2.00)

--2- Em um único SELECT exiba o nome, email e login do(s) alunos(s) que não possuem
--nenhuma atividade cadastrada na tabela ENTREGA. Ordenado alfabeticamente pelo
--nome do aluno.

SELECT 
	ALUNO.NOME,
	ALUNO.ID,
	ENTREGA.*,
	ALUNO.EMAIL,
	USUARIO.LOGIN
	
FROM ALUNO
	INNER JOIN USUARIO 
	ON USUARIO.ID = ALUNO.IDUSUARIO
	LEFT JOIN ENTREGA 
	ON ENTREGA.IDALUNO = ALUNO.ID
WHERE IDALUNO IS NULL
ORDER BY ALUNO.NOME ASC;



--3- Em um único SELECT exiba nome dos professores e das disciplinas da turma A do
--semestre 1 do ano de 2016 do curso de 'Banco de Dados'. Ordenados pelo nome da
--disciplina. Crie alias/apelido para identificaras colunas.


SELECT 
	PROFESSOR.NOME AS 'NOME_PROFESSOR', 
	DISCIPLINA.NOME AS 'NOME_DISCIPLINA'
FROM PROFESSOR
	JOIN DISCIPLINAOFERTADA ON DISCIPLINAOFERTADA.IDPROFESSOR = PROFESSOR.ID
	JOIN CURSO ON CURSO.ID = DISCIPLINAOFERTADA.IDCURSO 
	JOIN DISCIPLINA ON DISCIPLINA.ID = DISCIPLINAOFERTADA.IDDISCIPLINA
WHERE DISCIPLINAOFERTADA.TURMA = 'A' AND DISCIPLINAOFERTADA.SEMESTRE = 1 AND DISCIPLINAOFERTADA.ANO = 2016 AND CURSO.NOME = 'Banco De Dados'
ORDER BY DISCIPLINA.NOME


--4- Em um único SELECT exiba em 4 colunas o login, senha, o nome da pessoa (aluno ou
--coordenador) e na quarta coluna exiba se aquele nome é de um aluno ou de
--coordenador. Exibir somente logins de alunos ou coordenadores. Ordene exibindo
--primeiramente os alunos e depois os coordenadores. Crie alias/apelido para identificaras
--colunas.

SELECT 
	USUARIO.LOGIN LOGIN, 
	USUARIO.SENHA SENHA, 
	CONCAT(ALUNO.NOME, 
	COORDENADOR.NOME) AS NOME,
CASE
	WHEN ALUNO.IDUSUARIO = USUARIO.ID THEN 'ALUNO'
	ELSE 'COORDENADOR'
END ALUNO_COORDENADOR
	FROM USUARIO
	LEFT JOIN ALUNO ON ALUNO.IDUSUARIO = USUARIO.ID
	LEFT JOIN COORDENADOR ON COORDENADOR.IDUSUARIO = USUARIO.ID
WHERE ALUNO.IDUSUARIO = USUARIO.ID OR COORDENADOR.IDUSUARIO = USUARIO.ID
ORDER BY ALUNO_COORDENADOR


--5-Em um único SELECT exiba em colunas o nome dos professores, a nota das 5 ACs (uma
--nota em cada coluna) e a média das notas das ACs ((AC1+AC2+AC3+AC4+AC5)/ 5 ) da
--aluna 'ELIANA PRADO DE AZEVEDO'. Ordene considerando as médias em ordem
--crescente. Crie alias/apelido para identificaras colunas



SELECT COLUNAS.NOME, 
	ISNULL(COLUNAS.[AC 1],0) AC1 , 
	ISNULL(COLUNAS.[AC 2],0) AC2, 
	ISNULL(COLUNAS.[AC 3],0) AC3, 
	ISNULL(COLUNAS.[AC 4],0) AC4,
	ISNULL(COLUNAS.[AC 5],0) AC5,
((ISNULL(COLUNAS.[AC 1],0) + ISNULL(COLUNAS.[AC 2],0) + ISNULL(COLUNAS.[AC 3],0) + ISNULL(COLUNAS.[AC 4],0) + ISNULL(COLUNAS.[AC 5],0))/ 5 ) MEDIA_AC
FROM
(
SELECT
	PROFESSOR.NOME,
	ENTREGA.NOTA,
	ENTREGA.TITULO
FROM ENTREGA
	JOIN PROFESSOR ON PROFESSOR.ID = ENTREGA.IDPROFESSOR
	JOIN ALUNO ON ALUNO.ID = ENTREGA.IDALUNO 
WHERE ALUNO.NOME = 'ELIANA PRADO DE AZEVEDO'
) AS LINHAS

	PIVOT (SUM(NOTA) FOR TITULO IN ([AC 1], [AC 2], [AC 3], [AC 4], [AC 5], [MEDIA_ACS] )) AS COLUNAS
ORDER BY MEDIA_ACS ASC

--PROFESSOR, NÃO CONSEGUIMOS FAZER O 5º EXERCICIO COM JOINS!




