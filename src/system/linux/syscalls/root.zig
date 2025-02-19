const meta = @import("../../../meta.zig");
const platform = @import("../../platform.zig");

const parts = switch (platform.target.arch) {
    .x86_64 => @import("./x86_64.zig"),
};

pub const Calls = parts.Calls;

pub fn dispatch(call_enum: Calls, args_tuple: anytype) usize {
    const args = meta.tuple_args(usize, args_tuple);
    comptime if (args.len > 6)
        @compileError("linux syscalls take up to 6 arguments");

    const call = @intFromEnum(call_enum);
    return switch (args.len) {
        0 => parts.zero(call),
        1 => parts.one(call, args[0]),
        2 => parts.two(call, args[0], args[1]),
        3 => parts.three(call, args[0], args[1], args[2]),
        4 => parts.four(call, args[0], args[1], args[2], args[3]),
        5 => parts.five(call, args[0], args[1], args[2], args[3], args[4]),
        6 => parts.six(
            call,
            args[0],
            args[1],
            args[2],
            args[3],
            args[4],
            args[5],
        ),
        else => unreachable,
    };
}
