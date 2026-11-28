-- 0006: aula travada com liberação programada
-- bloqueada = true  -> a aula só libera depois de libera_em_dias dias
-- libera_em_dias    -> dias contados a partir do início do aluno no curso (inscricoes.criada_em)
alter table public.aulas
  add column if not exists bloqueada boolean not null default false;

alter table public.aulas
  add column if not exists libera_em_dias int not null default 0;

alter table public.aulas
  drop constraint if exists aulas_libera_em_dias_check;
alter table public.aulas
  add constraint aulas_libera_em_dias_check check (libera_em_dias between 0 and 365);

alter table public.inscricoes
  add column if not exists criada_em timestamptz not null default now();
