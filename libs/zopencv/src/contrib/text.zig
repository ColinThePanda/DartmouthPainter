const std = @import("std");
const c_import = @import("../c.zig");
const c = c_import.c;
const core = @import("../core.zig");

pub const Mat = core.Mat;
pub const Error = core.Error;

// ============================================================================
// TextDetectorCNN
// ============================================================================

/// CNN-based text detector
pub const TextDetectorCNN = struct {
    ptr: *c.TextDetectorCNN,

    const Self = @This();

    /// Create TextDetectorCNN with model files
    pub fn create(model_arch_filename: [:0]const u8, model_weights_filename: [:0]const u8) Error!Self {
        const ptr = c.TextDetectorCNN_Create(model_arch_filename.ptr, model_weights_filename.ptr) orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Release resources
    pub fn deinit(self: *Self) void {
        c.TextDetectorCNN_Delete(self.ptr);
        self.ptr = undefined;
    }

    /// Detect text regions in image
    pub fn detect(self: Self, image: Mat, bbox: *Mat, confidence: *Mat) void {
        c.TextDetectorCNN_Detect(self.ptr, image.ptr, bbox.ptr, confidence.ptr);
    }
};

// ============================================================================
// OCRTesseract
// ============================================================================

/// Tesseract OCR engine
pub const OCRTesseract = struct {
    ptr: *c.OCRTesseract,

    const Self = @This();

    /// Create OCRTesseract with default settings (English)
    pub fn create() Error!Self {
        const ptr = c.OCRTesseract_Create(null, "eng", null, 3, 3) orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Create OCRTesseract with custom settings
    pub fn createWithParams(datapath: ?[:0]const u8, language: [:0]const u8, char_whitelist: ?[:0]const u8, oem: i32, psm: i32) Error!Self {
        const datapath_ptr = if (datapath) |dp| dp.ptr else null;
        const whitelist_ptr = if (char_whitelist) |cw| cw.ptr else null;
        const ptr = c.OCRTesseract_Create(datapath_ptr, language.ptr, whitelist_ptr, oem, psm) orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Release resources
    pub fn deinit(self: *Self) void {
        c.OCRTesseract_Delete(self.ptr);
        self.ptr = undefined;
    }

    /// Run OCR on image (simplified version without component details)
    pub fn run(self: Self, image: Mat, allocator: std.mem.Allocator) (Error || error{OutOfMemory})![]u8 {
        var output_text: [*c]u8 = undefined;
        c.OCRTesseract_Run(self.ptr, image.ptr, &output_text, null, null, null);

        if (output_text == null) return Error.NullPointer;

        const text_len = std.mem.len(output_text);
        const text = try allocator.alloc(u8, text_len);
        @memcpy(text, output_text[0..text_len]);

        // Free the C string
        std.c.free(output_text);

        return text;
    }
};
