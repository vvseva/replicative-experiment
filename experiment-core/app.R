#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#
source("experiment-recipy.R")

library(shiny)
library(shinyjs)
library(tidyverse)
library(shinyWidgets)

with_red_star <- function(text) {
  htmltools::tags$span(HTML(paste0(
    text,
    htmltools::tags$span(style = "color:red", "*")
  )))
}

# Define UI for application that draws a histogram
ui <- fluidPage(
  navbarPage(
    id = "mainNavbarPage",
    # includeCSS("ui/hidebar.css"),
    shinyjs::useShinyjs(),
    tabPanel("Concent", value = "concent",
             source(
               file.path("ui", "concent.R"), local = TRUE
             )$value),
    tabPanel("SI", value = "SI",
             uiOutput("VoteUI")
             # source(
             #   file.path("ui", "SI.R"), local = TRUE
             # )$value
             )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  vals <- reactiveValues()
  
  vals$condition = sample(c("random",  "SI"), 1,
                          prob  = c(1, 1))
  
  
  observeEvent(input$concent_Btn, {
    if (vals$condition |> isolate() == "random") {
      vals$options_df_temp <- options_df |>
        sample_frac(1)
    } else {
      logs_old <- read_csv("results.csv", show_col_types = FALSE) |>
        select(condition,token,date_time,vote) |>
        filter(condition == "SI") |>
        count(vote)

      vals$options_df_temp <- options_df |>
        left_join(logs_old, by = c("choiceNames" = "vote")) |>
        arrange(-n)
    }
    
    output$VoteUI <- renderUI({
                   fluidPage(
                     div(
                       id = "intervention_SI",
                       fluidRow(br()),
                       fluidRow(column(2),
                                column(
                                  8,
                                  align = "left",
                                  p("Which course topic did you enjoy the most?"),
                                  radioButtons(
                                    label = with_red_star("Topics are sorted by popularity among students"),
                                    selected = character(0),
                                    width = "200%",
                                    inputId = "options_SI",
                                    choiceNames = vals$options_df_temp |> isolate()  |> pull(choiceNames),
                                    choiceValues = vals$options_df_temp |> isolate()   |>  pull(choiceNames)
                                  )
                                )
                                ),
                       fluidRow(column(2),
                                column(
                                  8, align = "right",
                                  actionButton('ContinueBtn_SI', 'Continue')
                                ))
                     )
                   )
    })
    
    showTab(inputId = "mainNavbarPage", target = "SI", select = T)
    hideTab(inputId = "mainNavbarPage", target = "concent")
  })

  observeEvent(c(input$ContinueBtn_SI), {
    if (input$ContinueBtn_SI == 1) {
    
    vals$logs <-   tibble(vote = input$options_SI, 
                          condition = vals$condition, 
                          token = session$token, 
                          date_time = Sys.time()
    )
    
    logs_old <- read_csv("results.csv", show_col_types = FALSE) |> 
      select(condition,token,date_time,vote)
    
    vals$logs |> 
      isolate() |> 
      bind_rows(logs_old) |>
      write_csv("results.csv")

  
    stopApp()
    }
  })

  session$onSessionEnded(function() {
    
  print("session ended")
    
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
