CREATE OR REPLACE FUNCTION validate_password()
RETURNS TRIGGER AS $$
  DECLARE
  len integer;
  password varchar;
  counter integer;
  tempChar char;
  haveDigit boolean;T
  BEGIN
  password := NEW.UserPassword;
  len := CHAR_LENGTH(password);

  -- Verificando se a senha informada possui 6 caracteres:
  IF( len <> 6 )
  THEN 
    RAISE EXCEPTION 'Password must have 6 characters.';
  END IF;

  -- Verificando se há caracteres maiúsculos e minúsculos/se há pelo menos uma letra:
  IF (password = UPPER(password) OR password = LOWER(password))
  THEN 
    RAISE EXCEPTION 'Password must have at least one uppercase and one lowercase character.';
  END IF;

  -- Verificando se há dígitos na senha informada:
  IF password !~ '[0-9]'
  THEN 
    RAISE EXCEPTION 'Password must have at least one digit.';
  END IF;
  
  -- Verificando se não há caracteres especiais:
  
  counter := 1;
  WHILE counter < len LOOP
  tempChar := SUBSTRING(password, counter, 1);
      IF tempChar !~ '[0-9]' AND tempChar !~* '[a-z]'
      THEN
      RAISE EXCEPTION 'Password can not have special characters.'; 
      END IF;
    counter := counter + 1;
    END LOOP;
  RETURN NEW;
  END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER validate_password
AFTER INSERT ON Users
FOR EACH ROW EXECUTE PROCEDURE validate_password();

-- Teste
-- SELECT * FROM Users;

-- DELETE FROM Users WHERE UserCPF='07143123129';

-- INSERT INTO Users(UserCPF, UserPassword, BirthDate) VALUES
-- ('07143123129', 'Mathe1', '2000-07-09');