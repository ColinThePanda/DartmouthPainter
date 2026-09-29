const std = @import("std");
const c_import = @import("../c.zig");
const c = c_import.c;
const core = @import("../core.zig");

pub const Mat = core.Mat;
pub const Error = core.Error;

// ============================================================================
// DNN Super Resolution
// ============================================================================

/// DNN-based super resolution for image upscaling
pub const DnnSuperResImpl = struct {
    ptr: *c.DnnSuperResImpl,

    const Self = @This();

    /// Create a new DNN super resolution object
    pub fn create() Error!Self {
        const ptr = c.DnnSuperResImpl_Create() orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Release resources
    pub fn deinit(self: *Self) void {
        c.DnnSuperResImpl_Delete(self.ptr);
        self.ptr = undefined;
    }

    /// Read and set the model from file
    /// Supported models: EDSR, ESPCN, FSRCNN, LapSRN
    pub fn readModel(self: Self, path: []const u8) void {
        const path_z = std.mem.sliceTo(path, 0);
        c.DnnSuperResImpl_ReadModel(self.ptr, path_z.ptr);
    }

    /// Set the model and scale factor
    /// algo: "edsr", "espcn", "fsrcnn", or "lapsrn"
    /// scale: upscaling factor (2, 3, 4, or 8 depending on model)
    pub fn setModel(self: Self, algo: []const u8, scale: i32) void {
        const algo_z = std.mem.sliceTo(algo, 0);
        c.DnnSuperResImpl_SetModel(self.ptr, algo_z.ptr, scale);
    }

    /// Upsample the input image
    pub fn upsample(self: Self, img: Mat, result: *Mat) void {
        c.DnnSuperResImpl_Upsample(self.ptr, img.ptr, result.ptr);
    }

    /// Get the current scale factor
    pub fn getScale(self: Self) i32 {
        return c.DnnSuperResImpl_GetScale(self.ptr);
    }

    /// Get the current algorithm name
    pub fn getAlgorithm(self: Self) []const u8 {
        const algo_ptr = c.DnnSuperResImpl_GetAlgorithm(self.ptr);
        return std.mem.span(algo_ptr);
    }
};
