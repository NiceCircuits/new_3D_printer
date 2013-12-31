support=1;
teardrop_angle=45;
brim=1;
support_T=0.25;

$fn=40;

module fillet(r, h, pos, rot)
{
	translate(pos)
	rotate(rot)
	translate([-r,-r,0])
		difference()
		{
			translate([0,0,-h/2])
				cube([r+1,r+1,h]);
			cylinder(r=r, h=h+2, center=true);
		}
}

module __rounded_cube(dim, r, rounded)
{
	difference()
	{
		cube(dim, center=true);
		if(search("x", rounded))
			for(y=[-1,1])
			for(z=[-1,1])
			scale([1,y,z])
			fillet(r=r, h=dim[0]+2, pos=[0, dim[1]/2, dim[2]/2], rot=[0,-90,0]);
		if(search("y", rounded))
			for(x=[-1,1])
			for(z=[-1,1])
			scale([x,1,z])
			fillet(r=r, h=dim[1]+2, pos=[dim[0]/2, 0, dim[2]/2], rot=[90,0,0]);
		if(search("z", rounded))
			for(x=[-1,1])
			for(y=[-1,1])
			scale([x,y,1])
			fillet(r=r, h=dim[2]+2, pos=[dim[0]/2, dim[1]/2, 0], rot=[0,0,0]);
		if(rounded=="xyz")
			for(x=[-1,1])
			for(y=[-1,1])
			for(z=[-1,1])
			scale([x,y,z])
			translate(dim/2)
			translate([-r,-r,-r])
			difference()
			{
				cube([r+1,r+1,r+1]);
				sphere(r=r);
			}
	}
}

module rounded_cube(dim=[], r=0, rounded="", center=false)
{
	if(center)
	{
		__rounded_cube(dim=dim, r=r, rounded=rounded);
	}
	else
	{
		translate(dim/2)
		__rounded_cube(dim=dim, r=r, rounded=rounded);
	}
}
t_ang=teardrop_angle;

module supported_cylinder(r=1,h=1,z_rot=0, center=false)
{
	union()
	{
		cylinder(r=r,h=h,center=center);
		if (support)
		rotate([0,0,z_rot])
		linear_extrude(height=h, center=center)
		if(support_cylinder_style=="trapezoid")
		{
			polygon([[r*sin(t_ang),r*cos(t_ang)], [r, r*(cos(t_ang)-tan(t_ang)*(1-sin(t_ang)))], [r, -r*(cos(t_ang)-tan(t_ang)*(1-sin(t_ang)))],[r*sin(t_ang),-r*cos(t_ang)]]);
		}
		else if(support_cylinder_style=="teardrop")
		{
			polygon([[r*sin(t_ang),r*cos(t_ang)],[r/sin(t_ang),0],[r*sin(t_ang),-r*cos(t_ang)]]);
		}		
	}
}

L=30.8;
W=30;
T=4;
slot_W=9.8;
slot_T=2;
slot_fillet=2;

bearing_D=15;
bearing_from_plane=2;
bearing_L=24.4;

module Prusa_i3_Y_Busing()
{
	difference()
	{
		union()
		{
			translate([-W/2,0,0])
				rounded_cube([W,T,L], r=0.5, rounded="z");
			translate([-slot_W/2,-slot_T,0])
				rounded_cube([slot_W,slot_T,L], r=slot_fillet, rounded="y");
			if(brim)
				for(i=[-1,1])
				translate([-15*i,2,support_T/2])
					cube([10,10,support_T], center=true);
		}
		for(i=[-10,10])
			translate([i,T/2,L/2])
			cube([3,T+2,5], center=true);
		translate([0,bearing_D/2+bearing_from_plane, L/2])
			cylinder(r=bearing_D/2, h=bearing_L, center=true);
	}
}

Prusa_i3_Y_Busing();



