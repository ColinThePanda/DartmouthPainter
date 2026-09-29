const std = @import("std");
const c_import = @import("c.zig");
const c = c_import.c;
const core = @import("core.zig");

pub const Mat = core.Mat;
pub const Point = core.Point;
pub const Error = core.Error;

// ============================================================================
// Denoising
// ============================================================================

/// Non-local means denoising for grayscale images
pub fn fastNlMeansDenoising(
    src: Mat,
    dst: *Mat,
    h: f32,
    templateWindowSize: i32,
    searchWindowSize: i32,
) void {
    c.FastNlMeansDenoising(src.ptr, dst.ptr, h, templateWindowSize, searchWindowSize);
}

/// Non-local means denoising for colored images
pub fn fastNlMeansDenoisingColored(
    src: Mat,
    dst: *Mat,
    h: f32,
    hColor: f32,
    templateWindowSize: i32,
    searchWindowSize: i32,
) void {
    c.FastNlMeansDenoisingColored(src.ptr, dst.ptr, h, hColor, templateWindowSize, searchWindowSize);
}

// ============================================================================
// Inpainting
// ============================================================================

/// Inpaint damaged regions of an image
pub fn inpaint(
    src: Mat,
    inpaintMask: Mat,
    dst: *Mat,
    inpaintRadius: f64,
    flags: InpaintFlag,
) void {
    c.Inpaint(src.ptr, inpaintMask.ptr, dst.ptr, inpaintRadius, @intFromEnum(flags));
}

pub const InpaintFlag = enum(i32) {
    ns = 0, // Navier-Stokes based method
    telea = 1, // Fast marching method
};

// ============================================================================
// Edge-Preserving Filters
// ============================================================================

/// Detail enhancement filter
pub fn detailEnhance(src: Mat, dst: *Mat, sigma_s: f32, sigma_r: f32) void {
    c.DetailEnhance(src.ptr, dst.ptr, sigma_s, sigma_r);
}

/// Edge-preserving filter
pub fn edgePreservingFilter(
    src: Mat,
    dst: *Mat,
    flags: EdgePreservingFilterFlag,
    sigma_s: f32,
    sigma_r: f32,
) void {
    c.EdgePreservingFilter(src.ptr, dst.ptr, @intFromEnum(flags), sigma_s, sigma_r);
}

pub const EdgePreservingFilterFlag = enum(i32) {
    recurs_filter = 1,
    normconv_filter = 2,
};

/// Pencil sketch effect
pub fn pencilSketch(
    src: Mat,
    dst1: *Mat,
    dst2: *Mat,
    sigma_s: f32,
    sigma_r: f32,
    shade_factor: f32,
) void {
    c.PencilSketch(src.ptr, dst1.ptr, dst2.ptr, sigma_s, sigma_r, shade_factor);
}

/// Stylization filter
pub fn stylization(src: Mat, dst: *Mat, sigma_s: f32, sigma_r: f32) void {
    c.Stylization(src.ptr, dst.ptr, sigma_s, sigma_r);
}

// ============================================================================
// Seamless Cloning
// ============================================================================

/// Seamless cloning for image composition
pub fn seamlessClone(
    src: Mat,
    dst: Mat,
    mask: Mat,
    p: Point,
    blend: *Mat,
    flags: SeamlessCloningFlag,
) void {
    c.SeamlessClone(src.ptr, dst.ptr, mask.ptr, p.toC(), blend.ptr, @intFromEnum(flags));
}

pub const SeamlessCloningFlag = enum(i32) {
    normal_clone = 1,
    mixed_clone = 2,
    monochrome_transfer = 3,
};

// ============================================================================
// Color Change and Illumination Change
// ============================================================================

/// Change color of selected region
pub fn colorChange(
    src: Mat,
    mask: Mat,
    dst: *Mat,
    red_mul: f32,
    green_mul: f32,
    blue_mul: f32,
) void {
    c.ColorChange(src.ptr, mask.ptr, dst.ptr, red_mul, green_mul, blue_mul);
}

/// Change illumination of selected region
pub fn illuminationChange(
    src: Mat,
    mask: Mat,
    dst: *Mat,
    alpha: f32,
    beta: f32,
) void {
    c.IlluminationChange(src.ptr, mask.ptr, dst.ptr, alpha, beta);
}

/// Texture flattening
pub fn textureFlattening(
    src: Mat,
    mask: Mat,
    dst: *Mat,
    low_threshold: f32,
    high_threshold: f32,
    kernel_size: i32,
) void {
    c.TextureFlattening(src.ptr, mask.ptr, dst.ptr, low_threshold, high_threshold, kernel_size);
}

// ============================================================================
// Decolorization
// ============================================================================

/// Enhanced grayscale conversion
pub fn decolorization(src: Mat, grayscale: *Mat, color_boost: *Mat) void {
    c.Decolorization(src.ptr, grayscale.ptr, color_boost.ptr);
}

// ============================================================================
// HDR / Tonemap Pipeline
// ============================================================================

/// MergeMertens exposure fusion
pub const MergeMertens = struct {
    ptr: ?*anyopaque,

    const Self = @This();

    pub fn init() Self {
        return .{ .ptr = c.MergeMertens_Create() };
    }

    pub fn initWithParams(contrast_weight: f32, saturation_weight: f32, exposure_weight: f32) Self {
        return .{ .ptr = c.MergeMertens_CreateWithParams(contrast_weight, saturation_weight, exposure_weight) };
    }

    pub fn process(self: Self, src_imgs: []const Mat, dst: *Mat) void {
        var ptrs = std.heap.c_allocator.alloc(?*anyopaque, src_imgs.len) catch return;
        defer std.heap.c_allocator.free(ptrs);
        for (src_imgs, 0..) |img, i| {
            ptrs[i] = img.ptr;
        }
        c.MergeMertens_Process(self.ptr, @ptrCast(ptrs.ptr), @intCast(src_imgs.len), dst.ptr);
    }

    pub fn deinit(self: Self) void {
        c.MergeMertens_Close(self.ptr);
    }
};

/// Tonemap
pub const Tonemap = struct {
    ptr: ?*anyopaque,

    const Self = @This();

    pub fn init(gamma: f32) Self {
        return .{ .ptr = c.Tonemap_Create(gamma) };
    }

    pub fn process(self: Self, src: Mat, dst: *Mat) void {
        c.Tonemap_Process(self.ptr, src.ptr, dst.ptr);
    }

    pub fn deinit(self: Self) void {
        c.Tonemap_Close(self.ptr);
    }
};

/// AlignMTB exposure alignment
pub const AlignMTB = struct {
    ptr: ?*anyopaque,

    const Self = @This();

    pub fn init(max_bits: i32, exclude_range: i32, cut: bool) Self {
        return .{ .ptr = c.AlignMTB_Create(max_bits, exclude_range, if (cut) 1 else 0) };
    }

    /// Align input images
    pub fn process(self: Self, src_imgs: []const Mat, dst_imgs: []Mat) void {
        var src_ptrs = std.heap.c_allocator.alloc(?*anyopaque, src_imgs.len) catch return;
        defer std.heap.c_allocator.free(src_ptrs);
        for (src_imgs, 0..) |img, i| {
            src_ptrs[i] = img.ptr;
        }
        var dst_ptrs = std.heap.c_allocator.alloc(?*anyopaque, dst_imgs.len) catch return;
        defer std.heap.c_allocator.free(dst_ptrs);
        for (dst_imgs, 0..) |img, i| {
            dst_ptrs[i] = img.ptr;
        }
        c.AlignMTB_Process(self.ptr, @ptrCast(src_ptrs.ptr), @intCast(src_imgs.len), @ptrCast(dst_ptrs.ptr));
    }

    pub fn deinit(self: Self) void {
        c.AlignMTB_Close(self.ptr);
    }
};

/// CalibrateDebevec camera response calibration
pub const CalibrateDebevec = struct {
    ptr: ?*anyopaque,

    const Self = @This();

    pub fn init(samples: i32, lambda: f32, random: bool) Self {
        return .{ .ptr = c.CalibrateDebevec_Create(samples, lambda, if (random) 1 else 0) };
    }

    /// Recovers inverse camera response function
    pub fn process(self: Self, src_imgs: []const Mat, dst: *Mat, times: Mat) void {
        var src_ptrs = std.heap.c_allocator.alloc(?*anyopaque, src_imgs.len) catch return;
        defer std.heap.c_allocator.free(src_ptrs);
        for (src_imgs, 0..) |img, i| {
            src_ptrs[i] = img.ptr;
        }
        c.CalibrateDebevec_Process(self.ptr, @ptrCast(src_ptrs.ptr), @intCast(src_imgs.len), dst.ptr, times.ptr);
    }

    pub fn deinit(self: Self) void {
        c.CalibrateDebevec_Close(self.ptr);
    }
};

/// MergeDebevec HDR merge
pub const MergeDebevec = struct {
    ptr: ?*anyopaque,

    const Self = @This();

    pub fn init() Self {
        return .{ .ptr = c.MergeDebevec_Create() };
    }

    /// Merges images into HDR image
    pub fn process(self: Self, src_imgs: []const Mat, dst: *Mat, times: Mat, response: Mat) void {
        var src_ptrs = std.heap.c_allocator.alloc(?*anyopaque, src_imgs.len) catch return;
        defer std.heap.c_allocator.free(src_ptrs);
        for (src_imgs, 0..) |img, i| {
            src_ptrs[i] = img.ptr;
        }
        c.MergeDebevec_Process(self.ptr, @ptrCast(src_ptrs.ptr), @intCast(src_imgs.len), dst.ptr, times.ptr, response.ptr);
    }

    pub fn deinit(self: Self) void {
        c.MergeDebevec_Close(self.ptr);
    }
};

// ============================================================================
// Tonemap Variants
// ============================================================================

pub const TonemapDrago = struct {
    const Self = @This();
    ptr: ?*anyopaque,

    pub fn init(gamma: f32, saturation: f32, bias: f32) Self {
        return .{ .ptr = c.TonemapDrago_Create(gamma, saturation, bias) };
    }

    pub fn process(self: Self, src: Mat, dst: *Mat) void {
        c.TonemapDrago_Process(self.ptr, src.ptr, dst.ptr);
    }

    pub fn deinit(self: Self) void {
        c.TonemapDrago_Close(self.ptr);
    }
};

pub const TonemapReinhard = struct {
    const Self = @This();
    ptr: ?*anyopaque,

    pub fn init(gamma: f32, intensity: f32, lightAdapt: f32, colorAdapt: f32) Self {
        return .{ .ptr = c.TonemapReinhard_Create(gamma, intensity, lightAdapt, colorAdapt) };
    }

    pub fn process(self: Self, src: Mat, dst: *Mat) void {
        c.TonemapReinhard_Process(self.ptr, src.ptr, dst.ptr);
    }

    pub fn deinit(self: Self) void {
        c.TonemapReinhard_Close(self.ptr);
    }
};

pub const TonemapMantiuk = struct {
    const Self = @This();
    ptr: ?*anyopaque,

    pub fn init(gamma: f32, scale: f32, saturation: f32) Self {
        return .{ .ptr = c.TonemapMantiuk_Create(gamma, scale, saturation) };
    }

    pub fn process(self: Self, src: Mat, dst: *Mat) void {
        c.TonemapMantiuk_Process(self.ptr, src.ptr, dst.ptr);
    }

    pub fn deinit(self: Self) void {
        c.TonemapMantiuk_Close(self.ptr);
    }
};

// ============================================================================
// Multi-frame Denoising
// ============================================================================

/// Perform denoising using multiple images (temporal denoising)
pub fn fastNlMeansDenoisingMulti(src_imgs: []const Mat, dst: *Mat, imgToDenoiseIndex: i32, temporalWindowSize: i32, h: f32, templateWindowSize: i32, searchWindowSize: i32) void {
    var src_ptrs = std.heap.c_allocator.alloc(?*anyopaque, src_imgs.len) catch return;
    defer std.heap.c_allocator.free(src_ptrs);
    for (src_imgs, 0..) |img, i| {
        src_ptrs[i] = img.ptr;
    }
    c.FastNlMeansDenoisingMulti(@ptrCast(src_ptrs.ptr), @intCast(src_imgs.len), dst.ptr, imgToDenoiseIndex, temporalWindowSize, h, templateWindowSize, searchWindowSize);
}

/// Perform denoising on colored images using multiple frames
pub fn fastNlMeansDenoisingColoredMulti(src_imgs: []const Mat, dst: *Mat, imgToDenoiseIndex: i32, temporalWindowSize: i32, h: f32, hColor: f32, templateWindowSize: i32, searchWindowSize: i32) void {
    var src_ptrs = std.heap.c_allocator.alloc(?*anyopaque, src_imgs.len) catch return;
    defer std.heap.c_allocator.free(src_ptrs);
    for (src_imgs, 0..) |img, i| {
        src_ptrs[i] = img.ptr;
    }
    c.FastNlMeansDenoisingColoredMulti(@ptrCast(src_ptrs.ptr), @intCast(src_imgs.len), dst.ptr, imgToDenoiseIndex, temporalWindowSize, h, hColor, templateWindowSize, searchWindowSize);
}
