-- ==============================================================================
-- MineOut Database Schema & Row Level Security (RLS) Policies
-- Run this script in the Supabase SQL Editor (Dashboard -> SQL Editor -> New Query)
-- ==============================================================================

-- 1. PROFILES TABLE (Linked to auth.users)
create table if not exists public.profiles (
  id uuid references auth.users(id) on delete cascade primary key,
  full_name text,
  email text,
  avatar_url text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Enable RLS on profiles
alter table public.profiles enable row level security;

-- Profiles RLS policies: Users can only select, update, or insert their own profile
create policy "Users can view their own profile" 
  on public.profiles for select 
  using (auth.uid() = id);

create policy "Users can update their own profile" 
  on public.profiles for update 
  using (auth.uid() = id);

create policy "Users can insert their own profile" 
  on public.profiles for insert 
  with check (auth.uid() = id);

-- Trigger to automatically create a profile row when a new user signs up
create or replace function public.handle_new_user() 
returns trigger as $$
begin
  insert into public.profiles (id, full_name, email, avatar_url)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'full_name', split_part(new.email, '@', 1)),
    new.email,
    new.raw_user_meta_data->>'avatar_url'
  );
  return new;
end;
$$ language plpgsql security definer;

-- Drop existing trigger if it exists then create
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();


-- 2. NOTEBOOKS / BOOKS TABLE
create table if not exists public.books (
  id text primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  title text not null,
  description text default '',
  color text not null default 'pink',
  icon text not null default 'heart',
  pattern text default 'frame',
  is_favorite boolean default false,
  is_archived boolean default false,
  notes_count integer default 0,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Enable RLS on books
alter table public.books enable row level security;

create policy "Users can view own books"
  on public.books for select
  using (auth.uid() = user_id);

create policy "Users can insert own books"
  on public.books for insert
  with check (auth.uid() = user_id);

create policy "Users can update own books"
  on public.books for update
  using (auth.uid() = user_id);

create policy "Users can delete own books"
  on public.books for delete
  using (auth.uid() = user_id);


-- 3. NOTES TABLE
create table if not exists public.notes (
  id text primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  book_id text references public.books(id) on delete cascade not null,
  title text not null,
  content text default '',
  tags text[] default '{}',
  is_pinned boolean default false,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Enable RLS on notes
alter table public.notes enable row level security;

create policy "Users can view own notes"
  on public.notes for select
  using (auth.uid() = user_id);

create policy "Users can insert own notes"
  on public.notes for insert
  with check (auth.uid() = user_id);

create policy "Users can update own notes"
  on public.notes for update
  using (auth.uid() = user_id);

create policy "Users can delete own notes"
  on public.notes for delete
  using (auth.uid() = user_id);


-- 4. TASKS TABLE
create table if not exists public.tasks (
  id text primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  text text not null,
  completed boolean default false,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Enable RLS on tasks
alter table public.tasks enable row level security;

create policy "Users can view own tasks"
  on public.tasks for select
  using (auth.uid() = user_id);

create policy "Users can insert own tasks"
  on public.tasks for insert
  with check (auth.uid() = user_id);

create policy "Users can update own tasks"
  on public.tasks for update
  using (auth.uid() = user_id);

create policy "Users can delete own tasks"
  on public.tasks for delete
  using (auth.uid() = user_id);


-- 5. FLASHCARDS TABLE
create table if not exists public.flashcards (
  id text primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  front text not null,
  back text not null,
  tags text[] default '{}',
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Enable RLS on flashcards
alter table public.flashcards enable row level security;

create policy "Users can view own flashcards"
  on public.flashcards for select
  using (auth.uid() = user_id);

create policy "Users can insert own flashcards"
  on public.flashcards for insert
  with check (auth.uid() = user_id);

create policy "Users can update own flashcards"
  on public.flashcards for update
  using (auth.uid() = user_id);

create policy "Users can delete own flashcards"
  on public.flashcards for delete
  using (auth.uid() = user_id);


-- 6. FILES METADATA TABLE
create table if not exists public.files (
  id text primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  name text not null,
  size bigint default 0,
  type text default '',
  url text,
  book_id text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Enable RLS on files
alter table public.files enable row level security;

create policy "Users can view own files"
  on public.files for select
  using (auth.uid() = user_id);

create policy "Users can insert own files"
  on public.files for insert
  with check (auth.uid() = user_id);

create policy "Users can update own files"
  on public.files for update
  using (auth.uid() = user_id);

create policy "Users can delete own files"
  on public.files for delete
  using (auth.uid() = user_id);


-- 7. SUPABASE STORAGE BUCKET & RLS POLICIES FOR PRIVATE USER FILES
-- Create a private bucket called 'mineout-storage'
insert into storage.buckets (id, name, public) 
values ('mineout-storage', 'mineout-storage', false)
on conflict (id) do nothing;

-- Storage policies: Users can upload, read, update, delete files in their own folder (auth.uid())
create policy "Users can upload their own files"
  on storage.objects for insert
  with check (
    bucket_id = 'mineout-storage' 
    and auth.uid() = (storage.foldername(name))[1]::uuid
  );

create policy "Users can view their own files"
  on storage.objects for select
  using (
    bucket_id = 'mineout-storage' 
    and auth.uid() = (storage.foldername(name))[1]::uuid
  );

create policy "Users can update their own files"
  on storage.objects for update
  using (
    bucket_id = 'mineout-storage' 
    and auth.uid() = (storage.foldername(name))[1]::uuid
  );

create policy "Users can delete their own files"
  on storage.objects for delete
  using (
    bucket_id = 'mineout-storage' 
    and auth.uid() = (storage.foldername(name))[1]::uuid
  );
