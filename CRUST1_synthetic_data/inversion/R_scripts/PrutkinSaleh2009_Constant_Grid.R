# This formula (Prutkin and Saleh 2009) calculates the gravity field       #
# at the Earth surface given on a rectangular grid {xObs, yObs}.           #
# In this model, the volume between moho surface and a reference moho      #
# plane z = H is devided into a number of rectangular prisms.              #
# A constant density contrast is considered for the model.                 #
# Summation over all prisms gives the 3D gravitational effect of the model.#

model <- read.table(file = modelfile, header = F, sep = ",", dec = ".",
stringsAsFactors = F)

x <- model$V1  #Longitudes
y <- model$V2  #Latitudes

##### The study area #####

xMin = 53 #Min Longitude
xMax = 66 #Max Longitude
yMin = 23 #Min Latitude
yMax = 30 #Max Latitude

##### Calculation of Bouguer anomaly in the center of each rectangle #####

L <- xMax - xMin  #Number of prisms on X axis
K <- yMax - yMin  #Number of prisms on Y axis


Mx <- ( xMax - xMin)/L #The length of each rectangle = 1 degree
My <- (yMax - yMin)/K  #The withd of each rectangle = 1 degree

deg2rad <- function(deg) {(deg * pi) / (180)} #Converting degree to radian

DELTAX <- 100 * Mx #The length of each rectangle in km
DELTAY <- 110 * My #The withd of each rectangle in km
S <- DELTAX*DELTAY   #The surface of each rectangle in km^2

G <- 6.67430E-11 #Gravitational constant
SIGMA <- 400 #Density contrast
H <- 35 #Reference moho for CRUST1.0 Moho model

forward <- function(z){
BA_cal <- c()
for(i in 1:N){
    ForwardB <- 0
    for (j in 1:M){
    #x and y distances between a measurement point and
    #the rectangular's center point in km
    xdistance <- 100*(x[j] - xObs[i]) 
    ydistance <- 110*(y[j] - yObs[i]) 
    ForwardB  <- ForwardB + (S*SIGMA*G*(
     (1/sqrt((xdistance)^2 + (ydistance)^2 + z[j]^2))
    -(1/sqrt((xdistance)^2 + (ydistance)^2 + H^2))))}
    BA_cal[i] <- ForwardB*10^8
}
return(BA_cal)
}


