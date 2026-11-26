-- ============================================================
-- NEXORA AI — Banco da plataforma (projeto Supabase: aiedu)
-- Aplicar com: supabase db push  (ou via Management API)
-- ============================================================

-- ---------- extensões ----------
create extension if not exists "pgcrypto";

-- ---------- perfis (espelha auth.users) ----------
create table if not exists public.perfis (
  id uuid primary key references auth.users(id) on delete cascade,
  nome text not null default 'Aluno',
  nivel int not null default 1,
  xp int not null default 0,
  streak_dias int not null default 0,
  criado_em timestamptz not null default now()
);

-- ---------- catálogo ----------
create table if not exists public.cursos (
  id uuid primary key default gen_random_uuid(),
  slug text unique not null,
  titulo text not null,
  descricao text not null default '',
  categoria text not null,
  nivel text not null default 'Iniciante' check (nivel in ('Iniciante','Intermédio','Avançado')),
  duracao_min int not null default 0,
  autor text not null default '',
  nota numeric(2,1) not null default 0,
  alunos int not null default 0,
  capa text not null default 'onda',   -- chave da capa SVG (synth, onda, portal, maleta, bussola, checklist)
  ativo boolean not null default true,
  criado_em timestamptz not null default now()
);

create table if not exists public.modulos (
  id uuid primary key default gen_random_uuid(),
  curso_id uuid not null references public.cursos(id) on delete cascade,
  titulo text not null,
  ordem int not null default 0
);

create table if not exists public.aulas (
  id uuid primary key default gen_random_uuid(),
  modulo_id uuid not null references public.modulos(id) on delete cascade,
  titulo text not null,
  duracao_seg int not null default 0,
  ordem int not null default 0,
  video_url text not null default ''
);

create table if not exists public.skills (
  id uuid primary key default gen_random_uuid(),
  slug text unique not null,
  nome text not null,
  descricao text not null default '',
  icone text not null default '✨',
  aulas int not null default 0
);

create table if not exists public.prompts (
  id uuid primary key default gen_random_uuid(),
  categoria text not null,
  titulo text not null,
  conteudo text not null,
  modelo text not null default 'ChatGPT',
  nivel text not null default 'Iniciante' check (nivel in ('Iniciante','Intermédio','Avançado')),
  nota numeric(2,1) not null default 0,
  autor text not null default 'NEXORA',
  criado_por uuid references auth.users(id) on delete set null,
  publico boolean not null default true,
  criado_em timestamptz not null default now()
);

create table if not exists public.squads (
  id uuid primary key default gen_random_uuid(),
  slug text unique not null,
  nome text not null,
  descricao text not null default '',
  nivel text not null default 'Iniciante' check (nivel in ('Iniciante','Intermédio','Avançado')),
  capa text not null default 'onda'
);

create table if not exists public.squad_cursos (
  squad_id uuid not null references public.squads(id) on delete cascade,
  curso_id uuid not null references public.cursos(id) on delete cascade,
  primary key (squad_id, curso_id)
);

create table if not exists public.aplicativos (
  id uuid primary key default gen_random_uuid(),
  slug text unique not null,
  nome text not null,
  categoria text not null,
  descricao text not null default '',
  nota numeric(2,1) not null default 0,
  preco text not null default 'Grátis',
  dificuldade text not null default 'Iniciante' check (dificuldade in ('Iniciante','Intermédio','Avançado')),
  url text not null default ''
);

create table if not exists public.missoes (
  id uuid primary key default gen_random_uuid(),
  titulo text not null,
  descricao text not null default '',
  meta int not null default 1,
  xp int not null default 50,
  semana timestamptz not null default date_trunc('week', now())
);

-- ---------- progresso do aluno ----------
create table if not exists public.inscricoes (
  usuario_id uuid not null references auth.users(id) on delete cascade,
  curso_id uuid not null references public.cursos(id) on delete cascade,
  progresso_pct int not null default 0 check (progresso_pct between 0 and 100),
  atualizado_em timestamptz not null default now(),
  primary key (usuario_id, curso_id)
);

create table if not exists public.aulas_concluidas (
  usuario_id uuid not null references auth.users(id) on delete cascade,
  aula_id uuid not null references public.aulas(id) on delete cascade,
  concluida_em timestamptz not null default now(),
  primary key (usuario_id, aula_id)
);

create table if not exists public.prompts_salvos (
  usuario_id uuid not null references auth.users(id) on delete cascade,
  prompt_id uuid not null references public.prompts(id) on delete cascade,
  salvo_em timestamptz not null default now(),
  primary key (usuario_id, prompt_id)
);

create table if not exists public.favoritos (
  usuario_id uuid not null references auth.users(id) on delete cascade,
  item_tipo text not null check (item_tipo in ('curso','skill','squad','aplicativo','prompt','aula')),
  item_id uuid not null,
  criado_em timestamptz not null default now(),
  primary key (usuario_id, item_tipo, item_id)
);

create table if not exists public.missao_progresso (
  usuario_id uuid not null references auth.users(id) on delete cascade,
  missao_id uuid not null references public.missoes(id) on delete cascade,
  atual int not null default 0,
  concluida boolean not null default false,
  primary key (usuario_id, missao_id)
);

create table if not exists public.certificados (
  id uuid primary key default gen_random_uuid(),
  usuario_id uuid not null references auth.users(id) on delete cascade,
  curso_id uuid not null references public.cursos(id) on delete cascade,
  codigo text unique not null default 'NEXORA-AIEDU-' || upper(substring(gen_random_uuid()::text,1,8)),
  emitido_em timestamptz not null default now()
);

-- ---------- trigger: cria perfil a cada novo usuário ----------
create or replace function public.cria_perfil_ao_cadastrar()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.perfis (id, nome)
  values (new.id, coalesce(new.raw_user_meta_data->>'nome', split_part(new.email,'@',1)))
  on conflict (id) do nothing;
  return new;
end $$;

drop trigger if exists ao_cadastrar on auth.users;
create trigger ao_cadastrar
  after insert on auth.users
  for each row execute function public.cria_perfil_ao_cadastrar();

-- ---------- RLS ----------
alter table public.perfis             enable row level security;
alter table public.cursos             enable row level security;
alter table public.modulos            enable row level security;
alter table public.aulas              enable row level security;
alter table public.skills             enable row level security;
alter table public.prompts            enable row level security;
alter table public.squads             enable row level security;
alter table public.squad_cursos       enable row level security;
alter table public.aplicativos        enable row level security;
alter table public.missoes            enable row level security;
alter table public.inscricoes         enable row level security;
alter table public.aulas_concluidas   enable row level security;
alter table public.prompts_salvos     enable row level security;
alter table public.favoritos          enable row level security;
alter table public.missao_progresso   enable row level security;
alter table public.certificados       enable row level security;

-- catálogo: leitura pública para usuários autenticados
drop policy if exists "catalogo_leitura" on public.cursos;
create policy "catalogo_leitura" on public.cursos       for select using (auth.role() = 'authenticated');
drop policy if exists "modulos_leitura" on public.modulos;
create policy "modulos_leitura" on public.modulos       for select using (auth.role() = 'authenticated');
drop policy if exists "aulas_leitura" on public.aulas;
create policy "aulas_leitura" on public.aulas         for select using (auth.role() = 'authenticated');
drop policy if exists "skills_leitura" on public.skills;
create policy "skills_leitura" on public.skills        for select using (auth.role() = 'authenticated');
drop policy if exists "prompts_leitura" on public.prompts;
create policy "prompts_leitura" on public.prompts       for select using (auth.role() = 'authenticated' and publico);
drop policy if exists "squads_leitura" on public.squads;
create policy "squads_leitura" on public.squads        for select using (auth.role() = 'authenticated');
drop policy if exists "squad_cursos_leitura" on public.squad_cursos;
create policy "squad_cursos_leitura" on public.squad_cursos for select using (auth.role() = 'authenticated');
drop policy if exists "apps_leitura" on public.aplicativos;
create policy "apps_leitura" on public.aplicativos   for select using (auth.role() = 'authenticated');
drop policy if exists "missoes_leitura" on public.missoes;
create policy "missoes_leitura" on public.missoes       for select using (auth.role() = 'authenticated');

-- prompts públicos: qualquer autenticado cria; só o autor edita/apaga
drop policy if exists "prompts_criar" on public.prompts;
create policy "prompts_criar" on public.prompts for insert with check (auth.uid() = criado_por);
drop policy if exists "prompts_editar" on public.prompts;
create policy "prompts_editar" on public.prompts for update using (auth.uid() = criado_por) with check (auth.uid() = criado_por);
drop policy if exists "prompts_apagar" on public.prompts;
create policy "prompts_apagar" on public.prompts for delete using (auth.uid() = criado_por);

-- progresso: usuário só vê e mexe no que é dele
drop policy if exists "inscricoes_dono" on public.inscricoes;
create policy "inscricoes_dono" on public.inscricoes       for all using (auth.uid() = usuario_id) with check (auth.uid() = usuario_id);
drop policy if exists "aulas_dono" on public.aulas_concluidas;
create policy "aulas_dono" on public.aulas_concluidas for all using (auth.uid() = usuario_id) with check (auth.uid() = usuario_id);
drop policy if exists "salvos_dono" on public.prompts_salvos;
create policy "salvos_dono" on public.prompts_salvos   for all using (auth.uid() = usuario_id) with check (auth.uid() = usuario_id);
drop policy if exists "favoritos_dono" on public.favoritos;
create policy "favoritos_dono" on public.favoritos        for all using (auth.uid() = usuario_id) with check (auth.uid() = usuario_id);
drop policy if exists "missao_dono" on public.missao_progresso;
create policy "missao_dono" on public.missao_progresso for all using (auth.uid() = usuario_id) with check (auth.uid() = usuario_id);
drop policy if exists "certificados_dono" on public.certificados;
create policy "certificados_dono" on public.certificados     for select using (auth.uid() = usuario_id);

-- perfil: dono lê e edita
drop policy if exists "perfil_dono" on public.perfis;
create policy "perfil_dono" on public.perfis for select using (auth.uid() = id);
drop policy if exists "perfil_editar" on public.perfis;
create policy "perfil_editar" on public.perfis for update using (auth.uid() = id) with check (auth.uid() = id);

-- ---------- índices ----------
create index if not exists idx_cursos_categoria on public.cursos(categoria);
create index if not exists idx_modulos_curso on public.modulos(curso_id);
create index if not exists idx_aulas_modulo on public.aulas(modulo_id);
create index if not exists idx_prompts_categoria on public.prompts(categoria);
create index if not exists idx_squad_cursos_squad on public.squad_cursos(squad_id);
