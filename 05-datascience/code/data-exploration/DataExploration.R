##load packages
library(ggplot2)
library(dplyr)
library(lubridate)

## read the data
trip = read.csv("201608_trip_data.csv",header = T,sep = ",")
station = read.csv("201608_station_data.csv",header = T,sep = ",")

## Roughly, trips per date
trip$date = as.Date(mdy_hm(trip$Start.Date))
datefreq =  as.data.frame(table(trip$date))
ggplot(data = datefreq,aes(x = Var1,y = Freq))+
  geom_bar(stat = "identity",fill = "darkblue") + 
  labs(title = "Trips Distribution(Day)",x = "Date in Consideration",
       y = "The Number of Trips") +
  theme(plot.title = element_text(hjust = 0.5))

# Specifically, trips distribution per week
dayfreq = as.data.frame(table(wday(trip$date, label = TRUE)))
ggplot(data = dayfreq, aes(x = Var1, y = Freq)) +
  geom_bar(stat="identity",color = "black") +
  labs(title = "Trips Distribution(One Week)",x = "Days in a Week",
       y = "The Number of Trips") +
  theme(plot.title = element_text(hjust = 0.5))

# More Specifically, trips distribution per hour
# Lines
hms = ymd_hms(mdy_hm(trip$Start.Date)) 
trip$hour = hour(hms) + minute(hms)/60
ggplot(trip, aes(x = hour)) + 
geom_freqpoly(bins = 100,color = "black") + 
  labs(title = "Trips Distribution(One Day)",x = "Hours in a Day",
       y = "The Number of Trips") + 
  theme(plot.title = element_text(hjust = 0.5))

#Barplot
hour = floor(hour(hms) + minute(hms)/60)
hourfreq = as.data.frame(table(hour))
ggplot(data = hourfreq, aes(x = hour, y = Freq)) + 
  geom_bar(stat = "identity",fill = "lightblue",color = "blue") +
  labs(title = "Trips Distribution(One Day)",x = "Hours in a Day",
       y = "The Number of Trips")+ 
  theme(plot.title = element_text(hjust = 0.5))


##Route Distribution
#The Location of the Stations
library(googleVis)
station$latlon = paste(station$lat,station$long,sep = ":")
station$tip = apply(station,1,function(x){paste(names(station),x,collapse = '<br/ >')})
#plot(gvisMap(station,'latlon',tipvar = 'tip'))

# Popular Start Stations
startfreq = data.frame(table(trip$Start.Terminal))
Station_Order = order(startfreq$Freq,decreasing = T)
Pop_Station = startfreq[Station_Order[1:10],]
Pop_Station_ID = as.numeric(as.character(Pop_Station$Var1))
Pop_Station2 = data.frame(station_id = Pop_Station_ID,count = Pop_Station$Freq)
station2 = read.csv("201608_station_data.csv",header = T,sep = ",")
Pop = left_join(Pop_Station2,station2,by = c("station_id"))
Pop$rank = c(1:10)
#Already Found the Popular Station, Draw them on the GoogleMap
#plot(gvisMap(Pop,'latlon',tipvar = 'tip'))
ggplot(data = Pop, aes(x = rank, y = count,fill = rank)) + 
  geom_bar(stat = "identity") +
  labs(title = "Popularity of Starting Stations",x = "Top Ten Popular Starting Stations",
       y = "The Number of Trips") + 
  scale_x_discrete(labels = Pop$station_id)  +
  geom_text(aes(label = station_id),position = position_stack(0.9),color = "orange") +
  theme(plot.title = element_text(hjust = 0.5))

#Popular Destination
endfreq = data.frame(table(trip$End.Terminal))
Station_Order = order(endfreq$Freq,decreasing = T)
Pop_Station = endfreq[Station_Order[1:10],]
Pop_Station_ID = as.numeric(as.character(Pop_Station$Var1))
Pop_Station2 = data.frame(station_id = Pop_Station_ID,count = Pop_Station$Freq)
Pop = left_join(Pop_Station2,station,by = c("station_id"))
Pop$rank = c(1:10)
ggplot(data = Pop, aes(x = rank, y = count,fill = rank)) + 
  geom_bar(stat = "identity") +
  labs(title = "Popularity of Destinations",x = "Top Ten Popular Destinations",
       y = "The Number of Trips") + 
  scale_x_discrete(labels = Pop$station_id)  +
  geom_text(aes(label = station_id),position = position_stack(0.9),color = "orange") +
  theme(plot.title = element_text(hjust = 0.5))
#Already Found the Popular Station, Draw them on the GoogleMap
#plot(gvisMap(Pop,'latlon',tipvar = 'tip'))

# Routes
# Pre-Processing
stat = data.frame(station_ids = station$station_id)
start_end = data.frame(station_ids = trip$Start.Terminal, end = trip$End.Terminal)
startend = left_join(stat,start_end,by = c("station_ids"))
stat = data.frame(station_ide = station$station_id)
start_end = data.frame(station_ids = startend$station_id , station_ide = startend$end)
startend = left_join(stat,start_end,by = c("station_ide"))
mat_startend = data.frame(table(startend))

#Using MATLAB to plot 3d
num_station = length(station[,1])
mat = matrix(mat_startend[,3],num_station,num_station)
write.table(mat, file ="mat.csv", sep =",",
            row.names = F, col.names = F, quote = F)
# MATLAB will use mat.csv to plot 3d histplot.

##  top ten popular route
order_startend = order(mat_startend$Freq,decreasing = T)
pop_route = mat_startend[order_startend[1:10],]
pop_route$rank = c(1:10)
pop_route$info = paste(pop_route$station_ids,"-",pop_route$station_ide)
#row.names(pop_route) = NULL
ggplot(data = pop_route, aes(x = rank, y = Freq, fill = rank)) + 
  geom_bar(stat = "identity",width = 0.5) +
  labs(title = "Popular Routes(Top Ten)",x = "Top Ten Popular Routes",
       y = "The Number of Trips") + 
  scale_x_discrete(labels = pop_route$station_ide)  +
  geom_text(aes(label = info),position = position_stack(0.7),color = "orange") +
  theme(plot.title = element_text(hjust = 0.5))

#The Start Station of the Popular Routes
pop_route_s = as.numeric(as.character(pop_route[,1]))
pop_route_start = data.frame(station_id = pop_route_s)
pop_route_sinfo = left_join(pop_route_start,station,by = c("station_id"))
#The End Station of the Popular Routes
pop_route_e = as.numeric(as.character(pop_route[,2]))
pop_route_end = data.frame(station_id = pop_route_e)
pop_route_einfo = left_join(pop_route_end,station,by = c("station_id"))
pop_route_info = data.frame(start_station = pop_route_sinfo$name,
                            end_station = pop_route_einfo$name)

## Estimate the center of each city
lat = rep(0,4)
long = rep(0,4)
lat[1] = mean(station[station$landmark == "San Jose",]$lat)
lat[2] = mean(station[station$landmark == "San Francisco",]$lat)
lat[3] = mean(station[station$landmark == "Palo Alto",]$lat)
lat[4] = mean(station[station$landmark == "Mountain View",]$lat)
long[1] = mean(station[station$landmark == "San Jose",]$long)
long[2] = mean(station[station$landmark == "San Francisco",]$long)
long[3] = mean(station[station$landmark == "Palo Alto",]$long)
long[4] = mean(station[station$landmark == "Mountain View",]$long)

ggplot(data = trip[trip$Start.Terminal == 2,], aes(x = wday(date,label = T))) +
  geom_point(aes(fill = Subscriber.Type), stat = "count",position = "dodge") +
  ggtitle("Customer Vs. Subscriber on Weekends and Weekdays") +
  ylab("Total Number of Bicycle Trips") +
  xlab("Trend Across Time") + 
  facet_grid(.~Subscriber.Type)
  
freq = count(trip, date)
ggplot(data = freq, aes(x = date,y = n)) +
  geom_point(color = "darkblue") +
  labs(title= "Trips per Day",x = "The Number of Trips",y = "Date")+ 
  theme(plot.title = element_text(hjust = 0.5))


hms = ymd_hms(mdy_hm(trip$Start.Date)) 
trip$hour = hour(hms) + minute(hms)/60
trip$season = quarter(trip$date)
ggplot(trip, aes(x = hour,fill= season)) +
  geom_histogram(binwidth = 0.25) + 
  labs(title = "Trips in 24 hours in four seasons",x = "Time of day on 24 hour clock",
       y = "Total number of bicycle trips") + 
  facet_grid(~season) + 
  theme(plot.title = element_text(hjust = 0.5)) 

routeduration = 
routetime = routeduration[routeduration$start == 3 &
                            routeduration$end == 2,]
ggplot(data = routetime, aes(x = y = duration)) + 
  geom_point(fill = "blue",color = "darkblue") +
  labs(title = "Trips Distribution(One Day)",x = "Hours in a Day",
       y = "The Number of Trips")


trip <- mutate(trip, weekend = (wday(trip$date) == 1 |
                                 wday(trip$date) == 7))
trip$weekend <- factor(trip$weekend, labels = c("Weekday", "Weekend"))
#Plot usage by city
ggplot(data = trip, aes(date)) +
  geom_point(aes(shape = weekend,color = weekend), stat = "count",
           position = "stack") +
  ggtitle("Trips by Weekday and Weekend") +
  ylab("Total Number of Bicycle Trips") +
  xlab("Trend Across Time") + 
  facet_grid(~weekend) + 
  theme(plot.title = element_text(hjust = 0.5)) 