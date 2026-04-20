-- ============================================================
-- 볼드 브랜드 사이트 - Supabase 스키마
-- ============================================================
-- 실행 방법: Supabase Dashboard → SQL Editor → 새 쿼리 → 아래 전체 붙여넣기 실행
-- ============================================================

-- 1. 사이트 전역 설정 테이블 (site_name, 로고, SEO 등 단일 레코드)
create table if not exists public.site_settings (
  id int primary key default 1,
  site_name text default '볼드',
  site_tagline text default 'BOLD',
  logo_url text,
  favicon_url text,
  footer_text text default 'COPYRIGHT (c) BOLD ALL RIGHTS RESERVED.',
  contact_email text,
  contact_phone text,
  contact_address text,
  social_instagram text,
  social_youtube text,
  social_facebook text,
  seo_description text,
  theme_primary_color text default '#0a0a0a',
  theme_accent_color text default '#ff3b30',
  updated_at timestamptz default now(),
  constraint single_row check (id = 1)
);

-- 단일 레코드 초기화
insert into public.site_settings (id) values (1)
on conflict (id) do nothing;

-- 2. 섹션 테이블 (히어로, 어바웃, 갤러리 등 자유롭게 추가/삭제)
create table if not exists public.sections (
  id uuid primary key default gen_random_uuid(),
  slug text unique not null,                 -- hero, about, gallery, contact 등
  type text not null,                         -- hero | text | image_text | gallery | cta | footer
  title text,
  subtitle text,
  body text,
  image_url text,
  link_label text,
  link_url text,
  extra jsonb default '{}'::jsonb,            -- 타입별 확장 필드
  sort_order int default 0,
  is_visible boolean default true,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create index if not exists sections_sort_idx
  on public.sections (sort_order, created_at);

-- 3. 아이템 테이블 (갤러리 카드, 상품, 포트폴리오 등 섹션에 속한 다수 항목)
create table if not exists public.items (
  id uuid primary key default gen_random_uuid(),
  section_id uuid references public.sections(id) on delete cascade,
  title text,
  subtitle text,
  description text,
  image_url text,
  link_url text,
  tag text,
  price text,                                 -- 쇼핑몰성 확장 대비
  extra jsonb default '{}'::jsonb,
  sort_order int default 0,
  is_visible boolean default true,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create index if not exists items_section_idx
  on public.items (section_id, sort_order);

-- 4. updated_at 자동 갱신 트리거
create or replace function public.touch_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

drop trigger if exists trg_site_settings_touch on public.site_settings;
create trigger trg_site_settings_touch
  before update on public.site_settings
  for each row execute procedure public.touch_updated_at();

drop trigger if exists trg_sections_touch on public.sections;
create trigger trg_sections_touch
  before update on public.sections
  for each row execute procedure public.touch_updated_at();

drop trigger if exists trg_items_touch on public.items;
create trigger trg_items_touch
  before update on public.items
  for each row execute procedure public.touch_updated_at();

-- 5. RLS (공개 사이트는 읽기만, 쓰기는 인증된 관리자만)
alter table public.site_settings enable row level security;
alter table public.sections enable row level security;
alter table public.items enable row level security;

-- 익명 읽기 허용 (공개 사이트용)
drop policy if exists "public read site_settings" on public.site_settings;
create policy "public read site_settings"
  on public.site_settings for select
  to anon, authenticated using (true);

drop policy if exists "public read sections" on public.sections;
create policy "public read sections"
  on public.sections for select
  to anon, authenticated using (is_visible = true);

drop policy if exists "public read items" on public.items;
create policy "public read items"
  on public.items for select
  to anon, authenticated using (is_visible = true);

-- 인증된 사용자만 쓰기 허용 (관리자 로그인 후)
drop policy if exists "auth write site_settings" on public.site_settings;
create policy "auth write site_settings"
  on public.site_settings for all
  to authenticated using (true) with check (true);

drop policy if exists "auth write sections" on public.sections;
create policy "auth write sections"
  on public.sections for all
  to authenticated using (true) with check (true);

drop policy if exists "auth write items" on public.items;
create policy "auth write items"
  on public.items for all
  to authenticated using (true) with check (true);

-- 관리자용: 관리자 페이지에서는 숨김 항목도 봐야 하므로 전체 select 별도 허용
drop policy if exists "auth read all sections" on public.sections;
create policy "auth read all sections"
  on public.sections for select
  to authenticated using (true);

drop policy if exists "auth read all items" on public.items;
create policy "auth read all items"
  on public.items for select
  to authenticated using (true);

-- 6. Storage 버킷 (이미지 업로드용) - 별도로 Storage 메뉴에서 수동 생성
-- 버킷명: bold-media  (public 읽기 허용)

-- 7. 샘플 데이터 (원하는 경우 주석 해제)
-- insert into public.sections (slug, type, title, subtitle, body, sort_order)
-- values
--   ('hero', 'hero', 'BOLD', '대담한 브랜드, 새로운 감각', '우리는 당신의 이야기를 대담하게 풀어냅니다.', 1),
--   ('about', 'text', 'ABOUT', '브랜드 소개', '볼드는 전주에 기반을 둔 창작 스튜디오입니다...', 2),
--   ('gallery', 'gallery', 'WORKS', '우리의 작업', '진행한 프로젝트를 소개합니다.', 3),
--   ('contact', 'cta', 'CONTACT', '문의하기', '함께 작업하고 싶으신가요?', 4);
