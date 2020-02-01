-- Script de criação do banco

-- Definição da estrutura das tabelas

CREATE TABLE Users (
	UserCPF char(11) NOT NULL,
	UserPassword char(32) NOT NULL,
	BirthDate DATE NOT NULL,
	CONSTRAINT UserCPF PRIMARY KEY (UserCPF)
);

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


CREATE SEQUENCE seq_TicketID START WITH 10000;
CREATE TABLE Tickets (
	TicketID integer NOT NULL DEFAULT nextval('seq_TicketID'),
	UserCPF char(11) NOT NULL,
	PresentationID integer NOT NULL,
	CONSTRAINT TicketID PRIMARY KEY (TicketID)
);

CREATE TABLE Cards (
	CardNumber char(16) NOT NULL,
	SecurityCod char(3) NOT NULL,
	ValidThru DATE NOT NULL,
	UserCPF char(11) NOT NULL,
	CONSTRAINT CardNumber PRIMARY KEY (CardNumber)
);

-- Adicionando as constraints

ALTER TABLE Events ADD CONSTRAINT UserCPF FOREIGN KEY (UserCPF) REFERENCES Users(UserCPF);

ALTER TABLE Presentations ADD CONSTRAINT EventID FOREIGN KEY (EventID) REFERENCES Events(EventID) ON DELETE CASCADE;

ALTER TABLE Tickets ADD CONSTRAINT UserCPF FOREIGN KEY (UserCPF) REFERENCES Users(UserCPF);
ALTER TABLE Tickets ADD CONSTRAINT PresentationID FOREIGN KEY (PresentationID) REFERENCES Presentations(PresentationID);

ALTER TABLE Cards ADD CONSTRAINT UserCPF FOREIGN KEY (UserCPF) REFERENCES Users(UserCPF) ON DELETE CASCADE;

-- Definindo as trigger functions

CREATE OR REPLACE FUNCTION validate_cpf()
RETURNS TRIGGER AS $$
DECLARE
  userCPF varchar;
  firstDigit integer;
  secondDigit integer;
  contador integer;
  soma integer;
  resto integer;
  temp integer;
  aux integer;
  len integer;
BEGIN
  userCPF := NEW.UserCPF;
  len := CHAR_LENGTH(NEW.UserCPF);
  firstDigit  := CAST(SUBSTRING(userCPF,len - 1,1)AS NUMERIC);
  secondDigit := CAST(SUBSTRING(userCPF,len,1)AS NUMERIC);

  IF len <> 11 THEN
      RAISE EXCEPTION 'Invalid CPF length.';
  END IF;

  contador := 1;
  soma := 0;
  aux := 10;

  WHILE contador <= (len - 2) LOOP
  temp := CAST(SUBSTRING(userCPF,contador,1)AS NUMERIC);
  soma := soma + (temp * aux);
  contador := contador + 1;
  aux := aux - 1;
  END LOOP; 

  resto := (soma*10)%11;
  
  IF (resto = 10 OR resto = 11) THEN
    resto := 0;
  END IF;

  IF(resto <> firstDigit) THEN
    RAISE EXCEPTION 'Invalid CPF.';
  END IF;

  contador := 1;
  soma := 0;
  aux := 11;

  WHILE contador <= (len - 1) LOOP
  temp := CAST(SUBSTRING(userCPF,contador,1)AS NUMERIC);
  soma := soma + (temp * aux);
  contador := contador + 1;
  aux := aux - 1;
  END LOOP; 

  resto := (soma*10)%11;
  
  IF (resto = 10 OR resto = 11) THEN
    resto := 0;
  END IF;

  IF(resto <> secondDigit) THEN
    RAISE EXCEPTION 'Invalid CPF.';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER validate_cpf
BEFORE INSERT ON Users
FOR EACH ROW EXECUTE PROCEDURE validate_cpf(); 

CREATE OR REPLACE FUNCTION validate_password()
RETURNS TRIGGER AS $$
DECLARE
  len integer;
  password varchar;
  counter integer;
  tempChar char;
  BEGIN
  password := NEW.UserPassword;
  len := CHAR_LENGTH(password);
  counter := 1;
  IF( len <> 6 ) THEN 
    RAISE EXCEPTION 'Password must have 6 characters.';
  END IF;

  IF (password = UPPER(password) OR password = LOWER(password)) THEN 
    RAISE EXCEPTION 'Password must have at least one uppercase and one lowercase character.';
  END IF;

  IF password !~ '[0-9]' THEN 
    RAISE EXCEPTION 'Password must have at least one digit.';
  END IF;
  
  WHILE counter <= len LOOP
    tempChar := SUBSTRING(password, counter, 1);
    IF tempChar !~* '[0-9a-z]'  THEN
      RAISE EXCEPTION 'Password can not have special characters.'; 
    END IF;
    counter := counter + 1;
  END LOOP;
  NEW.UserPassword := md5(password);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER validate_password
BEFORE INSERT OR UPDATE ON Users
FOR EACH ROW EXECUTE PROCEDURE validate_password();

CREATE OR REPLACE FUNCTION validateBirthDate()
RETURNS TRIGGER AS $$
BEGIN
  IF(NEW.BirthDate < '1900-01-01' OR NEW.BirthDate > CURRENT_DATE) THEN
    RAISE EXCEPTION 'Invalid birth date.';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER validateBirthDate
BEFORE INSERT OR UPDATE ON Users
FOR EACH ROW EXECUTE PROCEDURE validateBirthDate();

CREATE OR REPLACE FUNCTION deleteUser()
RETURNS TRIGGER AS $$
DECLARE
  events Events%rowtype;
  tickets Tickets%rowtype;
BEGIN
  FOR events IN 
    SELECT * FROM Events 
  LOOP
    IF events.UserCPF = OLD.UserCPF THEN
      RAISE EXCEPTION 'User with registered events.';
    END IF;
  END LOOP;

  FOR tickets IN 
    SELECT * FROM Tickets 
  LOOP
    IF tickets.UserCPF = OLD.UserCPF THEN
      RAISE EXCEPTION 'User have registered tickets.';
    END IF;
  END LOOP;

  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER deleteUser
BEFORE DELETE ON Users
FOR EACH ROW EXECUTE PROCEDURE deleteUser();

CREATE OR REPLACE FUNCTION validate_cc()
RETURNS TRIGGER AS $$
DECLARE
  tempInt integer;
  soma integer;
  counter integer;
  multiply boolean;
BEGIN
  IF (CHAR_LENGTH(NEW.CardNumber) <> 16) OR (NEW.CardNumber ~* '[a-z]') THEN
    RAISE EXCEPTION 'Card Number must have 16 digits.';
  ELSIF (CHAR_LENGTH(NEW.SecurityCod) <> 3) OR (NEW.SecurityCod ~* '[a-z]') THEN
    RAISE EXCEPTION 'Security code must have 3 digits.';
  ELSIF NEW.ValidThru <= CURRENT_DATE THEN
    RAISE EXCEPTION  'Expired card.';
  END IF;
  counter := CHAR_LENGTH(NEW.CardNumber);
  soma := 0;
  multiply := FALSE;
    
  WHILE counter >= 1 LOOP
    tempInt := CAST(SUBSTRING(NEW.CardNumber, counter, 1)AS NUMERIC);
    IF(multiply) THEN
      tempInt := tempInt * 2;
    END IF;

    IF (tempInt = 10) THEN
      tempInt := 1;
    ELSIF (tempInt > 10) THEN
      tempInt := tempInt - 9;     
    END IF;
      
    soma := soma + tempInt;
    counter := counter - 1;
    multiply :=  NOT multiply;
  END LOOP; 
    
  IF ((soma%10) <> 0)
  THEN
    RAISE EXCEPTION 'Invalid Card Number.';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER validate_cc
BEFORE INSERT OR UPDATE ON Cards
FOR EACH ROW EXECUTE PROCEDURE validate_cc();

CREATE OR REPLACE FUNCTION create_event()
RETURNS TRIGGER AS $$
DECLARE
  reg_events RECORD;
BEGIN

  SELECT COUNT(UserCPF) AS nb INTO reg_events FROM Events
  WHERE UserCPF = NEW.UserCPF; 

  IF(reg_events.nb = 5) THEN 
    RAISE EXCEPTION 'User already has 5 registered events';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER create_event
BEFORE INSERT ON Events
FOR EACH ROW EXECUTE PROCEDURE create_event();

CREATE OR REPLACE FUNCTION update_event()
RETURNS TRIGGER AS $$
DECLARE
  rec_invalid_events RECORD;
BEGIN
  
  SELECT * INTO rec_invalid_events FROM Events E 
  INNER JOIN 
  Presentations P ON P.EventID = OLD.EventID AND P.Disponibility < 250;

  IF rec_invalid_events IS NOT NULL THEN 
    RAISE EXCEPTION 'Can not edit events that already sold presentation tickets.';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_event
BEFORE UPDATE ON Events
FOR EACH ROW EXECUTE PROCEDURE update_event();

CREATE OR REPLACE FUNCTION validate_event()
RETURNS TRIGGER AS $$
DECLARE
  counter integer;
  tempChar char;
  pastChar char;
BEGIN
  IF (NEW.EventName !~* '[a-z]') THEN 
    RAISE EXCEPTION 'Name must have at least one letter.';
  ELSIF (NEW.EventName ~ '(  )') THEN
    RAISE EXCEPTION 'Name can not have sequencial spaces.'; 
  END IF;

  counter := 1;
  WHILE counter <= CHAR_LENGTH(NEW.EventName) LOOP
    tempChar := SUBSTRING(NEW.EventName, counter, 1);
    IF (tempChar !~* '[a-z0-9]' AND tempChar !~ '( )') THEN
      RAISE EXCEPTION 'Name can not have special characters.'; 
    END IF;
    counter := counter + 1;
  END LOOP;
  
  IF NEW.Class < 1 OR NEW.Class > 4 THEN
    RAISE EXCEPTION 'Invalid event class.';
  END IF;

  IF NEW.Rating !~ '(L|10|12|14|16|18)' THEN
    RAISE EXCEPTION 'Invalid event rating.';
  END IF;

  IF NEW.State !~ '(AC|AL|AP|AM|BA|CE|DF|ES|GO|MA|MT|MS|MG|PA|PB|PR|PE|PI|RJ|RN|
                    RS|RO|RR|SC|SP|SE|TO)' THEN                  
    RAISE EXCEPTION 'Invalid state.';
  END IF;

  IF (NEW.City !~* '[a-z]') THEN 
    RAISE EXCEPTION 'City must have at least one letter.';
  ELSIF (NEW.City ~ '(  )') THEN
    RAISE EXCEPTION 'City can not have sequencial spaces.'; 
  END IF;
  
  counter := 1;
  WHILE counter <= CHAR_LENGTH(NEW.City) LOOP
    tempChar := SUBSTRING(NEW.City, counter, 1);
    IF (tempChar !~* '[a-z0-9]' AND tempChar !~ '[., ]') THEN
      RAISE EXCEPTION 'City can not have special characters.'; 
    ELSIF (tempChar = '.' AND pastChar !~* '[a-z]') THEN
      RAISE EXCEPTION 'End point need to be preceeded by letter.';
    END IF;
    pastChar := SUBSTRING(NEW.City, counter, 1);
    counter := counter + 1;
  END LOOP;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER validate_event
BEFORE INSERT OR UPDATE ON Events
FOR EACH ROW EXECUTE PROCEDURE validate_event();

CREATE OR REPLACE FUNCTION create_presentation()
RETURNS TRIGGER AS $$
DECLARE
  rec_presentations RECORD;
BEGIN
  SELECT COUNT (EventID) as nb INTO rec_presentations FROM Presentations P
  WHERE EventID = NEW.EventID;

  IF rec_presentations.nb = 10 THEN
    RAISE EXCEPTION 'Events can have a maximum of 10 presentations registered.';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER create_presentations
BEFORE INSERT ON Presentations
FOR EACH ROW EXECUTE PROCEDURE create_presentation();

CREATE OR REPLACE FUNCTION validatePresentation()
RETURNS TRIGGER AS $$
DECLARE
  minutes integer;
BEGIN
  IF(NEW.Date < CURRENT_DATE) THEN
    RAISE EXCEPTION 'Invalid date.';
  END IF;

  minutes := EXTRACT(min FROM NEW.PresentationTime);
  IF(NEW.PresentationTime > '22:00:00' OR NEW.PresentationTime < '07:00:00') THEN
    RAISE EXCEPTION 'Invalid time.';
  ELSIF (minutes%15 <> 0) THEN
    RAISE EXCEPTION 'Invalid time.';
  END IF;

  IF(CAST(NEW.Price AS NUMERIC) < 0 OR CAST(NEW.Price AS NUMERIC) > 1000) THEN
    RAISE EXCEPTION 'Invalid price.';
  END IF;

  IF(NEW.Room < 1 OR NEW.Room > 10) THEN
    RAISE EXCEPTION 'Room is a number between 1 and 10.';
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER validatePresentation
BEFORE INSERT OR UPDATE ON Presentations
FOR EACH ROW EXECUTE PROCEDURE validatePresentation();

CREATE OR REPLACE FUNCTION create_ticket()
RETURNS TRIGGER AS $$
DECLARE
  rec_user RECORD;
  rec_presentation RECORD;
  rec_event RECORD;
  userAge integer;
  rating integer;
BEGIN
  SELECT * INTO rec_user FROM Users
  WHERE UserCPF = NEW.UserCPF;

  userAge := CAST(date_part('year', age(rec_user.BirthDate)) AS INTEGER);

  SELECT * INTO rec_presentation FROM Presentations 
  WHERE PresentationID = NEW.PresentationID;

  IF rec_presentation IS NULL THEN
    RAISE NOTICE 'Invalid presentation ID.';
  END IF;

  SELECT * INTO rec_event FROM Events
  WHERE EventID = rec_presentation.EventID;

  IF rec_event.Rating <> 'L' AND userAge < rec_event.Rating::integer THEN
    RAISE EXCEPTION 'User is not old enough to buy tickets for this presentation.';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;                                                      

CREATE TRIGGER create_ticket
BEFORE INSERT ON Tickets
FOR EACH ROW EXECUTE PROCEDURE create_ticket();

-- Definição das functions

CREATE OR REPLACE FUNCTION create_user(_userCPF char(11), _userPassword char(6), 
                                          _birthDate date, _cardNumber char(16), 
                                          _securityCod char(3), _validThru date)
RETURNS text AS $$
BEGIN
  INSERT INTO Users(UserCPF, UserPassword, BirthDate) VALUES
  (_userCPF, _userPassword, _birthDate);
  INSERT INTO Cards(CardNumber, SecurityCod, ValidThru, UserCPF) VALUES
  (_cardNumber, _securityCod, _validThru, _userCPF);
  RETURN 'User successfully created.';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_user(_userCPF char(11), _userPassword char(6), 
    _newPassword char(6), _birthDate date, _cardNumber char(16), _securityCod char(3),
    _validThru date)
RETURNS text AS $$
DECLARE
  rec_user RECORD;
BEGIN
  SELECT UserCPF INTO rec_user FROM Users 
  WHERE 
  UserCPF = _userCPF AND UserPassword = md5(_userPassword);
	
  IF rec_user.UserCPF IS NULL THEN
    RAISE EXCEPTION 'User authentication failed.';
  END IF;

  UPDATE Users
    SET
    UserPassword = CASE
      WHEN _newPassword = ''  THEN _userPassword
      ELSE _newPassword
      END,
    BirthDate = CASE
      WHEN _birthDate IS NULL THEN BirthDate
      ELSE _birthDate
      END
  WHERE UserCPF = _userCPF;

  UPDATE Cards
    SET
    CardNumber = CASE
      WHEN _cardNumber = '' THEN CardNumber
      ELSE _cardNumber
    END,
    SecurityCod = CASE
      WHEN _securityCod = '' THEN SecurityCod
      ELSE _securityCod
    END,
    ValidThru = CASE
      WHEN _validThru IS NULL THEN ValidThru
      ELSE _validThru
    END
  WHERE UserCPF = _userCPF;

  RETURN 'User successfully updated.';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION delete_user(_userCPF char(11), _userPassword char(6))  
RETURNS text AS $$
DECLARE
  rec_user RECORD;
BEGIN
  SELECT UserCPF INTO rec_user FROM Users 
  WHERE 
  UserCPF = _userCPF AND UserPassword = md5(_userPassword);
	
  IF rec_user.UserCPF IS NULL THEN
    RAISE EXCEPTION 'User authentication failed.';
  END IF;

  DELETE FROM Users WHERE UserCPF = _userCPF;
  RETURN 'User successfully deleted.';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION create_event(_userCPF char(11), _userPassword char(6),
                         _eventName varchar(20), _class integer, _rating char(2),
                         _state char(2), _city varchar(15))
RETURNS text AS $$
DECLARE
  rec_user RECORD;
BEGIN
  SELECT * INTO rec_user FROM Users 
  WHERE 
  UserCPF = _userCPF AND UserPassword = md5(_userPassword);
	
  IF rec_user IS NULL THEN
    RAISE EXCEPTION 'User authentication failed.';
  END IF;

  INSERT INTO Events(EventName, Class, Rating, State, City, UserCPF) 
  VALUES
    (_eventName, _class, _rating, _state, _city, _userCPF);
  
  RETURN 'Event successfully created.';
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION show_event(_initDate date, _endDate date, _city varchar(20), _state char(2))
RETURNS TABLE("Evento" varchar,
              "Número da apresentação" integer,
              "Data" date,
			        "Horário" time,
              "Preço" money,
              "Sala" integer,
              "Ingressos disponíveis" integer,
              "Classe" integer,
              "Classificação indicativa" varchar
              )AS $$
BEGIN
  RETURN QUERY
  SELECT E.EventName, P.PresentationID, P.Date, P.PresentationTime, P.Price, 
  P.Room, P.Disponibility, E.Class, E.Rating
  FROM Events E INNER JOIN Presentations P ON E.EventID = P.EventID AND E.State = _state AND E.City = _city
  WHERE P.Date BETWEEN _initDate AND _endDate;
END;
$$ LANGUAGE plpgsql;  


CREATE OR REPLACE FUNCTION events_control(_userCPF char(11), _userPassword char(6), _eventID integer)
RETURNS TABLE (
               "Número da apresentação" integer,
               "Ingressos vendidos" integer
              )AS $$
BEGIN
  RETURN QUERY
  SELECT P.PresentationID, 250 - P.Disponibility 
  FROM Presentations P
  WHERE P.EventID = _eventID
  GROUP BY P.PresentationID;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION update_event(_userCPF char(11), _userPassword char(6),
       _eventID integer, _eventName varchar(20), _class integer, _rating char(2),
                         _state char(2), _city varchar(15))
RETURNS text AS $$
DECLARE
  rec_user RECORD;
  rec_event RECORD;
BEGIN
  SELECT * INTO rec_user FROM Users 
  WHERE 
  UserCPF = _userCPF AND UserPassword = md5(_userPassword);
	
  IF rec_user IS NULL THEN
    RAISE EXCEPTION 'User authentication failed.';
  END IF;

  SELECT * INTO rec_event FROM Events 
  WHERE 
  EventID = _eventID;

  IF rec_event IS NULL THEN
    RAISE EXCEPTION 'Invalid event ID.';
  END IF;

  UPDATE Events
    SET 
	EventName = CASE
      WHEN _eventName = '' THEN EventName
      ELSE _eventName
    END,
    Class = _class, 
    Rating = CASE
      WHEN _rating = '' THEN Rating
      ELSE _rating
    END,  
    State = CASE
      WHEN _state = '' THEN State
      ELSE _state
    END,    
    City = CASE
      WHEN _city = '' THEN City
      ELSE _city
    END  
  WHERE EventID = _eventID;

  RETURN 'Event successfully edited.';
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION delete_event(_userCPF char(11), _userPassword char(6), _eventID integer)
RETURNS text AS $$
DECLARE
  rec_user RECORD;
BEGIN
  SELECT * INTO rec_user FROM Users 
  WHERE 
  UserCPF = _userCPF AND UserPassword = md5(_userPassword);
	
  IF rec_user IS NULL THEN
    RAISE EXCEPTION 'User authentication failed.';
  END IF;

  DELETE FROM Events WHERE EventID = _eventID;

  RETURN 'Event successfully deleted.';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION create_presentation(_userCPF char(11), _userPassword char(6),
                  _eventID integer, _date date, _time time, _price money,_room integer)
RETURNS text AS $$
DECLARE
  rec_user RECORD;
  rec_event RECORD;
BEGIN

  SELECT * INTO rec_user FROM Users 
  WHERE 
  UserCPF = _userCPF AND UserPassword = md5(_userPassword);
	
  IF rec_user IS NULL THEN
    RAISE EXCEPTION 'User authentication failed.';
  END IF;

  SELECT * INTO rec_event FROM Events
  WHERE EventID = _eventID AND UserCPF = _userCPF;

  IF rec_event IS NULL THEN
    RAISE EXCEPTION 'Invalid event ID.';
  END IF;

  INSERT INTO Presentations(Date, PresentationTime,Price, Room, EventID) 
  VALUES (_date, _time, _price, _room, _eventID);
  RETURN 'Presentation successfully created.';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_presentation(_userCPF char(11), _userPassword char(6),
                      _eventID integer, _presentationID integer, _date date, _time time,
                      _price money,_room integer)
RETURNS text AS $$
DECLARE
  rec_user RECORD;
  rec_presentation RECORD;
BEGIN
  SELECT UserCPF INTO rec_user FROM Users 
  WHERE 
  UserCPF = _userCPF AND UserPassword = md5(_userPassword);
	
  IF rec_user IS NULL THEN
    RAISE EXCEPTION 'User authentication failed.';
  END IF;

  SELECT * INTO rec_presentation FROM Presentations P
  WHERE P.PresentationID = _presentationID AND P.EventID = _eventID;

  IF rec_presentation IS NULL THEN
    RAISE EXCEPTION 'Presentation and event does not match.';
  END IF;

  UPDATE Presentations
    SET
    Date = CASE
      WHEN _date IS NULL THEN Date
      ELSE _date
    END,
    PresentationTime = CASE
      WHEN _time IS NULL THEN PresentationTime
      ELSE _time
    END,
    Price = CASE
      WHEN _price = '' THEN Price
      ELSE _price
    END,
    Room = _room
  WHERE PresentationID = _presentationID ;

  RETURN 'Presentation successfully edited.';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION delete_presentation(_userCPF char(11), _userPassword char(6),
                  _eventID integer, _presentationID integer)
RETURNS text AS $$
DECLARE
  rec_user RECORD;
  rec_presentation RECORD;
BEGIN
  SELECT UserCPF INTO rec_user FROM Users 
  WHERE 
  UserCPF = _userCPF AND UserPassword = md5(_userPassword);
	
  IF rec_user IS NULL THEN
    RAISE EXCEPTION 'User authentication failed.';
  END IF;

  SELECT * INTO rec_presentation FROM Presentations P
  WHERE P.PresentationID = _presentationID AND P.EventID = _eventID;

  IF rec_presentation IS NULL THEN
    RAISE EXCEPTION 'Presentation and event does not match.';
  END IF;

  DELETE FROM Presentations P
  WHERE P.PresentationID = _presentationID AND P.EventID = _eventID;

  RETURN 'Presentation successfully deleted.';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION buyTicket(_userCPF char(11), _userPassword char(6), 
                                    _presentationID integer, _quantity integer)
RETURNS text AS $$
DECLARE
  rec_user RECORD;
  rec_presentation RECORD;
  counter integer := 0;
BEGIN
  SELECT * INTO rec_user FROM Users 
  WHERE 
  UserCPF = _userCPF AND UserPassword = md5(_userPassword);
	
  IF rec_user IS NULL THEN
    RAISE EXCEPTION 'User authentication failed.';
  END IF;

  SELECT * INTO rec_presentation FROM Presentations
  WHERE
  PresentationID = _presentationID;

  IF rec_presentation.Disponibility < _quantity THEN
    RAISE EXCEPTION 'Unsuficient tickets.';
  END IF;

  WHILE counter < _quantity LOOP
  INSERT INTO Tickets (UserCPF, PresentationID)
  VALUES (_userCPF, _presentationID);
  counter := counter + 1;
  END LOOP;

  UPDATE Presentations
  SET
    Disponibility = Disponibility - _quantity
  WHERE PresentationID = _presentationID;

  RETURN 'Ticked purchased.';
END;
$$ LANGUAGE plpgsql;                                                                                                            

-- VIEWS
CREATE VIEW users_view AS SELECT U.UserCPF AS "CPF", U.BirthDate AS "Data de nascimento", C.CardNumber "Número do cartão"
FROM Users U
INNER JOIN Cards C ON C.UserCPF = U.UserCPF;