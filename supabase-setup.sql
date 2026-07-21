-- Run this once in your Supabase project's SQL Editor (Dashboard > SQL Editor > New query).

create table public.entries (
  id text primary key,
  school text not null,
  who text not null,
  city text not null,
  lat double precision not null,
  lng double precision not null,
  color text not null,
  color2 text not null,
  wiki text,
  ref_points jsonb,
  owner_id uuid references auth.users(id) not null,
  owner_email text not null,
  created_at timestamptz default now()
);

alter table public.entries enable row level security;

-- anyone (including signed-out visitors) can read the whole roster
create policy "Entries are viewable by everyone"
  on public.entries for select
  using (true);

-- only a signed-in user can add an entry, and only as themselves
create policy "Users can insert their own entries"
  on public.entries for insert
  with check (auth.uid() = owner_id);

-- only the owner can edit their own entry
create policy "Users can update their own entries"
  on public.entries for update
  using (auth.uid() = owner_id);

-- only the owner can delete their own entry
create policy "Users can delete their own entries"
  on public.entries for delete
  using (auth.uid() = owner_id);
