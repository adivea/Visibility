## Intervisibility

library(foreach)
library(doParallel)
library(data.table)

source("scripts/VisibilityFunctions.R")

detectCores() # 22 as some are multi-threaded
detectCores(logical = FALSE) # 16 real ones

cl <- makeCluster(n) # keep 4 cores so screensaver can run on W11
registerDoParallel(cl)

# Start experiment
origin <- cbind(st_coordinates(origin_sf), h = o_height)
target <- cbind(st_coordinates(target_sf), h = t_height)

# nesting both i and e with foreach 
ie_table <- foreach (i= 1:nrow(origin), .combine = 'rbind',.packages = c("data.table", "raster")) %do% {
  print(i)
  foreach( e= 1:nrow(target), .combine = 'rbind',.packages = c("data.table", "raster")) %dopar% {
    print(e)
    result = cansee(Y_elev, origin[i,1:2], target[e,1:2], h1 = origin[i,3], h2 = target[e,3])
    result_row <- c(i,e, result)
  }
  
}
