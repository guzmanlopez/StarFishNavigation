## ---- sssExtractGPS
### Extract GPS positions from raw CSV Tritech StarFish SideScanSonar
### Input: StarFish csv raw file (.csv)
### Output: Data frame [Time, Latitude, Longitude, UTM_N, UTM_E]

sssExtractGPS <- function(filepath) {
  
  t = file(filepath, "r")
  fields = scan(t, what = "character", sep = ",")
  posFields = which(fields == 'POS')
  close(t)
  
  TS_P = fields[posFields + 1]
  TS_P = strptime(x = TS_P, format = "%d/%m/%Y %H:%M:%S")
  LAT = fields[posFields + 2]
  LON = fields[posFields + 3]
  NOR = fields[posFields + 5]
  EST = fields[posFields + 6]
  
  # Data frame
  df_pos = data.frame(Time = TS_P, LAT = as.numeric(LAT),
                      LON = as.numeric(LON),
                      UTM_N = as.numeric(NOR),
                      UTM_E = as.numeric(EST))
  
  # Remove duplicate entries
  df_pos = df_pos[-which(duplicated(df_pos$Time)),]
  
  return(df_pos)
}

