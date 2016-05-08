$fn = 30;

module servoCogs()
{
    length = 5;
    max_diameter = 6.6;

    cog_amount = 24;

    cube_size = max_diameter / sqrt(2);
    for(i = [0:24/4])
    {
        rotate(i / (24) * 360)
        translate(-[1,1,0]*cube_size/2)
        cube([cube_size, cube_size, length]);
    }
}

module topPart()
{
    bracket_length = 10;
    width = 10;
    screw_diameter = 3.3;

    total_length = bracket_length * 3;

    motor_screw_distance = 16;
    motor_screw_diameter = 2.5;
    motor_screwhead_diameter = 4.5;

    mount_height = width * 4 / 5;
    difference () 
    {
        union()
        {
            //Bottom cylinder
            rotate(90, [0,1,0])
            cylinder(h = total_length, d=width);

            //Cube thing
            translate([0,-width/2,0])
            cube([total_length, width, width]);

            //Actual motor mount
            translate([total_length / 2, 0, mount_height])
            cylinder(d=bracket_length * 3.2, h = width / 2);
        }

        //Motor screwholes
        translate([total_length / 2, 0 ,0])
        for(i = [-1,1])
        {
            translate([0, motor_screw_distance / 2 * i, 0])
            {
                cylinder(d=motor_screw_diameter, h = 100);

                translate([0,0,mount_height])
                cylinder(d=motor_screwhead_diameter, h=3);
            }
        }

        
        //Hole for the motor shaft
        translate([total_length / 2, 0, 0])
        cylinder(d = 10, h = 100);

        //Hole for the mount
        translate([total_length / 2 - width / 2, - width / 2, -width / 2])
        cube([width, width, width + 2]);

        //Screwhole
        rotate(90, [0,1,0])
        cylinder(h = total_length, d=screw_diameter);

        //Servo cog things
        translate([-0.1,0,0])
        rotate(90, [0,1,0])
        servoCogs();
    }

}

topPart();

