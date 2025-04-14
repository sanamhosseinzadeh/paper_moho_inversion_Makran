# This formula (Prutkin and Saleh 2009) calculates the gravity field
# at the Earth surface given on a rectangular grid {xObs, yObs}.
# In this model, the volume between moho surface and a reference moho
# plane z = H is divided into a number of rectangular prisms.
# A constant density contrast is considered for the model.
# Summation over all prisms gives the 3D gravitational effect of the model.

##### Read Synthetic Moho Model File #####

# Define the data path
syntheticfile <- "C:/Users/90544/Documents/simple_synthetic_data/forward/data/Simple_Moho_Model.csv"

# Read the Moho model data
data <- read.table(file = syntheticfile, header = FALSE, sep = ",", dec = ".",
                   stringsAsFactors = FALSE)

x <- data$V1  # Longitudes
y <- data$V2  # Latitudes
z <- data$V3  # Moho depth [km]

Obs_Grid <- expand.grid(yObs = seq(23.25, 29.75, by = 0.5), 
                        xObs = seq(53.25, 65.75, by = 0.5))

xObs <- Obs_Grid$xObs
yObs <- Obs_Grid$yObs

N <- length(xObs) # Number of observed points
M <- length(x)    # Number of rectangular prisms

##### Study Area Bounds #####

xMin <- 53 # Min Longitude
xMax <- 66 # Max Longitude
yMin <- 23 # Min Latitude
yMax <- 30 # Max Latitude

##### Bouguer Anomaly Calculation #####

L <- xMax - xMin  # Number of prisms on X axis
K <- yMax - yMin  # Number of prisms on Y axis

Mx <- (xMax - xMin) / L  # The length of each rectangle = 1 degree
My <- (yMax - yMin) / K  # The width of each rectangle = 1 degree

deg2rad <- function(deg) {(deg * pi) / 180}  # Converting degree to radian

DELTAX <- 100 * Mx # The length of each rectangle in km
DELTAY <- 110 * My # The width of each rectangle in km
S <- DELTAX * DELTAY  # The surface of each rectangle in km^2

G <- 6.67430E-11 # Gravitational constant [m^3 s^-2 kg^-1] 
SIGMA <- 400 # Density contrast [kg m^-3]
H <- 37 # Reference Moho [km]

ForwardBA <- numeric(N)
for (i in 1:N) {
    ForwardB <- 0
    for (j in 1:M) {
        # x and y distances between a measurement point and
        # the rectangular's center point in km
        xdistance <- 100 * (x[j] - xObs[i])
        ydistance <- 110 * (y[j] - yObs[i])
        ForwardB <- ForwardB + (S * SIGMA * G * (
            (1 / sqrt((xdistance)^2 + (ydistance)^2 + z[j]^2)) -
            (1 / sqrt((xdistance)^2 + (ydistance)^2 + H^2))))
    }
    ForwardBA[i] <- ForwardB
}

# Convert results to mGal
sBA <- data.frame(long = xObs, lat = yObs, synthBA = ForwardBA * 10^8)

# Save results and define the path for the output file
write.table(sBA, 
            file = "C:/Users/90544/Documents/simple_synthetic_data/forward/results/Simple_Synthetic_Data.csv",
            sep = ",", row.names = FALSE, col.names = FALSE)