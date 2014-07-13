setwd("/home/knut/Documents/coursera/datascience/5-reprod-research/RepData_PeerAssessment1")

act <- read.csv("activity.csv", header=TRUE, na.strings=c("NA"))

colSums(is.na(act))

act <- act[which(act$steps >= 0),]



act$date <- as.Date(act$date)
library(lubridate)
act$wkday <- wday(act$date)
on_weekend <- act[(act$wkday %in% c(6,7)),]
on_workday <- act[!(act$wkday %in% c(6,7)),]
wday("2013-07-13")
summary(act)

split(mean(act$steps), act$date)

actfmax <- ddply(act, .(interval), summarize,  maxsteps = max(steps))
actfmax[which.max(actfmax$maxsteps),]


library(lubridate)
intvmax <- 805
duration_minutes_past_midnight <- dminutes(intvmax * 5)
ymd(today()) + duration_minutes_past_midnight
