setwd("/home/knut/Documents/coursera/datascience/5-reprod-research/RepData_PeerAssessment1")

act <- read.csv("activity.csv", header=TRUE, na.strings=c("NA"))

colSums(is.na(act))

act <- act[which(act$steps >= 0),]



act$date <- as.Date(act$date)


summary(act)

split(mean(act$steps), act$date)
