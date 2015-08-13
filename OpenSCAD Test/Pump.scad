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
FrameBoltHeadCircumference = 8;
FrameNutCircumference = 9.7;				// 8-32 nlyoc nut
FrameNutHeight = 5.8;

// -- Bolts for mounting the pump to the motor base

BaseBoltCircumference = FrameBoltCircumference;
BaseBoltHeadCircumference = FrameBoltHeadCircumference;
BaseBoltWasherCircumference = 9.55;					

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

EdgeAdjustment = 0.35;				// Adjust to match the printing nozzle

// --------------------------------------------------------------------------------------------------------------------
// Rendering Settings
// --------------------------------------------------------------------------------------------------------------------

DefaultConvexity = 10;
DefaultSegments = 100;

ShowHardware=true;
ShowHose=true;
ShowReferenceSTL=false;

// ********************************************************************************************************************
// Pump Housing
// --------------------------------------------------------------------------------------------------------------------

innerWallDiameter = RotorRollerDiameter + HoseCompressedWidth;
innerWallHeight = (RotorFrameHeight / 2) + RotorClearanceSpacing + FaceHeight;
innerWallThickness = HousingOuterFrameThickness;

supportChannelDiameter = RotorFrameDiameter + RotorClearanceSpacing;
supportChannelHeight = innerWallHeight - (RotorRollerHeight / 2) - RotorClearanceSpacing;
supportChannelThickness = innerWallDiameter - supportChannelDiameter;

faceEdgeDiameter = RotorFrameDiameter;
faceEdgeHeight = RotorClearanceSpacing;
faceEdgeThickness = supportChannelDiameter - faceEdgeDiameter;

hoseTubeOffset = 0;
hoseTubeLength = innerWallDiameter + innerWallThickness + 3.5;
assemblyBoltOffset = 0.8;
baseBoltOffset = 8;

if (ShowReferenceSTL == true) {
	color([1,0.5,0])
	translate([6.5,0,9.5])
	import("Casing_Reference.stl", convexity=DefaultConvexity);
}

//housingProfile_Main();

//housingComplete();

//assemblyBoltHolder();


// Slice for top part only
/*difference() {
	// render complete housing part (all parts combined)
	housingComplete();
	
	// slice off bottom portion
	translate([0,0,(innerWallHeight / 2)])	
			cube(size=[(innerWallDiameter + innerWallThickness) *2 + 50, (innerWallDiameter + innerWallThickness) *2 + 15, innerWallHeight], center=true);
	
	// slice out hose insert
	translate([0,(innerWallDiameter + innerWallThickness)/2 + 3.5,innerWallHeight])	
			cube(size=[(innerWallDiameter + innerWallThickness) *2 +10, (innerWallDiameter + innerWallThickness) + 7, (innerWallHeight - supportChannelHeight - faceEdgeHeight) * 2], center=true);
}*/


// Slice for bottom part only
/*difference() {
	// render complete housing part (all parts combined)
	housingComplete();
	
	// slice off top portion
	translate([0,0,innerWallHeight + (innerWallHeight / 2) + 0.5])	
			cube(size=[(innerWallDiameter + innerWallThickness) *2 + 15, (innerWallDiameter + innerWallThickness) *2 + 15, innerWallHeight +1], center=true);
	
	// slice out hose insert
	translate([0,(innerWallDiameter + innerWallThickness)/2 + 3.5,innerWallHeight])	
			cube(size=[(innerWallDiameter + innerWallThickness) *2 +10, (innerWallDiameter + innerWallThickness) + 7, (innerWallHeight - supportChannelHeight - faceEdgeHeight) * 2], center=true);
}*/

// Slice for hose insert part only

intersection() {
	// render complete housing part (all parts combined)
	housingComplete();
	// slice out hose insert
	translate([0,(innerWallDiameter + innerWallThickness)/2 + 3.5,innerWallHeight])	
			cube(size=[(innerWallDiameter + innerWallThickness) *2 +10, (innerWallDiameter + innerWallThickness) + 7, (innerWallHeight - supportChannelHeight - faceEdgeHeight) * 2], center=true);
}



// Render Whole Part
// --------------------------------------------------------------------------------------------------------------------


module housingComplete() {

	
	difference() {
		// Pump Housing - All parts combined
		union() {
			// Main Housing Body
			rotate_extrude(convexity = DefaultConvexity, $fn = DefaultSegments)
				housingProfile_Main();
				
			// lower bearing supports
			
			bearingSupports();
			
			
			translate([0,0,innerWallHeight * 2])
			rotate([0,180,0])
				bearingSupports();
		
			// Hose Insert Piece
			difference() {
			
				intersection() {
				
					union() {
						translate([0 - (innerWallDiameter - HoseDiameter), hoseTubeLength + 2.5 , innerWallHeight])
							rotate([90,0,0])
								cylinder(h= innerWallDiameter + innerWallThickness, r1=(innerWallHeight - supportChannelHeight), r2=(innerWallHeight - supportChannelHeight-1), convexity = DefaultConvexity, $fn = DefaultSegments / 2);
						translate([innerWallDiameter - HoseDiameter, hoseTubeLength + 2.5, innerWallHeight])
							rotate([90,0,0])
								cylinder(h= innerWallDiameter + innerWallThickness, r1=(innerWallHeight - supportChannelHeight), r2=(innerWallHeight - supportChannelHeight -1), convexity = DefaultConvexity, $fn = DefaultSegments / 2);
	
						// solid base of hose channels
						translate([0, hoseTubeLength / 2 + 1.25, innerWallHeight])	
								cube(size=[(innerWallDiameter ) *2, (innerWallDiameter + innerWallThickness) + 2.5, (supportChannelHeight * 2) - RotorClearanceSpacing], center=true);
	
					} // union() - Hose Insert Piece
				
					translate([0,0,innerWallHeight])	
						cube(size=[(innerWallDiameter + innerWallThickness) * 2 + 5, (innerWallDiameter + innerWallThickness) * 2 + 5, (innerWallHeight - supportChannelHeight - faceEdgeHeight) * 2], center=true);
				} // intersection() - Hose Insert Piece
				
				// Cut out center of support channel
				cylinder(h = innerWallHeight *2, r=innerWallDiameter, convexity = DefaultConvexity, $fn = DefaultSegments);
					
			} // difference() - Hose Insert Piece
			
			
			// Housing Assembly Bolt Holders 
			difference() {
				union() {
					// bolt holder
					rotate([0,0,45])
					translate([0,-(innerWallDiameter + innerWallThickness + assemblyBoltOffset),0])
						cylinder(h=innerWallHeight*2, r2 = (FrameBoltHeadCircumference /2) + 2, r1=(FrameNutCircumference/2) + 2, $fn=DefaultSegments /2);
				
					// bolt holder
					rotate([0,0,150])
					translate([0,-(innerWallDiameter + innerWallThickness + assemblyBoltOffset),0])
						cylinder(h=innerWallHeight*2, r=(FrameNutCircumference/2) + 2, $fn=DefaultSegments /2);
				
									// bolt holder
					rotate([0,0,-45])
					translate([0,-(innerWallDiameter + innerWallThickness + assemblyBoltOffset),0])
						cylinder(h=innerWallHeight*2, r=(FrameNutCircumference/2) + 2, $fn=DefaultSegments /2);
				
					// bolt holder
					rotate([0,0,-150])
					translate([0,-(innerWallDiameter + innerWallThickness + assemblyBoltOffset),0])
						cylinder(h=innerWallHeight*2, r=(FrameNutCircumference/2) + 2, $fn=DefaultSegments /2);
				}	

				// cut out center of support channel
				cylinder(h = innerWallHeight *2, r=innerWallDiameter, convexity = DefaultConvexity, $fn = DefaultSegments);
			}
			
			// bottom mounting bolt holders

			mountingBoltHolders();
				
			// top bolt holders

			rotate([0,0,180])
				mountingBoltHolders();
			
		} // union() - Main Housing Body
		
		// cut out tubing holes
		translate([innerWallDiameter - HoseDiameter, hoseTubeLength + hoseTubeOffset, innerWallHeight])
			rotate([90,0,0])
			cylinder(h = hoseTubeLength, r=HoseDiameter, convexity = DefaultConvexity, $fn = DefaultSegments / 2);

		translate([0 - (innerWallDiameter - HoseDiameter), hoseTubeLength + hoseTubeOffset, innerWallHeight])
		rotate([90,0,0])
			cylinder(h = hoseTubeLength, r=HoseDiameter, convexity = DefaultConvexity, $fn = DefaultSegments / 2);
		
		// assembly bolt holes
		rotate([0,0,45])
		translate([0,-(innerWallDiameter + innerWallThickness + assemblyBoltOffset),0])	
			assemblyBoltHole();
		rotate([0,0,-45])
		translate([0,-(innerWallDiameter + innerWallThickness + assemblyBoltOffset),0])	
			assemblyBoltHole();
		rotate([0,0,150])
		translate([0,-(innerWallDiameter + innerWallThickness + assemblyBoltOffset),0])	
			assemblyBoltHole();
		rotate([0,0,-150])
		translate([0,-(innerWallDiameter + innerWallThickness + assemblyBoltOffset),0])	
			assemblyBoltHole();
			
		// mounting bolt holes
		union() {
			translate([(innerWallDiameter + innerWallThickness + (baseBoltOffset /2)),BaseBoltWasherCircumference*1.5,0])
					cylinder(h=innerWallHeight/2, r=(BaseBoltCircumference / 2) + (EdgeAdjustment / 2), $fn=DefaultSegments / 4);
			translate([(innerWallDiameter + innerWallThickness + (baseBoltOffset /2)),-BaseBoltWasherCircumference*1.5,0])
					cylinder(h=innerWallHeight/2, r=(BaseBoltCircumference / 2) + (EdgeAdjustment / 2), $fn=DefaultSegments / 4);
			
			// mounting bolt clearance
			translate([(innerWallDiameter + innerWallThickness + (baseBoltOffset /2)),BaseBoltWasherCircumference*1.5,innerWallHeight/2 - 3])
					cylinder(h=innerWallHeight*2, r=(BaseBoltWasherCircumference / 2) + (EdgeAdjustment / 2), $fn=DefaultSegments / 4);
				
			// mounting bolt clearance
			translate([(innerWallDiameter + innerWallThickness + (baseBoltOffset /2)),-BaseBoltWasherCircumference*1.5,innerWallHeight/2 - 3])
					cylinder(h=innerWallHeight*2, r=(BaseBoltWasherCircumference / 2) + (EdgeAdjustment / 2), $fn=DefaultSegments / 4);
		}
		rotate([0,0,180])
		union() {
			translate([(innerWallDiameter + innerWallThickness + (baseBoltOffset /2)),BaseBoltWasherCircumference*1.5,0])
					cylinder(h=innerWallHeight/2, r=(BaseBoltCircumference / 2) + (EdgeAdjustment / 2), $fn=DefaultSegments / 4);
			translate([(innerWallDiameter + innerWallThickness + (baseBoltOffset /2)),-BaseBoltWasherCircumference*1.5,0])
					cylinder(h=innerWallHeight/2, r=(BaseBoltCircumference / 2) + (EdgeAdjustment / 2), $fn=DefaultSegments / 4);
			
			// mounting bolt clearance
			translate([(innerWallDiameter + innerWallThickness + (baseBoltOffset /2)),BaseBoltWasherCircumference*1.5,innerWallHeight/4])
					cylinder(h=innerWallHeight*2, r=(BaseBoltWasherCircumference / 2) + (EdgeAdjustment / 2), $fn=DefaultSegments / 4);
				
			// mounting bolt clearance
			translate([(innerWallDiameter + innerWallThickness + (baseBoltOffset /2)),-BaseBoltWasherCircumference*1.5,innerWallHeight/4])
					cylinder(h=innerWallHeight*2, r=(BaseBoltWasherCircumference / 2) + (EdgeAdjustment / 2), $fn=DefaultSegments / 4);
		}
		
	}
	
}

module mountingBoltHolders() {
			translate([(innerWallDiameter + innerWallThickness + (baseBoltOffset /2)),BaseBoltWasherCircumference*1.5,0])
				cylinder(h=innerWallHeight/2, r=(BaseBoltWasherCircumference/2) + 2, $fn=DefaultSegments /2);
				
			translate([(innerWallDiameter + innerWallThickness + (baseBoltOffset /2)),-BaseBoltWasherCircumference*1.5,0])
				cylinder(h=innerWallHeight/2, r=(BaseBoltWasherCircumference/2) + 2, $fn=DefaultSegments /2);
			
			translate([(innerWallDiameter + innerWallThickness - (BaseBoltWasherCircumference /2) + (baseBoltOffset /2)),-BaseBoltWasherCircumference*1.5,0])
				cube([BaseBoltWasherCircumference + 2,BaseBoltWasherCircumference*3,innerWallHeight/2]);
			color([1,0,0])
			translate([(innerWallDiameter + innerWallThickness - (BaseBoltWasherCircumference) + (baseBoltOffset /2)) -2.1,-(BaseBoltWasherCircumference*2) - 2,0])
				cube([BaseBoltWasherCircumference + 2,BaseBoltWasherCircumference*4 + 4,innerWallHeight/2]);
}

module bearingSupports() {
	intersection() {
		union() {
			rotate([0,0,0])
				housingProfile_ShaftBearingSupport();
			rotate([0,0,45])
				housingProfile_ShaftBearingSupport();
			rotate([0,0,90])
				housingProfile_ShaftBearingSupport();
			rotate([0,0,135])
				housingProfile_ShaftBearingSupport();
			rotate([0,0,180])
				housingProfile_ShaftBearingSupport();
			rotate([0,0,225])
				housingProfile_ShaftBearingSupport();
			rotate([0,0,270])
				housingProfile_ShaftBearingSupport();
			rotate([0,0,315])
				housingProfile_ShaftBearingSupport();
		}

	// slice off bottom edge of cylinders
	// center of support channel
		//translate([0,0,0-(innerWallHeight/2)])	
		
				cylinder(h = innerWallHeight *2, r=innerWallDiameter, convexity = DefaultConvexity, $fn = DefaultSegments);
	}
}

module assemblyBoltHole() {		
	union() {
		// bolt hole
		translate([0,0,7])
			cylinder(h=26, r=(FrameBoltCircumference / 2) + (EdgeAdjustment / 2), $fn=DefaultSegments / 4);
		
		// bolt nut recess
		translate([0,0,0])
			cylinder(h=6, r=(FrameNutCircumference / 2) + (EdgeAdjustment / 2), $fn=6);

		// bolt head recess
		translate([0,0,(innerWallHeight * 2) - 3])
			cylinder(h=3, r=(FrameBoltHeadCircumference / 2) + (EdgeAdjustment / 2), $fn=DefaultSegments / 4);
	}	
}

// --------------------------------------------------------------------------------------------------------------------
// Pump housing
// ====================================================================================================================

// Support Channel
// --------------------------------------------------------------------------------------------------------------------
// This part creates a channel to contain the hose whilst providing clearance for the rotor assembly
// Two squares with a circle at the edge provide a rounded camber 

module housingProfile_SupportChannel(_SupportChannelHeight = supportChannelHeight) {

	_curveRadius = 6;

	// lower main support
	color([1,0,0])
	translate([supportChannelDiameter + (_curveRadius / 2), 0, 0])
		square([supportChannelThickness - _curveRadius, supportChannelHeight],center=false);
			
	// lower portion of main support
	color([0,0,1])
	translate([supportChannelDiameter, 0, 0])
		square([_curveRadius, supportChannelHeight - (_curveRadius / 2)],center=false);
	
	// outside curved edge for main support	
	translate([supportChannelDiameter + (_curveRadius / 2), supportChannelHeight - (_curveRadius / 2), 0])
		circle(d = _curveRadius, $fn=64, center=false);
	
	// inner edge between the support channel and the Outer Frame
	difference() {
		translate([supportChannelDiameter + supportChannelThickness - (_curveRadius / 2), 0, 0])
			square([_curveRadius, supportChannelHeight + (_curveRadius / 2)],center=false);
		translate([supportChannelDiameter + supportChannelThickness - (_curveRadius / 2), supportChannelHeight + (_curveRadius / 2), 0])
			circle(d = _curveRadius, $fn =64, center=false);
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

	_curveRadius = 3;

	difference() {
		translate([faceEdgeDiameter, 0, 0])
			square([faceEdgeThickness, faceEdgeHeight + (RotorClearanceSpacing / 2)],center=false);
		translate([faceEdgeDiameter, faceEdgeHeight, 0])
			square([RotorClearanceSpacing / 2, faceEdgeHeight + RotorClearanceSpacing],center=false);
		translate([faceEdgeDiameter + faceEdgeThickness - (_curveRadius / 2), faceEdgeHeight + (RotorClearanceSpacing / 2), 0])
			circle(d = _curveRadius, $fn= DefaultSegments / 4, center=false);
	}		
}

// Shaft Bearing Hub
// --------------------------------------------------------------------------------------------------------------------

module housingProfile_ShaftBearingHub() {
	// rotor shaft bearing holder hub portion
	difference() {
		square([8,4]);
		
		union() {
			translate([5.5 + (EdgeAdjustment / 2),3,0])
				square([1,1]);
			translate([0,0,0])
				square([5.5 + (EdgeAdjustment / 2),4]);
		}
	}
	
	difference() {
		translate([8,0,0])
			circle(d = 8, $fn= 64 / 2);
			
		union() {
			square([8,4]);
			translate([0,-4,0])
				square([12,4]);
		}
	}
}

// Shaft Bearing Support
// --------------------------------------------------------------------------------------------------------------------

module housingProfile_ShaftBearingSupport() {
	translate([0,-8,0])
	rotate([90,0,0])
	linear_extrude(height = innerWallDiameter - 12, center = false, convexity = DefaultConvexity)
		scale([1.5,1.15,1])	
		circle($fn=32, d= RotorClearanceSpacing*2);
}

// --------------------------------------------------------------------------------------------------------------------
// Main Profile rendering module
// --------------------------------------------------------------------------------------------------------------------

module housing_LowerProfile() {
	// Render Sections of profile
	
	housingProfile_SupportChannel();
	housingProfile_OuterFrame();
	housingProfile_InnerEdge();
	housingProfile_ShaftBearingHub();
	
	// outer curve
	difference() {
		translate([innerWallDiameter -4,innerWallHeight,0])
			scale([1,3,1])
				circle(d=innerWallHeight, convexity = DefaultConvexity, $fn= DefaultSegments);

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
		rotate_extrude(convexity = DefaultConvexity, $fn = 128)
					housingProfile_Main();
		translate([0,0,(supportChannelHeight + faceEdgeHeight) /2])	
			cube(size=[(innerWallDiameter + innerWallThickness) * 3, (innerWallDiameter + innerWallThickness) * 3, supportChannelHeight + faceEdgeHeight], center=true);
	}
}

// --------------------------------------------------------------------------------------------------------------------

module housing_UpperPart() {
	// upper ring part
	intersection() {	// creates the main housing profile
		rotate_extrude(convexity = DefaultConvexity, $fn = 128)
					housingProfile_Main();
		translate([0,0,innerWallHeight * 2 - (supportChannelHeight + faceEdgeHeight) /2])	
			cube(size=[(innerWallDiameter + innerWallThickness) * 3, (innerWallDiameter + innerWallThickness) * 3, supportChannelHeight + faceEdgeHeight], center=true);
	}
}

// --------------------------------------------------------------------------------------------------------------------

module housing_CenterExtrude() {
	hoseTubeOffset = 0;
	hoseTubeLength = innerWallDiameter + innerWallThickness;

	rotate_extrude(convexity = DefaultConvexity, $fn = 128)
				housingProfile_Main();
				
	// hose channels
	translate([0 - (innerWallDiameter - HoseDiameter), hoseTubeLength + 2.5 , innerWallHeight])
        rotate([90,0,0])
			cylinder(h= innerWallDiameter + innerWallThickness, r1=(innerWallHeight - supportChannelHeight), r2=(innerWallHeight - supportChannelHeight), convexity = DefaultConvexity, $fn = 64);
	translate([innerWallDiameter - HoseDiameter, hoseTubeLength + 2.5, innerWallHeight])
        rotate([90,0,0])
			cylinder(h= innerWallDiameter + innerWallThickness, r1=(innerWallHeight - supportChannelHeight), r2=(innerWallHeight - supportChannelHeight), convexity = DefaultConvexity, $fn = 64);
	
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
		cylinder(h = (innerWallHeight * 2), r=innerWallDiameter, convexity = DefaultConvexity, $fn = 128);
	}

}
        
        
// ********************************************************************************************************************
// ********************************************************************************************************************