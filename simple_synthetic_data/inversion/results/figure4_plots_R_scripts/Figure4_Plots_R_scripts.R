##### True moho model #####

# define the path for the Moho model file
syntheticfile = file.path("C:/Users/90544/Documents/simple_synthetic_data/inversion/data/Simple_Moho_Model.csv")

Tdata <- read.table(file = syntheticfile, header = F, sep = ",", dec = ".",
                    stringsAsFactors = F)

x <- Tdata$V1  # Longitudes
y <- Tdata$V2  # Latitudes
Tz <- Tdata$V3

##### data frames for moho result, calculatedBA, misfitBA, misfitMoho #####

dimension <- 91

MohoResult <- data.frame(long = x, lat = y, moho = Result[1:dimension])

CaculatedBA <- data.frame(long = xObs, lat = yObs, calBA = Calculated)

Residuals <- Calculated - Observed
misfitBA <- data.frame(long = xObs, lat = yObs, misfit = Residuals)

ErrorImage <- Result[1:dimension] - Tz
misfitMoho <- data.frame(long = x, lat = y, misfit = ErrorImage)

##### Plots for Convergence, Calculated vs Observed BA #####
##### hist misfit, hist error image #####

tiff(file = "Figure4_plot.tiff", width = 3000, height = 3000, units = "px", res = 300)

par(cex.axis = 1.5, cex.main = 1.8, cex.lab = 1.5)
par(mfrow = c(2, 2), mar = c(4.8, 4.8, 4.8, 4.8))

# Plot a: Histogram of ErrorImage
h1 <- hist(ErrorImage, plot = F, breaks = seq(-0.0002, 0.0002, length.out = 12))
h1$counts <- h1$counts / sum(h1$counts)
plot(h1, freq = TRUE, ylab = "Relative Frequency", col = "blue",
     xlim = c(-0.0002, 0.0002), ylim = c(0, 0.5),
     xlab = "Moho Depth Residuals [km]", main = "a", font.main = 1,
     axes = FALSE, yaxs = "i", xaxs = "i")
x_axis_labels <- sprintf("%.0e", seq(-0.0002, 0.0002, length.out = 5))
x_axis_labels[x_axis_labels == "0e+00"] <- "0"
axis(side = 1, at = seq(-0.0002, 0.0002, length.out = 5),
     labels = x_axis_labels)
axis(side = 2, at = seq(0, 0.5, by = 0.1), labels = seq(0, 0.5, by = 0.1))
box()

# Plot b: Histogram of Residuals
h2 <- hist(Residuals, plot = F, breaks = seq(-0.001, 0.001, length.out = 12))
h2$counts <- h2$counts / sum(h2$counts)
plot(h2, freq = TRUE, ylab = "Relative Frequency", col = "blue",
     xlim = c(-0.001, 0.001), ylim = c(0, 0.5),
     xlab = "Data Residuals [mGal]", main = "b", font.main = 1,
     axes = FALSE, yaxs = "i", xaxs = "i")
x_axis_labels <- sprintf("%.0e", seq(-0.001, 0.001, length.out = 5))
x_axis_labels[x_axis_labels == "0e+00"] <- "0"
axis(side = 1, at = seq(-0.001, 0.001, length.out = 5),
     labels = x_axis_labels)
axis(side = 2, at = seq(0, 0.5, by = 0.1), labels = seq(0, 0.5, by = 0.1))
box()

# Plot c: Calculated vs Observed
plot(Calculated, Observed, type = "n", xlab = "Calculated Data [mGal]", 
     ylab = "Observed Data [mGal]", xlim = c(-200, 150), ylim = c(-200, 150), 
     xaxs = "i", yaxs = "i", axes = FALSE)
grid(nx = 5, ny = 5, col = "gray", lty = "dotted")
axis(side = 1, at = seq(-200, 150, by = 70), labels = seq(-200, 150, by = 70))
axis(side = 2, at = seq(-200, 150, by = 70), labels = seq(-200, 150, by = 70))
box()
abline(0, 1, lwd=2)
points(Calculated, Observed, pch = 20, cex = 1.5, col = "blue")
title("c", font.main = 1)  

# Plot d: Convergence plot

tmax <- ControlPar$tmax
line_data <- rep(NA, length(minOF))
plot(0:tmax, line_data, log = "y", 
     xlab = "Iteration",
     ylab = expression(Error ~ Energy ~ paste("[", "mGal"^2, "]")),
     yaxs = "i", xaxs = "i", xlim = c(0, tmax), ylim = c(10^-8, 10^4), 
     axes = FALSE, col = "blue", lwd = 3, type = "l" )
grid(nx = 3,ny = 3, col = "gray", lty = "dotted") #ny =3 if you want to have just grids
lines(0:tmax, minOF, col = "blue", lwd = 3, type = "l")
axis(side = 1, at = seq(0, tmax, by = 100), labels = seq(0, tmax, by = 100))
axis(side = 2, at = 10^seq(-8, 4, by = 4), 
     labels = expression(10^-8,10^-4,10^0,10^4))
minor_ticks <- unlist(lapply(-8:4, function(i) 1:9 * 10^i))
axis(side = 2, at = minor_ticks, labels = FALSE, tcl = 0.2, lwd.ticks = 0.5)
box()
title("d", font.main = 1)

dev.off()
