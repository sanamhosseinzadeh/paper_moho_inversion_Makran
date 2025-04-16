# Gravity Field Processing with GOCE TIM R6 and WGS84 Correction


This processes a satellite-derived geopotential model to prepare it for geophysical analysis by:

1. **Extracting spherical harmonic coefficients** (`n`, `m`, `Cnm`, `Snm`) from the GOCE TIM R6 gravity model (GO_CONS_GCF_2_TIM_R6.gfc).
2. **Correcting** the zonal terms of the model by removing the contribution of the WGS84 normal gravity field (ellipsoid).
3. Preparing the corrected coefficients for further use in Free-air gravity anomaly.

---

## Data Source

**Geopotential model used:**

> **GO_CONS_GCF_2_TIM_R6**  
> The 6th release of the GOCE gravity field model derived using the time-wise approach.

**Citation:**

> Brockmann, J. M.; Schubert, T.; Mayer-Gürr, T.; Schuh, W.-D. (2019):  
> *The Earth's gravity field as seen by the GOCE satellite – an improved sixth release derived with the time-wise approach*.  
> GFZ Data Services. [https://doi.org/10.5880/ICGEM.2019.003](https://doi.org/10.5880/ICGEM.2019.003)

---

## Files and Scripts

### 1. `Sat_M.dat`
- **Description:** Raw data file containing extracted spherical harmonic coefficients from the `GO_CONS_GCF_2_TIM_R6.gfc` file of the GOCE TIM R6 model.
- **Output:** `Sat_M.dat` Each row contains: `n`, `m`, `Cnm`, `Snm` 
- **Usage:**
```Bashscriptt
run('extract_model.bat')```


### 2. `WGS84_coefficient_correction.m`
- **Description:** MATLAB script used to subtract the WGS84 zonal terms from the GOCE model's zonal coefficients (`Cnm`, `m = 0`).
- **Purpose:** Correction of geopotential model coefficients by removing the normal gravity coefficients (WGS84 ellipsoid).
- **Input:** `Sat_M.dat` containing original GOCE coefficients.
- **Output:** `Sat_M_corrected.dat` Corrected zonal harmonic coefficients representing the anomaly field.
- **Usage:**
```matlab
run('WGS84_coefficient_correction.m')```