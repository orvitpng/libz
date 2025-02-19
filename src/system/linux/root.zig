pub const syscalls = @import("./syscalls/root.zig");
pub const types = @import("./types.zig");

pub const MAX_RW = 0x7ffff000;
pub const STDIN_FD = 0;
pub const STDOUT_FD = 1;
pub const STDERR_FD = 2;

pub fn read(fd: types.fd, buf: [*]u8, count: usize) isize {
    return @bitCast(syscalls.dispatch(
        .read,
        .{ @as(usize, fd), @intFromPtr(buf), count },
    ));
}

pub fn write(fd: types.fd, buf: [*]const u8, count: usize) isize {
    return @bitCast(syscalls.dispatch(
        .write,
        .{ @as(usize, fd), @intFromPtr(buf), count },
    ));
}

pub fn open(
    filename: [*]const u8,
    flags: c_int,
    mode: types.umode,
) c_long {
    return syscalls.dispatch(.open, .{
        @intFromPtr(filename),
        @as(usize, flags),
        @as(usize, mode),
    });
}

pub fn close(fd: types.fd) c_int {
    return syscalls.dispatch(.close, .{@as(usize, fd)});
}

pub fn get_errno(result: usize) Result {
    const signed: isize = @bitCast(result);
    return if (signed < 0 and signed > -4096)
        .{ .err = @enumFromInt(-signed) }
    else
        .{ .ok = result };
}

pub const Errno = enum(u16) {
    perm = 1,
    intr = 4,
    io = 5,
    badf = 9,
    again = 11,
    fault = 14,
    isdir = 21,
    inval = 22,
    fbig = 27,
    nospc = 28,
    pipe = 32,
    destaddrreq = 89,
    dquot = 122,
};

pub const Result = union(enum) {
    ok: usize,
    err: Errno,
};
