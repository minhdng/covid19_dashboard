# This R script is used to clean restaurant data from NYC Open Data source
#---------------------Clean restaurant data-----------------------------------#
# Objectives:
# 1. Select only necessary variable
# 2. Change variable names


# packages
if (!require("dplyr")) {install.packages("dplyr"); library(dplyr)}
if (!require("tibble")) {install.packages("tibble"); library(tibble)}
if (!require("tidyverse")) {install.packages("tidyverse"); library(tidyverse)}



# read Open_Restaurant_Applications.csv from data folder
res <- read.csv("./data/Open_Restaurant_Applications.csv", header=TRUE)

#Clean data: select only necessary variable + make new variable for seating options
res_dat <- res %>%
        mutate(seating=case_when(
        Seating.Interest..Sidewalk.Roadway.Both.=='both'~'sidewalk and roadway',
        Seating.Interest..Sidewalk.Roadway.Both.=='sidewalk'~'sidewalk',
        Seating.Interest..Sidewalk.Roadway.Both.=='roadway'~'roadway',
        Seating.Interest..Sidewalk.Roadway.Both.=='openstreets'~'openstreets'
        )) %>%
        #select variable
        select(Restaurant.Name, Latitude, Longitude, seating, 
               Business.Address, Qualify.Alcohol, Postcode, Time.of.Submission,
               Sidewalk.Dimensions..Length.,Sidewalk.Dimensions..Width.,Sidewalk.Dimensions..Area.,
               Roadway.Dimensions..Length.,Roadway.Dimensions..Width.,Roadway.Dimensions..Area.,
               Approved.for.Sidewalk.Seating,Approved.for.Roadway.Seating, Borough) %>%
        #rename
        rename(longitude=Longitude, latitude=Latitude, name=Restaurant.Name,
               address=Business.Address, alcohol=Qualify.Alcohol, postcode=Postcode,
               time_submit=Time.of.Submission,
               sw_len=Sidewalk.Dimensions..Length.,
               sw_width=Sidewalk.Dimensions..Width.,
               sw_area=Sidewalk.Dimensions..Area.,rw_len=Roadway.Dimensions..Length.,
               rw_width=Roadway.Dimensions..Width.,
               rw_area=Roadway.Dimensions..Area.,approved_sw=Approved.for.Sidewalk.Seating,
               approved_rw=Approved.for.Roadway.Seating)

# save the clean restaurant data in output
save(res_dat, file="app/output/res_dat.RData")




