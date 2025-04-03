library(shiny)
library(bslib)
library(clipr)

# Function definitions
randomtasks2 <- rat2 <- function() {
  tasks <- read_clip(allow_non_interactive = TRUE)
  tasks <- gsub("^\\s*☐", "- [ ]", tasks)
  probs <- 1 / seq_along(tasks)
  probs <- probs / sum(probs)
  chosen <- sample(tasks, prob = probs)
  paste(chosen, collapse = "\n")
}

daynote <- dn <- function(minutes_available = 10 * 60,
                          focus_areas = NULL,
                          tasks = NULL,
                          work_start = '08:00',
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
    tasks <- gsub("^☐", "- [ ]", tasks)
  } else {
    tasks <- NULL
  }
  chunk_length <- work_length + rest_length
  n_chunks <- round(minutes_available / chunk_length)
  pomo_work <- work_start + seq(0, minutes_available - chunk_length, by = chunk_length) * 60
  pomo_rest <- pomo_work + work_length * 60
  longer_breaks <- seq(0, n_chunks, breaks_every)
  results <- data.frame(
    Start = format(pomo_work, time_format),
    End = format(pomo_rest, time_format),
    Note = ''
  )
  results$Note[longer_breaks] <- 'Longer break'

  output <- c(
    paste('#', format(Sys.Date(), '%Y-%m-%d'), 'day note'),
    '',
    '## Wellbeing',
    '',
    '- ',
    '',
    '## Training',
    '',
    '- [ ] 5 reps',
    '- [ ] 5 reps',
    '- [ ] 5 reps',
    '- [ ] 5 reps',
    '- [ ] 5 reps',
    '- [ ] 5 reps',
    '- [ ] 5 reps',
    '- [ ] 5 reps',
    '',
    '## Work',
    '',
    '- ',
    '',
    '## Home',
    '',
    '- ',
    '',
    if (!is.null(priority))
      c(
        paste('**Priority focus activity:', priority, '**'),
        '',
        paste(tasks, collapse = "\n"),
        ''
      ),
    knitr::kable(results, format = "pipe"),
    '',
    '## Thoughts',
    '',
    '- '
  )

  paste(output, collapse = "\n")
}

ui <- page_navbar(
  theme = bs_theme(version = 5, bootswatch = "darkly"),
  title = "Task and Day Note Generator",


  nav_panel("Day Note", layout_sidebar(
    sidebar = sidebar(
      numericInput(
        "minutesAvailable",
        "Minutes Available",
        value = 10 * 60,
        min = 1
      ),
      textInput("focusAreas", "Focus Areas (comma-separated)", value = ""),
      textAreaInput(
        "tasks",
        "Tasks (one per line)",
        value = "",
        height = "100px"
      ),
      textInput("workStart", "Work Start Time", value = "08:00"),
      numericInput(
        "workLength",
        "Work Length (minutes)",
        value = 25,
        min = 1
      ),
      numericInput(
        "restLength",
        "Rest Length (minutes)",
        value = 5,
        min = 1
      ),
      numericInput(
        "breaksEvery",
        "Breaks Every (pomodoros)",
        value = 5,
        min = 1
      ),
      actionButton("generateDayNote", "Generate Day Note")
    ),
    card(
      card_header("Day Note Output"),
      card_body(
        verbatimTextOutput("dayNoteOutput"),
        actionButton("copyDayNote", "Copy to Clipboard")
      )
    )
  )),

  nav_panel("Random Tasks", layout_sidebar(
    sidebar = sidebar(actionButton(
      "generateRandomTasks", "Generate Random Tasks"
    )), card(
      card_header("Random Tasks Output"),
      card_body(
        uiOutput("randomTasksOutput"),
        actionButton("copyRandomTasks", "Copy to Clipboard")
      )
    )
  )),
)

server <- function(input, output, session) {
  randomTasksResult <- reactiveVal("")
  dayNoteResult <- reactiveVal("")

  observeEvent(input$generateRandomTasks, {
    result <- randomtasks2()
    randomTasksResult(result)
    output$randomTasksOutput <- renderUI({
      HTML(markdown::markdownToHTML(text = result, fragment.only = TRUE))
    })
  })

  observeEvent(input$generateDayNote, {
    focus_areas <- if (input$focusAreas != "")
      strsplit(input$focusAreas, ",")[[1]]
    else
      NULL
    tasks <- if (input$tasks != "")
      strsplit(input$tasks, "\n")[[1]]
    else
      NULL

    result <- daynote(
      minutes_available = input$minutesAvailable,
      focus_areas = focus_areas,
      tasks = tasks,
      work_start = input$workStart,
      work_length = input$workLength,
      rest_length = input$restLength,
      breaks_every = input$breaksEvery
    )
    dayNoteResult(result)
    output$dayNoteOutput <- renderText({
      result
    })
  })

  observeEvent(input$copyRandomTasks, {
    write_clip(randomTasksResult(), allow_non_interactive = TRUE)
    showNotification("Random Tasks copied to clipboard!", type = "message")
  })

  observeEvent(input$copyDayNote, {
    write_clip(dayNoteResult(), allow_non_interactive = TRUE)
    showNotification("Day Note copied to clipboard!", type = "message")
  })
}

shinyApp(ui, server)
