# Reproducible Research: 
# Peer Assessment 1

Knut Behrends  
knb@gfz-potsdam.de  
July 2014  

The instructions for this  assignment can be found on this page: 
[https://github.com/rdpeng/RepData_PeerAssessment1](https://github.com/rdpeng/RepData_PeerAssessment1).  
Please read this first for context and details.


Calculated with R 3.1.0, for details about the software used, see bottom of report.


## Loading and preprocessing the data

- Set working directory, 
- Read in data, ignoring cases with "NA" values
- Converting the "date" column to Date datatype


```r
library(lubridate)
library(plyr)

setwd("/home/knut/Documents/coursera/datascience/5-reprod-research/RepData_PeerAssessment1")

source("makePlot.R")

act <- read.csv("activity.csv", header=TRUE, na.strings=c("NA"))
```

 These are the number of NA values in each column:


```r
colSums(is.na(act));
```

```
##    steps     date interval 
##     2304        0        0
```

Preparing a new data frame, all rows with NA values removed:

```r
act$date <- as.Date(act$date)
actf <- act[which(act$steps >= 0),]
```


### The total number of steps per each day can be calculated as follows:

```r
actfagg <- ddply(actf, .(date), summarize,  sumsteps = round(sum(steps), 0))
head(actfagg, 10)
```

```
##          date sumsteps
## 1  2012-10-02      126
## 2  2012-10-03    11352
## 3  2012-10-04    12116
## 4  2012-10-05    13294
## 5  2012-10-06    15420
## 6  2012-10-07    11015
## 7  2012-10-09    12811
## 8  2012-10-10     9900
## 9  2012-10-11    10304
## 10 2012-10-12    17382
```
### The mean and median total number of steps taken per day are very similar.
Mean:

```r
mean_steps_per_day <- round(mean(actfagg$sumsteps),0); mean_steps_per_day
```

```
## [1] 10766
```

Median:

```r
median_steps_per_day <<- round(median(actfagg$sumsteps),0); median_steps_per_day
```

```
## [1] 10765
```
### Steps per day visualised as a histogram:



```r
strtit <- "Daily physical activity of an anonymous person in Oct-Nov 2012"
hist(actfagg$sumsteps,  breaks=20, xlab="Number of steps walked per day", ylab="Frequency of days", main=strtit)

abline(v= mean_steps_per_day, lwd =2, col="blue")
abline(v= median_steps_per_day, lwd =1, col="red")
```

![plot of chunk hist](figure/hist.png) 

In the plot above, the mean value of n = 1.0766 &times; 10<sup>4</sup> is shown as a blue line, the median as a red line.


### The mean of steps per interval-of-the-day can be calculated as follows.
We assume that there are the same number of 5-Minute-Intervals per measurement day. There are 

```r
nintv <- length(unique(actf$interval)); nintv
```

```
## [1] 288
```

intervals per day. 
After summing up all the steps taken during each interval, we have to normalize each sum by this value.

```r
actfagg3 <- ddply(actf, .(interval), summarize,  meansteps = round(sum(steps)/ nintv, 0))
```
 




```
##     interval meansteps
## 76       615        12
## 94       745        13
## 95       750        11
## 97       800        14
## 98       805        13
## 99       810        24
## 100      815        29
## 101      820        31
## 102      825        29
## 103      830        33
```

### This is the interval of the day during which, on average, user made the highest number of steps:

```r
intvmax <- actfagg3[which.max(actfagg3$meansteps),]; intvmax
```

```
##     interval meansteps
## 104      835        38
```




## Are there differences in activity patterns between weekdays and weekends?

This can be visualized with a time series plot.


### Plotting daily averages of steps made, using filtered data:


```r
nintv <- length(unique(actf$interval));


days.weekend <- actf[(wday(actf$date) %in% c(6,1)),];
nweekenddays <- nrow(days.weekend)/nintv;
on.weekend <-  ddply(days.weekend, .(interval), summarize,  mean_weekend_steps = round(sum(steps)/nweekenddays, 0)) ;

days.workweek <- actf[! (wday(actf$date) %in% c(6,1)),]
nworkdays <- nrow(days.workweek)/nintv
on.workday <- ddply(days.workweek, .(interval), summarize,  mean_workday_steps = round((sum(steps)/nworkdays), 0))

        
makePlot(on.weekend, on.workday)
```

![plot of chunk unnamed-chunk-11](figure/unnamed-chunk-11.png) 

The plots show that the user started to move around later during the day on weekends, compared to his/her activity during the workweek.

### The maximum of the daily averages of the 5-minute intervals
The maximum of the daily averages of the 5-minute intervals is interval n = 850 ,  218.


## Coping with missing data


To this end, we'll substitute NA values with the value for the mean steps per day (10766), determined above.  


```r
bad <- is.na(act$steps)
act[bad, "steps"] <- mean_steps_per_day/length(unique(act$date))

actagg <- ddply(act, .(date), summarize,  sumsteps = round(sum(steps), 0))



strtit <- paste0("Daily physical activity of an anonymous person in Oct-Nov 2012", "\n", " NAs substituted with daily averages")
hist(actagg$sumsteps,  breaks=20, xlab="Number of steps walked per day", ylab="Frequency of days", main=strtit)
```

![plot of chunk unnamed-chunk-12](figure/unnamed-chunk-12.png) 

The plot shows that there the newly assigned values produce asingle new bin to the far right of the histogram,  for all thos, however the shape of the histogram is not distorted much, and mean and median are still nearly unchanged.
Now we're plotting daily averages of steps made, using unfiltered data.  



```r
nintv <- length(unique(act$interval));


days.weekend <- act[(wday(act$date) %in% c(6,1)),];
nweekenddays <- nrow(days.weekend)/nintv;
on.weekend <-  ddply(days.weekend, .(interval), summarize,  mean_weekend_steps = round(sum(steps)/nweekenddays, 0)) ;

days.workweek <- act[! (wday(act$date) %in% c(6,1)),]
nworkdays <- nrow(days.workweek)/nintv
on.workday <- ddply(days.workweek, .(interval), summarize,  mean_workday_steps = round((sum(steps)/nworkdays), 0))

makePlot(on.weekend, on.workday,"missing data replaced with daily median value")
```

![plot of chunk unnamed-chunk-13](figure/unnamed-chunk-13.png) 

### R Session Info:


```r
sessionInfo()
```

```
## R version 3.1.0 (2014-04-10)
## Platform: x86_64-pc-linux-gnu (64-bit)
## 
## locale:
##  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
##  [3] LC_TIME=de_DE.UTF-8        LC_COLLATE=en_US.UTF-8    
##  [5] LC_MONETARY=de_DE.UTF-8    LC_MESSAGES=en_US.UTF-8   
##  [7] LC_PAPER=de_DE.UTF-8       LC_NAME=C                 
##  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
## [11] LC_MEASUREMENT=de_DE.UTF-8 LC_IDENTIFICATION=C       
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
## [1] plyr_1.8.1      lubridate_1.3.3 rj_2.0.2-1      knitr_1.6      
## [5] colorout_1.0-3 
## 
## loaded via a namespace (and not attached):
##  [1] digest_0.6.4     evaluate_0.5.3   formatR_0.10     htmltools_0.2.4 
##  [5] memoise_0.2.1    Rcpp_0.11.1      rmarkdown_0.2.49 stringr_0.6.2   
##  [9] tools_3.1.0      yaml_2.1.13
```
