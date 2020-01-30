--
-- Estrutura da tabela Users
--

CREATE TABLE Users (
	UserCPF char(11) NOT NULL,
	UserPassword char(32) NOT NULL,
	BirthDate DATE NOT NULL,
	CONSTRAINT UserCPF PRIMARY KEY (UserCPF)
);

--
-- Inserindo dados na tabela Users
--

--
-- Esrutura da tabela Events
--
CREATE SEQUENCE seq_eventID START WITH 100;
CREATE TABLE Events (
	EventID integer NOT NULL DEFAULT nextval('seq_eventID'),
	EventName varchar(20) NOT NULL,
	Class integer NOT NULL,
	Rating varchar(2) NOT NULL,
	State char(2) NOT NULL,
	City varchar(15) NOT NULL,
	UserCPF char(11) NOT NULL,
	CONSTRAINT EventID PRIMARY KEY (EventID)
);

--
-- Inserindo dados na tabela Events
--

--
-- Estrutura da tabela Presentations
--
CREATE SEQUENCE seq_PresentationID START WITH 1000;
CREATE TABLE Presentations (
	PresentationID integer NOT NULL DEFAULT nextval('seq_PresentationID'),
	Date DATE NOT NULL,
	PresentationTime TIME NOT NULL,
	Price money NOT NULL,
	Room integer NOT NULL,
	Disponibility integer DEFAULT 250,
	EventID integer NOT NULL,
	CONSTRAINT PresentationID PRIMARY KEY (PresentationID)
);

--
-- Inserindo dados na tabela Presentations
--

--
-- Estrutura da tabela Tickets
--
CREATE SEQUENCE seq_TicketID START WITH 10000;
CREATE TABLE Tickets (
	TicketID integer NOT NULL DEFAULT nextval('seq_TicketID'),
	UserCPF char(11) NOT NULL,
	PresentationID integer NOT NULL,
	CONSTRAINT TicketID PRIMARY KEY (TicketID)
);

--
-- Inserindo dados na tabela Tickets
--

--
-- Estrutura da tabela Cards
--

CREATE TABLE Cards (
	CardNumber char(16) NOT NULL,
	SecurityCod char(3) NOT NULL,
	ValidThru DATE NOT NULL,
	UserCPF char(11) NOT NULL,
	CONSTRAINT CardNumber PRIMARY KEY (CardNumber)
);

--
-- Inserindo dados na tabela Cards
--


--
-- Adicionando CONSTRAINTS
--

ALTER TABLE Events ADD CONSTRAINT UserCPF FOREIGN KEY (UserCPF) REFERENCES Users(UserCPF);

ALTER TABLE Presentations ADD CONSTRAINT EventID FOREIGN KEY (EventID) REFERENCES Events(EventID) ON DELETE CASCADE;

ALTER TABLE Tickets ADD CONSTRAINT UserCPF FOREIGN KEY (UserCPF) REFERENCES Users(UserCPF);
ALTER TABLE Tickets ADD CONSTRAINT PresentationID FOREIGN KEY (PresentationID) REFERENCES Presentations(PresentationID);

ALTER TABLE Cards ADD CONSTRAINT UserCPF FOREIGN KEY (UserCPF) REFERENCES Users(UserCPF) ON DELETE CASCADE;
