## ----nfa-setup, include=FALSE-------------------------------------------------
knitr::opts_chunk$set(
  echo = TRUE, message = FALSE, warning = TRUE, error = FALSE,
  fig.width = 8, fig.height = 5, dpi = 140,
  fig.align = "center", out.width = "100%", dev = "png"
)
if (.Platform$OS.type == "windows") {
  grDevices::windowsFonts(course = grDevices::windowsFont("Malgun Gothic"))
  knitr::opts_chunk$set(dev.args = list(family = "course"))
  ggplot2::theme_set(ggplot2::theme_gray(base_family = "course"))
} else if (Sys.info()[["sysname"]] == "Darwin") {
  # macOS: 기본 글꼴에 한글이 없어 그래프 글자가 깨지므로 AppleGothic 지정
  par(family = "AppleGothic")
  ggplot2::theme_set(ggplot2::theme_gray(base_family = "AppleGothic"))
}


## ----nfa-load-----------------------------------------------------------------
library(dplyr)
library(ggplot2)

nfa_raw <- read.csv("data/sports100-practice.csv", fileEncoding = "UTF-8-BOM")
nfa_info <- read.csv("data/sports100-variables.csv", fileEncoding = "UTF-8-BOM")

dim(nfa_raw)
str(nfa_raw)
head(nfa_raw)


## ----nfa-inventory------------------------------------------------------------
table(nfa_raw$AGE_GBN, useNA = "ifany")
table(nfa_raw$TEST_SEX, useNA = "ifany")
range(nfa_raw$TEST_AGE, na.rm = TRUE)


## ----nfa-prepare--------------------------------------------------------------
nfa <- nfa_raw %>%
  select(
    age_group = AGE_GBN, age = TEST_AGE, test_date = TEST_MD,
    sex = TEST_SEX, height_cm = ITEM_F001, weight_kg = ITEM_F002,
    grip_left = ITEM_F007, grip_right = ITEM_F008,
    curl_up = ITEM_F009, jump_count = ITEM_F010, bmi = ITEM_F018
  ) %>%
  mutate(
    test_date = as.Date(test_date),
    year = factor(format(test_date, "%Y")),
    sex = factor(sex, levels = c("M", "F"), labels = c("남성", "여성")),
    age_group = factor(age_group, levels = c("청소년", "성인", "어르신"))
  )

teen_raw <- nfa %>%
  filter(age_group == "청소년", age >= 13, age <= 18)

nrow(teen_raw)
table(teen_raw$year, teen_raw$sex)


## ----nfa-missing--------------------------------------------------------------
colSums(is.na(teen_raw[c("height_cm", "weight_kg", "grip_left",
                        "grip_right", "curl_up", "jump_count", "bmi")]))

with(teen_raw, table(
  윗몸말아올리기_측정 = !is.na(curl_up),
  반복점프_측정 = !is.na(jump_count)
))


## ----nfa-ranges---------------------------------------------------------------
nfa_info %>%
  filter(varname_eng %in% c("ITEM_F002", "ITEM_F007", "ITEM_F008", "ITEM_F009")) %>%
  select(varname_eng, varname_kor, unit, min_teen, max_teen)

teen_raw %>%
  summarise(
    weight_outside = sum(weight_kg < 20 | weight_kg > 140, na.rm = TRUE),
    left_outside = sum(grip_left < 1 | grip_left > 100, na.rm = TRUE),
    right_outside = sum(grip_right < 1 | grip_right > 100, na.rm = TRUE),
    curl_outside = sum(curl_up < 0 | curl_up > 100, na.rm = TRUE)
  )

table(teen_raw$curl_up[!is.na(teen_raw$curl_up) & teen_raw$curl_up > 100])


## ----nfa-clean-values---------------------------------------------------------
teen <- teen_raw %>%
  mutate(
    curl_flag = !is.na(curl_up) & (curl_up < 0 | curl_up > 100),
    curl_clean = ifelse(curl_flag, NA_real_, curl_up)
  )


## ----nfa-relative-grip--------------------------------------------------------
teen <- teen %>%
  mutate(
    grip_max = pmax(grip_left, grip_right, na.rm = TRUE),
    grip_max = ifelse(is.na(grip_left) & is.na(grip_right), NA_real_, grip_max),
    grip_rel = ifelse(weight_kg > 0, grip_max / weight_kg * 100, NA_real_)
  )

reg_data <- teen %>%
  filter(!is.na(sex), is.finite(grip_rel), is.finite(curl_clean))

sample_flow <- data.frame(
  단계 = c("원본 측정 기록", "13–18세 청소년", "상대악력 계산 가능",
           "윗몸말아올리기 측정", "범위 점검 후 윗몸말아올리기",
           "두 변수와 성별이 있는 회귀분석 자료"),
  기록수 = c(nrow(nfa_raw), nrow(teen), sum(is.finite(teen$grip_rel)),
             sum(!is.na(teen$curl_up)), sum(!is.na(teen$curl_clean)), nrow(reg_data))
)
sample_flow
table(reg_data$sex)


## ----nfa-frequency------------------------------------------------------------
sex_count <- table(teen$sex)
sex_count
prop.table(sex_count) * 100

year_sex <- table(teen$year, teen$sex)
year_sex
round(prop.table(year_sex, margin = 1) * 100, 1)


## ----nfa-descriptive----------------------------------------------------------
grip_values <- teen$grip_rel[is.finite(teen$grip_rel)]

c(
  n = length(grip_values),
  mean = mean(grip_values),
  median = median(grip_values),
  variance = var(grip_values),
  sd = sd(grip_values),
  IQR = IQR(grip_values),
  CV_percent = sd(grip_values) / mean(grip_values) * 100
)
quantile(grip_values, probs = c(0, 0.25, 0.5, 0.75, 1))


## ----nfa-group-summary--------------------------------------------------------
grip_summary <- teen %>%
  group_by(sex) %>%
  summarise(
    n_grip = sum(!is.na(grip_rel)),
    mean_grip = mean(grip_rel, na.rm = TRUE),
    sd_grip = sd(grip_rel, na.rm = TRUE),
    median_grip = median(grip_rel, na.rm = TRUE),
    cv_grip = sd_grip / mean_grip * 100,
    n_curl = sum(!is.na(curl_clean)),
    mean_curl = mean(curl_clean, na.rm = TRUE),
    .groups = "drop"
  )
grip_summary


## ----nfa-base-bar, fig.cap="청소년 자료의 성별 측정 기록 수."------------------------------
barplot(sex_count, col = c("steelblue", "tan3"),
        xlab = "성별", ylab = "측정 기록 수 (건)")


## ----nfa-base-hist, fig.cap="청소년 상대악력의 분포. 결측값을 제외한 자료입니다."-------------------
hist(grip_values, breaks = 15, col = "lightblue", border = "white",
     main = "", xlab = "상대악력 (%)", ylab = "도수 (건)")


## ----nfa-year-bar, fig.cap="연도별 성별 기록 수. 각 막대는 측정 기록의 도수입니다."-----------------
ggplot(teen, aes(x = year, fill = sex)) +
  geom_bar(position = "dodge") +
  labs(x = "측정 연도", y = "측정 기록 수 (건)", fill = "성별")


## ----nfa-mean-bar, fig.cap="성별 평균 상대악력. 막대의 높이는 이미 계산한 평균입니다."----------------
p_grip_mean <- ggplot(grip_summary, aes(x = sex, y = mean_grip, fill = sex)) +
  geom_col(width = 0.6, show.legend = FALSE) +
  labs(x = "성별", y = "평균 상대악력 (%)")
p_grip_mean


## ----nfa-grip-hist, fig.cap="같은 구간 너비로 작성한 성별 상대악력 히스토그램."--------------------
ggplot(filter(teen, !is.na(grip_rel)), aes(x = grip_rel)) +
  geom_histogram(binwidth = 5, boundary = 0, fill = "steelblue", color = "white") +
  facet_wrap(~ sex) +
  labs(x = "상대악력 (%)", y = "도수 (건)")


## ----nfa-bmi-box, fig.cap="청소년의 연도별·성별 BMI 분포."-------------------------------
ggplot(teen, aes(x = year, y = bmi, fill = sex)) +
  geom_boxplot(outlier.alpha = 0.4) +
  labs(x = "측정 연도", y = "BMI (kg/m²)", fill = "성별")


## ----nfa-scatter, fig.cap="상대악력과 윗몸말아올리기의 관계. 성별로 다른 회귀직선을 적합했습니다."-----------
p_nfa_relation <- ggplot(reg_data, aes(x = grip_rel, y = curl_clean)) +
  geom_point(alpha = 0.45, color = "steelblue4") +
  geom_smooth(method = "lm", se = FALSE, color = "firebrick") +
  facet_wrap(~ sex) +
  labs(x = "상대악력 (%)", y = "윗몸말아올리기 (회)")
p_nfa_relation


## ----nfa-cor------------------------------------------------------------------
cor(reg_data$grip_rel, reg_data$curl_clean)

reg_data %>%
  group_by(sex) %>%
  summarise(n = n(), r = cor(grip_rel, curl_clean), .groups = "drop")

male_data <- reg_data %>% filter(sex == "남성")
range(male_data$grip_rel)


## ----nfa-fit------------------------------------------------------------------
fit_nfa <- lm(curl_clean ~ grip_rel, data = male_data)
summary(fit_nfa)
confint(fit_nfa)


## ----nfa-metrics--------------------------------------------------------------
nfa_SSE <- sum(resid(fit_nfa)^2)
nfa_SST <- sum((male_data$curl_clean - mean(male_data$curl_clean))^2)
nfa_RMSE <- sqrt(mean(resid(fit_nfa)^2))
nfa_R2 <- 1 - nfa_SSE / nfa_SST

c(n = nrow(male_data), RMSE = nfa_RMSE, R_squared = nfa_R2)
summary(fit_nfa)$r.squared


## ----nfa-diagnostics, fig.height=4.5, fig.cap="남성 청소년 모형의 잔차 진단. 왼쪽은 적합값과 잔차, 오른쪽은 정규 Q-Q 그림입니다."----
old_par <- par(mfrow = c(1, 2), mar = c(4.5, 4.5, 2, 1))
plot(fitted(fit_nfa), resid(fit_nfa), pch = 16, col = "steelblue",
     xlab = "적합값 (회)", ylab = "잔차 (회)")
abline(h = 0, lty = 2, col = "firebrick")
qqnorm(rstandard(fit_nfa), pch = 16, col = "steelblue", main = "",
       xlab = "이론적 분위수", ylab = "표준화 잔차")
qqline(rstandard(fit_nfa), col = "firebrick")
par(old_par)


## ----nfa-prediction-----------------------------------------------------------
new_nfa <- data.frame(grip_rel = 50)
nfa_mean_ci <- predict(fit_nfa, newdata = new_nfa, interval = "confidence")
nfa_individual_pi <- predict(fit_nfa, newdata = new_nfa, interval = "prediction")
nfa_mean_ci
nfa_individual_pi


## ----nfa-task1----------------------------------------------------------------
female_teen <- teen %>% filter(sex == "여성")
female_teen %>%
  summarise(
    height_mean = mean(height_cm, na.rm = TRUE),
    height_sd = sd(height_cm, na.rm = TRUE),
    height_cv = height_sd / height_mean * 100,
    weight_mean = mean(weight_kg, na.rm = TRUE),
    weight_sd = sd(weight_kg, na.rm = TRUE),
    weight_cv = weight_sd / weight_mean * 100
  )


## ----nfa-task2, fig.cap="연도별 성별 구성비. 각 연도의 합은 100%입니다."-----------------------
ggplot(teen, aes(x = year, fill = sex)) +
  geom_bar(position = "fill") +
  scale_y_continuous(breaks = seq(0, 1, 0.25),
                     labels = c("0%", "25%", "50%", "75%", "100%")) +
  labs(x = "측정 연도", y = "연도 내 비율", fill = "성별")


## ----nfa-task3----------------------------------------------------------------
female_data <- reg_data %>% filter(sex == "여성")
fit_nfa_female <- lm(curl_clean ~ grip_rel, data = female_data)

data.frame(
  sex = c("남성", "여성"),
  n = c(nobs(fit_nfa), nobs(fit_nfa_female)),
  slope = c(unname(coef(fit_nfa)[2]), unname(coef(fit_nfa_female)[2])),
  R_squared = c(summary(fit_nfa)$r.squared, summary(fit_nfa_female)$r.squared),
  RMSE = c(sqrt(mean(resid(fit_nfa)^2)), sqrt(mean(resid(fit_nfa_female)^2)))
)
confint(fit_nfa_female)


## ----nfa-task4----------------------------------------------------------------
male_all <- teen %>%
  filter(sex == "남성", is.finite(grip_rel), is.finite(curl_up))
fit_nfa_all <- lm(curl_up ~ grip_rel, data = male_all)

data.frame(
  analysis = c("설명서 범위 적용", "원래 측정값 포함"),
  n = c(nobs(fit_nfa), nobs(fit_nfa_all)),
  slope = c(unname(coef(fit_nfa)[2]), unname(coef(fit_nfa_all)[2])),
  R_squared = c(summary(fit_nfa)$r.squared, summary(fit_nfa_all)$r.squared),
  RMSE = c(sqrt(mean(resid(fit_nfa)^2)), sqrt(mean(resid(fit_nfa_all)^2)))
)

