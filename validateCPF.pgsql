-- VALIDAÇÃO DE CPF

CREATE OR REPLACE FUNCTION valida_cpf(user_cpf char(11))
RETURNS integer AS $$
DECLARE
  firstDigit integer;
  secondDigit integer;
  contador integer;
  soma integer;
  resto integer;
  temp integer;
  aux integer;
BEGIN

  IF CHAR_LENGTH(user_cpf) <> 11
    THEN
      RAISE EXCEPTION 'Invalid CPF length.';
      RETURN 0;
  END IF;

  firstDigit  := CAST(SUBSTRING(user_cpf,10,1)AS NUMERIC);
  secondDigit := CAST(SUBSTRING(user_cpf,11,1)AS NUMERIC);

-- Validação do primeiro dígito

  contador := 1;
  soma := 0;
  aux := 10;

  WHILE contador <= 9 LOOP
  temp := CAST(SUBSTRING(user_cpf,contador,1)AS NUMERIC);
  soma := soma + (temp * aux);
  contador := contador + 1;
  aux := aux - 1;
  END LOOP; 

  resto := (soma*10)%11;
  
  IF (resto = 10 OR resto = 11)
    THEN
      resto := 0;
  END IF;
  
  RAISE NOTICE 'Resto_1: %, Dígito_1: %', resto, firstDigit;
  IF(resto <> firstDigit)
    THEN
      RAISE EXCEPTION 'Invalid CPF.';
      RETURN 0;
  END IF;
  

-- Validação do segundo dígito

  contador := 1;
  soma := 0;
  aux := 11;

  WHILE contador <= 10 LOOP
  temp := CAST(SUBSTRING(user_cpf,contador,1)AS NUMERIC);
  soma := soma + (temp * aux);
  contador := contador + 1;
  aux := aux - 1;
  END LOOP; 

  resto := (soma*10)%11;
  
  IF (resto = 10 OR resto = 11)
    THEN
      resto := 0;
  END IF;

  RAISE NOTICE 'Resto_2: %, Dígito_2: %', resto, secondDigit;
  IF(resto <> secondDigit)
    THEN
      RAISE EXCEPTION 'Invalid CPF.';
      RETURN 0;
  END IF;

  RETURN 1;
END;
$$ LANGUAGE plpgsql;