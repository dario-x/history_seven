library(shiny)
library(leaflet)
library(tidyverse)

library(sf)

library(raster)
library(rgeos)
library(mapview)

library(scales)
library(shinyaframe)

library(conflicted)
conflict_prefer("filter", "dplyr")
conflict_prefer("select", "dplyr")
conflict_prefer("rescale", "scales")

r_colors <- rgb(t(col2rgb(colors()) / 255))
names(r_colors) <- colors()

######## DATA LOAD ############################################################

# read in the history data
district_data = tibble(read.csv("./data/district_data.csv", sep=";"))

# get the boundaries of the 7th district
vienna_boundaries = read.csv("./data/BEZIRKSGRENZEOGD.csv")
filter_mask = vienna_boundaries %>% filter(BEZNR == 7) %>% select(SHAPE) %>% unlist()
filter_mask = gsub("\\,", "", gsub("SHAPE", "",gsub("POLYGON", "",gsub("\\(", "", gsub(")", "", filter_mask)))))
filter_mask  = str_trim(filter_mask)
filter_list = split(filter_mask, " ")
#extract longitude and latitude
x1=c()
x2=c()
i=1
for (n in strsplit(filter_mask, " ")[[1]]){
  if(i == 1){
    x1=append(x1, as.double(n))
    i = 0
  }else{
    x2=append(x2, as.double(n))
    i = 1
  }
} 
#create spatialpolygon
p = Polygon(cbind(x1, x2))
ps = Polygons(list(p),1)
filter_mask = SpatialPolygons(list(ps))
# create a filter mask using worldwide raster as template
world = rasterToPolygons(raster(ncol = 1, nrow = 1, crs = proj4string(filter_mask)))
filter_mask = gDifference(world, filter_mask)


# create icons to be used for markers in map 
history_icons = iconList(
  Anschlag = makeIcon(iconRetinaUrl = "./icons/flames.png", 18, 18),  
  Kaffeehaus = makeIcon(iconRetinaUrl = "./icons/coffee.png", 10, 10),  
  Theater = makeIcon(iconRetinaUrl = "./icons/culture-cinema.png", 10, 10),  
  Denkmal = makeIcon(iconRetinaUrl = "./icons/sculpture.png", 6, 6),  
  Park = makeIcon(iconRetinaUrl = "./icons/leafs-color.png", 15, 15),  
  Kirche = makeIcon(iconRetinaUrl = "./icons/church.png", 24, 24),  
  Apotheke_Spital_Anstalt =  makeIcon(iconRetinaUrl = "./icons/medical-briefcase-kit.png", 18, 18),  
  NS_Institution =  makeIcon(iconRetinaUrl = "./icons/danger.png", 16, 16),  
  Kino =  makeIcon(iconRetinaUrl = "./icons/film-movies.png", 10, 10),  
  Bauwerk =  makeIcon(iconRetinaUrl = "./icons/house.png", 14, 14),  
  Brunnen = makeIcon(iconRetinaUrl = "./icons/water-droplet.png", 14, 14),
  Schule = makeIcon(iconRetinaUrl = "./icons/school.png", 14, 14),
  Firma_Verlag_Institution = makeIcon(iconRetinaUrl = "./icons/business.png", 10, 10)
)



##############################################################################




ui <- bootstrapPage(
  
  theme = shinythemes::shinytheme("lumen"),
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  
  
  
  #tabsetPanel(
    
    #tabPanel("Plot", 
  
  
              
       leafletOutput("map", width = "100%", height = "100%"),
       
      
       absolutePanel(top = 10, right = 10, draggable = TRUE,
       
       titlePanel("History of the 7th district"),
       sliderInput('year', 'Choose a year you are interested in',value=1735, min=1211,max= 2000, step = 1, sep = ""),
       checkboxInput("legend", "Show legend", TRUE),
       
       )
                 
 
             
    #),
             
    #tabPanel("VR", 
       #aDataSceneOutput(
       # server output variable name
       #outputId = "mydatascene",
       # add backdrop
       #environment = "",
       
       
       # gg-aframe plot syntax
       #atags$entity(
         # an empty string sets attributes with no additional properties
        # plot = "",
         # sizable scale option uses polyhedra scaled for equivalent volumes
         #`scale-shape` = "sizable",
         #position = "0 1.6 -1.38",
         #atags$entity(
          # `layer-point` = "",
           #`data-binding__sepal.length`="target: layer-point.x",
           #`data-binding__sepal.width`="target: layer-point.y",
           #`data-binding__petal.length`="target: layer-point.z",
           #`data-binding__species`="target: layer-point.shape",
           #`data-binding__petal.width.size`="target: layer-point.size",
           #`data-binding__species.color`="target: layer-point.color"
         #),
         #atags$entity(
          # `guide-axis` = "axis: x",
          # `data-binding__xbreaks` = "target: guide-axis.breaks",
          # `data-binding__xlabels` = "target: guide-axis.labels",
          # `data-binding__xtitle` = "target: guide-axis.title"
         #))
         #)
        #)
        


  #)
  
)


server <- function(input, output, session) {
  
  # Reactive expression for the data subsetted to what the user selected
  filtered_data = reactive({
   district_data %>% filter(DATUM_VON <= input$year, DATUM_BIS >= input$year | DATUM_BIS == 0)
  })
  
  
  output$map <- renderLeaflet({
   leaflet(data = filtered_data()) %>%
      
      #define the map theme - a bw theme was used to draw attention to icons
      addProviderTiles("CartoDB.Positron", mask) %>%
      
      
      addMarkers(~LONG, ~LAT, icon = ~history_icons[TYPE], label = ~SEITENNAME) %>%
      
      fitBounds(min(district_data$LONG), min(district_data$LAT), max(district_data$LONG), max(district_data$LAT)) %>%
      
      addPolygons(data=filter_mask, color="white", weight = 0, opacity = 0.5, fillOpacity = 0.8)
  })
  
  output$mydatascene <- renderADataScene({
    
    names(iris) <- tolower(names(iris))
    # Margin in (0,1) scale keeps polyhedra from sticking out of plot area
    positional_to <- c(0.01, 0.99)
    # convert to #RRGGBB color
    color_scale = setNames(rainbow(3, 0.75, 0.5, alpha = NULL),
                           unique(iris$species))
    iris %>%
      # scale positional data
      mutate_if(is.numeric, rescale, to = positional_to) %>%
      # scale size data to relative percentage, using cube root to correct
      # for radius->volume perception bias
      mutate(petal.width.size = rescale(petal.width^(1/3), to = c(0.5, 2)),
             species.color = color_scale[species]) ->
      iris_scaled
    
    # provide guide info
    make_guide <- function (var, aes, breaks = c(0.01, 0.5, 0.99)) {
      guide = list()
      domain = range(iris[[var]])
      guide[[paste0(aes, "breaks")]] <- breaks
      guide[[paste0(aes, "labels")]] <- c(domain[1],
                                          round(mean(domain), 2),
                                          domain[2])
      guide[[paste0(aes, "title")]] <- var
      guide
    }
    Map(make_guide,
        var = c("sepal.length", "sepal.width", "petal.length"),
        aes = c("x", "y", "z")) %>%
      # repeat radius adjustment in the guide
      c(list(make_guide("petal.width", "size", c(0.5, 1.25, 2)^(1/3)))) %>%
      Reduce(f = c) ->
      guides
    guides$shapetitle = "species"
    guides$colortitle = "species"
    guides$colorbreaks = color_scale
    guides$colorlabels = names(color_scale)
    
    # convert data frame to list and combine with guides list
    aDataScene(c(iris_scaled, guides))
  })
  
  
  
}

#launch the app
shinyApp(ui = ui, server = server)

