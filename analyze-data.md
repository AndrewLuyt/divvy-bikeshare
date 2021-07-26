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

    ## Warning: `fun.y` is deprecated. Use `fun` instead.

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
    ## 1 casual         35.2   20.6     11.3   0.25
    ## 2 casual         35.2   20.6     38.7   0.75
    ## 3 casual         35.2   20.6    108.    0.95
    ## 4 member         15.1   11.3      6.45  0.25
    ## 5 member         15.1   11.3     19.6   0.75
    ## 6 member         15.1   11.3     37.6   0.95

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
  geom_histogram(bins = 40, alpha = 0.7) +
  scale_y_continuous(labels = scales::comma) +
  labs(title = "Ride times",
       x = "Minutes",
       y = "Count of rides")
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
  geom_col(position = position_dodge(width = 0.4), alpha = 0.8) + 
  labs(title = "Average Ride lengths over the week",
       x = NULL, y = "Average minutes")
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

## Trips volume trend over the last year

-   There is an enormous seasonal variation, from a low of 15 rides to a
    high of almost 20,000 in one day.
-   The trend in 2021 is for higher volume than 2020
-   Casual membership seems to be rising more sharply in 2021
    ![](analyze-data_files/figure-gfm/daily%20trips-1.png)<!-- -->

## Do weekends matter?

Yes, but only for casuals and not in winter.

![](analyze-data_files/figure-gfm/do%20weekends%20matter-1.png)<!-- -->

## Do they differ in *what hour* rides are taken?

Not much. There seems to be a slight tendency for casuals to start their
rides later. The tendency is similar for ending times (not shown.)

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

We see a clear pattern. As stations get busier, the proportion of
casuals rises. There is still a large amount of variability however.

![](analyze-data_files/figure-gfm/station%20popularity%20scatter%20and%20fit-1.png)<!-- -->

## Plot stations on the map

ideas:

-   Size of dot varies with station popularity
-   the colour varies with the proportion of users (by trip start) who
    are casuals.
    -   First step: mostly\_casual to colour the stations with binary
        scheme

<!-- -->

    ## Warning: Ignoring unknown parameters: bins

![](analyze-data_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

    ## Warning: Ignoring unknown parameters: bins

![](analyze-data_files/figure-gfm/unnamed-chunk-2-2.png)<!-- -->![](analyze-data_files/figure-gfm/unnamed-chunk-2-3.png)<!-- -->![](analyze-data_files/figure-gfm/unnamed-chunk-2-4.png)<!-- -->![](analyze-data_files/figure-gfm/unnamed-chunk-2-5.png)<!-- -->![](analyze-data_files/figure-gfm/unnamed-chunk-2-6.png)<!-- -->![](analyze-data_files/figure-gfm/unnamed-chunk-2-7.png)<!-- -->![](analyze-data_files/figure-gfm/unnamed-chunk-2-8.png)<!-- -->![](analyze-data_files/figure-gfm/unnamed-chunk-2-9.png)<!-- -->![](analyze-data_files/figure-gfm/unnamed-chunk-2-10.png)<!-- -->![](analyze-data_files/figure-gfm/unnamed-chunk-2-11.png)<!-- -->

    ## Warning: Ignoring unknown parameters: bins

![](analyze-data_files/figure-gfm/unnamed-chunk-2-12.png)<!-- -->![](analyze-data_files/figure-gfm/unnamed-chunk-2-13.png)<!-- -->![](analyze-data_files/figure-gfm/unnamed-chunk-2-14.png)<!-- -->![](analyze-data_files/figure-gfm/unnamed-chunk-2-15.png)<!-- -->![](analyze-data_files/figure-gfm/unnamed-chunk-2-16.png)<!-- -->![](analyze-data_files/figure-gfm/unnamed-chunk-2-17.png)<!-- -->![](analyze-data_files/figure-gfm/unnamed-chunk-2-18.png)<!-- -->

## Average rider motion by hour

Here we’ll examine the overall traffic flow: as the hours go by, do
riders tend to ride in a particular direction? (yes) We expected this
because the morning and evening commute times are not of equal
magnitude. Overall it seems like there is a daily tendency for riders
(and bicycles) to move northwest.

### TODO: make interpretable with distance

This has connections with how Divvy may have to shuttle bikes around at
night to ensure the busy stations have bikes

-   the average rider (and bike!) moves Xm west by northwest
-   overall, traffic moves Xm west by northwest

``` r
angle_from_x_axis <- function(y,x) {
  angle <- atan(y/x)
  if (x<0) {
    angle <- angle + pi
  } else if (x>=0 & y<0) {
    angle <- angle + 2*pi
  } 
  angle * 180 / pi
}
overall_vec <- df %>% 
  summarize(x = sum(trip_delta_x), 
            y = sum(trip_delta_y),
            mean_x = mean(trip_delta_x),
            mean_y = mean(trip_delta_y),
            magnitude = sqrt(x^2 + y^2),
            angle = angle_from_x_axis(y,x),
            atan = atan(y/x))
monthly_vec <- df %>% 
  group_by(month = lubridate::month(started_at),
           hour = lubridate::hour(started_at)) %>% 
  summarize(x = sum(trip_delta_x), 
            y = sum(trip_delta_y),
            mean_x = mean(trip_delta_x),
            mean_y = mean(trip_delta_y),
            magnitude = sqrt(x^2 + y^2),
            angle = angle_from_x_axis(y,x),
            atan = atan(y/x))
```

    ## `summarise()` has grouped output by 'month'. You can override using the `.groups` argument.

``` r
dow_vec <- df %>% 
  group_by(weekday,
           hour = lubridate::hour(started_at)) %>% 
  summarize(x = sum(trip_delta_x), 
            y = sum(trip_delta_y),
            mean_x = mean(trip_delta_x),
            mean_y = mean(trip_delta_y),
            magnitude = sqrt(x^2 + y^2),
            angle = angle_from_x_axis(y,x),
            atan = atan(y/x))
```

    ## `summarise()` has grouped output by 'weekday'. You can override using the `.groups` argument.

``` r
vecs <- df %>% 
  group_by(hour = lubridate::hour(started_at)) %>% 
  summarize(x = sum(trip_delta_x), 
            y = sum(trip_delta_y),
            mean_x = mean(trip_delta_x),
            mean_y = mean(trip_delta_y),
            magnitude = sqrt(x^2 + y^2),
            angle = angle_from_x_axis(y,x)) 
```

## Overall traffic flow by hour

We compute an estimate of the overall flow of traffic (direction and
distance) for every trip taken each hour. (\*Technical note: This is
done by adding the vectors of every trip up to compute the ‘overall
trip’ during that hour)

``` r
ggplot(vecs, aes(x=0, y=0, xend=x, yend=y)) +
  geom_hline(yintercept = 0, color = 'gray80') +
  geom_vline(xintercept = 0, color = 'gray80') +
  facet_wrap(~hour, ncol = 6) +
  theme_gray() +
  theme(axis.text = element_blank(),
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        panel.background = element_blank()) +
  geom_segment(arrow = arrow(length = unit(0.1, "npc")), color='blue') +
  coord_fixed(ratio = 0.7) +
  labs(title = "Overall traffic direction and strength, by hour")
```

![](analyze-data_files/figure-gfm/traffic%20flow%20by%20hour-1.png)<!-- -->

## Traffic flow by hour and weekday

``` r
ggplot(dow_vec, aes(x=0, y=0, xend=x, yend=y, color=as_factor(weekday))) +
  geom_hline(yintercept = 0, color = 'gray80') +
  geom_vline(xintercept = 0, color = 'gray80') +
  theme_gray() +
  theme(axis.text = element_blank(),
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        panel.background = element_blank()) +
  geom_segment(arrow = arrow(length = unit(0.1, "npc"))) +
  facet_wrap(~hour, ncol = 6) +
  labs(title = "Overall traffic direction and strength, by hour",
       subtitle = "Colours denote weekday",
       caption = "Note the variation on different days between 4-6pm") +
  scale_color_viridis(discrete = TRUE, option="turbo")
```

![](analyze-data_files/figure-gfm/Traffic%20flow%20by%20hour%20and%20weekday-1.png)<!-- -->

## Examining the evening rush hour traffic

The rush hour traffic flow has two main patterns.

-   On **Monday to Thursday** rush hour traffic trends strongly to the
    northwest.
-   On **weekends** the rush hour traffic trends west to southwest

``` r
dow_vec %>%
  filter(between(hour, 16, 18)) %>%
  ggplot(aes(
    x = 0,
    y = 0,
    xend = x,
    yend = y,
    color = as_factor(weekday)
  )) +
  geom_hline(yintercept = 0, color = 'gray80') +
  geom_vline(xintercept = 0, color = 'gray80') +
  theme_gray() +
  theme(
    axis.text = element_blank(),
    axis.title = element_blank(),
    axis.ticks = element_blank(),
    panel.background = element_blank()
  ) +
  geom_segment(arrow = arrow(length = unit(0.1, "npc"))) +
  facet_wrap( ~ hour) +
  labs(title = "Rush hour traffic direction and strength",
       subtitle = "Evening rush hour: 4 - 6pm",
       caption = "Weekends have their own distinct pattern") +
  scale_color_viridis(discrete = TRUE, option = "turbo")
```

![](analyze-data_files/figure-gfm/Traffic%20flow%20by%20hour%20and%20weekday%20limited%20to%20rush%20hour-1.png)<!-- -->

## Hourly traffic flow, with monthly patterns

``` r
ggplot(monthly_vec, aes(x=0, y=0, xend=x, yend=y, color=as_factor(month))) +
  geom_hline(yintercept = 0, color = 'gray80') +
  geom_vline(xintercept = 0, color = 'gray80') +
  theme_gray() +
  theme(axis.text = element_blank(),
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        panel.background = element_blank()) +
  geom_segment(arrow = arrow(length = unit(0.1, "npc"))) +
  facet_wrap(~hour) +
  labs(title = "Overall traffic direction and strength, by hour",
       subtitle = "Colours denote months",
       caption = "Little variation by month: the main effect is the hour")
```

![](analyze-data_files/figure-gfm/traffic%20flow%20by%20hour%20and%20month-1.png)<!-- -->

## TODO

-   ADD FEATURE: Calculate mean straight-line **distance** of trips
    started and ended in each sector.
    -   is it better to do straight line, or horizontal + vert distances
        (“manhattan distance”) and add them?
-   Bike Motion maps: calculate total “bike miles” moved in a certain
    direction to make the abstract arrows more concrete.
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
-   find the fastest rides:
    -   use trip time and straight-line distance
-   is there a ‘mean travel direction’?
    -   like, morning tends to go north, 5pm it switches?
    -   calculate by the hour and draw an arrow with direction and
        strength?
        -   seems like vectors would work… and we have all the
            components!
            -   start\_lng, start\_lat, end\_lng, end\_lat
            -   this is a vector with angle arctan(delta\_y/delta\_x)
                (Quadrant!) and magnitude sqrt(delta\_x^2 + delta\_y^2)
            -   BETTER: just add up all the delta\_x and delta\_y
                componenets of every trip in that hour and you end up
                with a vector pointing to the overall (sum of) trip
                direction and distance.
