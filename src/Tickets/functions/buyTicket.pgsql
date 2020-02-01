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