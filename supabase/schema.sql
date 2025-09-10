-- Extensions utiles
create extension if not exists unaccent;

-- Athlètes
create table if not exists public.athletes (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  normalized text generated always as (
    lower(unaccent(regexp_replace(name,'[^a-zA-Z0-9 ]','','g')))
  ) stored,
  category text not null check (category in
    ('Football','Tennis','Basket','Rugby','Formule1','Cyclisme','Handball','Athlétisme')
  )
);
create index if not exists athletes_category_idx on public.athletes(category);
create index if not exists athletes_norm_idx on public.athletes(normalized);

-- Scores
create table if not exists public.scores (
  id uuid primary key default gen_random_uuid(),
  player text not null,
  points int not null,
  mode text not null,
  created_at timestamptz default now()
);

-- RLS
alter table public.athletes enable row level security;
alter table public.scores enable row level security;

create policy "read athletes" on public.athletes for select using (true);
create policy "insert scores" on public.scores  for insert with check (true);
create policy "read scores"   on public.scores  for select using (true);
