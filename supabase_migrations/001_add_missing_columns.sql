-- Books: reading status and per-book lending switch
alter table public.books
  add column if not exists reading_status text not null default 'to_read'
    check (reading_status in ('to_read', 'reading', 'finished')),
  add column if not exists allow_lending boolean not null default true;

-- Posts: thought or question
alter table public.posts
  add column if not exists post_type text not null default 'thought'
    check (post_type in ('thought', 'question'));

-- Profiles: user settings
alter table public.profiles
  add column if not exists default_book_visibility text not null default 'public'
    check (default_book_visibility in ('public', 'private')),
  add column if not exists allow_borrowing boolean not null default true;
