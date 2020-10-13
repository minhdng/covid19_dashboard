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
#--------------------------------------------------------------------
###############################Define Global Functions#######################
data_cooker <- function(df){
    #input dataframe and change the Country/Region column into standard format
    #rename country region
    
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
    df$Country.Region[df$Country.Region =="South Sudan"]<-"S. Sudan"
    return(df)
}


data_transformer <- function(df) {
    #################################################################
    ##Given dataframe tranform the dataframe into aggregate level with
    ##rownames equal to countries name, and colnames equals date
    #################################################################
    #clean the country/regionnames
    
    
    df <- data_cooker(df)
    #columns that don't need 
    not_select_cols <- c("Province.State","Lat","Long")
    #aggregate the province into country level
    #group by country.region, remove 3 selected column
    aggre_df <- df %>% group_by(Country.Region) %>% 
        select(-one_of(not_select_cols)) %>% summarise_all(sum)
    
    #assign the country name into row names 
    aggre_df <- aggre_df %>% remove_rownames %>% 
        tibble::column_to_rownames(var="Country.Region")
    
    #change the colume name into date format
    date_name <- colnames(aggre_df)
    #change e.g: "x1.22.20" -> "2020-01-22"
    date_choices <- as.Date(date_name,format = 'X%m.%d.%y')
    
    #assign column name
    colnames(aggre_df) <- date_choices
    return(aggre_df)
}
#--------------------------------------------------------------------
###############################Data Preparation#######################
#Data Sources
"Dong E, Du H, Gardner L. An interactive web-based dashboard to track COVID-19 in real time. 
Lancet Inf Dis. 20(5):533-534. doi: 10.1016/S1473-3099(20)30120-1"
#get the daily global cases data from API
Cases_URL <- getURL("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv")
global_cases <- read.csv(text = Cases_URL)

#get the daily US cases
CasesUS_URL<-getURL("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv")
US_cases<-read.csv(text=CasesUS_URL)

#get the daily global deaths data from API
Death_URL <- getURL("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv")
global_death <- read.csv(text = Death_URL)

#get the daily US deaths data
DeathUS_URL<-getURL("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_US.csv")
US_death<-read.csv(text=DeathUS_URL)


##################Transforming global data using criteria set above
###################################3

# get global aggregate cases 
globalaggre_cases <- as.data.frame(data_transformer(global_cases))
# get aggregate death
globalaggre_death <- as.data.frame(data_transformer(global_death))

#######make 2 new varuables: dates_choices, country_name_choices
# define date_choices 
date_choices <- as.Date(colnames(globalaggre_cases),format = '%Y-%m-%d')
# define country_names
country_names_choices <- rownames(globalaggre_cases)



#--------------------------------------------------------------------
###############################Define USA Functions#######################

USdata_transformer <- function(df2) {
    #################################################################
    #Tranform the US dataframe into aggregate level with
    ##rownames equal to State name, and colnames equals date
    #################################################################
    
        #columns that don't need 
    not_select_colsUS <- c("UID","iso2", "iso3", "code3", "FIPS", "Admin2", "Country_Region","Lat","Long_", "Combined_Key", "Population")
    #aggregate Province_State into single Province
    #group by Province, remove selected columns
    aggre_df2 <- df2 %>% group_by(Province_State) %>% 
        select(-one_of(not_select_colsUS)) %>% summarise_all(sum)
    
    #assign the country name into row names 
    aggre_df2 <- aggre_df2 %>% remove_rownames %>% 
        tibble::column_to_rownames(var="Province_State")
    
    #change the colume name into date format
    date_name2 <- colnames(aggre_df2)
    #change e.g: "x1.22.20" -> "2020-01-22"
    date_choices2 <- as.Date(date_name2, format = 'X%m.%d.%y')
    
    #assign column name
    colnames(aggre_df2) <- date_choices2
    return(aggre_df2)
}


##################Transforming global data using criteria set above
###################################3

# get US aggregate cases 
USaggre_cases <- as.data.frame(USdata_transformer(US_cases))
# get aggregate death
USaggre_death <- as.data.frame(USdata_transformer(US_death))

#######make 2 new variables: dates_choices, state_name_choices
# define date_choices 
USdate_choices <- as.Date(colnames(USaggre_cases),format = '%Y-%m-%d')
# define state_names
state_names_choices <- rownames(USaggre_cases)



# Download the spatial polygons dataframe in this link
# https://www.naturalearthdata.com/downloads/50m-cultural-vectors/50m-admin-0-countries-2/

output_shapefile_filepath <- "./output/countries_shapeFile.RData"

# if already has countries_shapeFile.RData under output folder, no need to process it again
# otherwise, read files from data folder to create countries_shapeFile.RData under output folder
if(file.exists(output_shapefile_filepath)){
    load(output_shapefile_filepath)
}else{
    countries <- readOGR(dsn ="../data/ne_50m_admin_0_countries",
                         layer = "ne_50m_admin_0_countries",
                         encoding = "utf-8",use_iconv = T,
                         verbose = FALSE)
    save(countries, file=output_shapefile_filepath)
}


# make a copy of aggre_cases dataframe
aggre_cases_copy <- as.data.frame(aggre_cases)
aggre_cases_copy$country_names <- as.character(rownames(aggre_cases_copy))

# make a copy of aggre_death dataframe
aggre_death_copy <- as.data.frame(aggre_death)
aggre_death_copy$country_names <- as.character(rownames(aggre_death_copy))

binning<- function(x) {10^(ceiling(log10(x)))}

# use save.image() at any time to save all environment data into an .RData file
save.image(file='./output/covid-19.RData')