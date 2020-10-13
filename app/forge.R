
############################# Install Related Packages #######################
if (!require("dplyr")) {install.packages("dplyr")
    library(dplyr)
}
if (!require("tibble")) {install.packages("tibble")
    library(tibble)
}
if (!require("tidyverse")) {install.packages("tidyverse")
    library(tidyverse)
}
if (!require("shinythemes")) {install.packages("shinythemes")
    library(shinythemes)
}
if (!require("sf")) {install.packages("sf")
    library(sf)
}
if (!require("RCurl")) {install.packages("RCurl")
    library(RCurl)
}
if (!require("tmap")) {install.packages("tmap")
    library(tmap)
}
if (!require("rgdal")) {install.packages("rgdal")
    library(rgdal)
}
if (!require("leaflet")) {install.packages("leaflet")
    library(leaflet)
}
if (!require("shiny")) {install.packages("shiny")
    library(shiny)
}
if (!require("plotly")) {install.packages("plotly")
    library(plotly)
}
if (!require("ggplot2")) {install.packages("ggplot2")
    library(ggplot2)
}
if (!require("viridis")) {install.packages("viridis")
    library(viridis)
}


############################### Data Preparation#######################
#Data Sources
"Dong E, Du H, Gardner L. An interactive web-based dashboard to track COVID-19 in real time. 
Lancet Inf Dis. 20(5):533-534. doi: 10.1016/S1473-3099(20)30120-1"

#From JH github
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
