library(shinyWidgets)

with_red_star <- function(text) {
  htmltools::tags$span(HTML(paste0(
    text,
    htmltools::tags$span(style = "color:red", "*")
  )))
}



tags$section(class = "intervention_page_2",
             
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
                              choiceNames = options_df_temp  |> pull(choiceNames),
                              choiceValues = options_df_temp  |>  pull(choiceNames)
                            )
                          )),
                 fluidRow(column(2),
                          column(
                            8, align = "right",
                            actionButton('ContinueBtn_SI', 'Continue')
                          ))
               )
             )
)