// Parametric player tray for tabletop games

// Dependencies:
// - BOSL: https://github.com/revarbat/BOSL

include <BOSL/constants.scad>
use <BOSL/shapes.scad>

// Parameters

// Tray size

// Width (x) of the tray
width = 150;

// Depth (y) of the tray
depth = 70;

// Height (z) of the tray
height = 5;

// Height (z) of the wells (compartments) inside the tray
well_height = 3;

// Compartments

// Number of rows of wells
num_rows = 1;

// Number of columns of wells
num_cols = 3;

// Margins

// Outer edge margin around wells
outer_margin = 2;

// Inner margin between wells
between_margin = 2;

// Rounded corners

// Radius of rounded corners
rounding_radius = 2;

// Curve rounding resolution
$fn = 24;

well_width = (
    width -
    (outer_margin * 2) -
    (between_margin * (num_cols - 1))
) / num_cols;

well_depth = (
    depth -
    (outer_margin * 2) -
    (between_margin * (num_rows - 1))
) / num_rows;


module main_tray () {
    rounded_prismoid(
        size1=[width, depth],
        size2=[width, depth],
        h=height,
        r=rounding_radius
    );
}

module well () {
    translate ([
        (well_width / 2) - (width / 2),
        (well_depth / 2) - (depth / 2),
        height - well_height
    ]) {
        rounded_prismoid(
            size1=[well_width, well_depth],
            size2=[well_width, well_depth],
            h=well_height,
            r=rounding_radius
        );
    }
}

difference () {
    main_tray();

    for (i = [0 : num_cols - 1]) {
        for (j = [0 : num_rows - 1]) {
            translate_x = (
                outer_margin +
                (i * between_margin) + 
                (i * well_width)
            );
            translate_y = (
                outer_margin +
                (j * between_margin) + 
                (j * well_depth)
            );

            translate ([translate_x, translate_y, 0]) {
                well();
            }
        }
    }
}


