const std = @import("std");
const c_import = @import("../c.zig");
const c = c_import.c;
const core = @import("../core.zig");

pub const Mat = core.Mat;
pub const Error = core.Error;

// ============================================================================
// White Balance
// ============================================================================

/// White balancer for automatic white balance correction
pub const WhiteBalancer = struct {
    ptr: *c.WhiteBalancer,

    const Self = @This();

    /// Create simple white balancer
    pub fn createSimple() Error!Self {
        const ptr = c.WhiteBalancer_CreateSimple() orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Create gray world white balancer
    pub fn createGrayWorld() Error!Self {
        const ptr = c.WhiteBalancer_CreateGrayWorld() orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Create learning-based white balancer
    pub fn createLearningBased() Error!Self {
        const ptr = c.WhiteBalancer_CreateLearningBased() orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Release resources
    pub fn deinit(self: *Self) void {
        c.WhiteBalancer_Delete(self.ptr);
        self.ptr = undefined;
    }

    /// Balance white in image
    pub fn balanceWhite(self: Self, src: Mat, dst: *Mat) void {
        c.WhiteBalancer_BalanceWhite(self.ptr, src.ptr, dst.ptr);
    }
};

// ============================================================================
// Denoising
// ============================================================================

/// BM3D denoising
pub fn bm3dDenoising(src: Mat, dst: *Mat, h: f32) void {
    c.Bm3dDenoising(src.ptr, dst.ptr, h);
}

// ============================================================================
// Inpainting
// ============================================================================

/// Inpaint using Fast Marching Method
pub fn inpaintFMM(src: Mat, mask: Mat, dst: *Mat, radius: i32) void {
    c.InpaintFMM(src.ptr, mask.ptr, dst.ptr, radius);
}

// ============================================================================
// Oil Painting Effect
// ============================================================================

/// Apply oil painting effect to an image
pub fn oilPainting(src: Mat, dst: *Mat, size: i32, dyn_ratio: i32) void {
    c.Xphoto_OilPainting(src.ptr, dst.ptr, size, dyn_ratio);
}

// ============================================================================
// Channel Gains
// ============================================================================

/// Apply per-channel gains to an image
pub fn applyChannelGains(src: Mat, dst: *Mat, gain_b: f32, gain_g: f32, gain_r: f32) void {
    c.Xphoto_ApplyChannelGains(src.ptr, dst.ptr, gain_b, gain_g, gain_r);
}

// ============================================================================
// DCT Denoising
// ============================================================================

/// DCT-based image denoising
/// sigma: expected noise standard deviation
/// psize: size of block side (default 16)
pub fn dctDenoising(src: Mat, dst: *Mat, sigma: f64, psize: i32) void {
    c.Xphoto_DctDenoising(src.ptr, dst.ptr, sigma, psize);
}
