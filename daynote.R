# Day note with pomodoros
daynote <- dn <- function(minutes_available = 8 * 60,
                          focus_areas = NULL,
                          tasks = NULL,
                          work_start = '09:00',
                          time_format = '%H:%M',
                          work_length = 25,
                          rest_length = 5,
                          breaks_every = 5) {
  work_start <- strptime(work_start, time_format)
  if (!is.null(focus_areas)) {
    priority <- sample(focus_areas, 1)
  } else {
    priority <- NULL
  }
  if (!is.null(tasks)) {
    tasks <- data.frame(Task = sample(tasks), Done = '')
  } else {
    tasks <- NULL
  }
  chunk_length <- work_length + rest_length
  n_chunks <- round(minutes_available / chunk_length)
  pomo_work <- work_start + seq(0, minutes_available - chunk_length, by = chunk_length) * 60
  pomo_rest <- pomo_work + 25 * 60
  longer_breaks <- seq(0, n_chunks, breaks_every)
  results <- data.frame(
    Start = format(pomo_work, time_format),
    End = format(pomo_rest, time_format),
    Note = ''
  )
  results$Note[longer_breaks] <- 'Longer break'
  cat('\n')
  cat('#', format(Sys.Date(), '%Y-%m-%d'), 'day note\n\n')
  cat('## Wellbeing \n\n-\n\n')
  cat('## Work\n\n-\n\n')
  if (!is.null(priority)) {
    cat('**Priority focus activity: ', priority, '**', sep = '')
    print(knitr::kable(tasks))
  }
  print(knitr::kable(results))
  cat('\n\n## Thoughts\n\n-\n\n')
}

# Example usage
daynote()
