// Parametric player tray for tabletop games

// Dependencies:
// - BOSL: https://github.com/revarbat/BOSL

include <BOSL/constants.scad>
use <BOSL/shapes.scad>

use <../../fonts/Fira_Code/static/FiraCode-Bold.ttf>
use <../../fonts/Fira_Sans_Condensed/FiraSansCondensed-Black.ttf>
use <../../fonts/Permanent_Marker/PermanentMarker-Regular.ttf>
use <../../fonts/Press_Start_2P/PressStart2P-Regular.ttf>
use <../../fonts/Rock_Salt/RockSalt-Regular.ttf>
use <../../fonts/Orbitron/static/Orbitron-Bold.ttf>

// Parameters

// Tray size

// Width (x) of the tray (excluding extras)
width = 150;

// Depth (y) of the tray (excluding extras)
depth = 70;

// Height (z) of the tray (excluding extras)
height = 7;

// Height (z) of the wells (compartments) inside the tray
well_height = 5;

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

// Card rail

// Number of card rails
num_card_rails = 2;

// Depth (y) of the card rail, excluding margins (outer margins are used)
card_rail_depth = 5;

// Height (x) of the card rail groove
card_rail_groove_height = 5;

// Depth (y) of the card rail groove
card_rail_groove_depth = 1;

// Nameplate name: leave empty to remove nameplate
name = "Your name here";

// Depth (y) of the nameplate
nameplate_depth = 15;

// Height of the name text on the nameplate
name_height = 1;

// Font to use for the name text
name_font = "Liberation Sans"; // [Liberation Sans, "Fira Sans Condensed:style=Black", "Fira Code:style=Bold", "Permanent Marker:style=Regular", "Press Start 2P:style=Regular", "Rock Salt:style=Regular", "Orbitron:style=Bold"]

// Font size of the name
name_font_size = 7;

// Vertical alignment of the name
name_valign = "baseline"; // [top, bottom, center, baseline]

// Manual adjustment of vertical name placement (y axis)
name_adjust = 0;

// Curve rounding resolution
$fn = 24;

// Player component tray
module tray () {

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

}

module outer_margin_buffer () {
    color ([1, 0, 0]) {
        // Buffer to fill in rounded corners of tray
        translate([0, (depth / 2) - (outer_margin / 2), 0]) {
            cuboid([width, outer_margin, height], align=ALIGN_POS);
        }
    }
}

// Rail for holding cards
module card_rail () {

    module rail () {
        outer_margin_buffer();

        color ([0, 0, 1]) {
            translate([0, (depth / 2) + (card_rail_depth / 2), 0]) {
                rounded_prismoid(
                    size1=[width, card_rail_depth + (outer_margin * 2)],
                    size2=[width, card_rail_depth + (outer_margin * 2)],
                    h=height,
                    r=rounding_radius
                );
            }
        }
    }

    module rail_groove () {
        color ([0, 1, 0]) {
            translate([0, (depth / 2) + (card_rail_depth / 2), height - card_rail_groove_height]) {
                cuboid([
                    width - (outer_margin * 2),
                    card_rail_groove_depth,
                    card_rail_groove_height
                ],
                align=ALIGN_POS);
            }
        }
    }

    difference () {
        rail();
        rail_groove();
    }
}

// Nameplate for your name
module nameplate () {
    // Buffer to straighten rounded corners
    translate([
        0,
        (num_card_rails * card_rail_depth) +
        (num_card_rails * outer_margin),
        0,
    ]) {
        outer_margin_buffer();
    }

    // Nameplate
    module plate () {
        rounded_prismoid(
            size1=[width, nameplate_depth],
            size2=[width, nameplate_depth],
            h=height,
            r=rounding_radius
        );
    }
    
    translate([
        0,
        (depth / 2) +
        (nameplate_depth / 2) +
        (num_card_rails * card_rail_depth) +
        (num_card_rails * outer_margin) -
        outer_margin,
        0
    ]) {
        plate();
    }

    module name () {
        color([0.5, 0, 0.5]) {
            rotate([0, 0, 180]) {
                translate([
                    0,
                    -(depth / 2) -
                    (num_card_rails * card_rail_depth) -
                    (num_card_rails * outer_margin) -
                    nameplate_depth / 2 -
                    name_adjust,
                    height
                ]) {
                    linear_extrude(name_height) {
                        text(
                            name,
                            halign="center",
                            valign="baseline",
                            size=name_font_size,
                            font=name_font
                        );
                    }
                }
            }
        }
    }

    name ();
}

module main () {
    tray();

    if (num_card_rails) {
        for (i = [0 : num_card_rails - 1]) {
            translate([
                0,
                i * (card_rail_depth + outer_margin),
                0
            ]) {
                card_rail();
            }
        }
    }

    if (len(name)) {
        nameplate();
    }
}

main();
