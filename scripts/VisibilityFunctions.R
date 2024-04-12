cansee <- function(r, xy1, xy2, h1=0, h2=0){
  ### can xy1 see xy2 on DEM r?
  ### Y_elev is a DEM in same x,y, z units
  ### xy1 and xy2 are 2-length vectors of x,y coords
  ### h1 and h2 are extra height offsets (ie. mound heights)
  ###  (eg top of mast, observer on a ladder etc)
  xyz = rasterprofile(r, xy1, xy2)
  np = nrow(xyz)-1
  h1 = xyz$z[1] + h1
  h2 = xyz$z[np] + h2
  hpath = h1 + (0:np)*(h2-h1)/np
  return(!any(hpath < xyz$z))
}

viewTo <- function(r, xy, xy2, h1=0, h2=0, progress="none"){
  ## xy2 is a matrix of x,y coords (not a data frame)
  require(dplyr)
  apply(xy2, 1, function(d){cansee(r,xy,d,h1,h2)}, .progress=progress)
}

viewTo <- function(r, xy, xy2, h1=0, h2=0){
  ## xy2 is a matrix of x,y coords (not a data frame)
  require(dplyr)
  apply(xy2, 1, function(d){cansee(r,xy,d,h1,h2)})
}

rasterprofile <- function(r, xy1, xy2){
  ### sample a raster along a straight line between two points
  ### try to match the sampling size to the raster resolution
  dx = sqrt( (xy1[1]-xy2[1])^2 + (xy1[2]-xy2[2])^2 )
  nsteps = 1 + round(dx/ min(res(r)))
  xc = xy1[1] + (0:nsteps) * (xy2[1]-xy1[1])/nsteps
  yc = xy1[2] + (0:nsteps) * (xy2[2]-xy1[2])/nsteps
  data.frame(x=xc, y=yc, z=r[cellFromXY(r,cbind(xc,yc))])
}