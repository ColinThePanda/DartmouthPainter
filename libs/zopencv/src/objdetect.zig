const std = @import("std");
const c_import = @import("c.zig");
const c = c_import.c;
const core = @import("core.zig");

pub const Mat = core.Mat;
pub const Rect = core.Rect;
pub const Size = core.Size;
pub const Error = core.Error;

/// Vector of rectangles for detection results
pub const RectVector = struct {
    ptr: *c.RectVector,

    const Self = @This();

    pub fn init() Error!Self {
        const ptr = c.RectVector_New() orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    pub fn deinit(self: *Self) void {
        c.RectVector_Delete(self.ptr);
        self.ptr = undefined;
    }

    pub fn size(self: Self) usize {
        return c.RectVector_Size(self.ptr);
    }

    pub fn at(self: Self, index: usize) Rect {
        const c_rect = c.RectVector_At(self.ptr, index);
        return Rect{
            .x = c_rect.x,
            .y = c_rect.y,
            .width = c_rect.width,
            .height = c_rect.height,
        };
    }
};

/// Cascade classifier for object detection
pub const CascadeClassifier = struct {
    ptr: *c.CascadeClassifier,

    const Self = @This();

    pub fn init() Error!Self {
        const ptr = c.CascadeClassifier_New() orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    pub fn initFromFile(filename: []const u8) !Self {
        const filename_z = try std.heap.c_allocator.dupeZ(u8, filename);
        defer std.heap.c_allocator.free(filename_z);

        const ptr = c.CascadeClassifier_NewFromFile(filename_z.ptr) orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    pub fn deinit(self: *Self) void {
        c.CascadeClassifier_Delete(self.ptr);
        self.ptr = undefined;
    }

    pub fn load(self: *Self, filename: []const u8) !bool {
        const filename_z = try std.heap.c_allocator.dupeZ(u8, filename);
        defer std.heap.c_allocator.free(filename_z);

        return c.CascadeClassifier_Load(self.ptr, filename_z.ptr) != 0;
    }

    pub fn empty(self: Self) bool {
        return c.CascadeClassifier_Empty(self.ptr) != 0;
    }

    pub fn detectMultiScale(
        self: Self,
        image: Mat,
        objects: *RectVector,
        scale_factor: f64,
        min_neighbors: i32,
        flags: i32,
        min_size: Size,
        max_size: Size,
    ) void {
        c.CascadeClassifier_DetectMultiScale(
            self.ptr,
            image.ptr,
            objects.ptr,
            scale_factor,
            min_neighbors,
            flags,
            min_size.toC(),
            max_size.toC(),
        );
    }
};

/// HOG descriptor for pedestrian detection
pub const HOGDescriptor = struct {
    ptr: *c.HOGDescriptor,

    const Self = @This();

    pub fn init() Error!Self {
        const ptr = c.HOGDescriptor_New() orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    pub fn deinit(self: *Self) void {
        c.HOGDescriptor_Delete(self.ptr);
        self.ptr = undefined;
    }

    pub fn setSVMDetector(self: *Self, detector_type: HOGDetectorType) void {
        c.HOGDescriptor_SetSVMDetector(self.ptr, @intFromEnum(detector_type));
    }

    pub fn detectMultiScale(
        self: Self,
        image: Mat,
        found_locations: *RectVector,
        hit_threshold: f64,
        win_stride: Size,
        padding: Size,
        scale: f64,
        final_threshold: f64,
        use_meanshift_grouping: bool,
    ) void {
        c.HOGDescriptor_DetectMultiScale(
            self.ptr,
            image.ptr,
            found_locations.ptr,
            hit_threshold,
            win_stride.toC(),
            padding.toC(),
            scale,
            final_threshold,
            if (use_meanshift_grouping) 1 else 0,
        );
    }
};

/// Predefined HOG detector types
pub const HOGDetectorType = enum(i32) {
    default_people = 0,
    daimler_people = 1,
};

// ============================================================================
// QRCodeDetector
// ============================================================================

pub const QRCodeDetector = struct {
    ptr: *c.QRCodeDetector,

    const Self = @This();

    pub fn init() core.Error!Self {
        const p = c.QRCodeDetector_New() orelse return core.Error.NullPointer;
        return Self{ .ptr = p };
    }

    pub fn deinit(self: *Self) void {
        c.QRCodeDetector_Delete(self.ptr);
        self.ptr = undefined;
    }

    /// Detect QR code in image
    /// Returns true if QR code found, points will contain the corners
    pub fn detect(self: Self, image: core.Mat, points: *core.PointVector) bool {
        return c.QRCodeDetector_Detect(self.ptr, image.ptr, points.ptr) != 0;
    }

    /// Decode a detected QR code given its corner points
    /// Returns the decoded string, or null if decoding failed
    pub fn decode(self: Self, image: core.Mat, points: *core.PointVector, straight_qrcode: *core.Mat) ?[]const u8 {
        var buf: [4096]u8 = undefined;
        const len = c.QRCodeDetector_Decode(self.ptr, image.ptr, points.ptr, straight_qrcode.ptr, &buf, 4096);
        if (len <= 0) return null;
        const ulen: usize = @intCast(len);
        const actual_len = @min(ulen, 4095);
        const static = struct {
            var data: [4096]u8 = undefined;
        };
        @memcpy(static.data[0..actual_len], buf[0..actual_len]);
        return static.data[0..actual_len];
    }

    /// Detect and decode QR code in one step
    /// Returns the decoded string, or null if not found
    pub fn detectAndDecode(self: Self, image: core.Mat, points: *core.PointVector, straight_qrcode: *core.Mat) ?[]const u8 {
        var buf: [4096]u8 = undefined;
        const len = c.QRCodeDetector_DetectAndDecode(self.ptr, image.ptr, points.ptr, straight_qrcode.ptr, &buf, 4096);
        if (len <= 0) return null;
        const ulen: usize = @intCast(len);
        const actual_len = @min(ulen, 4095);
        // Copy to a static buffer that persists (limited but simple)
        const static = struct {
            var data: [4096]u8 = undefined;
        };
        @memcpy(static.data[0..actual_len], buf[0..actual_len]);
        return static.data[0..actual_len];
    }
};
