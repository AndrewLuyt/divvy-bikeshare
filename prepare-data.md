Prepare to Use the Divvy Dataset
================
Andrew Luyt
<br>Last updated: Friday August 13, 2021

## Summary

-   Do we have the appropriate rights to use this data?
    -   ![checkmark](img/checkmark.png) Yes, see “Data Rights”, below.
-   Does the data seem complete?
    -   **? Problematic:** 10% of rides are missing the station names.
        We don’t know if this is a random selection of rides or
        represents a pattern relevant to our analysis.
-   Has it been anonymized?
    -   ![checkmark](img/checkmark.png) Yes. Only an anonymous `ride_id`
        identifies the ride.
-   Does it appear we can perform the business task with this dataset?
    -   **? Problematic:** It might be difficult to infer *how* or *why*
        the bikes are being used with such limited information.
        -   We have obtained map data for Chicago so we can more
            sensibly interpret the location information.
-   **Data has been limited to the past year** to analyze only current
    trends.

## Data Rights

The data being used is available under [this
licence.](https://www.divvybikes.com/data-license-agreement) The
agreement allows us the right to independently analyze this dataset.

## Dataset summary

Let’s examine the most recent file from the raw dataset.

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
| Number of rows                                   | 729595 |
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
| ride\_id             |          0 |           1.00 |  16 |  16 |     0 |    729595 |          0 |
| start\_station\_name |      80093 |           0.89 |  10 |  53 |     0 |       689 |          0 |
| start\_station\_id   |      80093 |           0.89 |   3 |  35 |     0 |       689 |          0 |
| end\_station\_name   |      86387 |           0.88 |  10 |  53 |     0 |       690 |          0 |
| end\_station\_id     |      86387 |           0.88 |   3 |  35 |     0 |       690 |          0 |

**Variable type: factor**

| skim\_variable | n\_missing | complete\_rate | ordered | n\_unique | top\_counts                          |
|:---------------|-----------:|---------------:|:--------|----------:|:-------------------------------------|
| rideable\_type |          0 |              1 | FALSE   |         3 | cla: 435020, ele: 242859, doc: 51716 |
| member\_casual |          0 |              1 | FALSE   |         2 | cas: 370681, mem: 358914             |

**Variable type: numeric**

| skim\_variable | n\_missing | complete\_rate |   mean |   sd |     p0 |    p25 |    p50 |    p75 |   p100 | hist  |
|:---------------|-----------:|---------------:|-------:|-----:|-------:|-------:|-------:|-------:|-------:|:------|
| start\_lat     |          0 |              1 |  41.90 | 0.04 |  41.64 |  41.88 |  41.90 |  41.93 |  42.07 | ▁▁▇▇▁ |
| start\_lng     |          0 |              1 | -87.64 | 0.03 | -87.78 | -87.66 | -87.64 | -87.63 | -87.52 | ▁▁▇▂▁ |
| end\_lat       |        717 |              1 |  41.90 | 0.04 |  41.51 |  41.88 |  41.90 |  41.93 |  42.08 | ▁▁▁▇▁ |
| end\_lng       |        717 |              1 | -87.64 | 0.03 | -87.86 | -87.66 | -87.64 | -87.63 | -87.49 | ▁▁▇▆▁ |

**Variable type: POSIXct**

| skim\_variable | n\_missing | complete\_rate | min                 | max                 | median              | n\_unique |
|:---------------|-----------:|---------------:|:--------------------|:--------------------|:--------------------|----------:|
| started\_at    |          0 |              1 | 2021-06-01 00:00:38 | 2021-06-30 23:59:59 | 2021-06-14 19:46:47 |    589805 |
| ended\_at      |          0 |              1 | 2021-06-01 00:06:22 | 2021-07-13 22:51:35 | 2021-06-14 20:13:55 |    589069 |

### Observations & Sanity Checks

-   About 10% of the observations are missing the station name and/or
    ID. However, almost all rides have the latitude/longitude
    information and we might be able to use this to fill in the missing
    stations. We’ll investigate this in a later step.
-   The June dataset includes some rides from July. This is a
    consequence of how the files are compiled and released by Divvy, but
    isn’t an issue as datetime information is attached to every ride.
-   Times are recorded down to the second.
-   On their website, Divvy claims their network has over 600 stations.
    The dataset reports about 690. Seems fine.

## Can we infer the station names based on coordinates?

About 10% of the rides don’t have station names, and in a later step
will be dropped from the analysis. If it became necessary to try to
impute the names and include them in a later analysis, is it possible to
infer what the stations were, based on the longitude and latitude
recorded?

**Summary: Yes, looks like it, but we won’t because it isn’t necessary
now.**

Let’s see what the mean latitude & longitude is for each station name.
Below, we see that it appears a station can be specified to three or
four decimal places of precision. The standard deviations of the means
of the coordinates is about five decimal places of precision. At first
glance the stations can indeed be clearly identified by their map
coordinates.

Later, if we wished to pursue this imputation of data, we could do it
with a few simple methods:

-   Calculate the mean longitude and latitude of each station to about
    three decimal points. Then round the coordinates of each ride and
    match them.
-   Train a machine learning model to predict the station name based on
    the coordinates. As the coordinates are in a rectangular grid, a
    tree-based model (whose decision space is itself a rectangular grid)
    seems like an appropriate first choice.

In the context of finding differences between user types, prediction
errors like placing a trip start at a station a few blocks away should
not bias the analysis much, and would also give us an extra 10% of data
to work with.

| start\_station\_name       |   mean\_x |  mean\_y |    sd\_x |    sd\_y |
|:---------------------------|----------:|---------:|---------:|---------:|
| 2112 W Peterson Ave        | -87.68359 | 41.99118 | 1.88e-05 | 1.96e-05 |
| 63rd St Beach              | -87.57626 | 41.78095 | 9.22e-05 | 5.56e-05 |
| 900 W Harrison St          | -87.64980 | 41.87475 | 2.34e-05 | 1.25e-05 |
| Aberdeen St & Jackson Blvd | -87.65480 | 41.87773 | 3.87e-05 | 2.77e-05 |
| Aberdeen St & Monroe St    | -87.65554 | 41.88042 | 5.38e-05 | 3.09e-05 |
| Aberdeen St & Randolph St  | -87.65427 | 41.88412 | 2.34e-05 | 1.62e-05 |
| Ada St & 113th St          | -87.65543 | 41.68756 | 5.92e-05 | 1.01e-05 |
| Ada St & Washington Blvd   | -87.66120 | 41.88283 | 2.55e-05 | 2.12e-05 |
| Adler Planetarium          | -87.60728 | 41.86610 | 3.50e-05 | 2.22e-05 |
| Albany Ave & 26th St       | -87.70203 | 41.84449 | 3.17e-05 | 3.45e-05 |

| start\_station\_name       | start\_lat |
|:---------------------------|-----------:|
| Aberdeen St & Monroe St    |   41.88037 |
| Aberdeen St & Jackson Blvd |   41.87773 |
| Aberdeen St & Jackson Blvd |   41.87775 |
| Aberdeen St & Jackson Blvd |   41.87772 |
| Aberdeen St & Jackson Blvd |   41.87775 |
| Aberdeen St & Jackson Blvd |   41.87770 |
| Aberdeen St & Jackson Blvd |   41.87770 |
| Aberdeen St & Monroe St    |   41.88056 |
| Aberdeen St & Jackson Blvd |   41.87783 |
| Aberdeen St & Monroe St    |   41.88052 |
