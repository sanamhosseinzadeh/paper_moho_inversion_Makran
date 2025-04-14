##### this is the main code that should be run to get results of the inversion#####

# before runing this main code, please define work directory
Wdir <- "C:/Users/90544/Documents/simple_synthetic_data/inversion/R_scripts"

# before run please define home directory 
# getwd() command in R gives the home directory 
Hdir <- "C:/Users/90544/Documents" 

# define the path for the synthetic data file
syntheticfile = file.path(Hdir,"simple_synthetic_data/inversion/data/Simple_Synthetic_Data.csv")

# define the path for the Moho model file
modelfile = file.path(Hdir,"simple_synthetic_data/inversion/data/Simple_Moho_Model.csv")

#***********************************************************

# we have a folder named Outputs_runs to save the logs in each run
drctry <- paste0(Wdir, "/Output_runs/")

#************************ Read Data ***************************

source(file.path(Wdir, "ReadData.R"))

#******************* Constrain Functions *********************

source(file.path(Wdir, "PrutkinSaleh2009_Constant_Grid.R"))
source(file.path(Wdir, "ObjectiveF.R"))
source(file.path(Wdir, "CalZerOF.R"))

#************ Hybrid of DE and PSO **********************************

source(file.path(Wdir, "Hybrid.R"))

#************ Define Control Paramters of Hybrid Process ************

it <- 5 # Number of generations per each algorithm
p <- 150 # Population size
tmax <- 300 # Total iteration
iteration <- 1  #run

#*********** log information*****************

CP <- list (p = p, it= it, tmax = tmax)
Observed <- BA_obs
minBound <- minb
maxBound <- maxb
ControlPar <- append (CtrPar, CP)

#********************* Hybrid Optimization *******************

systime <- c()
result <- matrix(NA, ncol = dimension+1, nrow = iteration, byrow = T)
calculated <- matrix(NA, ncol = N , nrow = iteration, byrow = T)
better <- matrix(NA, nrow = iteration, ncol = tmax, byrow = T)
minOFmat <- matrix(NA, nrow = iteration, ncol = tmax + 1, byrow = T)
BestParList <- list()
initPDEList <- list()
initPSOList <- list()


for(i in 1:iteration){
 t <- system.time(HR <- Hybrid(p = p , it = it, tmax = tmax))
 result[i,] <- HR$Hresult 
 systime[i] <- t[3]
 better[i,] <- HR$better
 calculated[i,] <- forward(HR$Hresult)
 minOFmat[i,] <-  c(HR$ZerOF, HR$minOF)
 BestParList[[i]] <- rbind(HR$ZeroPar, HR$BestPar, deparse.level = 0)
 initPDEList[[i]] <- HR$initpopDE
 initPSOList[[i]] <- HR$initpopPSO

#### log info####

 print(paste("run:", i))
 print(paste("ElapsedTime:", systime[i]))

 info <- c("Observed","Calculated","minBound","maxBound","xObs","yObs","x","y",
 "ControlPar","Result","ElapsedTime","minOF","BestPar","initDE","initPSO")

 
 Calculated <- calculated[i,]
 Result <- result[i,]
 ElapsedTime <- systime[i]
 minOF <- minOFmat[i,] #a vector of convergency rate of objective function 
 BestPar <- BestParList[[i]] #a matrix containing model parameters in iterations
 initDE <- initPDEList[[i]] 
 initPSO <- initPSOList[[i]] 

 file_path <- file.path(drctry, paste("run",i,".RData",sep=""))

 save(info,Observed,Calculated,minBound,maxBound,xObs,yObs,x,y,
 ControlPar,Result,ElapsedTime,minOF,BestPar,initDE,initPSO,
 file = file_path)
}

minRMS <- which.min(result[,dimension+1])
MinRMS <- min(result[,dimension+1]) 
MaxRMS <- max(result[,dimension+1])  
meanRMS <- mean (result[,dimension+1]) 
SD <- sd (result[,dimension+1]) 
meanTime <- mean(systime)

#****** Display Results of Best Parameters & Elapsed Time ******

optimum <- result[minRMS,]
optimum 

MinRMS  
MaxRMS   
meanRMS  
SD
meanTime

#****** Log ***************************************************

source(file.path(Wdir, "Log.R"))

#***** Convergency Rate Plot **********************************

source(file.path(Wdir, "Convergency.R"))
