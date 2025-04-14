##### this subfunction generates a random initial population #####

generateRandom <- function(numPopulation, dimension, lowerBound, upperBound){
	IniP <- matrix()
	if(length(lowerBound) == 1){
    IniP <- matrix(runif(numPopulation*dimension, lowerBound, upperBound),
    nrow=numPopulation, ncol = dimension)

	}else{
	IniP <- matrix(nrow = numPopulation, ncol = dimension)
	for (i in 1:dimension){
	IniP[,i] = runif(numPopulation, lowerBound[i], upperBound[i])
	}
	}
return(IniP)
}