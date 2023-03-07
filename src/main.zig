const std = @import("std");
const treeFormatter = @import("tree-fmt").treeFormatter;
var fmt = @import("tree-fmt").defaultFormatter();

pub fn main() !void {
    try quickExample();
    try fullExample();
}

fn quickExample() !void {
    std.debug.print("\nQuick Example:\n", .{});
    try fmt.formatValue(.{ 1, 2.4, "hi" });
}

fn fullExample() !void {
    std.debug.print("\nFull Example:\n", .{});

    // allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const leaked = gpa.deinit();
        if (leaked) {
            @panic("leaked memory!");
        }
    }

    // writer
    var w = std.io.getStdOut().writer();

    // tree formatter (the actual formatter you use)
    var tree_formatter = treeFormatter(allocator, w, .{});

    // complicated structure to debug
    var ast = try std.zig.Ast.parse(allocator, zig_code, .zig);
    defer ast.deinit(allocator);

    // print the structure
    try tree_formatter.formatValueWithId(ast.tokens, "MyFavoriteAst");
}

const zig_code =
    \\ const std = @import("std");
    \\
    \\ pub fn main() void {
    \\     std.debug.print("hello {s}", .{"world"});
    \\ }
;