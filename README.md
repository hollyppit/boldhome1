# BOLD 브랜드 사이트

전주 기반 브랜드 사이트 템플릿. 쇼핑몰 감성의 레이아웃(헤더/사이드 드로어/섹션/푸터)을 유지하면서, 모든 콘텐츠는 관리자 페이지에서 수정할 수 있도록 만들어졌습니다.

## 📁 파일 구성

```
bold-site/
├── index.html              # 공개 사이트 (방문자가 보는 페이지)
├── admin.html              # 관리자 페이지 (로그인 필요)
├── supabase-schema.sql     # Supabase 테이블 생성 SQL
└── README.md               # 이 문서
```

## 🚀 초기 설정 (최초 1회)

### 1. Supabase 프로젝트 준비
1. [supabase.com](https://supabase.com) → New project
2. 프로젝트 생성 후 **Settings → API** 에서 아래 두 값 복사:
   - `Project URL`
   - `anon public` key

### 2. 테이블 생성
- Supabase Dashboard → **SQL Editor** → 새 쿼리
- `supabase-schema.sql` 파일 전체 내용을 붙여넣고 **Run**
- (선택) 샘플 데이터가 필요하면 SQL 파일 맨 아래 `insert into ...` 부분 주석 해제 후 실행

### 3. 관리자 계정 생성
- Supabase Dashboard → **Authentication → Users → Add user**
- **Create new user** → 이메일/비밀번호 입력
- ⚠️ **Auto Confirm User** 체크 (이메일 인증 없이 즉시 사용)

### 4. 코드에 Supabase 키 입력
`index.html`과 `admin.html` 두 파일 모두 상단의 스크립트에서 아래 두 값을 본인 값으로 교체:

```js
const SUPABASE_URL = 'https://YOUR-PROJECT.supabase.co';
const SUPABASE_ANON_KEY = 'YOUR-ANON-KEY';
```

### 5. 배포
Cloudflare Pages 기준 (진우님 기존 스택과 동일):
1. GitHub 저장소에 `bold-site/` 폴더 내용 푸시
2. Cloudflare Pages → Create a project → 저장소 연결
3. Build command: (비움), Output directory: `/`
4. Deploy

> **로컬 테스트**: `index.html`을 더블클릭해도 동작합니다. ESM import를 사용하므로 간단한 로컬 서버 권장:
> ```
> npx serve .
> ```

## ✍️ 관리자 페이지 사용법

`/admin.html` 로 접속 → Supabase에서 만든 계정으로 로그인.

### 탭 구성
1. **사이트 설정** — 로고/연락처/소셜/SEO/테마 색상
2. **섹션 관리** — 페이지 섹션을 추가/삭제/순서변경/편집
3. **내보내기/가져오기** — JSON 백업·복원

### 섹션 타입 5가지
| 타입 | 용도 |
|---|---|
| `hero` | 상단 메인 (거대한 타이틀 + 이미지) |
| `text` | 본문 텍스트만 |
| `image_text` | 좌측 이미지 + 우측 텍스트 |
| `gallery` | 카드 그리드 (내부 아이템 필요) |
| `cta` | 검은 배경 행동 유도 박스 |

### 드래그 앤 드롭
- 섹션 목록에서 왼쪽 `⋮⋮` 손잡이를 드래그하면 순서가 바뀝니다
- 갤러리 아이템도 동일하게 DnD 정렬 가능

### 이미지 사용
- 현재 버전은 **이미지 URL 직접 입력** 방식입니다 (가장 가볍고 안정적)
- 추천 호스팅:
  - [Supabase Storage](https://supabase.com/docs/guides/storage) — 무료 1GB
  - [Cloudflare R2](https://developers.cloudflare.com/r2/) — 무료 10GB
  - [Unsplash](https://unsplash.com) — 무료 이미지

## 🔒 보안

- 공개 사이트(`index.html`)는 Supabase **anon key** 사용 → 읽기만 가능 (RLS로 보호)
- 관리자(`admin.html`)는 **로그인 후에만** 쓰기 가능
- anon key는 공개되어도 안전 (RLS 정책이 방어선)
- ⚠️ **service role key는 절대 프론트엔드에 넣지 마세요**

## 🧩 확장 아이디어

- **이미지 업로드 UI**: Supabase Storage 버킷(`bold-media`)을 만들고 admin.html에 파일 입력 추가
- **다국어**: `sections` 테이블에 `lang` 컬럼 추가
- **블로그/뉴스**: `type: 'post'` 섹션 추가 + `items`를 글 목록으로 활용
- **애드센스 연동**: 진우님 만트라 아트에서 쓰시는 것처럼 `index.html` head에 스크립트 추가

## 📝 라이선스

자유롭게 수정·배포하세요. 참고한 원본 사이트(bold.clickn.co.kr)는 일반적인 쇼핑몰 스켈레톤 구조만 참고했으며, 본 코드는 모두 새로 작성되었습니다.
