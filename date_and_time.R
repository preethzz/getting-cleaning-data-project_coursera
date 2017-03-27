install.packages("lubridate")
library(lubridate)
help(package=lubridate)


# Dates and date-times
today() # Current day
now() # Current time

# Pick a date in the past
ymd('1990-02-01') # most common - big to small
ymd('1990/02/01') # alternative
ymd('90-2-01') # make sure you specify year fully

# Also handles vectors of dates
ymd(c('2016-02-30', '2016-10-01'))

# Often in the US, we refer to mm/dd/yyyy
mdy('02.01.1990')
mdy('Feb 01, 1990')
mdy(02011990)

# Do whatever you want
dmy('01 Febrauary 1990')
dmy('01021990')

# But be careful, it's not magic!
ymd('1990201')

# whwn we have time too
now()
now(tzone = 'UTC')
ymd_hms('2017-03-24 17:23:02')

rn <- now()
rn_tz <- now(tzone = 'UTC')

tz(rn)
tz(rn_tz)

year(rn)
month(rn)
day(rn)
hour(rn)
minute(rn)
second(rn)

wday(rn)
wday(rn, label = TRUE)

rn

hour(rn) <- 8
rn

update(rn, year = 2050, second = 0)


# Instants - exact moment in time

# Intervals - An interval is a span of time that occurs between two specific instants. The length of an interval is never ambiguous, because we know when it occurs. Moreover, we can calculate the exact length of any unit of time that occurs during it.

# Durations - If we record the time span in seconds, it will have an exact length since seconds always have the same length.

# Periods - Periods record a time span in units larger than seconds, such as years, months, weeks, days, hours, and minutes. For convenience, we can also create a period that only uses seconds, but such a period would have the same properties as a duration.

# Handles time info with ymd_hms()
dt1 <- '2017-03-27 08:42:00'




