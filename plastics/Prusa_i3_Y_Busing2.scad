support=1;
teardrop_angle=45;
brim=0;
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
		if(r[0])
			for(y=[-1,1])
			for(z=[-1,1])
			scale([1,y,z])
			fillet(r=r[0], h=dim[0]+2, pos=[0, dim[1]/2, dim[2]/2], rot=[0,-90,0]);
		if(r[1])
			for(x=[-1,1])
			for(z=[-1,1])
			scale([x,1,z])
			fillet(r=r[1], h=dim[1]+2, pos=[dim[0]/2, 0, dim[2]/2], rot=[90,0,0]);
		if(r[2])
			for(x=[-1,1])
			for(y=[-1,1])
			scale([x,y,1])
			fillet(r=r[2], h=dim[2]+2, pos=[dim[0]/2, dim[1]/2, 0], rot=[0,0,0]);
		if(r[0]&&(r[1]==r[2])&&(r[0]==r[1]))
			for(x=[-1,1])
			for(y=[-1,1])
			for(z=[-1,1])
			scale([x,y,z])
			translate(dim/2)
			translate(-r)
			scale(r)
			difference()
			{
				cube([2,2,2]);
				sphere(r=1);
			}
	}
}

module rounded_cube(dim=[], r=[], center=false)
{
	if(center)
	{
		__rounded_cube(dim=dim, r=r, r2=r2);
	}
	else
	{
		translate(dim/2)
		__rounded_cube(dim=dim, r=r);
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

bearing_D=15.2;
bearing_from_plane=2;
bearing_L=24.4;
rod_hole_D=10;

wall_H=12;
wall_T=(L-bearing_L)/2+2;

module Prusa_i3_Y_Busing()
{
	difference()
	{
		union()
		{
			translate([-W/2,0,0])
				rounded_cube([W,T,L], r=[0,0,1]);
			for (i=[0,1])
			translate([-W/2,0,(L-wall_T)*i])
				rounded_cube([W,wall_H,wall_T], r=[0,0,2]);
			translate([-slot_W/2,-slot_T,0])
				rounded_cube([slot_W,slot_T,L], r=[0,slot_fillet,0.7]);
			if(brim)
				for(i=[-1,1])
				translate([-15*i,2,support_T/2])
					cube([10,10,support_T], center=true);
		}
		for(i=[-10,10])
			translate([i,T/2,L/2])
				cube([3,T+2,5], center=true);
		//for(i=[0,1])
			//fillet(r=10, h=T+2, pos=[W/2*(1-2*i),T/2,L], rot=[90,-90*i,0]);
		translate([2,bearing_D/2+bearing_from_plane, L/2])
		{
			cylinder(r=bearing_D/2, h=bearing_L, center=true);
			cylinder(r=rod_hole_D/2, h=L+2, center=true);
		}
	}
}

Prusa_i3_Y_Busing();



