##### this subfunction calculates the objective function of the problem #####

objective <- function(z){
 BA_cal <- forward(z)
 res <- BA_obs - BA_cal 
 E <- sum(res*res)/N
 return(E)
}

