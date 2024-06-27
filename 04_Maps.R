e <- drawExtent(show = T, col = "blue")
plot(Y35); plot(region$geometry, add =T)
b <- st_make_grid(st_bbox(Y_buf25), n =1)
c <- st_make_grid(st_bbox(region), n =1)

d <- st_make_grid(st_bbox(st_buffer(region, 5000)), n =1)

plot(Y35); plot(b, add =T); plot(c, borders = "red", add =T); plot(region$geometry, add =T)

plot(Y);plot(b, add =T); plot(c, borders = "red", add =T); plot(region$geometry, add =T)

dem_Y25 <- crop(Y, b)
dem_Y5 <- crop(Y, d)
dem_Y <- crop(Y, c)
plot(dem_sm); plot(region$geometry, add =T)
plot(dem_Y5, col = grey.colors(6, start = 1, end = 0)); plot(region$geometry, add =T); plot(Yam_mnds$geometry, cex= 0.5, add =T)
writeRaster(dem_Y5, "data/large/Y_dem5.tif")
