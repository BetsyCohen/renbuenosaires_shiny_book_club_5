library(shiny)

ui <- fluidPage(
  textInput("nombre", "Tu nombre:"),
  numericInput("edad", "Tu edad:", value = 30),
  actionButton("saludar", "¡Saludar!"),
  textOutput("saludo")
)

server <- function(input, output, session) {
  saludo <- eventReactive(input$saludar, {
    paste("Hola", input$nombre, ", tenés", input$edad, "años.")
  })
  
  output$saludo <- renderText(saludo)
}

shinyApp(ui, server)

