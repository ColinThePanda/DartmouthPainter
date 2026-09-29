const std = @import("std");
const c_import = @import("../c.zig");
const c = c_import.c;
const core = @import("../core.zig");
const features2d = @import("../features2d.zig");

pub const Mat = core.Mat;
pub const KeyPoint = features2d.KeyPoint;
pub const Feature2D = features2d.Feature2D;
pub const Error = core.Error;

// ============================================================================
// SURF
// ============================================================================

pub const SURF = struct {
    /// Create SURF detector/descriptor
    /// Note: May fail if OPENCV_ENABLE_NONFREE is not set and patent algorithms are checked
    pub fn create(hessianThreshold: f64, nOctaves: i32, nOctaveLayers: i32, extended: bool, upright: bool) Error!Feature2D {
        const ptr = c.SURF_Create(hessianThreshold, nOctaves, nOctaveLayers, extended, upright) orelse return Error.AlgorithmInitializationFailed;
        return Feature2D{ .ptr = ptr };
    }

    /// Create with default parameters
    pub fn createDefault() Error!Feature2D {
        return create(100.0, 4, 3, false, false);
    }
};

// ============================================================================
// FREAK
// ============================================================================

pub const FREAK = struct {
    /// Create FREAK descriptor extractor
    pub fn create(orientationNormalized: bool, scaleNormalized: bool, patternScale: f32, nOctaves: i32) Error!Feature2D {
        const ptr = c.FREAK_Create(orientationNormalized, scaleNormalized, patternScale, nOctaves) orelse return Error.NullPointer;
        return Feature2D{ .ptr = ptr };
    }

    /// Create with default parameters
    pub fn createDefault() Error!Feature2D {
        return create(true, true, 22.0, 4);
    }
};

// ============================================================================
// BriefDescriptorExtractor
// ============================================================================

pub const BriefDescriptorExtractor = struct {
    /// Create BRIEF descriptor extractor
    pub fn create(bytes: i32, use_orientation: bool) Error!Feature2D {
        const ptr = c.BriefDescriptorExtractor_Create(bytes, use_orientation) orelse return Error.NullPointer;
        return Feature2D{ .ptr = ptr };
    }

    /// Create with default parameters
    pub fn createDefault() Error!Feature2D {
        return create(32, false);
    }
};
