###############################
###  AZB rewriting cleaning/visualizing spotlight survey maps and data
###############################

getwd()

library(tidyverse)
library(rgdal)
library(sp)
library(sf)
library(lattice)
library(raster)
library(rasterVis)
library(terra)

####These lines define maps from files in directory
shrubs <- raster::raster("rcmap_shrub_2020.img")
invasives <- raster::raster("rcmap_annual_herbaceous_2020.img")
routes <- sf::st_read("Km_Markings_2022.shp")
NCA <- sf::st_read(dsn= "BOPNCA_Boundary.shp")

###Converting objects made earlier into new cleaned layers
crstracks <- sf::st_crs(NCA)
NCA_buf <- NCA %>% sf::st_buffer(dist=5e3)
NCA_trans <- sf::st_transform(NCA_buf, st_crs(shrubs))

### Attempt to move temp folder into C drive at lowest level
### in case if full appdata/temp file was too full
###### No success.
options(rasterTmpDir = "C:/rtmp")

### Overlaying the boundaries of the NCA onto shrub/invasive layers
###### No success here either
###### I'm guessing the datum=WGS84/83 difference between the two
###### an incompatibility. Unsure of how to fix with the resources I have
shrubCrop <- raster::crop(shrubs, NCA_trans)
invCrop <- raster::crop(invasives, NCA_trans)

### Plotting the layers I do have
### shrubCrop would have been used instead of shrub,
### but y'know...
terra::plot(shrubs, main = "Native Shrubs (2020)")

### Error in raster here also. Error in rgdal? No idea
rasterVis::levelplot(shrubs)
rasterVis::levelplot(invasives)
