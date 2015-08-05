## ---- sssGPS2SHP
### Export positions from Tritech StarFish SideScanSonar to line shapefile (.shp)
### Input: output from sssExtractGPS
### Output: line shapefile (.shp)

sssGPS2SHP <- function(positions, trackname){
  
  # Create lines  
  positions[,2] <- as.numeric(as.character(positions$LAT))
  positions[,3] <- as.numeric(as.character(positions$LON))
  positions[,4] <- as.numeric(as.character(positions$UTM_N))
  positions[,5] <- as.numeric(as.character(positions$UTM_E))
  
  # Position matrix
  lista_transecta = list()
  for(i in 1:(nrow(positions)-1))
    lista_transecta[[i]] = cbind(c(positions[i,3],positions[i+1,3]), 
                                 c(positions[i,2], positions[i+1,2]))
  
  # Lines connecting adyacent points \acute{a}
  lista_lineas_transecta = list()
  for(i in 1:(nrow(positions)-1))
    lista_lineas_transecta[[i]] = Line(coords = lista_transecta[[i]])
  
  # Line lengths between points
  lista_dist_transecta = list()
  for(i in 1:(nrow(positions)-1))
    lista_dist_transecta[[i]] = LineLength(cc = lista_lineas_transecta[[i]], 
                                           longlat = TRUE)
  
  # Convert kilometers to meters
  lista_dist_transecta = unlist(lista_dist_transecta)*1000
  
  # Cortar segmentos si: dist > 50 metros
  #if(length(which(lista_dist_transecta > 50))==0)
  #lista_lineas_transecta <- lista_lineas_transecta else
  #lista_lineas_transecta <- lista_lineas_transecta[-which(lista_dist_transecta > 50)]
  
  lista_transecta = Lines(slinelist = lista_lineas_transecta, 
                          ID = paste(trackname))
  
  lineas_positions = SpatialLines(LinesList = list(lista_transecta), 
                                  proj4string = CRS("+proj=longlat +datum=WGS84 +no_defs"))
  
  lineas_positions = SpatialLinesDataFrame(sl = lineas_positions,
                                           data = data.frame(ID = paste(trackname, 
                                                                        sep = "")), 
                                           match.ID = FALSE)
  
  return(lineas_positions)
    
}
