// Terraforming Mars: Ares Expedition
// Phase card holder

// Size
card_size = 47.7;
width_factor = 2.5;

// Extra fudge allowance around to add to the width of cards
tolerance = 0.1;

// Number of degrees by which to tilt the holder upwards
tilt = 25; // [0:90]

// Width of the bottom lip that holds the phase card
lip_width = 2;

// Height of the bottom lip that holds the phase card
lip_height = 3;

peg = false;
peg_hole = false;
peg_tolerance = 0.125;

peg_width = 5;
peg_height = 4;
peg_depth = 3;
peg_radius = 3;

test_pegs = false;

// 9.3 x 3.6 magnets
magnet_left = false;
magnet_right = true;
magnet_width = 3.7;
magnet_height = 9.4;
magnet_depth = 10.4;
magnet_back_margin = 1.4;
magnet_side_margin = 1;
magnet_z_margin = 1.2;
//magnet_tolerance = 0.1;

card = card_size + tolerance;
width = card * width_factor;
back_shift = (card / sin(90)) * sin(90 - tilt);

// Base holder for the phase card
module base () {
    
    difference () {
        // Holder cube
        rotate([tilt, 0, 0])
            translate([0, 0, -card])
                cube([width, card, card]);
        
        // Exclude everything below z=0
        translate([-width * 5, -card * 5, -card * 10])
            cube([width * 10, card * 10, card * 10]);
        
        // Exclude back
        // Trig to cut off the back
        // https://www.mathsisfun.com/algebra/trig-solving-asa-triangles.html
        translate([0, back_shift, 0])
            cube([width, card, card]);
    }
    
    // Lip
    cube([width, lip_width, lip_height]);
}

module peg () {
    translate([width, back_shift / 2, 0])
        cube([peg_width, peg_height, peg_depth]);
    
    translate([
        width + peg_width,
        (back_shift / 2) + (peg_height / 2),
    0])
        cylinder(peg_depth, peg_radius, peg_radius);
}

module peg_hole () {
    translate([-card, 0, 0]) {
        translate([
            card,
            (back_shift / 2) - (peg_tolerance / 2),
            0
        ])
            cube([
                peg_width + peg_tolerance,
                peg_height + peg_tolerance,
                peg_depth
            ]);
    
    translate([
        card + peg_width - (peg_tolerance /2),
        (back_shift / 2) + (peg_height / 2),
        0
    ])
        cylinder(
            peg_depth,
            peg_radius + peg_tolerance,
            peg_radius + peg_tolerance
        );
    }
}

module magnet_hole_left () {
    // Hole
    translate([
        magnet_side_margin,
        back_shift - magnet_height - magnet_back_margin,
        magnet_z_margin
    ])
        cube([magnet_width, magnet_height, magnet_depth]);
}

module magnet_hole_right () {
    translate([
        width - magnet_width - (magnet_side_margin * 2),
        0,
        0
    ])
        magnet_hole_left();
}


// Main
module main () {
    difference () {
        base();
        if (peg_hole)
            peg_hole();
        
        if (magnet_left) {
            magnet_hole_left();
        }
        if (magnet_right) {
            magnet_hole_right();
        }
    }
        
    if (peg)
        peg();
    
// Peg tolerance testing
//    if (peg && peg_hole) {
//        difference () {
//            peg_hole();
//            peg();
//        }
//    }
}

// Run main

if (!test_pegs) {
    main();
}

// Test pegs
if (test_pegs) {
    difference () {
        main();
        
        // Cull front
        cube([card, 17, card]);

        // Cull back
        translate([0, 30, 0])
            cube([card, card, card]);
        
        // Cull top
        translate([0, 0, 5])
            cube([card, card, card]);
        
        // Cull middle
        translate([12, 0, 0])
            cube([card - 20, card, card]);
    }
}