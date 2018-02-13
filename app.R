#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Minimal app"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         sliderInput("number",
                     "Pick a number",
                     min = 1,
                     max = 150,
                     value = 30)
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
        fluidRow(column(6,
                        plotOutput("plot")),
                 column(6,
                 plotOutput("plot2"))),
         downloadButton("download_doc", "Download a pdf document")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$plot <- renderPlot({
      n <- input$number
      
      barplot((1:n)^2,
              col = rainbow(n),
              border = NA)
   })
   
   output$plot2 <- renderPlot({
     n <- input$number
     
     plot(1:n, (1:n)^2,
             col = adjustcolor(rainbow(n),alpha.f = 0.5),
          cex = ((1:n) / 10)^2,
          pch = 16)
   })
   
   
   output$download_doc <-
     downloadHandler(filename = "visualizations.pdf",
                     content = function(file){

                                              # generate html
                       rmarkdown::render('visualizations.Rmd',
                                         params = list(n = input$number))
                       
                       # copy html to 'file'
                       file.copy("visualizations.pdf", file)
                       
                       # # delete folder with plots
                       # unlink("figure", recursive = TRUE)
                     },
                     contentType = "application/pdf"
     )
}

# Run the application 
shinyApp(ui = ui, server = server)

