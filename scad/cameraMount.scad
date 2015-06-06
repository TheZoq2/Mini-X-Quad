
module vtx(size, antennaDimensions, antennaOffsetX)
{
    translate([0,size[1] + antennaDimensions[1],size[2]])
    rotate(180, [1,0,0])
    {
        cube(size);

        translate([antennaOffsetX, size[1], 0])
        cube(antennaDimensions);
    }
}
module camera(size, lensLength, lensDiameter, lensOffset)
{
    USB_WIDTH = 11;
    USB_LENGTH = 25;
    USB_HEIGHT = 9;
    USB_OFFSET = 4;
    USB_OFFSET_HEIGHT = 6;

    cube(size)

    translate([lensOffset + lensDiameter, size[1],size[2]/2])
    rotate(-90, [1,0,0])
    cylinder(h=lensLength, d=lensDiameter);

    translate([USB_OFFSET, -USB_LENGTH, USB_OFFSET_HEIGHT])
    cube([USB_WIDTH, USB_LENGTH, USB_HEIGHT]);
}


OUTSIDE_SIZE = [42, 43, 15];

VTX_SIZE = [24, 50, 10];
VTX_ANTENNA_DIM = [10, 25, 10];
VTX_ANTENNA_OFFSET = 8;

CAMERA_SIZE = [36, 60, 19];
CAMERA_LENS_DIA = 18;
CAMERA_LENS_HEIGHT = 10;
CAMERA_LENS_OFFSET = 4;

MIDDLE_THICKNESS = 3;

Y_OFFSET = VTX_SIZE[2] / 2;

VTX_OFFSET = -15;
CAMERA_OFFSET = 1 - VTX_OFFSET;

CHAMFER_DISTANCE = 4;

difference()
{
    cube(OUTSIDE_SIZE);
    
    translate([0, VTX_OFFSET, 0])
    translate([OUTSIDE_SIZE[0] / 2 -VTX_SIZE[0] / 2, 0, 0])
    translate([0,0,-Y_OFFSET])
    vtx(VTX_SIZE, VTX_ANTENNA_DIM, VTX_ANTENNA_OFFSET);

    translate([0, CAMERA_OFFSET, 0])
    translate([OUTSIDE_SIZE[0] / 2 - CAMERA_SIZE[0] / 2, 0, 0])
    translate([0,0,VTX_SIZE[2] + MIDDLE_THICKNESS - Y_OFFSET])
    camera(CAMERA_SIZE, CAMERA_LENS_HEIGHT, CAMERA_LENS_DIA, CAMERA_LENS_OFFSET);

    //chamfer
    translate([OUTSIDE_SIZE[0] / 2, -1, 0])
    for(i = [0,1])
    {
        mirror([i,0,0])
        {
            translate([OUTSIDE_SIZE[0] / 2 - CHAMFER_DISTANCE, 0, 0])
            rotate(45, [0,1,0])
            cube([OUTSIDE_SIZE[0] * 2, OUTSIDE_SIZE[1] * 2, OUTSIDE_SIZE[0] * 2]);
        }
    }
}

