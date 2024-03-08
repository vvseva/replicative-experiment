library(shinyWidgets)

tags$section(class = "concent_page",
             
             fluidPage(
               div(
                 id = "concent_div",
                 fluidRow(br()),
                 fluidRow(column(2),
                          column(
                            8,
                            align = "left",
                            p("Do you agree to participate in this study?"),
                          )),
                 fluidRow(column(2),
                          column(
                            8, align = "right",
                            actionButton('concent_Btn', 'Yes')
                          ))
               )
             )
)