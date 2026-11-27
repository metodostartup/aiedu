-- ============================================================
-- AI Edu — foto de perfil do aluno
-- ============================================================

alter table public.perfis add column if not exists avatar_url text not null default '';

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'avatars', 'avatars', true, 2097152,
  array['image/png','image/jpeg','image/webp']
)
on conflict (id) do update
  set public = true,
      file_size_limit = excluded.file_size_limit,
      allowed_mime_types = excluded.allowed_mime_types;

-- leitura pública da foto; escrita só na própria pasta avatars/<uid>/…
drop policy if exists "avatars_leitura" on storage.objects;
create policy "avatars_leitura" on storage.objects
  for select to authenticated using (bucket_id = 'avatars');

drop policy if exists "avatars_dono_upload" on storage.objects;
create policy "avatars_dono_upload" on storage.objects
  for insert to authenticated with check (
    bucket_id = 'avatars' and (storage.foldername(name))[1] = auth.uid()::text
  );

drop policy if exists "avatars_dono_editar" on storage.objects;
create policy "avatars_dono_editar" on storage.objects
  for update to authenticated using (
    bucket_id = 'avatars' and (storage.foldername(name))[1] = auth.uid()::text
  );

drop policy if exists "avatars_dono_apagar" on storage.objects;
create policy "avatars_dono_apagar" on storage.objects
  for delete to authenticated using (
    bucket_id = 'avatars' and (storage.foldername(name))[1] = auth.uid()::text
  );
