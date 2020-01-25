CREATE OR REPLACE FUNCTION validate_event()
RETURNS TRIGGER AS $$
  DECLARE
  counter integer;
  tempChar char;
  pastChar char;
  BEGIN
  
  -- Validação de ID
  IF CHAR_LENGTH(NEW.EventID) <> 3
  THEN 
    RAISE EXCEPTION 'Event ID must have 3 digits.';
  END IF;

  -- Validação do nome do evento
  IF (NEW.EventName !~* '[a-z]')
  THEN 
    RAISE EXCEPTION 'Name must have at least one letter.';
  ELSIF (NEW.EventName ~ '(  )')
  THEN
    RAISE EXCEPTION 'Name can not have sequencial spaces.'; 
  END IF;

  counter := 1;
  WHILE counter <= CHAR_LENGTH(NEW.EventName) LOOP
    tempChar := SUBSTRING(NEW.EventName, counter, 1);
    IF (tempChar !~* '[a-z0-9]' AND tempChar !~ '( )')
    THEN
      RAISE EXCEPTION 'Name can not have special characters.'; 
    END IF;
    counter := counter + 1;
  END LOOP;
  
  -- Validação da classe do evento
  IF NEW.Class < 1 OR NEW.Class > 4
  THEN
    RAISE EXCEPTION 'Invalid event class.';
  END IF;

  -- Validação da classificação indicativa

  IF NEW.Rating !~ '(L|10|12|14|16|18)'
  THEN
    RAISE EXCEPTION 'Invalid event rating.';
  END IF;

  -- Validação do campo estado

  IF NEW.State !~ '(AC|AL|AP|AM|BA|CE|DF|ES|GO|MA|MT|MS|MG|PA|PB|PR|PE|PI|RJ|RN|
                    RS|RO|RR|SC|SP|SE|TO)'
  THEN                  
    RAISE EXCEPTION 'Invalid state.';
  END IF;


  -- Validação do campo City 
  IF (NEW.City !~* '[a-z]')
  THEN 
    RAISE EXCEPTION 'City must have at least one letter.';
  ELSIF (NEW.EventName ~ '(  )')
  THEN
    RAISE EXCEPTION 'City can not have sequencial spaces.'; 
  END IF;
  
  counter := 1;
  WHILE counter <= CHAR_LENGTH(NEW.City) LOOP
    tempChar := SUBSTRING(NEW.City, counter, 1);
    IF (tempChar !~* '[a-z0-9]' AND tempChar !~ '[., ]')
    THEN
      RAISE EXCEPTION 'Name can not have special characters.'; 
    ELSIF (tempChar = '.' AND pastChar !~* '[a-z]')
    THEN
      RAISE EXCEPTION 'End point need to be preceeded by letter.';
    END IF;
    pastChar := SUBSTRING(NEW.City, counter, 1);
    counter := counter + 1;
  END LOOP;

  RETURN NEW;
  END;
$$ LANGUAGE plpgsql;

-- CREATE TRIGGER validate_event
-- AFTER INSERT ON Events
-- FOR EACH ROW EXECUTE PROCEDURE validate_event();

-- INSERT INTO Events (EventID, EventName, Rating, Class,State, City, UserCPF) VALUES
-- ('12', 'Semana Omnistack #10', '12', 1, 'DF', 'BsB', '07143123129');

-- DELETE FROM Events;
-- SELECT * FROM Events;