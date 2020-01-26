CREATE OR REPLACE FUNCTION validate_cc()
RETURNS TRIGGER AS $$
DECLARE
  tempInt integer;
  soma integer;
  counter integer;
  multiply boolean;
BEGIN
  IF (CHAR_LENGTH(NEW.CardNumber) <> 16) OR (NEW.CardNumber ~* '[a-z]') THEN
    RAISE EXCEPTION 'Card Number must have 16 digits.';
  ELSIF (CHAR_LENGTH(NEW.SecurityCod) <> 3) OR (NEW.SecurityCod ~* '[a-z]') THEN
    RAISE EXCEPTION 'Security code must have 3 digits.';
  ELSIF NEW.ValidThru <= CURRENT_DATE THEN
    RAISE EXCEPTION  'Expired card.';
  END IF;
    
  -- Luhn algorithm (verifica se o número do cartão informado é válido)
  counter := CHAR_LENGTH(NEW.CardNumber);
  soma := 0;
  multiply := FALSE;
    
  WHILE counter >= 1 LOOP
    tempInt := CAST(SUBSTRING(NEW.CardNumber, counter, 1)AS NUMERIC);
    IF(multiply) THEN
      tempInt := tempInt * 2;
    END IF;

    IF (tempInt = 10) THEN
      tempInt := 1;
    ELSIF (tempInt > 10) THEN
      tempInt := tempInt - 9;     --tempInt - 9 = soma dos dígitos de tempInt 
    END IF;
      
    soma := soma + tempInt;
    counter := counter - 1;
    multiply :=  NOT multiply;
  END LOOP; 
    
  IF ((soma%10) <> 0)
  THEN
    RAISE EXCEPTION 'Invalid Card Number.';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER validate_cc
BEFORE INSERT OR UPDATE ON Cards
FOR EACH ROW EXECUTE PROCEDURE validate_cc();
