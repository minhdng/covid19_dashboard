# Load data compiled by global.R
load('./output/covid-19.RData')





body <- dashboardBody( 
    shinyDashboardThemes(theme = "poor_mans_flatly"),
    

    tabItems(
        
        # tab panel 1 - Global ---------------------------------------------------
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
        ) # end of tab panel 4
        
    ) # end of TabItems

)    





# ui
ui <- dashboardPage( 
    
    dashboardHeader(
        title = 'COVID-19 Dashboard'
    ), 
    
    dashboardSidebar(
        sidebarMenu(
            menuItem("By Countries", tabName = "global", icon = icon("globe")),
            menuItem("By States", tabName = "US", icon = icon("flag-usa")),
            menuItem("NYC Map", tabName = "nyc_map", icon = icon("city")),
            menuItem("NYC Restaurants", tabName = "nyc_eat", icon = icon("utensils"))
        )
    ),
    
    body 
    
)    





   

    



