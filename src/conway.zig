const std = @import("std");
pub const CELL_COUNT = 400;
pub const sq = std.math.sqrt(CELL_COUNT);
pub const Cells = [CELL_COUNT]u1;

pub fn debug(cells: *Cells, title: []const u8) !void {
    try std.io.getStdOut().writer().writeAll("\x1B[2J\x1B[H");
    try std.io.getStdOut().writer().writeAll("\n\t\tConway's Game of Life ");
    try std.io.getStdOut().writer().print("(GEN={any})", .{title[0]});
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
        // Reset color
        try std.io.getStdOut().writer().writeAll("\x1B[0m");

        if ((i + 1) % sq == 0) {
            try std.io.getStdOut().writer().writeAll("\n\t  ");
        }
    }
    try std.io.getStdOut().writer().writeAll("\n");
    // try std.io.getStdOut().flush();

    std.time.sleep(std.time.ns_per_s / 10);
}

pub fn randomise(cells: *Cells) void {
    var prng = std.Random.DefaultPrng.init(@intCast(std.time.milliTimestamp()));
    for (cells, 0..) |_, c| {
        const bit = prng.random().float(f64);
        if (bit < 0.5) {
            mask(cells, c, 0);
        } else {
            mask(cells, c, 1);
        }
    }
}

pub fn check(cells: *Cells, pos: usize) void {
    const offsets = [8]isize{ -sq - 1, -sq, -sq + 1, -1, 1, sq - 1, sq, sq + 1 };
    const live = get(cells, pos) == 1;
    var count: usize = 0;
    for (offsets) |offset| {
        const conv: isize = @intCast(pos);
        const norm: isize = conv + offset;
        const posi: isize = @intCast(pos);
        if (norm >= 0 and norm < cells.*.len and @abs(@mod(posi, @as(isize, sq)) - @mod(norm, @as(isize, sq))) <= 1) {
            count += get(cells, @intCast(norm));
        }
    }

    if (live) {
        if (count == 2 or count == 3) return;
        set(cells, pos);
    } else if (count == 3) {
        set(cells, pos);
    }
}

pub fn set(cells: *Cells, pos: usize) void {
    cells.*[pos] = ~cells.*[pos];
}

pub fn mask(cells: *Cells, pos: usize, bit: u1) void {
    cells.*[pos] = bit;
}

pub fn get(cells: *Cells, pos: usize) u1 {
    return cells.*[pos];
}
