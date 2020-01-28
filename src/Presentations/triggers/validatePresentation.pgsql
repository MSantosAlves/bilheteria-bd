CREATE OR REPLACE FUNCTION validatePresentation()
RETURNS TRIGGER AS $$
DECLARE
  minutes integer;
BEGIN
  -- Validação de data e hora.
  IF(NEW.Date < CURRENT_DATE) THEN
    RAISE EXCEPTION 'Invalid date.';
  END IF;

  minutes := EXTRACT(min FROM NEW.Time);
  IF(NEW.Time > '22:00:00' OR NEW.Time < '07:00:00') THEN
    RAISE EXCEPTION 'Invalid time.';
  ELSIF (minutes%15 <> 0) THEN
    RAISE EXCEPTION 'Invalid time.';
  END IF;

  -- Validação do preço
  IF(CAST(NEW.Price AS NUMERIC) < 0 OR CAST(NEW.Price AS NUMERIC) > 1000) THEN
    RAISE EXCEPTION 'Invalid price.';
  END IF;

  -- Validação da sala
  IF(NEW.Room < 1 OR NEW.Room > 10) THEN
    RAISE EXCEPTION 'Room is a number between 1 and 10.';
  END IF;
  
  -- Validação da disponibilidade
  IF (NEW.Disponibility < 0 OR NEW.Disponibility > 250) THEN
    RAISE EXCEPTION 'Disponibility is a number between 1 and 250;';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER validatePresentation
BEFORE INSERT OR UPDATE ON Presentations
FOR EACH ROW EXECUTE PROCEDURE validatePresentation();