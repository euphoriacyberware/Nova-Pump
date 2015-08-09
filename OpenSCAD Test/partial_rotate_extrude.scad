

module teardrop_flat(diameter) {
	union() {
		circle(r = diameter/2, $fn = 100, center=true);
		rotate(45) square(diameter/2);
	}
}


module cross_section(diameter, thickness) {
	difference() {
		teardrop_flat(diameter);
		teardrop_flat(diameter - thickness*2);
		translate([0,-diameter/2,0]) square([diameter*2,diameter], center=true);
	}
}

module pie_slice(radius, angle, step) {
	for(theta = [0:step:angle-step]) {
		rotate([0,0,0])
		linear_extrude(height = radius*2, center=true)
		polygon( 
			points = [
				[0,0],
				[radius * cos(theta+step) ,radius * sin(theta+step)],
				[radius*cos(theta),radius*sin(theta)]
			] 
		);
	}
}

module partial_rotate_extrude(angle, radius, convex) {
	intersection () {
		rotate_extrude(convexity=convex) translate([radius,0,0]) children(0);
		pie_slice(radius*2, angle, angle/5);
	}
}









