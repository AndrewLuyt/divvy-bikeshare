Prepare Cyclistic Dataset
================

## Executive Summary

-   Do we have the appropriate rights to use this data?
    -   ![checkmark](img/checkmark.png) Yes, see “Data Rights”, below.
-   Does the data seem complete?
    -   **? Problematic.** 10% of the station names are missing. It
        might be possible to fill this in using the geographical
        coordinates which are almost entirely complete.
-   Has it been anonymized?
    -   ![checkmark](img/checkmark.png) Yes. Only an anonymous `ride_id`
        identifies the ride.
-   Does it appear we can perform the business task with this dataset?
    -   **? Problematic.** It might be difficult to infer *how* or *why*
        the bikes are being used
    -   We will want to obtain map data for Chicago so we can sensibly
        interpret the location information.
        -   Tableau can help with this visualization
        -   Maps that show districting information (commercial,
            industrial, residential, etc) might be useful in teasing out
            usage patterns by user type.

## Data Rights

The data being used is available under [this
licence.](https://www.divvybikes.com/data-license-agreement) The
agreement allows us the right to independently analyze this dataset.

## Detailed examination

Let’s examine our raw dataset. The output is long, but it gives us a
high-level view of all the data available to us.

``` r
names(df)  # What variables are in the dataset?
```

    ##  [1] "ride_id"            "rideable_type"      "started_at"        
    ##  [4] "ended_at"           "start_station_name" "start_station_id"  
    ##  [7] "end_station_name"   "end_station_id"     "start_lat"         
    ## [10] "start_lng"          "end_lat"            "end_lng"           
    ## [13] "member_casual"

``` r
skimr::skim(df)
```

|                                                  |        |
|:-------------------------------------------------|:-------|
| Name                                             | df     |
| Number of rows                                   | 531633 |
| Number of columns                                | 13     |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_   |        |
| Column type frequency:                           |        |
| character                                        | 5      |
| factor                                           | 2      |
| numeric                                          | 4      |
| POSIXct                                          | 2      |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ |        |
| Group variables                                  | None   |

Data summary

**Variable type: character**

| skim\_variable       | n\_missing | complete\_rate | min | max | empty | n\_unique | whitespace |
|:---------------------|-----------:|---------------:|----:|----:|------:|----------:|-----------:|
| ride\_id             |          0 |           1.00 |  16 |  16 |     0 |    531633 |          0 |
| start\_station\_name |      53744 |           0.90 |  10 |  53 |     0 |       687 |          0 |
| start\_station\_id   |      53744 |           0.90 |   3 |  35 |     0 |       686 |          0 |
| end\_station\_name   |      58194 |           0.89 |  10 |  53 |     0 |       683 |          0 |
| end\_station\_id     |      58194 |           0.89 |   3 |  35 |     0 |       682 |          0 |

**Variable type: factor**

| skim\_variable | n\_missing | complete\_rate | ordered | n\_unique | top\_counts                          |
|:---------------|-----------:|---------------:|:--------|----------:|:-------------------------------------|
| rideable\_type |          0 |              1 | FALSE   |         3 | cla: 309093, ele: 179187, doc: 43353 |
| member\_casual |          0 |              1 | FALSE   |         2 | mem: 274717, cas: 256916             |

**Variable type: numeric**

| skim\_variable | n\_missing | complete\_rate |   mean |   sd |     p0 |    p25 |    p50 |    p75 |   p100 | hist  |
|:---------------|-----------:|---------------:|-------:|-----:|-------:|-------:|-------:|-------:|-------:|:------|
| start\_lat     |          0 |              1 |  41.90 | 0.05 |  41.65 |  41.88 |  41.90 |  41.93 |  42.07 | ▁▁▇▇▁ |
| start\_lng     |          0 |              1 | -87.64 | 0.03 | -87.78 | -87.66 | -87.64 | -87.63 | -87.52 | ▁▂▇▂▁ |
| end\_lat       |        452 |              1 |  41.90 | 0.05 |  41.56 |  41.88 |  41.90 |  41.93 |  42.09 | ▁▁▂▇▁ |
| end\_lng       |        452 |              1 | -87.64 | 0.03 | -87.85 | -87.66 | -87.64 | -87.63 | -87.52 | ▁▁▃▇▁ |

**Variable type: POSIXct**

| skim\_variable | n\_missing | complete\_rate | min                 | max                 | median              | n\_unique |
|:---------------|-----------:|---------------:|:--------------------|:--------------------|:--------------------|----------:|
| started\_at    |          0 |              1 | 2021-05-01 00:00:11 | 2021-05-31 23:59:16 | 2021-05-19 07:44:31 |    447224 |
| ended\_at      |          0 |              1 | 2021-05-01 00:03:26 | 2021-06-10 22:17:11 | 2021-05-19 07:59:43 |    447217 |

### Observations

-   About 10% of the observations are missing the station name and/or
    ID. However, almost all rides have the latitude/longitude
    information and we might be able to use this to fill in the missing
    stations. We’ll investigate this in a later step.
-   The May dataset includes some rides from June.
-   It’s worth noting that the times are recorded down to the second.
