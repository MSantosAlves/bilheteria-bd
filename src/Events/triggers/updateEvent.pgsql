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