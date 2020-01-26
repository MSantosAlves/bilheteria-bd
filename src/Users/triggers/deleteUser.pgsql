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