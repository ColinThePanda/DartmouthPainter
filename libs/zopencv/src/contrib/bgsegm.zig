const std = @import("std");
const c_import = @import("../c.zig");
const c = c_import.c;
const core = @import("../core.zig");

pub const Mat = core.Mat;
pub const Error = core.Error;

// ============================================================================
// Background Subtraction Algorithms
// ============================================================================

/// Background subtractor for video analysis
pub const BackgroundSubtractor = struct {
    ptr: *c.BackgroundSubtractor,

    const Self = @This();

    /// Create MOG (Mixture of Gaussians) background subtractor
    pub fn createMOG(history: i32, nmixtures: i32, background_ratio: f64, noise_sigma: f64) Error!Self {
        const ptr = c.BackgroundSubtractorMOG_Create(history, nmixtures, background_ratio, noise_sigma) orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Create GMG (Godbehere-Matsukawa-Goldberg) background subtractor
    pub fn createGMG(initialization_frames: i32, decision_threshold: f64) Error!Self {
        const ptr = c.BackgroundSubtractorGMG_Create(initialization_frames, decision_threshold) orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Create CNT (Counting) background subtractor
    pub fn createCNT(min_pixel_stability: i32, use_history: bool, max_pixel_stability: i32, is_parallel: bool) Error!Self {
        const ptr = c.BackgroundSubtractorCNT_Create(min_pixel_stability, use_history, max_pixel_stability, is_parallel) orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Create GSOC background subtractor
    pub fn createGSOC() Error!Self {
        // Use default parameters (mc = 0 for LSBP_CAMERA_MOTION_COMPENSATION_NONE)
        // noiseRemovalThresholdFacBG and noiseRemovalThresholdFacFG must be >= 0 and < 0.5
        const ptr = c.BackgroundSubtractorGSOC_Create(0, 16, 0.003, 0.01, 15, 0.01, 0.0022, 0.1, 0.1, 0.1, 0.15) orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Create LSBP (Local SVD Binary Pattern) background subtractor
    pub fn createLSBP() Error!Self {
        // Use default parameters (mc = 0 for LSBP_CAMERA_MOTION_COMPENSATION_NONE)
        // noiseRemovalThresholdFacBG and noiseRemovalThresholdFacFG must be >= 0 and < 0.5
        const ptr = c.BackgroundSubtractorLSBP_Create(0, 16, 16, 1.0, 2.0, 0.25, 0.05, 1.5, 0.02, 0.1, 0.15, 20, 2) orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Release resources
    pub fn deinit(self: *Self) void {
        c.BackgroundSubtractor_Delete(self.ptr);
        self.ptr = undefined;
    }

    /// Apply background subtraction to get foreground mask
    pub fn apply(self: Self, image: Mat, fgmask: *Mat, learning_rate: f64) void {
        c.BackgroundSubtractor_Apply(self.ptr, image.ptr, fgmask.ptr, learning_rate);
    }

    /// Get the background image
    pub fn getBackgroundImage(self: Self, background_image: *Mat) void {
        c.BackgroundSubtractor_GetBackgroundImage(self.ptr, background_image.ptr);
    }
};
