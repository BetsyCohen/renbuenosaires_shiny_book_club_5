

# ## Ejemplo validación 1 -------------
# library(shiny)
# 
# ui <- fluidPage(
#   shinyFeedback::useShinyFeedback(),
#   numericInput("n", "n", value = 10),
#   textOutput("half")
# )
# 
# server <- function(input, output, session) {
#   half <- reactive({
#     even <- input$n %% 2 == 0
#     shinyFeedback::feedbackWarning("n", !even,"Por favor pone un número par")
#     req(even)
#     input$n / 2    
#   })
#   
#   output$half <- renderText(half())
# }
# 
# shinyApp(ui, server)


## Ejemplo validación 2 -------------
# library(shiny)
# 
# ui <- fluidPage(
#   selectInput("language", "Language", choices = c("", "English", "Spanish")),
#   textInput("name", "Name"),
#   textOutput("greeting")
# )
# 
# server <- function(input, output, session) {
#   greetings <- c(
#     English = "Hello",
#     Spanish = "Hola"
#   )
#   output$greeting <- renderText({
#     #req(input$language, input$name)
#     paste0(greetings[[input$language]], " ", input$name, "!")
#   })
# }
# 
# shinyApp(ui, server)

## Ejemplo validación 3 -------------

# ui <- fluidPage(
#   shinyFeedback::useShinyFeedback(),
#   textInput("dataset", "Dataset name"), 
#   tableOutput("data")
# )
# 
# server <- function(input, output, session) {
#   data <- reactive({
#     req(input$dataset)
#     
#     exists <- exists(input$dataset, "package:datasets")
#     shinyFeedback::feedbackDanger("dataset", !exists, "Dataset desconocido")
#     req(exists, cancelOutput = TRUE)
#     
#     get(input$dataset, "package:datasets")
#   })
#   
#   output$data <- renderTable({
#     head(data())
#   })
# }
# 
# shinyApp(ui, server)


# library(shiny)
# 
# ui <- fluidPage(
#   numericInput("x", "x", value = 0),
#   selectInput("trans", "transformation", 
#               choices = c("square", "log", "square-root")
#   ),
#   textOutput("out")
# )
# 
# server <- function(input, output, session) {
#   output$out <- renderText({
#     if (input$x < 0 && input$trans %in% c("log", "square-root")) {
#       validate("El valor que elegiste para tu x no admite ser negativo para aplicarle este cálculo")
#     }
#     
#     switch(input$trans,
#            square = input$x ^ 2,
#            "square-root" = sqrt(input$x),
#            log = log(input$x)
#     )
#   })
# }
# 
# shinyApp(ui, server)


# ## Ejemplo de notificación transitoria ------------
# 
# library(shiny)
# 
# ui <- fluidPage(
#   textInput("nombre", "Nombre"),
#   actionButton("enviar", "Enviar")
# )
# 
# server <- function(input, output, session) {
#   observeEvent(input$enviar, {
#     if (input$nombre == "") {
#       showNotification("Por favor ingresá un nombre", type = "error")
#     } else {
#       showNotification("Formulario enviado correctamente", type = "message")
#     }
#   })
# }
# 
# shinyApp(ui, server)



## Ejemplo notificación de procesos
# 
# library(shiny)
# 
# ui <- fluidPage(
#   actionButton("procesar", "Procesar datos")
# )
# 
# server <- function(input, output, session) {
#   observeEvent(input$procesar, {
#     # Mostrar notificación persistente mientras se procesa
#     id <- showNotification("Procesando datos...", duration = NULL, closeButton = FALSE, type = "message")
#     
#     # Simular un proceso lento
#     Sys.sleep(3)
#     
#     # Eliminar la notificación al terminar
#     removeNotification(id)
#     
#     # Mostrar notificación de éxito que desaparece sola
#     showNotification("¡Datos procesados correctamente!", type = "message")
#   })
# }
# 
# shinyApp(ui, server)


