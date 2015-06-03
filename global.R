# Source files

# Global data frame of extracted GPS positions
df_gps = data.frame()

# function sssExtractGPS (extract GPS positions from raw CSV Tritech StarFish SideScanSonar)
source("source/sssExtractGPS.R")
# function sssGPS2SHP (export positions from Tritech StarFish SideScanSonar to line shapefile)
source("source/sssGPS2SHP.R")