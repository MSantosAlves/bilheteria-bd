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

-- Autenticação de usuário



-- View de usuários cadastrados
CREATE VIEW user_view AS SELECT UserCPF, BirthDate FROM Users;

-- Atualização de usuário (senha, data de nascimento ou cartão de crédito)
CREATE OR REPLACE FUNCTION update_user(_userCPF char(11), _UserPassword char(6), _BirthDate date,
                                       _cardNumber char(16), _securityCod char(3), _validThru date)
RETURNS text AS $$
BEGIN
  UPDATE Users WHERE UserCPF = _userCPF
  SET UserPassword = _UserPassword,
  SET BirthDate = _BirthDate;

  UPDATE Cards WHERE UserCPF = _UserCPF
  SET CardNumber = _cardNumber,
  SET SecurityCod = _SecurityCod,
  SET ValidThru = _Validthru;
  RETURN 'User successfully updated.';
END;
$$ LANGUAGE plpgsql;

-- Exclusão de usuário
CREATE OR REPLACE FUNCTION delete_user(_userCPF char(11))  
RETURNS text AS $$
BEGIN
  DELETE FROM Users WHERE UserCPF = _userCPF;
  RETURN 'User successfully deleted.';
END;
$$ LANGUAGE plpgsql;