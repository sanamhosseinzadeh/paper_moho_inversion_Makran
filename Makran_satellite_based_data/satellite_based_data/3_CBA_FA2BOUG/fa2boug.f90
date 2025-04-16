!  PROGRAM FA2Boug.f:
!  Fortran 90 code to calculate Bouguer anomaly applying
!  Bullard A, B and C corrections to a Free Air (FA)/slab-corrected
!  Bouguer anomaly grid, provided an extra grid with elevation
!  (topo/bathymetry)
!  The program can calculate Bouguer anomaly in in either land or
! sea points
! Contributions to Bouguer anomaly are computed in different zones
! according the radial distance, R, to the calculation point:
! DISTANT ZONE:      (R_d>R>R_i)
! INTERMEDIATE ZONE: (R_i>R>del_xi/2)
! INNER ZONE:        (R<del_xi/2)
! Input files required by FA2Boug.f:
!  *parameters.dat
!  *topo_cart.xyz
!  *gravi_cart.xyz
! Output files are:
!  *bouguer.xyz
!  *bouguer_slab.xyz
! Optionally a detailed topography file, *topo_cart_det.xyz,
! with a gridstep del_xdet(<del_xi) can be provided. In that
! case, a new calculation is performed in the
! DETAILED INTERMEDIATE ZONE (del_xi/2>R>del_xdet/2), and
! the INNER ZONE is redefined as (R<del_xdet/2)
! Also optionally, the program calculate the isostatic residual
! anomaly using an Airy compensation model for the crust
! Written by Javier Fullea Urchulutegui
! Instituto de Ciencias de la Tierra Jaume Almera (CSIC)
! Sept 2007
!
     
      MODULE MOD_PARAM
      REAL(8), PARAMETER :: R_t=6370, G=6.67D-11, pi=4*atan(1.0d0)
      END MODULE
     
      MODULE MOD_EXPAN
      REAL(8) d_x,d_y,d_z,xc,yc,zc,Gp_as,d_rho
      END MODULE

      MODULE MOD_NEAR
      REAL(8) rad,d_h(2,2),G_cp,rho_w,rho_c,h
      END MODULE

      USE MOD_EXPAN
      USE MOD_NEAR
      USE MOD_PARAM
      

      REAL(8) del_xd,del_xi,cx,cy,del_xBg,R_d,R_i,del_xdet,del_x_pr
      REAL(8) AB
      REAL(8) x,y,z,del_g,Gpr,x1,y1,x2,y2,z1,z2,zm,E_pr
      REAL(8) L_x,L_y,BS
      REAL(8) BB,nu,al
      REAL(8) l_i1,l_i2,l_j1,l_j2,dm
      INTEGER N,M,k,l,IWIN_i,IWIN,rtio,rt,rt_i
      INTEGER l_lst,l_fst,k_lst,k_fst,up_INT
      INTEGER cont_x,cont_y,N_tot,N_nod,n_strg,slab_Boug
      REAL(8), ALLOCATABLE:: E(:,:),FA(:,:),E_det(:,:)
      CHARACTER(10), ALLOCATABLE:: FA_strg(:,:),E_det_strg(:,:),EE(:,:)
      CHARACTER(10) COORD,land
      REAL(8) a(3,3),R_i_L,R_i_R,R_i_D,R_i_U
      INTEGER det,N_det,M_det,IWIN_det
      LOGICAL det_on
      REAL(8) d_rho_mho,t,ISOS,z_cref

!//////////////////INPUT/////////////////////////////
      OPEN(1, file='parameters.dat', status='OLD')
      READ(1,'(I1)',ADVANCE='NO') det
      IF (det==1) THEN
       READ(1,*)del_xd,del_xi,del_xBg,rho_c,rho_w,N,M,R_d,R_i,land,slab_Boug,N_det,M_det,del_xdet
       write(*,*)del_xd,del_xi,del_xBg,rho_c,rho_w,N,M,R_d,R_i,land,slab_Boug,N_det,M_det,del_xdet
       ELSE
       READ(1,*)del_xd,del_xi,del_xBg,rho_c,rho_w,N,M,R_d,R_i,land,slab_Boug
      ENDIF
      CLOSE(1)
      
!Open INPUT files
      open(2,file='topo_cart.xyz', status='OLD')
      open(5,file='gravi_cart.xyz',status='OLD')
!Open detailed topography, if necessary
      IF (det==1) open(7,file='topo_cart_det.xyz', status='OLD')
!Open OUTPUT files
      open(15,file='bouguer.xyz',status='UNKNOWN')
      open(17,file='bouguer_slab.xyz',status='UNKNOWN')
!//////////////////INPUT/////////////////////////////

      write(*,*)''
      write(*,*)''
      write(*,*)'              ***FA2BOUG***'
      IF (land=='on') THEN
      write(*,*)'CALCULATES IN LAND AND SEA POINTS'
      ELSE
      write(*,*)'CALCULATES ONLY IN SEA POINTS'
      ENDIF
      write(*,*)''
      IF (slab_Boug==1) THEN
      write(*,*)'INPUT GRAVITY ANOMALY IS SLAB-CORRECTED BOUGUER'
      ELSE
      write(*,*)'INPUT GRAVITY ANOMALY IS FREE AIR'
      ENDIF
      IF (det==1) THEN
       write(*,*)'DETAILED TOPOGRAPHY ON'
      ELSE
       write(*,*)'DETAILED TOPOGRAPHY OFF'
      ENDIF


      IWIN=nint(R_d/del_xi)
      rtio=nint(del_xBg/del_xi)
      rt=nint(del_xd/del_xi)
      N_tot=N*M/rtio**2
!Dimensionate the elevation and FA matrices

      ALLOCATE(E(N,M),FA(N,M),FA_strg(N,M))
       IF (det==1) ALLOCATE(E_det(N_det,M_det),E_det_strg(N_det,M_det))

!Read elevation and FA files
!
      DO j=M,1,-1
       DO i=1,N
        read(2,*) E(i,j)
        read(5,*) FA_strg(i,j)
       ENDDO
      ENDDO
      REWIND (2)
!Read the detailed topography file (if present)
      IF (det==1) THEN
      call cpu_time(time1)
!Flag for NaN values
       E_det=-1D6
       DO j=M_det,1,-1
        DO i=1,N_det
        read(7,*) E_det_strg(i,j)
!        n_strg=iachar(E_det_strg(i,j))
        n_strg=ichar(E_det_strg(i,j)(1:1))
!Skips NaN and store only the numerical values (i.e. points
!where the detailed topography is present in the file topo_cart_det.xyz)
          IF ((n_strg<=47.OR.n_strg>57).AND.n_strg/=45) THEN
           CYCLE
          ELSE
           READ(E_det_strg(i,j),*)E_det(i,j)
          ENDIF
        ENDDO
       ENDDO
       DEALLOCATE(E_det_strg)
       call cpu_time(time2)
       write(*,*)'DETAILED TOPO READ, ELAPSED TIME:  ', time2-time1
       IWIN_det=nint((del_xi-del_xdet)/(2*del_xdet))
      ENDIF
      R_tl1=R_i*1D3*sqrt(2.)
      R_tl2=(R_d+1)*1D3*sqrt(2.)

!
! Loop for the FA anomaly grid
       WRITE(*,*)'%%%%%%%%%%%%%%%%%%'
       WRITE(*,*)'START CALCULATION'
       WRITE(*,*)'%%%%%%%%%%%%%%%%%%'
       cont_y=0
       DO j=M,1,-rtio
        cont_y=cont_y+1
        cont_x=0
        cy=(j-1)*del_xi
        DO i=1,N,rtio
         cont_x=cont_x+1
         cx=(i-1)*del_xi
!Percentage of program execution
         N_nod=(cont_y-1)*N/rtio+cont_x
         IF (N_nod==NINT(N_tot*.1)) THEN
         WRITE(*,*)'**10%**'
         ELSEIF (N_nod==NINT(N_tot*.3)) THEN
         WRITE(*,*)'****30%****'
         ELSEIF (N_nod==NINT(N_tot*.5)) THEN
         WRITE(*,*)'********50%********'
         ELSEIF (N_nod==NINT(N_tot*.9)) THEN   
         WRITE(*,*)'***********80%************'
         ENDIF

         IF (i<IWIN+1.OR.i>N-IWIN.OR. j<IWIN+1.OR.j>M-IWIN) CYCLE
!Elevation of the calculation point
         IF (det==1) THEN
          det_on=.TRUE.
          rt_i=nint(del_xi/del_xdet)
          IWIN_i=nint(R_i/del_xi)*rt_i
          rad=sqrt(2.)*del_xdet*1D3/2
          i_det=NINT((cx-R_d+R_i)/del_xdet)+1
          j_det=NINT((cy-R_d+R_i)/del_xdet)+1
           IF (E_det(i_det,j_det)==-1D6.OR. &
            E_det(i_det+IWIN_i,j_det)==-1D6.OR. &
            E_det(i_det-IWIN_i,j_det)==-1D6.OR. &
            E_det(i_det,j_det+IWIN_i)==-1D6.OR. &
            E_det(i_det,j_det-IWIN_i)==-1D6.OR. &
            E_det(i_det+IWIN_i,j_det+IWIN_i)==-1D6.OR. &
            E_det(i_det+IWIN_i,j_det-IWIN_i)==-1D6.OR. &
            E_det(i_det-IWIN_i,j_det+IWIN_i)==-1D6.OR. &
            E_det(i_det-IWIN_i,j_det-IWIN_i)==-1D6.OR. &
            h<0 ) det_on=.FALSE.
         ENDIF
! Elevation of the calculation point and parameters
!for the Intermediate zone
        IF (det==1.AND.det_on) THEN
         h=E_det(i_det,j_det)
        ELSE
         h=E(i,j)
         IWIN_i=nint(R_i/del_xi)
         rt_i=1
         rad=sqrt(2.)*del_xi*1D3/2
        ENDIF
!Skips land calculation if requiered
        IF (h>0.AND.land=='off') CYCLE
!Skips NaN (FA no-data points)
!       n_strg=iachar(FA_strg(i,j))
       n_strg=ichar(FA_strg(i,j)(1:1))
        IF ((n_strg<=47.OR.n_strg>57).AND.n_strg/=45) CYCLE
!Convert string to real
        READ(FA_strg(i,j),*)FA(i,j)

        IF (h<=0) THEN
        rho=rho_c-rho_w
        nu=-h/(R_t*1D3+h)
        zm=0D0
        ELSE
        rho=rho_c
        nu=h/(R_t*1D3+h)
        zm=h
        ENDIF
!Write simple Bouguer anomaly (i.e. only Bullard A correction)
        BS=(2*pi*G*rho*h)*1D5
!Starts the value of Bouguer Anomaly
         IF (slab_Boug==0) THEN
         AB=FA(i,j)
         WRITE(17,*)cx,cy,FA(i,j)-BS
         ELSE
         AB=FA(i,j)+BS
         WRITE(17,*)cx,cy,AB
         ENDIF
!Compute the curvature correction in mgal (Bullard B)
!using Whitman approximation (Whitman, Geophysics, 56 N12,
!pp 1980-1985,(1991))
        al=R_d/R_t
        BB=-2*pi*G*rho*h*(al/2-nu)*1D5
        AB=AB+BB
!Loop for the external square (length=2*R_d) Distant zone
!
!Find the  limits between the distant and intermediate zones
        l_i1=INT((i-NINT((R_i+del_xd*.5)/del_xi)))
        l_j1=INT((j-NINT((R_i+del_xd*.5)/del_xi)))
        l_i2=INT((i+NINT((R_i+del_xd*.5)/del_xi)))
        l_j2=INT((j+NINT((R_i+del_xd*.5)/del_xi)))
!The last and first nodes of the distant zone at each side of
!the calculation point (i,j)
        l_lst=i-IWIN+INT((l_i1-(i-IWIN))/rt)*rt
        l_fst=i+IWIN-INT(((i+IWIN)-l_i2)/rt)*rt
        k_lst=j-IWIN+INT((l_j1-(j-IWIN))/rt)*rt
        k_fst=j+IWIN-INT(((j+IWIN)-l_j2)/rt)*rt
!Limits R_i
       R_i_L=((i-l_lst)*del_xi-del_xd*.5)*1D3
       R_i_R=((l_fst-i)*del_xi-del_xd*.5)*1D3
       R_i_D=((j-k_lst)*del_xi-del_xd*.5)*1D3
       R_i_U=((k_fst-j)*del_xi-del_xd*.5)*1D3
      DO k=j-IWIN,j+IWIN,rt
       DO l=i-IWIN,i+IWIN,rt
!Select the DISTANT ZONE (R_d>R>R_i)
        IF (l<=l_i1.OR.l>=l_i2.OR.k<=l_j1.OR.k>=l_j2) THEN
!Onshore/offshore prism
            IF (E(l,k)>0) THEN
             d_rho=rho_c       
            ELSE
             d_rho=rho_c-rho_w
            ENDIF
!Vertical limits of the prism
            z1=zm
            z2=ABS(E(l,k)-zm)
!Sides of the prism
            d_x=del_xd*1D3
            d_y=del_xd*1D3
            d_z=z2-z1
!Cartesian coordinates of CM of the prism
            xc=abs((l-i)*del_xi)*1D3
            yc=abs((k-j)*del_xi)*1D3
            zc=(z1+z2)*.5
            CALL EXPAN
            AB=AB+Gp_as
        ENDIF
!END of the IF for the DISTANT ZONE (R_d>R>R_i)

       ENDDO
      ENDDO
!
!

!Loop for the internal square (length=2*R_i)
!INTERMEDIATE ZONE (R_i>R>del_xi/2)
      IF (det==1.AND.det_on) THEN
       I_in=i_det
       J_in=j_det
      ELSE
       I_in=i
       J_in=j
      ENDIF
      DO k=J_in-IWIN_i,J_in+IWIN_i,rt_i
       DO l=I_in-IWIN_i,I_in+IWIN_i,rt_i
!Onshore/offshore prism
            IF (det==1.AND.det_on) THEN
             E_pr=E_det(l,k)
             del_x_pr=del_xdet
            ELSE
             E_pr=E(l,k)
             del_x_pr=del_xi
            ENDIF

            IF (E_pr==-1D6) E_pr=zm   

            IF (E_pr>0) THEN
             d_rho=rho_c
            ELSE
             d_rho=rho_c-rho_w
            ENDIF
! Coordinates defining the Flat-Toped-Prism (in m)
      x1=((l-I_in)*del_x_pr-.5*del_xi)*1D3
      y1=((k-J_in)*del_x_pr-.5*del_xi)*1D3
      x2=((l-I_in)*del_x_pr+.5*del_xi)*1D3
      y2=((k-J_in)*del_x_pr+.5*del_xi)*1D3
!       write(*,*)'x1,x2',x1,x2
! Extend the prisms in the limit of the intermediate zone
! in order to fill the space between the two grids
       IF (l==I_in-IWIN_i) THEN
        IF(ABS(x1)>R_i_L.AND.ABS(x2)>R_i_L) CYCLE
        x1=-R_i_L
       ENDIF
       IF (l==I_in+IWIN_i) THEN
        IF(ABS(x2)>R_i_R.AND.ABS(x1)>R_i_R) CYCLE
        x2=R_i_R
       ENDIF
       IF (k==J_in-IWIN_i) THEN
        IF(ABS(y1)>R_i_D.AND.ABS(y1)>R_i_D) CYCLE
        y1=-R_i_D
       ENDIF
       IF (k==J_in+IWIN_i) THEN
        IF(ABS(y2)>R_i_U.AND.ABS(y1)>R_i_U) CYCLE
        y2=R_i_U
       ENDIF
        z1=zm
        z2=ABS(E_pr-zm)
        IF (det==1.AND.det_on.AND.k==j_det.AND.l==i_det) CYCLE
        CALL atrac_prisma(x1,x2,y1,y2,z1,z2,d_rho,Gpr)
        AB=AB+Gpr
!
       ENDDO
      ENDDO
!
! Calculate using the detailed topography
      IF (det==1.AND.det_on) THEN
       DO jj=j_det-IWIN_det,j_det+IWIN_det
        DO ii=i_det-IWIN_det,i_det+IWIN_det
         d_rho=rho_c
! Coordinates defining the Flat-Toped-Prism (in m)
         x1=((ii-i_det)-.5)*del_xdet*1D3
         y1=((jj-j_det)-.5)*del_xdet*1D3
         x2=((ii-i_det)+.5)*del_xdet*1D3
         y2=((jj-j_det)+.5)*del_xdet*1D3
         z1=zm
         z2=ABS(E_det(ii,jj)-zm)
! Extend the prisms in the limit in order to fill the space
! between the two grids
      IF (ii==i_det-IWIN_det) x1=x1-(del_xi*.5-del_xdet*(IWIN_det+.5))  &
            *1D3
      IF (ii==i_det+IWIN_det) x2=x2+(del_xi*.5-del_xdet*(IWIN_det+.5))  &
            *1D3
      IF (jj==j_det-IWIN_det) y1=y1-(del_xi*.5-del_xdet*(IWIN_det+.5))  &
            *1D3
      IF (jj==j_det+IWIN_det) y2=y2+(del_xi*.5-del_xdet*(IWIN_det+.5))  &
             *1D3
         CALL atrac_prisma(x1,x2,y1,y2,z1,z2,d_rho,Gpr)
         AB=AB+Gpr
        ENDDO
       ENDDO
      ENDIF
!
! Compute Bullard C correction in the NEAR ZONE (R<del_xi/2 or del_xdet/2)
       DO ih=1,3
        DO ik=1,3
         IF (det==1.AND.det_on) THEN
          a(ih,ik)=E_det(i_det+ih-2,j_det+ik-2)
         ELSE
          a(ih,ik)=E(i+ih-2,j+ik-2)
         ENDIF
        ENDDO
       ENDDO

        d_h(1,1)=SUM(a(1:2,1:2))/4-h
        d_h(1,2)=SUM(a(1:2,2:3))/4-h
        d_h(2,1)=SUM(a(2:3,1:2))/4-h
        d_h(2,2)=SUM(a(2:3,2:3))/4-h

        IF (det==1.AND.det_on) THEN
         rad=sqrt(2.)*del_xdet*1D3/2       
        ELSE
         rad=sqrt(2.)*del_xi*1D3/2
        ENDIF
       CALL NEAR
       AB=AB+G_cp
!
! Write Bouguer anomaly value
       write(15,*)cx,cy,AB
      ENDDO
      ENDDO
! End of loop for the FA anomaly grid

!
      L_x=cont_x*rtio*del_xi
      L_y=cont_y*rtio*del_xi

      OPEN(1, file='lat_ex.dat', status='UNKNOWN')
      WRITE(1,*) L_x,L_y,rtio*del_xi
      CLOSE(1)
      write(*,*)'*****************************'
      write(*,*)'BOUGUER ANOMALY CALCULATED'
      write(*,*)'*****************************'
      DEALLOCATE (E,FA,FA_strg)
      IF (det==1) DEALLOCATE (E_det)
      CLOSE(15)
      CLOSE(17)

      STOP
      END


      INTEGER FUNCTION up_INT(n)
      REAL(8) :: n
       IF (INT(n)-n==0) THEN
        up_INT=INT(n)
       ELSE
        up_INT=INT(n)+1
       ENDIF
      END FUNCTION

      SUBROUTINE EXPAN
! Calculates the vertical atraction of a rigth rectangular
! prism considering an spherical harmonic expansion (Mc Millan, 1958)
! to order 1/r**6, being r the distance between the Mass Centre (MC)
! of the prism and the calculation point
! The result is expresed in mgal=1e-5m/s²
      USE MOD_EXPAN
      USE MOD_PARAM
      REAL(8) ax,ay,az,ra,Gp,rh
            IF (zc==0) THEN
            Gp_as=0D0
            RETURN
            ENDIF
!  Distance to MC of the prism (m)
            ra=sqrt(xc**2+yc**2+zc**2)
!  Parámeters of the power expansion
            ax=(2*d_x**2-d_y**2-d_z**2)*xc**2
            ay=(2*d_y**2-d_x**2-d_z**2)*yc**2
            az=(2*d_z**2-d_y**2-d_x**2)*zc**2
		  Gp=(G*d_rho*d_x*d_y*d_z*zc)/(ra**3)
            Gp_as=(Gp+(ax+ay+az*(1-2*ra**2/(5*zc**2)))*5*G*d_rho* &
             d_x*d_y*d_z*zc/(24*ra**7))*1D5
      END SUBROUTINE

      SUBROUTINE atrac_prisma(x1,x2,y1,y2,z1,z2,d_r,g_z)
      USE MOD_PARAM
! Calculates the vertical atraction, g_z, of rigth rectangular
! prism of density d_r, defined by the coordinates of its six
! vertex x1,x2,y1,y2,z1,z2 (Nagy et al., J Geodesy 2000, 74)
! All input units must be referred to SI (m,kg/m³,m/s²).
! Output is in mgal (1 mgal=1e-5 m/s²)

      REAL(8) x1,x2,y1,y2,z1,z2,d_r,x(2),y(2),z(2),v,g_z
      INTEGER i,j,k,sgn

      x(1)=x1
      x(2)=x2
      y(1)=y1
      y(2)=y2
      z(1)=z1
      z(2)=z2

      v=0
      do i=1,2
       do j=1,2
        do k=1,2

        sgn=(-1)**(i+j+k+1)
        r=sqrt(x(i)**2+y(j)**2+z(k)**2)
     
        if ((x(i)==0).AND.(y(j)==0).AND.(z(k)==0)) then
         g_z=0
        elseif ((x(i)==0).AND.(y(j)==0)) then
         g_z=-z(k)*atan(x(i)*y(j)/(z(k)*r))*sgn
        elseif (((x(i)==0).AND.(z(k)==0))) then
         g_z=y(j)*log(abs(y(j)))*sgn
        elseif ((y(j)==0).AND.(z(k)==0)) then
         g_z=x(i)*log(abs(x(i)))*sgn
        elseif ((z(k)==0)) then
         g_z=(x(i)*log(y(j)+r)+y(j)*log(x(i)+r))*sgn
        else
        g_z=x(i)*log(y(j)+r)+y(j)*log(x(i)+r)-z(k)*atan(x(i)*y(j)/(z(k)* &
            r))
        g_z=g_z*sgn
        endif
        v=v+g_z
       
        enddo
       enddo
      enddo

      g_z=v*d_r*G*1D5
      END SUBROUTINE 

      SUBROUTINE NEAR
! Calculates the vertical atraction of four
! quadrants of a conic prism which slope continuously from
! the vertex of the near zone to the calculation point.
! If the calculation point is near the coast line,i.e., E and h
! have different signs, the quarter of the conic prism is splitted in
! three parts (see Fullea et al., Comp & Geosc)
! The result is expresed in mgal=1e-5m/s²
      USE MOD_PARAM     
      USE MOD_NEAR
      REAL(8) root,g_cp1,g_cp2,g_c,d_r,gdm
       G_cp=0     
       DO i=1,2
        DO j=1,2
        root=SQRT(rad**2+d_h(i,j)**2)
        gdm= pi*G*rad*(root-rad)/(2*root)
        IF (h>0.AND.d_h(i,j)+h>0) THEN
        d_r=rho_c
        G_cp=G_cp+gdm*d_r
        ELSEIF(h<0.AND.d_h(i,j)+h<0) THEN
        d_r=rho_c-rho_w
         IF (d_h(i,j)>0) THEN
         G_cp=G_cp-gdm*d_r
         ELSE
         G_cp=G_cp+gdm*d_r
         ENDIF
        ELSE
        g_cp1=-(h/d_h(i,j))*gdm
        g_cp2=(pi*G/(2*d_h(i,j)))*(-rad**2*(d_h(i,j)+h)/root+d_h(i,j)* &
            sqrt(rad**2+h**2)+h*root)

        g_c=pi*G*(rad*(d_h(i,j)+h)-d_h(i,j)*sqrt(rad**2+h**2)  &
            -h*root)/(2*d_h(i,j))
         IF (h>0.AND.d_h(i,j)+h<0) THEN
             G_cp=G_cp+g_cp1*rho_c+g_cp2*(rho_c-rho_w)+g_c*rho_c
         ELSEIF (h<0.AND.d_h(i,j)+h>0) THEN
             G_cp=G_cp-g_cp1*(rho_c-rho_w)+g_cp2*rho_c-g_c*(rho_c-rho_w)
         ENDIF
        ENDIF 

        ENDDO
       ENDDO
! Convert to mgals
        G_cp=G_cp*1D5

      END SUBROUTINE
