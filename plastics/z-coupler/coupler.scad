L=30;
W=22;
d1=5;
d2=10;
wall=1.2;
space=0.5;
dist=7;


difference()
{
union()
{
difference()
{
	rotate(180/8)
		cylinder(h=L, r=W/2, $fn=40, center=true);
	for(z=[-1,1])
	for(i=[-1,1])
		rotate([0,0,90*i])
		translate([7,0,L/4*z])
		rotate([90,0,0])
			m3_screw();
}
//translate([-dist/2,-W/2,-L/2])
//	cube(size=[0.25,W,L]);
}
	translate([-space/2, -W/2-1, -L/2-1])
		cube([W/2+1, W+2, L+2]);
	translate([0,0,wall/2])
		cylinder(h=L/2, r=d1/2, $fn=40);
	mirror([0,0,1])
	translate([0,0,wall/2])
		cylinder(h=L/2, r=d2/2, $fn=40);
}

module m3_screw()
{
	ext=15;
	union()
	{
		cylinder(h=dist+2*ext, r=3.5/2, center=true,$fn=30);
		translate([0,0,dist/2])
			cylinder(h=ext,r=6.5/2,$fn=40);
		translate([0,0,-dist/2-ext])
		rotate([0,0,180/6])
			cylinder(h=ext, r=(5.5+0.1)/2/cos(180/6), $fn=6);
	}
}