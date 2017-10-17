create or replace function
	retorna_nome_funcionario(func_id int)
returns text as
$$
	declare
	nome text;
	situacao text;
	begin
		select funcionario_nome,
		funcionario_situacao
		into nome, situacao
		from funcionarios
		where id = func_id;
		if situacao = 'A' then
			return nome || ' Usuário Ativo';
		else
			return nome || ' Usuário Inativo';
		end if;
	end
$$
language plpgsql;


create or replace function
rt_valor_comissao(func_id int)
returns real as
$$
	declare
		valor_comissao real;
	begin
	select funcionario_comissao
	into valor_comissao
	from funcionarios
	where id = func_id;
		return valor_comissao;
	end
$$
LANGUAGE plpgsql;

create or replace function
calc_comissao(data_ini timestamp,
data_fim timestamp)
returns void as $$
declare
-- declaração das variáveis que vamos
-- utilizar. Já na declaração elas
-- recebem o valor zero. Pois assim
-- garanto que elas estarão zeradas
-- quando for utilizá-las.
total_comissao real := 0;
porc_comissao real := 0;
-- declarando uma variável para armazenar
-- os registros dos loops
reg record;
--cursor para buscar a % de comissão do funcionário
cr_porce CURSOR (func_id int) IS
select rt_valor_comissao(func_id);
begin
-- realiza um loop e busca todas as vendas
-- no período informado
for reg in(
select vendas.id id,
funcionario_id,
venda_total
from vendas
where data_criacao >= data_ini
and data_criacao <= data_fim
and venda_situacao = 'A')loop
-- abertura, utilização e fechamento do cursor
open cr_porce(reg.funcionario_id);
fetch cr_porce into porc_comissao;
close cr_porce;
total_comissao := (reg.venda_total *
porc_comissao)/100;
-- insere na tabela de comissões o valor
-- que o funcionário irá receber de comissão
-- daquela venda
insert into comissoes(
funcionario_id,
comissao_valor,
comissao_situacao,
data_criacao,
data_atualizacao)
values(reg.funcionario_id,
total_comissao,
'A',
now(),
now());
-- update na situação da venda
-- para que ela não seja mais comissionada
update vendas set venda_situacao = 'C'
where id = reg.id;
-- devemos zerar as variáveis para reutilizá-las
total_comissao := 0;
porc_comissao := 0;
-- término do loop
end loop;
end
$$ language plpgsql;

create or replace function ttat_md5(value text)
returns text as 
$$
declare 
salt text;
begin
salt = 'T O T V S';
return md5(value || salt );
end
$$ language plpgsql;

select ttat_md5('ALVARO');

SELECT tgname FROM pg_trigger;