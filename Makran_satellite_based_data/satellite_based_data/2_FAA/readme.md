# Free-Air Gravity Anomaly Calculation

**Author:** P. Vanicek, E. Rakowsky  
**Publication:** *Geodesy: The Concepts*, Elsevier, Amsterdam, Netherlands, 1986.

---

## Overview

This folder contains MATLAB scripts to compute the **Free-Air Anomaly (FAA)** from a satellite-derived geopotential model. 

---

## Files and Scripts

`FAA_cal.m` & `Pnm_normalise.m`:  MATLAB scripts to compute the free-air Anomaly from a satellite-derived geopotential model.

- **Purpose:**  
  Calculates the free-air Anomaly at a given location (latitude, longitude) based on spherical harmonic synthesis.

- **Inputs:**
  - File `Sat_M_corrected.dat` includes degree and order: `n,m` and spherical harmonic coefficients: `Cnm`, `Snm` (fully normalized)
   - Geographic coordinates: latitude, longitude
  - Ellipsoidal height or radial distance


- **Output:**
  - File `FAA.dat` includes longitude, latitude and Free-Air Anomaly value (in mGal)

- **Usage:**
  ```matlab
     'run FAA_cal.m'
	 with function `Pnm_normalise.m` 
		 ```

