

//Creates a bracket that looks like this:
/*
 *      #     |
 *      #     | length
 *      #     |
 *  ######### | | boomWidth
 *  ---------
 *    width
 */
module tBracket(boomWidth, width, length, height)
{
    //xAxis boom
    cube([width, boomWidth, height]);

    //yAxis boom
    translate([width/2 - boomWidth / 2, 0,0])
    cube([boomWidth, length, height]);
}


