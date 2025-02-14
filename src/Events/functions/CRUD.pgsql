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

   /*
   Não é necessário verificar se já foram vendidos igressos da apresentação pois
   isso violaria a integridade referencial da tabela tickets (o próprio postgres verifica)
   */
  
  DELETE FROM Events WHERE EventID = _eventID;

  RETURN 'Event successfully deleted.';
END;
$$ LANGUAGE plpgsql;
