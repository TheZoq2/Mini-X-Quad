include <brackets.scad>
include <grid.scad>

$fn=20;

module bodyPlate(plateSize, thickness, bracketSize)
{
    //calculating the offset of the chamfer for the brackets
    chamferOffset = bracketSize[0] / 2;


    difference()
    {
        cube([plateSize, plateSize, thickness]);

        //Cutting off the corners
        translate([plateSize / 2, plateSize / 2, 0])
        for(r = [1:4])
        {
            rotate(45+r*90)
            {
                translate([sqrt(2 * pow(plateSize / 2, 2)) - chamferOffset, -20, -1])
                cube(40, 100, 10);
            }
        }
    }
}

BRACKET_MARGIN = 0.8;
function addInnerMargin(innerDimensions) = [
            innerDimensions[0] + BRACKET_MARGIN,
            innerDimensions[1],
            innerDimensions[2]
            ];
function addInnerMarginToBoom(boomWidth) = boomWidth + BRACKET_MARGIN;

module topArmBracket(outsideSize, innerDimensions, bottomBracketHeight, backWallWidth)
{
    barWidth = addInnerMarginToBoom(5);

    innerDimensions = addInnerMargin(innerDimensions);
    
    bracketZOffset = outsideSize[2] - (innerDimensions[2] - bottomBracketHeight);
    
    translate([-outsideSize[0] / 2, 0, 0])
    difference()
    {
        cube(outsideSize);
        
        //Flip the bracket upside down
        translate([0, 0, bracketZOffset])
        mirror([0,0,1])
        translate([0, 0, -innerDimensions[2]])
        //Moving the bracket to the right position inside the cube
        translate([outsideSize[0] / 2 - innerDimensions[0] / 2, backWallWidth, 0])
        //Moving the bracket to the right height
        tBracket(barWidth, innerDimensions[0], innerDimensions[1], innerDimensions[2]);
    }
}
module bottomArmBracket(outsideSize, innerDimensions, backWallWidth)
{
    barWidth = addInnerMarginToBoom(5);

    innerDimensions = addInnerMargin(innerDimensions);
    
    translate([-outsideSize[0] / 2, 0, 0])
    difference()
    {
        cube(outsideSize);

        translate([outsideSize[0] / 2 - innerDimensions[0] / 2, backWallWidth, 0])
        tBracket(barWidth, innerDimensions[0], innerDimensions[1], innerDimensions[2]);
    }
}
function getBracketOffset(plateSize, outsideSize) = sqrt(2* pow(plateSize / 2, 2)) - outsideSize[0] / 2 - outsideSize[1];
module armBrackets(outsideSize, plateSize, plateThickness)
{
    bracketOffset = getBracketOffset(plateSize, outsideSize);
    echo(bracketOffset);
    //Translate to the middle of the plate
    translate([plateSize / 2, plateSize / 2, plateThickness])
    for(i = [1:4])
    {
        rotate(45+90*i)
        {
            translate([0, bracketOffset, 0])
            {
                children(0);
            }
        }
    }
}
module bracketHoles(plateSize, bracketOutsideSize, diameter, bracketWallWidth, bracketBarWidth)
{
    bracketOffset = getBracketOffset(plateSize, bracketOutsideSize);
    
    holeOffset = bracketWallWidth + bracketBarWidth / 2;

    //Translate the whole thing to the center of the plate
    translate([plateSize/2, plateSize/2, 0])
    for(i = [1:4])
    {
        rotate(45 + i*90)
        translate([bracketOffset + holeOffset, 0, -1])
        cylinder(d=diameter, h=25);
    }
}

module screwholeGrid(rows, columns, distance, height)
{
    holeDiameter = 4;

    grid(rows, columns, distance)
    cylinder(d=holeDiameter, h=height);
    
}
module extensionPlate(width, length, bottomThickness)
{
    chamferDistance = 3;
    //center it on the x - axis
    difference()
    {
        translate([-width/2, 0, 0])
        cube([width, length, bottomThickness]);

        //Cutting off the corners
        for(i = [0,1])
        {
            mirror([i,0,0])
            translate([width/2 - chamferDistance, length - chamferDistance, -1])
            rotate(45)
            translate([0, -10, 0])
            cube([20, 20, 20]);
        }
    }
}
module receiverPlate(width, length, bottomThickness, gridDistance, screwDiameter, holeEdgeDistance)
{
    //Calculating how many rows and columns can fit on the receiver
    screwRowAmount = 1;
    screwColumnAmount = floor((length - holeEdgeDistance) / gridDistance);

    difference()
    {
        extensionPlate(width, length, bottomThickness);

        //Screwholes
        //Move to the center
        translate([0, length / 2, 0])
        {
            for(i = [0,1])
            {
                mirror([i, 0, 0])
                //Move to the center
                translate([(width - holeEdgeDistance * 2)/2, -gridDistance * (screwColumnAmount-1) / 2, -1])
                screwholeGrid(screwRowAmount, screwColumnAmount, gridDistance, bottomThickness * 2);
            }
        }
    }
}
module gridPlate(width, length, bottomThickness, gridDistance, screwDiameter, holeEdgeDistance)
{
    //Calculating how many rows and columns can fit on the receiver
    screwRowAmount = floor((width) / gridDistance);
    screwColumnAmount = floor((length - holeEdgeDistance) / gridDistance);


    difference()
    {
        extensionPlate(width, length, bottomThickness);

        //Screwholes
        //Move to the center
        translate([0, length / 2, 0])
        {
            translate([-gridDistance * (screwRowAmount - 1) / 2, -gridDistance * (screwColumnAmount - 1) / 2, -1])
            screwholeGrid(screwRowAmount, screwColumnAmount, gridDistance, bottomThickness * 2);
        }
    }
}

module nazeScrewholes()
{
    width = 36;
    holeEdgeDistance = 2.5;
    holeDiameter = 1.75;
    holeHeight = 10;
    
    holeCenterDistance = sqrt(2 * pow((width/2 - holeEdgeDistance), 2));

    echo("Hole center distance");
    echo(holeCenterDistance);

    for(i = [1:4])
    {
        rotate(45 + 90*i)
        translate([holeCenterDistance, 0, -1]) //Move them the right distance away from the center
        cylinder(h=holeHeight, r=holeDiameter);
    }
}

FC_SIZE = 40;
FC_ADDED = 4;
A_BRACKET_OUTSIDE = [20,12, 10];
A_TOP_BRACKET_OUTSIDE = [20,12, 3];
A_BRACKET_BACK_WALL = 2;
//A_BRACKET_INSIDE = [15, 10, 13];
A_BRACKET_INSIDE = [15, 10, 13];
A_BRACKET_HEIGHT = 13;
A_BRACKET_BOOM_WIDTH = 7;
A_SCREW_DIAMETER = 4;

B_THICKNESS = 3;

RECEIVERPLATE_WIDTH = 40;
RECEIVERPLATE_LENGTH = 25;

GRIDPLATE_WIDTH = 30;
GRIDPLATE_LENGTH = 25;

CAMERAPLATE_WIDTH = 40;
CAMERAPLATE_LENGTH = 25;

SCREWGRID_DISTANCE = 10;
SCREWGRID_DIAMETER = 4;
MIN_HOLE_DISTANCE = 4;

PLATE_SIZE = FC_SIZE + FC_ADDED + 2 * sqrt(pow(A_BRACKET_OUTSIDE[0] / 2, 2) + pow(A_BRACKET_OUTSIDE[1], 2));

module basePlate()
{
    difference()
    {
        union()
        {
            bodyPlate(PLATE_SIZE, B_THICKNESS, A_BRACKET_OUTSIDE);

            //armBrackets(A_BRACKET_OUTSIDE, PLATE_SIZE, B_THICKNESS)
            //bottomArmBracket(A_BRACKET_OUTSIDE, A_BRACKET_INSIDE, A_BRACKET_BACK_WALL);
            //Arm brackets
            children(0)
            children(1);
        }

        bracketHoles(PLATE_SIZE, A_BRACKET_OUTSIDE, A_SCREW_DIAMETER, A_BRACKET_BACK_WALL, A_BRACKET_BOOM_WIDTH);
    }
}

module bottomPlate()
{
    difference()
    {
        union()
        {
            basePlate()
            armBrackets(A_BRACKET_OUTSIDE, PLATE_SIZE, B_THICKNESS)
            bottomArmBracket(A_BRACKET_OUTSIDE, A_BRACKET_INSIDE, A_BRACKET_BACK_WALL);


            //naze screwholes

            //Reciever mounting thingy
            translate([PLATE_SIZE / 2, PLATE_SIZE, 0])
            {
                receiverPlate(
                        RECEIVERPLATE_WIDTH,
                        RECEIVERPLATE_LENGTH,
                        B_THICKNESS,
                        SCREWGRID_DISTANCE,
                        SCREWGRID_DIAMETER,
                        MIN_HOLE_DISTANCE
                    );
            }
            translate([PLATE_SIZE / 2, 0, 0])
            {
                rotate(180)
                /*gridPlate(
                        GRIDPLATE_WIDTH,
                        GRIDPLATE_LENGTH,
                        B_THICKNESS,
                        SCREWGRID_DISTANCE,
                        SCREWGRID_DIAMETER,
                        MIN_HOLE_DISTANCE
                    );*/
                //extensionPlate(CAMERAPLATE_WIDTH, CAMERAPLATE_LENGTH, B_THICKNESS);
                receiverPlate(
                        RECEIVERPLATE_WIDTH,
                        RECEIVERPLATE_LENGTH,
                        B_THICKNESS,
                        SCREWGRID_DISTANCE,
                        SCREWGRID_DIAMETER,
                        MIN_HOLE_DISTANCE
                    );
            }
        }
        translate([PLATE_SIZE / 2, PLATE_SIZE / 2])
        {
            nazeScrewholes();
        }
    }
}
module topPlate()
{
    bSlotLength = 30;
    bSlotWidth = 4;
    bSlotDistance = 40;

    screwRows = 3;
    screwEdgeDistance = 5;

    difference()
    {
        basePlate()
        armBrackets(A_TOP_BRACKET_OUTSIDE, PLATE_SIZE, B_THICKNESS)
        topArmBracket(A_TOP_BRACKET_OUTSIDE, A_BRACKET_INSIDE, A_BRACKET_OUTSIDE[2], A_BRACKET_BACK_WALL)
        
        translate([PLATE_SIZE / 2, PLATE_SIZE / 2, 0])
        for(i = [0,1])
        {
            mirror([i,0,0])
            {
                translate([-bSlotDistance / 2, -bSlotLength/2, -1])
                cube([bSlotWidth, bSlotLength, B_THICKNESS + 2]);
                
                rotate(90)
                translate([-((screwRows-1) * SCREWGRID_DISTANCE / 2), (PLATE_SIZE - screwEdgeDistance * 2)/2, -1])
                screwholeGrid(screwRows, 1, SCREWGRID_DISTANCE, B_THICKNESS * 2);
            }
            mirror([0,i,0])
            {
                translate([-((screwRows-1) * SCREWGRID_DISTANCE / 2), (PLATE_SIZE - screwEdgeDistance * 2)/2, -1])
                screwholeGrid(screwRows, 1, SCREWGRID_DISTANCE, B_THICKNESS * 2);
            }
        }
    }

}

!bottomPlate();
//translate([80, 80, 0])
//topPlate();
//armBrackets(A_BRACKET_OUTSIDE, PLATE_SIZE, B_THICKNESS);
//bottomArmBracket(A_BRACKET_OUTSIDE, A_BRACKET_INSIDE, A_BRACKET_BACK_WALL);
