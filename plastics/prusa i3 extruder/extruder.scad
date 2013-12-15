/*parameters*/

/* [Global] */
//Extruder type
extruder_type="j-head"; //["j-head"]
//Filament diameter
filament=3.0; //[3.0, 1.75]
//Generate support
support=1; //[1:Yes, 0:No]
//Pulley type
pulley=0; //[0:"MK7",1:"MK8"]
//Part to generate
part="assemble"; //["all":All parts (print plate), "assemble":Assembled view (demonstrative only) "base":Base, "arm":Arm, "bracket":Extruder bracket plate]


/* [Hidden] */
motor_W=42;
motor_L=40;
motor_shaft_D=5;
motor_shaft_L=23;
motor_flange_D=22;
motor_flange_L=2;
motor_connector_dim=[6,17,10];
motor_hole_spacing=31;
motor_hole_D=3;
motor_fillet_R=5;

pulley_D=12.6 - 4.7*pulley;
pulley_L=11;
pulley_drill_D=5.1;
pulley_effective_D=10.56 - 3.56*pulley;
pulley_teeth_R=3;
pulley_teeth_from_top=3.75;

jhead_rotate_poly=[[-.3,0], [8,0], [8,5], [6,5], [6,9.5], [8,9.5], [8,37], [3.85,41.15], [3.85,52], [0.65,53.6], [-.3,53.6]];
jhead_block_dim=[18.3, 14.9, 9.4];
jhead_block_move=[-12.1,-7.45,39.5];

base_H=17;
base_L=52;
base_motor_L=30;
base_wall_T=5;

hotend_X=-10;
hotend_Z=-5;

bracket_W=1;

module fillet(r, h, pos, rot)
{
	translate(pos)
	rotate(rot)
	translate([-r,-r,0])
		difference()
		{
			translate([0,0,-h/2])
				cube([r*2,r*2,h]);
			cylinder(r=r, h=h+2, center=true);
		}
}

module hotend_base(extr=0)
{
	if (extruder_type=="j-head")
	{
		rotate([0,180,0])
		union()
		{
			rotate_extrude(convexity = 50)
				polygon(jhead_rotate_poly);
			if (extr)
				for(i=[-1,1])
				scale([i,1,1])
				rotate([90,0,0])
				linear_extrude(50)
					polygon(jhead_rotate_poly);
			translate(jhead_block_move)
				cube(jhead_block_dim);
		}
	}
}

module hotend_base_translated(extr=0)
{
	translate([hotend_X,+pulley_effective_D/2+filament/2,hotend_Z])
		hotend_base(extr);
}

module base()
{
	difference()
	{
		translate([base_motor_L-base_L,-motor_W/2,-base_H])
			cube([base_L, motor_W+base_wall_T, base_H]);
		hotend_base_translated(extr=1);
		translate([hotend_X,+pulley_effective_D/2+filament/2,0])
			cylinder(r=filament/2+.2,h=50, center=true, $fn=20);
	}
}

module hotend_bracket()
{
}

module NEMA17_motor()
{
	translate([0,0,motor_L/2])
	union()
	{
		// base
		difference()
		{
			cube([motor_W,motor_W,motor_L], center=true);
			for(angle=[0:90:359])
			{
				rotate([0,0,angle])
					fillet(motor_fillet_R,motor_L+2,[motor_W/2,motor_W/2,0],[0,0,0], $fn=50);
			}
		}
		//flange
		cylinder(r=motor_flange_D/2,h=motor_L/2+motor_flange_L, $fn=50);
		//shaft
		cylinder(r=motor_shaft_D/2,h=motor_L/2+motor_flange_L+motor_shaft_L, $fn=50);
		//connector
		translate([0,-motor_connector_dim[1]/2,-motor_L/2])
			cube([motor_connector_dim[0]+motor_W/2,motor_connector_dim[1],motor_connector_dim[2]]);
	}
}

module MK_pulley()
{
	union()
	{
		difference()
		{
			cylinder(r=pulley_D/2, h=pulley_L, $fn=50);
			cylinder(r=pulley_drill_D/2, h=pulley_L*3, center=true, $fn=50);
			rotate_extrude(convexity = 50)
			translate([pulley_effective_D/2+pulley_teeth_R,pulley_L-pulley_teeth_from_top,0])
				circle(r=pulley_teeth_R, $fn=20);
		}
		//screw
		translate([pulley_D/2,0,2.5])
			rotate([0,90,0])
				cylinder(r=1.5,h=2, center=true,$fn=20);
	}
}


if (part=="assemble")
{
	union()
	{
		base();
		translate([motor_L,0,motor_W/2])
		rotate([0,-90,0])
		union()
		{
			NEMA17_motor();
			translate([0,0,motor_L-hotend_X+pulley_teeth_from_top-pulley_L])
				MK_pulley();
		}
		hotend_base_translated();
		// filament
		translate([hotend_X,+pulley_effective_D/2+filament/2,-5])
			cylinder(r=filament/2,h=55, $fn=6);
	}
}

else if (part=="base")
{
	base();
}







