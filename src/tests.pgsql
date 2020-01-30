INSERT INTO Users(UserCPF, UserPassword, BirthDate) VALUES
('07143123129', 'Mathe1', '2000-07-09');

INSERT INTO Cards(CardNumber, SecurityCod, ValidThru, UserCPF) VALUES
('4010000000000000', '123', '2020-09-09', '07143123129');

INSERT INTO Events(EventName, Class, Rating, State, City, UserCPF) VALUES
('Semana Omnistack 10', 1, 'L', 'SP', 'Av. Paulista', '07143123129');

INSERT INTO Presentations(Date, PresentationTime,Price, Room, EventID) VALUES
('2020-08-08', '20:30:00', '50.00', 3, );

INSERT INTO Tickets(UserCPF, PresentationID) VALUES
('07143123129', );

SELECT * FROM create_user('07143123129', 'Mathe1', '2000-07-09', '4010000000000000', '123', '2025-05-05');
SELECT * FROM delete_user('07143123129', 'Mathe1');

SELECT * FROM Users;
SELECT * FROM Events;
SELECT * FROM Presentations;

SELECT * FROM create_user('68377258404', 'Mathe1', '1968-05-22', '0010400000000000','222' ,'2027-05-05');

SELECT * FROM create_event('68377258404', 'Mathe1', 'The Witcher', 1, '18', 'SP', 'Av. Paulista');
SELECT * FROM create_event('68377258404', 'Mathe1', 'The Witcher', 1, '18', 'DF', 'Asa Norte');

SELECT * FROM create_event('07143123129', 'Mathe1', 'Semana OmniStack', 1, 'L', 'SP', 'Av. Paulista');
SELECT * FROM create_event('07143123129', 'Mathe1', 'Semana OmniStack', 1, 'L', 'DF', 'Asa Norte');


SELECT * FROM create_presentation('07143123129', 'Mathe1', 103, '2020-02-01', '21:45:00', '100.00', 3);


SELECT * FROM Tickets;
SELECT * FROM Presentations;
SELECT * FROM Events;
SELECT * FROM Cards;
SELECT * FROM Users;

DELETE FROM Tickets;
DELETE FROM Presentations;
DELETE FROM Events;
DELETE FROM Cards;
DELETE FROM Users;