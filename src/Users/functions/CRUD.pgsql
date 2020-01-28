-- Criação de usuário

CREATE OR REPLACE FUNCTION create_user(_userCPF char(11), _userPassword char(6), _birthDate date, _cardNumber char(16), _securityCod char(3), _validThru date)
RETURNS text AS $$
BEGIN
  INSERT INTO Users(UserCPF, UserPassword, BirthDate) VALUES
  (_userCPF, _userPassword, _birthDate);
  INSERT INTO Cards(CardNumber, SecurityCod, ValidThru, UserCPF) VALUES
  (_cardNumber, _securityCod, _validThru, _userCPF);
  RETURN 'User successfully created.';
END;
$$ LANGUAGE plpgsql;

-- Atualização de usuário (senha, data de nascimento ou cartão de crédito)
CREATE OR REPLACE FUNCTION update_user(_userCPF char(11), _userPassword char(6), 
    _newPassword char(6), _birthDate date, _cardNumber char(16), _securityCod char(3),
    _validThru date)
RETURNS text AS $$
DECLARE
  rec_user RECORD;
BEGIN
  SELECT UserCPF INTO rec_user FROM Users 
  WHERE 
  UserCPF = _userCPF AND UserPassword = md5(_userPassword);
	
  IF rec_user.UserCPF IS NULL THEN
    RAISE EXCEPTION 'User authentication failed.';
  END IF;

  UPDATE Users
    SET
    UserPassword = CASE
      WHEN _newPassword = ''  THEN _userPassword
      ELSE _newPassword
      END,
    BirthDate = CASE
      WHEN _birthDate IS NULL THEN BirthDate
      ELSE _birthDate
      END
  WHERE UserCPF = _userCPF;

  UPDATE Cards
    SET
    CardNumber = CASE
      WHEN _cardNumber = '' THEN CardNumber
      ELSE _cardNumber
    END,
    SecurityCod = CASE
      WHEN _securityCod = '' THEN SecurityCod
      ELSE _securityCod
    END,
    ValidThru = CASE
      WHEN _validThru IS NULL THEN ValidThru
      ELSE _validThru
    END
  WHERE UserCPF = _userCPF;

  RETURN 'User successfully updated.';
END;
$$ LANGUAGE plpgsql;

-- Exclusão de usuário
CREATE OR REPLACE FUNCTION delete_user(_userCPF char(11), _userPassword char(6))  
RETURNS text AS $$
DECLARE
  rec_user RECORD;
BEGIN
  SELECT UserCPF INTO rec_user FROM Users 
  WHERE 
  UserCPF = _userCPF AND UserPassword = md5(_userPassword);
	
  IF rec_user.UserCPF IS NULL THEN
    RAISE EXCEPTION 'User authentication failed.';
  END IF;

  DELETE FROM Users WHERE UserCPF = _userCPF;
  RETURN 'User successfully deleted.';
END;
$$ LANGUAGE plpgsql;
