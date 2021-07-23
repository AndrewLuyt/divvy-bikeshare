# Andrew Luyt, 2021
# Preprocess the numerous raw .csv files containing bikeshare ride
# information.
#
# Read all csv files available (except alldata.csv) into a single
# dataframe, add a trip_minutes feature, save complete dataset to
# alldata.csv.gz

library(data.table)  # use fread for speed
library(R.utils)     # allow fread to read/write .gz
library(tidyverse)
library(lubridate)

# We don't need trip_id (it's just a unique ID) and dropping it
# cuts memory use in half.
# factors are slower to read but reduce memory consumption
df <-
  list.files(path = "./data",
             pattern = "*-divvy-tripdata.csv.gz",
             full.names = TRUE) %>%
  map_df(~fread(.,
                select= (2:13),
                colClasses = c(start_station_id = 'character',
                                  end_station_id = 'character'),
                stringsAsFactors = FALSE))

# Problems fixed by dropping rows:
#  - blank stations
#  - huge trip times: are these bikes stolen, then recovered?
#     - filter out any trips longer than 24 hours
# New variables added:
#  - weekday (1-7, starts Monday)
#  - sector: rectangular area on map. Created by rounding lng/lat to
#    two decimal points.
#    - meant as an aggregating measure. Incidents could be, e.g.:
#       - plotted as in countplot() with increasing size of the point
#       - mapped onto a rectangular grid. This grid would have to be calculated
#         and some form of sf object created, which could then be coloured, etc.
df <- df %>%
  mutate(trip_minutes = abs(as.numeric(difftime(ended_at, started_at, units = "mins"))),
         weekday = factor(lubridate::wday(started_at, week_start = 1),
                          levels = 1:7,
                          labels = c("Monday", "Tuesday", "Wednesday",
                                     "Thursday", "Friday", "Saturday",
                                     "Sunday")),
         start_lng_sector = round(start_lng, digits = 2),
         start_lat_sector = round(start_lat, digits = 2),
         end_lng_sector = round(end_lng, digits = 2),
         end_lat_sector = round(end_lat, digits = 2),
         trip_delta_x = end_lng - start_lng,
         trip_delta_y = end_lat - start_lat,
         is_round_trip = if_else(start_station_id == end_station_id, 'round trip', 'a to b')) %>%
  filter(start_station_name != "" & start_station_id != "" &
           end_station_name != "" & end_station_id != "" &
           trip_minutes < 1440)

fwrite(x = df, file = "./data/alldata.csv.gz")
