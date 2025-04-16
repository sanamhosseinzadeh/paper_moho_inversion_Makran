# Folder Structure and File Descriptions

This folder contains the datasets and software codes used in the section titled **Moho Depth in the Makran Zone, SE Iran** of the paper. 
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
- `results/figure11_plot_R_scripts/ReadData_MSE_Plot`: R script to plot Figure 11.  
Note: The script contains paths that must be updated to match your system before running.
Description: The input files are located in `results/figure11_plot_R_scripts/ReadData_MSE_Plot/H_Ro_Results` folder that contains
`.csv` files containing the inversion results using various combinations of reference Moho depth (h<sub>0</sub>) and density contrast (Δρ).
They are named in the format `Result_h0_Δρ.csv.`.
The input file `Moho_Makran_2018_1deg.txt` is the previously obtained Moho depths from [Abdollahi et al. (2018)](https://doi.org/10.1016/j.tecto.2018.10.005). 
- `results/figure12a_map_GMT_scripts/a_map.bat`: GMT script to map the estimated Moho depths (Figure 12a).
- `results/figure12b_map_GMT_scripts/b_map.bat`: GMT script to map the Moho depths obtained by [Abdollahi et al. (2018)](https://doi.org/10.1016/j.tecto.2018.10.005)  (Figure 12b).
- `results/figure12c_map_GMT_scripts/c_map.bat`: GMT script to map the comparison of the reference Moho depths with the estimated values (Figure 12c).
- `results/figure12d_map_R_scripts/ReadData_Cal_Differences.R`: R script to plot histogram of the differences between the reference and the estimated Moho depths
   (Figure 12d).
  
 ## Reproducibility Note  

- The results obtained from the inversion process can vary due to the random nature of the hybrid DE/PSO metaheuristic algorithm.  
Since no fixed seed was set, running the inversion code multiple times may lead to slightly different outcomes, such as variations in the estimated Moho depths
and residuals.

The exact figures and values presented in the paper can be reproduced using the provided `.csv`, `.RData`, and output files included in this folder.
