$fn = 30;
include <brackets.scad>;

include <mesh.scad>;
include <wedge.scad>;

ARM_LENGTH = 100;
ARM_WIDTH = 15;
ARM_HEIGHT = 7;
ARM_OUTSIDE_WIDTH = 3;

MESH_HOLE_SIZE = 6;
MESH_BAR_WIDTH = 2;

module motorBracket(diameter, thickness, screw1Radius, screw2Radius, screwholeRadius)
{
    motorShaftDiameter = 7;
    screwheadDiameter = 5;
    screwheadHoleDepth = 3;
    difference()
    {
        cylinder(d=diameter, h=thickness);
        
        //Screw holes
        for(i = [-1, 1])
        {
            translate([screw1Radius * i, 0, 0])
            {
                translate([0, 0, -thickness])
                {
                    cylinder(h=thickness*3, r=screwholeRadius);
                }
                //Screwhead hole
                translate([0, 0, thickness - screwheadHoleDepth])
                {
                    cylinder(h=screwheadHoleDepth * 2, d = screwheadDiameter);
                }
            }
            translate([0, screw2Radius * i, 0])
            {
                translate([0, 0, -thickness])
                {
                    cylinder(h=thickness*3, r=screwholeRadius);
                }
                //Screwhead hole
                translate([0, 0, thickness - screwheadHoleDepth])
                {
                    cylinder(h=screwheadHoleDepth * 2, d = screwheadDiameter);
                }
            }
        }
        //ShaftHole
        translate([0,0,-1]);
        cylinder(h=thickness * 2, d=motorShaftDiameter);
    }
}


module armOutline(width, length, height)
{
    cube([width, length, height]);
}

module armMesh(barWidth, height, holeSize, armWidth, armLength)
{
    intersection()
    {
        armOutline(armWidth, armLength, height);
    
        mesh(barWidth, height, holeSize, 25, centered = true);
    }
}

module armHole(width, length, height, outsideWidth)
{
    holeWidth = width - outsideWidth * 2;
    holeLength = length - outsideWidth * 2;
    difference()
    {
        armOutline(width, length, height);

        translate([width / 2 - holeWidth / 2, length / 2 - holeLength / 2, -height/2])
        cube([holeWidth, holeLength, height * 2]);
    }
}

/*
 * length: length of the arm
 * width: width of the arm
 * flatHeight: The height of the wide part of the arm
 * wegeStart: the height at which the wedges starts,
 * wedgeHeight: the height of the wedge
 */

module armBase(width, length, flatHeight, meshWidth, meshHoleSize, outsideWidth)
{
    armHole(width, length, flatHeight, outsideWidth);
    armMesh(meshWidth, flatHeight, meshHoleSize, width, length);
}

module armWedge(width, length, wedgeStartHeight, wedgeHeight, armWidth)
{
    translate([armWidth / 2 - width/2, 0, 0])
    cube([width, length, wedgeStartHeight]);
    
    //Creating the wedge
    translate([armWidth / 2 - width / 2, 0,wedgeStartHeight])
    wedge(width, length, wedgeHeight);
}
module armBracket(width, length, height, barWidth, angle=0)
{
    xOffset = angle < 0 ? width - (cos(angle) * width) : 0;
    yOffset = angle < 0 ? -sin(angle) * width : 0;


    screwholeDiameter = 4;
    //Move the bracket to where it should be after rotation
    translate([xOffset, yOffset, 0])
    //translate([width/2, 0, 0]) //Offset to rotate around the correct point
    rotate(angle)
    //translate([-width/2, 0, 0])//Reset that offset
    difference()
    {
        translate([0,0,height])
        mirror([0,0,1])
        translate([0, -length, 0])
        {
            tBracket(barWidth, width, length, height);
        }

        //Screwhole
        translate([width/2, -length + barWidth / 2, -1])
        cylinder(h=height * 2, d=screwholeDiameter);
    }
}

module arm(length, width, flatHeight, wedgeWidth, wedgeStart, wedgeHeight, bracketWidth, bracketLength, bracketBarWidth, )
{

    //bottom of the wedge

}

module armMotorBracket(armLength, armWidth)
{
    DIAMETER = 24;
    BRACKET_THICKNESS = 7;
    SCREW1_RADIUS = 8;
    SCREW2_RADIUS = 6;
    OFFSET_DISTANCE = DIAMETER / 2 - 3;

    SCREWHOLE_RADIUS = 1.30;
    
    translate([armWidth / 2, armLength + OFFSET_DISTANCE, 0])
    {
        rotate(45, [0,0,1])
        motorBracket(DIAMETER, BRACKET_THICKNESS, SCREW1_RADIUS, SCREW2_RADIUS, SCREWHOLE_RADIUS);
    }
}

LENGTH = 90;
WIDTH = 15;
HEIGHT = 5;
WEDGE_WIDTH = 5;
WEDGE_START = 7;
WEDGE_HEIGHT = 3;
MESH_BAR_WIDTH = 2;
MESH_HOLE_SIZE = 9;
OUTSIDE_WIDTH = 3;

BRACKET_WIDTH = 15;
BRACKET_LENGTH = 13; //Original 10
BRACKET_BAR_WIDTH = 5;
BRACKET_HEIGHT = 13;
BRACKET_ANGLE = 15;


armBase(WIDTH, LENGTH, HEIGHT, MESH_BAR_WIDTH, MESH_HOLE_SIZE, OUTSIDE_WIDTH);
armWedge(WEDGE_WIDTH, LENGTH, WEDGE_START, WEDGE_HEIGHT, WIDTH);
armBracket(BRACKET_WIDTH, BRACKET_LENGTH, BRACKET_HEIGHT, BRACKET_BAR_WIDTH, BRACKET_ANGLE);
armMotorBracket(LENGTH, WIDTH);
