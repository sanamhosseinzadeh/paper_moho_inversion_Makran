data <- read.table(file=syntheticfile, header=F, sep=",", dec=".",
stringsAsFactors=F)

 xObs <- data$V1
 yObs <- data$V2
 BA_obs <- data$V3 

 N <- length(xObs) #Number of observed points
 M <- 91 #Number of rectangular prisms
 dimension <- 91

 minb <- rep(c(10), times = M)  #10 is the minimum boundary moho
 maxb <- rep(c(70), times = M)  #70 is the maximum boundary moho