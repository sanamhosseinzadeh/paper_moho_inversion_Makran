set lon_min_ext=53
set lon_max_ext=66
set lat_min_ext=23
set lat_max_ext=30

set lon_min=53
set lon_max=66
set lat_min=23
set lat_max=30

set psfile=f.ps

gmtset PROJ_LENGTH_UNIT i
gmtset FONT_LABEL 12 FONT_TITLE 14
gmtset FONT_ANNOT_PRIMARY 10 FONT_ANNOT_SECONDARY 12
gmtset MAP_TITLE_OFFSET 0.1i MAP_LABEL_OFFSET 1p MAP_ANNOT_OFFSET_PRIMARY 1p
gmtset MAP_LABEL_OFFSET 1p MAP_ANNOT_OFFSET_PRIMARY 1p

set i=-I0.2
set r_proj=-Rd%lon_min%/%lat_min%/%lon_max%/%lat_max%r
set r1=-R%lon_min%/%lat_min%/%lon_max%/%lat_max%r
set r=-Rd%lon_min_ext%/%lat_min_ext%/%lon_max_ext%/%lat_max_ext%r
set s=-JM3.9
set scalpos=-D4.2/1.15/2.3/0.3c

blockmean f.txt %i% %r1% -h1 -V > scratch
surface scratch -Gf.grd %i% %r1% -Lud -T0.3 -Lld -V -h1
makecpt -Cjet -T-0.001/0.001/0.00025 -Z > f.cpt
grdview f.grd %s% %r1% -Cf.cpt -Qi -X2 -Y7 -K -P -V -B1WNes:.f:  > %psfile%

pscoast %r% %s% -A1000 -Dh -I1/1p,blue -O -K -W1p >> %psfile%
gmtset MAP_LABEL_OFFSET 3p
gmtset MAP_ANNOT_OFFSET_PRIMARY 2p
psscale %scalpos% -Cf.cpt -Ba0.0005::/:mGal: -O -E -I >> %psfile%

gmt ps2raster %psfile% -A -Tg
gmt convert %psfile% -A -Tg

