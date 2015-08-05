## ---- server
library('shiny')
library('xts')
library('sp')
library('maptools')
library('rgdal')
library('leaflet')

# File upload size = 800 mb
options(shiny.maxRequestSize = 1000*1024^2, 
        digits = 16, 
        shiny.deprecation.messages = FALSE)

shinyServer(function(input, output, session) {
  
  # Entradas de datos
  datasetInput <- reactive({
    if (is.null(input$file1)) return(NULL)
    if (!is.null(input$file1)) {
      sss_pos <- sssExtractGPS(filepath = input$file1$datapath)
      df_gps <<- sss_pos
      output <- sss_pos
      return(output)
    }
  })
  
  # Cambiar resolución
  datasetInput_res <- reactive({
    
    if (is.null(input$file1)) {
      return(NULL)
    }
    if(!is.null(input$file1) && input$resolution == 0) {
      datasetInput()
      return(df_gps)
    } else {
      output <- sssChangeResolution(df = df_gps, resolution = input$resolution)
      return(output)
    }
  })
  
  ### Tabla ####
  output$table <- renderDataTable({
    datasetInput_res()
  })
  
  # Exportar datos
  
  # CSV
  output$action_exp_table <- downloadHandler(filename = function() {
    paste(input$filename, '.csv', sep = '')
  },
  content = function(con) {
    write.table(x = df_gps, sep = ",", row.names = FALSE, file = con)
  },
  contentType = "text/csv"
  )      
  
  # Shapefile  
  output$action_exp_shp <- downloadHandler(
    filename = paste(input$filename, "Export", ".zip", sep = ""),
    content = function(file) {
      if (length(Sys.glob(paste(input$filename, ".*", sep = ""))) > 0){
        file.remove(Sys.glob(paste(input$filename, ".*", sep = "")))
      }
      positions2Lines <<- sssGPS2SHP(positions = df_gps, 
                                     trackname = input$trackname)
      writeOGR(obj = positions2Lines, 
               dsn = paste(input$filename, ".shp", sep = ""), 
               layer = input$trackname, driver = "ESRI Shapefile")
      zip(zipfile = paste(input$filename, "Export", ".zip", sep = ""), 
          files = Sys.glob(paste(input$filename, ".*", sep = "")))
      file.copy(paste(input$filename, "Export", ".zip", sep = ""), file)
      if (length(Sys.glob(paste(input$filename, ".*", sep = "")))>0){
        file.remove(Sys.glob(paste(input$filename, ".*", sep = "")))
      }
    }
  )
  
  # KML
  output$action_exp_kml <- downloadHandler(filename = function() {
    paste(input$filename, '.kml', sep = '')
  },
  content = function(con) {
    positions2Lines <- sssGPS2SHP(positions = df_gps, 
                                  trackname = input$trackname)
    kmlLine(obj = positions2Lines, kmlfile = con, name = input$trackname, 
            description = "", col = "black", visibility = 1, lwd = 1, 
            kmlname = paste("StarFish990F-", input$trackname, sep = ""), 
            kmldescription = "")    
    #write.table(x = df_gps, sep = ",", row.names = FALSE, file = con)
  },
  contentType = "text/xml"
  )
  
  ### Mapa ####
  output$mapa <- renderLeaflet({
    
    proxy <- leafletProxy(mapId = "mapa")
    
    # Mapas base
    if(input$mapabase == "MBantiguo"){
      proxy %>% addProviderTiles(provider = 'MapBox.guzman.mbpa2kjj')
    }
    
    if(input$mapabase == "MBsathib"){
      proxy %>% addProviderTiles(provider = 'MapBox.guzman.lgoi91mh')
    }
    
    if(input$mapabase == "MBoutdoor"){
      proxy %>% addProviderTiles(provider = 'MapBox.guzman.j035h3hc')
    }
    
    if(input$mapabase == "OSM") {
      proxy %>% addProviderTiles(provider = 'CartoDB.Positron')
    }
    
    # Capas 
    if(length(df_gps) != 0 && !is.null(input$capaSBL)) {
      proxy %>% clearShapes()
      proxy %>% addPolylines(lng = as.numeric(as.character(df_gps$LON)), 
                             lat = as.numeric(as.character(df_gps$LAT)), 
                             smoothFactor = 1, color = "black", opacity = 1)
      proxy %>% fitBounds(lng1 = min(as.numeric(as.character(df_gps$LON))),
                          lng2 = max(as.numeric(as.character(df_gps$LON))),
                          lat1 = min(as.numeric(as.character(df_gps$LAT))),
                          lat2 = max(as.numeric(as.character(df_gps$LAT))))
    } 
    
    proxy %>% setView(lng = -55.5, lat = -35, zoom = 8)
    
  })
  
})
