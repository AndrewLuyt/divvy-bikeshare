---
title: "Prepare to Use the Divvy Dataset"
author: "Andrew Luyt"
date: "2021-07-27"
output: 
  html_document:
    keep_md: true
---

## Executive Summary

- Do we have the appropriate rights to use this data?
  - ![checkmark](img/checkmark.png) Yes, see "Data Rights", below.
- Does the data seem complete?
  - **? Problematic:** 10% of rides are missing the station names.  We don't
  know if this is a random selection of rides or represents a pattern relevant
  to our analysis.
- Has it been anonymized?
  - ![checkmark](img/checkmark.png) Yes. Only an anonymous `ride_id` identifies
    the ride.
- Does it appear we can perform the business task with this dataset?
  - **? Problematic:** It might be difficult to infer *how* or *why* the bikes 
  are being used with such limited information.
    - We have obtained map data for Chicago so we can more sensibly interpret
    the location information.
- **Data has been limited to sources as new or newer than April 2020** to
  analyze only current trends.

## Data Rights
The data being used is available under 
[this licence.](https://www.divvybikes.com/data-license-agreement)
The agreement allows us the right to independently analyze this dataset. 

## Dataset summary




Let's examine the most recent file from the raw dataset. 


```r
names(df)  # What variables are in the dataset?
```

```
##  [1] "ride_id"            "rideable_type"      "started_at"        
##  [4] "ended_at"           "start_station_name" "start_station_id"  
##  [7] "end_station_name"   "end_station_id"     "start_lat"         
## [10] "start_lng"          "end_lat"            "end_lng"           
## [13] "member_casual"
```

```r
skimr::skim(df)
```


Table: Data summary

|                         |       |
|:------------------------|:------|
|Name                     |df     |
|Number of rows           |729595 |
|Number of columns        |13     |
|_______________________  |       |
|Column type frequency:   |       |
|character                |5      |
|factor                   |2      |
|numeric                  |4      |
|POSIXct                  |2      |
|________________________ |       |
|Group variables          |None   |


**Variable type: character**

|skim_variable      | n_missing| complete_rate| min| max| empty| n_unique| whitespace|
|:------------------|---------:|-------------:|---:|---:|-----:|--------:|----------:|
|ride_id            |         0|          1.00|  16|  16|     0|   729595|          0|
|start_station_name |     80093|          0.89|  10|  53|     0|      689|          0|
|start_station_id   |     80093|          0.89|   3|  35|     0|      689|          0|
|end_station_name   |     86387|          0.88|  10|  53|     0|      690|          0|
|end_station_id     |     86387|          0.88|   3|  35|     0|      690|          0|


**Variable type: factor**

|skim_variable | n_missing| complete_rate|ordered | n_unique|top_counts                           |
|:-------------|---------:|-------------:|:-------|--------:|:------------------------------------|
|rideable_type |         0|             1|FALSE   |        3|cla: 435020, ele: 242859, doc: 51716 |
|member_casual |         0|             1|FALSE   |        2|cas: 370681, mem: 358914             |


**Variable type: numeric**

|skim_variable | n_missing| complete_rate|   mean|   sd|     p0|    p25|    p50|    p75|   p100|hist  |
|:-------------|---------:|-------------:|------:|----:|------:|------:|------:|------:|------:|:-----|
|start_lat     |         0|             1|  41.90| 0.04|  41.64|  41.88|  41.90|  41.93|  42.07|▁▁▇▇▁ |
|start_lng     |         0|             1| -87.64| 0.03| -87.78| -87.66| -87.64| -87.63| -87.52|▁▁▇▂▁ |
|end_lat       |       717|             1|  41.90| 0.04|  41.51|  41.88|  41.90|  41.93|  42.08|▁▁▁▇▁ |
|end_lng       |       717|             1| -87.64| 0.03| -87.86| -87.66| -87.64| -87.63| -87.49|▁▁▇▆▁ |


**Variable type: POSIXct**

|skim_variable | n_missing| complete_rate|min                 |max                 |median              | n_unique|
|:-------------|---------:|-------------:|:-------------------|:-------------------|:-------------------|--------:|
|started_at    |         0|             1|2021-06-01 00:00:38 |2021-06-30 23:59:59 |2021-06-14 19:46:47 |   589805|
|ended_at      |         0|             1|2021-06-01 00:06:22 |2021-07-13 22:51:35 |2021-06-14 20:13:55 |   589069|
### Observations & Sanity Checks

- About 10% of the observations are missing the station name and/or ID.  However,
almost all rides have the latitude/longitude information and we might be able
to use this to fill in the missing stations.  We'll investigate this in a 
later step.
- The June dataset includes some rides from July.  This is a consequence
of how the files are compiled and released by Divvy, but isn't an issue as
datetime information is attached to every ride.
- Times are recorded down to the second. 
- On their website, Divvy claims their network has over 600 stations. The 
dataset reports about 690. Seems fine.

## Can we infer the station names based on coordinates? 
About 10% of the rides don't have station names, and in a later step will
be dropped
from the analysis. If it became necessary to try to impute the names and
include them in a later analysis, is it possible to infer what the stations
were, based on the longitude and latitude recorded?

**Summary: Yes, looks like it, but we won't because it isn't necessary now.**

Let's see what the mean latitude & longitude is for each station name. Below,
we see that it appears a station can be specified to about three decimal
places of precision.  The standard deviations of the means of the coordinates
is about five decimal places of precision.
At first glance the stations can indeed be clearly identified by their map
coordinates. 

Later, if we wished to pursue this imputation of data, we could do it with a
few simple methods:

- Calculate the mean longitude and latitude of each station, to three decimal
points. Then round the coordinates of each ride to three decimal places and
match them.
- Train a machine learning model to predict the station name based
on the coordinates.  As the coordinates are in a rectangular grid, a tree-based
model (whose decision space is itself a rectangular grid) seems like an 
appropriate first choice.

In the context
of finding differences between user types, prediction errors like placing a
trip start at a station a few blocks away should not bias the analysis much, and
would also give us an extra 10% of data to work with.

```r
# Show more digits: the pillar package controls how tibbles display sigfigs
options(pillar.sigfig = 6)  
df %>% group_by(start_station_name) %>% 
  summarise(xbar = mean(start_lng), 
            ybar = mean(start_lat), 
            sd_x = sd(start_lng), 
            sd_y = sd(start_lat)) %>% 
  head(10)
```

```
## # A tibble: 10 × 5
##    start_station_name             xbar    ybar         sd_x         sd_y
##    <chr>                         <dbl>   <dbl>        <dbl>        <dbl>
##  1 2112 W Peterson Ave        -87.6836 41.9912 0.0000187732 0.0000196476
##  2 63rd St Beach              -87.5763 41.7809 0.0000921554 0.0000555548
##  3 900 W Harrison St          -87.6498 41.8748 0.0000233670 0.0000124568
##  4 Aberdeen St & Jackson Blvd -87.6548 41.8777 0.0000387254 0.0000277196
##  5 Aberdeen St & Monroe St    -87.6555 41.8804 0.0000537584 0.0000309008
##  6 Aberdeen St & Randolph St  -87.6543 41.8841 0.0000234281 0.0000162213
##  7 Ada St & 113th St          -87.6554 41.6876 0.0000592002 0.0000101161
##  8 Ada St & Washington Blvd   -87.6612 41.8828 0.0000255246 0.0000211606
##  9 Adler Planetarium          -87.6073 41.8661 0.0000350289 0.0000221574
## 10 Albany Ave & 26th St       -87.7020 41.8445 0.0000317080 0.0000345195
```


```r
df %>% 
  filter(start_station_name == 'Aberdeen St & Jackson Blvd' | 
         start_station_name == 'Aberdeen St & Monroe St') %>% 
  distinct(across(c(start_station_name, start_lat))) %>% 
  slice_sample(n = 10)
```

```
## # A tibble: 10 × 2
##    start_station_name         start_lat
##    <chr>                          <dbl>
##  1 Aberdeen St & Monroe St      41.8803
##  2 Aberdeen St & Monroe St      41.8805
##  3 Aberdeen St & Monroe St      41.8804
##  4 Aberdeen St & Monroe St      41.8803
##  5 Aberdeen St & Monroe St      41.8805
##  6 Aberdeen St & Jackson Blvd   41.8777
##  7 Aberdeen St & Monroe St      41.8805
##  8 Aberdeen St & Monroe St      41.8804
##  9 Aberdeen St & Monroe St      41.8804
## 10 Aberdeen St & Jackson Blvd   41.8776
```








