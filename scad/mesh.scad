$fn=30;

module rawMesh(barWidth, height, holeWidth, size)
{
    barDistance = barWidth + holeWidth;

    for(x = [0 : size-1])
    {
        translate([barDistance*x, 0, 0])
        {
            cube([barWidth, size*barDistance, height]);
        }
    }

    for(y = [0 : size-1])
    {
        translate([0, barDistance*y, 0])
        {
            cube([size*barDistance, barWidth, height]);
        }
    }
}

module mesh(barWidth, height, holeWidth, size, centered=false)
{
    meshSize = (barWidth + holeWidth) * size;
    echo(meshSize);
    
    rotate(45)
    {
        if(centered == true)
        { 
            translate([-meshSize / 2, -meshSize / 2, 0]) 
            {
                rawMesh(barWidth, height, holeWidth, size);
            }
        }
        else
        {
            rawMesh(barWidth, height, holeWidth, size);
        }
    }
}


//mesh(3, 5, 10, 10, centered=true);
