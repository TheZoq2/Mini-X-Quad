
module wedge(width, length, height)
{ 
    //Calculating the angle of the cutting block;
    angle = atan2(height, length);
    cutterLength = sqrt(pow(length, 2) + pow(height, 2));
    
    difference()
    {
        cube([width, length, height]);
        
        //Cutter
        translate([-1,0,height])
        {
            rotate(-angle, [1,0,0])
            cube([width * 2, cutterLength, height*2]);
        }
    }
}

//cube([10, 100, 10]);

//wedge(10, 100, 25);
