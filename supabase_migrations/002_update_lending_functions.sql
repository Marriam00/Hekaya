-- 1) Borrow request validation: respect allow_lending / allow_borrowing, block duplicates
create or replace function public.prepare_borrow_request()
returns trigger
language plpgsql
security definer
set search_path to ''
as $function$
declare
  b public.books;
begin
  new.requester_id := coalesce(auth.uid(), new.requester_id);

  select * into b from public.books where id = new.book_id;
  if not found or b.visibility <> 'public' then
    raise exception 'This book is not available for borrowing';
  end if;
  if b.owner_id = new.requester_id then
    raise exception 'You cannot request your own book';
  end if;
  if not b.allow_lending then
    raise exception 'The owner is not lending this book';
  end if;
  if exists (
    select 1 from public.profiles
    where id = b.owner_id and allow_borrowing = false
  ) then
    raise exception 'This member is not accepting borrow requests';
  end if;
  if exists (
    select 1 from public.loans where book_id = new.book_id and status = 'active'
  ) then
    raise exception 'This book is currently on loan';
  end if;
  if exists (
    select 1 from public.borrow_requests
    where book_id = new.book_id
      and requester_id = new.requester_id
      and status = 'pending'
  ) then
    raise exception 'You already have a pending request for this book';
  end if;

  new.owner_id := b.owner_id;
  new.status   := 'pending';
  return new;
end;
$function$;

-- 2) Accepting a request now sets a due date (21 days)
create or replace function public.respond_to_borrow_request(p_request_id uuid, p_accept boolean)
returns void
language plpgsql
security definer
set search_path to ''
as $function$
declare
  r public.borrow_requests;
  b public.books;
begin
  if not public.is_approved_member() then
    raise exception 'Not an approved member';
  end if;

  select * into r from public.borrow_requests where id = p_request_id for update;
  if not found then
    raise exception 'Request not found';
  end if;
  if r.owner_id <> auth.uid() then
    raise exception 'Only the book owner can respond to this request';
  end if;
  if r.status <> 'pending' then
    raise exception 'This request is no longer pending';
  end if;

  if p_accept then
    select * into b from public.books where id = r.book_id for update;
    if b.visibility <> 'public' then
      raise exception 'This book is no longer public';
    end if;
    if exists (
      select 1 from public.loans where book_id = r.book_id and status = 'active'
    ) then
      raise exception 'This book is already on loan';
    end if;

    insert into public.loans (book_id, borrower_id, owner_id, request_id, expected_return_at)
    values (r.book_id, r.requester_id, r.owner_id, r.id, now() + interval '21 days');

    update public.borrow_requests set status = 'accepted' where id = r.id;
  else
    update public.borrow_requests set status = 'rejected' where id = r.id;
  end if;
end;
$function$;
