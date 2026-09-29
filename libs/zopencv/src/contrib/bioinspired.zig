const std = @import("std");
const c_import = @import("../c.zig");
const c = c_import.c;
const core = @import("../core.zig");

pub const Mat = core.Mat;
pub const Error = core.Error;

// ============================================================================
// Bioinspired - Retina Model
// ============================================================================

/// Retina model for biologically-inspired vision processing
pub const Retina = struct {
    ptr: *c.Retina,

    const Self = @This();

    /// Create a new Retina model
    /// width, height: input image size
    /// colorMode: true for color, false for grayscale
    pub fn create(width: i32, height: i32, colorMode: bool) Error!Self {
        const ptr = c.Retina_Create(width, height, colorMode) orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Release resources
    pub fn deinit(self: *Self) void {
        c.Retina_Delete(self.ptr);
        self.ptr = undefined;
    }

    /// Run retina filter on input image
    pub fn run(self: Self, input: Mat) void {
        c.Retina_Run(self.ptr, input.ptr);
    }

    /// Get Parvo pathway output (details, color, foveal vision)
    pub fn getParvo(self: Self, output: *Mat) void {
        c.Retina_GetParvo(self.ptr, output.ptr);
    }

    /// Get Magno pathway output (motion, transient signals, peripheral vision)
    pub fn getMagno(self: Self, output: *Mat) void {
        c.Retina_GetMagno(self.ptr, output.ptr);
    }

    /// Clear all retina buffers
    pub fn clearBuffers(self: Self) void {
        c.Retina_ClearBuffers(self.ptr);
    }
};
