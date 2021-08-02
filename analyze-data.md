Analyze: How do Casual Users and Annual Subscribers Differ?
================
Andrew Luyt
2021-07-27

## Quick descriptive statistics

    ## `summarise()` has grouped output by 'weekday'. You can override using the `.groups` argument.

    ## # A tibble: 14 × 3
    ## # Groups:   weekday [7]
    ##    weekday   member_casual n_rides
    ##    <fct>     <fct>           <int>
    ##  1 Monday    casual         210438
    ##  2 Monday    member         344378
    ##  3 Tuesday   casual         205153
    ##  4 Tuesday   member         372075
    ##  5 Wednesday casual         214006
    ##  6 Wednesday member         394318
    ##  7 Thursday  casual         215632
    ##  8 Thursday  member         375376
    ##  9 Friday    casual         280867
    ## 10 Friday    member         385044
    ## 11 Saturday  casual         458682
    ## 12 Saturday  member         399781
    ## 13 Sunday    casual         381370
    ## 14 Sunday    member         341135

    ## # A tibble: 2 × 6
    ##   member_casual trip_minutes_min trip_minutes_max trip_minutes_mean
    ##   <fct>                    <dbl>            <dbl>             <dbl>
    ## 1 casual                    1.02            1440.              35.7
    ## 2 member                    1.02            1440.              15.4
    ## # … with 2 more variables: trip_minutes_median <dbl>, trip_minutes_sd <dbl>

## Who rides most often?

Members take the majority of rides.

![](analyze-data_files/figure-gfm/who%20rides%20most%20often-1.png)<!-- -->

On weekends however, casual use approximately doubles and exceeds member
use.

![](analyze-data_files/figure-gfm/who%20rides%20most%20often%202-1.png)<!-- -->

Breaking down the number of rides by month, we can see that while the
season is important for all riders, casual users are much less willing
to ride in the winter months. December to February, the system sees very
little casual use.

![](analyze-data_files/figure-gfm/who%20rides%20most%20often%203-1.png)<!-- -->

## How do they differ on type of bike ridden?

Casuals are more likely to choose a docked bike and less likely to
choose a classic bike.

**This is confusing**. The divvy website lists two types of bikes,
**classic** and **electric bike.** What is a **docked bike**?

![](analyze-data_files/figure-gfm/differ%20on%20bike%20type-1.png)<!-- -->

## How do trip distances vary?

This is a bit surprising - the average trip is about the same distance
for both classes of users. For this analysis we’ve removed trips that
start and end at the same station since we have no indication how long
the trip was.

``` r
df %>% 
  filter(is_round_trip == 'a to b') %>% 
  group_by(member_casual) %>% 
  summarise(mean_trip_distance = mean(trip_distance_m) / 1000) %>% 
  ggplot(aes(member_casual, mean_trip_distance, fill = member_casual)) +
  geom_col() +
  labs(title = "Average trip distance (Km)",
       subtitle = "Straight-line distance, 'as the crow flies'",
       caption = "Source: Divvy public data",
       x = NULL, y = "Kilometers") +
  geom_text(aes(label = round(mean_trip_distance, digits = 1)), 
            vjust = 2.1,
            size = 5) +
  theme(legend.position = "none",
        axis.text.x = element_text(size = x.txt.size))
```

![](analyze-data_files/figure-gfm/avg%20trip%20distance-1.png)<!-- -->
Not much difference by weekday.

``` r
df %>% 
  filter(is_round_trip == 'a to b') %>% 
  group_by(member_casual, weekday) %>% 
  summarise(mean_trip_distance = mean(trip_distance_m) / 1000) %>% 
  ggplot(aes(weekday, mean_trip_distance, fill = member_casual)) +
  geom_col(position = "dodge") +
  labs(title = "Average trip distance (Km)",
       subtitle = "Straight-line distance, 'as the crow flies'",
       caption = "Source: Divvy public data",
       x = NULL, y = "Kilometers") 
```

    ## `summarise()` has grouped output by 'member_casual'. You can override using the `.groups` argument.

![](analyze-data_files/figure-gfm/avg%20trip%20distance%202-1.png)<!-- -->

``` r
df %>% 
  filter(is_round_trip == 'a to b') %>% 
  group_by(member_casual, month) %>% 
  summarise(mean_trip_distance = mean(trip_distance_m) / 1000) %>% 
  ggplot(aes(month, mean_trip_distance, fill = member_casual)) +
  geom_col(position = "dodge") +
  labs(title = "Average trip distance (Km)",
       subtitle = "Straight-line distance, 'as the crow flies'",
       caption = "Source: Divvy public data",
       x = NULL, y = "Kilometers") 
```

    ## `summarise()` has grouped output by 'member_casual'. You can override using the `.groups` argument.

![](analyze-data_files/figure-gfm/avg%20trip%20distance%203-1.png)<!-- -->

For this analysis we’ve removed trips that start and end at the same
station since they have an apparent distance of zero. We believe it’s
likely that pleasure cruises make up a large portion of these rides.
We’ll examine this idea in a section further below.

``` r
df %>% 
  filter(is_round_trip == 'round trip') %>% 
  group_by(member_casual) %>% 
  summarise("Possible pleasure cruises" = n(),
            "Avg trip minutes" = round(mean(trip_minutes), 0)) %>% 
  rename("Rider Type" = member_casual)
```

    ## # A tibble: 2 × 3
    ##   `Rider Type` `Possible pleasure cruises` `Avg trip minutes`
    ##   <fct>                              <int>              <dbl>
    ## 1 casual                            315156                 61
    ## 2 member                            110279                 26

## How much *time* is spent on an average ride?

Casuals ride more than twice as long as members, on average. There isn’t
much variation in ride duration over the week other than a slight
increase over the weekend.

![](analyze-data_files/figure-gfm/mean%20ride%20duration-1.png)<!-- -->

Seasonally, casual rides have a large amount of variation. The small
number of winter trips taken tend to be short - half the length of rides
at the peak of summer.

    ## `summarise()` has grouped output by 'member_casual'. You can override using the `.groups` argument.

![](analyze-data_files/figure-gfm/mean%20ride%20duration%202-1.png)<!-- -->

## Pleasure cruises?

Earlier we noted the possibility of about 10% of rides being round-trip
pleasure cruises, starting and ending at the same station, likely near
the rider’s home. The two graphs below provide evidence for this idea.

If our hypothesis is correct, the percentage of this type of ride should
shrink in winter and grow in summer and be mostly confined to casual
users. This first graph shows exactly this pattern.

``` r
df %>% 
  group_by(month, member_casual, is_round_trip) %>% 
  summarise(n = n()) %>% 
  mutate(percent_of_rides = n / sum(n) * 100) %>% 
  filter(is_round_trip == "round trip") %>%
  ggplot(aes(x = month, y = percent_of_rides, fill = member_casual)) +
  geom_col() +
  facet_wrap(~member_casual, ncol = 2) +
  labs(title = "Pleasure cruises over the seasons",
       subtitle = "Percentage of all trips starting and ending at the same station",
       caption = "Source: Divvy public data",
       x = NULL, y = "Percent of all trips") +
  theme(legend.position = "none")
```

    ## `summarise()` has grouped output by 'month', 'member_casual'. You can override using the `.groups` argument.

![](analyze-data_files/figure-gfm/pleasure%20cruises-1.png)<!-- -->

Second, if our idea is correct we should also see trip duration becoming
longer in winter and shorter in summer. This should strongly affect
casual users but have little effect on members, who have a 45-minute
time limit. This graph demonstrates this pattern as well.

``` r
df %>% 
  group_by(month, member_casual, is_round_trip) %>% 
  summarise(avg_ride_minutes = mean(trip_minutes)) %>% 
  filter(is_round_trip == "round trip") %>%
  ggplot(aes(x = month, y = avg_ride_minutes, fill = member_casual)) +
  geom_col() +
  facet_wrap(~member_casual, ncol = 2) +
  labs(title = "Duration of pleasure cruises over the seasons",
       caption = "Source: Divvy public data",
       x = NULL, y = "Minutes") +
  theme(legend.position = "none")
```

    ## `summarise()` has grouped output by 'month', 'member_casual'. You can override using the `.groups` argument.

![](analyze-data_files/figure-gfm/pleasure%20cruises%202-1.png)<!-- -->

## Ride speed

We’ve seen that casuals and members ride about the same distances, but
members spend less time on the bikes. The graph below shows that members
are about 30% faster on average.

We’ve removed trips that start and end at the same station, since their
recorded trip distance is 0.

``` r
df %>% 
  filter(is_round_trip == 'a to b') %>%
  mutate(kph = (trip_distance_m / 1000) / (trip_minutes / 60)) %>% 
  group_by(member_casual) %>% 
  summarise(mean_kph = mean(kph)) %>% 
  ggplot(aes(member_casual, mean_kph, fill = member_casual)) +
  geom_col() +
  labs(title = "Mean trip speed (Kph)",
       subtitle = "Members ride about 30% faster",
       x = NULL, y = "Kilometers per hour",
       caption = "Source: Divvy public data") +
  geom_text(aes(label = round(mean_kph, digits = 1)), 
            vjust = 2.1,
            size = 5) +
  theme(legend.position = "none",
        axis.text.x = element_text(size = x.txt.size))
```

![](analyze-data_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

## Members ride more often, casuals ride longer: who rides the most total minutes?

Casuals spend more time using the bicycles.

    ## Warning: `fun.y` is deprecated. Use `fun` instead.

![](analyze-data_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

## What is the distribution of ride durations?

A quick examination shows a few notable items:

-   Casuals have a higher mean and median trip time. i.e. they tend to
    take longer trips
-   The difference is amplified in the particularly long trips
    -   compare the 95th percentile trip time. 5% of casuals take trips
        longer than 1:50!

**NB: Divvy’s policies (starting in 2018) limit members to 45 minutes on
the bike at one time (up from 30 minutes.) This artificial limit is
almost certainly the cause of these observations. Anyone, members
included, who wish a long cruise have to purchase a day pass.**

    ## # A tibble: 6 × 5
    ## # Groups:   member_casual [2]
    ##   member_casual  mean median quantiles     q
    ##   <fct>         <dbl>  <dbl>     <dbl> <dbl>
    ## 1 casual         35.7   20.9     11.6   0.25
    ## 2 casual         35.7   20.9     39.1   0.75
    ## 3 casual         35.7   20.9    108.    0.95
    ## 4 member         15.4   11.5      6.68  0.25
    ## 5 member         15.4   11.5     19.8   0.75
    ## 6 member         15.4   11.5     37.8   0.95

From above we see there is a **wide** range of trip lengths, with most
being short and a small number being over an hour. We will trim off the
longest 5% of trips so we can see the typical pattern of ride length.

**One observation is that casual riders make up almost all trips longer
than 40 minutes.** Online research shows that in 2018, Divvy extended
the maximum ride length for members to 45 minutes (up from 30). Longer
rides incur a fee.

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
  labs(title = "Ride durations",
       x = "Minutes", y = "Count of rides",
       caption = "Source: Divvy public data") +
  annotate(geom = "text", x = 70, y = 200000, label = "Members pay a surcharge if\n riding more than 45 minutes") +
  annotate(geom = "curve", x = 50, y = 160000, xend = 39, yend = 16000, 
           curvature = 0.1, arrow = arrow(length = unit(.02, "npc"))) +
  theme(legend.title = element_blank())
```

![](analyze-data_files/figure-gfm/trip%20duration%20histogram-1.png)<!-- -->

## Ride duration, by weekday

We see an unsurprising distribution of trip durations over the week: a
slight increase over the weekend, with casual riders having showing a
larger difference.

``` r
df %>% 
  group_by(weekday, member_casual) %>% 
  summarise(mean_ride_length = mean(trip_minutes)) %>% 
  ggplot(aes(weekday, mean_ride_length, fill=member_casual)) +
  geom_col(position = position_dodge(width = 0.4), alpha = 0.8) + 
  labs(title = "Average Ride lengths over the week",
       x = NULL, y = "Average minutes",
       caption = "Source: Divvy public data") +
  theme(legend.title = element_blank())
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

## Which stations do casuals use?

We’ll look at this question in two parts. **First** we’ll sort the
stations by popularity (number of trips that start there) and colour the
points by the proportion of the type of user. **Second** we will plot
these stations on a map of Chicago.

**First**: station popularity. We can extract three main insights from
the graph below:

-   Overall, most stations are used primarily by members
-   The least popular stations are dominated by casual use
-   A few of the city’s most popular stations are over 75% casual use
    -   These might make excellent targets for any pilot programs
        targeting casual users

``` r
df %>% 
  group_by(start_station_id, member_casual) %>% 
  summarise(n = n()) %>% 
  mutate(total_trips = sum(n),
         p_casual = n / total_trips,
         mostly_casual = factor(p_casual > .5,
                                levels = c(TRUE, FALSE),
                                labels = c("Mostly casual", "Mostly members"))) %>% 
  filter(member_casual == 'casual') %>% 
  select(start_station_id, p_casual, total_trips, mostly_casual) %>% 
  arrange(total_trips) %>% 
  filter(total_trips > 100) %>% # remove nearly unused stations (some might be obsolete?)
  ggplot(aes(total_trips, p_casual)) +
  geom_point(aes(color = mostly_casual)) +
  geom_smooth() +
  scale_x_log10(breaks = NULL, name = "(-)     Station Popularity     (+)") +
  scale_y_continuous(labels = scales::percent) +
  annotate("text", x = 600, y = 0.95, 
           label = "Least popular") +
  annotate("text", x = 8000, y = 0.95, 
           label = "Most popular") +
  annotate("curve", x = 600, y = 0.9, xend = 140, yend=.8, curvature = -0.1,
           arrow = arrow(length = unit(0.04, "npc"))) +
  annotate("curve", x = 8000, y = 0.9, xend = 25000, yend=.75, curvature = 0.1,
           arrow = arrow(length = unit(0.04, "npc"))) +
  labs(title = "Station popularity and typical users",
       subtitle = "The least and most popular stations are used casually",
       y = "Casual use",
       caption = "Source: Divvy public data") +
  theme(legend.title = element_blank())
```

![](analyze-data_files/figure-gfm/station%20popularity%20and%20use-1.png)<!-- -->

## Plot stations on the map

ideas:

-   Size of dot varies with station popularity
-   the colour varies with the proportion of users (by trip start) who
    are casuals.
    -   First step: mostly\_casual to colour the stations with binary
        scheme

<!-- -->

    ## Warning: Ignoring unknown parameters: bins

![](analyze-data_files/figure-gfm/mapping%20the%20dataset-1.png)<!-- -->

    ## Warning: Ignoring unknown parameters: bins

![](analyze-data_files/figure-gfm/mapping%20the%20dataset%202-1.png)<!-- -->

![](analyze-data_files/figure-gfm/mapping%20the%20dataset%203-1.png)<!-- -->
![](analyze-data_files/figure-gfm/mapping%20the%20dataset%204-1.png)<!-- -->
![](analyze-data_files/figure-gfm/mapping%20the%20dataset%205-1.png)<!-- -->

![](analyze-data_files/figure-gfm/mapping%20the%20dataset%206-1.png)<!-- -->![](analyze-data_files/figure-gfm/mapping%20the%20dataset%206-2.png)<!-- -->
![](analyze-data_files/figure-gfm/mapping%20the%20dataset%207-1.png)<!-- -->![](analyze-data_files/figure-gfm/mapping%20the%20dataset%207-2.png)<!-- -->
![](analyze-data_files/figure-gfm/mapping%20the%20dataset%208-1.png)<!-- -->
![](analyze-data_files/figure-gfm/mapping%20the%20dataset%2012-1.png)<!-- -->

![](analyze-data_files/figure-gfm/mapping%20the%20dataset%2013-1.png)<!-- -->
![](analyze-data_files/figure-gfm/mapping%20the%20dataset%209-1.png)<!-- -->

    ## Warning: Ignoring unknown parameters: bins

![](analyze-data_files/figure-gfm/mapping%20the%20dataset%2010-1.png)<!-- -->
![](analyze-data_files/figure-gfm/mapping%20the%20dataset%2011-1.png)<!-- -->![](analyze-data_files/figure-gfm/mapping%20the%20dataset%2011-2.png)<!-- -->

![](analyze-data_files/figure-gfm/mapping%20the%20dataset%2014-1.png)<!-- -->![](analyze-data_files/figure-gfm/mapping%20the%20dataset%2014-2.png)<!-- -->

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](analyze-data_files/figure-gfm/mapping%20the%20dataset%2015-1.png)<!-- -->

### Zoom in

    ## Warning: Removed 18 rows containing missing values (geom_point).

![](analyze-data_files/figure-gfm/mapping%20the%20dataset%2016-1.png)<!-- -->

### Which stations are these?

``` r
stations_users %>% 
  slice_max(n_trips_casual, n = 10) %>% 
  arrange(desc(n_trips_casual)) %>% 
  select(start_station_name, n_trips_casual, n_trips_station, p_trips_casual, station_lng, station_lat)
```

    ## Adding missing grouping variables: `start_station_id`

    ## # A tibble: 26 × 7
    ## # Groups:   start_station_id [26]
    ##    start_station_id start_station_name        n_trips_casual n_trips_station
    ##    <fct>            <fct>                              <int>           <int>
    ##  1 35               Streeter Dr & Grand Ave            47106           60903
    ##  2 76               Lake Shore Dr & Monroe St          32854           45142
    ##  3 90               Millennium Park                    29735           36742
    ##  4 3                Shedd Aquarium                     16636           22112
    ##  5 2                Buckingham Fountain                15632           18812
    ##  6 623              Michigan Ave & 8th St              14120           19543
    ##  7 6                Dusable Harbor                     13300           18977
    ##  8 13029            Field Museum                        4239            5648
    ##  9 406              Lake Park Ave & 35th St             3602            5099
    ## 10 200              MLK Jr Dr & 47th St                 1028            1028
    ## # … with 16 more rows, and 3 more variables: p_trips_casual <dbl>,
    ## #   station_lng <dbl>, station_lat <dbl>

## Average rider motion by hour

Here we’ll examine the overall traffic flow: as the hours go by, do
riders tend to ride in a particular direction? **Yes!** Overall it seems
like there is a daily tendency for riders (and bicycles) to move
northwest.

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
# trend over the entire dataset
overall_vec <- df %>% 
  summarize(x = sum(trip_delta_x), 
            y = sum(trip_delta_y),
            mean_x = mean(trip_delta_x),
            mean_y = mean(trip_delta_y),
            magnitude = sqrt(x^2 + y^2),
            angle = angle_from_x_axis(y,x),
            atan = atan(y/x))
# monthly trends
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
# day-of-the-week plus hour trends
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
# hourly trends
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
distance) for every trip taken each hour. We see the strong signals for
the morning and evening commutes, with the evening being larger. This
probably leads to bicycles being distributed over the city unequally,
with a bias towards the northwest.

*Technical note: This is done by adding the vectors of every trip up to
compute the ‘overall trip’ during that hour*

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

Between 4pm and 6pm, notice the distinct difference in traffic flow on
the weekend.

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
  labs(title = "Overall traffic direction and strength, by hour and weekday",
       caption = "Note the variation on different days between 4-6pm") +
  scale_color_viridis(discrete = TRUE, option="turbo")
```

![](analyze-data_files/figure-gfm/Traffic%20flow%20by%20hour%20and%20weekday-1.png)<!-- -->

## Examining the evening rush hour traffic

The rush hour traffic flow has two main patterns.

-   On **Monday to Friday**, evening rush hour traffic trends strongly
    to the northwest.
-   On **weekends** it trends west to southwest

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
  geom_segment(size = 1, arrow = arrow(length = unit(0.1, "npc"))) +
  facet_wrap( ~ hour) +
  labs(title = "Rush hour traffic direction and strength",
       subtitle = "Evening rush hour: 4 - 6pm",
       caption = "Weekends have their own distinct pattern") +
  scale_color_viridis(discrete = TRUE, option = "turbo")
```

![](analyze-data_files/figure-gfm/Traffic%20flow%20by%20hour%20and%20weekday%20limited%20to%20rush%20hour-1.png)<!-- -->

## Hourly traffic flow, with monthly patterns

Not useful. Traffic flow doesn’t notably vary by month, other than in
magnitude.

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
