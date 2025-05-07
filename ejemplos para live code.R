

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

## Ejemplo de notificaciones progresivas

# library(shiny)
# 
# ui <- fluidPage(
#   actionButton("start", "Iniciar carga de datos"),
#   tableOutput("data")
# )
# 
# server <- function(input, output, session) {
#   notify <- function(msg, id = NULL) {
#     showNotification(msg, id = id, duration = NULL, closeButton = FALSE)
#   }
#   
#   data <- eventReactive(input$start, { 
#     id <- notify("Leyendo datos...")
#     on.exit(removeNotification(id), add = TRUE)
#     Sys.sleep(1)
#     
#     notify("Reticulando splines...", id = id)
#     Sys.sleep(1)
#     
#     notify("Agrupando llamas...", id = id)
#     Sys.sleep(1)
#     
#     notify("Ortogonalizando matrices...", id = id)
#     Sys.sleep(1)
#     
#     mtcars  # dataset incorporado en R
#   })
#   
#   output$data <- renderTable(head(data()))
# }
# 
# shinyApp(ui, server)




# ## Ejemplo de barras de progreso con waiterss
# 
# 
# library(shiny)
# library(waiter)
# 
# ui <- navbarPage("Waitress aplicado al nav",
#                  tabPanel("home",
#                           useWaitress(color = "#7F7FFF"),
#                           actionButton("go", "Generar gráfico"),
#                           plotOutput("plot")
#                  )
# )
# 
# server <- function(input, output, session) {
#   
#   # Creamos el objeto waitress para despues llamar sus metodos $start() $inic()
#   # (creamos una sola vez la instancia y después lo volvemos a usar en el observeEvent)
#   waitress <- Waitress$new(
#     selector = "nav", 
#     theme = "overlay-percent", 
#     min = 0, 
#     max = 10
#   )
#   
#   observeEvent(input$go, {
#     
#     waitress$start()  # Muestra el loader
#     
#     output$plot <- renderPlot({
#       for (i in 1:10) {
#         waitress$inc(1)  # Incrementa 10%
#         Sys.sleep(0.5)
#       }
#       waitress$close()  # Oculta el loader cuando termina
#       hist(runif(100))
#     })
#     
#   })
# }
# 
# shinyApp(ui, server)


## Spinner con shinycssloaders

# library(shinycssloaders)
# 
# ui <- fluidPage(
#   actionButton("go", "go"),
#   withSpinner(plotOutput("plot")),
# )
# server <- function(input, output, session) {
#   data <- eventReactive(input$go, {
#     Sys.sleep(3)
#     data.frame(x = runif(50), y = runif(50))
#   })
#   
#   output$plot <- renderPlot(plot(data()), res = 96)
# }
# 
# shinyApp(ui, server)



## Confirmacion explicita

# Definimos el modalDialog

# modal_confirm <- modalDialog(
#   "Are you sure you want to continue?",
#   title = "Deleting files",
#   footer = tagList(
#     actionButton("cancel", "Cancel"),
#     actionButton("ok", "Delete", class = "btn btn-danger")
#   )
# )
# 
# 
# ui <- fluidPage(
#   actionButton("delete", "Delete all files?")
# )
# 
# 
# server <- function(input, output, session) {
#   observeEvent(input$delete, {
#     ## en vez de desatar el evento borrar corre el dialogo
#     showModal(modal_confirm)
#   })
#   
#   observeEvent(input$ok, {
#     showNotification("Files deleted")
#     removeModal()
#   })
#   observeEvent(input$cancel, {
#     removeModal()
#   })
# }
# 
# shinyApp(ui, server)

# ## Deshacer accion -----------
# 
# ui <- fluidPage(
#   textAreaInput("message", 
#                 label = NULL, 
#                 placeholder = "What's happening?",
#                 rows = 3
#   ),
#   actionButton("tweet", "Tweet")
# )
# 
# runLater <- function(action, seconds = 3) {
#   observeEvent(
#     invalidateLater(seconds * 1000), action, 
#     ignoreInit = TRUE, 
#     once = TRUE, 
#     ignoreNULL = FALSE,
#     autoDestroy = FALSE
#   )
# }
# 
# server <- function(input, output, session) {
#   waiting <- NULL
#   last_message <- NULL
#   
#   observeEvent(input$tweet, {
#     notification <- glue::glue("Tweeted '{input$message}'")
#     last_message <<- input$message
#     updateTextAreaInput(session, "message", value = "")
#     
#     showNotification(
#       notification,
#       action = actionButton("undo", "Undo?"),
#       duration = NULL,
#       closeButton = FALSE,
#       id = "tweeted",
#       type = "warning"
#     )
#     
#     waiting <<- runLater({
#       cat("Actually sending tweet...\n")
#       removeNotification("tweeted")
#     })
#   })
#   
#   observeEvent(input$undo, {
#     waiting$destroy()
#     showNotification("Tweet retracted", id = "tweeted")
#     updateTextAreaInput(session, "message", value = last_message)
#   })
# }
# 
# 
# shinyApp(ui, server)
