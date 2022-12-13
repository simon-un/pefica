// Gmsh project created on Wed Oct 31 11:07:05 2018
// longitudes en m y fuerzas en kN
lc=4.0;
Point(1) = {0, 0, 0, lc};
Point(2) = {0.012,0, 0, lc};
Point(3) = {0.012,0.00225, 0, lc};
Point(4) = {0.006,0.00225, 0, lc};
Point(5) = {0,0.00225, 0, lc};
Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 5};
Line(5) = {5, 1};
Curve Loop(1) = {1, 2, 3, 4, 5};
Plane Surface(1) = {1};
Physical Curve("DISP UY=0") = {1};
Physical Curve("DISP UX=0") = {5};
Physical Surface("CATE EYOU=20E6  POIS=0.25 GAMM=23 TESP=1.0 TIPR=21 EPLA=0 SIGY=1E2 TYMO=21") = {1};
//+
Physical Curve("PRES WY=-1", 7) = {4};
//+
MeshSize {1, 2, 3} = 0.0003;
MeshSize {4, 5} = 0.0001;
