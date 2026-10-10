## ----reg-setup, include=FALSE-------------------------------------------------
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


## ----reg-load-----------------------------------------------------------------
library(ggplot2)

url1 <- "https://uos-bigdata.github.io/bigdata-exercise/_downloads/4480b104e6e159a32c7d5a0b03cf4684/father-and-son.csv"
father_son <- read.csv(url1)

dim(father_son)             # 행 수와 열 수
str(father_son)             # 변수 이름과 자료형
colSums(is.na(father_son))  # 변수별 결측값 수
head(father_son)


## ----reg-units----------------------------------------------------------------
father_son$fheight <- father_son$fheight * 2.54
father_son$sheight <- father_son$sheight * 2.54

summary(father_son)


## ----reg-scatter, fig.cap="아버지와 아들의 키. 점선은 두 변수 각각의 평균입니다."-------------------
ggplot(father_son, aes(x = fheight, y = sheight)) +
  geom_point(alpha = 0.3, color = "steelblue4") +
  geom_vline(xintercept = mean(father_son$fheight), linetype = "dashed") +
  geom_hline(yintercept = mean(father_son$sheight), linetype = "dashed") +
  labs(x = "아버지의 키 (cm)", y = "아들의 키 (cm)")


## ----reg-correlation----------------------------------------------------------
r_height <- cor(father_son$fheight, father_son$sheight)
r_height


## ----reg-standardize----------------------------------------------------------
zx <- as.numeric(scale(father_son$fheight))
zy <- as.numeric(scale(father_son$sheight))
n <- nrow(father_son)

sum(zx * zy) / (n - 1)


## ----reg-nonlinear, fig.cap="상관계수가 0에 가까워도 곡선 형태의 관계가 존재할 수 있습니다."------------
curve_data <- data.frame(x = seq(-3, 3, length.out = 61))
curve_data$y <- curve_data$x^2
round(cor(curve_data$x, curve_data$y), 10)

ggplot(curve_data, aes(x = x, y = y)) +
  geom_point(color = "steelblue4") +
  labs(x = "x", y = "y = x²")


## ----reg-bin-means, fig.cap="전체 관측값과 아버지 키 구간별 평균. 붉은 점의 크기는 구간별 관측 수를 나타냅니다."----
father_son$height_band <- cut(
  father_son$fheight,
  breaks = c(140, 160, 170, 180, 200), include.lowest = TRUE
)
band_means <- aggregate(
  cbind(fheight, sheight) ~ height_band,
  data = father_son, FUN = mean
)
band_counts <- aggregate(sheight ~ height_band, data = father_son, FUN = length)
band_means$n <- band_counts$sheight[match(band_means$height_band,
                                         band_counts$height_band)]
band_means

ggplot(father_son, aes(x = fheight, y = sheight)) +
  geom_point(alpha = 0.15, color = "grey40") +
  geom_point(data = band_means, aes(size = n), color = "firebrick") +
  labs(x = "아버지의 키 (cm)", y = "아들의 키 (cm)", size = "구간별 관측 수")


## ----reg-manual---------------------------------------------------------------
x <- father_son$fheight
y <- father_son$sheight

b1 <- sum((x - mean(x)) * (y - mean(y))) / sum((x - mean(x))^2)
b0 <- mean(y) - b1 * mean(x)

c(intercept = b0, slope = b1)
cor(x, y) * sd(y) / sd(x)  # 같은 기울기를 구하는 다른 식


## ----reg-candidates-----------------------------------------------------------
data.frame(
  line = c("20 + 0.8x", "25 + 0.9x", "최소제곱 직선"),
  MSE = c(
    mean((y - (20 + 0.8 * x))^2),
    mean((y - (25 + 0.9 * x))^2),
    mean((y - (b0 + b1 * x))^2)
  )
)


## ----reg-lm-------------------------------------------------------------------
fit_height <- lm(sheight ~ fheight, data = father_son)
coef(fit_height)


## ----reg-summary--------------------------------------------------------------
summary(fit_height)


## ----reg-coefficient-ci-------------------------------------------------------
confint(fit_height, level = 0.95)


## ----reg-fitted---------------------------------------------------------------
height_result <- data.frame(
  father_cm = father_son$fheight,
  observed_cm = father_son$sheight,
  fitted_cm = fitted(fit_height),
  residual_cm = resid(fit_height)
)
head(height_result)


## ----reg-residual-segments, fig.cap="전체 자료로 적합한 회귀직선과 처음 20개 관측값의 잔차."--------
ggplot(father_son, aes(x = fheight, y = sheight)) +
  geom_point(alpha = 0.12, color = "grey40") +
  geom_segment(
    data = head(height_result, 20),
    aes(x = father_cm, xend = father_cm,
        y = fitted_cm, yend = observed_cm),
    inherit.aes = FALSE, color = "firebrick", linewidth = 0.6
  ) +
  geom_abline(intercept = coef(fit_height)[1],
              slope = coef(fit_height)[2], color = "steelblue4", linewidth = 1) +
  labs(x = "아버지의 키 (cm)", y = "아들의 키 (cm)")


## ----reg-metrics--------------------------------------------------------------
n <- nrow(father_son)
SSE <- sum(resid(fit_height)^2)
SST <- sum((father_son$sheight - mean(father_son$sheight))^2)
MSE <- SSE / n
RMSE <- sqrt(MSE)
R2 <- 1 - SSE / SST

c(MSE = MSE, RMSE = RMSE, R_squared = R2)
summary(fit_height)$r.squared
cor(father_son$fheight, father_son$sheight)^2


## ----reg-denominators---------------------------------------------------------
c(
  RMSE = sqrt(SSE / n),
  residual_standard_error = sqrt(SSE / (n - 2)),
  summary_sigma = summary(fit_height)$sigma
)


## ----reg-residual-plot, fig.cap="적합값에 대한 잔차. 붉은 수평선은 잔차 0을 나타냅니다."------------
ggplot(height_result, aes(x = fitted_cm, y = residual_cm)) +
  geom_point(alpha = 0.3, color = "steelblue4") +
  geom_hline(yintercept = 0, color = "firebrick", linetype = "dashed") +
  labs(x = "적합값 (cm)", y = "잔차 (cm)")


## ----reg-qq, fig.cap="표준화 잔차의 정규 Q-Q 그림. 특히 양쪽 꼬리의 이탈을 확인합니다."----------------
residual_data <- data.frame(standardized = rstandard(fit_height))
ggplot(residual_data, aes(sample = standardized)) +
  stat_qq(alpha = 0.4, color = "steelblue4") +
  stat_qq_line(color = "firebrick") +
  labs(x = "정규분포의 이론적 분위수", y = "표준화 잔차")


## ----reg-holdout--------------------------------------------------------------
set.seed(2026)
train_id <- sample(seq_len(nrow(father_son)),
                   size = floor(0.8 * nrow(father_son)))
train_data <- father_son[train_id, ]
test_data <- father_son[-train_id, ]

fit_train <- lm(sheight ~ fheight, data = train_data)
test_pred <- predict(fit_train, newdata = test_data)

c(
  train_RMSE = sqrt(mean(resid(fit_train)^2)),
  test_RMSE = sqrt(mean((test_data$sheight - test_pred)^2))
)


## ----reg-predict--------------------------------------------------------------
new_father <- data.frame(fheight = 185)
predict(fit_height, newdata = new_father)


## ----reg-predict-many---------------------------------------------------------
new_fathers <- data.frame(fheight = c(165, 175, 185))
data.frame(new_fathers, predicted_cm = predict(fit_height, newdata = new_fathers))


## ----reg-intervals------------------------------------------------------------
predict(fit_height, newdata = new_father,
        interval = "confidence", level = 0.95)
predict(fit_height, newdata = new_father,
        interval = "prediction", level = 0.95)


## ----reg-interval-plot, fig.cap="평균반응의 95% 신뢰구간과 새로운 개인의 95% 예측구간. 각 x값에서 계산한 구간입니다."----
height_grid <- data.frame(
  fheight = seq(min(father_son$fheight), max(father_son$fheight), length.out = 100)
)
mean_ci <- predict(fit_height, newdata = height_grid, interval = "confidence")
individual_pi <- predict(fit_height, newdata = height_grid, interval = "prediction")
height_grid$fit <- mean_ci[, "fit"]
height_grid$mean_lower <- mean_ci[, "lwr"]
height_grid$mean_upper <- mean_ci[, "upr"]
height_grid$individual_lower <- individual_pi[, "lwr"]
height_grid$individual_upper <- individual_pi[, "upr"]

ggplot(height_grid, aes(x = fheight)) +
  geom_ribbon(aes(ymin = individual_lower, ymax = individual_upper,
                  fill = "개인 예측구간"), alpha = 0.35) +
  geom_point(data = father_son, aes(y = sheight), alpha = 0.15, size = 1) +
  geom_ribbon(aes(ymin = mean_lower, ymax = mean_upper,
                  fill = "평균 신뢰구간"), alpha = 0.8) +
  geom_line(aes(y = fit), color = "steelblue4", linewidth = 0.8) +
  scale_fill_manual(values = c("개인 예측구간" = "grey65",
                                "평균 신뢰구간" = "skyblue3")) +
  labs(x = "아버지의 키 (cm)", y = "아들의 키 (cm)", fill = "95% 구간") +
  theme(legend.position = "bottom")


## ----reg-range----------------------------------------------------------------
range(father_son$fheight)


## ----reg-sports-data----------------------------------------------------------
sports_reg <- data.frame(
  grip_kg = c(24, 28, 30, 31, 32, 33, 34, 36, 38, 42,
              27, 31, 33, 35, 36, 38, 40, 42, 46, 58),
  jump_cm = c(25, 28, 30, 29, 31, 32, 34, 33, 36, 38,
              26, 30, 31, 33, 35, 36, 38, 40, 43, 46)
)

ggplot(sports_reg, aes(x = grip_kg, y = jump_cm)) +
  geom_point(size = 2, color = "steelblue4") +
  geom_smooth(method = "lm", se = FALSE, color = "firebrick") +
  labs(x = "악력 (kg)", y = "점프 높이 (cm)")

fit_sports <- lm(jump_cm ~ grip_kg, data = sports_reg)
summary(fit_sports)

