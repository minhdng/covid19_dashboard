############################# Install Packages #######################
# template:
#   if (!require("PACKAGE")) {install.packages("PACKAGE"); library(PACKAGE) }
#
# data cleaning
if (!require("dplyr")) {install.packages("dplyr"); library(dplyr) }
if (!require("tibble")) {install.packages("tibble"); library(tibble)}
if (!require("tidyverse")) {install.packages("tidyverse"); library(tidyverse)}

# shiny 
if (!require("shiny")) {install.packages("shiny"); library(shiny)}
#if (!require("shinythemes")) {install.packages("shinythemes"); library(shinythemes)}
if (!require("shinydashboard")) {install.packages("shinydashboard"); library(shinydashboard)}
if (!require("shinyjs")) {install.packages("shinyjs"); library(shinyjs) }
if (!require("dashboardthemes")) {install.packages("dashboardthemes"); library(dashboardthemes)}
# if (!require("sf")) {install.packages("sf"); library(sf)}


# map
if (!require("RCurl")) {install.packages("RCurl"); library(RCurl)}
if (!require("tmap")) {install.packages("tmap"); library(tmap)}
if (!require("rgdal")) {install.packages("rgdal"); library(rgdal)}

# plotting
if (!require("highcharter")) {install.packages("highcharter"); library(highcharter)}
if (!require("plotly")) {install.packages("plotly"); library(plotly)}
if (!require("ggplot2")) {install.packages("ggplot2"); library(ggplot2)}
# if (!require("viridis")) {install.packages("viridis"); library(viridis)}

# maps
if (!require("leaflet")) {install.packages("leaflet"); library(leaflet)}
if (!require("ggmap")) {install.packages("ggmap"); library(ggmap) }
if (!require("geojsonio")) {install.packages("geojsonio"); library(geojsonio) }

# restaurant info
if (!require("data.table")) {install.packages("data.table"); library(data.table) }
if (!require("DT")) {install.packages("DT"); library(DT) }
if (!require("htmlwidgets")) {install.packages("htmlwidgets"); library(htmlwidgets) }
if (!require("sparkline")) {install.packages("sparkline"); library(sparkline) }



############################### Utilities Functions #######################


cleanCountryNames <- function(df){
    # Input dataframe and change the Country/Region column into standard format
    # Output formatted dataframe
    # This function is used in:
    #       cleanGlobalData
    # 
    df$Country.Region <- as.character(df$Country.Region)
    df$Country.Region[df$Country.Region == "Congo (Kinshasa)"] <- "Dem. Rep. Congo"
    df$Country.Region[df$Country.Region == "Congo (Brazzaville)"] <- "Congo"
    df$Country.Region[df$Country.Region == "Central African Republic"] <- "Central African Rep."
    df$Country.Region[df$Country.Region == "Equatorial Guinea"] <- "Eq. Guinea"
    df$Country.Region[df$Country.Region == "Western Sahara"]<-"W. Sahara"
    df$Country.Region[df$Country.Region == "Eswatini"] <- "Eswatini"
    df$Country.Region[df$Country.Region == "Taiwan*"] <- "Taiwan"
    df$Country.Region[df$Country.Region == "Cote d'Ivoire"] <-"Côte d'Ivoire"
    df$Country.Region[df$Country.Region == "Korea, South"] <- "South Korea"
    df$Country.Region[df$Country.Region == "Bosnia and Herzegovina"] <- "Bosnia and Herz."
    df$Country.Region[df$Country.Region == "US"] <- "United States of America"
    df$Country.Region[df$Country.Region == "Burma"]<-"Myanmar"
    df$Country.Region[df$Country.Region == "Holy See"]<-"Vatican"
    df$Country.Region[df$Country.Region == "South Sudan"]<-"S. Sudan"
    return(df)
}


cleanGlobalData <- function(df) {
    # Input dataframe and aggregate province rows into single country row
    # Output 
    # 	rownames = country names
    # 	colnames = dates
    #    
    # clean the country/region names
    df <- cleanCountryNames(df)
    
    # columns that don't need 
    # see exploratory analysis for more details
    unused_cols <- c("Province.State","Lat","Long")
    
    # aggregate the province into country level
    df_output <- df %>% group_by(Country.Region) %>% 
        select( - one_of(unused_cols) ) %>% summarise_all(sum)
    
    # assign the country name into row names 
    df_output <- df_output %>% remove_rownames %>% 
        tibble::column_to_rownames(var="Country.Region")
    
    # change the column name into date format
    date_names <- colnames(df_output)
    
    # change date format from "xM.DD.YY" to "YYYY-MM-DD"
    date_choices <- as.Date(date_names, format='X%m.%d.%y')
    
    # assign column name
    colnames(df_output) <- date_choices
    
    return(df_output)
}


cleanUSData <- function(df) {
    # Input dataframe and aggregate province rows into state rows
    # Output 
    # 	row = State names
    # 	col = dates
    #
    # columns that don't need 
    unused_cols <- c("UID","iso2", "iso3", "code3", "FIPS", "Admin2", 
                     "Country_Region","Lat","Long_", "Combined_Key")
    
    # aggregate the province into country level
    df_output <- df %>% group_by(Province_State) %>% 
        select( - one_of(unused_cols) ) %>% summarise_all(sum)
    
    # assign the country name into row names 
    df_output <- df_output %>% remove_rownames %>% 
        tibble::column_to_rownames(var="Province_State")
    
    # change the column name into date format
    date_names <- colnames(df_output)
    
    # change date format from "xM.DD.YY" to "YYYY-MM-DD"
    date_choices <- as.Date(date_names, format='X%m.%d.%y')
    
    # assign column name
    colnames(df_output) <- date_choices
    
    # remove first column
    df_output[, 1] <- NULL
    
    return(df_output)
}


convertToDaily <- function(df) {
    # From cumulative data (either global or US), convert to daily new case data   
    # Input: dataframe of cumulative cases
    #   columns: dates
    #   rows: countries/states
    # Output: dataframe of daily cases
    
    len = length(df)
    
    # make output data frame
    # put the first column to last
    df_daily <- df[, c(2:len, 1)]
    
    # daily cases = today cases - yesterday cases
    df_daily <- df_daily - df
    
    # remove df_daily last col
    df_daily[, len] <- NULL
    
    # put back first col of df into df_daily
    # Note: since the first day of data set have no daily data
    #       use cumulative data for first day
    df_daily <- cbind( df[[1]], df_daily )
    names(df_daily)[1] <- names(df)[1]
    
    return(df_daily)
}


getLastestCount <- function(df, n=0) {
    l = length(df)
    return( sum(df[ ,(l-n):l]) )
}


getLastestData <- function(df, n=11) {
    l <- length(df)
    
    # create new data frame from country/state name and lastest cases
    df_last <- as.data.frame( cbind( name = rownames(df), cases = df[, l]) )
    df_last$cases <- as.numeric(df_last$cases)
    
    # sort in decending order of cases
    df_last <- df_last[ order(- df_last$cases), ]
    
    # trim
    df_last_trimmed <- df_last[1:n, ]
    
    # append a new row for trimmed data
    df_last_trimmed <- 
        rbind( df_last_trimmed, 
               c( "Others", getLastestCount(df) - sum(df_last_trimmed$cases) )  
    )
    df_last_trimmed$cases <- as.numeric(df_last_trimmed$cases)
    
    return(df_last_trimmed)
}


############################### Global Data ###############################
# Data Sources
# "Dong E, Du H, Gardner L. 
# An interactive web-based dashboard to track COVID-19 in real time. 
# Lancet Inf Dis. 20(5):533-534. doi: 10.1016/S1473-3099(20)30120-1"


# get and clean global cumulative confirmed cases data from API 
confirmed_global_URL <- getURL("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv")
confirmed_global_raw <- read.csv(text = confirmed_global_URL)
confirmed_global <- as.data.frame( cleanGlobalData(confirmed_global_raw) )
confirmed_global_t <- as.data.frame( t(confirmed_global) )

# convert to global daily confirmed cases
confirmed_global_daily <- convertToDaily(confirmed_global)
confirmed_global_daily_t <- as.data.frame( t(confirmed_global_daily) )

# define date for plotting
date_choices_global <- as.Date(colnames(confirmed_global), format = "%Y-%m-%d")

# define country for plotting
country_names_choices <- rownames(confirmed_global)


# get and clean global cumulative deaths cases data from API 
deaths_global_URL <- getURL("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv")
deaths_global_raw <- read.csv(text = deaths_global_URL)
deaths_global <- as.data.frame( cleanGlobalData(deaths_global_raw) )
deaths_global_t <- as.data.frame( t(deaths_global) )

# convert to global daily deaths cases
deaths_global_daily <- convertToDaily(deaths_global)
deaths_global_daily_t <- as.data.frame( t(deaths_global_daily) )

# get and clean global cumulative recovered cases data from API 
recovered_global_URL <- getURL("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv")
recovered_global_raw <- read.csv(text = recovered_global_URL)
recovered_global <- as.data.frame( cleanGlobalData(recovered_global_raw) )
recovered_global_t <- as.data.frame( t(recovered_global) )

# convert to global daily recovered cases
recovered_global_daily <- convertToDaily(recovered_global)
recovered_global_daily_t <- as.data.frame( t(recovered_global_daily) )



############################### US Data ###############################

# get and clean US cumulative confirmed cases data from API 
confirmed_US_URL <- getURL("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv")
confirmed_US_raw <- read.csv(text = confirmed_US_URL)
confirmed_US <- as.data.frame( cleanUSData(confirmed_US_raw) )
confirmed_US_t <- as.data.frame( t(confirmed_US) )

# convert to US daily confirmed cases
confirmed_US_daily <- convertToDaily(confirmed_US)
confirmed_US_daily_t <- as.data.frame( t(confirmed_US_daily) )

# define date for plotting
date_choices_US <- as.Date(colnames(confirmed_US), format = '%Y-%m-%d')

# define state for plotting
state_names_choices <- rownames(confirmed_US)

# get and clean US cumulative deaths cases data from API 
deaths_US_URL <- getURL("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_US.csv")
deaths_US_raw <- read.csv(text = deaths_US_URL)
deaths_US <- as.data.frame( cleanUSData(deaths_US_raw) )
deaths_US_t <- as.data.frame( t(deaths_US) )

# convert to US daily deaths cases
deaths_US_daily <- convertToDaily(deaths_US)
deaths_US_daily_t <- as.data.frame( t(deaths_US_daily) )



############################### NYC map data ###############################
# Data Sources
#   nyc Health data
#
# get NYC covid data based on Modified Zip code
# First get ZCTA (zip code) to MODZCTA data:
zcta_to_modzctaURL <- getURL("https://raw.githubusercontent.com/nychealth/coronavirus-data/master/Geography-resources/ZCTA-to-MODZCTA.csv")
zcta_to_modzcta <- read.csv( text=zcta_to_modzctaURL )

# NYC Covid data by MODZCTA:
data_by_modzctaURL <- getURL('https://raw.githubusercontent.com/nychealth/coronavirus-data/master/data-by-modzcta.csv')
data_by_modzcta <- read.csv( text=data_by_modzctaURL )

# get nyc neighborhoods
nyc_neighborhoods <- data_by_modzcta %>%
    select(
        "MODIFIED_ZCTA","NEIGHBORHOOD_NAME", 
        "BOROUGH_GROUP", "COVID_CASE_COUNT", 
        "COVID_CASE_RATE", "PERCENT_POSITIVE"
    )

# import geojson file from NYC open data
nyc_zipcode_geo <- sf::st_read("./output/ZIP_CODE_040114/ZIP_CODE_040114.shp") %>%
    sf::st_transform('+proj=longlat +datum=WGS84')
nyc_zipcode_geo$ZIPCODE <- type.convert(nyc_zipcode_geo$ZIPCODE)

# import longitude and latitude data
nyc_lat_data <- read.csv("./output/zc_geo.csv", sep= ";")

nyc_lat_table<-nyc_lat_data %>%
    select("Zip", "Latitude", "Longitude")

# match zipcode with longitude and latitude data and merge new data
nyc_neighborhoods <- nyc_neighborhoods %>%
    mutate(
        LAT_repre = nyc_lat_data$Latitude[
            match(nyc_neighborhoods$MODIFIED_ZCTA, nyc_lat_data$Zip) ]
    ) %>%
    mutate(
        LNG_repre = nyc_lat_data$Longitude[ 
            match(nyc_neighborhoods$MODIFIED_ZCTA, nyc_lat_data$Zip) ]
    )

# data for line chart and positive rate
nyc_recent_4w_URL <- getURL("https://raw.githubusercontent.com/nychealth/coronavirus-data/master/recent/recent-4-week-by-modzcta.csv")
nyc_recent_4w_cases <- read.csv(text = nyc_recent_4w_URL)

# recent_use_dat
nyc_recent_4w_data <- nyc_recent_4w_cases %>%
    select("MODIFIED_ZCTA","NEIGHBORHOOD_NAME","COVID_CASE_RATE_WEEK4",
           "COVID_CASE_RATE_WEEK3","COVID_CASE_RATE_WEEK2","COVID_CASE_RATE_WEEK1",
           "PERCENT_POSITIVE_4WEEK" )


############################### NYC restaurant data ###########################


# inline line graph from sparkline
# transform data from wide to long format (required by sparkline)

# gather case rate from week 4:week 1 into new column case_rate
nyc_sparkline_data <- nyc_recent_4w_data %>%
    select("MODIFIED_ZCTA", "COVID_CASE_RATE_WEEK4", "COVID_CASE_RATE_WEEK3", 
           "COVID_CASE_RATE_WEEK2", "COVID_CASE_RATE_WEEK1") %>%
    gather(week, case_rate, COVID_CASE_RATE_WEEK4:COVID_CASE_RATE_WEEK1) %>%
    data.table()

# create sparkline column linechart
nyc_sparkline_html <- 
    nyc_sparkline_data[, .(linechart = spk_chr(case_rate, type = 'line')), by = 'MODIFIED_ZCTA']

# modify 4 weeks data, this will be used to render table
nyc_recent_4w_data_res <- nyc_recent_4w_data %>%
    select("MODIFIED_ZCTA", "NEIGHBORHOOD_NAME", "PERCENT_POSITIVE_4WEEK") %>%
    merge(nyc_sparkline_html, by = 'MODIFIED_ZCTA') %>%
    rename(Zip="MODIFIED_ZCTA", Neighborhood="NEIGHBORHOOD_NAME", 
           "4-week Infection Rate"="PERCENT_POSITIVE_4WEEK", 
           "Weekly Trend (per 100,000)"=linechart)



# load map data for nyc restaurant from clean_restaurant_data.R
load(file="output/res_dat.RData")

nyc_res_map <- res_dat %>%
    filter(!is.na(latitude) | !is.na(longitude)) %>%  # get rid of NA value
    select(name, latitude, longitude, seating, 
           address, alcohol, postcode, Borough)      

############################### Export ###############################
# use save.image() at any time to save all environment data into an .RData file
save.image(file="./output/covid-19.RData")



############################### Deploy ###############################
#library(rsconnect)
#deployApp()
