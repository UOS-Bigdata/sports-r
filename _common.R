# 모든 세션 공통 설정 (각 .qmd 첫 청크에서 source)
options(tibble.print_max = 6, tibble.print_min = 6, pillar.min_title_chars = 6, pillar.sigfig = 4)

if (identical(knitr::pandoc_to(), "revealjs")) {
  # 슬라이드: 코드 블록을 쪼개지 않고 결과를 모아서 출력, 화면 폭에 맞춰 출력 너비 조정
  knitr::opts_chunk$set(results = "hold", R.options = list(width = 100))
  narrow <- function(options) {
    loc <- c(options[["output-location"]], options[["output.location"]])
    if (any(grepl("column", loc))) options$R.options <- list(width = 50)
    options
  }
  knitr::opts_hooks$set(`output-location` = narrow, output.location = narrow)
}
