const std = @import("std");
const treeFormatter = @import("tree-fmt").treeFormatter;
var fmt = @import("tree-fmt").defaultFormatter();

pub fn main(init: std.process.Init) !void {
    try quickExample();
    try fullExample(init.gpa);
}

fn quickExample() !void {
    std.debug.print("\nQuick Example:\n", .{});
    try fmt.format(.{ 1, 2.4, "hi" }, .{});
}

fn fullExample(allocator: std.mem.Allocator) !void {
    std.debug.print("\nFull Example:\n", .{});

    const DebugWriter = struct {
        pub fn print(self: @This(), comptime f: []const u8, args: anytype) !void {
            _ = self;
            std.debug.print(f, args);
        }
        pub fn writeAll(self: @This(), bytes: []const u8) !void {
            _ = self;
            std.debug.print("{s}", .{bytes});
        }
    };

    var tree_formatter = treeFormatter(allocator, DebugWriter{});

    var ast = try std.zig.Ast.parse(allocator, zig_code, .zig);
    defer ast.deinit(allocator);

    try tree_formatter.format(ast.tokens, .{
        .name = "MyFavoriteAst",
    });
}

const zig_code =
    \\ const std = @import("std");
    \\
    \\ pub fn main() void {
    \\     std.debug.print("hello {s}", .{"world"});
    \\ }
;
