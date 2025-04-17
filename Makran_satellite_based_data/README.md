# Folder Structure and File Descriptions

This folder contains the datasets and software codes used in the section titled **Moho Depth in the Makran Zone, SE Iran** of the manuscript. 
The materials are organized into subfolders for satellite_based_data and inversion. 
Each folder is self-contained, with the corresponding data, scripts, and results provided for transparency and reproducibility.
All resulting figures are saved in their respective folder for easy access.

## satellite_based_data/  
This folder contains the scripts, data, results, and figures to obtain satellite-based Bouguer anomalies.
The subfolders `1_Sat_model/`, `2_FAA/`, and `3_CBA_FA2BOUG/` contain the steps for obtaining the satellite-based Bouguer data and the `README.md` file located in each folder includes the descriptions of the files and scripts.

- `figure7a_map_GMT_scripts/a_map.bat`: GMT script to map the free-air gravity anomalies (Figure 7a).  
- `figure7b_map_GMT_scripts/b_map.bat`: GMT script to map the Bouguer gravity anomalies (Figure 7b).  

## inversion/  
This folder contains the scripts, data, results, and figures related to the inversion process using the hybrid DE/PSO metaheuristic algorithm.

- `data/Model_Coordinates.csv`: Input file defining the coordinates of the unknown Moho model.  
- `data/SatCBA.csv`: Input file defining the satellite-based Bouguer gravity anomalies.
- `data/figure9a_map_GMT_scripts/a_map`: GMT script to map the Bouguer gravity anomalies (Figure 9a) 
- `R_scripts/Inversion_Hybrid_Main_Code.R`: Main R script to perform the inversion and save results in the `log/` folder.  
Note: The script contains paths that must be updated to match your system before running.  
- `results/log/P150it5tmax300.log`, `run1.RData`, `P150it5tmax300.pdf`: Output files from the inversion.
- `results/figure9b_map_GMT_scripts/b_map.bat`: GMT script to map the estimated Moho depths (Figure 9b).  
- `results/figure9c_map_GMT_scripts/c_map.bat`: GMT script to map the calculated data (Figure 9c).  
- `results/figure9d_map_GMT_scripts/d_map.bat`: GMT script to map the data residuals (Figure 9d).  
- `results/figure10_plots_R_scripts/Figure10_Plots_R_scripts.R`: R script to plot Figure 10.  
Note: Open the `run1.RData` file first, then run this script. It uses the saved workspace variables.  
- `results/output_files_R_scripts/Output_Files_R_scripts.R`: R script to generate `.csv` files containing the inversion results.  
Note: Open the `run1.RData` file first, then run this script. It uses the saved workspace variables.
- `results/figure11_plot_R_scripts/ReadData_MSE_Plot`: R script to plot Figure 8.  
Note: The script contains paths that must be updated to match your system before running.
Description: The input files are located in `results/figure11_plot_R_scripts/ReadData_MSE_Plot/H_Ro_Results` folder that contains
`.csv` files containing the inversion results using various combinations of reference Moho depth (h<sub>0</sub>) and density contrast (Δρ).
They are named in the format `Result_h0_Δρ.csv.`.
The input file `Moho_Makran_2018_1deg.txt` is the previously obtained Moho depths from [Abdollahi et al. (2018)](https://doi.org/10.1016/j.tecto.2018.10.005). 
- `results/figure11a_map_GMT_scripts/a_map.bat`: GMT script to map the estimated Moho depths (Figure 11a).
- `results/figure11b_map_GMT_scripts/b_map.bat`: GMT script to map the Moho depths obtained by [Abdollahi et al. (2018)](https://doi.org/10.1016/j.tecto.2018.10.005)  (Figure 11b).
- `results/figure11c_map_GMT_scripts/c_map.bat`: GMT script to map the comparison of the reference Moho depths with the estimated values (Figure 11c).
- `results/figure11d_map_R_scripts/ReadData_Cal_Differences.R`: R script to plot histogram of the differences between the reference and the estimated Moho depths
   (Figure 11d).

### Usage
1- run `R_scripts/Inversion_Hybrid_Main_Code.R`
- **Input:** `data/SatCBA.csv`,`data/Model_Coordinates.csv`
- **Output:** log folder including `.log`, `.RData`, and `.pdf` files. `.RData` saves all inversion results.

2- run `results/output_files_R_scripts/Output_Files_R_scripts.R`

Note: Open the output `.RData` workspace file before running
- **Output:** `Caculated_Data.csv`, `Data_Residuals.csv`, and `Estimated_Moho_Depths.csv`

3-  run `results/figure8_plot_R_scripts/ReadData_MSE_Plot`  
   - **Input:** `.csv` files in `results/figure11_plot_R_scripts/ReadData_MSE_Plot/H_Ro_Results/` (named as `Result_h0_Δρ.csv`)  
   and`Moho_Makran_2018_1deg.txt` from [Abdollahi et al. (2018)](https://doi.org/10.1016/j.tecto.2018.10.005)

4- run `data/figure9a_map_GMT_scripts/a_map`
- **Input:** `a.txt` that is the txt file of `SatCBA.csv`.

5- run `results/figure9b_map_GMT_scripts/b_map.bat` 
- **Input:** `b.txt` that is the txt file of `Estimated_Moho_Depths.csv`.

6- run `results/figure9c_map_GMT_scripts/c_map.bat`
- **Input:** `c.txt` that is the txt file of `Caculated_Data.csv`.

7- run `results/figure9d_map_GMT_scripts/d_map.bat`
- **Input:** `d.txt` that is the txt file of `Data_Residuals.csv`.

8- run `results/figure10_plots_R_scripts/Figure10_Plots_R_scripts.R`  

Note: Open the output `.RData` workspace file before running

9- run `results/figure11a_map_GMT_scripts/a_map.bat`
- **Input:** `a.txt` that is the txt file of `Estimated_Moho_Depths.csv`.

10- run `results/figure11b_map_GMT_scripts/b_map.bat` 
- **Input:** `Moho_Makran_2018_1deg.txt` that is the previously obtained Moho depths from [Abdollahi et al. (2018)](https://doi.org/10.1016/j.tecto.2018.10.005). 

11- run `results/figure11d_map_R_scripts/ReadData_Cal_Differences.R`
- **Input:** `Moho_Makran_2018_1deg.txt`, `Result_35_500.csv` to calculate the differences between the reference -the previously obtained Moho depths from [Abdollahi et al. (2018)](https://doi.org/10.1016/j.tecto.2018.10.005)- and our estimated Moho depths. Then the script plots the histogram of Moho depth differences.
  
12- run `results/figure11c_map_GMT_scripts/c_map.bat`
- **Input:** `resid.txt` that is the txt file of `resid.csv` containing the differences between the reference (the previously obtained Moho depths from [Abdollahi et al. (2018)](https://doi.org/10.1016/j.tecto.2018.10.005) and our estimated Moho depths.


 ## Reproducibility Note  

- The results obtained from the inversion process can vary due to the random nature of the hybrid DE/PSO metaheuristic algorithm.  
Since no fixed seed was set, running the inversion code multiple times may lead to slightly different outcomes, such as variations in the estimated Moho depths
and residuals.

The exact figures and values presented in the paper can be reproduced using the provided `.csv`, `.RData`, and output files included in this folder.
