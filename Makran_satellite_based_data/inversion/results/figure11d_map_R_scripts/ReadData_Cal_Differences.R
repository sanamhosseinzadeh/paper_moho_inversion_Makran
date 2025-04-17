####### read our optimum result ########

dir <- "C:/Users/90544/Documents/Makran_satellite_based_data/inversion/results/figure12d_map_R_scripts"

data <- read.table(file = file.path(dir,"Result_35_500.csv"), header = FALSE, sep = ",", dec = ".", stringsAsFactors = FALSE)
Result <- data$V3

####### Result obtained by Abdollahi et al. (2018) ######

data_2018 <- read.table(file = file.path(dir, "Moho_Makran_2018_1deg.txt")
,header = FALSE,sep = "\t",dec = ".",stringsAsFactors = FALSE)

colnames(data_2018) <- c("x", "y", "z_2018")
ordered_data <- data_2018[order(data_2018$x, data_2018$y), ]

z_2018 <- ordered_data$z_201

####### calculate difference between two results and plot histogram ########

difference <- z_2018 - Result

tiff(file = file.path(dir,"Figure11d_plot.tiff"), 
width = 4000, height = 4000, units = "px", res = 800)

h <- hist(difference , plot=F, breaks = seq(-15,15,length.out = 11))
h$counts <- h$counts / sum(h$counts)
plot(h, freq=TRUE, ylab="Relative Frequency", col = "blue",
xlim = c(-10,10), ylim = c(0, 0.5),
xlab = "Residuals [km]", main = "d",
axes = FALSE, yaxs = "i",xaxs = "i")
axis(side = 1, at = seq(-10,10,by =5),
labels = seq(-10,10,by =5))
axis(side = 2, at = seq(0,0.5,by = 0.1),labels =seq(0,0.5,by = 0.1))
box()

dev.off()

###### write the difference between two results to a file for mapping #####

x <- data$V1  #Longitudes
y <- data$V2  #Latitudes

dimension <- 91

resid <- data.frame( long = x, lat = y, resid = difference )

write.table(resid,
file = file.path(dir,"resid.csv"),sep=",",row.names = F,col.names=F)