-- ============================================================
-- AI Edu — Produtos parceiros, programa de indicações e suporte via chat
-- ============================================================

-- ---------- Produtos parceiros ----------
create table if not exists public.parceiros (
  id uuid primary key default gen_random_uuid(),
  titulo text not null,
  descricao text not null default '',
  categoria text not null default 'Parceiro',
  imagem_url text not null default '',
  link_url text not null default '',
  ativo boolean not null default true,
  ordem int not null default 0,
  criado_em timestamptz not null default now()
);

create index if not exists parceiros_ordem_idx on public.parceiros (ativo, ordem, criado_em);

alter table public.parceiros enable row level security;
drop policy if exists "parceiros_leitura" on public.parceiros;
create policy "parceiros_leitura" on public.parceiros
  for select to authenticated using (ativo);
drop policy if exists "parceiros_admin_total" on public.parceiros;
create policy "parceiros_admin_total" on public.parceiros
  for all to authenticated using (public.eh_admin()) with check (public.eh_admin());

-- ---------- Programa de indicações ----------
create table if not exists public.afiliados_config (
  id int primary key default 1 check (id = 1),
  percentual numeric(5,2) not null default 30 check (percentual >= 0 and percentual <= 100),
  dias_liberacao int not null default 30 check (dias_liberacao >= 0 and dias_liberacao <= 365),
  atualizado_em timestamptz not null default now()
);
insert into public.afiliados_config (id) values (1) on conflict (id) do nothing;

alter table public.afiliados_config enable row level security;
drop policy if exists "afiliados_config_leitura" on public.afiliados_config;
create policy "afiliados_config_leitura" on public.afiliados_config
  for select to authenticated using (true);
drop policy if exists "afiliados_config_admin" on public.afiliados_config;
create policy "afiliados_config_admin" on public.afiliados_config
  for all to authenticated using (public.eh_admin()) with check (public.eh_admin());

create table if not exists public.afiliados_cliques (
  id uuid primary key default gen_random_uuid(),
  afiliado_id uuid not null references auth.users(id) on delete cascade,
  origem text not null default '',
  criado_em timestamptz not null default now()
);
create index if not exists afiliados_cliques_idx on public.afiliados_cliques (afiliado_id, criado_em desc);

alter table public.afiliados_cliques enable row level security;
drop policy if exists "afiliados_cliques_registrar" on public.afiliados_cliques;
revoke insert on public.afiliados_cliques from anon;

create or replace function public.registrar_clique(ref uuid, origem text default '')
returns void language sql security definer set search_path = public as $$
  insert into public.afiliados_cliques (afiliado_id, origem)
  select ref, left(coalesce(origem, ''), 120)
  where exists (select 1 from auth.users u where u.id = ref);
$$;

revoke all on function public.registrar_clique(uuid, text) from public;
grant execute on function public.registrar_clique(uuid, text) to anon, authenticated;
drop policy if exists "afiliados_cliques_leitura" on public.afiliados_cliques;
create policy "afiliados_cliques_leitura" on public.afiliados_cliques
  for select to authenticated using (afiliado_id = auth.uid() or public.eh_admin());

create table if not exists public.afiliados_vendas (
  id uuid primary key default gen_random_uuid(),
  afiliado_id uuid not null references auth.users(id) on delete cascade,
  descricao text not null default '',
  valor numeric(12,2) not null check (valor >= 0),
  percentual numeric(5,2) not null default 0,
  comissao numeric(12,2) not null default 0,
  libera_em timestamptz not null default now(),
  criado_em timestamptz not null default now()
);
create index if not exists afiliados_vendas_idx on public.afiliados_vendas (afiliado_id, criado_em desc);

create or replace function public.afiliados_venda_defaults()
returns trigger language plpgsql security definer set search_path = public as $$
declare p numeric; d int;
begin
  select percentual, dias_liberacao into p, d from public.afiliados_config where id = 1;
  if coalesce(new.percentual, 0) = 0 then new.percentual := coalesce(p, 0); end if;
  new.comissao := round(new.valor * new.percentual / 100.0, 2);
  new.libera_em := new.criado_em + make_interval(days => coalesce(d, 30));
  return new;
end $$;

drop trigger if exists trg_afiliados_venda_defaults on public.afiliados_vendas;
create trigger trg_afiliados_venda_defaults
  before insert on public.afiliados_vendas
  for each row execute function public.afiliados_venda_defaults();

alter table public.afiliados_vendas enable row level security;
drop policy if exists "afiliados_vendas_leitura" on public.afiliados_vendas;
create policy "afiliados_vendas_leitura" on public.afiliados_vendas
  for select to authenticated using (afiliado_id = auth.uid() or public.eh_admin());
drop policy if exists "afiliados_vendas_admin" on public.afiliados_vendas;
create policy "afiliados_vendas_admin" on public.afiliados_vendas
  for all to authenticated using (public.eh_admin()) with check (public.eh_admin());

-- ---------- Suporte (chat aluno ↔ admin) ----------
create table if not exists public.suporte_conversas (
  id uuid primary key default gen_random_uuid(),
  usuario_id uuid not null references auth.users(id) on delete cascade,
  usuario_nome text not null default '',
  status text not null default 'aberta' check (status in ('aberta','fechada')),
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now(),
  unique (usuario_id)
);

alter table public.suporte_conversas enable row level security;
drop policy if exists "suporte_conversas_aluno" on public.suporte_conversas;
create policy "suporte_conversas_aluno" on public.suporte_conversas
  for all to authenticated using (usuario_id = auth.uid() or public.eh_admin())
  with check (usuario_id = auth.uid() or public.eh_admin());

create table if not exists public.suporte_mensagens (
  id uuid primary key default gen_random_uuid(),
  conversa_id uuid not null references public.suporte_conversas(id) on delete cascade,
  autor text not null check (autor in ('aluno','admin')),
  autor_id uuid,
  texto text not null check (char_length(texto) between 1 and 4000),
  criado_em timestamptz not null default now()
);
create index if not exists suporte_mensagens_idx on public.suporte_mensagens (conversa_id, criado_em);

create or replace function public.conversa_minha(cid uuid)
returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.suporte_conversas c where c.id = cid and c.usuario_id = auth.uid());
$$;

create or replace function public.suporte_tocar_conversa()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  update public.suporte_conversas set atualizado_em = now() where id = new.conversa_id;
  return new;
end $$;

drop trigger if exists trg_suporte_tocar_conversa on public.suporte_mensagens;
create trigger trg_suporte_tocar_conversa
  after insert on public.suporte_mensagens
  for each row execute function public.suporte_tocar_conversa();

alter table public.suporte_mensagens enable row level security;
drop policy if exists "suporte_mensagens_leitura" on public.suporte_mensagens;
create policy "suporte_mensagens_leitura" on public.suporte_mensagens
  for select to authenticated using (public.conversa_minha(conversa_id) or public.eh_admin());
drop policy if exists "suporte_mensagens_enviar" on public.suporte_mensagens;
create policy "suporte_mensagens_enviar" on public.suporte_mensagens
  for insert to authenticated with check (
    (autor = 'aluno' and public.conversa_minha(conversa_id)) or public.eh_admin()
  );
drop policy if exists "suporte_mensagens_admin" on public.suporte_mensagens;
create policy "suporte_mensagens_admin" on public.suporte_mensagens
  for all to authenticated using (public.eh_admin()) with check (public.eh_admin());
