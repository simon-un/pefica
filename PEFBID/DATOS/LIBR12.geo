lc=0.05;
Point(1) = {0, 0, 0, lc};
Point(2) = {0.40, 0, 0, lc};
Point(3) = {0.4, 0.2, 0, lc};
Point(4) = {0.75, 0.4, 0, lc};
Point(5) = {0.75, 0.7, 0, lc};
Point(6) = {0.4, 0.7, 0, lc};
Point(7) = {0.4, 0.9, 0, lc};
Point(8) = {0, 0.9, 0, lc};
Point(9) = {0.6, 0.7, 0, lc};
Point(10) = {0.7, 0.7, 0, lc};
Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 5};
Line(5) = {5, 10};
Line(6) = {10, 9};
Line(7) = {9, 6};
Line(8) = {6, 7};
Line(9) = {7, 8};
Line(10) = {8, 1};
Curve Loop(1) = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
Plane Surface(1) = {1};
Physical Curve("DISP UX=0 UY=0") = {1, 9};
Physical Curve("PRES WY=-2500") = {6};
Physical Surface("CATE EYOU=20E6  POIS=0.25 GAMM=0.0 TESP=0.4 TIPR=20") = {1};
