
# https://www.kaggle.com/datasets/gowthamvarma/singapore-bus-data-land-transport-authority/data
# chrome-extension://efaidnbmnnnibpcajpcglclefindmkaj/https://datamall.lta.gov.sg/content/dam/datamall/datasets/LTA_DataMall_API_User_Guide.pdf?ref=stuartbreckenridge.net


dataroot <- "C:/Users/MSI KATANA/Desktop/Tulane/Business Analytics Practic/Singapore Bus Routes/fulldata.rds"
singapore_bus_data <- readRDS(dataroot)


str(singapore_bus_data)
singapore_bus_data %>% count(Operator.x)


Stop_overlapping <- singapore_bus_data %>% 
  group_by(BusStopCode,Latitude, Longitude) %>% 
  summarise(n_operators = n_distinct(Operator.x), .groups = "drop")

singapore_bus_data %>% 
  group_by(BusStopCode,Latitude, Longitude) %>% 
  summarise(n_operators = n_distinct(Operator.x)) %>% #ungroup()
  select(BusStopCode, n_operators) %>% View

singapore_bus_data %>% 
  group_by(BusStopCode,Latitude, Longitude) %>% 
  summarise(n_operators = n_distinct(Operator.x)) %>% ungroup() %>% 
  summarise(mean(n_operators)) %>%  View

ggplot(Stop_overlapping, 
       aes(x=Longitude, y = Latitude, color= as.factor(n_operators)))+
  geom_point(alpha = 0.7, size = 1.8) + 
  coord_map() +
  labs(title = "Bus Operators in Singapore",
       x = "adjusted longitude",
       y = "adjusted latitude",
       color = "Number of Unique operators")

Stop_overlapping %>% 
  group_by(BusStopCode) %>% 
  summarise(cases1 = n_distinct(Latitude),
            cases2 = n_distinct(Longitude)) %>%
  filter(cases1 >1 | cases2 >1) %>% View

##. groups = "drop", drop the grouping criterion 

#we are interested in for each bus stop, how many bus services pass the 
# we want to visualize that

services_per_stop <- singapore_bus_data %>% 
  group_by(BusStopCode, Latitude, Longitude) %>% 
  summarise(num_services = n_distinct(ServiceNo)) %>% ungroup()

#check the summary statistics of your calculations
fivenum(services_per_stop$num_services)# minimum value, 25 - 50 - 75% percentile, maximum value 

#find the number of bus stop
nrow(services_per_stop)

ggplot(services_per_stop, 
       aes(x=Longitude, y = Latitude, color= num_services))+
  geom_point(alpha = 0.7, size = 1.8) + #alpha: changing the opaque lv, size: changing the point size
  coord_map() +
  labs(title = "Bus Operators in Singapore",
       x = "adjusted longitude",
       y = "adjusted latitude",
       color = "Number of Unique operators")+ 
  scale_color_viridis_c(
    trans = "log10", #to make the difference in smaller values' color more visible , trans can also be trans = "sqrt"
    option = "C", #change the choices of color
    name = "Services per stop",
    direction = -1)


#we are interested in plotting each operator on a separate panel. 
#color codes indicate, whether the operator is represented in the bus stop

#market analysis/ competitive analysis 
#what information do we need in the data to plot? 
#bus stop code, lat, long, serviceno (create binary, for each bus stop code, is there a bus service from each of the operator that pass the stop)
#operator 

#pull out an excel sheet to write down the column names that you want to use for analysis, draft out the structure 
#create the data to plot (ex: like binary code)
#create the full grid of operator and bus stops 
library(tidyr)
singapore_bus_data %>% 
  select(BusStopCode, Latitude, Longitude) %>% unique () %>%  #extract all the unique bus stop informations
  crossing(operators = singapore_bus_data %>% distinct(Operator.x) %>%  pull) %>% 
  left_join(
    singapore_bus_data %>% 
      select(BusStopCode, Operator.x, ServiceNo) %>% unique() %>% 
      mutate(is_covered_by_operator = 1) %>% 
      select (-ServiceNo) %>%
      unique(), by = c("BusStopCode","operators" = "Operator.x")) %>% 
  mutate(is_covered_by_operator = replace_na(is_covered_by_operator, 0)) %>% #pipe directly into gg plot
ggplot( 
       aes(x=Longitude, y = Latitude, color= as.factor(is_covered_by_operator)))+
  geom_point(alpha = 0.7, size = 1.8) + #alpha: changing the opaque lv, size: changing the point size
  coord_map() +
  facet_wrap(.~operators) +
  labs(title = "Bus Operators in Singapore",
       x = "adjusted longitude",
       y = "adjusted latitude",
       color = "Number of Unique operators")+ 
  scale_color_manual(
    values = c("1"= "blue", "0" = "gray80"),
    name = "Covered by Operator")
