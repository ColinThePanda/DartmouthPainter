const std = @import("std");
const c_import = @import("c.zig");
const c = c_import.c;
const core = @import("core.zig");

pub const Mat = core.Mat;
pub const Error = core.Error;

/// Image read modes
pub const ImreadMode = enum(i32) {
    unchanged = -1,
    grayscale = 0,
    color = 1,
    anydepth = 2,
    anycolor = 4,
    load_gdal = 8,
    reduced_grayscale_2 = 16,
    reduced_color_2 = 17,
    reduced_grayscale_4 = 32,
    reduced_color_4 = 33,
    reduced_grayscale_8 = 64,
    reduced_color_8 = 65,
    ignore_orientation = 128,
};

/// Read image from file
pub fn imread(filename: []const u8, flags: ImreadMode) !Mat {
    const filename_z = try std.heap.c_allocator.dupeZ(u8, filename);
    defer std.heap.c_allocator.free(filename_z);

    const ptr = c.ImRead(filename_z.ptr, @intFromEnum(flags)) orelse return Error.MatCreationFailed;
    return Mat{ .ptr = ptr };
}

/// Write image to file
pub fn imwrite(filename: []const u8, img: Mat) !void {
    const filename_z = try std.heap.c_allocator.dupeZ(u8, filename);
    defer std.heap.c_allocator.free(filename_z);

    const result = c.ImWrite(filename_z.ptr, img.ptr);
    if (result == 0) {
        return error.ImWriteFailed;
    }
}

/// Write image to file with compression parameters
pub fn imwriteWithParams(filename: []const u8, img: Mat, params: []const i32) !void {
    const filename_z = try std.heap.c_allocator.dupeZ(u8, filename);
    defer std.heap.c_allocator.free(filename_z);

    const result = c.ImWriteWithParams(
        filename_z.ptr,
        img.ptr,
        @constCast(params.ptr),
        @intCast(params.len),
    );
    if (result == 0) {
        return error.ImWriteFailed;
    }
}

/// Encode image to memory buffer
pub fn imencode(ext: []const u8, img: Mat, params: ?[]const i32) ![]u8 {
    const ext_z = try std.heap.c_allocator.dupeZ(u8, ext);
    defer std.heap.c_allocator.free(ext_z);

    const p_ptr = if (params) |p| @constCast(p.ptr) else null;
    const p_len: i32 = if (params) |p| @intCast(p.len) else 0;

    const result = c.ImEncode(ext_z.ptr, img.ptr, p_ptr, p_len);
    if (result.data == null) {
        return error.ImEncodeFailed;
    }
    const len: usize = @intCast(result.length);
    // Caller must free with std.heap.c_allocator.free()
    return result.data[0..len];
}

/// Decode image from memory buffer
pub fn imdecode(buf: []const u8, flags: ImreadMode) !Mat {
    const ptr = c.ImDecode(
        @ptrCast(@constCast(buf.ptr)),
        @intCast(buf.len),
        @intFromEnum(flags),
    ) orelse return Error.MatCreationFailed;
    return Mat{ .ptr = ptr };
}

/// Check if the specified image file can be decoded
pub fn haveImageReader(filename: []const u8) !bool {
    const filename_z = try std.heap.c_allocator.dupeZ(u8, filename);
    defer std.heap.c_allocator.free(filename_z);
    return c.HaveImageReader(filename_z.ptr) != 0;
}

/// Check if the specified image file can be encoded
pub fn haveImageWriter(filename: []const u8) !bool {
    const filename_z = try std.heap.c_allocator.dupeZ(u8, filename);
    defer std.heap.c_allocator.free(filename_z);
    return c.HaveImageWriter(filename_z.ptr) != 0;
}

/// Get number of images in a multi-page file
pub fn imcount(filename: []const u8, flags: ImreadMode) !i32 {
    const filename_z = try std.heap.c_allocator.dupeZ(u8, filename);
    defer std.heap.c_allocator.free(filename_z);
    return c.ImCount(filename_z.ptr, @intFromEnum(flags));
}

/// Read multiple images from a multi-page file
pub fn imreadMulti(filename: []const u8, flags: ImreadMode, allocator: std.mem.Allocator) ![]Mat {
    const filename_z = try std.heap.c_allocator.dupeZ(u8, filename);
    defer std.heap.c_allocator.free(filename_z);

    var count: c_int = 0;
    // First call to get count
    _ = c.ImReadMulti(filename_z.ptr, @intFromEnum(flags), null, &count);
    if (count <= 0) return error.ImReadFailed;

    // Allocate array for mat pointers
    const mat_ptrs = try allocator.alloc(?*anyopaque, @intCast(count));
    defer allocator.free(mat_ptrs);

    var actual_count: c_int = count;
    _ = c.ImReadMulti(filename_z.ptr, @intFromEnum(flags), @ptrCast(mat_ptrs.ptr), &actual_count);

    const result = try allocator.alloc(Mat, @intCast(actual_count));
    for (0..@intCast(actual_count)) |i| {
        result[i] = Mat{ .ptr = mat_ptrs[i] };
    }
    return result;
}

/// ImwriteFlags for compression parameters
pub const ImwriteFlags = struct {
    pub const jpeg_quality: i32 = 1;
    pub const jpeg_progressive: i32 = 2;
    pub const jpeg_optimize: i32 = 3;
    pub const jpeg_rst_interval: i32 = 4;
    pub const jpeg_luma_quality: i32 = 5;
    pub const jpeg_chroma_quality: i32 = 6;
    pub const png_compression: i32 = 16;
    pub const png_strategy: i32 = 17;
    pub const png_bilevel: i32 = 18;
    pub const pxm_binary: i32 = 32;
    pub const webp_quality: i32 = 64;
    pub const tiff_resunit: i32 = 256;
    pub const tiff_xdpi: i32 = 257;
    pub const tiff_ydpi: i32 = 258;
    pub const tiff_compression: i32 = 259;
};
