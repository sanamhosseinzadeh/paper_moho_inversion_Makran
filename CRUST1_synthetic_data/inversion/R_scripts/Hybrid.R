##### this subfunction combines DE and PSO algorithms #####

library("NMOF")

# Control Paramters Obtained by Parameter Tuning of DE and PSO
CtrPar <- list ( F = 0.4, CR = 0.9, w = 0.715, c1 = 1.7, c2 = 1.7 )

#***** Generate Random Initial Population **************************

source(file.path(Wdir, "GRinitPOP.R"))
source(file.path(Wdir, "CalZerOF.R"))

#*******************************************************************

Hybrid <- function(p,it,tmax){

 Mat <- generateRandom(numPopulation = 2*p, dimension = length(minb),
 lowerBound = minb, upperBound = maxb)

 r <- p+1
 c <- 2*p

 popDE <- t(Mat[1:p,])
 popPSO <- t(Mat[r:c,])

 ZerOF <- min(min(calcOF(popDE)), min(calcOF(popPSO))) 
 if (min(calcOF(popDE)) < min(calcOF(popPSO))){
 ZeroPar <- calcBest(popDE)
 }else{
 ZeroPar <- calcBest(popPSO)
}

initpopDE <- popDE 
initpopPSO <- popPSO 

 i <- 0
 better <- c()
 minOF <- c()
 BestPar <- matrix(NA, ncol = dimension, nrow = tmax, byrow = T)


repeat {

 DEalgo <- list(min = minb,
 max = maxb,
 minmaxConstr = TRUE,
 printDetail = FALSE, 
 storeF = FALSE,
 storeSolutions = TRUE,
 printBar = FALSE,
 nP = p, ### population size
 nG = it, ### number of generations
 F = CtrPar$F, ### step size
 CR = CtrPar$CR, ### prob of crossover 
 initP = popDE ) 

 de <- DEopt(OF = objective, algo = DEalgo)

 PSOalgo <- list(min = minb,
 max = maxb,
 minmaxConstr = TRUE,
 printDetail = FALSE,
 storeF = FALSE,
 storeSolutions = TRUE,
 printBar = FALSE,
 nP = p, ### population size
 nG = it, ### number of generations
 c1 = CtrPar$c1,
 c2 = CtrPar$c2,
 iner = CtrPar$w,
 initP = popPSO) 

  ps <- PSopt(OF = objective, algo = PSOalgo)

  popPSO <- ps$xlist$P[[PSOalgo$nG]] #update the population popPSO
  popDE <- de$xlist$P[[DEalgo$nG]]   #update the population popDE

  #Comparison of the population fitness values f_PSO and f_DE.

  if(de$OFvalue < ps$OFvalue){
  Bpso <- which.min(ps$popF)
  popPSO[,Bpso] <- de$xbest # update the optimum solution and position in the
  better[i] <- "DE"         # PSO algorithm with the newest optimum value and
  minOF[i] <- de$OFvalue    # position in the DE algorithm.
  BestPar[i,] <- de$xbest      
 }else{
  Bde <- which.min(de$popF)
  popDE[,Bde] <- ps$xbest   # update the optimum solution and position in the
  better[i] <- "PSO"             # DE algorithm with the newest optimum value and
  minOF[i] <-  ps$OFvalue         # position in the PSO algorithm.
  BestPar[i,] <- ps$xbest
 }

 
 if ( i == tmax ){
  break
 }
 i <-i+1
 print(paste("iteration:",i))
}
 
if (sqrt(ps$OFvalue) > sqrt(de$OFvalue)){
 result <- de$xbest
 rms <- sqrt(de$OFvalue)
}else{
 result <- ps$xbest
 rms <- sqrt(ps$OFvalue)
}

Hresult <- c(result, rms)

options("scipen" = 100,"digits" = 4)

return(list(Hresult = Hresult,
 better = better, 
minOF = minOF,
 BestPar = BestPar,
 initpopDE = initpopDE,
initpopPSO = initpopPSO,
 ZerOF = ZerOF,
 ZeroPar = ZeroPar))
}