#' ---
#' title: "Cleaning and Pre-Processing Divvy Bikeshare Data"
#' author: "Andrew Luyt"
#' date: "2021-07-27"
#' output:
#'   html_document:
#'    keep_md: true
#' ---

#' ## Purpose
#' Transform the numerous raw .csv files into a single, cleaned .csv with
#' some extra features.
#'
#' Read **all** csv files available (except `alldata.csv.gz`) into a single
#' dataframe, add features, then save complete dataset to
#' `alldata.csv.gz`.
#'
#' Only include files in the data
#' directory which you wish to include in the analysis.
#' If datasets which are too old to be relevant are included in the data
#' directory, they will also be read.
#+ message=FALSE
library(data.table)  # use fread for speed
library(R.utils)     # allow fread to read/write .gz
library(tidyverse)
library(lubridate)
library(geosphere)   # calculate trip distances without creating sf objects

Mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

#+ message=FALSE
# Don't include trip_id (it's just a unique string ID) and dropping it
# cuts memory significantly.
# Factors are slower to read but also reduce memory consumption.
df <-
  list.files(path = "./data",
             pattern = "*-divvy-tripdata.csv.gz",
             full.names = TRUE) %>%
  map_df(~fread(.,
                select= (2:13),
                colClasses = c(start_station_id = 'character',
                                  end_station_id = 'character'),
                stringsAsFactors = TRUE))

#' ## Data Issues Resolved
#' We drop rows to remove incomplete, probably-corrupt, or irrelevant data:
#'
#'  - Blank station information: we need to know where trips start and end.
#'  - Huge or tiny trip times: are these bikes stolen, lost, or broken, then brought
#'    back into service?  Did someone undock a bike, then change their mind?
#'    Is it some sort of internal system test?
#'    Whatever the cause, these outliers are irrelevant for casual vs member
#'    analysis.
#'     - We filter out any trips longer than 24 hours or shorter than 1 minute
#'  - impossible speeds: remove any trips with an estimated speed over 70kph.
#'  This represents fewer than 20 trips at time of writing.
#'  - Station names can have multiple station IDs (did they get re-numbered?)
#'  We collapse these into single IDs.
#'    - Some station names are suffixed with " (*)".  This suffix is removed.
#'
#' ## New variables added:
#'
#'  - `weekday`: by the start of the ride (1-7, starts Monday)
#'  - `month`: Abbreviated, by the start of the ride
#'  - Four `sector` variables: a rectangular area on the map. Created by
#'  rounding longitude & latitude to two decimal points.
#'    - Interpreted as a geographical **area** or "bin" where a trip starts
#'    or ends, as opposed to a point. Meant as a convenient aggregating measure
#'    for later analysis.
#'  - `trip_minutes`: Some trips are of negative duration and will be filtered
#'  out later. Online research suggests that some of this comes from Divvy taking
#'  bikes in and out of service for quality control reasons.
#'  - `trip_delta_`: the change in longitude and latitude over the trip.
#'  - `is_round_trip`: a boolean flag that shows if the trip started and ended
#'    at the same station.  Meant to distinguish between commute-type trips
#'    and pleasure cruises.
#'  - `trip_distance_m`: straight-line distance (meters) from start to finish.
#'  This is a proxy for the actual trip path as ridden, which is not available
#'  in the dataset. It will always be smaller than reality. Round trips have
#'  a distance of 0 by this measure. Unavoidable, as GPS tracks showing the
#'  true route taken are not available.
#'  - `trip_kph`: Estimate of overall trip speed. Since `trip_distance_m` is an
#'  underestimate, this speed is faster than reality. However, it will be
#'  useful as a *relative comparison* between groups.

#+ message=FALSE
df <- df %>%
  mutate(
    trip_minutes = as.numeric(difftime(ended_at, started_at, units = "mins")),
    weekday = factor(lubridate::wday(started_at, week_start = 1),
                     levels = 1:7,
                     labels = c("Monday", "Tuesday", "Wednesday",
                                "Thursday", "Friday", "Saturday", "Sunday")),
    month = factor(lubridate::month(started_at, abbr = TRUE, label = TRUE)),
    start_lng_sector = round(start_lng, digits = 2),
    start_lat_sector = round(start_lat, digits = 2),
    end_lng_sector = round(end_lng, digits = 2),
    end_lat_sector = round(end_lat, digits = 2),
    trip_delta_x = end_lng - start_lng,
    trip_delta_y = end_lat - start_lat,
    is_round_trip = if_else(start_station_id == end_station_id,
                            'round trip', 'a to b'),
    start_station_name = str_replace(start_station_name, " \\(\\*\\)", ""),
    end_station_name = str_replace(end_station_name, " \\(\\*\\)", "")) %>%
  filter(
    start_station_name != "",
    start_station_id != "",
    end_station_name != "",
    end_station_id != "",
    !is.na(start_lng),
    !is.na(start_lat),
    !is.na(end_lng),
    !is.na(end_lat),
    trip_minutes < 1440,
    trip_minutes > 1
  ) %>%
  # Create the trip distance feature. geosphere::distm isn't vectorized, so do it
  # rowwise. This is unfortunately slow. distCosine() is accurate to about 0.5%
  # and is the fastest distance measure.  This is accurate enough and
  # takes ~5min on my laptop.
  # Also create trip_kph now that we have the trip distance and remove a
  # small number (<10) of weird trips where people rode at inhuman speeds.
  rowwise() %>%
  mutate(trip_distance_m =
           geosphere::distm(x = c(start_lng, start_lat),
                            y = c(end_lng, end_lat),
                            fun = distCosine)[1, 1], # returns a 1x1 matrix
         trip_kph = trip_distance_m / trip_minutes * 60 / 1000) %>%
  filter(trip_kph < 70) %>%
  group_by(start_station_name) %>%
  mutate(start_station_id = Mode(start_station_id)) %>%
  ungroup() %>%
  group_by(end_station_name) %>%
  mutate(end_station_id = Mode(end_station_id)) %>%
  ungroup()
fwrite(x = df, file = "./data/alldata.csv.gz")
