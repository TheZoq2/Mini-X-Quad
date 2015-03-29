$fn=30;
include <brackets.scad>

module bracketTest()
{
    difference()
    {
        cube([18.5, 12, 10]);
    
        translate([1, 2.2, 2])
        tBracket(6, 15+1.5, 10, 9);
    }
}

//bracketTest();

module armBracket(width, length, height, barWidth, tWidth, tLength, edgeDistance, bracketHeight, inverted=false, bottomBracketHeight=0) 
{
    difference()
    {
        cube([width, length, height]);
        
        if(inverted)
        {
            translate([width / 2 - tWidth /2, edgeDistance, 0])
            tBracket(barWidth, tWidth, tLength,  bracketHeight);
        }
        else
        {
        echo(bracketHeight);
            !mirror([0,0,1])
            translate([width / 2 - tWidth /2, edgeDistance, bottomBracketHeight])
            tBracket(barWidth, tWidth, tLength,  bracketHeight);
        }
    }
}

module xt60Plug()
{
    height = 4;
    width  = 16;
    length = 16;
    
    cornerHeight = 1.5;

    for(i = [0, 1])
    {
        mirror([0,0,i])
        difference()
        {
            cube([width, length, height]);

            //Chopping off the corners
            translate([0,-1,cornerHeight])
            rotate(-45, [0,1,0])
            cube([10, length*2, 10]);

        }
    }
}
module xt60Bottom()
{
    height = (8-3) / 2;
    width = 16;
    length = 16;

    edgeWidth = 4;
    outsideWidth = width + edgeWidth;

    xt60Height = 8;
    
    difference()
    {
        cube([outsideWidth, length, height]);

        translate([edgeWidth / 2, -1, xt60Height / 2])
        scale([1, 10, 1])
        xt60Plug();
    }
}

module xt60Holder(bottomThickness, chamferBoth=false)
{
    length = 16;
    holderWidth = 20;
    //bottomThickness = 3;
    bottomWidth = holderWidth + 14;

    screwDistance = holderWidth / 2 + 3;
    screwholeDiameter = 4;
    cornerCutDistance = 4;

    translate([-holderWidth/2, 0, bottomThickness])
    {
        xt60Bottom();
    }

    difference()
    {
        translate([-bottomWidth / 2, 0, 0])
        {
            cube([bottomWidth, length, bottomThickness]);
        }

        //Screwholes
        for(i = [-1,1])
        {
            translate([i * screwDistance, length/2, -1])
            cylinder(h=bottomThickness * 2, d=screwholeDiameter);
        }

        //cutting off the corners
        for(i = [0,1])
        {
            mirror([i,0,0])
            translate([bottomWidth / 2 - cornerCutDistance, length, -1])
            rotate(-45)
            cube([10, 10, 10]);
        }

        if(chamferBoth)
        {
            for(i = [0, 1])
            {
                mirror([i, 0, 0])
                translate([bottomWidth / 2 - cornerCutDistance, 0, -1])
                rotate(-45)
                cube([10, 10, 10]);
            }
        }
    }
}

module body(fcSize, thickness, bracketHeight, bracketStandoffHeight, xt60=false, radio=false, isTop=false, bottomBracketHeight=0)
{
    bracketWidth = 20;
    bracketLength = 12;
    bracketBarWidth = 6;
    tWidth = 17;
    tLength = 15;
    bracketEdgeDistance = 2;
    screwholeDiameter = 4;

    cutterWidth = 100;

    addedSize = 4;
    finalSize = fcSize + addedSize;

    //bottomSize = finalSize + (sqrt(pow(bracketWidth / 2, 2) + pow(bracketLength, 2))) + 
            //sqrt(pow(bracketHeight, 2) * 2);
    bottomSize = finalSize + 2 * sqrt(pow(bracketWidth / 2, 2) + pow(bracketLength, 2));
    
    //Calculating the distance that the brackets need to be moved
    //for the flight controller to fit
    bracketDistance = sqrt(pow(finalSize / 2, 2) * 2);

    translate([0, 0, thickness])
    for(i = [1:4])
    {
        rotate(45 + 90 * i)
        {
            //Center the bracket and move it forward
            translate([-bracketWidth / 2, bracketDistance, 0])
            armBracket(bracketWidth, bracketLength, bracketHeight, bracketBarWidth, tWidth, tLength, bracketEdgeDistance, bracketStandoffHeight, inverted=isTop, bottomBracketHeight=bottomBracketHeight);

        }
    }
    
    difference()
    {
        //Bottom plate
        translate([-bottomSize / 2, -bottomSize / 2, 0])
        cube([bottomSize, bottomSize, thickness]);

        //Cutting of the corners
        for(i = [1 : 4])
        {
            rotate(45 + 90*i)
            {
                translate([-cutterWidth / 2, bracketDistance + bracketLength, -1])
                {
                    cube([cutterWidth, 100, thickness * 3]);
                }
                
                //Screw holes
                translate([bracketDistance + bracketEdgeDistance + bracketBarWidth / 2, 0, 0])
                {
                    cylinder(h=bracketHeight, d=screwholeDiameter, centered = true);
                }
            }
        }
    }
    
    xt60Length = 15;
    if(xt60)
    {
        translate([0, finalSize/2 + xt60Length, 0])
        xt60Holder(thickness);
    }

    //Creating the radio holder
    radioHolderWidth = 30;
    radioHolderLength = 25;
    radioCutWidth = 4;

    if(radio)
    {
        rotate(180) //Turning it over to the other side, this avoids unnesssairy transforms
        {
            translate([-radioHolderWidth / 2, finalSize / 2 + radioHolderLength / 2, 0])
            {
                difference()
                {
                    cube([radioHolderWidth, radioHolderLength, thickness]);

                    //Cutting the corners a bit
                    translate([radioHolderWidth / 2, 0, 0])
                    for(i = [0,1])
                    {
                        mirror([i, 0, 0])
                        {
                            translate([radioHolderWidth / 2 - radioCutWidth, radioHolderLength, -1])
                            rotate(-45)
                            cube([10, 10, thickness * 2]);
                        }
                    }
                }
            }
        }
    }
}


FC_SIZE = 40;
THICKNESS = 2;
BATTERY_WIDTH = 45;
STRAP_WIDTH = 30;
STRAP_HOLE_LENGTH = 5;

module bottom()
{
    bracketStandoffHeight = 13;
    bracketHeight = 10;
    body(FC_SIZE, THICKNESS, bracketHeight, bracketStandoffHeight, xt60 = true, radio = true);
}
module top()
{
    bracketHeight = 10;
    difference()
    {
        body(FC_SIZE, THICKNESS, bracketHeight, 5, bottomBracketHeight = 10);

        //Battery strap hole
        for(i = [-1,1])
        {
            translate([-STRAP_WIDTH / 2, i * BATTERY_WIDTH / 2 - STRAP_HOLE_LENGTH / 2, -1])
            cube([STRAP_WIDTH, STRAP_HOLE_LENGTH, THICKNESS * 2]);
        }
    }
}

//bottom();
top();

//xt60Holder(chamferBoth = true);
