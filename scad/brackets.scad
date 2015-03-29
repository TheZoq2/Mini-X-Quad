

//Creates a bracket that looks like this:
/*
 *      #     |
 *      #     | length
 *      #     |
 *  ######### | | boomWidth
 *  ---------
 *    width
 */
module oldTBracket(boomWidth, width, length, height) 
{
    //xAxis boom
    cube([width, boomWidth, height]);

    //yAxis boom
    translate([width/2 - boomWidth / 2, 0,0])
    cube([boomWidth, length, height]);
}


module tBracket(boomWidth, width, length, height) 
{
    topHeight = 5;
    //xAxis boom
    cube([width, boomWidth, height]);
    
    translate([0,0,height-topHeight])
    cube([width, length, topHeight]);

    //yAxis boom
    translate([width/2 - boomWidth / 2, 0,0])
    cube([boomWidth, length, height]);
}


