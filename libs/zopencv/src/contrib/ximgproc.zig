const std = @import("std");
const c_import = @import("../c.zig");
const c = c_import.c;
const core = @import("../core.zig");

pub const Mat = core.Mat;
pub const Error = core.Error;

// ============================================================================
// Edge-Preserving Filters
// ============================================================================

/// Guided filter - edge-preserving smoothing
pub fn guidedFilter(src: Mat, guide: Mat, dst: *Mat, radius: i32, eps: f64) void {
    c.GuidedFilter(src.ptr, guide.ptr, dst.ptr, radius, eps);
}

/// Bilateral texture filter
pub fn bilateralTextureFilter(src: Mat, dst: *Mat, fr: i32, numIter: i32, sigmaAlpha: f64, sigmaAvg: f64) void {
    c.BilateralTextureFilter(src.ptr, dst.ptr, fr, numIter, sigmaAlpha, sigmaAvg);
}

/// Adaptive manifold filter
pub fn adaptiveManifoldFilter(src: Mat, dst: *Mat, sigma_s: f64, sigma_r: f64, adjust_outliers: bool) void {
    c.AdaptiveManifoldFilter(src.ptr, dst.ptr, sigma_s, sigma_r, adjust_outliers);
}

// ============================================================================
// Edge Detection
// ============================================================================

/// Structured edge detection
pub const StructuredEdgeDetection = struct {
    ptr: *c.StructuredEdgeDetection,

    const Self = @This();

    /// Create from model file
    pub fn create(model_path: [:0]const u8) Error!Self {
        const ptr = c.StructuredEdgeDetection_Create(model_path.ptr) orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Release resources
    pub fn deinit(self: *Self) void {
        c.StructuredEdgeDetection_Delete(self.ptr);
        self.ptr = undefined;
    }

    /// Detect edges in image
    pub fn detectEdges(self: Self, src: Mat, dst: *Mat) void {
        c.StructuredEdgeDetection_DetectEdges(self.ptr, src.ptr, dst.ptr);
    }
};

// ============================================================================
// Morphological Operations
// ============================================================================

/// Thinning types
pub const ThinningType = enum(i32) {
    ZHANGSUEN = 0,
    GUOHALL = 1,
};

/// Apply binary blob thinning (skeletonization)
/// src must be CV_8UC1 binary image
pub fn thinning(src: Mat, dst: *Mat, thinning_type: ThinningType) void {
    c.Ximgproc_Thinning(src.ptr, dst.ptr, @intFromEnum(thinning_type));
}

// ============================================================================
// Thresholding
// ============================================================================

/// Binarization methods for niBlackThreshold
pub const BinarizationMethod = enum(i32) {
    NIBLACK = 0,
    SAUVOLA = 1,
    WOLF = 2,
    NICK = 3,
};

/// Perform niBlack thresholding on a grayscale image
pub fn niBlackThreshold(src: Mat, dst: *Mat, max_value: f64, threshold_type: i32, block_size: i32, k: f64, method: BinarizationMethod) void {
    c.Ximgproc_NiBlackThreshold(src.ptr, dst.ptr, max_value, threshold_type, block_size, k, @intFromEnum(method));
}

// ============================================================================
// Diffusion
// ============================================================================

/// Perform anisotropic diffusion on an image
/// alpha: step forward amount per iteration (normally <= 0.25)
/// k: sensitivity to edges
/// niters: number of iterations
pub fn anisotropicDiffusion(src: Mat, dst: *Mat, alpha: f32, k: f32, niters: i32) void {
    c.Ximgproc_AnisotropicDiffusion(src.ptr, dst.ptr, alpha, k, niters);
}
