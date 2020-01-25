-- VALIDAÇÃO DE CPF

CREATE OR REPLACE FUNCTION valida_cpf()
RETURNS TRIGGER AS $$
DECLARE
  firstDigit integer;
  secondDigit integer;
  contador integer;
  soma integer;
  resto integer;
  temp integer;
  aux integer;
  len integer;
BEGIN
  len := CHAR_LENGTH(NEW.UserCPF);

  IF len <> 11
    THEN
      RAISE EXCEPTION 'Invalid CPF length.';
  END IF;

  firstDigit  := CAST(SUBSTRING(NEW.UserCPF,10,1)AS NUMERIC);
  secondDigit := CAST(SUBSTRING(NEW.UserCPF,11,1)AS NUMERIC);

-- Validação do primeiro dígito

  contador := 1;
  soma := 0;
  aux := 10;

  WHILE contador <= 9 LOOP
  temp := CAST(SUBSTRING(NEW.UserCPF,contador,1)AS NUMERIC);
  soma := soma + (temp * aux);
  contador := contador + 1;
  aux := aux - 1;
  END LOOP; 

  resto := (soma*10)%11;
  
  IF (resto = 10 OR resto = 11)
    THEN
      resto := 0;
  END IF;
  
  IF(resto <> firstDigit)
    THEN
      RAISE EXCEPTION 'Invalid CPF.';
  END IF;
  

-- Validação do segundo dígito

  contador := 1;
  soma := 0;
  aux := 11;

  WHILE contador <= 10 LOOP
  temp := CAST(SUBSTRING(NEW.UserCPF,contador,1)AS NUMERIC);
  soma := soma + (temp * aux);
  contador := contador + 1;
  aux := aux - 1;
  END LOOP; 

  resto := (soma*10)%11;
  
  IF (resto = 10 OR resto = 11)
    THEN
      resto := 0;
  END IF;

  IF(resto <> secondDigit)
    THEN
      RAISE EXCEPTION 'Invalid CPF.';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER valida_cpf
AFTER INSERT ON Users
FOR EACH ROW EXECUTE PROCEDURE valida_cpf(); 
