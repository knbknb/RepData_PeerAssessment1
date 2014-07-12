# Reproducible Research: Peer Assessment 1

The instructions for this  assignment can be found on this page:
[https://github.com/rdpeng/RepData_PeerAssessment1](https://github.com/rdpeng/RepData_PeerAssessment1).  
Please read this first for context and details.

Calculated with R 3.1.0, for details see bottom of report.


## Loading and preprocessing the data

- Set working directory, 
- Read in data, ignoring cases with "NA" values
- Converting the "date" column to Date datatype


```r
setwd("/home/knut/Documents/coursera/datascience/5-reprod-research/RepData_PeerAssessment1")

act <- read.csv("activity.csv", header=TRUE, na.strings=c("NA"))


act <- act[which(act$steps >= 0),]


act$date <- as.Date(act$date)
```

 These are the number of NA values in each column:

```r
nas_per_column <- colSums(is.na(act));nas_per_column
```

```
##    steps     date interval 
##        0        0        0
```



### The mean of steps per each day can be calculated as follows:

```r
library(plyr)

actagg <- ddply(act, .(date), summarize,  sumsteps = round(sum(steps), 0))
head(actagg, 10)
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
### The mean and median total number of steps taken per day are very similar:

```r
mean_steps_per_day <- round(mean(actagg$sumsteps),0); mean_steps_per_day
```

```
## [1] 10766
```

```r
median_steps_per_day <- round(median(actagg$sumsteps),0); median_steps_per_day
```

```
## [1] 10765
```
### Visualised as a histogram:

```r
hist(actagg$sumsteps,  breaks=20, xlab="Number of steps walked per day", ylab="Frequency of days", main="Daily physical activity of an anonymous person in 2012")
```

![plot of chunk hist](figure/hist.png) 




## Are there differences in activity patterns between weekdays and weekends?

To answer  this question, we add a new column to the filtered `act` data frame.  
This column will contain the weekday.


```r
library(lubridate)
```

```
## 
## Attaching package: 'lubridate'
## 
## The following object is masked from 'package:plyr':
## 
##     here
```

```r
act$wkday <- wday(act$date)
```


# R Session Info:


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
## [1] lubridate_1.3.3 plyr_1.8.1      rj_2.0.2-1      knitr_1.6      
## [5] colorout_1.0-3 
## 
## loaded via a namespace (and not attached):
## [1] digest_0.6.4   evaluate_0.5.3 formatR_0.10   memoise_0.2.1 
## [5] Rcpp_0.11.1    stringr_0.6.2  tools_3.1.0
```
