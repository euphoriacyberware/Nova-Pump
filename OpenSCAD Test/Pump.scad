// Test designs for a peristaltic pump
// Looking to make the repeated curved shape work easier via openscad


// Hardware Settings -----------------------------------------------------------

// This design uses some oddball hardware, but these will be adjustable via the
// following settings:

// -- Drive Shaft

DriveBoltCircumference = 3.8;				// M4-45 Bolt
DriveBoltLength = 45;

DriveNutCircumference = 5;					// M4 Nut
DriveNutHeight = 2.3;

// -- Bolts used for securing two sides of housing together
			
FrameBoltCircumference = 4.1;				// SAE 8-32 Bolt

FrameNutCircumference = 9.7;					// 8-32 nlyoc nut
FrameNutHeight = 6.4;					

// Design Settings -------------------------------------------------------------

// -- Stator Reference Values for the test

StatorCircumference = 62;

// -- Hose Reference Values

HoseCircumference = 9.5;
HoseCompressedWidth = 3;					// Width of hose when compressed
HoseCompressedHeight = 16;					// Height of hose when compressed


// Tweaks and Adjustments ------------------------------------------------------

// Settings to compensate for inaccuracies produced from using FFM techniques

EdgeAdjustment = 0.35;				// Adjust to match the printing nozzle



// Constants -------------------------------------------------------------------


// Testing ---------------------------------------------------------------------

import("Casing_Reference.stl", convexity=3);

rotate_extrude(convexity = 3)
translate([StatorCircumference/2 + HoseCompressedWidth, 0, 0])
square([2,20],center=true); 