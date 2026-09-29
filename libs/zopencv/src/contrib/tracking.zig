const std = @import("std");
const c_import = @import("../c.zig");
const c = c_import.c;
const core = @import("../core.zig");

pub const Mat = core.Mat;
pub const Rect = core.Rect;
pub const Error = core.Error;

// ============================================================================
// Tracker (Legacy API)
// ============================================================================

/// Object tracker base class
pub const Tracker = struct {
    ptr: *c.Tracker,

    const Self = @This();

    /// Create TrackerKCF (Kernelized Correlation Filters)
    pub fn createKCF() Error!Self {
        const ptr = c.TrackerKCF_Create() orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Create TrackerCSRT (Discriminative Correlation Filter with Channel and Spatial Reliability)
    pub fn createCSRT() Error!Self {
        const ptr = c.TrackerCSRT_Create() orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Create TrackerMIL (Multiple Instance Learning)
    pub fn createMIL() Error!Self {
        const ptr = c.TrackerMIL_Create() orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Release resources
    pub fn deinit(self: *Self) void {
        c.Tracker_Delete(self.ptr);
        self.ptr = undefined;
    }

    /// Initialize tracker with bounding box
    pub fn init(self: Self, image: Mat, boundingBox: Rect) bool {
        const result = c.Tracker_Init(self.ptr, image.ptr, boundingBox.toC());
        return result != 0;
    }

    /// Update tracker and get new bounding box
    pub fn update(self: Self, image: Mat, boundingBox: *Rect) bool {
        var bbox = boundingBox.toC();
        const result = c.Tracker_Update(self.ptr, image.ptr, &bbox);
        if (result != 0) {
            boundingBox.* = Rect.fromC(bbox);
            return true;
        }
        return false;
    }
};
