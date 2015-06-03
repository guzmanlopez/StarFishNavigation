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
  list_track = list()
  for(i in 1:(nrow(positions)-1))
    list_track[[i]] = cbind(c(positions[i,3], positions[i+1,3]), c(positions[i,2], positions[i+1,2]))
  
  # Lines between consecutive positions
  list_lines_track = list()
  for(i in 1:(nrow(positions)-1))
    list_lines_track[[i]] = Line(coords = list_track[[i]])
  
  # Line distances between points
  list_dist_track = list()
  for(i in 1:(nrow(positions)-1))
    list_dist_track[[i]] = LineLength(cc = list_lines_track[[i]], longlat = TRUE)
  # Convert from kilometers to meters
  list_dist_track = unlist(list_dist_track)*1000
  
  # Break segments if distance > 50 meters
  #if(length(which(list_dist_track > 50))==0) list_lines_track <- list_lines_track else
  #list_lines_track <- list_lines_track[-which(list_dist_track > 50)]
  
  list_track = Lines(slinelist = list_lines_track, ID = paste(trackname))
  
  lines_positions = SpatialLines(LinesList = list(list_track), proj4string = CRS("+proj=longlat +datum=WGS84 +no_defs"))
  
  lines_positions = SpatialLinesDataFrame(sl = lines_positions, data = data.frame(ID = paste(trackname, sep = "")), match.ID = FALSE)
  
  return(lines_positions)
  
}
