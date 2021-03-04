# Load data compiled by global.R
load('./output/covid-19.RData')





body <- dashboardBody( 
    shinyDashboardThemes(theme = "poor_mans_flatly"),
    

    tabItems(
        # tab panel 1- Intro ----------------------------------------------------
        tabItem(tabName = "Home", fluidPage(
            fluidRow(box(width = 15, title = "Introduction", status = "primary",
                         solidHeader = TRUE, h3("Covid-19 Dashboard: Where to eat safely in NYC? "),
                         h4("By Wendy Doan, Minh Nguyen"),
                         h5("Drawing data from multiple sources, this application provides insight into impacts of coronavirus 2019 (COVID-19) around the world, across US states, and in New York city in particular"),
                         h5("Through this website, users will accumulate all the key statistics about the spread of Covid 19, as well as information/advises to make a decision on where to eat-out in NYC area")))),
            fluidRow(box(width = 15, title = "How to Use The App", status = "primary",
                         solidHeader = TRUE,
                         h5("The application is divided into 6 separate tabs"),
                         tags$div(tags$ul(
                             tags$li("The", strong("first"), "tab: Introduction"),
                             tags$li("The", strong("second"), "tab: Covid 19 stats across the globe"),
                             tags$li("The", strong("third"), "tab: Covid 19 stats across US states"),
                             tags$li("The", strong("fourth"), "tab: The detailed ZIP code map shows the extent of Covid 19 outbreak in NYC. It provided key information including: confirmed cases, infection rate"),
                             tags$li("The", strong("fifth"),"tab: Here, users can select where they want to eat-out. The page will automatically refresh and show only restaurants in the area, with the exact Covid 19 infection rate, and the recent infection trends nearby"),
                             tags$li("The", strong("sixth"), "tab: Appendix and data sources")
                             
                             
                         ))
            ))
        ), # end of home 
        
        # tab panel 2 - Global ---------------------------------------------------
        tabItem(tabName = "global",
                
                fluidPage( 
                    
                    fluidRow(
                        
                        valueBox( prettyNum(getLastestCount(confirmed_global), big.mark = ","),
                                  subtitle="Cases globally", color='aqua', width = 3, icon = icon("hospital-user")),
                        
                        valueBox( prettyNum(getLastestCount(confirmed_global_daily), big.mark = ","), 
                                  subtitle="Cases today", color="purple", width = 2, icon = icon("hospital-user")),                            

                        valueBox( prettyNum(getLastestCount(deaths_global), big.mark = ","), 
                                  subtitle="Deaths globally", color="olive", width = 3, icon = icon("skull")),
                        
                        valueBox( prettyNum(getLastestCount(deaths_global_daily), big.mark = ","), 
                                  subtitle="Deaths today", color="maroon", width = 2, icon = icon("skull")),
                        
                        box( title=NULL, width = 2,  height = 102, background = "yellow", 
                            selectInput("country", label="Viewing data for",
                                        choices = country_names_choices, 
                                        selected = "United States of America"),
                            
                        )
                        
                    ),
                    
                    box(title=NULL, width=12,                  
                        fluidRow(
                            column(4, highchartOutput('plotGlobalCummulativeConfirmed')),
                            column(4, highchartOutput('plotGlobalCummulativeDeaths')),
                            column(4, highchartOutput('plotGlobalCummulativeRecovered'))
                        ),
                        
                        fluidRow(
                            column(4, highchartOutput('plotGlobalDailyConfirmed')),
                            column(4, highchartOutput('plotGlobalDailyDeaths')),
                            column(4, highchartOutput('plotGlobalDailyRecovered'))
                        ),
                    ),
                    
                    box(title=NULL,width=12,
                        fluidRow(
                            column(6, h4("Countries with most cases"),
                                   highchartOutput('pieGlobal'), align='center'
                            ),
                            column(6, h4("Countries with most deaths"),
                                   highchartOutput('pieGlobal2'), align='center'
                            )
                        )
                    )                    
                )
                
        ),
        # end of tab panel 1 
        
        # tab panel 2 - US ---------------------------------------------------
        tabItem(tabName = "US",
                
                fluidPage( 
                    fluidRow(
                        valueBox( prettyNum(getLastestCount(confirmed_US), big.mark = ","), 
                                  subtitle="Cases US", color='aqua', width = 3, icon = icon("hospital-user")),
                        valueBox( prettyNum(getLastestCount(confirmed_US_daily), big.mark = ","), 
                                  subtitle="Cases today", color="purple", width = 2, icon = icon("hospital-user")),                            
                        
                        valueBox( prettyNum(getLastestCount(deaths_US), big.mark = ","), 
                                  subtitle="Deaths US", color="olive", width = 3, icon = icon("skull")),
                        valueBox( prettyNum(getLastestCount(deaths_US_daily), big.mark = ","), 
                                  subtitle="Deaths today", color="maroon", width = 2, icon = icon("skull")),
                        box( title=NULL, width = 2,  height = 102, background = "yellow", 
                             selectInput("state", label="Viewing data for",
                                         choices = state_names_choices, 
                                         selected = "New York"),
                             
                        )
                    ), 
                    
                    box(title=NULL,width=12,                    
                        fluidRow(
                            column(6, highchartOutput('plotUSCummulativeConfirmed')),
                            column(6, highchartOutput('plotUSCummulativeDeaths'))
                        ),
                        
                        fluidRow(
                            column(6, highchartOutput('plotUSDailyConfirmed')),
                            column(6, highchartOutput('plotUSDailyDeaths'))
                        ),
                    ),
                    
                    box(title=NULL,width=12,
                        fluidRow(
                            column(6, h5("States with most cases"),
                                   highchartOutput('pieUS'), align='center'
                            ),
                            column(6, h5("States with most deaths"),
                                   highchartOutput('pieUS2'), align='center'
                            )
                        )
                    )    
                ) # end of page

        ),
        # end of tab panel 2
        
        # tab panel 3 - NYC map ---------------------------------------------------
        tabItem(tabName = "nyc_map",
                h2("NYC Covid-19", align = 'center'),
                leafletOutput("nyc_map_covid", width = "100%", height = 800)
        ),
        # end of tab panel 3
        
        
        # tab panel 4 - NYC restaurant map ---------------------------------------------------
        tabItem(tabName = "nyc_eat",
                fluidPage(
                    fluidRow(
                        column(12, titlePanel('NYC Restaurant Locations'), selectizeInput(
                            'boro',
                            '',
                            choices = c(
                                'Choose Borough' = '',
                                'Bronx',
                                'Brooklyn',
                                'Manhattan',
                                'Queens',
                                'Staten Island'), multiple = T),
                            align='center'
                        )
                    ),
                    
                    fluidRow(
                        column(6, titlePanel(''),
                               leafletOutput('nyc_map_restaurant', height = "600px")
                               ),
                        
                        column(6, titlePanel(''),
                                    getDependency('sparkline'),
                                    dataTableOutput('nyc_table_res')
                               )
                    )
                )
        ), # end of tab panel 4,
    # ------------------ Appendix --------------------------------
    tabItem(tabName = "Appendix", fluidPage( 
        HTML(
            "<h2> Data Sources </h2>
                <h4> <p><li>NYC Covid 19 Data: <a href='https://github.com/nychealth/coronavirus-data'>NYC covid 19 github database</a></li></h4>
                <h4><li>Global and States-wide Covid 19 Datat : <a href='https://github.com/CSSEGISandData/COVID-19'>John Hopkins data</a></li></h4>
                <h4><li>NYC Geo Data : <a href='https://github.com/ResidentMario/geoplot-data-old' target='_blank'> Geoplot Github</a></li></h4>"
        ),

        titlePanel("Acknowledgement  "),
        
        HTML(
            " <p>This application is built using R shiny app.</p>",
            "<p>The following R packages were used in to build this RShiny application:</p>
                <li>Shinytheme</li>
                <li>Tidyverse</li>
                <li>Dyplr</li><li>Tibble</li><li>Rcurl</li><li>Plotly</li>
                <li>ggplot2</li>"
        ),
        
        titlePanel("Contacts"),
        
        HTML(
            " <p>For more information please feel free to contact</p>",
            " <p>Wendy Doan(ad3801@columbia.edu) </p>",
            " <p>Minh Nguyen(nguy1642@umn.edu)</p>"
           )
    )) # end of tab
        
    )) # end of TabItems



# ui
ui <- dashboardPage( 
    
    dashboardHeader(
        title = 'COVID-19 Dashboard'
    ), 
    
    dashboardSidebar(
        sidebarMenu(
            menuItem("Home", tabName = "Home", icon = icon("home")),
            menuItem("By Countries", tabName = "global", icon = icon("globe")),
            menuItem("By States", tabName = "US", icon = icon("flag-usa")),
            menuItem("NYC Map", tabName = "nyc_map", icon = icon("city")),
            menuItem("NYC Restaurants", tabName = "nyc_eat", icon = icon("utensils")),
            menuItem("Appendix", tabName = "Appendix", icon = icon("fas fa-asterisk"))
            
        )),
    
    body 
    
)    





   

    



