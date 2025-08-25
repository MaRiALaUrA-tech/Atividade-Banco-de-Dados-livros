create database db_revenda_marialaura;

create table editora_livro(
	editora_livro_id serial primary key,
	nome_editora varchar (20) not null unique,
	email varchar (80) not null unique,
	data_cadastro date not null,
	status_ativo varchar (20) default 'pendente', -- se ainda está conosco ou não
	cnpj varchar (18) not null unique 
);

create table livro (
	livro_id serial primary key,
	nome_livro varchar (40) not null,
	nome_autor varchar (50) not null,
	sinopse text not null,
	isbn varchar (17) not null unique,  --código identificador internacional de livros
	num_paginas int not null,
	editora_livro int
);

ALTER TABLE livro ADD COLUMN editora_livro_id int;

create table vendedor(
	vendedor_id serial primary key,
	nome_vendedor varchar (80) not null,
	data_nascimento date not null,
	cpf char (14) not null unique ,
	email varchar (80) not null,
	teve_indicacao boolean
);
	

create table cliente(
	cliente_id serial primary key,
	nome_cliente varchar (80) not null,
	email varchar (80) not null,
	frequencia_compra int check (frequencia_compra >=0),
	recebe_email_nossos boolean not null,
	data_ultima_compra date not null
);

create table pedido(
	pedido_id serial primary key,
	cliente_id int,
	valor_total numeric (6,2) not null check (valor_total > 0),
	forma_pagamento varchar (20) not null,
	data_pedido date not null,
	data_pagamento date not null check (data_pagamento > date '2024-12-31'),
	cupom_aplicado varchar (5) 
);
	
	

create table item_pedido (
    pedido_id int,
    livro_id int,
    primary key (pedido_id, livro_id),
    quantidade int not null
);


alter table livro add constraint fk_editora_livro foreign key (editora_livro_id) references editora_livro (editora_livro_id);
alter table pedido add constraint fk_cliente foreign key (cliente_id) references cliente (cliente_id);

CREATE VIEW view_pedidos_clientes as SELECT 
  p.pedido_id,
  c.nome_cliente,
  p.valor_total,
  p.forma_pagamento,
  p.data_pedido
FROM pedido p
JOIN cliente c ON p.cliente_id = c.cliente_id;

select*from view_pedidos_clientes;

INSERT INTO editora_livro (nome_editora, email, data_cadastro, status_ativo, cnpj) VALUES 
('Nova Era', 'contato@novaera.com', '2025-01-10', 'ativo', '12.345.678/0001-01'),
('Letra Viva', 'viva@letraviva.com', '2025-02-15', 'pendente', '23.456.789/0001-02'),
('Palavra Solta', 'info@palavrasolta.com', '2025-03-20', 'ativo', '34.567.890/0001-03'),
('EditaMais', 'suporte@editamais.com', '2025-04-05', 'inativo', '45.678.901/0001-04'),
('Texto Livre', 'contato@textolivre.com', '2025-05-12', 'ativo', '56.789.012/0001-05'),
('Cultura Impressa', 'cultura@impressa.com', '2025-06-18', 'pendente', '67.890.123/0001-06'),
('Ponto Final', 'final@ponto.com', '2025-07-22', 'ativo', '78.901.234/0001-07'),
('Verbo Vivo', 'verbo@vivo.com', '2025-08-01', 'inativo', '89.012.345/0001-08'),
('Palavra & Arte', 'arte@palavra.com', '2025-08-10', 'ativo', '90.123.456/0001-09'),
('Editora Raiz', 'raiz@editora.com', '2025-08-15', 'pendente', '01.234.567/0001-10');

INSERT INTO cliente (nome_cliente, email, frequencia_compra, recebe_email_nossos, data_ultima_compra) VALUES 
('Ana Paula', 'ana@cliente.com', 5, TRUE, '2025-08-01'),
('Carlos Eduardo', 'carlos@cliente.com', 2, FALSE, '2025-07-15'),
('Fernanda Lima', 'fernanda@cliente.com', 8, TRUE, '2025-08-10'),
('João Pedro', 'joao@cliente.com', 1, FALSE, '2025-06-20'),
('Mariana Silva', 'mariana@cliente.com', 3, TRUE, '2025-07-30'),
('Lucas Oliveira', 'lucas@cliente.com', 0, FALSE, '2025-05-25'),
('Juliana Costa', 'juliana@cliente.com', 4, TRUE, '2025-08-05'),
('Bruno Tavares', 'bruno@cliente.com', 6, TRUE, '2025-08-12'),
('Patrícia Mendes', 'patricia@cliente.com', 2, FALSE, '2025-07-01'),
('Thiago Rocha', 'thiago@cliente.com', 7, TRUE, '2025-08-15');

INSERT INTO livro (nome_livro, nome_autor, sinopse, isbn, num_paginas, editora_livro_id) VALUES 
('O Sol da Meia-Noite', 'Ana Ribeiro', 'Romance sobre encontros improváveis.', '978-3-16-148410-0', 320, 1),
('Caminhos Tortos', 'Carlos Mendes', 'Suspense psicológico em cidade pequena.', '978-3-16-148411-7', 280, 2),
('A Arte de Respirar', 'Fernanda Lima', 'Reflexões sobre bem-estar e meditação.', '978-3-16-148412-4', 150, 3),
('O Último Verso', 'João Silva', 'Poemas sobre amor e perda.', '978-3-16-148413-1', 90, 4),
('Histórias de Rua', 'Marcos Tavares', 'Contos urbanos com crítica social.', '978-3-16-148414-8', 210, 5),
('Além do Horizonte', 'Luciana Costa', 'Ficção científica com dilemas éticos.', '978-3-16-148415-5', 400, 6),
('Café com Filosofia', 'Rafael Duarte', 'Diálogos filosóficos em cafés parisienses.', '978-3-16-148416-2', 180, 7),
('O Código da Alma', 'Beatriz Nunes', 'Autoajuda com base em psicologia.', '978-3-16-148417-9', 230, 8),
('Fragmentos do Tempo', 'Eduardo Rocha', 'História alternativa do Brasil.', '978-3-16-148418-6', 350, 9),
('Ventos do Norte', 'Juliana Martins', 'Romance histórico no século XIX.', '978-3-16-148419-3', 290, 10);

INSERT INTO pedido (cliente_id, valor_total, forma_pagamento, data_pedido, data_pagamento, cupom_aplicado) VALUES 
(1, 120.00, 'Cartão', '2025-08-01', '2025-08-02', 'DESC'),
(2, 85.50, 'Pix', '2025-07-15', '2025-07-16', NULL),
(3, 200.00, 'Dinheiro', '2025-08-10', '2025-08-11', 'PROMO'),
(4, 60.00, 'Cartão', '2025-06-20', '2025-06-21', NULL),
(5, 150.00, 'Pix', '2025-07-30', '2025-07-31', 'DESC'),
(6, 90.00, 'Dinheiro', '2025-05-25', '2025-05-26', NULL),
(7, 110.00, 'Cartão', '2025-08-05', '2025-08-06', 'PROMO'),
(8, 75.00, 'Pix', '2025-08-12', '2025-08-13', NULL),
(9, 130.00, 'Dinheiro', '2025-07-01', '2025-07-02', 'DESC'),
(10, 180.00, 'Cartão', '2025-08-15', '2025-08-16', NULL);

INSERT INTO item_pedido (pedido_id, livro_id, quantidade) VALUES 
(1, 1, 1),
(2, 2, 2),
(3, 3, 1),
(4, 4, 1),
(5, 5, 2),
(6, 6, 1),
(7, 7, 1),
(8, 8, 2),
(9, 9, 1),
(10, 10, 1);

CREATE VIEW view_livros_editoras AS
SELECT 
  l.livro_id,
  l.nome_livro,
  e.nome_editora
FROM livro l
JOIN editora_livro e ON l.editora_livro_id = e.editora_livro_id;

select*from view_livros_editoras;



