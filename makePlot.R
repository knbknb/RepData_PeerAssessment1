#makeplot.R

makePlot <- function(on.weekend, on.workday, extrainfo=""){

        
        xlab <-"Minute of the day"
        ylab <-paste0("daily avg. number of steps")
        main <-paste0("Number of physical steps taken by an anonymous person, ","\n",
                      "per 5-minute intervals during Oct-Nov. 2012", "\n", extrainfo)
        lty<-c("dotted", "solid")
        lwd <-2
        mar <-c(6,6,4,1)
        oma <-c(0,0,20,0)
        cex <- 0.9
        ylim <-range(on.workday$mean_workday_steps)
        xlim <-range(on.weekend$interval) 
        par(mfrow=c(2,1),mar=mar, cex=cex)
        plot( on.weekend, type="l", lty=lty[[1]], lwd=lwd,main=main, oma=oma,
              xlab="", xlim=xlim, ylab=ylab, ylim=ylim)
        legend("topright", col=c("black"), legend=c("Weekend"), lwd=lwd, lty=lty[[1]])
        
        plot( on.workday,type="l",lwd=lwd, lty=lty[[2]], main="", xlim=xlim, xlab=xlab, ylab=paste(ylab), ylim=ylim)
        legend("topright", col=c("black"), legend=c("Workweek"), lwd=lwd, lty=lty[[2]])
        
        
}

