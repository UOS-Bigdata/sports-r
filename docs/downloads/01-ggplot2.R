## ---- 한글 그래프 글꼴 설정 ------------------------------------------------
# Windows는 맑은 고딕, macOS는 AppleGothic을 사용 (기본 글꼴에는 한글이 없어 그래프 글자가 깨짐)
if (.Platform$OS.type == "windows") {
  grDevices::windowsFonts(course = grDevices::windowsFont("Malgun Gothic"))
  par(family = "course")
  if (requireNamespace("ggplot2", quietly = TRUE)) ggplot2::theme_set(ggplot2::theme_gray(base_family = "course"))
} else if (Sys.info()[["sysname"]] == "Darwin") {
  par(family = "AppleGothic")
  if (requireNamespace("ggplot2", quietly = TRUE)) ggplot2::theme_set(ggplot2::theme_gray(base_family = "AppleGothic"))
}


## ----install-ggplot2, eval=FALSE----------------------------------------------
# install.packages("ggplot2")


## ----load-ggplot2-------------------------------------------------------------
library(ggplot2)


## ----inspect-data-------------------------------------------------------------
head(mpg)       # 첫 6행을 봅니다.
dim(mpg)        # 행 개수, 열 개수 순서로 나옵니다.
names(mpg)      # 사용할 수 있는 열 이름을 봅니다.


## ----first-scatter, fig.cap="배기량과 고속도로 연비의 관계. 점 하나는 자료의 관측 한 건입니다."----------
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point()


## ----fixed-color, fig.cap="모든 점에 같은 색과 크기를 지정한 산점도."--------------------------
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(color = "steelblue", size = 2, alpha = 0.6)


## ----mapped-color, fig.cap="구동방식에 따라 색이 달라지고 범례가 자동으로 생깁니다."------------------
ggplot(mpg, aes(x = displ, y = hwy, color = drv)) +
  geom_point(size = 2, alpha = 0.7)


## ----labeled-plot, fig.cap="제목과 축 단위를 추가하면 그래프의 질문과 측정값을 파악하기 쉽습니다."----------
ggplot(mpg, aes(x = displ, y = hwy, color = drv)) +
  geom_point(size = 2, alpha = 0.7) +
  labs(
    title = "배기량과 고속도로 연비의 관계",
    subtitle = "구동방식별 비교: 4 = 사륜, f = 전륜, r = 후륜",
    x = "배기량 (L)",
    y = "고속도로 연비 (mile/gallon)",
    color = "구동방식",
    caption = "자료: ggplot2 패키지의 mpg"
  )


## ----save-plot-object, fig.cap="p에 저장한 그래프. 이 객체를 이후 파일 저장 예제에서 사용합니다."-------
p <- ggplot(mpg, aes(x = displ, y = hwy, color = drv)) +
  geom_point(size = 2, alpha = 0.7) +
  labs(
    title = "배기량과 고속도로 연비",
    subtitle = "4 = 사륜구동, f = 전륜구동, r = 후륜구동",
    x = "배기량 (L)",
    y = "고속도로 연비 (mile/gallon)",
    color = "구동방식"
  ) +
  theme_minimal(base_size = 13)

p


## ----facets, fig.cap="구동방식별로 나눈 산점도. 패널의 축 범위가 같아 위치를 비교할 수 있습니다."------------
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(color = "steelblue", alpha = 0.6) +
  facet_wrap(~ drv) +
  labs(
    title = "구동방식별 배기량과 연비",
    subtitle = "4 = 사륜구동, f = 전륜구동, r = 후륜구동",
    x = "배기량 (L)", y = "고속도로 연비 (mile/gallon)"
  ) +
  theme_minimal()


## ----count-bar, fig.cap="차종별 관측 수. 이 자료에서는 suv의 관측이 가장 많습니다."-----------------
ggplot(mpg, aes(x = class)) +
  geom_bar(fill = "steelblue") +
  labs(
    title = "차종별 관측 수", x = "차종", y = "관측 수 (건)"
  ) +
  theme_minimal()


## ----count-table--------------------------------------------------------------
table(mpg$class)


## ----boxplot, fig.cap="차종별 고속도로 연비 분포. 상자 안의 선은 평균이 아니라 중앙값입니다."--------------
ggplot(mpg, aes(x = class, y = hwy)) +
  geom_boxplot(fill = "lightblue") +
  labs(
    title = "차종별 고속도로 연비 분포",
    x = "차종", y = "고속도로 연비 (mile/gallon)"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


## ----boxplot-points, fig.cap="점을 좌우로만 조금 흩어 놓아 관측의 겹침을 줄인 그림."----------------
set.seed(2026)
ggplot(mpg, aes(x = class, y = hwy)) +
  geom_boxplot(outlier.shape = NA, fill = "lightblue") +
  geom_jitter(width = 0.15, height = 0, alpha = 0.35) +
  labs(x = "차종", y = "고속도로 연비 (mile/gallon)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


## ----export-plot, eval=FALSE--------------------------------------------------
# getwd()  # 현재 작업 폴더를 확인합니다.
# dir.create("outputs", showWarnings = FALSE)
# 
# ggsave(
#   filename = "outputs/mpg_scatter.png",
#   plot = p,
#   width = 18,
#   height = 12,
#   units = "cm",
#   dpi = 300,
#   bg = "white"
# )


## ----trend-line, fig.cap="직선으로 요약한 전체 추세. 점과 추세선을 함께 읽습니다."-------------------
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE) +
  labs(
    title = "배기량과 연비의 전체적인 경향",
    x = "배기량 (L)", y = "고속도로 연비 (mile/gallon)"
  ) +
  theme_minimal()


## ----install-dplyr, eval=FALSE------------------------------------------------
# install.packages("dplyr")


## ----group-summary------------------------------------------------------------
library(dplyr)

mpg_sum <- mpg %>%
  group_by(class) %>%
  summarise(
    mean_hwy = mean(hwy),
    n = n(),
    .groups = "drop"
  )

mpg_sum


## ----mean-bar, fig.cap="차종별 평균 고속도로 연비. 막대 높이는 관측 수가 아니라 계산한 평균입니다."----------
ggplot(mpg_sum, aes(x = class, y = mean_hwy)) +
  geom_col(fill = "steelblue") +
  labs(
    title = "차종별 평균 고속도로 연비",
    x = "차종", y = "평균 고속도로 연비 (mile/gallon)"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


## ----sorted-mean-bar, fig.cap="평균으로 정렬한 가로 막대그래프."----------------------------
ggplot(mpg_sum, aes(x = mean_hwy, y = reorder(class, mean_hwy))) +
  geom_col(fill = "steelblue") +
  labs(x = "평균 고속도로 연비 (mile/gallon)", y = "차종") +
  theme_minimal()


## ----zoom-plot, fig.cap="연비 15–35 구간을 확대해 본 그림. 화면 밖의 관측이 자료에서 삭제되지는 않습니다."----
p + coord_cartesian(ylim = c(15, 35))


## ----sports-data--------------------------------------------------------------
sports <- data.frame(
  id = 1:8,
  group = c("A", "A", "A", "A", "B", "B", "B", "B"),
  grip_kg = c(28, 32, 35, 30, 38, 42, 36, 40),
  jump_cm = c(31, 35, 33, 29, 38, 42, 34, 40)
)

sports


## ----sports-scatter, fig.cap="가상의 스포츠 측정 자료. 같은 그래프 구조에서 데이터와 열 이름을 바꾸었습니다."----
ggplot(sports, aes(x = grip_kg, y = jump_cm, color = group)) +
  geom_point(size = 3) +
  labs(
    title = "악력과 점프 높이의 관계",
    subtitle = "문법 연습용 가상 자료 · 8명",
    x = "악력 (kg)", y = "점프 높이 (cm)", color = "집단"
  ) +
  theme_minimal()

