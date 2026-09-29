const std = @import("std");
const c_import = @import("../c.zig");
const c = c_import.c;
const core = @import("../core.zig");

pub const Mat = core.Mat;
pub const Error = core.Error;

// ============================================================================
// Static Saliency
// ============================================================================

/// Computes a saliency map from a single image.
///
/// Two algorithms are provided:
/// - **Spectral Residual**: Based on the principle of natural image statistics,
///   simulates pre-attentive visual search by analyzing the log spectrum.
/// - **Fine Grained**: Calculates saliency based on center-surround differences,
///   producing high-resolution saliency maps in real time via integral images.
pub const StaticSaliency = struct {
    ptr: *c.StaticSaliency,

    const Self = @This();

    /// Create Spectral Residual saliency detector
    pub fn createSpectralResidual() Error!Self {
        const ptr = c.StaticSaliencySpectralResidual_Create() orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Create Fine Grained saliency detector
    pub fn createFineGrained() Error!Self {
        const ptr = c.StaticSaliencyFineGrained_Create() orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Release resources
    pub fn deinit(self: *Self) void {
        c.StaticSaliency_Delete(self.ptr);
        self.ptr = undefined;
    }

    /// Compute saliency map from input image
    /// Returns true on success
    pub fn computeSaliency(self: Self, image: Mat, saliencyMap: *Mat) bool {
        const result = c.StaticSaliency_ComputeSaliency(self.ptr, image.ptr, saliencyMap.ptr);
        return result != 0;
    }
};
