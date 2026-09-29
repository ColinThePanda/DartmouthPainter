const std = @import("std");
const c_import = @import("../c.zig");
const c = c_import.c;
const core = @import("../core.zig");

pub const Mat = core.Mat;
pub const Mats = core.Mats;
pub const Error = core.Error;

// ============================================================================
// FaceRecognizer
// ============================================================================

/// Face recognition base class
pub const FaceRecognizer = struct {
    ptr: *c.FaceRecognizer,

    const Self = @This();

    /// Create Eigenfaces recognizer
    pub fn createEigenfaces(num_components: i32, threshold: f64) Error!Self {
        const ptr = c.FaceRecognizer_CreateEigenfaces(num_components, threshold) orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Create Fisherfaces recognizer
    pub fn createFisherfaces(num_components: i32, threshold: f64) Error!Self {
        const ptr = c.FaceRecognizer_CreateFisherfaces(num_components, threshold) orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Create LBPH (Local Binary Patterns Histograms) recognizer
    pub fn createLBPH(radius: i32, neighbors: i32, grid_x: i32, grid_y: i32, threshold: f64) Error!Self {
        const ptr = c.FaceRecognizer_CreateLBPH(radius, neighbors, grid_x, grid_y, threshold) orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Release resources
    pub fn deinit(self: *Self) void {
        c.FaceRecognizer_Delete(self.ptr);
        self.ptr = undefined;
    }

    /// Train the recognizer
    pub fn train(self: Self, images: Mats, labels: Mat) void {
        c.FaceRecognizer_Train(self.ptr, images.ptr, labels.ptr);
    }

    /// Predict label and confidence for given image
    pub fn predict(self: Self, image: Mat) struct { label: i32, confidence: f64 } {
        var label: i32 = -1;
        var confidence: f64 = 0.0;
        c.FaceRecognizer_Predict(self.ptr, image.ptr, &label, &confidence);
        return .{ .label = label, .confidence = confidence };
    }

    /// Save model to file
    pub fn save(self: Self, filename: [:0]const u8) void {
        c.FaceRecognizer_Save(self.ptr, filename.ptr);
    }

    /// Load model from file
    pub fn load(self: Self, filename: [:0]const u8) void {
        c.FaceRecognizer_Load(self.ptr, filename.ptr);
    }
};
