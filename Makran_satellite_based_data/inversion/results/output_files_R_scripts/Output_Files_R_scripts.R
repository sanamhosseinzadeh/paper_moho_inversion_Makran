##### data frames for moho result, calculatedBA, misfitBA #####

dimension <- 91

MohoResult <- data.frame(long = x, lat = y, moho = Result[1:dimension])

CaculatedBA <- data.frame(long = xObs, lat = yObs, calBA = Calculated)

Residuals <- Calculated - Observed
misfitBA <- data.frame(long = xObs, lat = yObs, misfit = Residuals)

##### Output files #####

write.table(MohoResult, file="Estimated_Moho_Depths.csv", sep=",", row.names = F, col.names=F)

write.table(CaculatedBA, file="Caculated_Data.csv", sep=",", row.names = F, col.names=F)

write.table(misfitBA, file="Data_Residuals.csv", sep=",", row.names = F, col.names=F)