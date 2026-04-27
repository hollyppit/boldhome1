-- ============================================================
-- 볼드 사이트 - 한/영 다국어(i18n) 마이그레이션
-- ============================================================
-- 실행 방법: Supabase Dashboard → SQL Editor → 새 쿼리 → 아래 전체 붙여넣기 실행
-- 기존 데이터 보존: 안전한 ADD COLUMN IF NOT EXISTS만 사용합니다.
-- ============================================================

-- 1) site_settings: 사이트 전역 텍스트의 영문 버전
alter table public.site_settings
  add column if not exists site_name_en        text,
  add column if not exists site_tagline_en     text,
  add column if not exists footer_text_en      text,
  add column if not exists seo_description_en  text,
  add column if not exists contact_address_en  text;

-- 2) sections: 섹션 단위의 영문 콘텐츠
alter table public.sections
  add column if not exists title_en      text,
  add column if not exists subtitle_en   text,
  add column if not exists body_en       text,
  add column if not exists link_label_en text;

-- 3) items: 갤러리 카드 / 슬라이드의 영문 콘텐츠
alter table public.items
  add column if not exists title_en       text,
  add column if not exists subtitle_en    text,
  add column if not exists description_en text,
  add column if not exists tag_en         text;

-- ============================================================
-- 끝. 기존 한글 컬럼은 그대로 유지되고, *_en 컬럼이 비어있으면
-- 사이트는 자동으로 한글 값으로 폴백합니다.
-- ============================================================
