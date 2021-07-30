Analysis: How Casual Users and Members Differ
================
Andrew Luyt
2021-07-29

## Who rides most often?

Overall, members take the majority of rides.

![](analysis-report_files/figure-gfm/who%20rides%20most%20often-1.png)<!-- -->

On weekends however, casual use approximately doubles and exceeds member
use.

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
of users, two and a half kilometers.

![](analysis-report_files/figure-gfm/avg%20trip%20distance-1.png)<!-- -->

Seasonally, average trip distance is smallest during the winter and
largest  
in summer, but only by about half a kilometer. Trip distance does not
change much over the course of the week.

### A special case: pleasure cruises?

For this analysis we’ve removed trips that start and end at the same
station since they have an apparent distance of zero. We believe it’s
likely that pleasure cruises make up a large portion of these rides.
These round trips are about an hour on average for casual users.

    ## `summarise()` has grouped output by 'member_casual'. You can override using the `.groups` argument.

| Rider Type | Possible pleasure cruises | Avg trip minutes | Percent of trips |
|:-----------|--------------------------:|-----------------:|-----------------:|
| casual     |                    315156 |               61 |        16.029084 |
| member     |                    110279 |               26 |         4.221833 |

In the next section on ride duration we’ll see the average casual trip
is just over 30 minutes, an interesting difference. These trips
represent about 10% of all bike use and about 16% of all casual use. We
also see above that casual users outnumber members 3 to 1 in this
interesting subset of rides.  
We’ll explore these rides in more detail in a later section.

## How much *time* is spent on an average ride?

Casuals ride more than twice as long as members, on average. There isn’t
much variation in ride duration over the week other than a slight
increase over the weekend.

![](analysis-report_files/figure-gfm/mean%20ride%20duration-1.png)<!-- -->

Seasonally, casual rides have a large amount of variation. The small
number of winter trips taken tend to be short - half the length of rides
at the peak of summer.

![](analysis-report_files/figure-gfm/mean%20ride%20duration%202-1.png)<!-- -->

## Pleasure cruises?

Earlier we noted the possibility of about 10% of rides being round-trip
pleasure cruises, starting and ending at the same station, likely near
the rider’s home. The two graphs below provide evidence for this idea.

If our hypothesis is correct, the percentage of this type of ride should
shrink in winter and grow in summer and be mostly confined to casual
users. This first graph shows exactly this pattern.

![](analysis-report_files/figure-gfm/pleasure%20cruises-1.png)<!-- -->

Second, if our idea is correct we should also see trip duration becoming
longer in winter and shorter in summer. This should strongly affect
casual users but have little effect on members, who have a 45-minute
time limit. This graph demonstrates this pattern as well.

![](analysis-report_files/figure-gfm/pleasure%20cruises%202-1.png)<!-- -->

Learning how these rides differ in destination, length, or speed would
require some sort of GPStracking data from the bikes, which is outside
the scope of this dataset. For now we note the strong possibility that
about ten percent of all
