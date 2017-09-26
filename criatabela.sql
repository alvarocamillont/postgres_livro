create table mesas (
id int not null primary key,
mesa_codigo varchar(20),
mesa_situacao varchar(1) default 'A',
data_criacao timestamp,
data_atualizacao timestamp);

create table funcionarios(
id int not null primary key,
funcionario_codigo varchar(20),
funcionario_nome varchar(100),
funcionario_situacao varchar(1) default 'A',
funcionario_comissao real,
funcionario_cargo varchar(30),
data_criacao timestamp,
data_atualizacao timestamp);


create table vendas(
id int not null primary key,
funcionario_id int references funcionarios (id),
mesa_id int references mesas(id),
venda_codigo varchar(20),
venda_valor real,
venda_total real,venda_desconto real,
venda_situacao varchar(1) default 'A',
data_criacao timestamp,
data_atualizacao timestamp);

create table produtos(
id int not null primary key,
produto_codigo varchar(20),
produto_nome varchar(60),
produto_valor real,
produto_situacao varchar(1) default 'A',
data_criacao timestamp,
data_atualizacao timestamp);

create table itens_vendas(
id int not null primary key,
produto_id int not null references produtos(id),
vendas_id int not null references vendas(id),
item_valor real,
item_quantidade int,
item_total real,
data_criacao timestamp,
data_atualizacao timestamp);

create table comissoes(
id int not null primary key,
funcionario_id int references funcionarios(id),
comissao_valor real,
comissao_situacao varchar(1) default 'A',
data_criacao timestamp,
data_atualizacao timestamp);

alter table vendas add check (venda_total > 0 );

alter table funcionarios add check( funcionario_nome <> null);

create sequence mesa_id_seq;
create sequence vendas_id_seq;
create sequence itens_vendas_id_seq;
create sequence produtos_id_seq;
create sequence funcionario_id_seq;
create sequence comissoes_id_seq;

alter table mesas
alter column id set default nextval('mesa_id_seq');
alter table vendas
alter column id set default nextval('vendas_id_seq');
alter table itens_vendas
alter column id set default nextval('itens_vendas_id_seq');
alter table produtos
alter column id set default nextval('produtos_id_seq');
alter table funcionarios
alter column id set default nextval('funcionario_id_seq');
alter table comissoes
alter column id set default nextval('comissoes_id_seq');


create table logs_produtos(
id int not null primary key,
data_alteracao timestamp,
alteracao varchar(10),
id_old int,
produto_codigo_old varchar(20),
produto_nome_old varchar(60),
produto_valor_old real,
produto_situacao_old varchar(1) default 'A',
data_criacao_old timestamp,
data_atualizacao_old timestamp,
id_new int,
produto_codigo_new varchar(20),
produto_nome_new varchar(60),
produto_valor_new real,
produto_situacao_new varchar(1) default 'A',
data_criacao_new timestamp,
data_atualizacao_new timestamp,
hash_campo varchar(200) );

create sequence logs_produto_id_seq;

alter table logs_produtos
alter column id set default
nextval('logs_produto_id_seq');
