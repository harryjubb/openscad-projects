// Diameter of the can / container for the lid to cover, plus a 0.5-1 mm tolerance
can_diameter = 75.5;

// Height of the main lid volume
lid_height = 1;

// Width of the lip to add around the edge of the lid
lip_width = 2.5;

// Height of the lip around the edge (total, not in addition to the main lid volume height)
lip_height = 5;


difference () {

    // Main piece
    cylinder(
        h = lip_height,
        d = can_diameter + lip_width
    );
    
    // Create the lip
    translate([
        0, 0, lid_height
    ])
        cylinder(
            h = lip_height - lid_height,
            d = can_diameter
        );
}