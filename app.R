library(shiny)

ui <- fluidPage(
  textInput("name", "¿Cómo te llamás?"),
  textOutput("greeting")
)

server <- function(input, output, session) {
  output$greeting <- renderText({
    paste0("Hola ", input$name, "!")
  })
}

shinyApp(ui, server)


