CREATE TABLE Users (
	UserCPF char(11) NOT NULL,
	UserPassword varchar(6) NOT NULL,
	BirthDate DATE NOT NULL,
	CONSTRAINT UserCPF PRIMARY KEY (UserCPF)
);



CREATE TABLE Events (
	EventID char(3) NOT NULL,
	EventName varchar(20) NOT NULL,
	Class integer NOT NULL,
	Rating varchar(2) NOT NULL,
	State char(2) NOT NULL,
	City varchar(15) NOT NULL,
	UserCPF char(11) NOT NULL,
	CONSTRAINT EventID PRIMARY KEY (EventID)
);



CREATE TABLE Presentations (
	PresentationID char(4) NOT NULL,
	Date DATE NOT NULL,
	Time TIME NOT NULL,
	Price money NOT NULL,
	Room integer NOT NULL,
	Disponibilty integer NOT NULL,
	EventID char(3) NOT NULL,
	CONSTRAINT PresentationID PRIMARY KEY (PresentationID)
);



CREATE TABLE Tickets (
	TicketID char(5) NOT NULL,
	UserCPF char(11) NOT NULL,
	PresentationID char(4) NOT NULL,
	CONSTRAINT TicketID PRIMARY KEY (TicketID)
);



CREATE TABLE Cards (
	CardNumber char(16) NOT NULL,
	SecurityCod char(3) NOT NULL,
	ValidThru DATE NOT NULL,
	UserCPF char(11) NOT NULL,
	CONSTRAINT CardNumber PRIMARY KEY (CardNumber)
);




ALTER TABLE Events ADD CONSTRAINT UserCPF FOREIGN KEY (UserCPF) REFERENCES Users(UserCPF);

ALTER TABLE Presentations ADD CONSTRAINT EventID FOREIGN KEY (EventID) REFERENCES Events(EventID);

ALTER TABLE Tickets ADD CONSTRAINT UserCPF FOREIGN KEY (UserCPF) REFERENCES Users(UserCPF);
ALTER TABLE Tickets ADD CONSTRAINT PresentationID FOREIGN KEY (PresentationID) REFERENCES Presentations(PresentationID);

ALTER TABLE Cards ADD CONSTRAINT UserCPF FOREIGN KEY (UserCPF) REFERENCES Users(UserCPF);
