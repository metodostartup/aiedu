-- ============================================================
-- AI Edu — Ferramentas: catálogo com foto, arquivo para download ou link
-- ============================================================

create table if not exists public.ferramentas (
  id uuid primary key default gen_random_uuid(),
  titulo text not null,
  descricao text not null default '',
  categoria text not null default 'Ferramenta',
  imagem_url text not null default '',
  arquivo_url text not null default '',
  arquivo_nome text not null default '',
  link_url text not null default '',
  ativo boolean not null default true,
  ordem int not null default 0,
  criado_em timestamptz not null default now()
);

create index if not exists ferramentas_ordem_idx on public.ferramentas (ativo, ordem, criado_em);

alter table public.ferramentas enable row level security;

drop policy if exists "ferramentas_leitura" on public.ferramentas;
create policy "ferramentas_leitura" on public.ferramentas
  for select to authenticated using (ativo);

drop policy if exists "ferramentas_admin_total" on public.ferramentas;
create policy "ferramentas_admin_total" on public.ferramentas
  for all to authenticated using (public.eh_admin()) with check (public.eh_admin());

-- ---------- bucket de mídia das ferramentas (foto + arquivo) ----------
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'ferramentas', 'ferramentas', true, 52428800,
  array[
    'image/png','image/jpeg','image/webp','image/avif',
    'application/pdf','application/zip','application/x-zip-compressed',
    'application/octet-stream','text/plain',
    'application/msword','application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'application/vnd.ms-excel','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    'application/vnd.ms-powerpoint','application/vnd.openxmlformats-officedocument.presentationml.presentation'
  ]
)
on conflict (id) do update
  set public = true,
      file_size_limit = excluded.file_size_limit,
      allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists "ferramentas_midia_leitura" on storage.objects;
create policy "ferramentas_midia_leitura" on storage.objects
  for select to authenticated using (bucket_id = 'ferramentas');

drop policy if exists "ferramentas_midia_upload" on storage.objects;
create policy "ferramentas_midia_upload" on storage.objects
  for insert to authenticated with check (bucket_id = 'ferramentas' and public.eh_admin());

drop policy if exists "ferramentas_midia_editar" on storage.objects;
create policy "ferramentas_midia_editar" on storage.objects
  for update to authenticated using (bucket_id = 'ferramentas' and public.eh_admin());

drop policy if exists "ferramentas_midia_apagar" on storage.objects;
create policy "ferramentas_midia_apagar" on storage.objects
  for delete to authenticated using (bucket_id = 'ferramentas' and public.eh_admin());
