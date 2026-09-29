const std = @import("std");
const c_import = @import("../c.zig");
const c = c_import.c;
const core = @import("../core.zig");

pub const Mat = core.Mat;
pub const Error = core.Error;

// ============================================================================
// DualTVL1OpticalFlow — Dense Optical Flow
// ============================================================================

/// Dense optical flow using DualTVL1 algorithm.
///
/// This implementation is based on the "Duality Based Approach for Realtime
/// TV-L1 Optical Flow" paper. It produces high-quality flow fields and is
/// well-suited for applications requiring accurate dense optical flow.
pub const DualTVL1OpticalFlow = struct {
    ptr: *c.DualTVL1OpticalFlow,

    const Self = @This();

    /// Create DualTVL1OpticalFlow with default parameters
    pub fn create() Error!Self {
        const ptr = c.DualTVL1OpticalFlow_Create() orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Release resources
    pub fn deinit(self: *Self) void {
        c.DualTVL1OpticalFlow_Delete(self.ptr);
        self.ptr = undefined;
    }

    /// Calculate dense optical flow
    /// prev: first 8-bit single-channel input image
    /// next: second input image of same size and type
    /// flow: computed flow image of size prev and type CV_32FC2
    pub fn calc(self: Self, prev: Mat, next: Mat, flow: *Mat) void {
        c.DualTVL1OpticalFlow_Calc(self.ptr, prev.ptr, next.ptr, flow.ptr);
    }
};
