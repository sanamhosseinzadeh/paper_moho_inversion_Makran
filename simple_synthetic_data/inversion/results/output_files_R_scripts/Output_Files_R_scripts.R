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

##### Output files #####

write.table(MohoResult, file="1Estimated_Moho_Depths.csv", sep=",", row.names = F, col.names=F)

write.table(CaculatedBA, file="1Caculated_Data.csv", sep=",", row.names = F, col.names=F)

write.table(misfitBA, file="1Data_Residuals.csv", sep=",", row.names = F, col.names=F)

write.table(misfitMoho, file="1Moho_Depth_Residuals.csv", sep=",", row.names = F, col.names=F)
