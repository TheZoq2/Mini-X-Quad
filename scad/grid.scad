
module grid(rows, columns, distance)
{
    for(x = [0:rows-1])
    {
        for(y = [0:columns-1])
        {
            translate([distance*x, distance*y, 0])
            children();
        }
    }
}
