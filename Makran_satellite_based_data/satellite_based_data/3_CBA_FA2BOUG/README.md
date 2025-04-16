# FA2BOUG – Bouguer Anomaly Computation Tool

**Author:** J. Fullea, M. Fernàndez, H. Zeyen  
**Publication:** *FA2BOUG—A FORTRAN 90 code to compute Bouguer gravity anomalies from gridded free-air anomalies: Application to the Atlantic-Mediterranean transition zone*,  
Computers & Geosciences, Volume 34, Issue 12, 2008, Pages 1665–1681.  
DOI: [10.1016/j.cageo.2008.02.018](https://doi.org/10.1016/j.cageo.2008.02.018)

---

## Overview

**FA2BOUG** is a FORTRAN 90 code designed to compute Bouguer gravity anomalies from gridded free-air anomalies using Bullard A–C topographic corrections on a Cartesian grid.

The tool takes as input a digital elevation model (topography) and gravity anomaly data, processes topographic corrections in concentric zones (near, intermediate, and distant), and produces both the fully corrected Bouguer anomaly and the slab-corrected anomaly.

---

## Files Included

### Source Code
- `fa2boug.f90` – Main FORTRAN 90 program

### Input Files
- `parameters.dat` – Configuration file containing processing parameters
- `topo_cart.xyz` – Cartesian gridded elevation (topography)
- `gravi_cart.xyz` – Cartesian gridded free-air anomalies (or slab-corrected Bouguer anomalies)

### Output Files
- `bouguer.xyz` – Fully corrected Bouguer anomaly
- `bouguer_slab.xyz` – Slab-corrected Bouguer anomaly (Bullard A only)

---

## Program Description

FA2BOUG performs topographic corrections by integrating the topographic mass in three zones:

1. **Near zone** – Optional detailed DEM (if `det = 1`)
2. **Intermediate and distant zones** – Computed using input grids and specified grid steps

The main settings and computation parameters are defined in the `parameters.dat` file.

### Key Features
- Accepts free-air anomaly or slab-corrected Bouguer anomaly as input
- Supports optional high-resolution DEM for land areas
- Applies Bullard A, B, and C corrections
- Outputs both full Bouguer anomaly and slab-corrected anomaly
- Works with Cartesian gridded data

---

## Parameters (`parameters.dat`)

```plaintext
det            ! (0 or 1) - Use detailed topography (1 = yes, 0 = no)
d_xi, d_xd     ! Grid steps for intermediate and distant zones
d_xBg          ! Output grid step for Bouguer anomaly
rho_c, rho_w   ! Reduction densities (crust and seawater)
N, M           ! Grid size of input topo and gravity files
R_i, R_d       ! Radius limits for intermediate and distant zones
land           ! 'on' to process land and sea, 'off' for sea only
Boug_slab      ! 1 if input is slab Bouguer anomaly, 0 if free-air anomaly
Ndet, Mdet     ! Grid size of detailed topography (only if det = 1)
d_xdet         ! Grid step of detailed topography (only if det = 1)
```

---

## Input Format

- Files `topo_cart.xyz` and `gravi_cart.xyz` must be:
  - ASCII
  - Cartesian coordinates
  - Single-column values
  - Ordered from NW to SE (West to East per row, North to South per column)

- Optional detailed topography: `topo_cart_det.xyz`
  - Must fully cover a region extended by `R_i` around the output grid
  - Recommended to set flat regions as `NaN` to save computation time

---

## Output Files

- `bouguer_slab.xyz`: Slab-corrected anomaly (Bullard A only)
- `bouguer.xyz`: Fully corrected Bouguer anomaly (Bullard A–C) in Cartesian coordinates ==> Finally extract the complete Bouguer anomaly (CBS) for the region in the `CBA.xyz` file. 



