// ********************************************************************************************************************
// Test designs for a peristaltic pump
// Looking to make the repeated curved shape work easier via openscad
// ********************************************************************************************************************

// --------------------------------------------------------------------------------------------------------------------
// Hardware Settings 
// --------------------------------------------------------------------------------------------------------------------

// This design uses some oddball hardware, but these will be adjustable via the
// following settings:

// -- Drive Shaft

DriveBoltCircumference = 3.8;				// M4-45 Bolt
DriveBoltLength = 45;

DriveNutCircumference = 5;					// M4 Nut
DriveNutHeight = 2.3;

// -- Bolts used for securing two sides of housing together
			
FrameBoltCircumference = 4.1;				// SAE 8-32 Bolt

FrameNutCircumference = 9.7;				// 8-32 nlyoc nut
FrameNutHeight = 6.4;					

// --------------------------------------------------------------------------------------------------------------------
// Design Settings 
// --------------------------------------------------------------------------------------------------------------------

// -- Rotor Reference Values for the test

RotorRollerDiameter = 32;				// Diameter from center to the outer roller edge
RotorRollerHeight = 14;					// Height of rollers (2x 608zz bearings)

RotorFrameDiameter = 25;				// Diameter from center to outer frame edge
RotorFrameHeight = 28;					// Height of the rotor frame - includes roller mounting hardware

RotorClearanceSpacing = 2;				// Extra spacing to be added to provide clearance

// -- Frame Reference Values

FaceHeight = 3;

HousingOuterFrameThickness = 4;


// -- Hose Reference Values

HoseCircumference = 9.5;
HoseCompressedWidth = 3;					// Width of hose when compressed
HoseCompressedHeight = 16;					// Height of hose when compressed

// --------------------------------------------------------------------------------------------------------------------
// Adjustments
// --------------------------------------------------------------------------------------------------------------------

// Settings to compensate for inaccuracies produced from using FFM techniques

EdgeAdjustment = 0.35;				// Adjust to match the printing nozzle

// --------------------------------------------------------------------------------------------------------------------
// Rendering Settings
// --------------------------------------------------------------------------------------------------------------------

DefaultConvexity = 10;
DefaultSegments = 64;

ShowHardware=true;
ShowHose=true;
ShowReferenceSTL=false;

// ********************************************************************************************************************

// Reference Housing
// --------------------------------------------------------------------------------------------------------------------

if (ShowReferenceSTL == true) {
	color([1,0.5,0])
	translate([6.5,0,9.5])
	import("Casing_Reference.stl", convexity=DefaultConvexity);
}

// Test Pump Housing
// --------------------------------------------------------------------------------------------------------------------

innerWallDiameter = RotorRollerDiameter + HoseCompressedWidth + (EdgeAdjustment / 2);
innerWallHeight = (RotorFrameHeight / 2) + RotorClearanceSpacing + FaceHeight;
innerWallThickness = HousingOuterFrameThickness;

supportChannelDiameter = RotorFrameDiameter + RotorClearanceSpacing  + (EdgeAdjustment / 2);
supportChannelHeight = innerWallHeight - (RotorRollerHeight / 2) - RotorClearanceSpacing;
supportChannelThickness = innerWallDiameter - supportChannelDiameter;

faceEdgeDiameter = RotorFrameDiameter + (EdgeAdjustment / 2);
faceEdgeHeight = RotorClearanceSpacing;
faceEdgeThickness = supportChannelDiameter - faceEdgeDiameter;

// -- Housing - Outer Frame
// This part forms an inner wall large enough for the hose to be fully compressed by the rollers

rotate_extrude(convexity = DefaultConvexity, $fn = DefaultSegments) 
	translate([innerWallDiameter, 0, 0])
		square([innerWallThickness, innerWallHeight],center=false);
        
// -- Housing - Support for tubing      
// This part creates a channel to contain the hose whilst providing clearance for the rotor assembly
// Two squares with a circle at the edge provide a rounded camber 

rotate_extrude(convexity = DefaultConvexity, $fn = DefaultSegments) 
	translate([supportChannelDiameter + (RotorClearanceSpacing / 2), 0, 0])
		square([supportChannelThickness, supportChannelHeight],center=false);
	
rotate_extrude(convexity = DefaultConvexity, $fn = DefaultSegments) 
	translate([supportChannelDiameter, 0, 0])
		square([supportChannelThickness, supportChannelHeight - (RotorClearanceSpacing / 2)],center=false);
			
translate([0,0,supportChannelHeight - (RotorClearanceSpacing / 2)]) {
	rotate_extrude(convexity = DefaultConvexity, $fn = DefaultSegments) 
        translate([supportChannelDiameter + (RotorClearanceSpacing / 2), 0, 0])
        	circle(d = RotorClearanceSpacing, $fn= DefaultSegments, center=false);
}
       	
// -- Housing - Facing

rotate_extrude(convexity = DefaultConvexity, $fn = DefaultSegments) translate([faceEdgeDiameter, 0, 0])
	square([faceEdgeThickness, faceEdgeHeight],center=false); 
        
        
        
// ********************************************************************************************************************
// ********************************************************************************************************************