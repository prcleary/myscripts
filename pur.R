# Pullups (Russian)
pur <- function(start_reps = 5,
                n_days = 30) {
  days <- paste0('Day ', seq_len(n_days))
  rep1 <- floor(seq(start_reps, start_reps + n_days / 5 - .2, by = .2))
  rep2 <- floor(seq(start_reps - .8, start_reps + n_days / 5 - 1, by =
                      .2))
  rep3 <- floor(seq(start_reps - 1.6, start_reps + n_days / 5 - 1.8, by =
                      .2))
  rep4 <- floor(seq(start_reps - 2.4, start_reps + n_days / 5 - 2.6, by =
                      .2))
  rep5 <- floor(seq(start_reps - 3.19, start_reps + n_days / 5 - 3.39, by =
                      .2))
  results <- data.table::data.table(`Date done` = '',
                                    Day = days,
                                    rep1,
                                    rep2,
                                    rep3,
                                    rep4,
                                    rep5)
  knitr::kable(results)

}
# pur(10, 60)

