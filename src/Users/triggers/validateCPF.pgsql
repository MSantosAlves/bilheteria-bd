CREATE OR REPLACE FUNCTION validate_cpf()
RETURNS TRIGGER AS $$
DECLARE
  userCPF varchar;
  firstDigit integer;
  secondDigit integer;
  contador integer;
  soma integer;
  resto integer;
  temp integer;
  aux integer;
  len integer;
BEGIN
  -- Atribuições 
  userCPF := NEW.UserCPF;
  len := CHAR_LENGTH(NEW.UserCPF);
  firstDigit  := CAST(SUBSTRING(userCPF,len - 1,1)AS NUMERIC);
  secondDigit := CAST(SUBSTRING(userCPF,len,1)AS NUMERIC);


  IF len <> 11 THEN
      RAISE EXCEPTION 'Invalid CPF length.';
  END IF;


  -- Validação do primeiro dígito

  contador := 1;
  soma := 0;
  aux := 10;

  WHILE contador <= (len - 2) LOOP
  temp := CAST(SUBSTRING(userCPF,contador,1)AS NUMERIC);
  soma := soma + (temp * aux);
  contador := contador + 1;
  aux := aux - 1;
  END LOOP; 

  resto := (soma*10)%11;
  
  IF (resto = 10 OR resto = 11) THEN
    resto := 0;
  END IF;

  IF(resto <> firstDigit) THEN
    RAISE EXCEPTION 'Invalid CPF.';
  END IF;

  -- Validação do segundo dígito

  contador := 1;
  soma := 0;
  aux := 11;

  WHILE contador <= (len - 1) LOOP
  temp := CAST(SUBSTRING(userCPF,contador,1)AS NUMERIC);
  soma := soma + (temp * aux);
  contador := contador + 1;
  aux := aux - 1;
  END LOOP; 

  resto := (soma*10)%11;
  
  IF (resto = 10 OR resto = 11) THEN
    resto := 0;
  END IF;

  IF(resto <> secondDigit) THEN
    RAISE EXCEPTION 'Invalid CPF.';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER validate_cpf
BEFORE INSERT ON Users
FOR EACH ROW EXECUTE PROCEDURE validate_cpf(); 
