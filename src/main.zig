const std = @import("std");
const con = @import("conway.zig");

pub fn main() !void {
    // Max to keep the GEN able to pass into []const u8
    const GEN = 256;
    var cells: con.Cells = [_]u1{1} ** con.CELL_COUNT;
    con.randomise(&cells);
    var i: usize = 0;
    while (i < GEN) : (i += 1) {
        for (cells, 0..) |_, c| {
            con.check(&cells, c);
        }
        std.debug.print("\n", .{});
        _ = try con.debug(&cells, &[_]u8{@intCast(i)});
    }
}
test "Randomise" {
    var cells: con.Cells = [_]u1{0} ** con.CELL_COUNT;
    con.randomise(&cells);
    con.debug(&cells, "Conway") catch {};
}
