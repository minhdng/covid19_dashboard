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
if (!require("shinythemes")) {install.packages("shinythemes"); library(shinythemes)}
if (!require("sf")) {install.packages("sf"); library(sf)}

# map
if (!require("RCurl")) {install.packages("RCurl"); library(RCurl)}
if (!require("tmap")) {install.packages("tmap"); library(tmap)}
if (!require("rgdal")) {install.packages("rgdal"); library(rgdal)}

# plotting
if (!require("leaflet")) {install.packages("leaflet"); library(leaflet)}
if (!require("plotly")) {install.packages("plotly"); library(plotly)}
if (!require("ggplot2")) {install.packages("ggplot2"); library(ggplot2)}
if (!require("viridis")) {install.packages("viridis"); library(viridis)}



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
    # 	rownames = State names
    # 	colnames = dates
    
    
    # columns that don't need 
    # see exploratory analysis for more details
    unused_cols <- c("UID","iso2", "iso3", "code3", "FIPS", "Admin2", 
                     "Country_Region","Lat","Long_", "Combined_Key", 
                     "Population")
    
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
    
    return(df_output)
}


convertToDaily <- function(df) {
    # From cumulative data (either global or US), convert to daily new case data   
    # Input: dataframe of cumulative cases
    #               columns: dates
    #               rows: countries/states
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


takeLog <- function(df) {
    # Take log
    # Replace -Inf values with 0
    df_log <- log(df)
    df_log[df_log == -Inf] <- 0
    
    return(df_log)
}


binning <- function(x) {
    10^(ceiling(log10(x))) 
}


############################### Global Data ###############################
# Data Sources
# 
# "Dong E, Du H, Gardner L. 
# An interactive web-based dashboard to track COVID-19 in real time. 
# Lancet Inf Dis. 20(5):533-534. doi: 10.1016/S1473-3099(20)30120-1"

# get and clean global cumulative confirmed cases data from API 
confirmed_global_URL <- getURL("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv")
confirmed_global_raw <- read.csv(text = confirmed_global_URL)
confirmed_global <- as.data.frame( cleanGlobalData(confirmed_global_raw) )
confirmed_global_log <- takeLog(confirmed_global)

# convert to global daily confirmed cases
confirmed_global_daily <- convertToDaily(confirmed_global)
confirmed_global_daily_log <- takeLog(confirmed_global_daily)

# define date for plotting
date_choices <- as.Date(colnames(confirmed_global), format = '%Y-%m-%d')

# define country for plotting
country_names_choices <- rownames(confirmed_global)


# get and clean global cumulative death cases data from API 
deaths_global_URL <- getURL("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv")
deaths_global_raw <- read.csv(text = deaths_global_URL)
deaths_global <- as.data.frame( cleanGlobalData(deaths_global_raw) )
deaths_global_log <- takeLog(deaths_global)
# convert to global daily deaths cases
deaths_global_daily <- convertToDaily(deaths_global)
deaths_global_daily_log <- takeLog(deaths_global_daily)


############################### US Data ###############################

# get and clean US cumulative confirmed cases data from API 
confirmed_US_URL <- getURL("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv")
confirmed_US_raw <- read.csv(text = confirmed_US_URL)
confirmed_US <- as.data.frame( cleanUSData(confirmed_US_raw) )
confirmed_US_log <- takeLog(confirmed_US)

# convert to US daily confirmed cases
confirmed_US_daily <- convertToDaily(confirmed_US)
confirmed_US_daily_log <- takeLog(confirmed_US_daily)

# define date for plotting
# same as global
# date_choices <- as.Date(colnames(confirmed_US), format = '%Y-%m-%d')

# define state for plotting
state_names_choices <- rownames(confirmed_US)


# get and clean US cumulative death cases data from API 
deaths_US_URL <- getURL("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_US.csv")
deaths_US_raw <- read.csv(text = deaths_US_URL)
deaths_US <- as.data.frame( cleanUSData(deaths_US_raw) )
deaths_US_log <- takeLog(deaths_US)
# convert to US daily deaths cases
deaths_US_daily <- convertToDaily(deaths_US)
deaths_US_daily_log <- takeLog(deaths_US_daily)

