-- ============================================================
-- 볼드 포트폴리오 샘플 데이터 (1회 실행)
-- ============================================================
-- Supabase Dashboard → SQL Editor → 새 쿼리 → 전체 붙여넣기 → Run
-- 관리자 페이지에서 텍스트/이미지만 교체하면 실제 포트폴리오가 됩니다.
-- ============================================================

-- (주의) 기존 sections/items를 모두 지우고 새로 넣습니다.
-- 이미 작업 중인 내용이 있다면 먼저 백업하세요 (admin.html → 내보내기).

begin;

delete from public.items;
delete from public.sections;

-- 1) 테마 색: 남색 + 흰색 + 오렌지 포인트
update public.site_settings
set theme_primary_color = '#0a1f44',
    theme_accent_color  = '#ff6b1a',
    site_name           = coalesce(nullif(site_name,''), '볼드'),
    site_tagline        = coalesce(nullif(site_tagline,''), 'BOLD'),
    seo_description     = coalesce(nullif(seo_description,''),
                                   'BOLD — 포트폴리오 스튜디오')
where id = 1;

-- 2) 대문 (hero + 슬라이드 3장)
with hero as (
  insert into public.sections (slug, type, title, subtitle, body, link_label, link_url, sort_order)
  values (
    'hero', 'hero',
    'BOLD',
    'PORTFOLIO',
    E'대담한 시선으로 이야기를 풀어냅니다.\n기획과 실행 사이, 그 균형점에서 태어난 스튜디오.',
    'WORKS 보기', '#works',
    1
  ) returning id
)
insert into public.items (section_id, title, subtitle, image_url, sort_order)
select hero.id, t.title, t.subtitle, t.img, t.ord
from hero, (values
  ('Campaign 01', 'BRAND IDENTITY',
   'https://images.unsplash.com/photo-1558769132-cb1aea458c5e?w=1600&q=80', 1),
  ('Editorial 02', 'ART DIRECTION',
   'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=1600&q=80', 2),
  ('Poster 03', 'GRAPHIC DESIGN',
   'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=1600&q=80', 3)
) as t(title, subtitle, img, ord);

-- 3) 소개 (text)
insert into public.sections (slug, type, title, subtitle, body, sort_order)
values (
  'about', 'text', 'ABOUT', '브랜드 소개',
  E'BOLD는 전주에 기반을 둔 창작 스튜디오입니다.\n\n이야기와 이미지, 태도가 만나는 지점에서 브랜드를 설계합니다. 크기가 아닌 밀도로 승부하며, 한 번의 좋은 선택이 열 개의 평범함을 이긴다고 믿습니다.',
  2
);

-- 4) 작업물 (gallery + 아이템 6개)
with works as (
  insert into public.sections (slug, type, title, subtitle, body, sort_order)
  values (
    'works', 'gallery',
    'WORKS', '포트폴리오',
    '최근 진행한 프로젝트들입니다. 썸네일을 클릭하면 상세로 이동합니다.',
    3
  ) returning id
)
insert into public.items (section_id, title, subtitle, tag, image_url, link_url, sort_order)
select works.id, t.title, t.subtitle, t.tag, t.img, t.url, t.ord
from works, (values
  ('Project 01', 'Brand Identity', 'NEW',
   'https://images.unsplash.com/photo-1558769132-cb1aea458c5e?w=800&q=80', '#', 1),
  ('Project 02', 'Editorial', NULL,
   'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=800&q=80', '#', 2),
  ('Project 03', 'Campaign', NULL,
   'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800&q=80', '#', 3),
  ('Project 04', 'Art Direction', NULL,
   'https://images.unsplash.com/photo-1492707892479-7bc8d5a4ee93?w=800&q=80', '#', 4),
  ('Project 05', 'Poster', 'HOT',
   'https://images.unsplash.com/photo-1534551767192-78b8dd45b51b?w=800&q=80', '#', 5),
  ('Project 06', 'Packaging', NULL,
   'https://images.unsplash.com/photo-1561070791-2526d30994b8?w=800&q=80', '#', 6)
) as t(title, subtitle, tag, img, url, ord);

-- 5) 철학 (image_text)
insert into public.sections (slug, type, title, body, image_url, sort_order)
values (
  'philosophy', 'image_text',
  'PHILOSOPHY',
  E'우리의 작업은 장식이 아닌 전략에서 시작합니다.\n\n간결하지만 결코 비어있지 않은, 대담하지만 결코 무례하지 않은 균형을 추구합니다. 브랜드의 본질을 찾고, 그것을 오래 남을 형태로 번역합니다.',
  'https://images.unsplash.com/photo-1526947425960-945c6e72858f?w=1200&q=80',
  4
);

-- 6) 연락 (cta)
insert into public.sections (slug, type, title, subtitle, body, link_label, link_url, sort_order)
values (
  'contact', 'cta',
  'CONTACT', '함께 만들어요',
  '새로운 협업 제안이나 문의를 환영합니다. 편하게 연락 주세요.',
  '이메일 보내기', 'mailto:hello@bold.kr',
  5
);

commit;
