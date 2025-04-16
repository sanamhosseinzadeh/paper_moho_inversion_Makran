##### this subfunction gives the best objective function and best parameters during iterations #####

minOF <- minOFmat [minRMS,]
BestPar <- BestParList [[minRMS]]

# Plotting Error versus Iteration number
  plot(0:tmax, minOF, xlab = "Generation number",
  ylab = "Error energy [mGal^2]", main = paste("Convergency Rate of  Hybrid DE & PSO",
  "(p =",p,"it = ",it,"tmax =", tmax,")"),
  col= "blue", type = "l",yaxs = "i",xaxs = "i",xlim = c(0,tmax),
  ylim = c(0, (max(minOF)+0.5)), lwd = 3)

directory <- file.path(Wdir, "log")
setwd(directory)

 pdf(paste("p",p,"it",it,"tmax",tmax,".pdf", sep = ""))
 plot(0:tmax, minOF, xlab = "Generation number",
 ylab = "Error energy [mGal^2]", main = paste("Convergency Rate of  Hybrid DE & PSO",
 "(p =",p,"it = ",it,"tmax =", tmax,")"),
 col= "blue", type = "l",yaxs = "i",xaxs = "i",xlim = c(0,tmax),
 ylim = c(0, max(minOF)+ 0.5), lwd = 3)
 dev.off()

setwd(Hdir)
