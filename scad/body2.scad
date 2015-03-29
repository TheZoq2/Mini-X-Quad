include <brackets.scad>

$fn=20;

//TODO: add tollerance

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

module topArmBracket(outsideSize, innerDimensions, bottomBracketHeight, backWallWidth)
{
    barWidth = 5;
    
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
    barWidth = 5;
    
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

FC_SIZE = 40;
FC_ADDED = 4;
A_BRACKET_OUTSIDE = [20,12, 10];
A_TOP_BRACKET_OUTSIDE = [20,12, 8];
A_BRACKET_BACK_WALL = 2;
A_BRACKET_INSIDE = [15, 10, 13];
A_BRACKET_HEIGHT = 13;
A_BRACKET_BOOM_WIDTH = 7;
A_SCREW_DIAMETER = 4;

B_THICKNESS = 3;

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
    basePlate()
    armBrackets(A_BRACKET_OUTSIDE, PLATE_SIZE, B_THICKNESS)
    bottomArmBracket(A_BRACKET_OUTSIDE, A_BRACKET_INSIDE, A_BRACKET_BACK_WALL);
}
module topPlate()
{
    basePlate()
    armBrackets(A_TOP_BRACKET_OUTSIDE, PLATE_SIZE, B_THICKNESS)
    topArmBracket(A_TOP_BRACKET_OUTSIDE, A_BRACKET_INSIDE, A_BRACKET_OUTSIDE[2], A_BRACKET_BACK_WALL);
}

bottomPlate();
translate([80, 0, 0])
topPlate();
