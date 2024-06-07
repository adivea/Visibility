## Mosaic rasters

library(sf)
library(raster)
library(tidyverse)
library(mapview)

# rasters downloaded from https://gdemdl.aster.jspacesystems.or.jp/index_en.html
YT_elev <- raster("data/large/YT_elev32635.tif")
BR_elev <- raster("data/large/ASTGTMV003_N42E027/ASTGTMV003_N42E027_dem.tif")
YA_elev <- raster("data/large/ASTGTMV003_N42E026/ASTGTMV003_N42E026_dem.tif")
ZA_elev <- raster("data/large/ASTGTMV003_N42E025/ASTGTMV003_N42E025_dem.tif")
TU_elev <- raster("data/large/ASTGTMV003_N41E026/ASTGTMV003_N41E026_dem.tif")
TS_elev <- raster("data/large/ASTGTMV003_N41E027/ASTGTMV003_N41E027_dem.tif")

# region admin
region <- read_sf("data/YamRegion.shp")
Y_buf25 <- st_buffer(region, 25000)
extent(st_transform(Y_buf25, 4326))

# mosaic and crop rasters to the extent of map mounds
Y <- mosaic(ZA_elev,YA_elev, BR_elev, TU_elev, TS_elev, fun = mean)
extent(Y) 
Y_crop <- crop(Y, extent(25.0, 28.00014,41.7,43.00014 ) )
plot(Y_crop)

Y35 <- projectRaster(Y_crop, crs = 32635, method = "bilinear")
writeRaster(Y35, "data/large/Y_elev_ext.tif",format="GTiff", overwrite=TRUE)

# plot final raster with Yambol region buffer and map mounds
plot(Y35);plot(st_geometry(Y_buf25), add = T);plot(mm$geometry, add = T)
