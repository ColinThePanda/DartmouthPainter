const std = @import("std");
const c_import = @import("../c.zig");
const c = c_import.c;
const core = @import("../core.zig");

pub const Mat = core.Mat;
pub const Error = core.Error;

// ============================================================================
// ArucoDictionary
// ============================================================================

/// ArUco marker dictionary
pub const ArucoDictionary = struct {
    ptr: *c.ArucoDictionary,

    const Self = @This();

    /// Get predefined ArUco dictionary
    pub fn getPredefined(dict_type: PredefinedDictionaryType) Error!Self {
        const ptr = c.ArucoDictionary_GetPredefined(@intFromEnum(dict_type)) orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Release resources
    pub fn deinit(self: *Self) void {
        c.ArucoDictionary_Delete(self.ptr);
        self.ptr = undefined;
    }

    /// Generate an ArUco marker image
    pub fn generateImageMarker(self: Self, id: i32, side_pixels: i32, img: *Mat, border_bits: i32) void {
        c.ArucoDictionary_GenerateImageMarker(self.ptr, id, side_pixels, img.ptr, border_bits);
    }
};

// ============================================================================
// ArucoDetector
// ============================================================================

/// ArUco marker detector
pub const ArucoDetector = struct {
    ptr: *c.ArucoDetector,

    const Self = @This();

    /// Create ArUco detector with dictionary
    pub fn create(dictionary: ArucoDictionary) Error!Self {
        const ptr = c.ArucoDetector_Create(dictionary.ptr) orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Release resources
    pub fn deinit(self: *Self) void {
        c.ArucoDetector_Delete(self.ptr);
        self.ptr = undefined;
    }

    /// Detect ArUco markers in image
    pub fn detectMarkers(self: Self, image: Mat, corners: *Mat, ids: *Mat, rejected: *Mat) void {
        c.ArucoDetector_DetectMarkers(self.ptr, image.ptr, corners.ptr, ids.ptr, rejected.ptr);
    }
};

// ============================================================================
// Enums
// ============================================================================

/// Predefined ArUco dictionary types
pub const PredefinedDictionaryType = enum(i32) {
    dict_4x4_50 = 0,
    dict_4x4_100 = 1,
    dict_4x4_250 = 2,
    dict_4x4_1000 = 3,
    dict_5x5_50 = 4,
    dict_5x5_100 = 5,
    dict_5x5_250 = 6,
    dict_5x5_1000 = 7,
    dict_6x6_50 = 8,
    dict_6x6_100 = 9,
    dict_6x6_250 = 10,
    dict_6x6_1000 = 11,
    dict_7x7_50 = 12,
    dict_7x7_100 = 13,
    dict_7x7_250 = 14,
    dict_7x7_1000 = 15,
    dict_aruco_original = 16,
};
