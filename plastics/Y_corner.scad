H=56;
W=18;
L=22;

threaded_D=10;
plain_D=8;

fillet=3;

include <write/Write.scad>

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

module sphere_fillet(r,pos,rot)
{
	translate(pos)
	rotate(rot)
	translate([-r,-r,-r])
		difference()
		{
			cube([r*2,r*2,r*2]);
			sphere(r=r);
		}
}


module Y_corner()
{
	difference()
	{
		cube([L,W,H]);
		for(i=[0,1])
			translate([L/2, -1, 12+22*i])
				rotate([-90,0,0])
					cylinder(r=threaded_D/2, h=W+2);
		translate([-1, W/2, 23])
			rotate([0,90,0])
				cylinder(r=threaded_D/2, h=L+2);
		translate([0, W/2, 54])
			rotate([0,90,0])
			{
				translate([0,0,2])
					cylinder(r=plain_D/2, h=L);
				translate([0,0,L/2])
					difference()
					{
						cylinder(r=W/2+1, h=5, center=true);
						cylinder(r=W/2-2, h=7, center=true);
					}
				
			}
		for(i=[0,1])
		{
			fillet(fillet,H+2,[0,W*i,H/2],[0,0,180-90*i]);
			fillet(fillet,L+2,[L/2,W*i,H],[180*(i-1),-90,0]);
			sphere_fillet(fillet,[0,W*i,H],[0,0,180-90*i]);
		}
		fillet(fillet,W+2,[0,W/2,H],[90,-90,0]);
		translate([0,W/2,40])
			rotate([90,0,-90])
				scale([17/h,17/h,-1])
					write("Y",center=true);
	}
}


Y_corner($fn=40);

