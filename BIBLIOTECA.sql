create table Editora(
	idEditora integer primary key not null,
	Nome varchar(30),
	Endereço varchar(70),
	Bairro varchar(30),
	Cidade varchar(30),
	UF varchar(30)
);

create table Leitor(
	idLeitor integer primary key not null,
	Nome varchar(30),
	Telefone varchar,
	CPF varchar(11),
	Rua varchar(30),
	Bairro varchar(30),
	Cidade varchar(20),
	UF varchar(20),
	Multar integer	
);
create table Funcionario(
	idFuncionario integer primary key not null,
	Nome varchar(30),
	Telefone integer,
	CPF varchar(11),
	Rua varchar(30),
	Bairro varchar(30),
	Cidade varchar(20),
	UF varchar(20)	
);

create table Reserva(
	idReserva integer primary key not null,
	Leitor_idLeitor integer,
	Status_da_reserva bool,
	constraint Reserva_FKIndex1 foreign key(leitor_idLeitor) references leitor(idLeitor)
);

create table titulo(
	idTitulo integer primary key not null,
	Reserva_idReserva integer,
	Nome varchar(30),
	Autor varchar(30),
	Assunto varchar(20),
	constraint Titulo_FKIndex1 foreign key(Reserva_idReserva) references reserva(idReserva)
);

create table Livro(
	idLivro integer primary key not null,
	Titulo_idTitulo integer,
	Editora_idEditora integer,
	Assunto varchar,
	Status_livro bool,
	Autor varchar(30),
	constraint Livro_FKIndex1 foreign key(titulo_idTitulo) references titulo(idTitulo),
	constraint Livro_FKIndex2 foreign key(editora_idEditora) references editora(idEditora)
);

create table Emprestimo(
	idEmprestimo integer primary key not null,
	Funcionario_idFuncionario integer,
	Leitor_idLeitor integer,
	Hora date,
	constraint Emprestimo_FKIndex1  foreign key(leitor_idLeitor) references leitor(idLeitor),
	constraint Emprestimo_FKIndex2  foreign key(Funcionario_idFuncionario) references funcionario(idFuncionario)
);

create table ItemEmprestimo(
	idItemEMprestimo serial,
	Titulo_idTitulo integer,
	Livro_idLivro integer,
	Emprestimo_idEmprestimo integer,
	DataDevolucao date,
	constraint ItemEmprestimo_FKIndex1  foreign key(Titulo_idTitulo) references titulo(idTitulo),
	constraint ItemEmprestimo_FKIndex2  foreign key(Emprestimo_idEmprestimo) references emprestimo(idEmprestimo),
	constraint ItemEmprestimo_FKIndex3  foreign key(Livro_idLivro) references livro(idLivro)	
);


CREATE OR REPLACE FUNCTION CADASTRAR_EDITORA(COD INT, N VARCHAR, ENDERECO VARCHAR, BAIRRO VARCHAR, CIDADE VARCHAR, UF VARCHAR)
RETURNS VOID AS $$
	DECLARE
		CODIGO INT;
		NOM VARCHAR;
	BEGIN
		SELECT IDEDITORA INTO CODIGO FROM EDITORA WHERE IDEDITORA = COD;
		SELECT NOME INTO NOM FROM EDITORA WHERE NOME = N;
		IF CODIGO IS NULL THEN
			IF NOM IS NULL THEN
				INSERT INTO EDITORA VALUES (COD, N, ENDERECO, BAIRRO, CIDADE, UF);
			ELSE
				RAISE EXCEPTION 'Nome já cadastrado';
			END IF;
		ELSE
			RAISE EXCEPTION 'Código já cadastrado';
		END IF;
	END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION CUD_EDITORA(OPERACAO VARCHAR, COD INT, N VARCHAR, ENDE VARCHAR, BA VARCHAR, CID VARCHAR, ESTADO VARCHAR)
RETURNS VOID AS $$
	DECLARE
		CODIGO INT;
		NOM VARCHAR;
	BEGIN
		IF OPERACAO LIKE 'CAD%' THEN
			SELECT IDEDITORA INTO CODIGO FROM EDITORA WHERE IDEDITORA = COD;
			SELECT NOME INTO NOM FROM EDITORA WHERE NOME = N;
			IF CODIGO IS NULL THEN
				IF NOM IS NULL THEN
					INSERT INTO EDITORA VALUES (COD, N, ENDERECO, BAIRRO, CIDADE, UF);
				ELSE
					RAISE EXCEPTION 'Nome já cadastrado';
				END IF;
			ELSE
				RAISE EXCEPTION 'Código já cadastrado';
			END IF;
		ELSIF OPERACAO LIKE 'EXC%' OR OPERACAO LIKE 'DEL%' THEN
			UPDATE LIVRO SET EDITORA_IDEDITORA = NULL WHERE EDITORA_IDEDITORA = COD;
			DELETE FROM EDITORA WHERE IDEDITORA = COD;
		ELSIF OPERACAO LIKE 'ALT%' OR OPERACAO LIKE 'MODI%' THEN
			IF N IS NOT NULL THEN
				UPDATE EDITORA SET NOME = N WHERE IDEDITORA = COD;
			END IF;
			IF BA IS NOT NULL THEN
				UPDATE EDITORA SET BAIRRO = BA WHERE IDEDITORA = COD;
			END IF;
			IF CID IS NOT NULL THEN
				UPDATE EDITORA SET CIDADE = CID WHERE IDEDITORA = COD;
			END IF;
			IF ESTADO IS NOT NULL THEN
				UPDATE EDITORA SET UF = ESTADO WHERE IDEDITORA = COD;
			END IF;
			IF ENDE IS NOT NULL THEN
				UPDATE EDITORA SET ENDEREçO = ENDE WHERE IDEDITORA = COD;
			END IF;				
		END IF;
	END;
$$ LANGUAGE PLPGSQL;
UPDATE editora set IDEDITORA = 0 where ideditora = 1;
drop function cud_editora
SELECT CUD_EDITORA('CADASTRO', 7, 'CLEBER', '231', 'MOCAMBINHO', 'THE', 'PI');
SELECT CUD_EDITORA('DELETAR', 1, 'CLEBER', '231', 'MOCAMBINHO', 'THE', 'PI');
SELECT CUD_EDITORA('ALTERAR', 2, 'CLEBINHO', '124231', NULL, NULL, 'MA');
SELECT * FROM EDITORA;


drop function cadastrar_editora
SELECT CADASTRAR_EDITORA(2, 'CLEITO', 'rua 2', 'ilhotas', 'teresina', 'pi');
select * from editora;


CREATE OR REPLACE FUNCTION CADASTRAR_LEITOR(COD INT, N VARCHAR, TELEFONE INT, PESSOA_FISICA VARCHAR, RUA VARCHAR, BAIRRO VARCHAR, CIDADE VARCHAR, UF VARCHAR)
RETURNS VOID AS $$
	DECLARE
		CODIGO INT;
		CP INT;
	BEGIN
		SELECT IDLEITOR INTO CODIGO FROM LEITOR WHERE IDLEITOR = COD;
		SELECT CPF INTO CP FROM LEITOR WHERE CPF = PESSOA_FISICA;
		IF CODIGO IS NULL THEN
			IF CP IS NULL THEN
				INSERT INTO LEITOR VALUES (COD, N, TELEFONE, PESSOA_FISICA, RUA, BAIRRO, CIDADE, UF);
			ELSE
				RAISE EXCEPTION 'CPF já cadastrado';
			END IF;
		ELSE
			RAISE EXCEPTION 'Código já cadastrado';
		END IF;
	END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION CUD_LEITOR(OPERACAO VARCHAR, COD INT, N VARCHAR, TEL INT, PESSOA_FISICA VARCHAR, R VARCHAR, BA VARCHAR, CID VARCHAR, ESTADO VARCHAR)
RETURNS VOID AS $$
	DECLARE
		CODIGO INT;
		CP INT;
	BEGIN
		IF OPERACAO LIKE 'CAD%' OR OPERACAO LIKE 'INSE%' THEN 
			SELECT IDLEITOR INTO CODIGO FROM LEITOR WHERE IDLEITOR = COD;
			SELECT CPF INTO CP FROM LEITOR WHERE CPF = PESSOA_FISICA;
			IF CODIGO IS NULL THEN
				IF CP IS NULL THEN
					INSERT INTO LEITOR VALUES (COD, N, TELE, PESSOA_FISICA, R, BA, CID, ESTADO);
				ELSE
					RAISE EXCEPTION 'CPF já cadastrado';
				END IF;
			ELSE
				RAISE EXCEPTION 'Código já cadastrado';
			END IF;
		ELSIF OPERACAO LIKE 'EXC%' OR OPERACAO LIKE 'DEL%' THEN
			UPDATE EMPRESTIMO SET LEITOR_IDLEITOR = NULL WHERE LEITOR_IDLEITOR = COD;
			UPDATE RESERVA SET LEITOR_IDLEITOR = NULL WHERE LEITOR_IDLEITOR = COD;
			DELETE FROM LEITOR WHERE IDLEITOR = COD;
		ELSIF OPERACAO LIKE 'ALT%' OR OPERACAO LIKE 'MODI%' THEN
			IF N IS NOT NULL THEN
				UPDATE LEITOR SET NOME = N WHERE IDLEITOR = COD;
			END IF;
			IF BA IS NOT NULL THEN
				UPDATE LEITOR SET BAIRRO = BA WHERE IDLEITOR = COD;
			END IF;
			IF CID IS NOT NULL THEN
				UPDATE LEITOR SET CIDADE = CID WHERE IDLEITOR = COD;
			END IF;
			IF ESTADO IS NOT NULL THEN
				UPDATE LEITOR SET UF = ESTADO WHERE IDLEITOR = COD;
			END IF;
			IF TEL IS NOT NULL THEN
				UPDATE LEITOR SET TELEFONE = TEL WHERE IDLEITOR = COD;
			END IF;	
			IF R IS NOT NULL THEN
				UPDATE LEITOR SET RUA = R WHERE IDLEITOR = COD;
			END IF;	
			IF PESSOA_FISICA IS NOT NULL THEN
				UPDATE LEITOR SET CPF = PESSOA_FISICA WHERE IDLEITOR = COD;
			END IF;	
		END IF;
	END;
$$ LANGUAGE PLPGSQL;
drop function cud_leitor
SELECT CADASTRAR_LEITOR(1, 'JOAO', 33232332, '123124', 'teresina', 'DIRCEU', 'amarante', 'pi');
SELECT Cud_LEITOR('ALTERAR', 1, 'CARLOS', NULL, '141223124', '521teresina', 'D521512IRCEU', 'ama52151rante', 'ma');
select * from leitor

CREATE OR REPLACE FUNCTION CADASTRAR_FUNCIONARIO(COD INT, N VARCHAR, TELEFONE VARCHAR, PESSOA_FISICA VARCHAR, RUA VARCHAR, BAIRRO VARCHAR, CIDADE VARCHAR, UF VARCHAR)
RETURNS VOID AS $$
	DECLARE
		CODIGO INT;
		CP INT;
	BEGIN
		SELECT IDFUNCIONARIO INTO CODIGO FROM FUNCIONARIO WHERE IDFUNCIONARIO = COD;
		SELECT CPF INTO CP FROM LEITOR WHERE CPF = PESSOA_FISICA;
		IF CODIGO IS NULL THEN
			IF LENGTH(PESSOA_FISICA) = 11 THEN
				IF CP IS NULL THEN
					INSERT INTO FUNCIONARIO VALUES (COD, N, TELEFONE, PESSOA_FISICA, RUA, BAIRRO, CIDADE, UF);
				ELSE
					RAISE EXCEPTION 'CPF já cadastrado';
				END IF;
			ELSE
				RAISE EXCEPTION 'CPF incorreto';
			END IF;
		ELSE
			RAISE EXCEPTION 'Código já cadastrado';
		END IF;
	END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION CUD_FUNCIONARIO(OPERACAO VARCHAR, COD INT, N VARCHAR, TEL VARCHAR, PESSOA_FISICA VARCHAR, R VARCHAR, BA VARCHAR, CID VARCHAR, ESTADO VARCHAR)
RETURNS VOID AS $$
	DECLARE
		CODIGO INT;
		CP INT;
	BEGIN
		IF OPERACAO LIKE 'CAD%' OR OPERACAO LIKE 'INSE%' THEN 
			SELECT IDFUNCIONARIO INTO CODIGO FROM FUNCIONARIO WHERE IDFUNCIONARIO = COD;
			SELECT CPF INTO CP FROM LEITOR WHERE CPF = PESSOA_FISICA;
			IF CODIGO IS NULL THEN
				IF LENGTH(PESSOA_FISICA) = 11 THEN
					IF CP IS NULL THEN
						INSERT INTO FUNCIONARIO VALUES (COD, N, TEL, PESSOA_FISICA, R, BA, CID, ESTADO);
					ELSE
						RAISE EXCEPTION 'CPF já cadastrado';
					END IF;
				ELSE
					RAISE EXCEPTION 'CPF incorreto';
				END IF;
			ELSE
				RAISE EXCEPTION 'Código já cadastrado';
			END IF;
		ELSIF OPERACAO LIKE 'EXC%' OR OPERACAO LIKE 'DEL%' THEN
			UPDATE EMPRESTIMO SET FUNCIONARIO_IDFUNCIONARIO = NULL WHERE FUNCIONARIO_IDFUNCIONARIO = COD;
			DELETE FROM FUNCIONARIO WHERE FUNCIONARIO_IDFUNCIONARIO = COD;
		ELSIF OPERACAO LIKE 'ALT%' OR OPERACAO LIKE 'MODI%' THEN
			IF N IS NOT NULL THEN
				UPDATE FUNCIONARIO SET NOME = N WHERE IDFUNCIONARIO = COD;
			END IF;
			IF BA IS NOT NULL THEN
				UPDATE FUNCIONARIO SET BAIRRO = BA WHERE IDFUNCIONARIO = COD;
			END IF;
			IF CID IS NOT NULL THEN
				UPDATE FUNCIONARIO SET CIDADE = CID WHERE IDFUNCIONARIO = COD;
			END IF;
			IF ESTADO IS NOT NULL THEN
				UPDATE FUNCIONARIO SET UF = ESTADO WHERE IDFUNCIONARIO = COD;
			END IF;
			IF TEL IS NOT NULL THEN
				UPDATE FUNCIONARIO SET TELEFONE = TEL WHERE IDFUNCIONARIO = COD;
			END IF;	
			IF R IS NOT NULL THEN
				UPDATE FUNCIONARIO SET RUA = R WHERE IDFUNCIONARIO = COD;
			END IF;	
			IF PESSOA_FISICA IS NOT NULL THEN
				UPDATE FUNCIONARIO SET CPF = PESSOA_FISICA WHERE IDFUNCIONARIO = COD;
			END IF;	
		END IF;
	END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION CADASTRAR_TITULO(COD INT, N VARCHAR, AUTOR VARCHAR, ASSUNTO VARCHAR)
RETURNS VOID AS $$
	DECLARE
		CODIGO INT;
		NOM VARCHAR;
	BEGIN
		SELECT IDTITULO INTO CODIGO FROM TITULO WHERE IDTITULO = COD;
		SELECT NOME INTO NOM FROM TITULO WHERE NOME = N;
		IF CODIGO IS NULL THEN
			IF NOM IS NULL THEN
				INSERT INTO TITULO (IDTITULO, NOME, AUTOR, ASSUNTO) VALUES (COD, N, AUTOR, ASSUNTO);
			ELSE
				RAISE EXCEPTION 'Nome já cadastrado';
			END IF;
		ELSE
			RAISE EXCEPTION 'Código já cadastrado';
		END IF;
	END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION CUD_TITULO(COD INT, N VARCHAR, AUT VARCHAR, ASS VARCHAR)
RETURNS VOID AS $$
	DECLARE
		CODIGO INT;
		NOM VARCHAR;
	BEGIN
		IF OPERACAO LIKE 'CAD%' OR OPERACAO LIKE 'INSE%' THEN 
			SELECT IDTITULO INTO CODIGO FROM TITULO WHERE IDTITULO = COD;
			SELECT NOME INTO NOM FROM TITULO WHERE NOME = N;
			IF CODIGO IS NULL THEN
				IF NOM IS NULL THEN
					INSERT INTO TITULO (IDTITULO, NOME, AUTOR, ASSUNTO) VALUES (COD, N, AUT, ASS);
				ELSE
					RAISE EXCEPTION 'Nome já cadastrado';
				END IF;
			ELSE
				RAISE EXCEPTION 'Código já cadastrado';
			END IF;
		ELSIF OPERACAO LIKE 'EXC%' OR OPERACAO LIKE 'DEL%' THEN
			UPDATE LIVRO SET TITULO_IDTITULO = NULL WHERE TITULO_IDTITULO = COD;
			DELETE FROM TITULO WHERE IDTITULO = COD;
		ELSIF OPERACAO LIKE 'ALT%' OR OPERACAO LIKE 'MODI%' THEN
			IF N IS NOT NULL THEN
				UPDATE TITULO SET NOME = N WHERE IDTITULO = COD;
			END IF;
			IF AUT IS NOT NULL THEN
				UPDATE TITULO SET AUTOR = AUT WHERE IDTITULO = COD;
			END IF;
			IF ASS IS NOT NULL THEN
				UPDATE TITULO SET ASSUNTO = ASS WHERE IDTITULO = COD;
			END IF;
		END IF;
	END;
$$ LANGUAGE PLPGSQL;
SELECT CADASTRAR_TITULO(1, 'PORRADA', 'CARLOS', 'SANGUE');
SELECT CADASTRAR_TITULO(2, 'violencia', 'hehe', 'briga');
SELECT CADASTRAR_TITULO(3, 'DRAMA', 'ROMANFCE', 'BEIJO');

CREATE OR REPLACE FUNCTION CADASTRAR_LIVRO(COD INT, TIT INT, EDI INT, ASSUNTO VARCHAR, STATUS BOOL, AUTOR VARCHAR)
RETURNS VOID AS $$
	DECLARE
		CODIGO INT;
		TITU INT;
		EDIT INT;
	BEGIN
		SELECT IDLIVRO INTO CODIGO FROM LIVRO WHERE IDLIVRO = COD;
		SELECT IDTITULO INTO TITU FROM TITULO WHERE IDTITULO = TIT;
		SELECT IDEDITORA INTO EDIT FROM EDITORA WHERE IDEDITORA = EDI;
		IF CODIGO IS NULL THEN
			IF TITU IS NOT NULL THEN
				IF EDIT IS NOT NULL THEN
					INSERT INTO LIVRO VALUES (COD, TIT, EDI, ASSUNTO, STATUS, AUTOR);
				ELSE
					RAISE EXCEPTION 'Editora não cadastrada';
				END IF;
			ELSE
				RAISE EXCEPTION 'Titulo não cadastrado';
			END IF;
		ELSE
			RAISE EXCEPTION 'Código já cadastrado';
		END IF;
	END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION CUD_LIVRO(COD INT, TIT INT, EDI INT, ASS VARCHAR, ST BOOL, AUT VARCHAR)
RETURNS VOID AS $$
	DECLARE
		CODIGO INT;
		TITU INT;
		EDIT INT;
	BEGIN
		IF OPERACAO LIKE 'CAD%' OR OPERACAO LIKE 'INSE%' THEN 
			SELECT IDLIVRO INTO CODIGO FROM LIVRO WHERE IDLIVRO = COD;
			SELECT IDTITULO INTO TITU FROM TITULO WHERE IDTITULO = TIT;
			SELECT IDEDITORA INTO EDIT FROM EDITORA WHERE IDEDITORA = EDI;
			IF CODIGO IS NULL THEN
				IF TITU IS NOT NULL THEN
					IF EDIT IS NOT NULL THEN
						INSERT INTO LIVRO VALUES (COD, TIT, EDI, ASS, ST, AUT);
					ELSE
						RAISE EXCEPTION 'Editora não cadastrada';
					END IF;
				ELSE
					RAISE EXCEPTION 'Titulo não cadastrado';
				END IF;
			ELSE
				RAISE EXCEPTION 'Código já cadastrado';
			END IF;
		ELSIF OPERACAO LIKE 'EXC%' OR OPERACAO LIKE 'DEL%' THEN
			UPDATE ITEMEMPRESTIMO SET LIVRO_IDLIVRO = NULL WHERE LIVRO_IDLIVRO = COD;
			DELETE FROM LIVRO WHERE IDLIVRO = COD;
		ELSIF OPERACAO LIKE 'ALT%' OR OPERACAO LIKE 'MODI%' THEN
			IF AUT IS NOT NULL THEN
				UPDATE LIVRO SET AUTOR = AUT WHERE IDLIVRO = COD;
			END IF;
			IF ASS IS NOT NULL THEN
				UPDATE LIVRO SET ASSUNTO = ASS WHERE IDLIVRO = COD;
			END IF;
			IF TIT IS NOT NULL THEN
				UPDATE LIVRO SET TITULO_IDTITULO = TIT WHERE IDLIVRO = COD;
			END IF;
			IF EDI IS NOT NULL THEN
				UPDATE LIVRO SET EDITORA_IDEDITORA = EDI WHERE IDLIVRO = COD;
			END IF;
			IF ST IS NOT NULL THEN
				UPDATE LIVRO SET STATUS = ST WHERE IDLIVRO = COD;
			END IF;
		END IF;
	END;
$$ LANGUAGE PLPGSQL;
SELECT * FROM EDITORA

SELECT CADASTRAR_LIVRO(1, 1, 1, 'GUERRA', TRUE, 'JOSÉ');
SELECT CADASTRAR_LIVRO(2, 2, 1, 'PORRADA', TRUE, 'JOAO');
SELECT CADASTRAR_LIVRO(3, 2, 1, 'HMMM', FALSE, 'JOAO123');
SELECT CADASTRAR_LIVRO(4, 3, 1, 'H12321MMM', FALSE, 'JOAO123123');


select * from livro

CREATE OR REPLACE FUNCTION REALIZAR_RESERVA(COD_RES INT, COD_TIT INT, COD_LEITOR INT)
RETURNS VOID AS $$
	DECLARE
		CODIGO_TIT INT;
		CODIGO_LEITOR INT;
		COD_LIVRO INT;
		COD_RESERVA INT;
		STS_LIVRO BOOL;
	BEGIN
		SELECT RESERVA_IDRESERVA INTO COD_RESERVA FROM TITULO WHERE IDTITULO = COD_TIT;
		SELECT IDLEITOR INTO CODIGO_LEITOR FROM LEITOR WHERE IDLEITOR = COD_LEITOR;
		SELECT IDTITULO INTO COD_TIT FROM TITULO WHERE IDTITULO = COD_TIT;
		IF COD_TIT IS NOT NULL THEN
			SELECT IDLIVRO INTO COD_LIVRO FROM LIVRO WHERE TITULO_IDTITULO = COD_TIT;
			IF COD_LIVRO IS NOT NULL THEN
				SELECT STATUS_LIVRO INTO STS_LIVRO FROM LIVRO WHERE TITULO_IDTITULO = COD_TIT;
				IF STS_LIVRO IS TRUE THEN
					RAISE EXCEPTION 'Não pode reservar o livro pois ele está disponível';
				ELSE
					IF COD_RESERVA IS NULL THEN
						IF CODIGO_LEITOR IS NOT NULL THEN
							INSERT INTO RESERVA VALUES (COD_RES, COD_LEITOR, TRUE);
							UPDATE TITULO SET RESERVA_IDRESERVA = COD_RES WHERE IDTITULO = COD_TIT;
						ELSE
							RAISE EXCEPTION 'Leitor não cadastrado';
						END IF;
					ELSE
						RAISE EXCEPTION 'Titulo já está reservado';
					END IF;
				END IF;
			ELSE
				RAISE EXCEPTION 'Este titulo não possui nenhum livro associado a ele';
			END IF;
		ELSE
			RAISE EXCEPTION 'Titulo não cadastrado';
		END IF;
	END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION OPERACOES_RESERVA(OPERACAO VARCHAR, COD_RES INT, COD_TIT INT, COD_LEITOR INT)
RETURNS VOID AS $$
	DECLARE
		CODIGO_TIT INT;
		CODIGO_LEITOR INT;
		COD_LIVRO INT;
		COD_RESERVA INT;
		STS_LIVRO BOOL;
		X INT;
	BEGIN
		IF OPERACAO LIKE 'REALIZAR%' THEN
			SELECT IDTITULO INTO CODIGO_TIT FROM TITULO WHERE IDTITULO = COD_TIT;
			SELECT RESERVA_IDRESERVA INTO COD_RESERVA FROM TITULO WHERE IDTITULO = COD_TIT;
			SELECT IDLEITOR INTO CODIGO_LEITOR FROM LEITOR WHERE IDLEITOR = COD_LEITOR;
			IF CODIGO_TIT IS NOT NULL THEN
				SELECT IDLIVRO INTO COD_LIVRO FROM LIVRO WHERE TITULO_IDTITULO = COD_TIT;
				IF COD_LIVRO IS NOT NULL THEN
					SELECT STATUS_LIVRO INTO STS_LIVRO FROM LIVRO WHERE TITULO_IDTITULO = COD_TIT;
					IF STS_LIVRO IS TRUE THEN
						RAISE EXCEPTION 'Não pode reservar o livro pois ele está disponível';
					ELSE
						IF COD_RESERVA IS NULL THEN
							IF CODIGO_LEITOR IS NOT NULL THEN
								INSERT INTO RESERVA VALUES (COD_RES, COD_LEITOR, TRUE);
								UPDATE TITULO SET RESERVA_IDRESERVA = COD_RES WHERE IDTITULO = COD_TIT;
							ELSE
								RAISE EXCEPTION 'Leitor não cadastrado';
							END IF;
						ELSE
							RAISE EXCEPTION 'Titulo já está reservado';
						END IF;
					END IF;
				ELSE
					RAISE EXCEPTION 'Este titulo não possui nenhum livro associado a ele';
				END IF;
			ELSE
				RAISE EXCEPTION 'Titulo não cadastrado';
			END IF;
		ELSIF OPERACAO LIKE 'FINALIZAR%' THEN
			SELECT RESERVA_IDRESERVA INTO COD_RESERVA FROM TITULO WHERE IDTITULO = COD_RES;
			IF COD_RESERVA IS NOT NULL THEN
				SELECT IDLIVRO INTO X FROM TITULO INNER JOIN LIVRO ON TITULO_IDTITULO = IDTITULO WHERE RESERVA_IDRESERVA = COD_RES;
				UPDATE RESERVA SET STATUS_DA_RESERA = FALSE WHERE IDRESERVA = COD_RES;
				UPDATE LIVRO SET STATUS_LIVRO = FALSE WHERE TITULO_IDTITULO = COD_TIT;
			ELSE
				RAISE EXCEPTION 'Não possui nenhuma reserva com esse código';
			END IF;
		END IF;
	END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION OPERACOES_EMPRESTIMO(OPERACAO VARCHAR, COD_EMP INT, COD_FUNC INT, COD_LEITOR INT, COD_LIVRO)
RETURNS VOID AS $$
	DECLARE
		CODIGO_TIT INT;
		CODIGO_LEITOR INT;
		CODIGO_LIVRO INT;
		CODIGO_FUNC INT;
		CODIGO_EMPRESTIMO INT;
		X INT;
	BEGIN
		SELECT IDEMPRESTIMO INTO CODIGO_EMPRESTIMO FROM EMPRESTIMO WHERE IDEMPRESTIMO = COD_EMP;
		SELECT IDTITULO INTO CODIGO_TIT FROM TITULO WHERE IDTITULO = COD_TIT;
		SELECT IDFUNCIONARIO INTO CODIGO_FUNC FROM FUNCIONARIO WHERE IDFUNCIONARIO = COD_FUNC;
		SELECT IDLEITOR INTO CODIGO_LEITOR FROM LEITOR WHERE IDLEITOR = COD_LEITOR;
		SELECT IDLIVRO INTO CODIGO_LIVRO FROM LIVRO WHERE IDLIVRO = COD_LIVRO;
		IF OPERACAO LIKE 'REALIZAR%' THEN
			IF CODIGO_EMPRESTIMO IS NULL THEN
				IF CODIGO_TIT IS NOT NULL THEN
					IF CODIGO_LIVRO IS NOT NULL THEN
						SELECT STATUS_LIVRO INTO STS_LIVRO FROM LIVRO WHERE TITULO_IDTITULO = COD_TIT;
						IF STS_LIVRO IS TRUE THEN
							IF CODIGO_LEITOR IS NOT NULL THEN
								IF CODIGO_FUNCIONARIO IS NOT NULL THEN
									INSERT INTO EMPRESTIMO VALUES (COD_EMP, COD_FUNC, COD_LEITOR, CURRENT_TIME);
									INSERT INTO ITEMEMPRESTIMO(TITULO_IDTITULO, LIVRO_IDLIVRO, EMPRESTIMO_IDEMPRESTIMO, DATAEMPRESTIMO) VALUES (NULL, COD_LIVRO, COD_EMP, CURRENT_DATE);
									UPDATE LIVRO SET STATUS_LIVRO = FALSE WHERE IDLIVRO = COD_LIVRO;
								ELSE
									RAISE EXCEPTION 'Funcionário não cadastrado';
								END IF;
							ELSE 
								RAISE EXCEPTION 'Leitor não cadastrado';
							END IF;
						ELSE
							RAISE EXCEPTION 'O livro não está disponível para emprestimo';
						END IF;
					ELSE
						RAISE EXCEPTION 'Livro não cadastrado';
					END IF;
				ELSE 
					RAISE EXCEPTION 'Titulo não cadastrado';
				END IF;
			ELSE
				RAISE EXCEPTION 'Este código de emprestimo já existe';
			END IF;
		ELSIF OPERACAO LIKE 'FINALIZAR%' THEN
			IF CODIGO_EMPRESTIMO IS NOT NULL THEN
				UPDATE ITEMEMPRESTIMO SET DATADEVOLUCAO = CURRENT_DATE WHERE EMPRESTIMO_IDEMPRESTIMO = CODIGO_EMPRESTIMO;
				UPDATE LIVRO SET STATUS = TRUE WHERE IDLIVRO = COD_LIVRO;
			ELSE
				RAISE EXCEPTION 'Não possui nenhum emprestimo com esse código';
			END IF;
		ELSE
			RAISE EXCEPTION 'Operação inválida';
		END IF;
	END;
$$ LANGUAGE PLPGSQL;

select * from titulo;
select REALIZAR_RESERVA(1, 1, 1);
select REALIZAR_RESERVA(2, 2, 1);
select REALIZAR_RESERVA(3, 3, 1);
select REALIZAR_RESERVA(4, 3, 1);
select * from reserva
select * from livro;
select CADASTRAR_LIVRO(2, 2, 1)

SELECT CADASTRAR_TITULO(4, 'safasfsa', '11231231', '12312312');
SELECT CADASTRAR_LIVRO(5, 4, 1, 'H12321M231321MM', FALSE, 'JOA21312O123123');
select REALIZAR_RESERVA(5, 4, 1);



CREATE OR REPLACE FUNCTION CADASTRO_GENERICO(NOME_TABELA INT, COD INT, NOME VARCHAR, ENDERECO VARCHAR, BAIRRO VARCHAR, CIDADE VARCHAR, UF VARCHAR, CPF INT, TELEFONE INT, RUA VARCHAR, ASSUNTO VARCHAR, AUTOR VARCHAR, COD_EMP INT, COD_LEITOR INT, COD_LIVRO INT, COD_TIT INT, COD_RES INT)


