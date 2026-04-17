// Gmsh project created on Wed Oct 31 11:07:05 2018
// longitudes en m y fuerzas en kN
SetFactory("Opencascade");
lc=4.0;
Point(1) = {0, 0, 0, lc};
Point(6) = {0.1625,3.90, 0, lc};
Point(5) = {0.1625,10.30, 0, lc};
Point(4) = {1.6425,10.30, 0, lc};
Point(3) = {2.2005,6.65, 0, lc};
Point(2) = {7.02,0, 0, lc};
Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 5};
Line(5) = {5, 6};
Line(6) = {6, 1};
Curve Loop(1) = {1, 2, 3, 4, 5, 6};
Plane Surface(1) = {1};
Physical Curve("DISP UX=0 UY=0") = {1};
Physical Point("CURV HO=UX VE=FX") = {5};
Physical Curve("PRES GAWA=9.80 HEWA=10") = {5, 6};
Physical Surface("CATE EYOU=400E3 POIS=0.3 GAMM=13 TESP=1 TIPR=21 EPLA=0 SIGY=1.5E3 TYMO=21") = {1};
Physical Curve("PRES WX=9.80", 7) = {5, 6};
MeshSize {1, 2, 3, 4, 5, 6} = 0.3;
