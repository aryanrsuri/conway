const std = @import("std");

// TODO: Must be abstracted out
pub const CELL_COUNT = 900;
pub const sq = std.math.sqrt(CELL_COUNT);
pub const Cells = [CELL_COUNT]u1;

pub fn check(cells: *Cells, pos: usize) void {
    const offsets = [8]isize{ -sq - 1, -sq, -sq + 1, -1, 1, sq - 1, sq, sq + 1 };
    const live = get(cells, pos) == 1;
    var count: usize = 0;
    for (offsets) |offset| {
        const conv: isize = @intCast(pos);
        const norm: isize = conv + offset;
        if (norm >= 0 and norm < cells.*.len) {
            count += get(cells, @intCast(norm));
        }
    }

    if (live) {
        if (count == 2 or count == 3) return;
        mask(cells, pos);
    } else if (count == 3) {
        mask(cells, pos);
    }
}

pub fn mask(cells: *Cells, pos: usize) void {
    cells.*[pos] = ~cells.*[pos];
}

pub fn set(cells: *Cells, pos: usize, bit: u1) void {
    cells.*[pos] = bit;
}

pub fn get(cells: *Cells, pos: usize) u1 {
    return cells.*[pos];
}

pub fn debug(cells: *Cells, title: []const u8) !void {
    try std.io.getStdOut().writer().writeAll("\x1B[2J\x1B[H");
    try std.io.getStdOut().writer().writeAll("\n\tConway's Game of Life ");
    if (title.len == 1) {
        try std.io.getStdOut().writer().print("(GEN={any})", .{title[0]});
    } else {
        try std.io.getStdOut().writer().print("\n\t{s}", .{title});
    }
    try std.io.getStdOut().writer().writeAll("\n\t  ");
    var i: usize = 0;
    while (i < CELL_COUNT) : (i += 1) {
        const cell = get(cells, i);
        if (cell == 0) {
            // Red for 0
            try std.io.getStdOut().writer().writeAll("\x1B[31m");
        } else {
            // Blue for 1
            try std.io.getStdOut().writer().writeAll("\x1B[34m");
        }
        try std.io.getStdOut().writer().print("{d} ", .{cell});
        try std.io.getStdOut().writer().writeAll("\x1B[0m");

        if ((i + 1) % sq == 0) {
            try std.io.getStdOut().writer().writeAll("\n\t  ");
        }
    }
    try std.io.getStdOut().writer().writeAll("\n");
    std.time.sleep(std.time.ns_per_s / 15);
}

pub fn randomise(cells: *Cells) void {
    var prng = std.Random.DefaultPrng.init(@intCast(std.time.milliTimestamp()));
    for (cells, 0..) |_, c| {
        const bit = prng.random().float(f64);
        if (bit < 0.5) {
            set(cells, c, 0);
        } else {
            set(cells, c, 1);
        }
    }
}

/// Play the standard Conway's Game of Life for N generations
/// @param  cells: *Cells -> Bit Array Representing the Cell Automatae
/// @param  generations: u8 -> N generations (Max 225 for printing)
/// @param  random: bool -> Randomise the cell state before playing?
pub fn play(cells: *Cells, generations: u8, random: bool) !void {
    if (random) randomise(cells);
    var i: usize = 0;
    while (i < generations) : (i += 1) {
        for (cells, 0..) |_, c| {
            check(cells, c);
        }
        _ = try debug(cells, &[_]u8{@intCast(i)});
    }
}

pub const Conway = struct {
    count: usize,
    square: usize = std.math.sqrt(CELL_COUNT),
    cells: [CELL_COUNT]u1,
    pub fn init(file: []const u8) void {
        std.debug.print("{s}\n", .{file});
    }
};
