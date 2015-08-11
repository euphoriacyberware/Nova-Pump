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

HousingOuterFrameThickness = 3;


// -- Hose Reference Values

HoseCircumference = 9.5;
HoseDiameter = 4.25;
HoseCompressedWidth = 3;					// Width of hose when compressed
HoseCompressedHeight = 16;					// Height of hose when compressed

// --------------------------------------------------------------------------------------------------------------------
// Adjustments
// --------------------------------------------------------------------------------------------------------------------

// Settings to compensate for inaccuracies produced from using FFM techniques

EdgeAdjustment = 0.0;				// Adjust to match the printing nozzle

// --------------------------------------------------------------------------------------------------------------------
// Rendering Settings
// --------------------------------------------------------------------------------------------------------------------

DefaultConvexity = 16;
DefaultSegments = 32;

ShowHardware=true;
ShowHose=true;
ShowReferenceSTL=false;

// ********************************************************************************************************************
// Pump Housing
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

if (ShowReferenceSTL == true) {
	color([1,0.5,0])
	translate([6.5,0,9.5])
	import("Casing_Reference.stl", convexity=DefaultConvexity);
}


housingComplete();

// Slice for bottom part only
/*difference() {
	// render complete housing part (all parts combined)
	housingComplete();
	
	// slice off top portion
	translate([0,0,innerWallHeight + (innerWallHeight / 2)])	
			cube(size=[(innerWallDiameter + innerWallThickness) *2 + 15, (innerWallDiameter + innerWallThickness) *2 + 15, innerWallHeight], center=true);
	
	// slice out hose insert
	translate([0,(innerWallDiameter + innerWallThickness)/2 + 3.5,innerWallHeight])	
			cube(size=[(innerWallDiameter + innerWallThickness) *2 +10, (innerWallDiameter + innerWallThickness) + 7, (innerWallHeight - supportChannelHeight - faceEdgeHeight) * 2], center=true);
}
*/
// Slice for hose insert part only

/*intersection() {
	// render complete housing part (all parts combined)
	housingComplete();
	// slice out hose insert
	translate([0,(innerWallDiameter + innerWallThickness)/2 + 3.5,innerWallHeight])	
			cube(size=[(innerWallDiameter + innerWallThickness) *2 +10, (innerWallDiameter + innerWallThickness) + 7, (innerWallHeight - supportChannelHeight - faceEdgeHeight) * 2], center=true);
}*/



// Render Whole Part
// --------------------------------------------------------------------------------------------------------------------


module housingComplete() {
	hoseTubeOffset = 0;
	hoseTubeLength = innerWallDiameter + innerWallThickness + 3.5;
	assemblyBoltOffset = 0.9;
	
	difference() {
		union() {
			difference() {
				housing_CenterPart();
		
				// tubing holes
				translate([innerWallDiameter - HoseDiameter, hoseTubeLength + hoseTubeOffset, innerWallHeight])
					rotate([90,0,0])
					cylinder(h = hoseTubeLength, r=HoseDiameter, convexity = DefaultConvexity, $fn = DefaultSegments / 2);

				translate([0 - (innerWallDiameter - HoseDiameter), hoseTubeLength + hoseTubeOffset, innerWallHeight])
				rotate([90,0,0])
					cylinder(h = hoseTubeLength, r=HoseDiameter, convexity = DefaultConvexity, $fn = DefaultSegments / 2);
			}


			housing_LowerPart();
			housing_UpperPart();
		
			// Housing Assembly Bolt Holders 
			difference() {
				union() {
					// bolt holder
					rotate([0,0,30])
					translate([0,-(innerWallDiameter + innerWallThickness + assemblyBoltOffset),0])
						cylinder(h=38, r=(FrameNutCircumference/2) + 2);
				
					// bolt holder
					rotate([0,0,150])
					translate([0,-(innerWallDiameter + innerWallThickness + assemblyBoltOffset),0])
						cylinder(h=38, r=(FrameNutCircumference/2) + 2);
				
									// bolt holder
					rotate([0,0,-30])
					translate([0,-(innerWallDiameter + innerWallThickness + assemblyBoltOffset),0])
						cylinder(h=38, r=(FrameNutCircumference/2) + 2);
				
					// bolt holder
					rotate([0,0,-150])
					translate([0,-(innerWallDiameter + innerWallThickness + assemblyBoltOffset),0])
					cylinder(h=38, r=(FrameNutCircumference/2) + 2);
				}	

				// slice out center of support channel
				cylinder(h = innerWallHeight *2, r=innerWallDiameter, convexity = DefaultConvexity, $fn = DefaultSegments);
			}
		}
		
		// Housing Assembly Bolt Holders (holes)
		union() {
			// bolt hole
			rotate([0,0,30])
			translate([0,-(innerWallDiameter + innerWallThickness + assemblyBoltOffset),0])
				cylinder(h=38, r=FrameBoltCircumference/2);
			
			// bolt hole
			rotate([0,0,150])
			translate([0,-(innerWallDiameter + innerWallThickness + assemblyBoltOffset),0])
				cylinder(h=38, r=FrameBoltCircumference/2);
			
			// bolt hole
			rotate([0,0,-30])
			translate([0,-(innerWallDiameter + innerWallThickness + assemblyBoltOffset),0])
				cylinder(h=38, r=FrameBoltCircumference/2);
			
			// bolt hole
			rotate([0,0,-150])
			translate([0,-(innerWallDiameter + innerWallThickness + assemblyBoltOffset),0])
				cylinder(h=38, r=FrameBoltCircumference/2);
		}
	}
}

/*difference() {
    
    color([0,1,1])
    translate([0 - (innerWallDiameter - HoseDiameter), innerWallDiameter, innerWallHeight])
        rotate([90,0,0])
        cylinder(h = innerWallDiameter + innerWallThickness, r=HoseDiameter);   
    
    // tubing test
    color([0,1,1])
    translate([innerWallDiameter - HoseDiameter, innerWallDiameter, innerWallHeight])
        rotate([90,0,0])
        cylinder(h = innerWallDiameter + innerWallThickness, r=HoseDiameter);


}*/

module housing_LowerComponent() {
	intersection() {
		rotate_extrude(convexity = DefaultConvexity, $fn = DefaultSegments)
			housingProfile_Main();

		translate([0 - (innerWallDiameter + innerWallThickness), 0 - (innerWallDiameter + innerWallThickness), 0])
			cube(size=[innerWallDiameter + innerWallThickness, (innerWallDiameter + innerWallThickness) * 2, innerWallHeight], center = false);
	}
	
	intersection() {
		rotate_extrude(convexity = DefaultConvexity, $fn = DefaultSegments)
			housingProfile_HoseSide();
        
        
		translate([0, 0 - (innerWallDiameter + innerWallThickness), 0])
			cube(size=[innerWallDiameter + innerWallThickness, (innerWallDiameter + innerWallThickness) * 2, innerWallHeight], center = false);
	}
    
    /*intersection() {
    rotate([0,0,270])
    translate([0 - (innerWallDiameter + innerWallThickness), 0 - (innerWallDiameter + innerWallThickness), 0])
			cube(size=[innerWallDiameter + innerWallThickness, (innerWallDiameter + innerWallThickness) * 2, innerWallHeight], center = false);
        housingProfile_SupportChannel();
    }*/
}


// --------------------------------------------------------------------------------------------------------------------
// Pump housing
// ====================================================================================================================



// Support Channel
// --------------------------------------------------------------------------------------------------------------------
// This part creates a channel to contain the hose whilst providing clearance for the rotor assembly
// Two squares with a circle at the edge provide a rounded camber 

module housingProfile_SupportChannel(_SupportChannelHeight = supportChannelHeight) {

	// lower main support
	translate([supportChannelDiameter + (RotorClearanceSpacing / 2), 0, 0])
		square([supportChannelThickness - RotorClearanceSpacing, supportChannelHeight],center=false);
			
	// lower portion of main support
	translate([supportChannelDiameter, 0, 0])
		square([RotorClearanceSpacing, supportChannelHeight - (RotorClearanceSpacing / 2)],center=false);
	
	// outside curved edge for main support	
	translate([supportChannelDiameter + (RotorClearanceSpacing / 2), supportChannelHeight - (RotorClearanceSpacing / 2), 0])
		circle(d = RotorClearanceSpacing, $fn= DefaultSegments / 4, center=false);
	
	// inner edge between the support channel and the Outer Frame
	difference() {
		translate([supportChannelDiameter + supportChannelThickness - (RotorClearanceSpacing / 2), 0, 0])
			square([RotorClearanceSpacing, supportChannelHeight + (RotorClearanceSpacing / 2)],center=false);
		translate([supportChannelDiameter + supportChannelThickness - (RotorClearanceSpacing / 2), supportChannelHeight + (RotorClearanceSpacing / 2), 0])
			circle(d = RotorClearanceSpacing, $fn= DefaultSegments / 4, center=false);
	}

}

// Outer Frame
// --------------------------------------------------------------------------------------------------------------------
// This part forms an inner wall large enough for the hose to be fully compressed by the rollers
// it also provides the outside edge of the housing

module housingProfile_OuterFrame() {
	translate([innerWallDiameter, 0, 0])
		square([innerWallThickness, innerWallHeight],center=false);

}

// Inner Edge
// --------------------------------------------------------------------------------------------------------------------

module housingProfile_InnerEdge() {

	difference() {
		translate([faceEdgeDiameter, 0, 0])
			square([faceEdgeThickness, faceEdgeHeight + (RotorClearanceSpacing / 2)],center=false);
		translate([faceEdgeDiameter, faceEdgeHeight, 0])
			square([RotorClearanceSpacing / 2, faceEdgeHeight + RotorClearanceSpacing],center=false);
		translate([faceEdgeDiameter + faceEdgeThickness - (RotorClearanceSpacing / 2), faceEdgeHeight + (RotorClearanceSpacing / 2), 0])
			circle(d = RotorClearanceSpacing, $fn= DefaultSegments / 4, center=false);
	}		
}

// Main Profile rendering module
// --------------------------------------------------------------------------------------------------------------------

module housing_LowerProfile() {
	// Render Sections of profile
	
	housingProfile_SupportChannel();
	housingProfile_OuterFrame();
	housingProfile_InnerEdge();
	difference() {
		translate([innerWallDiameter -4,innerWallHeight,0])
			scale([1,3,1])
				circle(d=innerWallHeight, convexity = DefaultConvexity, $fn = DefaultSegments);

		translate([0,-20,0])
			square([innerWallDiameter,innerWallHeight *4], center=false);
		translate([innerWallDiameter -14,-innerWallHeight,0])
			square([innerWallDiameter,innerWallHeight], center=false);
		translate([innerWallDiameter -14,innerWallHeight,0])
			square([innerWallDiameter,innerWallHeight+10], center=false);
	}
}

module housingProfile_Main() {
	housing_LowerProfile();
	
	translate([0,innerWallHeight * 2,0])
		rotate([0,180,180])
			housing_LowerProfile();
}

// --------------------------------------------------------------------------------------------------------------------

module housing_LowerPart() {
	// lower ring part
	intersection() {	// creates the main housing profile
		rotate_extrude(convexity = DefaultConvexity, $fn = DefaultSegments)
					housingProfile_Main();
		translate([0,0,(supportChannelHeight + faceEdgeHeight) /2])	
			cube(size=[(innerWallDiameter + innerWallThickness) * 3, (innerWallDiameter + innerWallThickness) * 3, supportChannelHeight + faceEdgeHeight], center=true);
	}
}

// --------------------------------------------------------------------------------------------------------------------

module housing_UpperPart() {
	// upper ring part
	intersection() {	// creates the main housing profile
		rotate_extrude(convexity = DefaultConvexity, $fn = DefaultSegments)
					housingProfile_Main();
		translate([0,0,innerWallHeight * 2 - (supportChannelHeight + faceEdgeHeight) /2])	
			cube(size=[(innerWallDiameter + innerWallThickness) * 3, (innerWallDiameter + innerWallThickness) * 3, supportChannelHeight + faceEdgeHeight], center=true);
	}
}

// --------------------------------------------------------------------------------------------------------------------

module housing_CenterExtrude() {
	hoseTubeOffset = 0;
	hoseTubeLength = innerWallDiameter + innerWallThickness;

	rotate_extrude(convexity = DefaultConvexity, $fn = DefaultSegments)
				housingProfile_Main();
				
	// hose channels
	translate([0 - (innerWallDiameter - HoseDiameter), hoseTubeLength + 2.5 , innerWallHeight])
        rotate([90,0,0])
			cylinder(h= innerWallDiameter + innerWallThickness, r1=(innerWallHeight - supportChannelHeight), r2=(innerWallHeight - supportChannelHeight), convexity = DefaultConvexity, $fn = DefaultSegments);
	translate([innerWallDiameter - HoseDiameter, hoseTubeLength + 2.5, innerWallHeight])
        rotate([90,0,0])
			cylinder(h= innerWallDiameter + innerWallThickness, r1=(innerWallHeight - supportChannelHeight), r2=(innerWallHeight - supportChannelHeight), convexity = DefaultConvexity, $fn = DefaultSegments);
	
	// solid base of hose channels
	translate([0, hoseTubeLength / 2 + 1.25, innerWallHeight])	
			cube(size=[(innerWallDiameter ) *2, (innerWallDiameter + innerWallThickness) + 2.5, (supportChannelHeight * 2) - RotorClearanceSpacing], center=true);

}

module housing_CenterPart() {
	difference() {
		union() {
			intersection() {	// creates the main housing profile
				housing_CenterExtrude();
				translate([0,0,innerWallHeight])	
					cube(size=[(innerWallDiameter + innerWallThickness) * 3, (innerWallDiameter + innerWallThickness) * 3, (innerWallHeight - supportChannelHeight - faceEdgeHeight) * 2], center=true);
			}
		}
		// slice out center of support channel
		cylinder(h = innerWallHeight *2, r=innerWallDiameter, convexity = DefaultConvexity, $fn = DefaultSegments);
	}

}
        
        
// ********************************************************************************************************************
// ********************************************************************************************************************