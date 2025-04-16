Wdir <- "C:/Users/90544/Documents/Makran_satellite_based_data/inversion/results/figure11_plot_R_scripts"

file1 <- file.path(Wdir, "H_Ro_Results", "Result_30_300.csv")
data1 <- read.table(file=file1, header=F, sep=",", dec=".", stringsAsFactors=F)
Result_1 <- data1$V3 

file2 <- file.path(Wdir, "H_Ro_Results", "Result_30_350.csv")
data2 <- read.table(file = file2, header = FALSE, sep = ",", dec = ".", stringsAsFactors = FALSE)
Result_2 <- data2$V3

file3 <- file.path(Wdir, "H_Ro_Results", "Result_30_400.csv")
data3 <- read.table(file = file3, header = FALSE, sep = ",", dec = ".", stringsAsFactors = FALSE)
Result_3 <- data3$V3

file4 <- file.path(Wdir, "H_Ro_Results", "Result_30_450.csv")
data4 <- read.table(file = file4, header = FALSE, sep = ",", dec = ".", stringsAsFactors = FALSE)
Result_4 <- data4$V3

file5 <- file.path(Wdir, "H_Ro_Results", "Result_30_500.csv")
data5 <- read.table(file = file5, header = FALSE, sep = ",", dec = ".", stringsAsFactors = FALSE)
Result_5 <- data5$V3

file6 <- file.path(Wdir, "H_Ro_Results", "Result_35_300.csv")
data6 <- read.table(file = file6, header = FALSE, sep = ",", dec = ".", stringsAsFactors = FALSE)
Result_6 <- data6$V3

file7 <- file.path(Wdir, "H_Ro_Results", "Result_35_350.csv")
data7 <- read.table(file = file7, header = FALSE, sep = ",", dec = ".", stringsAsFactors = FALSE)
Result_7 <- data7$V3

file8 <- file.path(Wdir, "H_Ro_Results", "Result_35_400.csv")
data8 <- read.table(file = file8, header = FALSE, sep = ",", dec = ".", stringsAsFactors = FALSE)
Result_8 <- data8$V3

file9 <- file.path(Wdir, "H_Ro_Results", "Result_35_450.csv")
data9 <- read.table(file = file9, header = FALSE, sep = ",", dec = ".", stringsAsFactors = FALSE)
Result_9 <- data9$V3

file10 <- file.path(Wdir, "H_Ro_Results", "Result_35_500.csv")
data10 <- read.table(file = file10, header = FALSE, sep = ",", dec = ".", stringsAsFactors = FALSE)
Result_10 <- data10$V3

file11 <- file.path(Wdir, "H_Ro_Results", "Result_40_300.csv")
data11 <- read.table(file = file11, header = FALSE, sep = ",", dec = ".", stringsAsFactors = FALSE)
Result_11 <- data11$V3

file12 <- file.path(Wdir, "H_Ro_Results", "Result_40_350.csv")
data12 <- read.table(file = file12, header = FALSE, sep = ",", dec = ".", stringsAsFactors = FALSE)
Result_12 <- data12$V3

file13 <- file.path(Wdir, "H_Ro_Results", "Result_40_400.csv")
data13 <- read.table(file = file13, header = FALSE, sep = ",", dec = ".", stringsAsFactors = FALSE)
Result_13 <- data13$V3

file14 <- file.path(Wdir, "H_Ro_Results", "Result_40_450.csv")
data14 <- read.table(file = file14, header = FALSE, sep = ",", dec = ".", stringsAsFactors = FALSE)
Result_14 <- data14$V3

file15 <- file.path(Wdir, "H_Ro_Results", "Result_40_500.csv")
data15 <- read.table(file = file15, header = FALSE, sep = ",", dec = ".", stringsAsFactors = FALSE)
Result_15 <- data15$V3

file16 <- file.path(Wdir, "H_Ro_Results", "Result_45_300.csv")
data16 <- read.table(file = file16, header = FALSE, sep = ",", dec = ".", stringsAsFactors = FALSE)
Result_16 <- data16$V3

file17 <- file.path(Wdir, "H_Ro_Results", "Result_45_350.csv")
data17 <- read.table(file = file17, header = FALSE, sep = ",", dec = ".", stringsAsFactors = FALSE)
Result_17 <- data17$V3

file18 <- file.path(Wdir, "H_Ro_Results", "Result_45_400.csv")
data18 <- read.table(file = file18, header = FALSE, sep = ",", dec = ".", stringsAsFactors = FALSE)
Result_18 <- data18$V3

file19 <- file.path(Wdir, "H_Ro_Results", "Result_45_450.csv")
data19 <- read.table(file = file19, header = FALSE, sep = ",", dec = ".", stringsAsFactors = FALSE)
Result_19 <- data19$V3

file20 <- file.path(Wdir, "H_Ro_Results", "Result_45_500.csv")
data20 <- read.table(file = file20, header = FALSE, sep = ",", dec = ".", stringsAsFactors = FALSE)
Result_20 <- data20$V3

file21 <- file.path(Wdir, "H_Ro_Results", "Result_50_300.csv")
data21 <- read.table(file = file21, header = FALSE, sep = ",", dec = ".", stringsAsFactors = FALSE)
Result_21 <- data21$V3

file22 <- file.path(Wdir, "H_Ro_Results", "Result_50_350.csv")
data22 <- read.table(file = file22, header = FALSE, sep = ",", dec = ".", stringsAsFactors = FALSE)
Result_22 <- data22$V3

file23 <- file.path(Wdir, "H_Ro_Results", "Result_50_400.csv")
data23 <- read.table(file = file23, header = FALSE, sep = ",", dec = ".", stringsAsFactors = FALSE)
Result_23 <- data23$V3

file24 <- file.path(Wdir, "H_Ro_Results", "Result_50_450.csv")
data24 <- read.table(file = file24, header = FALSE, sep = ",", dec = ".", stringsAsFactors = FALSE)
Result_24 <- data24$V3

file25 <- file.path(Wdir, "H_Ro_Results", "Result_50_500.csv")
data25 <- read.table(file = file25, header = FALSE, sep = ",", dec = ".", stringsAsFactors = FALSE)
Result_25 <- data25$V3

####### Makran 2018 Somaye Data ######

file_2018 <- file.path(Wdir, "H_Ro_Results", "Moho_Makran_2018_1deg.txt")
data_2018 <- read.table(file = file_2018,header = FALSE,sep = "\t",dec = ".",stringsAsFactors = FALSE)

colnames(data_2018) <- c("x", "y", "z_2018")
ordered_data <- data_2018[order(data_2018$x, data_2018$y), ]

z_2018 <- ordered_data$z_2018

##### Make a data frame of ro versus h and MSE #####
###### Calculate MSE (mean square error) #####

results <- list(Result_1, Result_2, Result_3, Result_4, Result_5,
                Result_6, Result_7, Result_8, Result_9, Result_10,
                Result_11, Result_12, Result_13, Result_14, Result_15,
                Result_16, Result_17, Result_18, Result_19, Result_20,
                Result_21, Result_22, Result_23, Result_24, Result_25)

mse <- sapply(results, function(result) mean((z_2018 - result)^2))

h <- seq(30, 50, by = 5)   # h values: 30, 35, 40, 45, 50
Ro <- seq(300, 500, by = 50)  # Ro values: 300, 400, 500, 600
grid <- expand.grid(h = h, Ro = Ro)
ordered_grid <- grid[order(grid$h, grid$Ro),]
print(ordered_grid)

results_df <- data.frame(h = ordered_grid$h, Ro = ordered_grid$Ro, mse = mse)

##### plot MSE #####

# Load necessary libraries
library(raster)
library(viridis)
library(sp)

raster_df <- rasterFromXYZ(as.matrix(results_df[, c("h", "Ro", "mse")]))

tiff(file = file.path(Wdir,"Figure11_plot.tiff"), width = 4500, height = 4000, units = "px", res = 800)

par(mar = c(5, 6, 2, 2) + 0.1)

plot(raster_df,  
     col =(viridis(100)),  # Use viridis color palette
     interpolate = FALSE, 
     legend.args = list(text = expression(paste("MSE [km"^2, "]")), cex = 0.7), 
     asp = NA, 
     axes = FALSE,
     xaxs = "i", 
     yaxs = "i",
     xlab = "Reference Moho [km]",  # X-axis label
     ylab = expression(paste("Density-Contrast [kg m"^-3, "]"))  # Y-axis label
)

# Set axis limits based on your data
axis(side = 1, at = seq(min(results_df$h), max(results_df$h), by = 5), 
     labels = paste(seq(min(results_df$h), max(results_df$h), by = 5)))
axis(side = 2, at = seq(min(results_df$Ro), max(results_df$Ro), by = 50), 
     labels = paste(seq(min(results_df$Ro), max(results_df$Ro), by = 50)))
box()

points(35, 500, col = "red", pch = 17, cex = 2)

dev.off()
