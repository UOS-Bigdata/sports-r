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


## ----desc-factor--------------------------------------------------------------
event <- factor(c("달리기", "수영", "달리기", "근력운동"))
levels(event)
table(event)

satisfaction <- factor(
  c("보통", "높음", "낮음", "높음"),
  levels = c("낮음", "보통", "높음"),
  ordered = TRUE
)
satisfaction

sessions <- c(1, 3, 2, 4, 2)  # 이산형 수치 자료
grip <- c(28.5, 32.1, 30.8)   # 연속형 측정 자료
mean(sessions)
mean(grip)


## ----desc-data----------------------------------------------------------------
fitness <- data.frame(
  id = 1:20,
  group = factor(rep(c("A", "B"), each = 10), levels = c("A", "B")),
  sessions = c(1, 2, 3, 2, 4, 3, 1, 2, 3, 4,
               2, 3, 4, 3, 5, 4, 2, 3, 4, 5),
  grip_kg = c(24, 28, 30, 31, 32, 33, 34, 36, 38, 42,
              27, 31, 33, 35, 36, 38, 40, 42, 46, 58),
  jump_cm = c(25, 28, 30, 29, 31, 32, 34, 33, 36, 38,
              26, 30, 31, 33, 35, 36, 38, 40, 43, 46)
)

head(fitness)
str(fitness)


## ----desc-mean----------------------------------------------------------------
x <- c(20, 25, 30, 35, 40)

sum(x) / length(x)
mean(x)
mean(fitness$grip_kg)


## ----desc-robust-center-------------------------------------------------------
data1 <- c(2, 2, 2, 3, 3, 3, 3, 4, 4, 5)
data2 <- c(1, 2, 2, 3, 3, 3, 5, 5, 7, 1000)

center_compare <- data.frame(
  data = c("자료1", "자료2"),
  mean = c(mean(data1), mean(data2)),
  median = c(median(data1), median(data2)),
  trimmed_mean = c(mean(data1, trim = 0.1), mean(data2, trim = 0.1))
)
center_compare


## ----desc-mode----------------------------------------------------------------
frequency <- table(fitness$sessions)
frequency
names(frequency)[frequency == max(frequency)]


## ----desc-quantiles-----------------------------------------------------------
quantile(fitness$grip_kg, probs = c(0.25, 0.5, 0.75))
quantile(fitness$grip_kg, probs = 0.9)
quantile(fitness$grip_kg, probs = c(0, 0.25, 0.5, 0.75, 1))
summary(fitness$grip_kg)


## ----desc-deviation-----------------------------------------------------------
x <- c(20, 25, 30, 35, 40)
deviation <- x - mean(x)
deviation
sum(deviation)

range(x)
diff(range(x))


## ----desc-variance------------------------------------------------------------
x <- c(20, 25, 30, 35, 40)
n <- length(x)
squared_deviation <- (x - mean(x))^2

sum(squared_deviation) / (n - 1)
var(x)
sd(x)

mean(squared_deviation)
sqrt(mean(squared_deviation))


## ----desc-iqr-----------------------------------------------------------------
IQR(fitness$grip_kg)
quantile(fitness$grip_kg, 0.75) - quantile(fitness$grip_kg, 0.25)


## ----desc-cv------------------------------------------------------------------
cv_example <- data.frame(
  group = c("A", "B"),
  mean_kg = c(40, 20),
  sd_kg = c(4, 4)
)
cv_example$cv_percent <- cv_example$sd_kg / cv_example$mean_kg * 100
cv_example

sd(fitness$grip_kg) / mean(fitness$grip_kg) * 100


## ----desc-missing-------------------------------------------------------------
x_missing <- c(20, 25, NA, 35, 40)
mean(x_missing)
mean(x_missing, na.rm = TRUE)
sum(is.na(x_missing))
sum(!is.na(x_missing))


## ----desc-summary-table-------------------------------------------------------
grip <- fitness$grip_kg
summary_grip <- data.frame(
  n = length(grip),
  mean = mean(grip),
  median = median(grip),
  variance = var(grip),
  sd = sd(grip),
  min = min(grip),
  max = max(grip),
  IQR = IQR(grip),
  CV_percent = sd(grip) / mean(grip) * 100
)
round(summary_grip, 2)


## ----desc-frequency-----------------------------------------------------------
group_frequency <- table(fitness$group)
group_frequency
prop.table(group_frequency)

session_frequency <- table(factor(fitness$sessions, levels = 0:5))
data.frame(
  sessions = names(session_frequency),
  frequency = as.vector(session_frequency),
  percent = as.vector(prop.table(session_frequency)) * 100
)


## ----desc-bar, fig.cap="주간 운동 횟수별 관측 수. 도수가 0인 값도 표시합니다."---------------------
barplot(
  session_frequency,
  col = "steelblue",
  main = "주간 운동 횟수의 분포",
  xlab = "주간 운동 횟수 (회)",
  ylab = "도수 (명)",
  ylim = c(0, max(session_frequency) + 1)
)


## ----desc-pie, fig.cap="집단별 구성비. 가상 자료는 각 집단 10명으로 구성되어 있습니다."----------------
pie(
  group_frequency,
  labels = paste0(names(group_frequency), ": ",
                  prop.table(group_frequency) * 100, "%"),
  col = c("lightblue", "gray80"),
  main = "집단별 구성비"
)


## ----desc-histogram, fig.cap="악력의 히스토그램. 계급폭을 10kg으로 지정한 결과입니다."--------------
hist(
  fitness$grip_kg,
  breaks = seq(20, 60, by = 10),
  right = FALSE,
  col = "lightblue", border = "white",
  main = "악력의 분포",
  xlab = "악력 (kg)", ylab = "도수 (명)"
)


## ----desc-histogram-width, fig.width=9, fig.height=4.5, fig.cap="같은 자료에 계급폭 5kg과 10kg을 적용한 비교."----
local({
  old_par <- par(mfrow = c(1, 2), mar = c(4, 4, 3, 1))
  on.exit(par(old_par))
  hist(fitness$grip_kg, breaks = seq(20, 60, 5), right = FALSE,
       col = "lightblue", main = "계급폭 5kg",
       xlab = "악력 (kg)", ylab = "도수 (명)")
  hist(fitness$grip_kg, breaks = seq(20, 60, 10), right = FALSE,
       col = "lightblue", main = "계급폭 10kg",
       xlab = "악력 (kg)", ylab = "도수 (명)")
})


## ----desc-density, fig.cap="악력의 커널 밀도 추정. 표본이 작으므로 세부 형태의 해석에 유의합니다."---------
plot(
  density(fitness$grip_kg),
  main = "악력의 밀도곡선",
  xlab = "악력 (kg)", ylab = "밀도",
  col = "steelblue", lwd = 2
)
rug(fitness$grip_kg)


## ----desc-stem----------------------------------------------------------------
stem(fitness$grip_kg)


## ----desc-boxplot, fig.cap="집단별 악력 분포. 표시는 분포 요약이며 집단 효과에 대한 검정 결과가 아닙니다."----
boxplot(
  grip_kg ~ group, data = fitness,
  col = c("lightblue", "gray80"),
  main = "집단별 악력 분포",
  xlab = "집단", ylab = "악력 (kg)"
)


## ----desc-scatter, fig.cap="악력과 점프 높이의 산점도. 가상 자료에서 두 측정값의 관계를 살펴봅니다."--------
plot(
  fitness$grip_kg, fitness$jump_cm,
  pch = 19, col = "steelblue",
  main = "악력과 점프 높이의 관계",
  xlab = "악력 (kg)", ylab = "점프 높이 (cm)"
)


## ----desc-line, fig.cap="한 참여자의 주차별 악력 변화 예시. 별도로 구성한 가상 반복측정 자료입니다."---------
weekly <- data.frame(week = 1:6, grip_kg = c(30, 31, 30.5, 32, 33, 32.5))
plot(
  weekly$week, weekly$grip_kg,
  type = "b", pch = 19, col = "steelblue",
  main = "주차별 악력 변화",
  xlab = "주차", ylab = "악력 (kg)"
)


## ----desc-group-summary-------------------------------------------------------
group_summary <- data.frame(
  group = levels(fitness$group),
  n = as.vector(table(fitness$group)),
  mean = as.vector(tapply(fitness$grip_kg, fitness$group, mean)),
  median = as.vector(tapply(fitness$grip_kg, fitness$group, median)),
  sd = as.vector(tapply(fitness$grip_kg, fitness$group, sd))
)
group_summary$CV_percent <- group_summary$sd / group_summary$mean * 100
group_summary

