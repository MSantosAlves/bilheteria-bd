CREATE OR REPLACE FUNCTION create_presentation(_userCPF char(11), _userPassword char(6),
                  _eventID integer, _date date, _time time, _price money,_room integer)
RETURNS text AS $$
DECLARE
  rec_user RECORD;
  rec_event RECORD;
BEGIN

  SELECT UserCPF INTO rec_user FROM Users 
  WHERE 
  UserCPF = _userCPF AND UserPassword = md5(_userPassword);
	
  IF rec_user IS NULL THEN
    RAISE EXCEPTION 'User authentication failed.';
  END IF;

  SELECT * INTO rec_event FROM Events
  WHERE EventID = _eventID AND UserCPF = _userCPF;

  IF rec_event IS NULL THEN
    RAISE EXCEPTION 'Invalid event ID';
  END IF;

  INSERT INTO Presentations(Date, Time,Price, Room, EventID) 
  VALUES (_date, _time, _price, _room, _eventID);
  RETURN 'Presentations successfully created.';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_presentation(_userCPF char(11), _userPassword char(6),
                      _eventID integer, _presentationID integer, _date date, _time time,
                      _price money,_room integer)
RETURNS text AS $$
DECLARE
  rec_user RECORD;
  rec_event RECORD;
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
    Time = CASE
      WHEN _time IS NULL THEN Time
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