# Singapore-Bus-Routes-Operators-Analysis
Geospatial analysis of Singapore’s bus network using LTA open data. Visualizes bus stop coverage, operator overlap, and number of services per stop with ggplot2. Demonstrates data wrangling, mapping, and competitive transport insights using R (dplyr, tidyr, ggplot2, viridis).

**Author:** [Your Name]  
**Language:** R  
**Dataset:** [Singapore Bus Data – Land Transport Authority (LTA)](https://www.kaggle.com/datasets/gowthamvarma/singapore-bus-data-land-transport-authority/data)  
**Source:** [LTA DataMall API](https://datamall.lta.gov.sg/content/dam/datamall/datasets/LTA_DataMall_API_User_Guide.pdf)

---

## 📘 Project Overview

This project performs **geospatial analysis and visualization** of Singapore’s bus network using data from the **Land Transport Authority (LTA)**.  
It explores how **different bus operators** share stops, how many **bus services** pass through each stop, and provides **visual insights** into Singapore’s transport network.

The project demonstrates practical use of:
- **Data wrangling** with `dplyr` and `tidyr`
- **Geospatial visualization** with `ggplot2`
- **Competitive / coverage analysis** across operators
- **Data storytelling** using public transport infrastructure data

https://www.kaggle.com/datasets/gowthamvarma/singapore-bus-data-land-transport-authority/data
chrome-extension://efaidnbmnnnibpcajpcglclefindmkaj/https://datamall.lta.gov.sg/content/dam/datamall/datasets/LTA_DataMall_API_User_Guide.pdf?ref=stuartbreckenridge.net


``` r
library(dplyr)

dataroot <- "C:/Users/MSI KATANA/Desktop/Tulane/Business Analytics Practic/Singapore Bus Routes/fulldata.rds"
singapore_bus_data <- readRDS(dataroot)


str(singapore_bus_data)
```

```
## spc_tbl_ [26,317 × 28] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
##  $ ...1.x         : num [1:26317] 0 1 2 3 4 5 6 7 8 9 ...
##  $ ServiceNo      : chr [1:26317] "10" "10" "10" "10" ...
##  $ Operator.x     : chr [1:26317] "SBST" "SBST" "SBST" "SBST" ...
##  $ Direction      : num [1:26317] 1 1 1 1 1 1 1 1 1 1 ...
##  $ StopSequence   : num [1:26317] 1 2 3 4 5 6 7 8 9 10 ...
##  $ BusStopCode    : chr [1:26317] "75009" "76059" "76069" "96289" ...
##  $ Distance       : num [1:26317] 0 0.6 1.1 2.3 2.7 3.3 3.5 3.8 4.1 4.5 ...
##  $ WD_FirstBus    : chr [1:26317] "0500" "0502" "0504" "0508" ...
##  $ WD_LastBus     : chr [1:26317] "2300" "2302" "2304" "2308" ...
##  $ SAT_FirstBus   : chr [1:26317] "0500" "0502" "0504" "0508" ...
##  $ SAT_LastBus    : chr [1:26317] "2300" "2302" "2304" "2309" ...
##  $ SUN_FirstBus   : chr [1:26317] "0500" "0502" "0503" "0507" ...
##  $ SUN_LastBus    : chr [1:26317] "2300" "2302" "2304" "2308" ...
##  $ ...1.y         : num [1:26317] 4088 4165 4167 4889 4855 ...
##  $ RoadName       : chr [1:26317] "Tampines Ctrl 1" "Tampines Ave 5" "Tampines Ave 5" "Simei Ave" ...
##  $ Description    : chr [1:26317] "Tampines Int" "Opp Our Tampines Hub" "Blk 147" "Changi General Hosp" ...
##  $ Latitude       : num [1:26317] 1.35 1.35 1.35 1.34 1.34 ...
##  $ Longitude      : num [1:26317] 104 104 104 104 104 ...
##  $ ...1           : num [1:26317] 55 55 55 55 55 55 55 55 55 55 ...
##  $ Operator.y     : chr [1:26317] "SBST" "SBST" "SBST" "SBST" ...
##  $ Category       : chr [1:26317] "TRUNK" "TRUNK" "TRUNK" "TRUNK" ...
##  $ OriginCode     : chr [1:26317] "75009" "75009" "75009" "75009" ...
##  $ DestinationCode: chr [1:26317] "16009" "16009" "16009" "16009" ...
##  $ AM_Peak_Freq   : chr [1:26317] "08-09" "08-09" "08-09" "08-09" ...
##  $ AM_Offpeak_Freq: chr [1:26317] "06-17" "06-17" "06-17" "06-17" ...
##  $ PM_Peak_Freq   : chr [1:26317] "10-15" "10-15" "10-15" "10-15" ...
##  $ PM_Offpeak_Freq: chr [1:26317] "11-18" "11-18" "11-18" "11-18" ...
##  $ LoopDesc       : chr [1:26317] NA NA NA NA ...
##  - attr(*, "spec")=List of 3
##   ..$ cols   :List of 13
##   .. ..$ ...1        : list()
##   .. .. ..- attr(*, "class")= chr [1:2] "collector_double" "collector"
##   .. ..$ ServiceNo   : list()
##   .. .. ..- attr(*, "class")= chr [1:2] "collector_character" "collector"
##   .. ..$ Operator    : list()
##   .. .. ..- attr(*, "class")= chr [1:2] "collector_character" "collector"
##   .. ..$ Direction   : list()
##   .. .. ..- attr(*, "class")= chr [1:2] "collector_double" "collector"
##   .. ..$ StopSequence: list()
##   .. .. ..- attr(*, "class")= chr [1:2] "collector_double" "collector"
##   .. ..$ BusStopCode : list()
##   .. .. ..- attr(*, "class")= chr [1:2] "collector_character" "collector"
##   .. ..$ Distance    : list()
##   .. .. ..- attr(*, "class")= chr [1:2] "collector_double" "collector"
##   .. ..$ WD_FirstBus : list()
##   .. .. ..- attr(*, "class")= chr [1:2] "collector_character" "collector"
##   .. ..$ WD_LastBus  : list()
##   .. .. ..- attr(*, "class")= chr [1:2] "collector_character" "collector"
##   .. ..$ SAT_FirstBus: list()
##   .. .. ..- attr(*, "class")= chr [1:2] "collector_character" "collector"
##   .. ..$ SAT_LastBus : list()
##   .. .. ..- attr(*, "class")= chr [1:2] "collector_character" "collector"
##   .. ..$ SUN_FirstBus: list()
##   .. .. ..- attr(*, "class")= chr [1:2] "collector_character" "collector"
##   .. ..$ SUN_LastBus : list()
##   .. .. ..- attr(*, "class")= chr [1:2] "collector_character" "collector"
##   ..$ default: list()
##   .. ..- attr(*, "class")= chr [1:2] "collector_guess" "collector"
##   ..$ delim  : chr ","
##   ..- attr(*, "class")= chr "col_spec"
##  - attr(*, "problems")=<externalptr>
```

``` r
singapore_bus_data %>% count(Operator.x)
```

```
## # A tibble: 4 × 2
##   Operator.x     n
##   <chr>      <int>
## 1 GAS         1973
## 2 SBST       16255
## 3 SMRT        6269
## 4 TTS         1820
```

``` r
Stop_overlapping <- singapore_bus_data %>% 
  group_by(BusStopCode,Latitude, Longitude) %>% 
  summarise(n_operators = n_distinct(Operator.x), .groups = "drop")

singapore_bus_data %>% 
  group_by(BusStopCode,Latitude, Longitude) %>% 
  summarise(n_operators = n_distinct(Operator.x)) %>% #ungroup()
  select(BusStopCode, n_operators) %>% View
```

```
## `summarise()` has grouped output by 'BusStopCode', 'Latitude'. You can override using the `.groups`
## argument.
## Adding missing grouping variables: `Latitude`
```

``` r
singapore_bus_data %>% 
  group_by(BusStopCode,Latitude, Longitude) %>% 
  summarise(n_operators = n_distinct(Operator.x)) %>% ungroup() %>% 
  summarise(mean(n_operators)) %>%  View
```

```
## `summarise()` has grouped output by 'BusStopCode', 'Latitude'. You can override using the `.groups`
## argument.
```

``` r
ggplot(Stop_overlapping, 
       aes(x=Longitude, y = Latitude, color= as.factor(n_operators)))+
  geom_point(alpha = 0.7, size = 1.8) + 
  coord_map() +
  labs(title = "Bus Operators in Singapore",
       x = "adjusted longitude",
       y = "adjusted latitude",
       color = "Number of Unique operators")
```

```
## Warning: Removed 1 row containing missing values or values outside the scale range (`geom_point()`).
```

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1-1.png)

``` r
Stop_overlapping %>% 
  group_by(BusStopCode) %>% 
  summarise(cases1 = n_distinct(Latitude),
            cases2 = n_distinct(Longitude)) %>%
  filter(cases1 >1 | cases2 >1) %>% View
```

#. groups = "drop", drop the grouping criterion 
we are interested in for each bus stop, how many bus services pass the 
we want to visualize that


``` r
services_per_stop <- singapore_bus_data %>% 
  group_by(BusStopCode, Latitude, Longitude) %>% 
  summarise(num_services = n_distinct(ServiceNo)) %>% ungroup()
```

```
## `summarise()` has grouped output by 'BusStopCode', 'Latitude'. You can override using the `.groups`
## argument.
```

check the summary statistics of your calculations


``` r
fivenum(services_per_stop$num_services)# minimum value, 25 - 50 - 75% percentile, maximum value 
```

```
## [1]  1  2  3  7 48
```

find the number of bus stop


``` r
nrow(services_per_stop)
```

```
## [1] 5022
```

``` r
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
```

```
## Warning: Removed 1 row containing missing values or values outside the scale range (`geom_point()`).
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-1.png)

we are interested in plotting each operator on a separate panel. 
color codes indicate, whether the operator is represented in the bus stop
market analysis/ competitive analysis 
what information do we need in the data to plot? 
bus stop code, lat, long, serviceno (create binary, for each bus stop code, is there a bus service from each of the operator that pass the stop)
operator 
pull out an excel sheet to write down the column names that you want to use for analysis, draft out the structure 
create the data to plot (ex: like binary code)
create the full grid of operator and bus stops 


``` r
library(tidyr)
library(ggplot2)
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
```

```
## Warning: Removed 4 rows containing missing values or values outside the scale range (`geom_point()`).
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5-1.png)

