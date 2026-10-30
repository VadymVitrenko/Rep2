-- Aluno: [Nome do Aluno]
-- Numero: [Número do Aluno]
-- Turma: [Número da Turma]
-- Horário: 30/10/2026 - 10:26
-- Caso de estudo: Reservas de alojamento

-- ============================================================================
-- PREPARAÇÃO DO AMBIENTE
-- ============================================================================
USE master;
GO

-- Apaga a base de dados se ela já existir para evitar erros de execução repetida
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'DB_ReservasAlojamento')
BEGIN
    ALTER DATABASE DB_ReservasAlojamento SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DB_ReservasAlojamento;
END
GO

-- Criação da Base de Dados
CREATE DATABASE DB_ReservasAlojamento;
GO

USE DB_ReservasAlojamento;
GO


-- ============================================================================
-- QUESTÃO 1: Criação da Estrutura das Tabelas (DDL)
-- ============================================================================

CREATE TABLE Hospede (
    id_hospede INT IDENTITY(1,1),
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    nacionalidade VARCHAR(50),
    CONSTRAINT PK_Hospede PRIMARY KEY (id_hospede)
);

CREATE TABLE Alojamento (
    id_alojamento INT IDENTITY(1,1),
    nome_alojamento VARCHAR(100) NOT NULL, 
    tipo_alojamento VARCHAR(50) NOT NULL,  
    preco_noite DECIMAL(10,2) NOT NULL,
    unidade_hoteleira VARCHAR(100) NOT NULL, 
    CONSTRAINT PK_Alojamento PRIMARY KEY (id_alojamento),
    CONSTRAINT CHK_Preco CHECK (preco_noite > 0)
);

CREATE TABLE Reserva (
    id_reserva INT IDENTITY(1,1),
    id_hospede INT NOT NULL,
    id_alojamento INT NOT NULL,
    data_checkin DATE NOT NULL,
    data_checkout DATE NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    CONSTRAINT PK_Reserva PRIMARY KEY (id_reserva),
    CONSTRAINT FK_Reserva_Hospede FOREIGN KEY (id_hospede) REFERENCES Hospede(id_hospede),
    CONSTRAINT FK_Reserva_Alojamento FOREIGN KEY (id_alojamento) REFERENCES Alojamento(id_alojamento),
    CONSTRAINT CHK_Datas CHECK (data_checkout > data_checkin)
);
GO


-- ============================================================================
-- QUESTÃO 2: Povoamento Inicial (DML)
-- ============================================================================

INSERT INTO Hospede (nome, email, telefone, nacionalidade) VALUES
('João Silva', 'joao.silva@email.com', '912345678', 'Portuguesa'),
('Maria Schmidt', 'maria.s@email.de', '+49170123456', 'Alemã'),
('John Doe', 'john.doe@email.com', '+15550199', 'Americana');

INSERT INTO Alojamento (nome_alojamento, tipo_alojamento, preco_noite, unidade_hoteleira) VALUES
('Quarto 101 - Vista Mar', 'Quarto Duplo', 85.00, 'Hotel Benfica Sol'),
('Suite Presidential', 'Suite', 250.00, 'Hotel Benfica Sol'),
('Apartamento T1 Centro', 'Apartamento', 120.00, 'Lisbon Apartments Oásis');

INSERT INTO Reserva (id_hospede, id_alojamento, data_checkin, data_checkout, valor_total) VALUES
(1, 1, '2026-11-01', '2026-11-05', 340.00), 
(1, 2, '2026-12-24', '2026-12-26', 500.00), 
(2, 1, '2026-11-10', '2026-11-15', 425.00), 
(1, 1, '2026-11-20', '2026-11-22', 170.00); 
GO


-- ============================================================================
-- QUESTÃO 3: Consultas de Validação (DQL)
-- ============================================================================

-- Listagem total para validar se os dados entraram corretamente
SELECT r.id_reserva, h.nome AS Hospede, a.nome_alojamento AS Alojamento, r.data_checkin, r.data_checkout
FROM Reserva r
INNER JOIN Hospede h ON r.id_hospede = h.id_hospede
INNER JOIN Alojamento a ON r.id_alojamento = a.id_alojamento;
GO
