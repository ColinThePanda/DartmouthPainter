const std = @import("std");
const c_import = @import("../c.zig");
const c = c_import.c;
const core = @import("../core.zig");

pub const Mat = core.Mat;
pub const Error = core.Error;

// ============================================================================
// Image Hashing Algorithms
// ============================================================================

/// Base class for image hashing algorithms
pub const ImgHashBase = struct {
    ptr: *c.ImgHashBase,

    const Self = @This();

    /// Create Average Hash (aHash) - fast but less accurate
    pub fn createAverageHash() Error!Self {
        const ptr = c.AverageHash_Create() orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Create Perceptual Hash (pHash) - slower but more robust
    pub fn createPHash() Error!Self {
        const ptr = c.PHash_Create() orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Create Block Mean Hash (dHash variant)
    /// mode: 0 for BLOCK_MEAN_HASH_MODE_0, 1 for BLOCK_MEAN_HASH_MODE_1
    pub fn createBlockMeanHash(mode: i32) Error!Self {
        const ptr = c.BlockMeanHash_Create(mode) orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Create Marr-Hildreth Hash
    pub fn createMarrHildrethHash(alpha: f32, scale: f32) Error!Self {
        const ptr = c.MarrHildrethHash_Create(alpha, scale) orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Create Radial Variance Hash
    pub fn createRadialVarianceHash(sigma: f64, num_of_angle_line: i32) Error!Self {
        const ptr = c.RadialVarianceHash_Create(sigma, num_of_angle_line) orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Create Color Moment Hash
    pub fn createColorMomentHash() Error!Self {
        const ptr = c.ColorMomentHash_Create() orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Release resources
    pub fn deinit(self: *Self) void {
        c.ImgHashBase_Delete(self.ptr);
        self.ptr = undefined;
    }

    /// Compute hash for an image
    pub fn compute(self: Self, input: Mat, output: *Mat) void {
        c.ImgHashBase_Compute(self.ptr, input.ptr, output.ptr);
    }

    /// Compare two hashes and return distance (0 = identical)
    pub fn compare(self: Self, hash_one: Mat, hash_two: Mat) f64 {
        return c.ImgHashBase_Compare(self.ptr, hash_one.ptr, hash_two.ptr);
    }
};
