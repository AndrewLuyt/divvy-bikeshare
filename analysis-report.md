Analysis: How Casual Users and Members Differ
================
Andrew Luyt,
Last updated: Tuesday August 10, 2021

-   [Summary of Findings](#summary-of-findings)
-   [Who rides most often?](#who-rides-most-often)
-   [How do trip distances vary?](#how-do-trip-distances-vary)
    -   [A special case: pleasure
        cruises?](#a-special-case-pleasure-cruises)
-   [How much *time* is spent on an average
    ride?](#how-much-time-is-spent-on-an-average-ride)
-   [Pleasure cruises?](#pleasure-cruises)
-   [Speed, Time in the Saddle,
    Comfort](#speed-time-in-the-saddle-comfort)
-   [Which stations do casual users
    choose?](#which-stations-do-casual-users-choose)
-   [Traffic Flow](#traffic-flow)
-   [All traffic flow](#all-traffic-flow)
-   [Traffic flow patterns: showing all bike
    stations](#traffic-flow-patterns-showing-all-bike-stations)

## Summary of Findings

Unless otherwise stated, these findings all refer to totals or averages
over the past year of data.

Traffic patterns

-todo

Comparing casual users with members we find a few notable differences.

-todo

## Who rides most often?

Overall, members take the majority of rides.

![](analysis-report_files/figure-gfm/who%20rides%20most%20often-1.png)<!-- -->

Casual use doubles on the weekend, even exceeding member use.

![](analysis-report_files/figure-gfm/who%20rides%20most%20often%202-1.png)<!-- -->

Breaking down the number of rides by month, we can see that while the
season is important for all riders, casual users are much less willing
to ride in the winter months. From December to February, the system sees
very little casual use.

![](analysis-report_files/figure-gfm/who%20rides%20most%20often%203-1.png)<!-- -->

**Summarizing the previous three graphs**, casual use of the system is
much more variable than for members. It is maximized during summer
weekends and minimized during winter weekdays.

## How do trip distances vary?

This is a bit surprising. For trips that start and end at different
stations, the average trip is about the same distance for both classes
of users, about two and a half kilometers.

![](analysis-report_files/figure-gfm/avg%20trip%20distance-1.png)<!-- -->

Seasonally, average trip distance is smallest during the winter and
largest in summer, but only by about half a kilometer. Trip distance
does not change much over the course of the week.

### A special case: pleasure cruises?

For the above analysis we removed trips that start and end at the same
station since, lacking GPS data to track the ride, they have an apparent
distance of zero. We believe it’s likely that pleasure cruises make up a
large portion of these rides. These rides average an hour long for
casual users. In the next section on ride duration we’ll see the average
of all casual trips is just over 30 minutes, an interesting difference.

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:left;">
Rider Type
</th>
<th style="text-align:right;">
Possible pleasure cruises
</th>
<th style="text-align:right;">
Avg trip minutes
</th>
<th style="text-align:left;">
Percent of trips
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
casual
</td>
<td style="text-align:right;">
287355
</td>
<td style="text-align:right;">
61
</td>
<td style="text-align:left;">
15.5%
</td>
</tr>
<tr>
<td style="text-align:left;">
member
</td>
<td style="text-align:right;">
96357
</td>
<td style="text-align:right;">
26
</td>
<td style="text-align:left;">
3.9%
</td>
</tr>
</tbody>
</table>

These round-trips represent about 10% of all bike use and about **15% of
all casual use.** We also see above that casual users outnumber members
3 to 1 in this interesting subset of rides. We’ll return to these trips
in a later section, after we have explored ride duration.

## How much *time* is spent on an average ride?

Casuals ride more than twice as long as members, on average.

![](analysis-report_files/figure-gfm/mean%20ride%20duration-1.png)<!-- -->

Seasonally, casual rides have a large amount of variation. The small
number of winter trips taken tend to be short - half the length of rides
at the peak of summer.

![](analysis-report_files/figure-gfm/mean%20ride%20duration%202-1.png)<!-- -->

## Pleasure cruises?

Earlier we noted the possibility that 10% of all rides (and 15% of
casual rides) were round-trip pleasure cruises starting and ending at
the same station, likely near the rider’s home. The two graphs below
provide more evidence for this idea.

If our hypothesis is correct, the percentage of this type of ride should
shrink in winter and grow in summer and be mostly confined to casual
users. This first graph shows exactly this pattern.

![](analysis-report_files/figure-gfm/pleasure%20cruises-1.png)<!-- -->

Second, if our idea is correct we should also see trip duration becoming
longer in summer and shorter in winter. This should strongly affect
casual users but have little effect on members, who have a 45-minute
time limit. This graph demonstrates this pattern as well.

![](analysis-report_files/figure-gfm/pleasure%20cruises%202-1.png)<!-- -->

Going further to learn how these rides differ in destination, length, or
speed would require some sort of GPS tracking data from the bikes, which
is outside the scope of this dataset. For now we note the strong
possibility that **about ten percent of all trips are taken for
enjoyment rather than travel, and that casual users dominate this market
segment.**

## Speed, Time in the Saddle, Comfort

We’ve seen that casuals and members ride about the same distances, but
members spend less time on the bikes. The graph below shows that members
are about 30% faster on average.

![](analysis-report_files/figure-gfm/mean%20trip%20speed-1.png)<!-- -->

We now know that members ride more often and casuals ride longer - so
who rides the most total minutes? Casual users do!

![](analysis-report_files/figure-gfm/saddle%20time-1.png)<!-- -->

Since casual users spend so much more time in the saddle, it might be a
worthwhile experiment to trial a set of more comfortable, relaxed-ride
bikes aimed at users who want to cruise in comfort. In the maps section
below we identify regions of the city where casual users dominate the
ridership.

## Which stations do casual users choose?

Here we map all the bike stations in the system and colour them by the
percentage of casual rides that start there.

![](analysis-report_files/figure-gfm/casual%20usage%20map-1.png)<!-- -->

We can clearly see a division between casual use and member use. Next
let’s highlight hot spots. We’ll plot only stations with over 70% casual
use and we’ll also give busier stations larger dots.

![](analysis-report_files/figure-gfm/casual%20usage%20map%20over%2070-1.png)<!-- -->

Finally let’s zoom in on the notable hot spot near Navy Pier. Of all
stations with over 70% casual use, these are the busiest.

![](analysis-report_files/figure-gfm/mapping%20the%20dataset%2016-1.png)<!-- -->

These stations are all on and around the waterfront between Soldier
Field and Navy Pier. They represent what is easily the most popular
casual use desination anywhere in the city, demonstrating a consistent
pattern of activity by casual users of the system.

## Traffic Flow

In our last piece of analysis we will examine the overall traffic flow
for patterns. First, we will animate the traffic volume at all stations
over 20 minute intervals for a busy weekend.

![](analysis-report_files/figure-gfm/all%20traffic%20volume%20mapped-1.gif)<!-- -->

Next we’ll examine the average traffic patterns in June and compare
weekdays & weekends.

![](analysis-report_files/figure-gfm/all%20traffic%20volume%20mapped%20june%20weekday-1.gif)<!-- -->

We can see a few things of note:

-   On weekdays traffic starts earlier and that early morning traffic is
    primarily members on their morning commute. Member usage stays
    proportionally higher all day than on weekends.
-   On weekends traffic is heavier, starts & ends later, and has a
    higher proportion of casual users.

Let’s remind ourselves of the overall traffic volume patterns over a
year.

![](analysis-report_files/figure-gfm/traffic%20volume%20linegraph-1.png)<!-- -->

Note how low the traffic is in winter, particularly for casual users.
Next we will map the average winter traffic volume, to compare with
June.

![](analysis-report_files/figure-gfm/all%20traffic%20volume%20mapped%20winter-1.gif)<!-- -->

## All traffic flow

When we look at the overall traffic flow for the city, it is remarkably
consistent, day to day and between members and casuals. Traffic mostly
flows in to the waterfront from all directions, and flows out *from* the
waterfront either to the northwest or southwest, depending which side of
Navy Pier one is on.

Each arrow represents overall motion of all the bikes during a 10-minute
period. An arrow pointing northwest means that during that time the
**average** motion of bikes is that direction. The stronger the trend,
the longer the arrow.

We’ll first look at the big traffic patterns in the city. Traffic flow
from bike stations surrounding each arrow have been aggregated together

![](analysis-report_files/figure-gfm/all%20traffic%20flow%20mapped%20sectored-1.gif)<!-- -->

*Technical note: to calculate this metric, each trip is treated as a
vector from start station to end station. All vectors in a particular
period of time are added end-to-end and the final vector is treated as
the overall traffic flow.*

## Traffic flow patterns: showing all bike stations

![](analysis-report_files/figure-gfm/all%20traffic%20flow%20mapped%20fine%20detail-1.gif)<!-- -->

![](analysis-report_files/figure-gfm/all%20traffic%20flow%20mapped%20fine%20detail%20zoomed-1.gif)<!-- -->
