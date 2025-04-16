##### data frames for moho result, caculatedBA, misfitBA #####

dimension <- 91

MohoResult <- data.frame( long = x, lat = y, moho = Result[1:dimension] )

CaculatedBA <- data.frame( long = xObs, lat = yObs, calBA = Calculated )

Residuals <- Calculated - Observed
misfitBA <- data.frame( long = xObs, lat = yObs, misfit = Residuals )

##### Plots for Convergency, Calculated vs Observed BA #####
##### hist misfit, hist error image #####

tiff(file = "Figure10_plot.tiff", width = 4500, height = 1500, units = "px", res = 300)
par(cex.axis = 1.5, cex.main = 1.8, cex.lab = 1.5)
par(mfrow = c(1, 3), mar = c(4.5, 5, 2.5, 2.5))

h2 <- hist(Residuals, plot=F, breaks = seq(-100,100,length.out = 14))
h2$counts <- h2$counts / sum(h2$counts)
plot(h2, freq=TRUE, ylab="Relative Frequency",col="blue",
xlim = c(-100,100), ylim = c(0, 0.5),
xlab = "Data Residuals [mGal]", main = "a", font.main = 1,
axes = FALSE, yaxs = "i",xaxs = "i")
axis(side = 1, at = seq(-100,100,by =50),
labels = seq(-100,100,by =50))
axis(side = 2, at = seq(0,0.5,by = 0.1),labels =seq(0,0.5,by = 0.1))
box()

plot(Calculated, Observed, type = "n", xlab = "Calculated Data [mGal]", 
     ylab = "Observed Data [mGal]", xlim = c(-300, 300), ylim = c(-300, 300), 
     xaxs = "i", yaxs = "i", axes = FALSE)
grid(nx = 4, ny = 4, col = "gray", lty = "dotted") 
axis(side = 1, at = seq(-300,300, by = 150),labels = seq(-300,300, by = 150))
axis(side = 2, at = seq(-300,300, by = 150),labels = seq(-300,300, by = 150))
box() 
abline(0, 1, lwd = 2)
points(Calculated, Observed, pch = 20, cex = 1.5, col = "blue")
title("b", font.main = 1)

tmax <- ControlPar$tmax
line_data <- rep(NA, length(minOF))
plot(0:tmax, line_data, log = "y", 
     xlab = "Iteration",
     ylab = expression(Error ~ Energy ~ paste("[", "mGal"^2, "]")),
     yaxs = "i", xaxs = "i", xlim = c(0, tmax), ylim = c(10^2, 10^5), 
     axes = FALSE, col = "blue", lwd = 3, type = "l" )
grid(nx = 3,ny = 3, col = "gray", lty = "dotted") #ny =3 if you want to have just grids
lines(0:tmax, minOF, col = "blue", lwd = 3, type = "l")
axis(side = 1, at = seq(0, tmax, by = 100), labels = seq(0, tmax, by = 100))
axis(side = 2, at = 10^seq(2, 5, by = 1), 
     labels = expression(10^2,10^3,10^4,10^5))
minor_ticks <- unlist(lapply(2:5, function(i) 1:9 * 10^i))
axis(side = 2, at = minor_ticks, labels = FALSE, tcl = 0.2, lwd.ticks = 0.5)
box()
title("c", font.main = 1)

dev.off()
