# tree-fmt-example

Example of how to use [tree-fmt](https://github.com/speed2exe/tree-fmt) via the Zig package manager.

## Requirements

- Zig `0.16.0`

## Add dependency

```sh
zig fetch --save https://github.com/speed2exe/tree-fmt/archive/0.16.0.tar.gz
```

This adds `tree-fmt` to your `build.zig.zon`:

```zig
.dependencies = .{
    .tree_fmt = .{
        .url = "https://github.com/speed2exe/tree-fmt/archive/0.16.0.tar.gz",
        .hash = "tree_fmt-0.16.0-zrQKk7_GAABRaLF_ryiV1tF7R4u5h3KOyp2qVBGgzTn_",
    },
},
```

## Wire up in `build.zig`

```zig
const tree_fmt_dep = b.dependency("tree_fmt", .{ .target = target, .optimize = optimize });
const exe_mod = b.createModule(.{
    .root_source_file = b.path("src/main.zig"),
    .target = target,
    .optimize = optimize,
});
exe_mod.addImport("tree-fmt", tree_fmt_dep.module("tree-fmt"));
const exe = b.addExecutable(.{ .name = "tree-fmt-example", .root_module = exe_mod });
b.installArtifact(exe);
```

## Usage

```zig
const std = @import("std");
const treeFormatter = @import("tree-fmt").treeFormatter;
var fmt = @import("tree-fmt").defaultFormatter();

pub fn main(init: std.process.Init) !void {
    // Quick example — uses defaultFormatter() which prints via std.debug.print
    try fmt.format(.{ 1, 2.4, "hi" }, .{});

    // Full example — custom writer + allocator
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
    var tree_fmt = treeFormatter(init.gpa, DebugWriter{});
    try tree_fmt.format(.{ "hello", 42 }, .{ .name = "root" });
}
```

## Run

```sh
zig build run
```
