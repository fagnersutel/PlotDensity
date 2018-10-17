library(ggplot2)
library(ggthemes)
library(scales)
library(ggmap)
library(MASS)
library(sp)
library(viridis)

pop <- read.csv("~/r-files/PlotDensity/PopulationDensity.csv", header=TRUE, stringsAsFactors=FALSE)

# get density polygons
dens <- contourLines(
  kde2d(pop$LONG, pop$LAT, 
        lims=c(expand_range(range(pop$LONG), add=0.5),
               expand_range(range(pop$LAT), add=0.5))))

head(dens)
# this will be the color aesthetic mapping
pop$Density <- 0

# density levels go from lowest to highest, so iterate over the
# list of polygons (which are in level order), figure out which
# points are in that polygon and assign the level to them

for (i in 1:length(dens)) {
  tmp <- point.in.polygon(pop$LONG, pop$LAT, dens[[i]]$x, dens[[i]]$y)
  pop$Density[which(tmp==1)] <- dens[[i]]$level
}

Canada <- get_map(location="Canada", zoom=3, maptype="terrain")

gg <- ggmap(Canada, extent="normal")
gg <- gg + geom_point(data=pop, aes(x=LONG, y=LAT, color=Density))
gg <- gg + scale_color_viridis()
gg <- gg + theme_map()
gg <- gg + theme(legend.position="none")
gg

rm(gg)
gg <- ggmap(Canada, extent="normal")
gg <- gg + geom_point(data=pop, aes(x=LONG, y=LAT, color=Density, size = Density))
gg <- gg + scale_color_viridis()
gg <- gg + theme_map()
gg <- gg + theme(legend.position="none")
gg
