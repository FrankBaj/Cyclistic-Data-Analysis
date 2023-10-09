install.packages('tidyverse')

## Loading Packages
library('tidyverse')
library('ggplot2')
library('tidyr')
library('readr')
library('dplyr')
library('lubridate')

## Loading Data
X2020_12_tripdata <- read_csv("202012-divvy-tripdata.csv")
View(X2020_12_tripdata)
X2021_12_tripdata <- read_csv("202112-divvy-tripdata.csv")
View(X2021_12_tripdata)
X2022_12_tripdata <- read_csv("202212-divvy-tripdata.csv")
View(X2022_12_tripdata)
X2023_02_tripdata <- read_csv("202302-divvy-tripdata.csv")
View(X2023_02_tripdata)

## Modifying Data
trip_data_2020_2023 <- bind_rows(X2020_12_tripdata, X2021_12_tripdata, X2022_12_tripdata, X2023_02_tripdata) %>% arrange(started_at)

trip_data_2020_2023$length_of_trip <- abs(difftime(trip_data_2020_2023$ended_at, trip_data_2020_2023$started_at, units = "mins"))

member_trip_data <- subset(trip_data_2020_2023, member_casual == "member", select=c(ride_id, rideable_type, started_at, ended_at, member_casual, length_of_trip))

casual_trip_data <- subset(trip_data_2020_2023, member_casual == "casual", select=c(ride_id, rideable_type, started_at, ended_at, member_casual, length_of_trip))

trip_data_2020_2023$day_of_week <- weekdays(trip_data_2020_2023$started_at)

member_trip_data$day_of_week <- weekdays(member_trip_data$started_at)

casual_trip_data$day_of_week <- weekdays(casual_trip_data$started_at)

trip_data_2020_2023$length_of_trip <- as.numeric(trip_data_2020_2023$length_of_trip)

avg_length_by_day <- trip_data_2020_2023 %>% group_by(day_of_week) %>% summarise(mean(length_of_trip))

colnames(avg_length_by_day)[2] <- "average_length_of_time"

avg_length_by_membership <- trip_data_2020_2023 %>% group_by(member_casual) %>% summarise(mean(length_of_trip))

max_trip_length_by_membership <- trip_data_2020_2023 %>% group_by(member_casual) %>% summarise(max(length_of_trip))

avg_trip_length_by_membership_and_day <- trip_data_2020_2023 %>% group_by(member_casual, day_of_week) %>% summarise(length_of_trip_in_minutes = n())

## Viewing Data
View(trip_data_2020_2023)

View(trip_data_2020_2023 %>% arrange(desc(length_of_trip)))

View(member_trip_data %>% arrange(desc(length_of_trip)))

View(casual_trip_data %>% arrange(desc(length_of_trip)))

View(mean(member_trip_data$length_of_trip))

View(mean(casual_trip_data$length_of_trip))

table(member_trip_data$day_of_week)

table(casual_trip_data$day_of_week)

table(trip_data_2020_2023$day_of_week)

View(avg_length_by_day)

View(avg_length_by_membership)

View(avg_trip_length_by_membership_and_day)

View(max_trip_length_by_membership)

write.csv(trip_data_2020_2023, "C:\\Users\\tiger\\Documents\\Data Analysis Course\\Case Studies\\Cyclistic Case Study\\trip-data-2020-2023-winter.csv", row.names=TRUE)

## Graphing Data
ggplot(data=avg_length_by_day, aes(x = day_of_week, y = average_length_of_time)) + geom_point()

## Removing Data
trip_data_2020_2023 <- subset(trip_data_2020_2023, select = -length_of_trip)

rm(length_of_trip)

rm(member_trip_data)

rm(casual_trip_data)
