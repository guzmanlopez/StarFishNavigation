library(shiny)
library(stringr)
library(xts)

# Numbers with 16 digits, 800 mb maximium upload .csv file size
options(shiny.maxRequestSize = 800*1024^2, digits = 16, shiny.deprecation.messages = FALSE)

# Tritech StarFish Sidescan Sonar GPS extraction tool

shinyUI(ui = fluidPage(
  titlePanel("Tritech StarFish Export Navigation"),
  sidebarLayout(
    sidebarPanel(fileInput(inputId = 'file1', label = h4('Tritech StarFish 990F (csv raw data)'), accept = 'text/csv', multiple = FALSE),
                 tags$hr(),
                 selectInput(inputId = 'extract', label = h4('View data'), choices = c('GPS' = 'gps', 'Backscatter (dB) (In development...)' = 'bs'), selectize = TRUE),
                 conditionalPanel(condition = "input.extract == 'gps'",
                                  sliderInput(inputId = 'resolution', label = h4('Resolution (seconds)'), min = 0, max = 300, value = 0, step = 10, ticks = TRUE, post = " s"),
                                  tags$hr(),
                                  selectInput(inputId = 'export', label = h4('Export data'), choices = c('Table' = 'table', 'Shapefile' = 'shapefile', 'Kml' = 'kml'), multiple = FALSE, selectize = TRUE),
                                  
                                  conditionalPanel(condition = "input.export == 'table'",
                                                   textInput(inputId = 'filename', label = h5('Table filename'), value = 'sss-gps-data'),
                                                   downloadButton(outputId = 'action_exp_table', label = "Download", class = 'btn-success'),
                                                   tags$hr()),
                                  
                                  conditionalPanel(condition = "input.export == 'shapefile'",
                                                   textInput(inputId = 'trackname', label = h5('Name of track'), value = 'track_01'),                                                   
                                                   textInput(inputId = 'filename_shp', label = h5('Shapefile name'), value = 'sss-track-line'),
                                                   downloadButton(outputId = 'action_exp_shp', label = "Download", class = 'btn-success'),
                                                   tags$hr()),
                                  
                                  conditionalPanel(condition = "input.export == 'kml'",                                                   
                                                   textInput(inputId = 'filename_kml', label = h5('Name of kml file'), value = 'sss-googleearth-track'),
                                                   downloadButton(outputId = 'action_exp_kml', label = "Download", class = 'btn-success'),
                                                   tags$hr())
                 )
    ),
    mainPanel(dataTableOutput("table"))
  )
)
)