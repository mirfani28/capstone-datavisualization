# load basic library
options(shiny.maxRequestSize=200*1024^2) #increase size of shinydashboard
options(scipen = 99) #disable scientific annotation
library(tidyverse) #collection of library for R
library(dplyr) #grammar of data manipulation
library(readr) #reading data
library(glue) #setting tooltip
library(scales) # scale for plot

#load library for plotting map
library(XML) #to read GPX file
library(OpenStreetMap) #plotting to Open Street
library(lubridate) #treatment date column
library(ggmap) #plotting map 
library(ggplot2) #static plot
library(raster) #plotting map, to add background data to map
library(sp) #plotting map complementary
library(mapview) #interactive map plotting
library(leaflet)  #interactive map plotting
library(plotly) #interactive plot

#load shiny
library(shinydashboard)
library(shiny)

#Import Dataset
activities <- read_csv(file = "strava-data/activities.csv")

#Cleaning Dataset
activities_clean <-
  activities %>%
  select('Activity ID',
         'Activity Date',
         'Activity Type',
         'Elapsed Time...15',
         'Distance...7',
         'Moving Time',
         'Max Speed',
         'Average Speed',
         'Elevation Gain',
         'Average Watts',
         'Calories',
         'Bike',
         'Gear') %>%
  rename('activity_id' = 'Activity ID',
         'date' = 'Activity Date',
         'type' = 'Activity Type',
         'elapsed_time' = 'Elapsed Time...15',
         'distance' = 'Distance...7',
         'moving_time' = 'Moving Time',
         'max_speed' = 'Max Speed',
         'avg_speed' = 'Average Speed',
         'elevation_gain' = 'Elevation Gain',
         'avg_watts' = 'Average Watts',
         'calories' = 'Calories',
         'bike_id' = 'Bike',
         'gear_id' = 'Gear')

activities_clean <-
  activities_clean %>%
  mutate(equip_id = coalesce(bike_id, gear_id)) %>%
  select(-(bike_id:gear_id))

activities_clean <- 
  activities_clean %>%
  filter_at(vars(elevation_gain, calories), all_vars(!is.na(.)))

activities_clean_final <-
  activities_clean %>%
  mutate(
    type = as_factor(type),
    equip_id = as_factor(equip_id),
    activity_id = as.character(activity_id)
  )

activities_clean_final$date <- mdy_hms(activities_clean_final$date, tz="Asia/Jakarta") + hours(7)

activities_clean_final <-
  activities_clean_final %>%
  filter(activity_id != "3075499358")

activities_clean_final$year_record <- year(activities_clean_final$date)
activities_clean_final$month_record <- month(activities_clean_final$date, label = TRUE)
activities_clean_final$hour_record <- hour(activities_clean_final$date)

activities_clean_final <-
  activities_clean_final %>% 
  filter(year_record %in% c(2020,2021)) %>%
  mutate(
    year_record= as_factor(year_record), 
    month_record= as_factor(month_record)
  )


#Data Aggregation for Summary

summary_sport <-
  activities_clean_final %>%
  summarise(total_moving_time = sum(moving_time),
            total_calories = sum(calories),
            total_distance = sum(distance))

#Create Input
selectType <- unique(activities_clean_final$type)

#Map Convert from GPX
