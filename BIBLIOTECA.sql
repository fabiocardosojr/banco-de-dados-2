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
drop function cadastrar_leitor
SELECT CADASTRAR_LEITOR(1, 'JOAO', 33232332, '123124', 'teresina', 'DIRCEU', 'amarante', 'pi');
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
SELECT CADASTRAR_TITULO(1, 'PORRADA', 'CARLOS', 'SANGUE');

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

SELECT CADASTRAR_LIVRO(1, 1, 1, 'GUERRA', TRUE, 'JOSÉ');
SELECT CADASTRAR_LIVRO(2, 1, 123, 'GUERRA', TRUE, 'JOSÉ');
select * from livro

CREATE OR REPLACE FUNCTION REALIZAR_EMPRESTIMO(COD_EMP INT, COD_LIVRO INT, COD_LEITOR INT, COD_FUNC INT)
RETURNS VOID AS $$
	DECLARE
		CODIGO_LIVRO INT;
		CODIGO_LEITOR INT;
		CODIGO_FUNCIONARIO INT;
		COD_EMP_ITEM INT;
	BEGIN
		SELECT IDLIVRO INTO CODIGO_LIVRO FROM LIVRO WHERE IDLIVRO = COD_LIVRO;
		SELECT IDLEITOR INTO CODIGO_LEITOR FROM LEITOR WHERE IDLEITOR = COD_LEITOR;
		SELECT IDFUNCIONARIO INTO CODIGO_FUNCIONARIO FROM FUNCIONARIO WHERE IDFUNCIONARIO = COD_FUNC;
		IF CODIGO_LIVRO IS NOT NULL THEN
			IF CODIGO_LEITOR IS NOT NULL THEN
				IF CODIGO_FUNCIONARIO IS NOT NULL THEN
					SELECT EMPRESTIMO_IDEMPRESTIMO INTO COD_EMP_ITEM FROM ITEMEMPRESTIMO WHERE EMPRESTIMO_IDEMPRESTIMO = COD_EMP;
					IF COD_EMP_ITEM IS NULL THEN
						INSERT INTO EMPRESTIMO VALUES (COD_EMP, COD_FUNC, COD_LEITOR, CURRENT_DATE)
						INSERT INTO ITEMEMPRESTIMO (TITULO_IDTITULO, LIVRO_IDLIVRO, EMPRESTIMO_IDEMPRESTIMO, DATAEMPRESTIMO) VALUES (NULL, COD_LIVRO, COD_EMP, CURRENT_DATE);
					ELSE
						INSERT INTO ITEMEMPRESTIMO (TITULO_IDTITULO, LIVRO_IDLIVRO, EMPRESTIMO_IDEMPRESTIMO, DATAEMPRESTIMO) VALUES (NULL, COD_LIVRO, COD_EMP, CURRENT_DATE);
					END IF;
				ELSE
					RAISE EXCEPTION 'Funcionário não cadastrado';
				END IF;
			ELSE
				RAISE EXCEPTION 'Leitor não cadastrado';
			END IF;
		ELSE
			RAISE EXCEPTION 'Livro não cadastrado';
		END IF;
	END;
$$ LANGUAGE PLPGSQL;









