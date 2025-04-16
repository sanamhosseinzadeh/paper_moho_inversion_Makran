# Set parameters
set lon_min_ext=53
set lon_max_ext=66
set lat_min_ext=23
set lat_max_ext=30

set lon_min2=53.5
set lon_max2=65.5
set lat_min2=23.5
set lat_max2=29.5

set psfile=c.ps

# Set GMT settings
gmtset PROJ_LENGTH_UNIT i
gmtset FONT_LABEL 12 FONT_TITLE 14
gmtset FONT_ANNOT_PRIMARY 10 FONT_ANNOT_SECONDARY 12
gmtset MAP_TITLE_OFFSET 0.1i MAP_LABEL_OFFSET 1p MAP_ANNOT_OFFSET_PRIMARY 1p
gmtset MAP_LABEL_OFFSET 1p MAP_ANNOT_OFFSET_PRIMARY 1p

# Define parameters for GMT commands
set i2=-I1
set r2=-R%lon_min2%/%lat_min2%/%lon_max2%/%lat_max2%r
set r=-Rd%lon_min_ext%/%lat_min_ext%/%lon_max_ext%/%lat_max_ext%r
set s=-JM3.9
set scalpos=-D4.2/1.15/2.3/0.3c

# Use grd2cpt to create c.cpt
grd2cpt c.grd -V %r2% -Cjet -Z > c.cpt

# Plot map
grdimage c.grd %s% %r% -Cc.cpt -K -P -V -B1g1WNes:.c: > %psfile%
pscoast %r% %s% -Dh -I1/1p,blue -A1000 -O -K -W1p >> %psfile%
gmtset MAP_LABEL_OFFSET 3p MAP_ANNOT_OFFSET_PRIMARY 2p
psscale %scalpos% -Cc.cpt -Ba5::/:km: -O -E -I >> %psfile%

# Convert to raster format
gmt ps2raster %psfile% -A -Tg
gmt convert %psfile% -A -Tg
