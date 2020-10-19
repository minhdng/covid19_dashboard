#--------------------------------------------------------------------
###############################Install Related Packages #######################
if (!require("dplyr")) {
        install.packages("dplyr")
        library(dplyr)
}
if (!require("tibble")) {
        install.packages("tibble")
        library(tibble)
}
if (!require("tidyverse")) {
        install.packages("tidyverse")
        library(tidyverse)
}
if (!require("shinythemes")) {
        install.packages("shinythemes")
        library(shinythemes)
}

if (!require("sf")) {
        install.packages("sf")
        library(sf)
}
if (!require("RCurl")) {
        install.packages("RCurl")
        library(RCurl)
}
if (!require("tmap")) {
        install.packages("tmap")
        library(tmap)
}
if (!require("rgdal")) {
        install.packages("rgdal")
        library(rgdal)
}
if (!require("leaflet")) {
        install.packages("leaflet")
        library(leaflet)
}
if (!require("shiny")) {
        install.packages("shiny")
        library(shiny)
}
if (!require("shinythemes")) {
        install.packages("shinythemes")
        library(shinythemes)
}
if (!require("plotly")) {
        install.packages("plotly")
        library(plotly)
}
if (!require("ggplot2")) {
        install.packages("ggplot2")
        library(ggplot2)
}
if (!require("viridis")) {
        install.packages("viridis")
        library(viridis)
}


#------------------ Main link for quick summary -----------------------------#

update_URL <- getURL("https://raw.githubusercontent.com/nychealth/coronavirus-data/master/summary.csv")
quick_update <- read.csv(text = update_URL)

#------------------clean data for NYC map (tab 3) -----------------------#

#get NYC covid data based on Modified Zip code
# First get ZCTA (zip code) to MODZCTA data:

zcta_to_modzctaURL <- getURL("https://raw.githubusercontent.com/nychealth/coronavirus-data/master/Geography-resources/ZCTA-to-MODZCTA.csv")
zcta_to_modzcta <- read.csv(text=zcta_to_modzctaURL)

# NYC Covid data by MODZCTA:
data_by_modzctaURL <- getURL('https://raw.githubusercontent.com/nychealth/coronavirus-data/master/data-by-modzcta.csv')
data_by_modzcta <- read.csv(text= data_by_modzctaURL)

# get neighborhood
neighborhoods<- data_by_modzcta%>%
        select(MODIFIED_ZCTA,NEIGHBORHOOD_NAME, BOROUGH_GROUP, COVID_CASE_COUNT, COVID_CASE_RATE, PERCENT_POSITIVE)

# get individual neighborhood for restaurant map use
#bronxZip <-neighborhoods%>%
#        filter(BOROUGH_GROUP=="Bronx")

#manZip <-neighborhoods%>%
#        filter(BOROUGH_GROUP=="Manhattan")
#SIZip <-neighborhoods%>%
#        filter(BOROUGH_GROUP=="Staten Island")
#queensip <-neighborhoods%>%
#        filter(BOROUGH_GROUP=="Queens")
#BKzip<- neighborhoods%>%
#        filter(BOROUGH_GROUP=="Brooklyn")

#------------------- import data for interactive map ____________________#
#import geojson file from NYC open data
zipcode_geo <- sf::st_read("./output/ZIP_CODE_040114/ZIP_CODE_040114.shp") %>%
        sf::st_transform('+proj=longlat +datum=WGS84')


####################  SERVER R test try #####################
shinyServer(function(input, output) {
        
        map_base = leaflet(
                options = leafletOptions(dragging = T, 
                                         minZoom = 10, maxZoom = 16)
        ) %>%
                setView(lng = -73.92,lat = 40.73, zoom = 11) %>% 
                addTiles() %>%
                addProviderTiles("CartoDB.Positron")
        
        observe({
                
                output$map_covid = renderLeaflet({
                        
                        zipcode_geo = zipcode_geo %>% neighborhoods
                        
                        map_out = map_base
                        
                        map_out = map_out %>% 
                                addPolygons( data = zipcode_geo,
                                            weight = 0.5, color = "#41516C", fillOpacity = 0,
                                            popup = ~(paste0("<b>Zip Code: ",MODIFIED_ZCTA ,
                                                             "</b><br/>Borough: ",BOROUGH_GROUP,
                                                             "<br/>Infection Rate: ", PERCENT_POSITIVE,
                                                             "<br/>Confirmed Cases: ", COVID_CASE_COUNT)),
                                            highlight = highlightOptions(weight = 2,
                                                                         color = "red",
                                                                         bringToFront = F)) %>%
                                
#                               addCircleMarkers(data = neighborhoods,
#                                                lng = ~LNG_repre, lat = ~LAT_repre,
#                                                color = "#2C6BAC", fillOpacity = 0.7,
#                                         radius = ~(cases)/175, 
#                                                 popup = ~(paste0("<b>Zip Code: ",MODIFIED_ZCTA , 
#                                                                  "</b><br/>Confirmed Cases: ",COVID_CASE_COUNT)),
#                                                 group = "Covid Cases") %>% 
                             
                        
                        map_out = map_out %>% 
                                addLayersControl(overlayGroups = "Covid Cases") 
                        
                })
                leafletProxy("map_base")
                
        })



