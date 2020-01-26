#O Projeto

	Banco de dados de um uma organização promotora de eventos. Por meio desse sistema podem ser vendidos ingressos para apresentações
das seguintes classes de evento: teatro, esporte, show nacional e show internacional.

##Requisitos funcionais

* Um usuário do sistema pode comprar ingresso, cadastrar e editar eventos. Para isso deve ser cadastrado e estar autenticado através de CPF e senha. Para se cadastrar precisa informar CPF, senha e os seguintes dados sobre seu cartão de crédito: número, código de segurança e data de validade.

*  Uma vez autenticado, o usuário também tem acesso aos seguintes serviços providos pelo sistema: cadastrar, excluir e alterar evento.

*  Para cadastrar um evento, o usuário deve informar os seguintes dados associados ao evento: código do evento, nome do evento, código de cada apresentação, data de cada apresentação, horário de cada apresentação, preço do ingresso de cada apresentação, código da sala de cada apresentação, cidade, estado, classe e faixa etária do evento.

* O usuário que cadastrar um evento é responsável pelo evento e só ele pode alterar ou excluir o evento. 

* Um evento não pode ser alterado ou excluído se já foi vendido ingresso para alguma das suas apresentações. 

* Quando um evento é excluído, os dados do evento, assim como os dados de suas apresentações, são excluídos do sistema. 

* Para acessar os dados dos eventos o usuário deve prover os seguintes dados: datas de início e término do evento, nome da cidade e sigla do estado no qual ocorrerá o evento.

* Para adquirir ingressos, o usuário deve informar o código da apresentação e a quantidade de ingressos desejada. Se houver a quantidade de ingressos desejada, o sistema lista os códigos dos ingressos vendidos e atualiza a quantidade de ingressos disponíveis para a apresentação. 

* O resultado da consulta ao sistema deve listar os seguintes dados: nome do evento, código de cada apresentação, data de apresentação, horário de cada apresentação, preço do ingresso de cada apresentação, número da sala de cada apresentação, quantidade de ingressos disponíveis  para cada apresentação, classe e faixa etária do evento. 

* O responsável por um evento pode solicitar informação sobre vendas do evento. Nesse caso, o sistema lista, para cada apresentação do evento, a quantidade total de ingressos vendidos e o CPF de cada comprador de ingresso. Cada usuário pode excluir seu cadastro do sistema quando achar conveniente. Entretanto, a exclusão  de um usuário não é realizado se o usuário for responsável por evento que ainda esteja cadastrado ou for dono de um ingresso. 

* Quando há exclusão de um usuário, os dados do usuário são excluídos do sistema.

##Regras de negócio

* Cada usuário cadastrado pode ser responsável por até cinco eventos;

* Cada evento cadastrado pode ter até dez apresentações associadas.

