library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)
library(ggplot2)
library(lubridate)

hms = ymd_hms(mdy_hm(trip$Start.Date)) 
hour = floor(hour(hms) + minute(hms)/60)
hourfreq = as.data.frame(table(hour))
colnames(station) = c("Station ID:","Name:","Latitude:","Longtitude:",
                      "DockCount:","LandMark:","Installation Date:")
r_colors <- rgb(t(col2rgb(colors()) / 255))
names(r_colors) <- colors()
tips = apply(station,1,function(x){
  paste(names(station),x,collapse = '<br/ >')})
hms = ymd_hms(mdy_hm(trip$Start.Date)) 
trip$hour = hour(hms) + minute(hms)/60
trip$date = as.Date(mdy_hm(trip$Start.Date))

function(input, output, session) {
  
  # Interactive Map #
  # Create the map
  points <- eventReactive(input$latlon, {
    cbind(station$Longtitude, station$Latitude)
  }, ignoreNULL = FALSE)
  
  observe({
    cityBy = input$city
    mapBy = input$basemap
    
    maplat = 37.6
    maplong = -122.2
    zoom = 10
    if (cityBy == "sanjose") 
    {
      maplat = lat[1]
      maplong = long[1]
      zoom = 14
    } 
    if (cityBy == "sanfrancisco") 
    {
      maplat = lat[2]
      maplong = long[2]
      zoom = 14
    } 
    if (cityBy == "paloalto") 
    {
      maplat = lat[3] - 0.02
      maplong = long[3] + 0.05
      zoom = 13
    } 
    if (cityBy == "mountainview") 
    {
      maplat = lat[4] + 0.02
      maplong = long[4] - 0.03
      zoom = 13
    } 
    
    if (mapBy == "default")
    {
      output$map <- renderLeaflet({
        leaflet() %>% setView(lng = maplong, lat = maplat, zoom = zoom) %>%
          addTiles() %>% 
          addMarkers(data = points(),popup = tips)  })
    }
    else{
      output$map <- renderLeaflet({
        leaflet() %>% setView(lng = maplong, lat = maplat, zoom = zoom) %>%
          addProviderTiles( mapBy,
                            options = providerTileOptions(noWrap = TRUE)) %>%
          addMarkers(data = points(),popup = tips)  })
    }
  })
  
  observe({
    fromBy = input$stationfrom
    currentid = stationinfo[stationinfo$stationinfo == fromBy,]$station_id
    #currentstation = station[station$station_id == currentstationid,]
    endBy = input$stationend
    destid = stationinfo[stationinfo$stationinfo == endBy,]$station_id
  
    tripfromcurrent = data.frame(table(trip[trip$Start.Terminal == currentid,]$End.Terminal))
    output$barPlot <- renderPlot({
      ggplot(data = tripfromcurrent, aes(x = tripfromcurrent$Var1, y = Freq)) + 
        geom_bar(stat = "identity",fill = "blue",color = "darkblue") +
        labs(title = paste("Trips Begining With the Station",currentid),x = "Station IDs",
              y = "The Number of Trips")
      })
    
    output$faceSubCust <- renderPlot({
      ggplot(data = trip[trip$Start.Terminal == currentid,], aes(x = wday(date))) +
        geom_bar(aes(fill = Subscriber.Type,shape = Subscriber.Type), stat = "count",position = "dodge") +
        ggtitle("Customer Vs. Subscriber") +
        ylab("Total Number of Bicycle Trips") +
        xlab("Trend Across Time") + 
        facet_grid(.~Subscriber.Type)
    })
    
    triptemp = trip[trip$Start.Terminal == currentid & trip$End.Terminal == destid,]
    output$tripdistribute <- renderPlot({
      ggplot(triptemp, aes(x = hour)) + 
      geom_histogram(bins = 100,fill = "purple") +
      labs(title = "Trips Distribution(One Day)",x = "Hours in a Day",
           y = "The Number of Trips")
    })
  })
  
}