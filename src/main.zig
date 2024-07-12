const std = @import("std");
const con = @import("conway.zig");
pub fn main() !void {
    var cells: con.Cells = [_]u1{0} ** con.CELL_COUNT;
    _ = try con.play(&cells, 255, true);
}

test "toad" {
    // Won't work , grid dependent, will patch
    var cells: con.Cells = [_]u1{0} ** con.CELL_COUNT;
    con.set(&cells, 21, 1);
    con.set(&cells, 22, 1);
    con.set(&cells, 29, 1);
    con.set(&cells, 41, 1);
    con.set(&cells, 48, 1);
    con.set(&cells, 49, 1);
    _ = try con.debug(&cells, "Toad");
    // _ = try con.play(&cells, 1, false);
}
