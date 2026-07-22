-- Run this once in your Supabase project's SQL Editor to bring the existing
-- entries table up to date with the private-per-account model and break data.

drop policy if exists "Entries are viewable by everyone" on public.entries;

create policy "Users can view their own entries"
  on public.entries for select
  using (auth.uid() = owner_id);

alter table public.entries add column if not exists breaks jsonb default '[]'::jsonb;
