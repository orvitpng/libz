const std = @import("std");

pub fn tuple_args(comptime T: type, args: anytype) [
    blk: {
        const ArgsType = @TypeOf(args);
        const info = @typeInfo(ArgsType);
        if (info != .Struct or !info.Struct.is_tuple)
            @compileError("expected tuple argument, found " ++
                @typeName(ArgsType));

        break :blk info.Struct.fields.len;
    }
]T {
    const fields = @typeInfo(@TypeOf(args)).Struct.fields;
    var results: [fields.len]T = undefined;
    inline for (fields, 0..) |field, i| {
        if (field.type != T)
            @compileError("expected all arguments to be of type " ++
                @typeName(T) ++
                ", but index " ++
                field.name ++
                " is of type " ++
                @typeName(field.type));

        results[i] = @field(args, field.name);
    }

    return results;
}
