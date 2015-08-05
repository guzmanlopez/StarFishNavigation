## ---- ui
library(shiny)
library(xts)
library(leaflet)

# Ampliar a 16 el número de dígitos 
options(shiny.maxRequestSize = 800*1024^2,
        digits = 16,
        shiny.deprecation.messages = FALSE)

# Sonar Barrido Lateral

shinyUI(ui = fluidPage(
  sidebarLayout(
    sidebarPanel(
      conditionalPanel(condition = "input.tabs == 'tabTabla'",
                       fileInput(inputId = 'file1', 
                                 label = h3('Tritech StarFish 990F'), 
                                 accept='text/csv', multiple = FALSE),
                       tags$hr(),                 
                       selectInput(inputId = 'extraer', 
                                   label = h3('Ver datos'), 
                                   choices = c('GPS' = 'gps', 
                                               'ECO (en desarrollo...)'='eco'), 
                                   selectize = TRUE),
                       conditionalPanel(condition = "input.extraer == 'gps'", 
                                        numericInput(inputId = 'resolution', 
                                                     label = h4('Resolución (segundos)'), 
                                                     min = 0, 
                                                     max = 300, 
                                                     value = 0, 
                                                     step = 10),
                                        tags$hr(),
                                        selectInput(inputId = 'export', 
                                                    label = h3('Exportar datos'), 
                                                    choices = c('Tabla' = 'table', 
                                                                'Shapefile' = 'shapefile', 
                                                                'KML' = 'kml'), 
                                                    multiple = FALSE, 
                                                    selectize = TRUE),
                                        conditionalPanel(condition = "input.export == 'table'",
                                                         textInput(inputId = 'filename', 
                                                                   label = h4('Nombre del archivo tabla:'), 
                                                                   value = 'SBL-posiciones-gps'),
                                                         downloadButton(outputId = 'action_exp_table', 
                                                                        label = "Descargar", 
                                                                        class = 'btn-success'),
                                                         tags$hr(),
                                                         helpText("Nota: se sugiere utilizar un nombre que contenga",
                                                                  "un identificador de la campaña y la fecha de la misma.")
                                        ),
                                        conditionalPanel(condition = "input.export == 'shapefile'",
                                                         textInput(inputId = 'trackname', 
                                                                   label = h4('Nombre de trayectos:'), 
                                                                   value = 'trayecto01'),
                                                         textInput(inputId = 'filename_shp', 
                                                                   label = h4('Nombre de Shapefile:'), 
                                                                   value = 'SBL-trayecto-sig'),
                                                         downloadButton(outputId = 'action_exp_shp', 
                                                                        label = "Descargar", 
                                                                        class = 'btn-success'),
                                                         tags$hr(),
                                                         helpText("Nota: se sugiere utilizar un nombre que contenga",
                                                                  "un identificador de la campaña y la fecha de la misma.")
                                        ),
                                        conditionalPanel(condition = "input.export == 'kml'",
                                                         textInput(inputId = 'filename_kml', 
                                                                   label = h4('Nombre del archivo kml:'), 
                                                                   value = 'SBL-trayecto-googleearth'),
                                                         downloadButton(outputId = 'action_exp_kml', 
                                                                        label = "Descargar", 
                                                                        class = 'btn-success'),
                                                         tags$hr(),
                                                         helpText("Nota: se sugiere utilizar un nombre que contenga",
                                                                  "un identificador de la campaña y la fecha de la misma.")
                                        )
                       )
      ),
      
      conditionalPanel(condition = "input.tabs == 'tabMapa'",
                       radioButtons(inputId = 'mapabase',
                                    label = h3('Mapa base'), 
                                    choices = c('MapBox - Antiguo' = 'MBantiguo',
                                                'MapBox - Satélite híbrido' = 'MBsathib', 
                                                'MapBox - Outdoor' = 'MBoutdoor',
                                                'OpenStreetMaps' = 'OSM'), 
                                    selected = "MBantiguo"),
                       checkboxGroupInput(inputId = 'capas', 
                                          label = h3('Capas adicionales'), 
                                          choices = c('Batimetría' = 'bati')),
                       checkboxGroupInput(inputId = 'capaSBL', 
                                          label = h3('Datos cargados'), 
                                          choices = c('SBL' = 'sbl'))
      )
    ),
    
    mainPanel(tabsetPanel(id = "tabs", type = "pills",
                          tabPanel(title = "Tabla de datos", 
                                   value = "tabTabla", 
                                   dataTableOutput("table")),
                          tabPanel(title = "Mapa", 
                                   value = "tabMapa", 
                                   leafletOutput("mapa", height = "600px"))
    )
    )
  )
)
)
