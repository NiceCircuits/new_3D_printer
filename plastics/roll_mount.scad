$fn=40;
difference()
{
union()
{
	cube([40, 30,8]);
	cube([10,30,27]);
	for(i=[0,1])
		translate([0, 25*i,8+4.4])
			cube([20, 5, 27-8-4.4]);
}
	translate([5,15,8+13/2+4])
	rotate([0,90,0])
		cylinder(r=4.2, h=12, center=true);
	hull()
	for(i=[0,1])
	{
		translate([10+9+4*i,15,0])
		cylinder(r=1.7, h=11);
	}
}