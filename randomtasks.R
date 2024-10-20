# Exponentially randomise tasks
randomtasks <- rat <- function(n_tasks = 20,
                               n_required = NULL,
                               fancy = FALSE) {
  if (is.null(n_required))
    n_required <- n_tasks
  tasks <- seq(1, n_tasks)
  probs <- 1 / tasks
  probs <- probs / sum(probs)
  chosen <- sample(tasks, size = n_required, prob = probs)
  if (fancy) {
    knitr::kable(data.frame(Number = chosen, Task = ''))
  } else {
    chosen
  }
}

randomtasks2 <- rat2 <- function() {
  #  Share Random tasks from tasks.org app via email
  invisible(readline('Press Enter when tasks copied to clipboard'))
  tasks <- readClipboard()
  probs <- 1 / seq_along(tasks)
  probs <- probs / sum(probs)
  chosen <- sample(tasks, prob = probs)
  knitr::kable(data.frame(Task = chosen, Notes = ''))
}

# Examples
# rat(15)

