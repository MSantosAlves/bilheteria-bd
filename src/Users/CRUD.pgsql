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

-- View de usuários cadastrados
CREATE VIEW user_view AS SELECT UserCPF, BirthDate FROM Users;

-- Atualização de usuário (senha, data de nascimento ou cartão de crédito)
CREATE OR REPLACE FUNCTION update_user(_userCPF char(11), _userPassword char(6),_newPassword char(6), 
                        _BirthDate date, _cardNumber char(16), _securityCod char(3), _validThru date)
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

  IF(_newPassword = '') THEN
    _newPassword := _userPassword;
  END IF;

  UPDATE Users 
  SET 
    UserPassword = _newPassword,
    BirthDate = _BirthDate
  WHERE UserCPF = _userCPF;

  UPDATE Cards 
  SET 
    CardNumber = _cardNumber,
    SecurityCod = _SecurityCod,
    ValidThru = _Validthru
  WHERE UserCPF = _UserCPF;

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
