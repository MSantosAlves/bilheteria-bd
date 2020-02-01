-- CADASTRO DE USUÁRIOS

SELECT * FROM create_user('95286955070', 'Passw0', '2000-07-09', '4396062468162544', '954', '2025-05-05');
SELECT * FROM create_user('88932212090', 'Passw1', '1987-02-01', '4901286729929775', '564', '2030-11-10');
SELECT * FROM create_user('71478912014', 'Passw2', '2008-01-02', '4122067386146116', '775', '2027-08-28');
SELECT * FROM create_user('44657949080', 'Passw3', '1998-11-03', '4733354119542196', '169', '2022-12-24');
SELECT * FROM create_user('21266688005', 'Passw4', '2005-05-04', '4709048961497000', '832', '2024-07-12');
SELECT * FROM create_user('60189446005', 'Passw5', '1999-12-05', '4000666555795004', '132', '2028-02-23');
SELECT * FROM create_user('14683263092', 'Passw6', '1972-09-06', '4605115418940505', '544', '2026-01-14');
SELECT * FROM create_user('71817114077', 'Passw7', '1990-04-07', '4633235710519231', '678', '2030-12-28');
SELECT * FROM create_user('80969983077', 'Passw8', '1996-02-08', '4888753600934726', '957', '2021-06-17');
SELECT * FROM create_user('42942914009', 'Passw9', '2002-04-09', '4204544393701019', '348', '2028-09-13');

-- CRIANDO EVENTOS E APRESENTAÇÕES

SELECT * FROM create_event('95286955070','Passw0', 'The Witcher', 1, '18', 'DF', 'Brasilia');
SELECT * FROM create_presentation('95286955070','Passw0', 100, '2020-02-18', '22:00:00', '50.00', 5);
SELECT * FROM create_presentation('95286955070','Passw0', 100, '2020-02-22', '20:00:00', '35.00', 3);
SELECT * FROM create_presentation('95286955070','Passw0', 100, '2020-02-22', '18:00:00', '35.00', 4);
SELECT * FROM create_presentation('95286955070','Passw0', 100, '2020-02-23', '18:00:00', '35.00', 3);
SELECT * FROM create_presentation('95286955070','Passw0', 100, '2020-02-23', '20:00:00', '35.00', 4);
SELECT * FROM create_presentation('95286955070','Passw0', 100, '2020-02-24', '18:00:00', '35.00', 3);
SELECT * FROM create_presentation('95286955070','Passw0', 100, '2020-02-24', '20:00:00', '35.00', 4);
SELECT * FROM create_presentation('95286955070','Passw0', 100, '2020-02-25', '18:00:00', '25.00', 3);
SELECT * FROM create_presentation('95286955070','Passw0', 100, '2020-02-25', '20:00:00', '25.00', 4);
SELECT * FROM create_presentation('95286955070','Passw0', 100, '2020-02-25', '22:00:00', '25.00', 5);

SELECT * FROM create_event('95286955070','Passw0', 'The Witcher', 1, '18', 'SP', 'Guarulhos');
SELECT * FROM create_presentation('95286955070','Passw0', 101, '2020-02-18', '22:00:00', '50.00', 5);
SELECT * FROM create_presentation('95286955070','Passw0', 101, '2020-02-22', '20:00:00', '35.00', 3);
SELECT * FROM create_presentation('95286955070','Passw0', 101, '2020-02-22', '18:00:00', '35.00', 4);
SELECT * FROM create_presentation('95286955070','Passw0', 101, '2020-02-23', '18:00:00', '35.00', 3);
SELECT * FROM create_presentation('95286955070','Passw0', 101, '2020-02-23', '20:00:00', '35.00', 4);
SELECT * FROM create_presentation('95286955070','Passw0', 101, '2020-02-24', '18:00:00', '35.00', 3);
SELECT * FROM create_presentation('95286955070','Passw0', 101, '2020-02-24', '20:00:00', '35.00', 4);
SELECT * FROM create_presentation('95286955070','Passw0', 101, '2020-02-25', '18:00:00', '25.00', 3);
SELECT * FROM create_presentation('95286955070','Passw0', 101, '2020-02-25', '20:00:00', '25.00', 4);
SELECT * FROM create_presentation('95286955070','Passw0', 101, '2020-02-25', '22:00:00', '25.00', 5);

SELECT * FROM create_event('88932212090','Passw1', 'CBLOL', 2, '10', 'RJ', 'Copacabana');
SELECT * FROM create_presentation('88932212090','Passw1', 102, '2020-02-25', '16:30:00', '75.00', 2);

SELECT * FROM create_event('88932212090','Passw1', 'Major CSGO', 2, '12', 'RJ', 'Copacabana');
SELECT * FROM create_presentation('88932212090','Passw1', 103, '2020-03-27', '15:45:00', '100.00', 4);

SELECT * FROM create_event('88932212090','Passw1', 'NBB', 2, 'L', 'RJ', 'Copacabana');
SELECT * FROM create_presentation('88932212090','Passw1', 104, '2020-03-27', '19:45:00', '40.00', 8);

SELECT * FROM create_event('88932212090','Passw1', 'BR6', 2, '16', 'DF', 'Brasilia');
SELECT * FROM create_presentation('88932212090','Passw1', 105, '2020-02-14', '15:45:00', '40.00', 3);

SELECT * FROM create_event('88932212090','Passw1', 'FLAXFLU', 2, '10', 'RJ', 'Copacabana');
SELECT * FROM create_presentation('88932212090','Passw1', 106, '2020-03-27', '19:45:00', '40.00', 8);


SELECT * FROM create_event('71478912014','Passw2', 'Villa Mix SP', 3, '18', 'SP', 'Guarulhos');
SELECT * FROM create_presentation('71478912014','Passw2', 107, '2020-02-16', '22:00:00', '200.00', 3);

SELECT * FROM create_event('71478912014','Passw2', 'Villa Mix RJ', 3, '18', 'RJ', 'Copacabana');
SELECT * FROM create_presentation('71478912014','Passw2', 108, '2020-02-22', '22:00:00', '200.00', 9);

SELECT * FROM create_event('71478912014','Passw2', 'Post Malone DF', 4, '16', 'DF', 'Brasilia');
SELECT * FROM create_presentation('71478912014','Passw2', 109, '2020-02-14', '22:00:00', '450.00', 8);

SELECT * FROM create_event('71478912014','Passw2', 'Post Malone SP', 4, '16', 'SP', 'Guarulhos');
SELECT * FROM create_presentation('71478912014','Passw2', 110, '2020-02-20', '22:00:00', '450.00', 1);

SELECT * FROM create_event('71478912014','Passw2', 'Post Malone RJ', 4, '16', 'RJ', 'Copacabana');
SELECT * FROM create_presentation('71478912014','Passw2', 111, '2020-02-26', '22:00:00', '450.00', 7);

-- COMPRA DE INGRESSOS

SELECT * FROM buyTicket('44657949080', 'Passw3', 1000, 12);
SELECT * FROM buyTicket('71817114077', 'Passw7', 1001, 23);
SELECT * FROM buyTicket('71817114077', 'Passw7', 1002, 14);
SELECT * FROM buyTicket('60189446005', 'Passw5', 1003, 9);
SELECT * FROM buyTicket('80969983077', 'Passw8', 1004, 7);
SELECT * FROM buyTicket('14683263092', 'Passw6', 1005, 3);
SELECT * FROM buyTicket('60189446005', 'Passw5', 1006, 5);
SELECT * FROM buyTicket('71817114077', 'Passw7', 1007, 8);
SELECT * FROM buyTicket('44657949080', 'Passw3', 1008, 1);
SELECT * FROM buyTicket('80969983077', 'Passw8', 1009, 1);
SELECT * FROM buyTicket('80969983077', 'Passw8', 1010, 2);
SELECT * FROM buyTicket('14683263092', 'Passw6', 1011, 1);
SELECT * FROM buyTicket('44657949080', 'Passw3', 1012, 19);
SELECT * FROM buyTicket('71817114077', 'Passw7', 1013, 1);
SELECT * FROM buyTicket('71817114077', 'Passw7', 1014, 8);
SELECT * FROM buyTicket('80969983077', 'Passw8', 1015, 1);
SELECT * FROM buyTicket('80969983077', 'Passw8', 1016, 10);
SELECT * FROM buyTicket('71817114077', 'Passw7', 1017, 3);
SELECT * FROM buyTicket('14683263092', 'Passw6', 1018, 1);
SELECT * FROM buyTicket('44657949080', 'Passw3', 1019, 5);
SELECT * FROM buyTicket('71817114077', 'Passw7', 1020, 8);
SELECT * FROM buyTicket('71817114077', 'Passw7', 1021, 8);
SELECT * FROM buyTicket('14683263092', 'Passw6', 1022, 3);
SELECT * FROM buyTicket('80969983077', 'Passw8', 1023, 2);
SELECT * FROM buyTicket('80969983077', 'Passw8', 1024, 1);
SELECT * FROM buyTicket('44657949080', 'Passw3', 1025, 1);
SELECT * FROM buyTicket('60189446005', 'Passw5', 1026, 1);
SELECT * FROM buyTicket('80969983077', 'Passw8', 1027, 7);
SELECT * FROM buyTicket('71817114077', 'Passw7', 1028, 3);

