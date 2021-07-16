Analyze: How do Casual Users and Annual Subscribers Differ?
================
Andrew Luyt

## Who rides most often?

Members take the majority of rides.
![](analyze-data_files/figure-gfm/who%20rides%20most%20often-1.png)<!-- -->

## How do they differ on type of bike ridden?

Casuals are more likely to choose a docked bike and less likely to
choose a classic bike.

**This is confusing**. The divvy website lists two types of bikes,
**classic** and **electric bike.** What is a **docked bike**?
![](analyze-data_files/figure-gfm/differ%20on%20bike%20type-1.png)<!-- -->

# How long do they ride?

Casuals ride more than twice as long as members, on average.
![](analyze-data_files/figure-gfm/mean%20ride%20length-1.png)<!-- -->

## Members ride more often, casuals ride longer: who rides the most minutes?

Casuals spend more time using the bicycles.
![](analyze-data_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

## What is the distribution of ride lengths?

A quick examination shows a few notable items:

-   Casuals have a higher mean and median trip time. i.e. they tend to
    take longer trips
-   The difference is amplified in the particularly long trips
    -   compare the 95th percentile trip time. 5% of casuals take trips
        longer than 1:50!

<!-- -->

    ## # A tibble: 6 x 5
    ## # Groups:   member_casual [2]
    ##   member_casual  mean median quantiles     q
    ##   <fct>         <dbl>  <dbl>     <dbl> <dbl>
    ## 1 casual         36.0   21.1     11.5   0.25
    ## 2 casual         36.0   21.1     39.8   0.75
    ## 3 casual         36.0   21.1    110.    0.95
    ## 4 member         15.3   11.4      6.48  0.25
    ## 5 member         15.3   11.4     19.8   0.75
    ## 6 member         15.3   11.4     37.9   0.95

From above we see there is a **wide** range of trip lengths, with most
being short and a small number being over an hour. We will trim off the
longest 5% of trips so we can see the typical pattern of ride length.

**One observation is that casual riders make up almost all trips longer
than 40 minutes!**

**TODO: is there some limitation on ride length for members? The cutoff
around 40 minutes looks quite sudden.**

One question to arise from this: what sort of bike is most comfortable
for long trips, and which are better for short ones? Do members tend to
choose lighter, speedier bikes and do casuals prefer bikes with more
comfort?

``` r
df %>% 
  group_by(member_casual) %>%  # IMPORTANT! Trim the top 5% of EACH GROUP, separately
  filter(trip_minutes < quantile(trip_minutes, 0.95)) %>% 
  ungroup() %>% 
  ggplot(aes(x = trip_minutes, fill = member_casual, color = member_casual)) +
  geom_histogram(bins = 40, alpha = 0.7)
```

![](analyze-data_files/figure-gfm/trip%20length%20histogram-1.png)<!-- -->

## Ride length, by weekday

We see an unsurprising distribution of trip times over the week: a
slight increase over the weekend, with casual riders having showing a
larger difference.

``` r
df %>% 
  group_by(weekday, member_casual) %>% 
  summarise(mean_ride_length = mean(trip_minutes)) %>% 
  ggplot(aes(weekday, mean_ride_length, fill=member_casual)) +
  geom_col(position = position_dodge(width = 0.4), alpha = 0.8)
```

    ## `summarise()` has grouped output by 'weekday'. You can override using the `.groups` argument.

![](analyze-data_files/figure-gfm/tuesday%20oddity-1.png)<!-- -->

## Number of trips by day of the week

We see here that:

-   Member use is fairly steady through the week
-   Casual use increases on Friday and nearly doubles through the
    weekend.

We can take this as more evidence that members are often commuting,
whereas casuals are primarily riding for other reasons (enjoyment,
exercise?)
![](analyze-data_files/figure-gfm/day%20of%20week-1.png)<!-- -->

## Do they differ in *what hour* rides are taken?

There seems to be a slight tendency for casuals to start their rides
later. The tendency is similar for ending times (not shown.)

![](analyze-data_files/figure-gfm/hour%20of%20trip%20start-1.png)<!-- -->

## Hour of trip start, in detail

Lending more weight to the ‘members commute more often’ hypothesis we
see two jumps in member activity, both starting around morning and
evening commute times. Casual users have a much smoother increase in
trips as the day goes on. Two possible interpretations are that casuals
are using a bike for their commute less often, or casual users tend to
have non-typical start times for their job.
![](analyze-data_files/figure-gfm/hour%20of%20trip%20start%20detailed-1.png)<!-- -->

## Are some stations preferred by casuals?

Dramatically so! Some stations are 100% casual use and others are
near-zero! The median station is 42% casual use.

![](analyze-data_files/figure-gfm/station%20use-1.png)<!-- -->

## Break stations into 10 groups: slowest to busiest

### TODO: check this entire section, seems iffy

On the left, the slowest 10% of stations (by number of trips started
there) are preferred by members. This is important as these unpopular
stations are used most often by our members whom we desire to keep.

![](analyze-data_files/figure-gfm/station%20popularity%20quantiles-1.png)<!-- -->

## Order all stations by popularity, plot the proportion of members using it

We see a clear pattern. As staions get busier, the proportion of casuals
rises. There is still a large amount of variability however.
![](analyze-data_files/figure-gfm/station%20popularity%20scatter%20and%20fit-1.png)<!-- -->

## Plot stations on the map

ideas:

-   Size of dot varies with station popularity
-   the colour varies with the proportion of users (by trip start) who
    are casuals.
    -   First step: mostly\_casual to colour the stations with binary
        scheme

![](analyze-data_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->![](analyze-data_files/figure-gfm/unnamed-chunk-2-2.png)<!-- -->![](analyze-data_files/figure-gfm/unnamed-chunk-2-3.png)<!-- -->![](analyze-data_files/figure-gfm/unnamed-chunk-2-4.png)<!-- -->![](analyze-data_files/figure-gfm/unnamed-chunk-2-5.png)<!-- -->![](analyze-data_files/figure-gfm/unnamed-chunk-2-6.png)<!-- -->![](analyze-data_files/figure-gfm/unnamed-chunk-2-7.png)<!-- -->![](analyze-data_files/figure-gfm/unnamed-chunk-2-8.png)<!-- -->![](analyze-data_files/figure-gfm/unnamed-chunk-2-9.png)<!-- -->![](analyze-data_files/figure-gfm/unnamed-chunk-2-10.png)<!-- -->![](analyze-data_files/figure-gfm/unnamed-chunk-2-11.png)<!-- -->![](analyze-data_files/figure-gfm/unnamed-chunk-2-12.png)<!-- -->![](analyze-data_files/figure-gfm/unnamed-chunk-2-13.png)<!-- -->![](analyze-data_files/figure-gfm/unnamed-chunk-2-14.png)<!-- -->

## TODO

-   Calculate mean straight-line **distance** of trips started and ended
    in each sector.
-   visualize timelapse behaviour
    -   trips starting from a sector, with scrubbable hour (tableau!)
        -   or as an animation
    -   and similarly, ending at a sector..
    -   Can you draw a map of LINES connecting start and end points for
        trips..?
        -   or similarly, for e.g. 4-4:59pm, a cloud of dots in two
            colours, trips started and trips ended, at every location.
-   a map of all stations, coloured by the proportion of casual users
    who start/end trips at this station.
    -   size the dots based on the popularity of the station (\# of
        trips starting/ending there)
