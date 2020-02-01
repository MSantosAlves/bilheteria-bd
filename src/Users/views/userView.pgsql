-- View de usuários cadastrados
CREATE VIEW users_view AS SELECT U.UserCPF AS "CPF", U.BirthDate AS "Data de nascimento", C.CardNumber "Número do cartão"
FROM Users U
INNER JOIN Cards C ON C.UserCPF = U.UserCPF;