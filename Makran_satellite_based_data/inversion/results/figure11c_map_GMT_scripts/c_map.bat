# Set parameters
set lon_min_ext=53
set lon_max_ext=66
set lat_min_ext=23
set lat_max_ext=30

set psfile=c.ps

# Set GMT settings
gmtset PROJ_LENGTH_UNIT i
gmtset FONT_LABEL 12 FONT_TITLE 14
gmtset FONT_ANNOT_PRIMARY 10 FONT_ANNOT_SECONDARY 12
gmtset MAP_TITLE_OFFSET 0.1i MAP_LABEL_OFFSET 1p MAP_ANNOT_OFFSET_PRIMARY 1p
gmtset MAP_LABEL_OFFSET 1p MAP_ANNOT_OFFSET_PRIMARY 1p

# Define parameters for GMT commands
set i2=-I1
set r=-Rd%lon_min_ext%/%lat_min_ext%/%lon_max_ext%/%lat_max_ext%r
set s=-JM3.9
set scalpos=-D4.2/1.15/2.3/0.3c

makecpt -Cjet -T-10/10/2.5 > c.cpt

 psxy Zagros.txt  %s% %r%  -W0.3/0/0/0 -G0/0/0   -Sf0.2i/0.09i+l+t -V -K > %psfile%
 psxy MAKRAN_trench.txt %s% %r%  -W0.3/0/0/0 -G0/0/0 -Sf0.2i/0.09i+l+t -O -V -K >> %psfile%
 psxy MINAB_fault.txt %s% %r% -W0.3/0/0/0 -G0/0/0 -Sf8/.08rs:0.5 -O -V -K >> %psfile%
 psxy mountain.txt %r% %s% -W0.2/0/0/0 -G0/0/0  -St0.05 -O -V -K >>  %psfile%

pscoast %r% %s% -A1000 -Dh -I1/1p,blue -O -K -W1p -B1WNes:.c: >> %psfile%
psxy resid.txt %r% %s% -Sc0.08 -W0.1/0/0/0 -Cc.cpt -O -K -V >> %psfile%

gmtset MAP_LABEL_OFFSET 3p MAP_ANNOT_OFFSET_PRIMARY 2p
psscale %scalpos% -Cc.cpt -Ba5::/:km: -O -E -I >> %psfile%

# Convert to raster format
gmt ps2raster %psfile% -A -Tg
gmt convert %psfile% -A -Tg -P
