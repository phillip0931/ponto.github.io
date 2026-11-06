-- Resgatécnica | Ponto e Visitas
-- Execute este arquivo inteiro no Supabase > SQL Editor > New query.
create table if not exists public.punches (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,
 punched_at timestamptz not null,
 created_at timestamptz not null default now(),
 constraint punches_user_time_unique unique(user_id,punched_at)
);
create table if not exists public.visits (
 id uuid primary key,
 user_id uuid not null references auth.users(id) on delete cascade,
 client text not null, reason text not null default '', notes text not null default '',
 started_at timestamptz not null, ended_at timestamptz, photo_path text,
 created_at timestamptz not null default now()
);
create table if not exists public.user_settings (
 user_id uuid primary key references auth.users(id) on delete cascade,
 daily_goal numeric(4,1) not null default 8 check(daily_goal>0 and daily_goal<=24),
 updated_at timestamptz not null default now()
);
create index if not exists punches_user_time_idx on public.punches(user_id,punched_at desc);
create index if not exists visits_user_time_idx on public.visits(user_id,started_at desc);
alter table public.punches enable row level security;
alter table public.visits enable row level security;
alter table public.user_settings enable row level security;
revoke all on public.punches,public.visits,public.user_settings from anon;
grant select,insert,update,delete on public.punches,public.visits,public.user_settings to authenticated;
drop policy if exists punches_select_own on public.punches;
drop policy if exists punches_insert_own on public.punches;
drop policy if exists punches_update_own on public.punches;
drop policy if exists punches_delete_own on public.punches;
create policy punches_select_own on public.punches for select to authenticated using((select auth.uid())=user_id);
create policy punches_insert_own on public.punches for insert to authenticated with check((select auth.uid())=user_id);
create policy punches_update_own on public.punches for update to authenticated using((select auth.uid())=user_id) with check((select auth.uid())=user_id);
create policy punches_delete_own on public.punches for delete to authenticated using((select auth.uid())=user_id);
drop policy if exists visits_select_own on public.visits;
drop policy if exists visits_insert_own on public.visits;
drop policy if exists visits_update_own on public.visits;
drop policy if exists visits_delete_own on public.visits;
create policy visits_select_own on public.visits for select to authenticated using((select auth.uid())=user_id);
create policy visits_insert_own on public.visits for insert to authenticated with check((select auth.uid())=user_id);
create policy visits_update_own on public.visits for update to authenticated using((select auth.uid())=user_id) with check((select auth.uid())=user_id);
create policy visits_delete_own on public.visits for delete to authenticated using((select auth.uid())=user_id);
drop policy if exists settings_select_own on public.user_settings;
drop policy if exists settings_insert_own on public.user_settings;
drop policy if exists settings_update_own on public.user_settings;
drop policy if exists settings_delete_own on public.user_settings;
create policy settings_select_own on public.user_settings for select to authenticated using((select auth.uid())=user_id);
create policy settings_insert_own on public.user_settings for insert to authenticated with check((select auth.uid())=user_id);
create policy settings_update_own on public.user_settings for update to authenticated using((select auth.uid())=user_id) with check((select auth.uid())=user_id);
create policy settings_delete_own on public.user_settings for delete to authenticated using((select auth.uid())=user_id);
insert into storage.buckets(id,name,public,file_size_limit,allowed_mime_types)
values('visit-photos','visit-photos',false,5242880,array['image/jpeg'])
on conflict(id) do update set public=false,file_size_limit=5242880,allowed_mime_types=array['image/jpeg'];
drop policy if exists visit_photos_select_own on storage.objects;
drop policy if exists visit_photos_insert_own on storage.objects;
drop policy if exists visit_photos_update_own on storage.objects;
drop policy if exists visit_photos_delete_own on storage.objects;
create policy visit_photos_select_own on storage.objects for select to authenticated using(bucket_id='visit-photos' and (storage.foldername(name))[1]=(select auth.uid())::text);
create policy visit_photos_insert_own on storage.objects for insert to authenticated with check(bucket_id='visit-photos' and (storage.foldername(name))[1]=(select auth.uid())::text);
create policy visit_photos_update_own on storage.objects for update to authenticated using(bucket_id='visit-photos' and (storage.foldername(name))[1]=(select auth.uid())::text) with check(bucket_id='visit-photos' and (storage.foldername(name))[1]=(select auth.uid())::text);
create policy visit_photos_delete_own on storage.objects for delete to authenticated using(bucket_id='visit-photos' and (storage.foldername(name))[1]=(select auth.uid())::text);
