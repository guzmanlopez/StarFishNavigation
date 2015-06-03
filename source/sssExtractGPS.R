### Extract GPS positions from raw CSV Tritech StarFish SideScanSonar
### Input: StarFish csv raw file (.csv)
### Output: Data frame [Time, Latitude, Longitude, UTM_N, UTM_E]

sssExtractGPS <- function(sss, resolution) {
  
  # GPS
  #sss = unlist(strsplit(x=sss, split=","))
  
  pos = which(sss == 'POS')
  end = length(pos)
  
  TS_P = NULL
  for(i in 1:end)
    TS_P[i] = sss[pos[i]+1]
  TS_P <- strptime(x = TS_P, format = "%d/%m/%Y %H:%M:%S")
  
  LAT = NULL
  for(i in 1:end)
    LAT[i] = sss[pos[i]+2]
  
  LON = NULL
  for(i in 1:end)
    LON[i] = sss[pos[i]+3]
  
  NOR = NULL
  for(i in 1:end)
    NOR[i] = sss[pos[i]+5]
  
  EST = NULL
  for(i in 1:end)
    EST[i] = sss[pos[i]+6]
  
  # Data frame
  df_pos = data.frame(Time = TS_P, LAT = as.numeric(LAT), LON = as.numeric(LON), UTM_N = as.numeric(NOR), UTM_E = as.numeric(EST))
  
  # Remove duplicate entries
  df_pos = df_pos[-which(duplicated(df_pos$Time)),]
  
  # Convert to xts class
  df_pos = as.xts(df_pos, order.by = df_pos$Time)
  
  # Group by time
  if(resolution != 0)  {
    
    df_pos = split.xts(df_pos, f = 'seconds', k = resolution)    
    df = matrix(ncol = 5, nrow = length(df_pos))
    for(i in 1:length(df_pos))
      df[i,] = as.vector(df_pos[[i]][1,])    
    df = as.data.frame(df)
    df_pos = data.frame("Time" = as.character(df$V1), "LAT" = as.character(df$V2), "LON" = as.character(df$V3), "UTM_N" = as.character(df$V4), "UTM_E" = as.character(df$V5))
  }
  
  if(resolution == 0)  {
    df_pos = as.data.frame(df_pos)
  }
  
  return(df_pos)
}
