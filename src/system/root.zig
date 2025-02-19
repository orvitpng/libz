const linux = @import("./linux/root.zig");
const target = switch (platform.target.os) {
    .linux => linux,
};

pub const platform = @import("./platform.zig");

pub fn read(handle: Handle, buf: []u8) ReadError!usize {
    const count = max_rw(buf.len);
    return switch (platform.target.os) {
        .linux => while (true) {
            const result = linux.read(handle.linux, buf.ptr, count);
            break switch (linux.get_errno(@bitCast(result))) {
                .ok => |r| r,
                .err => |e| switch (e) {
                    .intr => continue,
                    .io => error.IO,
                    .badf => error.NotOpenForReading,
                    .again => error.WouldBlock,
                    .isdir => error.IsDir,
                    .fault, .inval => unreachable,
                    else => unreachable,
                },
            };
        },
    };
}
pub const ReadError = error{
    IO,
    IsDir,
    NotOpenForReading,
    WouldBlock,
};

pub fn write(handle: Handle, buf: []const u8) WriteError!usize {
    const count = max_rw(buf.len);
    return switch (platform.target.os) {
        .linux => while (true) {
            const result = linux.write(handle.linux, buf.ptr, count);
            break switch (linux.get_errno(@bitCast(result))) {
                .ok => |r| r,
                .err => |e| switch (e) {
                    .intr => continue,
                    .perm => error.AccessDenied,
                    .io => error.IO,
                    .again => error.WouldBlock,
                    .badf => error.NotOpenForWriting,
                    .fbig => error.FileTooBig,
                    .nospc => error.NoSpaceLeft,
                    .pipe => error.BrokenPipe,
                    .dquot => error.DiskQuota,
                    .fault, .inval, .destaddrreq => unreachable,
                    else => unreachable,
                },
            };
        },
    };
}
pub const WriteError = error{
    AccessDenied,
    BrokenPipe,
    DiskQuota,
    IO,
    NoSpaceLeft,
    NotOpenForWriting,
    FileTooBig,
    WouldBlock,
};

pub fn get_std_handle(stream: StandardStream) Handle {
    return switch (platform.target.os) {
        .linux => .{ .linux = switch (stream) {
            .in => linux.STDIN_FD,
            .out => linux.STDOUT_FD,
            .err => linux.STDERR_FD,
        } },
    };
}

pub const StandardStream = enum { in, out, err };

pub const Handle = union {
    linux: linux.types.fd,
};

fn max_rw(min: usize) usize {
    return if (@hasDecl(target, "MAX_RW"))
        @min(min, target.MAX_RW)
    else
        min;
}
