// Parametric player tray for tabletop games

// Dependencies:
// - BOSL: https://github.com/revarbat/BOSL

include <BOSL/constants.scad>
use <BOSL/shapes.scad>

// Parameters

// Tray size

width = 100;
depth = 100;
height = 5;
well_height = 3;

// Compartments

num_rows = 2;
num_cols = 2;

// Margins

outer_margin = 2;
between_margin = 2;

// Rounded corners

rounding_radius = 2;
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


