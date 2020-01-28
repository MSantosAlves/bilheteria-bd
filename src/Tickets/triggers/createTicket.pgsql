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