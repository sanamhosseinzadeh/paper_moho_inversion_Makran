clear all; close all; clc;

% Constants
pi_val = pi;
Nombre = 45448;

a_model = 0.6378136460E+07;
GM = 0.3986004415E+15;
r1 = 0.6378136460E+07;
a_r = a_model / r1;

% Constants of enhanced WGS84 reference ellipsoid
a2 = 6378137;
GM2 = 0.3986004418E+15;
f2 = 1/298.257223563;
w2 = 7292115E-11;
gama_a = 9.7803253359;
m2 = 0.00344978650684;
h2 = 0;
gama_0 = GM2 / a2^2;

% Load geopotential coefficients
model_mtrice = load('Sat_M_corrected.dat');

% Output file
fid = fopen('FAA.dat','w');

% Loop over region (Iran region example)
for ph = 32:-1:21
    phi = ph * pi_val / 180;
    theta = sin(phi);
    for la = 51:1:68
        lambda = la * pi_val / 180;

        % Geocentric calculations
        H = 0;
        e2 = 2*f2 - f2^2;
        N2 = a2 / sqrt(1 - e2 * sin(phi)^2);
        x = (N2 + H) * cos(phi) * cos(lambda);
        y = (N2 + H) * cos(phi) * sin(lambda);
        z = (N2 * (1 - e2) + H) * sin(phi);
        R = sqrt(x^2 + y^2 + z^2);
        w = atan(z / sqrt(x^2 + y^2));
        X1 = sin(w);

        % Gravity anomaly
        dg = 0;
        for i2 = 1:Nombre
            j = model_mtrice(i2,1);
            m = model_mtrice(i2,2);
            Cjm = model_mtrice(i2,3);
            Sjm = model_mtrice(i2,4);

            cos_ml = cos(m * lambda);
            sin_ml = sin(m * lambda);

            Pnm = Pnm_normalise(j, m, X1);
            dg = dg + (j - 1) * (a_r^j) * (Cjm * cos_ml + Sjm * sin_ml) * Pnm;
        end

        dg = dg * (GM / r1^2);
        faa = dg * 1.0e+5;  % Convert to mGal

        fprintf(fid, '%.6f %.6f %.6f\n', lambda * 180/pi_val, phi * 180/pi_val, faa);
    end
end

fclose(fid);
