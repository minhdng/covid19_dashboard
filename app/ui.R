# Packages
library(shiny)
library(shinythemes)
library(viridis)
library(dplyr)
library(tibble)
library(tidyverse)
library(sf)
library(RCurl)
library(tmap)
library(rgdal)
library(leaflet)
library(plotly)
library(ggplot2)



# Load data compiled by global.R
load('./output/covid-19.RData')


# ui
shinyUI( navbarPage(
    title = 'COVID-19 Dashboard',
    fluid = TRUE,
    collapsible = TRUE,
    theme = shinytheme("flatly"),
    
    # tab panel 1 - Global ---------------------------------------------------
    tabPanel("Global",icon = icon("globe"),
        fluidPage( fluidRow(
            column(12, h1("Global Cases overview across time"),
                
                fluidRow(
                    
                    # date and country selections
                    column(6,
                        
                        # select date with slider
                        sliderInput('date','Date Slider:',
                            min = as.Date(date_choices[1]),
                            max = as.Date(tail(date_choices,1)),
                            value = as.Date(tail(date_choices,1)),
                            timeFormat = "%Y-%m-%d",
                            animate = TRUE, step = 5
                        ),
                        
                        fluidRow(
                            # select country 
                            column(6, 
                                selectInput('country','Which Country?',
                                choices = country_names_choices,
                                selected = 'United States of America')
                            ),
                                                      
                            # select log scale or not
                            column(6,
                                radioButtons("log_scale", "In Log Scale:",
                                choices = c(TRUE,FALSE),
                                selected = FALSE)
                            )
                        )
                    ),
                    
                    
                    # render plotly output
                    column(width = 6,
                        plotlyOutput('case_overtime')
                    )
                )
            )
        ))
    ),
    # end of tab panel 1 

    # tab panel 2 - State ---------------------------------------------------
    tabPanel("State",icon = icon("cog"),
             fluidPage( fluidRow(
                 column(12, h1("US Cases overview across time"),
                        
                        fluidRow(
                            
                            # date and country selections
                            column(6,
                                   
                                   # select date with slider
                                   sliderInput('date_2','Date Slider:',
                                               min = as.Date(date_choices[1], '%Y-%m-%d'),
                                               max = as.Date(tail(date_choices,1), '%Y-%m-%d'),
                                               value = as.Date(date_choices[2], '%Y-%m-%d'),
                                               timeFormat = "%Y-%m-%d",
                                               animate = TRUE, step = 5
                                   ),
                                   
                                   fluidRow(
                                       # select country 
                                       column(6, 
                                              selectInput('state','Which State?',
                                                          choices = country_names_choices,
                                                          selected = 'United States of America')
                                       ),
                                       
                                       # select log scale or not
                                       column(6,
                                              radioButtons("log_scale_2", "In Log Scale:",
                                                           choices = c(TRUE,FALSE),
                                                           selected = FALSE)
                                       )
                                   )
                            ),
                            
                            
                            # render plotly output
                            column(width = 6,
                                   plotlyOutput('case_overtime_state')
                            )
                        )
                 )
             ))
    ),
    # end of tab panel 2 
        
    

    # tab panel 3 - Global Map ---------------------------------------------------
    tabPanel("Maps",icon = icon("map-marker-alt"), 
        div(class = 'outer',
            leafletOutput("map", width = "100%", height = "1200"),
            absolutePanel(
                id = "control", 
                class = "panel panel-default", 
                fixed = TRUE, 
                draggable = TRUE,
                top = 300, 
                left = 20, 
                right = "auto", 
                bottom = "auto", 
                width = 250, 
                height = "auto",
                
                selectInput('choices','Which data to visualize:',
                    choices = c('Cases','Death'),
                    selected = c('Cases')
                ),
                
                sliderInput('date_map','Input Date:',
                    min = as.Date(date_choices[1]),
                    max = as.Date(tail(date_choices,1)),
                    # as.Date('2020-04-01','%Y-%m-%d')
                    value = as.Date(tail(date_choices,1), '%Y-%m-%d'),
                    timeFormat = "%Y-%m-%d",
                    animate = animationOptions(interval = 3000, loop = FALSE), 
                    step = 5
                ),
                style = "opacity: 0.80"
            )
    )),
    # end of tab panel 2 


    #tab panel 4 - Sources ---------------------------------------------------
    tabPanel("Data Source",icon = icon("cloud-download"),
        HTML(
            "
            <h2> Data Source : </h2>
            
            <h4> <p> <li>
                <a href='https://coronavirus.jhu.edu/map.html'>
                Coronavirus COVID-19 Global Cases map Johns Hopkins University
                </a>
            </li> </h4>
            
            <h4> <li> COVID-19 Cases : 
                <a href='https://github.com/CSSEGISandData/COVID-19'>
                Github Johns Hopkins University 
                </a>
            </li> </h4>
            
            <h4><li> Spatial Polygons : 
                <a href='https://www.naturalearthdata.com/downloads/'> 
                Natural Earth
                </a>
            </li></h4>
            "
        )
    )
    # end of tab panel 3 
))