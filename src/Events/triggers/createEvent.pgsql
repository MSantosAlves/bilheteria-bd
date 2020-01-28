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
