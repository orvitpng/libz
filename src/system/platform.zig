const builtin = @import("builtin");

pub const Os = enum { linux };
pub const Arch = enum { x86_64 };

pub const Pair = struct {
    arch: Arch,
    os: Os,
};

pub const target = Pair{
    .os = switch (builtin.os.tag) {
        .linux => .linux,
        else => @compileError("unsupported os"),
    },
    .arch = switch (builtin.cpu.arch) {
        .x86_64 => .x86_64,
        else => @compileError("unsupported architecture"),
    },
};
