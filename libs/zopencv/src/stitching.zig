const std = @import("std");
const c_import = @import("c.zig");
const c = c_import.c;
const core = @import("core.zig");

pub const Mat = core.Mat;
pub const Error = core.Error;

// ============================================================================
// Stitcher
// ============================================================================

/// Image stitcher for creating panoramas
pub const Stitcher = struct {
    ptr: *c.Stitcher,

    const Self = @This();

    /// Create stitcher with specified mode
    pub fn create(mode: StitcherMode) Error!Self {
        const ptr = c.Stitcher_Create(@intFromEnum(mode)) orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Release resources
    pub fn deinit(self: *Self) void {
        c.Stitcher_Delete(self.ptr);
        self.ptr = undefined;
    }

    /// Stitch images together to create panorama
    pub fn stitch(self: Self, images: []Mat, pano: *Mat) StitcherStatus {
        // Create array of Mat pointers
        const allocator = std.heap.page_allocator;
        const mat_ptrs = allocator.alloc(*c.Mat, images.len) catch return .err_need_more_imgs;
        defer allocator.free(mat_ptrs);

        for (images, 0..) |img, i| {
            mat_ptrs[i] = img.ptr;
        }

        const status = c.Stitcher_Stitch(
            self.ptr,
            @ptrCast(mat_ptrs.ptr),
            @intCast(images.len),
            pano.ptr,
        );

        return @enumFromInt(status);
    }

    /// Get registration resolution scale
    pub fn getRegistrationResol(self: Self) f64 {
        return c.Stitcher_GetRegistrationResol(self.ptr);
    }

    /// Set registration resolution scale
    pub fn setRegistrationResol(self: Self, resol: f64) void {
        c.Stitcher_SetRegistrationResol(self.ptr, resol);
    }

    /// Get seam estimation resolution scale
    pub fn getSeamEstimationResol(self: Self) f64 {
        return c.Stitcher_GetSeamEstimationResol(self.ptr);
    }

    /// Set seam estimation resolution scale
    pub fn setSeamEstimationResol(self: Self, resol: f64) void {
        c.Stitcher_SetSeamEstimationResol(self.ptr, resol);
    }

    /// Get compositing resolution scale
    pub fn getCompositingResol(self: Self) f64 {
        return c.Stitcher_GetCompositingResol(self.ptr);
    }

    /// Set compositing resolution scale
    pub fn setCompositingResol(self: Self, resol: f64) void {
        c.Stitcher_SetCompositingResol(self.ptr, resol);
    }

    /// Get panorama confidence threshold
    pub fn getPanoConfidenceThresh(self: Self) f64 {
        return c.Stitcher_GetPanoConfidenceThresh(self.ptr);
    }

    /// Set panorama confidence threshold
    pub fn setPanoConfidenceThresh(self: Self, conf_thresh: f64) void {
        c.Stitcher_SetPanoConfidenceThresh(self.ptr, conf_thresh);
    }

    /// Get wave correction flag
    pub fn getWaveCorrection(self: Self) bool {
        return c.Stitcher_GetWaveCorrection(self.ptr) != 0;
    }

    /// Set wave correction flag
    pub fn setWaveCorrection(self: Self, flag: bool) void {
        c.Stitcher_SetWaveCorrection(self.ptr, if (flag) 1 else 0);
    }
};

// ============================================================================
// Enums
// ============================================================================

/// Stitching modes
pub const StitcherMode = enum(i32) {
    panorama = 0, // Panorama mode (default)
    scans = 1, // Scans mode
};

/// Stitching status codes
pub const StitcherStatus = enum(i32) {
    ok = 0, // Success
    err_need_more_imgs = 1, // Need more images
    err_homography_est_fail = 2, // Homography estimation failed
    err_camera_params_adjust_fail = 3, // Camera parameters adjustment failed
};
