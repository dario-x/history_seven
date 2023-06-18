library(shiny)
library(leaflet)
library(tidyverse)

library(sf)

library(raster)
library(rgeos)
library(mapview)

library(shinyaframe)

Sys.setlocale("LC_ALL","en_US")


r_colors <- rgb(t(col2rgb(colors()) / 255))
names(r_colors) <- colors()

######## DATA LOAD ############################################################


# read in the history data
district_data = tibble(read.csv("./data/district_data.csv", sep=";"))
district_data = tibble::rowid_to_column(district_data, "id")

# get the boundaries of the 7th district
vienna_boundaries = readRDS(file = "./data/vienna_boundaries.rds")
filter_mask = vienna_boundaries %>% dplyr::filter(BEZNR == 7) %>% dplyr::select(SHAPE) %>% unlist()
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
  coffee_house = makeIcon(iconRetinaUrl = "./icons/coffee.png", 10, 10),  
  theatre = makeIcon(iconRetinaUrl = "./icons/culture-cinema.png", 15, 15),  
  statue = makeIcon(iconRetinaUrl = "./icons/sculpture.png", 6, 6),  
  park = makeIcon(iconRetinaUrl = "./icons/leafs-color.png", 15, 15),  
  church = makeIcon(iconRetinaUrl = "./icons/church.png", 24, 24),  
  health_institution =  makeIcon(iconRetinaUrl = "./icons/medical-briefcase-kit.png", 18, 18),  
  NS_institution =  makeIcon(iconRetinaUrl = "./icons/danger.png", 16, 16),  
  cinema =  makeIcon(iconRetinaUrl = "./icons/film-movies.png", 10, 10),  
  building =  makeIcon(iconRetinaUrl = "./icons/house.png", 14, 14),
  school = makeIcon(iconRetinaUrl = "./icons/school.png", 14, 14),
  farm = makeIcon(iconRetinaUrl = "./icons/farm.png", 30, 30),
  settlement = makeIcon(iconRetinaUrl = "./icons/settlement.png", 30, 30)
)


##############################################################################


ui <- bootstrapPage(
  
  tags$style(type = "text/css", "html,
             body {
                width: 100%;
                height: 100%;
             }
            .jslider-value {font-size: 50px;}
            .leaflet-fade-anim .leaflet-tile, .leaflet-fade-anim .leaflet-popup {opacity: 1 !important;}"),
  
  theme = shinythemes::shinytheme("lumen"),
  

  
  leafletOutput("map", width = "100%", height = "100%"),
  tags$div(
    style = "position: absolute; bottom: 5px; left: 10px; font-size: 12px;",
    "Data taken from open.data.gv objects: 
    https://www.data.gv.at/katalog/dataset/71ef28d3-58a4-4087-8b31-c192792beb0e 
    (for historic buildings) - and 
    https://www.data.gv.at/katalog/dataset/stadt-wien_bezirksgrenzenwien 
    (for the boundaries)"
  ),
  
  
  
  absolutePanel(top = 10, right = 10, draggable = TRUE,
                
                titlePanel("History of the 7th district"),
                
                
                
                sliderInput('year', 'This is the year counter
                            It will increase each second by one year.
                            Alternatively you can
                            triple click to choose a year you are interested in',
                            value=1280, min=1211,max= 2000, step = 1, sep = ""),
                
                
                tags$audio(
                  id = "audio",
                  src = "sound.mp3",
                  type = "audio/mp3",
                  controls = "controls",
                  autoplay = TRUE,
                ),
                
                
                checkboxInput("show_legend", "Show legend"),
                
                conditionalPanel(
                  condition = "input.show_legend",
                  img(src = "legend.jpg", height = 586, width = 232)
                )
                
  )
  
  
  
)




server <- function(input, output, session) {
  
  
  
  # Reactive expression for the data subsetted to what the user selected
  filtered_data = reactive({
    district_data %>% dplyr::filter(date_of_origin <= input$year, date_of_destruction >= input$year | date_of_destruction == 0)
  })
  
  start_data = district_data %>% dplyr::filter(date_of_origin <= 1303, date_of_destruction >= 1303 | date_of_destruction == 0)
  
  marker_group <- addMarkers(leaflet(), data=district_data %>% dplyr::filter(date_of_origin <= 1303, date_of_destruction >= 1303 | date_of_destruction == 0),
                             ~LONG, 
                             ~LAT, 
                             icon = ~history_icons[TYPE], 
                             label = ~page_name)
  
  output$map <- renderLeaflet({
    leaflet(data = district_data) %>%
      
      
      #define the map theme - a bw theme was used to draw attention to icons
      addProviderTiles("CartoDB.Positron", mask) %>%

      addMarkers(data=district_data %>% dplyr::filter(date_of_origin <= 1303, date_of_destruction >= 1303 | date_of_destruction == 0),
                 layerId=as.character(district_data$id),
                 ~LONG, 
                 ~LAT, 
                 icon = ~history_icons[TYPE], 
                 label = ~page_name,
                 group = "Markers") %>%
      
      fitBounds(min(district_data$LONG), 
               min(district_data$LAT), 
               max(district_data$LONG), 
               max(district_data$LAT)) %>%
      
      addPolygons(data=filter_mask, color="white", weight = 0, opacity = 0.5, fillOpacity = 0.8) 
    
    
  })
  
  
  
  
  
  
  
  # Create a reactive timer is used to update 
  # the value of the slider each second by one
  timer = reactiveTimer(1000, session)
  # Update the slider input every time the timer triggers
  observeEvent(timer(), {
    updateSliderInput(session, "year", value = input$year + 1)
  })
  
  
  observeEvent(input$year, {
    proxy <- leafletProxy("map", session, deferUntilFlush = TRUE)
    proxy %>%
      clearMarkers() %>%
      addMarkers(data = filtered_data(),
                 ~LONG, ~LAT, icon = ~history_icons[TYPE], 
                 label = ~page_name,
                 group = "Markers") 
  })
  
  
}

#launch the app
shinyApp(ui = ui, server = server)

