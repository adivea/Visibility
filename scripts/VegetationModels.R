# Binomial distribution function; probability refers to 
# completeness of coverage, 05 = 50% of terrain covered 
# size refers to vegetation height, see 
#https://www.monumentaltrees.com/en/records/bgr/ for height examples

# Test first
?rbinom()
r <- raster(ncol = 100, nrow = 100)
test <- rbinom(n=10000, size=1, prob=0.50)
test <- setValues(r, test)
plot(test)

# Terrain BOM
Y_elev <- raster("data/large/Yelev32635.tif")
plot(Y_elev)

# Vegetation static 10m 
r <- raster(Y_elev)
x <- rbinom(n=ncell(Y_elev), size=1, prob=0.50)
veg10m <- setValues(r, x)
veg10m[veg10m >= 1] <- 10
veg10m[veg10m < 1] <- 0
plot(veg10m)
hist(values(veg10m))

mapview(veg10m)+mapview(Y_region)

# Vegetation variable 20m
r <- raster(Y_elev)
x <- rbinom(n=ncell(Y_elev), size=20, prob=0.50)
summary(x)
veg20mgradual <- setValues(r, x)
plot(veg20mgradual)
hist(values(veg20mgradual))

############# Overlay of vegetation over yambol elev
new_extent <- extent(veg10m)
elev_cropped <- crop(Y_elev, new_extent)

Y_elev10 <- overlay(elev_cropped, 
                    veg10m, 
                    fun = function(x, y) ifelse(!is.na(x), x + y, y))
hist(values(Y_elev10))
hist(values(elev_cropped))

Y_elev20grad <- overlay(elev_cropped, 
                        veg20mgradual, 
                        fun = function(x, y) ifelse(!is.na(x), x + y, y))
hist(values(Y_elev20grad))
hist(values(elev_cropped))

plot(Y_elev10)

############### Recalculate prominence
# with the modelled patchy vegetation
# prom_radius(Y_elev10, 500)
# prom_radius(Y_elev20grad, 550)

############## Extract prominence at 250 radius
library(FSA)
region <- read_sf("data/YamRegion.shp")

Yam_mnds$veg10prom <- raster::extract(Y_elev10, st_sf(Yam_mnds), buffer = 250,
                                      fun = function(x){perc(x,x[length(x)/2],"lt", na.rm = FALSE, digits = 2)})


Yam_mnds$veg20prom <- raster::extract(Y_elev20grad, st_sf(Yam_mnds), buffer = 250,
                                      fun = function(x){perc(x,x[length(x)/2],"lt", na.rm = FALSE, digits = 2)})

hist(Yam_mnds$veg10prom, main = "Prominence range within the Yambol landscape \n with 10m vegetation", xlab = "Prominence (%)")
hist(Yam_mnds$veg20prom, main = "Prominence range within the Yambol landscape \n with 20m vegetation", xlab = "Prominence (%)")

randompoints <- sf::st_sample(region, size = 1500) # generate sample as big as the mounds
randompoints <- randompoints %>% st_as_sf()
plot(region$geometry);plot(randompoints, add= T)


randompoints$prom250buff <- raster::extract(Y_elev,    
                                          st_as_sf(randompoints),     
                                          buffer = 250,           
                                          fun = function(x){perc(x,x[length(x)/2],"lt", na.rm = FALSE, digits = 2)})

randompoints$veg10prom <- raster::extract(Y_elev10,    
                                     st_sf(randompoints),     
                                     buffer = 250,           
                                     fun = function(x){perc(x,x[length(x)/2],"lt", na.rm = FALSE, digits = 2)})
randompoints$veg20prom <- raster::extract(Y_elev20grad,    
                                          st_sf(randompoints),     
                                          buffer = 250,           
                                          fun = function(x){perc(x,x[length(x)/2],"lt", na.rm = FALSE, digits = 2)})


hist(randompoints$prom250buff, main = "Prominence range within the Yambol landscape", xlab = "Prominence (%)")

###################  Prominence at 2000 m radius
library(FSA)
Yam_mnds$veg10prom2000 <- raster::extract(Y_elev10, st_sf(Yam_mnds), 
                                          buffer = 2000,
                                      fun = function(x){perc(x,x[length(x)/2],"lt", na.rm = FALSE, digits = 2)})


Yam_mnds$veg20prom2000 <- raster::extract(Y_elev20grad, st_sf(Yam_mnds), 
                                      buffer = 2000,
                                      fun = function(x){perc(x,x[length(x)/2],"lt", na.rm = FALSE, digits = 2)})

hist(Yam_mnds$veg10prom2000, main = "Prominence range within the Yambol landscape \n with 10m vegetation", xlab = "Prominence (%)")
hist(Yam_mnds$veg20prom2000, main = "Prominence range within the Yambol landscape \n with 20m vegetation", xlab = "Prominence (%)")

randompoints <- sf::st_sample(region, size = 1500) # generate sample as big as the mounds
plot(region$geometry);plot(randompoints, add= T)


randompoints$veg10prom2000 <- raster::extract(Y_elev10,    
                                          st_sf(randompoints),     
                                          buffer = 2000,           
                                          fun = function(x){perc(x,x[length(x)/2],"lt", na.rm = FALSE, digits = 2)})
randompoints$veg20prom2000 <- raster::extract(Y_elev20grad,    
                                          st_sf(randompoints),     
                                          buffer = 2000,           
                                          fun = function(x){perc(x,x[length(x)/2],"lt", na.rm = FALSE, digits = 2)})


