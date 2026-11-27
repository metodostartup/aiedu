-- ============================================================
-- AI Edu — mídias: capa de curso (upload) e vídeos de aula (upload/link)
-- ============================================================

-- capa enviada por upload (URL pública do storage); 'capa' continua
-- sendo a chave do SVG de fallback
alter table public.cursos add column if not exists capa_url text not null default '';

-- ---------- buckets ----------
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'capas', 'capas', true, 5242880,
  array['image/png','image/jpeg','image/webp','image/avif']
)
on conflict (id) do update
  set public = true,
      file_size_limit = excluded.file_size_limit,
      allowed_mime_types = excluded.allowed_mime_types;

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'videos', 'videos', true, 524288000,
  array['video/mp4','video/webm','video/quicktime']
)
on conflict (id) do update
  set public = true,
      file_size_limit = excluded.file_size_limit,
      allowed_mime_types = excluded.allowed_mime_types;

-- ---------- políticas de storage ----------
-- leitura (as URLs públicas não dependem disto, mas mantém a listagem coerente)
drop policy if exists "midias_leitura" on storage.objects;
create policy "midias_leitura" on storage.objects
  for select to authenticated using (bucket_id in ('capas','videos'));

-- escrita: somente admin
drop policy if exists "capas_admin_upload" on storage.objects;
create policy "capas_admin_upload" on storage.objects
  for insert to authenticated with check (bucket_id = 'capas' and public.eh_admin());

drop policy if exists "capas_admin_editar" on storage.objects;
create policy "capas_admin_editar" on storage.objects
  for update to authenticated using (bucket_id = 'capas' and public.eh_admin());

drop policy if exists "capas_admin_apagar" on storage.objects;
create policy "capas_admin_apagar" on storage.objects
  for delete to authenticated using (bucket_id = 'capas' and public.eh_admin());

drop policy if exists "videos_admin_upload" on storage.objects;
create policy "videos_admin_upload" on storage.objects
  for insert to authenticated with check (bucket_id = 'videos' and public.eh_admin());

drop policy if exists "videos_admin_editar" on storage.objects;
create policy "videos_admin_editar" on storage.objects
  for update to authenticated using (bucket_id = 'videos' and public.eh_admin());

drop policy if exists "videos_admin_apagar" on storage.objects;
create policy "videos_admin_apagar" on storage.objects
  for delete to authenticated using (bucket_id = 'videos' and public.eh_admin());
