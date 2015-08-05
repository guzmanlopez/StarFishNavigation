## ---- sssChangeResolution
### Change position time resolution
### Input: Data frame [Time, Latitude, Longitude, UTM_N, UTM_E], Resolution time (seconds)
### Output: Data frame [Time, Latitude, Longitude, UTM_N, UTM_E]

sssChangeResolution <- function(df, resolution) {
  
  df_pos = df
  
  # Convert to xts class
  df_pos = as.xts(df_pos, order.by = df_pos$Time)
  
  # Group by time
  if(resolution != 0)  {
    
    df_pos = split.xts(df_pos, f = 'seconds', k = resolution)    
    df = matrix(ncol = 5, nrow = length(df_pos))
    for(i in 1:length(df_pos))
      df[i,] = as.vector(df_pos[[i]][1,])    
    df = as.data.frame(df)
    df_pos = data.frame("Time" = as.character(df$V1),
                        "LAT" = as.character(df$V2), 
                        "LON" = as.character(df$V3), 
                        "UTM_N" = as.character(df$V4), 
                        "UTM_E" = as.character(df$V5))
  }
  
  if(resolution == 0)  {
    df_pos = as.data.frame(df_pos)
  }
  
  return(df_pos)
  
}
