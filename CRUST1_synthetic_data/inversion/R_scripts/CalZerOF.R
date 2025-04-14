##### this subfunction calculates the Objective Function of the initial population #####

calcOF <- function(popu){
	OF <- c()
	for (i in 1:ncol(popu)) {
	OF[i] <- objective(popu[,i])
	}
return(OF)
}

calcBest <- function(popu){
	ObFun <- calcOF(popu)
	best <- popu[,which.min(ObFun)]
return(best)
}
