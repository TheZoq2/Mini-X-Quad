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

module motorHoles(largeRadius, smallRadius, holeDiameter, height)
{
    shaftHoleRadius = 3;

    cylinder(r = shaftHoleRadius, h = height);
    for(i = [0,1])
    {
        rotate(45 + i * 180)
        translate([largeRadius, 0, 0])
        cylinder(d = holeDiameter, h = height);
        rotate(45 + 90 + i * 180)
        translate([smallRadius, 0, 0])
        cylinder(d = holeDiameter, h = height);
    }
}
//Motor mount that can have a motor on two sides.
//3 stacked on top of eachother where the top and bottom should have screwholes for the motor screws
//and the center should have holes where the screwheads fit. The mounts are assempled by two screws on the 
//'sides'
//
//Child 0 is the hole layout of the motors,
module doubleMotorMount(blockSize, motorDiameter, screwholeDiameter)
{
    motorAngle = 25;

    screwholeOffset = screwholeDiameter/2 + 3;
    difference()
    {
        union()
        {
            //Creating the block
            cube(blockSize);

            //Motor mount
            translate([blockSize[0]/2, blockSize[1]/2, 0])
            cylinder(d = motorDiameter, h=blockSize[2]);
        }
        
        //Screwhole for mounting the bracket
        translate([screwholeOffset, blockSize[1]/2, -1])
        cylinder(d=screwholeDiameter, blockSize[2] + 2);

        translate([blockSize[0] - screwholeOffset, blockSize[1]/2, -1])
        cylinder(d=screwholeDiameter, blockSize[2] + 2);
        
        //Create the motor holes. The mirroring is done to allow motors to be mounted in all directions
        for(i = [0,1])
        {
            translate([blockSize[0] / 2, blockSize[1] / 2, -1])
            mirror([i,0,0])
            rotate(motorAngle)
            children(0);
        }
    }
}

//Quad arm
/*
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
*/

//Y6 arm
LENGTH = 70;
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
BRACKET_ANGLE = 0;

MOTOR_DIAMETER = 23;
BRACKET_MOUNTING_SIZE = [40, WIDTH, HEIGHT];
DOUBLE_BRACKET_SIZE = [40, WIDTH, 3];
MOTOR_SCREW_DIAMETER = 2.5;
MOTOR_SCREWHEAD_DIAMETER = 4.5;
MOUNTING_SCREW_DIAMETER = 3.5;
MOTOR_SCREW_LRADIUS = 16 / 2;
MOTOR_SCREW_SRADIUS = 12 / 2;

//Standard version
module standardVersion()
{
    armBase(WIDTH, LENGTH, HEIGHT, MESH_BAR_WIDTH, MESH_HOLE_SIZE, OUTSIDE_WIDTH);
    armWedge(WEDGE_WIDTH, LENGTH, WEDGE_START, WEDGE_HEIGHT, WIDTH);
    armBracket(BRACKET_WIDTH, BRACKET_LENGTH, BRACKET_HEIGHT, BRACKET_BAR_WIDTH, BRACKET_ANGLE);
    armMotorBracket(LENGTH, WIDTH);
}

//Y6 version
module y6Version()
{
    armBase(WIDTH, LENGTH, HEIGHT, MESH_BAR_WIDTH, MESH_HOLE_SIZE, OUTSIDE_WIDTH);
    armWedge(WEDGE_WIDTH, LENGTH, WEDGE_START, WEDGE_HEIGHT, WIDTH);
    armBracket(BRACKET_WIDTH, BRACKET_LENGTH, BRACKET_HEIGHT, BRACKET_BAR_WIDTH, BRACKET_ANGLE);

    rotate(90)
    mirror([0,1,0])
    translate([LENGTH,0,0])
    doubleMotorMount(BRACKET_MOUNTING_SIZE, MOTOR_DIAMETER, MOUNTING_SCREW_DIAMETER)
    motorHoles(MOTOR_SCREW_LRADIUS, MOTOR_SCREW_SRADIUS, MOTOR_SCREWHEAD_DIAMETER, HEIGHT * 2);
}

//doubleMotorMount(DOUBLE_BRACKET_SIZE, MOTOR_DIAMETER, MOUNTING_SCREW_DIAMETER)
//motorHoles(MOTOR_SCREW_LRADIUS, MOTOR_SCREW_SRADIUS, MOTOR_SCREW_DIAMETER, HEIGHT * 2);

//Tricopter back version
module tricopterVersion()
{
    carbon_arm_width = 12;
    back_padding = 0; //Offset of the carbon arm from the bracket
    bottom_thickness = 3;
    arm_width = WIDTH + 3;
    screw_offset = 13;
    added_width = 0;
    wedge_back_distance = 3;

    difference()
    {
        union()
        {
            armBracket(BRACKET_WIDTH, BRACKET_LENGTH, BRACKET_HEIGHT, BRACKET_BAR_WIDTH, BRACKET_ANGLE);
            //armBase(WIDTH, LENGTH/2, HEIGHT, MESH_BAR_WIDTH, MESH_HOLE_SIZE, OUTSIDE_WIDTH);
            translate([0,-wedge_back_distance, 0])
            armWedge(arm_width + added_width, LENGTH/2, WEDGE_START, WEDGE_HEIGHT, WIDTH);
        }
        translate([WIDTH / 2 - carbon_arm_width / 2, back_padding, bottom_thickness])
        cube([carbon_arm_width, LENGTH, carbon_arm_width]);
        
        for(i = [1, 2])
        {
            //Holes for screwing the arm into the bracket
            translate([WIDTH/2, screw_offset * i, -1])
            cylinder(d=MOUNTING_SCREW_DIAMETER, h = 100);
        }
    }
}

tricopterVersion();
