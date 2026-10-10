# R 데이터 분석 · 재직자교육

1일차 R 기초와 데이터프레임 · 2일차 데이터 시각화와 회귀분석

- 강의자료 사이트: <https://uos-bigdata.github.io/sports-r/>
- 문서는 브라우저에서 바로 보고, PDF는 인쇄·배포용으로 사용함

## 1일차 · R 기초와 데이터프레임

| 시간 | 세션 | 주요 내용 | 자료 |
|---|---|---|---|
| 09:30–10:00 | 교육 등록 및 과정 안내 | | |
| 10:00–11:00 | 1교시 · R 기초 | 자료형(문자형·숫자형·논리형), 자료구조(벡터·리스트·데이터프레임) | [문서](https://uos-bigdata.github.io/sports-r/d1-01-r-basics.html) · [슬라이드](https://uos-bigdata.github.io/sports-r/d1-01-r-basics-slides.html) · [PDF](docs/pdf/d1-01-r-basics.pdf) |
| 11:00–12:00 | 2교시 · 데이터프레임 다루기 I | 데이터프레임 주요 함수, 인덱싱과 슬라이싱 | [문서](https://uos-bigdata.github.io/sports-r/d1-02-dataframe-1.html) · [슬라이드](https://uos-bigdata.github.io/sports-r/d1-02-dataframe-1-slides.html) · [PDF](docs/pdf/d1-02-dataframe-1.pdf) |
| 12:00–13:00 | 점심 | | |
| 13:00–15:00 | 3·4교시 · 데이터프레임 다루기 II | dplyr 패키지, select · filter · mutate · arrange | [문서](https://uos-bigdata.github.io/sports-r/d1-03-dataframe-2.html) · [슬라이드](https://uos-bigdata.github.io/sports-r/d1-03-dataframe-2-slides.html) · [PDF](docs/pdf/d1-03-dataframe-2.pdf) |
| 15:00–17:00 | 5·6교시 · 데이터프레임 다루기 III | group_by · summarize, `_join` 함수를 이용한 데이터 결합 | [문서](https://uos-bigdata.github.io/sports-r/d1-04-dataframe-3.html) · [슬라이드](https://uos-bigdata.github.io/sports-r/d1-04-dataframe-3-slides.html) · [PDF](docs/pdf/d1-04-dataframe-3.pdf) |

## 2일차 · 데이터 시각화와 회귀분석

| 시간 | 장 | 주요 내용 | 자료 |
|---|---|---|---|
| 09:30–10:00 | 교육 등록 및 과정 안내 | | |
| 10:00–11:00 | 제1장 · 자료의 특성과 기술통계 | 변수 유형, 중심위치와 산포, 기본 R 그래프 | [문서](https://uos-bigdata.github.io/sports-r/d2-01-descriptive-statistics.html) · [PDF](docs/pdf/d2-01-descriptive-statistics.pdf) |
| 11:00–12:00 | 제2장 · ggplot2를 활용한 데이터 시각화 | 집단별 평균 및 빈도 요약표, 기초 그래프 작성 | [문서](https://uos-bigdata.github.io/sports-r/d2-02-ggplot2.html) · [PDF](docs/pdf/d2-02-ggplot2.pdf) |
| 12:00–13:00 | 점심 | | |
| 13:00–15:00 | 제3장 · 선형회귀분석 | 산점도와 상관계수, 회귀계수 해석, 설명과 예측 | [문서](https://uos-bigdata.github.io/sports-r/d2-03-linear-regression.html) · [PDF](docs/pdf/d2-03-linear-regression.pdf) |
| 15:00–17:00 | 제4장 · 국민체력 100 자료를 이용한 종합 실습 | 실제자료 분석 | [문서](https://uos-bigdata.github.io/sports-r/d2-04-sports100-practice.html) · [PDF](docs/pdf/d2-04-sports100-practice.pdf) |

2일차 장별 구성과 권장 진행 순서는 [2일차 강의 안내](https://uos-bigdata.github.io/sports-r/d2-00-intro.html)에 있음.

## 실습 파일 내려받기

### 1일차

| 파일 | 내용 |
|---|---|
| [day1-data.zip](https://uos-bigdata.github.io/sports-r/downloads/day1-data.zip) | 1일차 실습 파일 묶음 (아래 두 파일) |
| [practice_data.R](https://uos-bigdata.github.io/sports-r/data/practice_data.R) | 실습 데이터 생성 스크립트. `source("data/practice_data.R")`로 실행하면 `fitness`(30행), `programs`(15행)가 만들어짐 |
| [fitness.csv](https://uos-bigdata.github.io/sports-r/data/fitness.csv) | 2교시 `read.csv()` 불러오기 실습용 CSV (`fitness`와 같은 내용) |

1일차 데이터는 국민체력100 체력측정 자료와 비슷한 구조로 만든 가상 데이터이며 실제 측정 결과와 무관함. 1교시에 직접 입력하는 `member`(10명)는 `fitness`의 앞 10명과 같음.

### 2일차

| 파일 | 내용 |
|---|---|
| [day2-data.zip](https://uos-bigdata.github.io/sports-r/downloads/day2-data.zip) | 2일차 실습 데이터 묶음 (아래 세 CSV와 설명 파일) |
| [sports100-practice.csv](https://uos-bigdata.github.io/sports-r/data/sports100-practice.csv) | 제4장 국민체력 100 표본 자료 (2,000행) |
| [sports100-variables.csv](https://uos-bigdata.github.io/sports-r/data/sports100-variables.csv) | 제4장 변수 설명 |
| [father-and-son.csv](https://uos-bigdata.github.io/sports-r/data/father-and-son.csv) | 제3장 아버지·아들 키 자료 (본문 코드는 인터넷 주소에서 직접 읽음) |

장별 R Markdown 원고와 R 실습 코드는 [2일차 강의 안내](https://uos-bigdata.github.io/sports-r/d2-00-intro.html)의 "실습 파일"에서 내려받을 수 있음.

### 내려받기 안내

**1. 폴더 준비**

1. RStudio → `File` → `New Project` → `New Directory` → `New Project`로 실습용 프로젝트 생성 (예: `sports-r-practice`)
2. 프로젝트 폴더 안에 `data` 폴더 생성
3. 내려받은 파일을 모두 `data` 폴더에 저장. 코드의 `data/파일이름` 경로가 이 폴더를 가리킴

```text
sports-r-practice/
├── sports-r-practice.Rproj
└── data/
    ├── practice_data.R
    ├── fitness.csv
    ├── sports100-practice.csv
    ├── sports100-variables.csv
    └── father-and-son.csv
```

**2. 내려받는 방법 (셋 중 하나 선택)**

- 방법 A · zip 묶음 (권장): 위 표의 `day1-data.zip`, `day2-data.zip`을 눌러 저장 → 압축을 풀고 안의 파일을 `data` 폴더로 옮김
- 방법 B · 파일 하나씩: 링크를 누르면 내용이 화면에 글자로 보이는 경우가 있음(`.R`, `.csv`). 이때는 링크에서 오른쪽 클릭 → "다른 이름으로 링크 저장"
- 방법 C · R 코드로 한 번에: 프로젝트를 연 상태에서 콘솔에 아래 코드를 붙여 넣고 실행

```r
dir.create("data", showWarnings = FALSE)
base <- "https://uos-bigdata.github.io/sports-r/downloads/"
for (z in c("day1-data.zip", "day2-data.zip")) {
  download.file(paste0(base, z), destfile = z, mode = "wb")
  unzip(z, exdir = "data")
}
list.files("data")
```

`list.files("data")` 결과에 `practice_data.R`, `fitness.csv`, `sports100-practice.csv` 등이 보이면 준비 완료.

> [!TIP]
> 강의자료 전체(문서·PDF·데이터)가 필요하면 이 저장소 상단의 `Code` → `Download ZIP`으로 한 번에 받을 수 있음. 압축을 풀면 실습 데이터는 `data/` 폴더, PDF는 `docs/pdf/` 폴더에 있음.

> [!NOTE]
> 교육장 PC에서 인터넷 접속이 막혀 있으면 방법 C가 실패함. 이 경우 방법 A로 미리 받아 USB 등으로 옮김.

## 준비 사항

1. R 설치 (<https://cran.r-project.org>) → RStudio 설치 (<https://posit.co/download/rstudio-desktop/>) 순서로 설치
2. RStudio 콘솔에서 아래 패키지 설치 (최초 1회)

```r
install.packages(c("dplyr", "ggplot2"))
```

## 1일차 슬라이드 사용법

| 키 | 기능 |
|---|---|
| `→` `←` / `Space` | 다음·이전 슬라이드 |
| `F` | 전체 화면 |
| `S` | 발표자 화면 (노트와 다음 슬라이드 미리보기) |
| `C` / `B` | 슬라이드 위에 판서 / 칠판 화면 |
| `M` | 메뉴 (슬라이드 목록) |
| `Esc` / `O` | 전체 슬라이드 한눈에 보기 |
| `Alt` + 클릭 | 해당 부분 확대 |

실습 슬라이드의 타이머는 클릭하면 시작·정지, 더블클릭하면 초기화됨.

## PDF

각 문서를 화면 그대로 PDF로 저장한 파일임. 탭과 보충 상자는 모두 펼쳐서 넣었고, 실습 정답과 과제 해설은 넣지 않았음.

---

<details>
<summary>강의자료 관리 (수정 후 다시 만들기)</summary>

| 경로 | 내용 |
|---|---|
| `index.qmd` | 사이트 첫 페이지 (이틀 시간표, 실습 파일 내려받기) |
| `d1-*.qmd` | 1일차 교시별 원고 (HTML 문서 + revealjs 슬라이드를 한 파일에서 생성) |
| `d2-00-intro.qmd`, `d2-*.qmd` | 2일차 안내와 장별 원고 |
| `data/` | 실습 데이터 |
| `downloads/` | 2일차 원본 R Markdown·R 코드·CSV, 날짜별 데이터 묶음(zip) |
| `pdf/` | 문서별 PDF |
| `theme/`, `filters/`, `_common.R` | 디자인, 문서/슬라이드 분리·정답 상자·장 번호 필터, 공통 설정 |
| `docs/` | 렌더링 결과 (GitHub Pages가 읽는 폴더) |

1. RStudio에서 `r-lecture.Rproj` 열기
2. 터미널에서 `quarto render` → `docs/` 갱신
3. PDF가 필요하면 `python make_pdf.py` 실행 후 `quarto render index.qmd`
4. 변경 내용을 커밋하고 push

필요 도구: Quarto 1.4 이상, `install.packages(c("dplyr", "ggplot2", "knitr", "rmarkdown"))`

GitHub Pages 설정: 저장소 `Settings` → `Pages` → Source `Deploy from a branch` → Branch `main`, 폴더 `/docs`

</details>
