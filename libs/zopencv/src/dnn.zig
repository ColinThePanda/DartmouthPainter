const std = @import("std");
const c_import = @import("c.zig");
const c = c_import.c;
const core = @import("core.zig");

pub const Mat = core.Mat;
pub const Size = core.Size;
pub const Scalar = core.Scalar;
pub const Error = core.Error;

// ============================================================================
// Net - Neural Network
// ============================================================================

pub const Net = struct {
    ptr: ?*c.Net,

    /// Create an empty neural network
    pub fn init() !Net {
        const ptr = c.Net_New();
        if (ptr == null) return Error.NullPointer;
        return Net{ .ptr = ptr };
    }

    /// Check if network has no layers (empty)
    pub fn empty(self: Net) bool {
        if (self.ptr) |ptr| {
            return c.Net_Empty(ptr) != 0;
        }
        return true;
    }

    /// Read a network model stored in Darknet format
    pub fn readNetFromDarknet(cfgFile: [*:0]const u8, darknetModel: ?[*:0]const u8) !Net {
        const ptr = c.ReadNetFromDarknet(cfgFile, darknetModel orelse "");
        if (ptr == null) return Error.NullPointer;
        return Net{ .ptr = ptr };
    }

    /// Read a network model stored in Caffe format
    pub fn readNetFromCaffe(prototxt: [*:0]const u8, caffeModel: ?[*:0]const u8) !Net {
        const ptr = c.ReadNetFromCaffe(prototxt, caffeModel orelse "");
        if (ptr == null) return Error.NullPointer;
        return Net{ .ptr = ptr };
    }

    /// Read a network model stored in TensorFlow format
    pub fn readNetFromTensorflow(model: [*:0]const u8, config: ?[*:0]const u8) !Net {
        const ptr = c.ReadNetFromTensorflow(model, config orelse "");
        if (ptr == null) return Error.NullPointer;
        return Net{ .ptr = ptr };
    }

    /// Read a network model stored in ONNX format
    pub fn readNetFromONNX(onnxFile: [*:0]const u8) !Net {
        const ptr = c.ReadNetFromONNX(onnxFile);
        if (ptr == null) return Error.NullPointer;
        return Net{ .ptr = ptr };
    }

    /// Read a network model stored in Torch/PyTorch format
    pub fn readNetFromTorch(model: [*:0]const u8, isBinary: bool) !Net {
        const ptr = c.ReadNetFromTorch(model, if (isBinary) 1 else 0);
        if (ptr == null) return Error.NullPointer;
        return Net{ .ptr = ptr };
    }

    /// Read a network model stored in TFLite format
    pub fn readNetFromTFLite(model: [*:0]const u8) !Net {
        const ptr = c.ReadNetFromTFLite(model);
        if (ptr == null) return Error.NullPointer;
        return Net{ .ptr = ptr };
    }

    /// Delete neural network
    pub fn deinit(self: Net) void {
        if (self.ptr) |ptr| {
            c.Net_Delete(ptr);
        }
    }

    /// Set input blob for the network
    pub fn setInput(self: Net, blob: Mat, name: ?[*:0]const u8) void {
        c.Net_SetInput(self.ptr, blob.ptr, name orelse "");
    }

    /// Run forward pass and return output
    pub fn forward(self: Net, outputName: ?[*:0]const u8) !Mat {
        const ptr = c.Net_Forward(self.ptr, outputName orelse "");
        if (ptr == null) return Error.NullPointer;
        return Mat{ .ptr = ptr };
    }

    /// Get names of unconnected output layers
    pub fn getUnconnectedOutLayersNames(self: Net, allocator: std.mem.Allocator) ![][]const u8 {
        var size: c_int = 0;
        const names_ptr = c.Net_GetUnconnectedOutLayersNames(self.ptr, &size);

        var names = try allocator.alloc([]const u8, @intCast(size));
        errdefer allocator.free(names);

        for (0..@intCast(size)) |i| {
            const len = std.mem.len(names_ptr[i]);
            names[i] = try allocator.dupe(u8, names_ptr[i][0..len]);
        }

        c.FreeStringArray(names_ptr, size);
        return names;
    }

    /// Set preferable backend
    pub fn setPreferableBackend(self: Net, backendId: i32) void {
        c.Net_SetPreferableBackend(self.ptr, backendId);
    }

    /// Set preferable target device
    pub fn setPreferableTarget(self: Net, targetId: i32) void {
        c.Net_SetPreferableTarget(self.ptr, targetId);
    }

    /// Get performance profile
    pub fn getPerfProfile(self: Net) f64 {
        return c.Net_GetPerfProfile(self.ptr);
    }

    /// Dump network structure as a string (caller must free with allocator)
    pub fn dump(self: Net, allocator: std.mem.Allocator) ![]const u8 {
        const c_str = c.Net_Dump(self.ptr);
        if (c_str == null) return Error.NullPointer;
        defer c.FreeCharPtr(c_str);
        const len = std.mem.len(c_str);
        const result = try allocator.alloc(u8, len);
        @memcpy(result, c_str[0..len]);
        return result;
    }

    /// Get names of all layers in the network
    pub fn getLayerNames(self: Net, allocator: std.mem.Allocator) ![][]const u8 {
        var size: c_int = 0;
        const names_ptr = c.Net_GetLayerNames(self.ptr, &size);

        var names = try allocator.alloc([]const u8, @intCast(size));
        errdefer allocator.free(names);

        for (0..@intCast(size)) |i| {
            const len = std.mem.len(names_ptr[i]);
            names[i] = try allocator.dupe(u8, names_ptr[i][0..len]);
        }

        c.FreeStringArray(names_ptr, size);
        return names;
    }

    /// Get indices of unconnected output layers
    pub fn getUnconnectedOutLayers(self: Net, allocator: std.mem.Allocator) ![]i32 {
        var size: c_int = 0;
        const layers_ptr = c.Net_GetUnconnectedOutLayers(self.ptr, &size);
        if (layers_ptr == null or size <= 0) return Error.NullPointer;

        const result = try allocator.alloc(i32, @intCast(size));
        for (0..@intCast(size)) |i| {
            result[i] = layers_ptr[i];
        }

        c.FreeIntArray(layers_ptr);
        return result;
    }
};

// ============================================================================
// Blob Creation
// ============================================================================

/// Create 4D blob from image
pub fn blobFromImage(
    image: Mat,
    scalefactor: f64,
    size: Size,
    mean: Scalar,
    swapRB: bool,
    crop: bool,
    ddepth: i32,
) !Mat {
    const c_size = c.Size{ .width = size.width, .height = size.height };
    const c_mean = c.Scalar{ .v0 = mean.val1, .v1 = mean.val2, .v2 = mean.val3, .v3 = mean.val4 };
    const ptr = c.BlobFromImage(
        image.ptr,
        scalefactor,
        c_size,
        c_mean,
        if (swapRB) 1 else 0,
        if (crop) 1 else 0,
        ddepth,
    ) orelse return Error.NullPointer;
    return Mat{ .ptr = ptr };
}

/// Create 4D blob from multiple images
pub fn blobFromImages(
    images: []Mat,
    scalefactor: f64,
    size: Size,
    mean: Scalar,
    swapRB: bool,
    crop: bool,
    ddepth: i32,
) !Mat {
    const ptr = c.BlobFromImages(
        @ptrCast(images.ptr),
        @intCast(images.len),
        scalefactor,
        size,
        mean,
        if (swapRB) 1 else 0,
        if (crop) 1 else 0,
        ddepth,
    );
    if (ptr == null) return Error.NullPointer;
    return Mat{ .ptr = ptr };
}

// ============================================================================
// DNN Backend and Target Enums
// ============================================================================

pub const Backend = enum(i32) {
    default = 0,
    halide = 1,
    inference_engine = 2,
    opencv = 3,
    vkcom = 4,
    cuda = 5,
};

pub const Target = enum(i32) {
    cpu = 0,
    opencl = 1,
    opencl_fp16 = 2,
    myriad = 3,
    vulkan = 4,
    fpga = 5,
    cuda = 6,
    cuda_fp16 = 7,
};

// ============================================================================
// Post-processing
// ============================================================================

/// Perform non-maximum suppression on bounding boxes
pub fn nmsBoxes(
    bboxes: []const core.Rect,
    scores: []const f32,
    score_threshold: f32,
    nms_threshold: f32,
    allocator: std.mem.Allocator,
) ![]i32 {
    var indices_ptr: [*c]c_int = undefined;
    var indices_count: c_int = 0;

    c.NMSBoxes(
        @ptrCast(@constCast(bboxes.ptr)),
        @intCast(bboxes.len),
        @ptrCast(@constCast(scores.ptr)),
        @intCast(scores.len),
        score_threshold,
        nms_threshold,
        @ptrCast(&indices_ptr),
        &indices_count,
    );

    if (indices_count <= 0) {
        return allocator.alloc(i32, 0);
    }

    const result = try allocator.alloc(i32, @intCast(indices_count));
    for (0..@intCast(indices_count)) |i| {
        result[i] = indices_ptr[i];
    }

    c.FreeIntArray(indices_ptr);
    return result;
}
