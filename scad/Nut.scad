
//Uses 6 cubes to form a reference nut that is 1mm wide and 1mm high
module baseNut()
{
    //Calculating the length of the cubes
    //    _ #               
    // a  | |     -  c
    //    | |        v -
    //    - |-------------#
    //      |          -
    //      |     - 
    //      # 
    //      |-------------|
    //           1/2 = b
    //
    //    len = 2*a
    //
    //    sin(v) = a/c <=> a=c*sin(v)
    //
    //    cos(v) = b/c <=> c = b/cos(v) <=> c = 1/2/cos(v) = 1/2cos(v)
    //
    //    a = 1/2cos(v) * sin(v) = sin(v)/2cos(v)
    //    len = 2a = sin(v)/cos(v)
    //
    //    v = 30
    
    cubeLen = 1/2;
    cubeWidth = sin(30)/cos(30);

    union()
    {
        for(i = [0 : 5])
        {
            rotate(60*i + 30)
            translate([-cubeWidth/2, 0, 0]) cube([cubeWidth, cubeLen, 1]);
        }
    }
}

module nut(width, height, center=false)
{
    translation = [0, 0, 0];

    if(center == true);
    {
        translation = [0, 0, -height/2];
    }

    scale([width,width,height])
    {
        baseNut();
    }
}

//baseNut(1);

