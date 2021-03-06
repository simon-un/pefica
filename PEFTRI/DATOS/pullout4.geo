// Gmsh project created on Thu Jun 27 07:47:36 2019
SetFactory("OpenCASCADE");
//+
lf=2.0;
lm=2*lf;
lc=4*lf;
//+
Point(1) = {0, -0, 0, lc};
//+
Point(2) = {70, 0, 0, lc};
//+
Point(3) = {70, 60, 0, lc};
//+
Point(4) = {45, 60, 0, lm};
//+
Point(5) = {36, 60, 0, lm};
//+
Point(6) = {6, 60, 0, lm};
//+
Point(7) = {5, 60, 0, lm};
//+
Point(8) = {0, 60, 0, lm};
//+
Point(9) = {0, 24, 0, lf};
//+
Point(10) = {15, 24, 0, lf};
//+
Point(11) = {5, 30, 0, lf};
//+
Point(12) = {6, 30, 0, lf};
//+
Point(13) = {15, 30, 0, lf};
//+
Point(14) = {0, 30, 0, lf};
//+
Point(18) = {0, 23, 0, lc};
//+
Point(19) = {16.6, 23, 0, lf};
//+
Line(1) = {1, 2};
//+
Line(2) = {2, 3};
//+
Line(3) = {3, 4};
//+
Line(20) = {4, 5};
//+
Line(21) = {5, 6};
//+
Line(4) = {6, 12};
//+
Line(5) = {12, 13};
//+
Line(7) = {13, 19};
//+
Line(8) = {19, 18};
//+
Line(9) = {18, 1};
//+
Line(10) = {9, 10};
//+
Line(11) = {10, 13};
//+
Line(13) = {12, 11};
//+
Line(14) = {11, 14};
//+
Line(15) = {14, 9};
//+
Line(17) = {11, 7};
//+
Line(18) = {7, 8};
//+
Line(19) = {8, 14};
//+
Curve Loop(1) = {1, 2, 3, 20, 21, 4, 5, 7, 8, 9};
//+
Plane Surface(1) = {1};
//+
Curve Loop(2) = {10, 11, -5, 13, 14, 15};
//+
Plane Surface(2) = {2};
//+
Curve Loop(3) = {14, 17, 18, 19};
//+
Plane Surface(3) = {3};
//+
Extrude {{0, 60, 0}, {0, 0, 0}, Pi/2} {
  Surface{1}; Surface{2}; Surface{3};
}
