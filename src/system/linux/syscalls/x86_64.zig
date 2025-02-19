pub const Calls = enum(usize) {
    read = 0,
    write = 1,
    open = 2,
    close = 3,
};

pub fn zero(call: usize) usize {
    return asm volatile ("syscall"
        : [result] "={rax}" (-> usize),
        : [call] "{rax}" (call),
        : "rcx", "x11", "memory"
    );
}

pub fn one(call: usize, arg1: usize) usize {
    return asm volatile ("syscall"
        : [result] "={rax}" (-> usize),
        : [call] "{rax}" (call),
          [arg1] "{rdi}" (arg1),
        : "rcx", "x11", "memory"
    );
}

pub fn two(call: usize, arg1: usize, arg2: usize) usize {
    return asm volatile ("syscall"
        : [result] "={rax}" (-> usize),
        : [call] "{rax}" (call),
          [arg1] "{rdi}" (arg1),
          [arg2] "{rsi}" (arg2),
        : "rcx", "x11", "memory"
    );
}

pub fn three(call: usize, arg1: usize, arg2: usize, arg3: usize) usize {
    return asm volatile ("syscall"
        : [result] "={rax}" (-> usize),
        : [call] "{rax}" (call),
          [arg1] "{rdi}" (arg1),
          [arg2] "{rsi}" (arg2),
          [arg3] "{rdx}" (arg3),
        : "rcx", "x11", "memory"
    );
}

pub fn four(
    call: usize,
    arg1: usize,
    arg2: usize,
    arg3: usize,
    arg4: usize,
) usize {
    return asm volatile ("syscall"
        : [result] "={rax}" (-> usize),
        : [call] "{rax}" (call),
          [arg1] "{rdi}" (arg1),
          [arg2] "{rsi}" (arg2),
          [arg3] "{rdx}" (arg3),
          [arg4] "{r10}" (arg4),
        : "rcx", "x11", "memory"
    );
}

pub fn five(
    call: usize,
    arg1: usize,
    arg2: usize,
    arg3: usize,
    arg4: usize,
    arg5: usize,
) usize {
    return asm volatile ("syscall"
        : [result] "={rax}" (-> usize),
        : [call] "{rax}" (call),
          [arg1] "{rdi}" (arg1),
          [arg2] "{rsi}" (arg2),
          [arg3] "{rdx}" (arg3),
          [arg4] "{r10}" (arg4),
          [arg5] "{r8}" (arg5),
        : "rcx", "x11", "memory"
    );
}

pub fn six(
    call: usize,
    arg1: usize,
    arg2: usize,
    arg3: usize,
    arg4: usize,
    arg5: usize,
    arg6: usize,
) usize {
    return asm volatile ("syscall"
        : [result] "={rax}" (-> usize),
        : [call] "{rax}" (call),
          [arg1] "{rdi}" (arg1),
          [arg2] "{rsi}" (arg2),
          [arg3] "{rdx}" (arg3),
          [arg4] "{r10}" (arg4),
          [arg5] "{r8}" (arg5),
          [arg6] "{r9}" (arg6),
        : "rcx", "x11", "memory"
    );
}
