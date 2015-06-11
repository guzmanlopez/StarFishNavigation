Tritech StarFish 990F Sidescan Sonar GPS extraction tool
===

This is a Shiny web app.
It is written on [R programming languaje](http://cran.r-project.org/ "R webpage") using the [Shiny library](http://shiny.rstudio.com/ "Shiny webpage") to develop the General User Interface.
With this tool you can import [Tritech StarFish 990F](http://www.tritech.co.uk/product/starfish-990f-high-resolution-side-scan-sonar-shallow-water0 "Tritech webpage") Sidescan Sonar CSV raw files from [ScanLine software](http://www.tritech.co.uk/support-software/starfish-seabed-imaging-systems-scanline "Scanline software webpage") and extract the navigation as:

- Text datatables (.csv)
- ESRI Shapefiles (.shp)
- KML file format (.kml)

The aim of this software is "fast extract" of the navigation data to visualize it on a GIS software like [QGIS](http://www.qgis.org "QGIS webpage").

You can run a demo [here](https://glopez.shinyapps.io/StarFishNavigation "shinyapps.io"), but I suggest run it locally using R because the csv raw files are generally big files (hundreds of megabytes) to upload over internet.

R packages dependencies
===

```R
library('shiny')
library('sp')
library('maptools')
library('geosphere')
library('stringr')
library('xts')
```

To install the requiered packages you can execute in R:

```R
install.packages("shiny")
install.packages("stringr")
install.packages("xts")
install.packages("sp")
install.packages("maptools")
install.packages("rgdal")
```

Run the app
===

Execute in R:

```R
shiny::runGitHub('guzmanlopez/StarFishNavigation')
```

Screenshot
===

![Image](https://raw.githubusercontent.com/guzmanlopez/StarFishNavigation/master/images/screenshot01.png)

Future developments
===

- Extract and show the backscatter data.


License
===

GPLv3
