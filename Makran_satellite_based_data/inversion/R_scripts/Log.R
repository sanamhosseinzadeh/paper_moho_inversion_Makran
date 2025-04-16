##### this subfunction prepares a log document for the results #####
##### the log includes information about the results and also gives a .RData #####
##### the .RData file will save information of the results and if you open it #####
##### in log folder and type "info" you can see all the saved information #####

library(logr)
options("logr.notes" = FALSE)

tmp <- file.path(Wdir,paste("P",p,"it",it,"tmax",tmax,".log", sep = ""))
lf <- log_open(tmp)

log_print("Inversion of Bouguer Anomalies using Hybrid DE & PSO")

log_print("**** Initial Parameters ****")
log_print(paste("Population Size:",p))
log_print(paste("Number of Generations Per Each Algorithm:",it))
log_print(paste("Number of Iterations in Hybrid:",tmax))
log_print(paste("Cognitive Scaling Factor in PSO:",CtrPar$c1))
log_print(paste("Social Scaling Factor in PSO:",CtrPar$c2))
log_print(paste("Inertia Weight in PSO:",CtrPar$w))
log_print(paste("Probability for Crossover in DE:",CtrPar$CR))
log_print(paste("Mutation Constant in DE:",CtrPar$F))

log_print("**** Elapsed Time for Each Iteration ****")
names(systime) <- c(1:iteration)
log_print (round(systime,2))
log_print(paste("Mean of Time for n Runs:", round(meanTime, 2)))

log_print(paste("Best model parameters were obtained at the iteration no:",
minRMS))


log_print("**** rms Information Among n Runs:****")
log_print(paste("Minimum rms value:",MinRMS))
log_print(MinRMS, digits = 5)
log_print(paste("Maximum rms value:",MaxRMS))
log_print(MaxRMS, digits = 5)
log_print(paste("Mean of rms Values:",meanRMS))
log_print(meanRMS, digits = 5)
log_print(paste("Standard Deviation of rms Values:",SD))
log_print(SD, digits = 5)

log_print("**** Optimum solution ****")
options(scipen = 100, digits = 6)
log_print(round(optimum,5))

log_print("Average Colaboration of Each Algorithm in The Hybrid (Percent)")
log_print(100*(table(better)/iteration)/tmax)
log_print("Colaboration of Each Algorithm for Optimum Solution Among n runs (Percent)")
log_print(100*table(better[minRMS,])/tmax)

log_close()
detach("package:logr", unload = TRUE)

#*****************************************************

directory <- file.path(Wdir, "log")
setwd(directory)
pathFolder <- "directory"
newFolder <- paste("P", p, "it", it, "tmax", tmax, sep = "")

dir.create(file.path(dirname(pathFolder), newFolder))

setwd(newFolder)

CP <- list (p = p, it= it, tmax = tmax)
Observed <- BA_obs
minBound <- minb
maxBound <- maxb
ControlPar <- append (CtrPar, CP)

info <- c("Observed","Calculated","minBound","maxBound","xObs","yObs","x","y",
"ControlPar","Result","ElapsedTime","minOF","BestPar","initDE","initPSO")

for(i in 1:iteration){
 Calculated <- calculated[i,]
 Result <- result[i,]
 ElapsedTime <- systime[i]
 minOF <- minOFmat[i,] #a vector of convergency rate of objective function 
 BestPar <- BestParList[[i]] #a matrix containing model parameters in iterations
 initDE <- initPDEList[[i]] 
 initPSO <- initPSOList[[i]] 
 save(info,Observed,Calculated,minBound,maxBound,xObs,yObs,x,y,
 ControlPar,Result,ElapsedTime,minOF,BestPar,initDE,initPSO,
 file = paste("run",i,".RData",sep=""))
}

setwd(Hdir)


