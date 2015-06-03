library(shiny)
library(stringr)
library(xts)
library(sp)
library(maptools)
library(rgdal)

# Numbers with 16 digits, 800 mb maximium upload .csv file size
options(shiny.maxRequestSize = 800*1024^2, digits = 16, shiny.deprecation.messages = FALSE)

shinyServer(function(input, output, session) {
  
  # Data input
  datasetInput <- reactive({
    if (is.null(input$file1)) return(NULL) else {
      sss <- unlist(strsplit(x = readLines(file(input$file1$datapath) ), split = ","))
      return(sss)
    }    
  })
  
  # Extract positions
  datasetInput_pos <- reactive ({
    output <- NULL
    if (!is.null(input$file1)) {
      sss_pos <- sssExtractGPS(sss = datasetInput(), resolution = input$resolution)
      output <- sss_pos
      df_gps <<- sss_pos
    }
    return(output)    
  })
  
  # Export data
  
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
      positions2Lines <- sssGPS2SHP(positions = df_gps, trackname = input$trackname)
      writeOGR(obj = positions2Lines, dsn = paste(input$filename, ".shp", sep = ""), layer = input$trackname, driver = "ESRI Shapefile")
      zip(zipfile = paste(input$filename, "Export", ".zip", sep = ""), files = Sys.glob(paste(input$filename, ".*", sep = "")))
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
    positions2Lines <- sssGPS2SHP(positions = df_gps, trackname = input$trackname)
    kmlLine(obj = positions2Lines, kmlfile = con, name = input$trackname, description="", col = "black", visibility = 1, lwd = 1, kmlname = paste("StarFish990F-", input$trackname, sep = ""), kmldescription="")    
    #write.table(x = df_gps, sep = ",", row.names = FALSE, file = con)
  },
  contentType = "text/xml"
  )
  
  ### Table ####
  output$table <- renderDataTable({
    datasetInput_pos()
  })  
})