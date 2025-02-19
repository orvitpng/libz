const system = @import("./system/root.zig");

pub fn print(comptime fmt: []const u8, args: anytype) void {
    _ = args;
    _ = system.write(system.get_std_handle(.err), fmt) catch return;
}

pub fn println(comptime fmt: []const u8, args: anytype) void {
    print(fmt ++ "\n", args);
}
