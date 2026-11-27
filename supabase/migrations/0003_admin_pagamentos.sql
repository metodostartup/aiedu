-- ============================================================
-- NEXORA AI — Camada admin + pagamentos/configurações
-- ============================================================

-- ---------- papel de admin ----------
alter table public.perfis add column if not exists papel text not null default 'aluno';

-- helper: é admin? (security definer para usar dentro de policies)
create or replace function public.eh_admin() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.perfis where id = auth.uid() and papel = 'admin');
$$;

-- ---------- configurações da plataforma (pagamentos, chave PIX, preços etc.) ----------
create table if not exists public.configuracoes (
  chave text primary key,                -- ex.: 'pagamento', 'plano'
  valor jsonb not null default '{}'::jsonb,
  atualizado_em timestamptz not null default now()
);

-- ---------- políticas admin ----------
-- catálogo: admin tem controle total
do $$
declare t text;
begin
  foreach t in array array['cursos','modulos','aulas','skills','prompts','squads','squad_cursos','aplicativos','missoes']
  loop
    execute format('drop policy if exists "admin_total" on public.%I', t);
    execute format('create policy "admin_total" on public.%I for all using (public.eh_admin()) with check (public.eh_admin())', t);
  end loop;
end $$;

-- prompts: admin vê também os não públicos
drop policy if exists "prompts_admin_ler" on public.prompts;
create policy "prompts_admin_ler" on public.prompts for select using (public.eh_admin());

-- perfis: admin lista e gerencia todos os usuários
drop policy if exists "perfis_admin_ler" on public.perfis;
create policy "perfis_admin_ler" on public.perfis for select using (public.eh_admin());
drop policy if exists "perfis_admin_editar" on public.perfis;
create policy "perfis_admin_editar" on public.perfis for update using (public.eh_admin()) with check (public.eh_admin());
drop policy if exists "perfis_admin_apagar" on public.perfis;
create policy "perfis_admin_apagar" on public.perfis for delete using (public.eh_admin());

-- configurações: todos autenticados leem; só admin escreve
alter table public.configuracoes enable row level security;
drop policy if exists "config_leitura" on public.configuracoes;
create policy "config_leitura" on public.configuracoes for select using (auth.role() = 'authenticated');
drop policy if exists "config_admin" on public.configuracoes;
create policy "config_admin" on public.configuracoes for all using (public.eh_admin()) with check (public.eh_admin());

-- ---------- admin inicial ----------
update public.perfis set papel = 'admin'
where id in (select id from auth.users where email = 'teste@nexora.ai');

-- valores padrão de pagamento
insert into public.configuracoes (chave, valor) values
  ('plano', '{"nome":"Vitalício","preco":497,"parcelas":"12x R$ 48,63","moeda":"BRL","ativo":true}'),
  ('pagamento', '{"metodo":"pix","chave_pix":"","link_checkout":"","garantia_dias":7}')
on conflict (chave) do nothing;
