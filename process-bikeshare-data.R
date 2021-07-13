# Andrew Luyt, 2021
# Preprocess the numerous raw .csv files containing bikeshare ride
# information.
#
# Read all csv files available (except alldata.csv) into a single
# dataframe, add a trip_minutes feature, save complete dataset to
# alldata.csv

library(tidyverse)
library(lubridate)
library(data.table) # use fread for speed

# We don't need trip_id (it's just a unique ID) and dropping it
# cuts memory use in half.
# factors are slower to read but reduce memory consumption
df <-
  list.files(path = "./data",
             pattern = "*-divvy-tripdata.csv",
             full.names = TRUE) %>%
  map_df(~fread(.,
                select= (2:13),
                colClasses = c(start_station_id = 'character',
                                  end_station_id = 'character'),
                stringsAsFactors = TRUE))

# Problems to fix:
#  - blank stations
#  - huge trip times: are these bikes stolen, then recovered?
#     - filter out any trips longer than 24 hours
df <- df %>%
  mutate(trip_minutes = abs(as.numeric(difftime(ended_at, started_at, units = "mins"))),
         weekday = factor(lubridate::wday(started_at, week_start = 1),
                          levels = 1:7,
                          labels = c("Monday", "Tuesday", "Wednesday",
                                     "Thursday", "Friday", "Saturday",
                                     "Sunday"))) %>%
  filter(start_station_name != "" & start_station_id != "" &
           end_station_name != "" & end_station_id != "" &
           trip_minutes < 1440)

fwrite(x = df, file = "./data/alldata.csv")
