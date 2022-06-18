outer_diameter = 50;
inner_diameter = 40;
lid_height = 1;
height = 7;

spike_step = 20;
spike_height = 10;
spike_diameter = 1;

$fn = 96;

// Holder / window
difference () {
    cylinder (
        d = outer_diameter,
        h = height
    );

    cylinder (
        d = inner_diameter,
        h = height
    );
}

// Cap: use with rectilinear infill instead of solid top layer
translate([
    0,
    0,
    height
])
    cylinder (
        h = lid_height,
        d = outer_diameter
    );

// Spikes
for (i = [0:spike_step:360 - spike_step]) {

    x = ((outer_diameter / 2) - (spike_diameter / 2)) * cos(i);
    y = ((outer_diameter / 2) - (spike_diameter / 2)) * sin(i);

    translate([
        x,
        y,
        height + lid_height
    ]) {
        cylinder(
            d = spike_diameter,
            h = spike_height
        );
    }
}