set psfile=Figure1.ps
set region=-R30/70/15/50
set projection=-JM5
set proj=-JM9
set reg_mak=-R53/66/23/30
set scalpos=-D4.5/-0.5/6/0.25h

gmtset FONT_ANNOT_PRIMARY 10 FONT_ANNOT_SECONDARY 12

makecpt -Cglobe -T-4500/4500/500 -Z > topo_globe.cpt

pscoast %region% %projection% -A1000 -Dh -W0.5p -B5/5::WNes -N1/0.5p,red -V -K > %psfile%

rem Drawing the profile line
project -C53/23 -E66/23 -G0.01 > track1.txt
psxy track1.txt %region% %projection%  -W0.5/0/0/0 -G0/0/0  -O -V -K >> %psfile%
project -C23/66 -E30/66 -G0.01 > track2.txt
psxy -: track2.txt %region% %projection%  -W0.5/0/0/0 -G0/0/0  -O -V -K >> %psfile%
project -C66/30 -E53/30 -G0.01 > track3.txt
psxy track3.txt %region% %projection%  -W0.5/0/0/0 -G0/0/0  -O -V -K >> %psfile%
project -C30/53 -E23/53 -G0.01 > track4.txt
psxy -: track4.txt %region% %projection%  -W0.5/0/0/0 -G0/0/0  -O -V -K >> %psfile%

grdimage topo.nc -Ctopo_globe.cpt %reg_mak% %proj% -X6.7 -Y0.8 -O -V -K >> %psfile%

psxy Zagros.txt  %reg_mak% %proj%  -W1/0/0/0 -G0/0/0   -Sf0.3i/0.09i+l+t -O -V -K >> %psfile%
psxy MAKRAN_trench.txt %reg_mak% %proj%  -W1/0/0/0 -G0/0/0   -Sf0.3i/0.09i+l+t -O -V -K >> %psfile%
psxy MINAB_fault.txt %reg_mak% %proj%  -W0.3/0/0/0 -G0/0/0 -Sf8/.3rs:0.6  -O -V -K >> %psfile%
psxy mountain.txt %reg_mak% %proj% -W0.2/0/0/0 -G0/0/0  -St0.15 -O -V -K >> %psfile%

pscoast %reg_mak% %proj% -A1000 -Dh -I1/1p,blue -B1/1::WNes -W1p -O -V -K >> %psfile%

echo 63.675 24.987 | psxy %reg_mak% %proj% -Sa0.3c -Gred  -O -K -W0.09p >> %psfile%
echo 61.996 28.033 | psxy %reg_mak% %proj% -Sa0.23c -Gred -O -K -W0.09p >> %psfile% 

echo 63.95  24.9 5 0 1 1 Mw 8.1 | pstext %reg_mak% %proj% -V -O -K >> %psfile%
echo 62.05  28.12 5 0 1 1 Mw 7.7 | pstext %reg_mak% %proj% -V -O -K >> %psfile%

pstext name.txt %reg_mak% %proj%  -K -O -V >> %psfile%

psscale %scalpos% -Ctopo_globe.cpt -Ba2000::/:m: -I0.5 -O >> %psfile%

gmt convert  %psfile% -A+s5c -Tg
gmt ps2raster %psfile% -A -P -Tg
