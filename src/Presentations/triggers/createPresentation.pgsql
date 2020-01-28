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