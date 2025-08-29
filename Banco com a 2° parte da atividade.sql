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
	
	alter table pedido add vendedor_id int;

create table item_pedido (
    pedido_id int,
    livro_id int,
    primary key (pedido_id, livro_id),
    quantidade int not null
);


alter table livro add constraint fk_editora_livro foreign key (editora_livro_id) references editora_livro (editora_livro_id);
alter table pedido add constraint fk_cliente foreign key (cliente_id) references cliente (cliente_id);
alter table item_pedido add constraint fk_pedido foreign key (pedido_id) references pedido (pedido_id);
alter table item_pedido add constraint fk_livro foreign key (livro_id) references livro (livro_id);
alter table pedido add constraint fk_vendedor foreign key (vendedor_id) references vendedor (vendedor_id);

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

INSERT INTO pedido (cliente_id, valor_total, forma_pagamento, data_pedido, data_pagamento, cupom_aplicado, vendedor_id) VALUES 
(1, 120.00, 'Cartão', '2025-08-01', '2025-08-02', 'DESC', 1),
(2, 85.50, 'Pix', '2025-07-15', '2025-07-16', null, 2),
(3, 200.00, 'Dinheiro', '2025-08-10', '2025-08-11', 'PROMO', 3),
(4, 60.00, 'Cartão', '2025-06-20', '2025-06-21', null, 4),
(5, 150.00, 'Pix', '2025-07-30', '2025-07-31', 'DESC', 5),
(6, 90.00, 'Dinheiro', '2025-05-25', '2025-05-26', null, 6),
(7, 110.00, 'Cartão', '2025-08-05', '2025-08-06', 'PROMO', 7),
(8, 75.00, 'Pix', '2025-08-12', '2025-08-13', null, 8),
(9, 130.00, 'Dinheiro', '2025-07-01', '2025-07-02', 'DESC', 9),
(10, 180.00, 'Cartão', '2025-08-15', '2025-08-16', null, 10);

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

INSERT INTO vendedor (nome_vendedor, data_nascimento, cpf, email, teve_indicacao) VALUES
('Amanda Souza', '1990-03-15', '123.456.789-00', 'amanda@vendas.com', TRUE),
('Bruno Lima', '1985-07-20', '234.567.890-11', 'bruno@vendas.com', FALSE),
('Ana Clara Mendes', '1992-01-05', '345.678.901-22', 'ana.mendes@vendas.com', TRUE),
('Carlos Silva', '1988-11-30', '456.789.012-33', 'carlos@vendas.com', FALSE),
('Mariana Oliveira', '1995-04-12', '567.890.123-44', 'mariana@vendas.com', TRUE),
('Felipe Santos', '1987-09-25', '678.901.234-55', 'felipe@vendas.com', FALSE),
('Patrícia Gomes', '1993-06-18', '789.012.345-66', 'patricia@vendas.com', TRUE),
('Ricardo Alves', '1982-12-02', '890.123.456-77', 'ricardo@vendas.com', FALSE),
('Beatriz Rocha', '1991-08-09', '901.234.567-88', 'beatriz@vendas.com', TRUE),
('João Pedro Martins', '1989-10-22', '012.345.678-99', 'joao.pedro@vendas.com', FALSE);


CREATE VIEW view_livros_editoras AS
SELECT 
  l.livro_id,
  l.nome_livro,
  e.nome_editora
FROM livro l
JOIN editora_livro e ON l.editora_livro_id = e.editora_livro_id;

select*from view_livros_editoras;

-- Segunda parte da atividade

select * from vendedor where nome_vendedor like 'A%';
explain select * from vendedor where nome_vendedor like 'A%';
create index index_nome_vendedor on vendedor (nome_vendedor);
explain select * from vendedor where nome_vendedor like 'A%';

select * from cliente where nome_cliente like 'B%';
explain select * from cliente where nome_cliente like 'B%';

create index index_nome_cliente on cliente (nome_cliente);
explain select * from cliente where nome_cliente like 'B%';

alter table cliente alter column email type int USING email::integer;
alter table item_pedido alter column quantidade type varchar using quantidade::integer;

create user maria_laura with password 'sapocururu';
grant all privileges on database db_revenda_marialaura to maria_laura; -- acesso ao banco
grant all privileges on all tables in schema public to maria_laura; -- tabelas
grant all privileges on all sequences in schema public to maria_laura; -- colunas/inserts

create user colega with password 'araraazul';
grant select on table cliente to colega;

-- Testando na conta "colega"
select * from cliente where nome_cliente like 'B%';
explain select * from cliente where nome_cliente like 'B%';
create index index_nome_cliente on cliente (nome_cliente);
explain select * from cliente where nome_cliente like 'B%';
alter table cliente alter column email type int USING email::integer;
alter table item_pedido alter column quantidade type varchar using quantidade::integer;

-- Pedidos e clientes 

SELECT p.pedido_id, c.nome_cliente, p.valor_total FROM pedido p INNER JOIN cliente c ON p.cliente_id = c.cliente_id;
SELECT p.pedido_id, c.nome_cliente, p.valor_total FROM pedido p LEFT JOIN cliente c ON p.cliente_id = c.cliente_id;
SELECT p.pedido_id, c.nome_cliente, p.valor_total FROM pedido p right join cliente c ON p.cliente_id = c.cliente_id;

-- Livros e editoras

select l.livro_id, l.isbn, e.nome_editora from livro l inner join editora_livro e on e.editora_livro_id = l.editora_livro_id;
select l.livro_id, l.isbn, e.nome_editora from livro l left join editora_livro e on e.editora_livro_id = l.editora_livro_id;
select l.livro_id, l.isbn, e.nome_editora from livro l right join editora_livro e on e.editora_livro_id = l.editora_livro_id;

-- Vendedor e cliente

select p.pedido_id, c.nome_cliente, v.nome_vendedor from pedido p inner join cliente c on p.cliente_id = c.cliente_id inner join vendedor v on p.vendedor_id = v.vendedor_id;
select p.pedido_id, c.nome_cliente, v.nome_vendedor from pedido p left join cliente c on p.cliente_id = c.cliente_id left join vendedor v on p.vendedor_id = v.vendedor_id; -- mostrou os registros que estavam sem o id_vendedor CONCERTAR
select p.pedido_id, c.nome_cliente, v.nome_vendedor from pedido p right join cliente c on p.cliente_id = c.cliente_id right join vendedor v on p.vendedor_id = v.vendedor_id;

--Livros nos pedidos

select p.pedido_id, l.nome_livro, ip.quantidade, p.valor_total from pedido p inner join item_pedido ip on ip.pedido_id = p.pedido_id inner join livro l on ip.livro_id = l.livro_id;
select p.pedido_id, l.nome_livro, ip.quantidade, p.valor_total from pedido p left join item_pedido ip on ip.pedido_id = p.pedido_id left join livro l on ip.livro_id = l.livro_id;
select p.pedido_id, l.nome_livro, ip.quantidade, p.valor_total from pedido p right join item_pedido ip on ip.pedido_id = p.pedido_id right join livro l on ip.livro_id = l.livro_id;

UPDATE pedido SET cupom_aplicado = null WHERE cupom_aplicado IS NOT NULL;
select cupom_aplicado from pedido p;
update pedido set cupom_aplicado = 'PROMO';
select cupom_aplicado from pedido p;


