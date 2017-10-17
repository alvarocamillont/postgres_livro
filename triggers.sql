

create or replace function gera_log_produtos()
	returns trigger as
$$
	Begin
	if TG_OP = 'INSERT' then
	insert into logs_produtos (
		alteracao
		,data_alteracao
		,id_new
		,produto_codigo_new
		,produto_nome_new
		,produto_valor_new
		,produto_situacao_new
		,data_criacao_new
		,data_atualizacao_new
		,hash_campo
	)
	values (
		TG_OP
		,now()
		,new.id
		,new.produto_codigo
		,new.produto_nome
		,new.produto_valor
		,new.produto_situacao
		,new.data_criacao
		,new.data_atualizacao
		,MD5(new.produto_codigo||new.produto_nome)
	);
	return new;

	elsif TG_OP = 'UPDATE' then
	insert into logs_produtos (
		alteracao
		,data_alteracao
		,id_old
		,produto_codigo_old
		,produto_nome_old
		,produto_valor_old
		,produto_situacao_old
		,data_criacao_old
		,data_atualizacao_old
		,id_new
		,produto_codigo_new
		,produto_nome_new
		,produto_valor_new
		,produto_situacao_new
		,data_criacao_new
		,data_atualizacao_new
		,hash_campo
	)
	values (
		TG_OP
		,now()
		,old.id
		,old.produto_codigo
		,old.produto_nome
		,old.produto_valor
		,old.produto_situacao
		,old.data_criacao
		,old.data_atualizacao
		,new.id
		,new.produto_codigo
		,new.produto_nome
		,new.produto_valor
		,new.produto_situacao
		,new.data_criacao
		,new.data_atualizacao
		,MD5(new.produto_codigo||new.produto_nome)
	);
	return new;
	elsif TG_OP = 'DELETE' then
	insert into logs_produtos (
		alteracao
		,data_alteracao
		,id_old
		,produto_codigo_old
		,produto_nome_old
		,produto_valor_old
		,produto_situacao_old
		,data_criacao_old
		,data_atualizacao_old
		,hash_campo
	)
	values (
		TG_OP
		,now()
		,old.id
		,old.produto_codigo
		,old.produto_nome
		,old.produto_valor
		,old.produto_situacao
		,old.data_criacao
		,old.data_atualizacao
		,MD5(new.produto_codigo||new.produto_nome)
	);
	return new;
	end if;
	end;
$$ language 'plpgsql';

create trigger tri_log_produtos
after insert or update or delete on produtos
for each row execute
procedure gera_log_produtos();

insert into produtos (produto_codigo,
produto_nome,
produto_valor,
produto_situacao,
data_criacao,
data_atualizacao)
values ('1512',
'LAZANHA',
46,
'A',
'01/01/2016',
'01/01/2016');

insert into produtos (produto_codigo,
produto_nome,
produto_valor,
produto_situacao,
data_criacao,
data_atualizacao)
values ('1613',
'PANQUECA',
38,
'A',
'01/01/2016',
'01/01/2016');

SELECT * FROM logs_produtos;

drop trigger tri_log_produtos on produtos CASCADE ;