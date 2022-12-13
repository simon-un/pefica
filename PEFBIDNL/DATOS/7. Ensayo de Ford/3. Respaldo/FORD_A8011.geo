// Gmsh project created on Wed Oct 31 11:07:05 2018
// longitudes en m y fuerzas en kN
lc=0.0003;
Point(1) = {0, 0, 0, lc};
Point(2) = {0.012,0, 0, lc};
Point(3) = {0.012,0.001915, 0, lc};
Point(4) = {0.006,0.001915, 0, lc/7};
Point(5) = {0,0.001915, 0, lc};
Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 5};
Line(5) = {5, 1};
Curve Loop(1) = {1, 2, 3, 4, 5};
Plane Surface(1) = {1};
Physical Curve("DISP UY=0") = {1};
Physical Curve("DISP UX=0") = {5};
Physical Surface("CATE EYOU=6.86E7 POIS=0.345 GAMM=0 TESP=0.02957 TIPR=21 EPLA=4.55E5 SIGY=120E3 TYMO=21") = {1};
Physical Curve("DISP UY=-1E-7", 7) = {4};
Physical Curve("CURV HO=UY VE=FY") = {4};

