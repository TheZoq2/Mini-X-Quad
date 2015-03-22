
$fn=20;

module landingFeet(height, thickness, screwHeadDiameter)
{
    screwDiameter = 4;
    screwHeadHeight = 5;

    difference()
    {
        cylinder(h=height, d = screwHeadDiameter + thickness * 2);

        //Screwhole
        translate([0,0,-1])
        cylinder(h=screwHeadHeight + 1, d=screwHeadDiameter);
        cylinder(h=height + 2, d=screwDiameter);
    }
}

module antennaHolder(height, outsideThickness, screwHeadDiameter, antennaSize)
{
    antennaSize = 2.6;
    width = screwHeadDiameter + outsideThickness * 2;
    length = 20;

    landingFeet(height, outsideThickness, screwHeadDiameter);

    difference()
    {
        union()
        {
            translate([-width / 2, 0, 0])
            {
                cube([width, length, height]);

            }

            translate([0, length, 0])
            cylinder(h=height, d=width);
        }

        cylinder(h=height, d=width);

        //antenna hole
        translate([-antennaSize / 2, length - antennaSize / 2, -1])
        {
            cube([antennaSize, antennaSize, height * 2]);
        }
    }
}

HEIGHT = 6;
THICKNESS = 2;
SCREWHEAD_DIAMETER = 7;

//landingFeet(HEIGHT, THICKNESS, SCREWHEAD_DIAMETER);
//translate([15, 0, 0])
antennaHolder(HEIGHT, THICKNESS, SCREWHEAD_DIAMETER);
//
ANTENNA_HEIGHT = 100;
ANTENNA_WIDTH = 2;

//cube([ANTENNA_HEIGHT, ANTENNA_WIDTH, ANTENNA_WIDTH]);
