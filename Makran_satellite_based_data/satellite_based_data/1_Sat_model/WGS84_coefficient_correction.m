clc
clear all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description:
% This code removes the normal gravity field (WGS84 ellipsoid) 
% contribution from the input geopotential coefficients, resulting in 
% the anomaly field. Only the zonal (m=0) coefficients up to degree 20 
% are corrected here. This is often used in geoid computations or
% gravity anomaly analysis.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Reference ellipsoid parameters (WGS84):
GM     = 3.986004415e+14;    % Gravitational parameter of Earth model [m^3/s^2]
r      = 6.37813646e+06;     % Earth radius used in the current geopotential model [m]

% Normal gravity field parameters (WGS84 Reference)
GM_N   = 3.986004418e+14;    % Normal gravitational parameter [m^3/s^2]
a_N    = 6.378137e+06;       % Semi-major axis of WGS84 ellipsoid [m]

% Read the geopotential model file (assumed to contain: n, m, Cnm, Snm)
model = readmatrix('Sat_M.dat'); 
[n, l] = size(model);  % n: number of rows, l: number of columns

% Loop through all coefficients to apply corrections for zonal terms (m = 0)
for ii = 1:n
    n_degree = model(ii,1);  % Spherical harmonic degree (n)
    m_order  = model(ii,2);  % Spherical harmonic order (m)

    if m_order == 0  % Only apply correction to zonal terms (m = 0)

        % Define corresponding Cbar (normal zonal coefficient) from WGS84
        switch n_degree
            case 2
                Cbar = -4.841667749835220e-04;
            case 4
                Cbar = 7.903037335100000e-07;
            case 6
                Cbar = -1.687249611513883e-09;
            case 8
                Cbar = 3.460524683954118e-12;
            case 10
                Cbar = -2.650022257475667e-15;
            case 12
                Cbar = -4.1079014018568e-17;
            case 14
                Cbar = 4.4717735634512e-19;
            case 16
                Cbar = -3.4636256435927e-21;
            case 18
                Cbar = 2.4114560299700e-23;
            case 20
                Cbar = -1.6024329272168e-25;
            otherwise
                Cbar = 0;  % Skip degrees not defined in the WGS84 normal field
        end

        % Apply correction to the Cnm coefficient
        model(ii,3) = model(ii,3) - ((GM_N / GM) * (a_N / r)^n_degree) * Cbar;
    end
end

% Save corrected model
writematrix(model, 'Sat_M_corrected.dat', 'delimiter', 'tab');

