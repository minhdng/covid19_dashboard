<<<<<<< HEAD

=======
# can run RData directly to get the necessary date for the app
# global.r will enable us to get new data everyday
# update data with automated script
# source("global.R") 
load('./output/covid-19.RData')


shinyServer(function(input, output) {

    ####################### Tab 1 ##################
    output$plotGlobalCummulativeConfirmed <- renderHighchart({
        highchart() %>%
            hc_exporting( enabled = TRUE, formAttributes = list(target = "_blank") ) %>%
            hc_chart( type='line' ) %>%
            hc_series( list( name = "confirmed", data = confirmed_global_t[, input$country], 
                             color='#48A9A6', marker = list(symbol = 'triangle')) )  %>%
            hc_plotOptions(column = list(
                dataLabels = list(enabled = F),
                #stacking = "normal",
                enableMouseTracking = T ) 
            ) %>%
            hc_tooltip(table = TRUE,
                   sort = TRUE,
                   pointFormat = paste0( '<br> <span style="color:{point.color}">\u25CF</span>',
                                         " {series.name}: {point.y}"),
                   headerFormat = '<span style="font-size: 13px">Date {point.key}</span>'
            ) %>%
            hc_legend( layout = 'vertical', align = 'left', verticalAlign = 'top', floating = T, x = 100, y = 000 )
        
    })
    
    output$plotGlobalCummulativeDeaths <- renderHighchart({
        highchart() %>%
            hc_exporting( enabled = TRUE, formAttributes = list(target = "_blank") ) %>%
            hc_chart( type='line' ) %>%
            hc_series( list( name = "deaths", data = deaths_global_t[, input$country], 
                             color='#930A1E', marker = list(symbol = 'triangle')) )  %>%
            hc_plotOptions(column = list(
                dataLabels = list(enabled = F),
                #stacking = "normal",
                enableMouseTracking = T ) 
            ) %>%
            hc_tooltip(table = TRUE,
                       sort = TRUE,
                       pointFormat = paste0( '<br> <span style="color:{point.color}">\u25CF</span>',
                                             " {series.name}: {point.y}"),
                       headerFormat = '<span style="font-size: 13px">Date {point.key}</span>'
            ) %>%
            hc_legend( layout = 'vertical', align = 'left', verticalAlign = 'top', floating = T, x = 100, y = 000 )
        
    })
    
    
    output$plotGlobalCummulativeRecovered <- renderHighchart({
        highchart() %>%
            hc_exporting( enabled = TRUE, formAttributes = list(target = "_blank") ) %>%
            hc_chart( type='line' ) %>%
            hc_series( list( name = "recovered", data = deaths_global_t[, input$country], 
                             color='#4281A4', marker = list(symbol = 'triangle')) )  %>%
            hc_plotOptions(column = list(
                dataLabels = list(enabled = F),
                #stacking = "normal",
                enableMouseTracking = T ) 
            ) %>%
            hc_tooltip(table = TRUE,
                       sort = TRUE,
                       pointFormat = paste0( '<br> <span style="color:{point.color}">\u25CF</span>',
                                             " {series.name}: {point.y}"),
                       headerFormat = '<span style="font-size: 13px">Date {point.key}</span>'
            ) %>%
            hc_legend( layout = 'vertical', align = 'left', verticalAlign = 'top', floating = T, x = 100, y = 000 )
        
    })
    
    output$plotGlobalDailyConfirmed <- renderHighchart({
        highchart() %>%
            hc_exporting( enabled = TRUE, formAttributes = list(target = "_blank") ) %>%
            hc_chart( type='column' ) %>%
            hc_series( list( name = "confirmed", data = confirmed_global_daily_t[,input$country], 
                             color='#48A9A6', marker = list(symbol = 'triangle')) )  %>%
            hc_xAxis( categories = unique(date_choices_global) ) %>%
            hc_plotOptions(column = list(
                dataLabels = list(enabled = F),
                #stacking = "normal",
                enableMouseTracking = T ) 
            ) %>%
            hc_tooltip(table = TRUE,
                       sort = TRUE,
                       pointFormat = paste0( '<br> <span style="color:{point.color}">\u25CF</span>',
                                             " {series.name}: {point.y}"),
                       headerFormat = '<span style="font-size: 13px">Date {point.key}</span>'
            ) %>%
            hc_legend( layout = 'vertical', align = 'left', verticalAlign = 'top', floating = T, x = 100, y = 000 )
        
    })
    
    output$plotGlobalDailyDeaths <- renderHighchart({
        highchart() %>%
            hc_exporting( enabled = TRUE, formAttributes = list(target = "_blank") ) %>%
            hc_chart( type='column' ) %>%
            hc_series( list( name = "deaths", data = deaths_global_daily_t[, input$country], 
                             color='#930A1E', marker = list(symbol = 'triangle')) )  %>%
            hc_xAxis( categories = unique(date_choices_global) ) %>%
            hc_plotOptions(column = list(
                dataLabels = list(enabled = F),
                stacking = "normal",
                enableMouseTracking = T ) 
            ) %>%
            hc_tooltip(table = TRUE,
                       sort = TRUE,
                       pointFormat = paste0( '<br> <span style="color:{point.color}">\u25CF</span>',
                                             " {series.name}: {point.y}"),
                       headerFormat = '<span style="font-size: 13px">Date {point.key}</span>'
            ) %>%
            hc_legend( layout = 'vertical', align = 'left', verticalAlign = 'top', floating = T, x = 100, y = 000 )
        
    })
    
    
    output$plotGlobalDailyRecovered <- renderHighchart({
        highchart() %>%
            hc_exporting( enabled = TRUE, formAttributes = list(target = "_blank") ) %>%
            hc_chart( type='column' ) %>%
            hc_series( list( name = "recovered", data = recovered_global_daily_t[, input$country], 
                             color='#4281A4', marker = list(symbol = 'triangle')) )  %>%
            hc_xAxis( categories = unique(date_choices_global) ) %>%
            hc_plotOptions(column = list(
                dataLabels = list(enabled = F),
                #stacking = "normal",
                enableMouseTracking = T ) 
            ) %>%
            hc_tooltip(table = TRUE,
                       sort = TRUE,
                       pointFormat = paste0( '<br> <span style="color:{point.color}">\u25CF</span>',
                                             " {series.name}: {point.y}"),
                       headerFormat = '<span style="font-size: 13px">Date {point.key}</span>'
            ) %>%
            hc_legend( layout = 'vertical', align = 'left', verticalAlign = 'top', floating = T, x = 100, y = 000 )
        
    })
    
    output$pieGlobal <- renderHighchart({
        getLastestData(confirmed_global, 9) %>% hchart(type = "pie", hcaes(x = name, y = cases))
    })
    
    output$pieGlobal2 <- renderHighchart({
        getLastestData(deaths_global, 9) %>% hchart(type = "pie", hcaes(x = name, y = cases))
    })
    
    
    
    ####################### Tab 2 ##################
    
    output$plotUSCummulativeConfirmed <- renderHighchart({
        highchart() %>%
            hc_exporting( enabled = TRUE, formAttributes = list(target = "_blank") ) %>%
            hc_chart( type='line' ) %>%
            hc_series( list( name = "confirmed", data = confirmed_US_t[, input$state], 
                             color='#48A9A6', marker = list(symbol = 'triangle')) )  %>%
            hc_plotOptions(column = list(
                dataLabels = list(enabled = F),
                #stacking = "normal",
                enableMouseTracking = T ) 
            ) %>%
            hc_tooltip(table = TRUE,
                       sort = TRUE,
                       pointFormat = paste0( '<br> <span style="color:{point.color}">\u25CF</span>',
                                             " {series.name}: {point.y}"),
                       headerFormat = '<span style="font-size: 13px">Date {point.key}</span>'
            ) %>%
            hc_legend( layout = 'vertical', align = 'left', verticalAlign = 'top', floating = T, x = 100, y = 000 )
        
    })
    
    output$plotUSCummulativeDeaths <- renderHighchart({
        highchart() %>%
            hc_exporting( enabled = TRUE, formAttributes = list(target = "_blank") ) %>%
            hc_chart( type='line' ) %>%
            hc_series( list( name = "deaths", data = deaths_US_t[, input$state], 
                             color='#930A1E', marker = list(symbol = 'triangle')) )  %>%
            hc_plotOptions(column = list(
                dataLabels = list(enabled = F),
                #stacking = "normal",
                enableMouseTracking = T ) 
            ) %>%
            hc_tooltip(table = TRUE,
                       sort = TRUE,
                       pointFormat = paste0( '<br> <span style="color:{point.color}">\u25CF</span>',
                                             " {series.name}: {point.y}"),
                       headerFormat = '<span style="font-size: 13px">Date {point.key}</span>'
            ) %>%
            hc_legend( layout = 'vertical', align = 'left', verticalAlign = 'top', floating = T, x = 100, y = 000 )
        
    })
    
    
    output$plotUSDailyConfirmed <- renderHighchart({
        highchart() %>%
            hc_exporting( enabled = TRUE, formAttributes = list(target = "_blank") ) %>%
            hc_chart( type='column' ) %>%
            hc_series( list( name = "confirmed", data = confirmed_US_daily_t[,input$state], 
                             color='#48A9A6', marker = list(symbol = 'triangle')) )  %>%
            hc_xAxis( categories = unique(date_choices_US) ) %>%
            hc_plotOptions(column = list(
                dataLabels = list(enabled = F),
                #stacking = "normal",
                enableMouseTracking = T ) 
            ) %>%
            hc_tooltip(table = TRUE,
                       sort = TRUE,
                       pointFormat = paste0( '<br> <span style="color:{point.color}">\u25CF</span>',
                                             " {series.name}: {point.y}"),
                       headerFormat = '<span style="font-size: 13px">Date {point.key}</span>'
            ) %>%
            hc_legend( layout = 'vertical', align = 'left', verticalAlign = 'top', floating = T, x = 100, y = 000 )
        
    })
    
    output$plotUSDailyDeaths <- renderHighchart({
        highchart() %>%
            hc_exporting( enabled = TRUE, formAttributes = list(target = "_blank") ) %>%
            hc_chart( type='column' ) %>%
            hc_series( list( name = "deaths", data = deaths_US_daily_t[, input$state], 
                             color='#930A1E', marker = list(symbol = 'triangle')) )  %>%
            hc_xAxis( categories = unique(date_choices_US) ) %>%
            hc_plotOptions(column = list(
                dataLabels = list(enabled = F),
                stacking = "normal",
                enableMouseTracking = T ) 
            ) %>%
            hc_tooltip(table = TRUE,
                       sort = TRUE,
                       pointFormat = paste0( '<br> <span style="color:{point.color}">\u25CF</span>',
                                             " {series.name}: {point.y}"),
                       headerFormat = '<span style="font-size: 13px">Date {point.key}</span>'
            ) %>%
            hc_legend( layout = 'vertical', align = 'left', verticalAlign = 'top', floating = T, x = 100, y = 000 )
        
    })
    
    output$pieUS <- renderHighchart({
        getLastestData(confirmed_US, 9) %>% hchart(type = "pie", hcaes(x = name, y = cases))
    })
    
    output$pieUS2 <- renderHighchart({
        getLastestData(deaths_US, 9) %>% hchart(type = "pie", hcaes(x = name, y = cases))
    })
    

    
    ####################### Tab 3 ##################
    map_base <-
        leaflet(options = leafletOptions(dragging = T, minZoom = 10, maxZoom = 16)) %>%
        setView(lng = -73.92,lat = 40.72, zoom = 11) %>% 
        addTiles() %>%
        addProviderTiles("CartoDB.Positron")
    
    observe({
        output$nyc_map_covid = renderLeaflet({
            
            # join zipcode geo with covid data from nyc_recent_4w_data
            nyc_zipcode_geo = nyc_zipcode_geo %>%
                left_join(nyc_neighborhoods, by = c("ZIPCODE"="MODIFIED_ZCTA")) %>%
                left_join(nyc_recent_4w_data, by = c("ZIPCODE"="MODIFIED_ZCTA"))
            
            nyc_map_output = map_base %>% 
                addPolygons( 
                    data = nyc_zipcode_geo,
                    weight = 0.5, color = "#41516C", fillOpacity = 0,
                    popup = ~(paste0( 
                        "<b>Zip Code: ",ZIPCODE ,
                        "</b><br/>Borough: ",BOROUGH_GROUP,
                        "<br/>Infection Rate: ", PERCENT_POSITIVE_4WEEK,
                        "<br/>Confirmed Cases: ", COVID_CASE_COUNT
                    )),
                    highlight = highlightOptions(
                        weight = 2, color = "red", bringToFront = F) ) %>%
                addCircleMarkers(
                    data = nyc_zipcode_geo,
                    lng = ~LNG_repre, lat = ~LAT_repre,
                    color = "#2C6BAC", fillOpacity = 0.7,
                    radius = ~(COVID_CASE_COUNT)/200, 
                    popup = ~(paste0(
                        "<b>Zip Code: ",ZIPCODE ,
                        "<br/>Infection Rate: ", PERCENT_POSITIVE_4WEEK,
                        "</b><br/>Confirmed Cases: ",COVID_CASE_COUNT
                    )),
                    group = "Covid Cases"
                )            
        }) # end of observe
        
        leafletProxy("nyc_map_output")
        
    })
    # end of tab 3
    
    
    ####################### Tab 4 ##################
    # filtered data for zooming in specific borough in the map
    filtered_data_map <- reactive({
        if( is.null(input$boro) ){
            selected_boro = levels(nyc_res_map$Borough)
        } else {
            selected_boro = input$boro
        }
        nyc_res_map %>% filter(Borough %in% selected_boro)
    })
    
    # restaurant map
    output$nyc_map_restaurant <- renderLeaflet({
        leaflet(nyc_res_map, options = leafletOptions(minZoom = 10, maxZoom = 18)) %>%
            addProviderTiles(providers$CartoDB.Positron) %>%
            setView(lng = -73.95, lat = 40.72, zoom = 10) %>%
            addMarkers(lng = nyc_res_map$longitude, lat = nyc_res_map$latitude,
                       clusterOptions = markerClusterOptions(),
                       label = lapply( lapply(seq(nrow(nyc_res_map)), function(i){
                           paste0(
                               '<b>',nyc_res_map[i, "name"], '</b>', '<br/>', 
                               'Address: ',nyc_res_map[i, "address"], '<br/>',
                               'Zipcode: ',nyc_res_map[i, "postcode"], '<br/>',
                               'Seating: ',nyc_res_map[i, "seating"], '<br/>',
                               'Alcohol: ',nyc_res_map[i, "alcohol"]
                           ) 
                       }), 
                       htmltools::HTML)
            ) 
    })
    
    observe({
        temp_df = filtered_data_map()
        leafletProxy('nyc_map_restaurant',data = temp_df) %>%
            clearMarkerClusters()%>%
            clearMarkers() %>%
            addMarkers(lng = temp_df$longitude, lat = temp_df$latitude,
                       clusterOptions = markerClusterOptions(),
                       label = lapply( lapply(
                           seq(nrow(temp_df)), 
                           function(i){ paste0(
                               '<b>',temp_df[i, "name"], '</b>', '<br/>', 
                               'Address: ',temp_df[i, "address"], '<br/>',
                               'Zipcode: ',temp_df[i, "postcode"], '<br/>',
                               'Seating: ',temp_df[i, "seating"],'<br/>',
                               'Alcohol: ',temp_df[i, "alcohol"]
                               ) 
                               }
                           ), 
                           htmltools::HTML
                           )
                       ) 
    })
    
    # table with inline graph
    staticRender_cb <- JS('function(){HTMLWidgets.staticRender();}') 
    output$nyc_table_res <- 
        renderDataTable(nyc_recent_4w_data_res,
                        escape = FALSE,  # important to render html widgets
                        rownames = FALSE,
                        options = list(drawCallback = staticRender_cb)
        ) 
    # end of tab 4

    
})




    
>>>>>>> 70400a28fcf34799ae12bf1d098ae7b306d50d1b
