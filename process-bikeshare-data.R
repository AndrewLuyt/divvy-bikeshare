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
gc()
df <- df %>%
  mutate(trip_minutes = difftime(ended_at, started_at, units = "mins"))

fwrite(x = df, file = "./data/alldata.csv")
