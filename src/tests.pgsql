-- Arquivo para testes

-- Cadastro de usuário (CPF, SENHA, NASCIMENTO, NÚMEROCC, CÓDIGOCC, VALIDADECC)
SELECT * FROM create_user('1234567890', 'senha', '2020-01-01', '1234123412341234', '456', '2020-01-31'); 
SELECT * FROM users_view;

-- Cadastro de Evento (CPF, SENHA, NOME, CLASSE, CLASSIFICAÇÃO, ESTADO, CIDADE)
SELECT * FROM create_event
('_inserirCPF', '_inserirSenha', 'Evento teste',  1, '18', 'DF', 'Plano Piloto');
SELECT * FROM create_event
('_inserirCPF', '_inserirSenha', 'Evento teste 2',  1, '18', 'DF', 'Plano Piloto');
SELECT * FROM create_event
('_inserirCPF', '_inserirSenha', 'Evento teste 3',  1, '18', 'DF', 'Plano Piloto');
SELECT * FROM create_event
('_inserirCPF', '_inserirSenha', 'Evento teste 4',  1, '18', 'DF', 'Plano Piloto');
SELECT * FROM create_event
('_inserirCPF', '_inserirSenha', 'Evento teste 5',  1, '18', 'DF', 'Plano Piloto');
SELECT * FROM Events;

SELECT * FROM create_event
('_inserirCPF', '_inserirSenha', 'Evento teste 6',  1, '18', 'DF', 'Plano Piloto'); -- Não deve cadastrar

-- Cadastro de apresentação (CPF, SENHA, IDEVENTO, DATA, HORÁRIO, PREÇO, SALA)
SELECT * FROM create_presentation
('_inserirCPF', '_inserirSenha', 112,'2020-02-10', '07:00:00', '25.00', 1);
SELECT * FROM create_presentation
('_inserirCPF', '_inserirSenha', 112,'2020-02-10', '08:15:00', '25.00', 2);
SELECT * FROM create_presentation
('_inserirCPF', '_inserirSenha', 112,'2020-02-10', '11:30:00', '25.00', 3);
SELECT * FROM create_presentation
('_inserirCPF', '_inserirSenha', 112,'2020-02-10', '13:45:00', '25.00', 4);
SELECT * FROM create_presentation
('_inserirCPF', '_inserirSenha', 112,'2020-02-10', '15:00:00', '25.00', 5);
SELECT * FROM create_presentation
('_inserirCPF', '_inserirSenha', 112,'2020-02-10', '17:15:00', '25.00', 6);
SELECT * FROM create_presentation
('_inserirCPF', '_inserirSenha', 112,'2020-02-10', '19:30:00', '25.00', 7);
SELECT * FROM create_presentation
('_inserirCPF', '_inserirSenha', 112,'2020-02-10', '20:45:00', '25.00', 8);
SELECT * FROM create_presentation
('_inserirCPF', '_inserirSenha', 112,'2020-02-10', '21:00:00', '25.00', 9);
SELECT * FROM create_presentation
('_inserirCPF', '_inserirSenha', 112,'2020-02-10', '22:00:00', '25.00', 10);

SELECT * FROM create_presentation
('_inserirCPF', '_inserirSenha', 112,'2020-02-10', '14:30:00', '25.00', 1); -- Não deve cadastrar

SELECT * FROM show_event('2020-01-01', '2020-12-31', 'Plano Piloto', 'DF');

-- Compra de ingressos (CPF, SENHA, IDAPRESENTAÇÃO, QUANTIDADE)
SELECT * FROM buyTicket('95286955070', 'Passw0', 1030,10)
SELECT * FROM show_event('2020-01-01', '2020-12-31', 'Plano Piloto', 'DF');

SELECT * FROM users_view;
SELECT * FROM buyTicket('21266688005', 'Passw4', 1030,1); -- Não deve conseguir comprar 
                                                         -- (usuário menor de idade).
-- Informções do evento (CPF, SENHA, IDEVENTO)
SELECT * FROM events_control('_inserirCPF', '_inserirSenha',112);

-- Update de usuário (CPF, SENHA, _NOVASENHA, ANIVERSÁRIO(NULL), _NÚMEORCC, _CÓDIGOCC, VALIDADECC(NULL))
SELECT * FROM update_user('_inserirCPF', '_inserirSenha', '', NULL, '', '', NULL);

-- Update de evento (CPF, SENHA, IDEVENTO, _NOME, CLASSE, _CLASSIFICAÇÃO, _ESTADO, _CIDADE)
SELECT * FROM update_event('_inserirCPF', '_inserirSenha', 112,'', 1, 'L', 'SC', 'Balneario');
SELECT * FROM show_event('2020-01-01', '2020-12-31', 'SC', 'Balneario');

SELECT * FROM update_event('_inserirCPF', '_inserirSenha', 113,'', 1, 'L', 'SC', 'Balneario');
SELECT * FROM Events;

-- Deleção de usuário (CPF, SENHA)
SELECT * FROM users_view;
SELECT * FROM delete_user('_inserirCPF', '_inserirSenha');
SELECT * FROM users_view;

-- Deleção de evento (CPF, SENHA, IDEVENTO)
SELECT * FROM delete_event('_inserirCPF', '_inserirSenha', 112);

SELECT * FROM show_event('2020-01-01', '2020-12-31', 'Copacabana', 'RJ');
SELECT * FROM delete_event('71478912014', 'Passw2', 111);
SELECT * FROM Events;
SELECT * FROM show_event('2020-01-01', '2020-12-31', 'Copacabana', 'RJ');

-- Deleção de apresentação (CPF, SENHA, IDEVENTO, IDAPRESENTAÇÃO)
SELECT * FROM show_event('2020-01-01', '2020-12-31', 'Plano Piloto', 'DF');
SELECT * FROM delete_presentation('_inserirCPF', '_inserirSenha', 112, 1031);
SELECT * FROM show_event('2020-01-01', '2020-12-31', 'Plano Piloto', 'DF');

SELECT * FROM delete_presentation('_inserirCPF', '_inserirSenha', 112, 1030); 
-- Não deve ser efetuada (apresentação já vendeu ingressos)

