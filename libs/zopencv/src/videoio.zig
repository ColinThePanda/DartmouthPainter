const std = @import("std");
const c_import = @import("c.zig");
const c = c_import.c;
const core = @import("core.zig");

pub const Mat = core.Mat;
pub const Size = core.Size;
pub const Error = core.Error;

/// Video capture properties
pub const VideoCaptureProperty = enum(i32) {
    pos_msec = 0,
    pos_frames = 1,
    pos_avi_ratio = 2,
    frame_width = 3,
    frame_height = 4,
    fps = 5,
    fourcc = 6,
    frame_count = 7,
    format = 8,
    mode = 9,
    brightness = 10,
    contrast = 11,
    saturation = 12,
    hue = 13,
    gain = 14,
    exposure = 15,
    convert_rgb = 16,
    white_balance_blue_u = 17,
    rectification = 18,
    monochrome = 19,
    sharpness = 20,
    auto_exposure = 21,
    gamma = 22,
    temperature = 23,
    trigger = 24,
    trigger_delay = 25,
    white_balance_red_v = 26,
    zoom = 27,
    focus = 28,
    guid = 29,
    iso_speed = 30,
    backlight = 32,
    pan = 33,
    tilt = 34,
    roll = 35,
    iris = 36,
    settings = 37,
    buffersize = 38,
    autofocus = 39,
    backend = 42,
    channel = 43,
    auto_wb = 44,
    wb_temperature = 45,
    codec_pixel_format = 46,
    bitrate = 47,
    orientation_meta = 48,
    orientation_auto = 49,
    open_timeout_msec = 53,
    read_timeout_msec = 54,
};

/// Video capture API backends
pub const VideoCaptureAPI = enum(i32) {
    any = 0,
    v4l2 = 200,
    firewire = 300,
    qt = 500,
    unicap = 600,
    dshow = 700,
    pvapi = 800,
    openni = 900,
    openni_asus = 910,
    android = 1000,
    xiapi = 1100,
    avfoundation = 1200,
    giganetix = 1300,
    msmf = 1400,
    winrt = 1410,
    realsense = 1500,
    openni2 = 1600,
    openni2_asus = 1610,
    openni2_astra = 1620,
    gphoto2 = 1700,
    gstreamer = 1800,
    ffmpeg = 1900,
    images = 2000,
    aravis = 2100,
    opencv_mjpeg = 2200,
    intel_mfx = 2300,
    xine = 2400,
};

/// VideoCapture - Video capture from camera or file
pub const VideoCapture = struct {
    ptr: *c.VideoCapture,

    const Self = @This();

    /// Create new VideoCapture
    pub fn init() Error!Self {
        const ptr = c.VideoCapture_New() orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Create VideoCapture from camera index
    pub fn initFromIndex(index: i32) Error!Self {
        const ptr = c.VideoCapture_NewFromIndex(index) orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Create VideoCapture from file
    pub fn initFromFile(filename: []const u8) !Self {
        const filename_z = try std.heap.c_allocator.dupeZ(u8, filename);
        defer std.heap.c_allocator.free(filename_z);

        const ptr = c.VideoCapture_NewFromFile(filename_z.ptr) orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Free VideoCapture
    pub fn deinit(self: *Self) void {
        c.VideoCapture_Delete(self.ptr);
        self.ptr = undefined;
    }

    /// Open video file
    pub fn open(self: Self, filename: []const u8) !bool {
        const filename_z = try std.heap.c_allocator.dupeZ(u8, filename);
        defer std.heap.c_allocator.free(filename_z);

        return c.VideoCapture_Open(self.ptr, filename_z.ptr) != 0;
    }

    /// Open camera device
    pub fn openDevice(self: Self, index: i32) bool {
        return c.VideoCapture_OpenDevice(self.ptr, index) != 0;
    }

    /// Check if VideoCapture is opened
    pub fn isOpened(self: Self) bool {
        return c.VideoCapture_IsOpened(self.ptr) != 0;
    }

    /// Release VideoCapture
    pub fn release(self: Self) void {
        c.VideoCapture_Release(self.ptr);
    }

    /// Read frame
    pub fn read(self: Self, frame: *Mat) bool {
        return c.VideoCapture_Read(self.ptr, frame.ptr) != 0;
    }

    /// Grab frame
    pub fn grab(self: Self) bool {
        return c.VideoCapture_Grab(self.ptr) != 0;
    }

    /// Retrieve frame
    pub fn retrieve(self: Self, frame: *Mat) bool {
        return c.VideoCapture_Retrieve(self.ptr, frame.ptr) != 0;
    }

    /// Get property
    pub fn get(self: Self, propId: VideoCaptureProperty) f64 {
        return c.VideoCapture_Get(self.ptr, @intFromEnum(propId));
    }

    /// Set property
    pub fn set(self: Self, propId: VideoCaptureProperty, value: f64) bool {
        return c.VideoCapture_Set(self.ptr, @intFromEnum(propId), value) != 0;
    }

    /// Create VideoCapture from file with API preference
    pub fn initFromFileWithAPI(filename: []const u8, apiPreference: VideoCaptureAPI) !Self {
        const filename_z = try std.heap.c_allocator.dupeZ(u8, filename);
        defer std.heap.c_allocator.free(filename_z);

        const ptr = c.VideoCapture_NewFromFileWithAPI(filename_z.ptr, @intFromEnum(apiPreference)) orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Create VideoCapture from camera index with API preference
    pub fn initFromIndexWithAPI(index: i32, apiPreference: VideoCaptureAPI) Error!Self {
        const ptr = c.VideoCapture_NewFromIndexWithAPI(index, @intFromEnum(apiPreference)) orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Open video file with API preference
    pub fn openWithAPI(self: Self, filename: []const u8, apiPreference: VideoCaptureAPI) !bool {
        const filename_z = try std.heap.c_allocator.dupeZ(u8, filename);
        defer std.heap.c_allocator.free(filename_z);

        return c.VideoCapture_OpenWithAPI(self.ptr, filename_z.ptr, @intFromEnum(apiPreference)) != 0;
    }

    /// Open camera device with API preference
    pub fn openDeviceWithAPI(self: Self, index: i32, apiPreference: VideoCaptureAPI) bool {
        return c.VideoCapture_OpenDeviceWithAPI(self.ptr, index, @intFromEnum(apiPreference)) != 0;
    }

    /// Get backend name
    pub fn getBackendName(self: Self) []const u8 {
        const name_ptr = c.VideoCapture_GetBackendName(self.ptr);
        if (name_ptr == null) return "";
        return std.mem.span(name_ptr);
    }
};

/// VideoWriter - Video writer
pub const VideoWriter = struct {
    ptr: *c.VideoWriter,

    const Self = @This();

    /// Create new VideoWriter
    pub fn init() Error!Self {
        const ptr = c.VideoWriter_New() orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Create VideoWriter with parameters
    pub fn initWithParams(filename: []const u8, fourcc_code: i32, fps: f64, frameSize: Size, isColor: bool) !Self {
        const filename_z = try std.heap.c_allocator.dupeZ(u8, filename);
        defer std.heap.c_allocator.free(filename_z);

        const ptr = c.VideoWriter_NewWithParams(filename_z.ptr, fourcc_code, fps, frameSize.toC(), if (isColor) 1 else 0) orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Free VideoWriter
    pub fn deinit(self: *Self) void {
        c.VideoWriter_Delete(self.ptr);
        self.ptr = undefined;
    }

    /// Open video file for writing
    pub fn open(self: Self, filename: []const u8, fourcc_code: i32, fps: f64, frameSize: Size, isColor: bool) !bool {
        const filename_z = try std.heap.c_allocator.dupeZ(u8, filename);
        defer std.heap.c_allocator.free(filename_z);

        return c.VideoWriter_Open(self.ptr, filename_z.ptr, fourcc_code, fps, frameSize.toC(), if (isColor) 1 else 0) != 0;
    }

    /// Check if VideoWriter is opened
    pub fn isOpened(self: Self) bool {
        return c.VideoWriter_IsOpened(self.ptr) != 0;
    }

    /// Release VideoWriter
    pub fn release(self: Self) void {
        c.VideoWriter_Release(self.ptr);
    }

    /// Write frame
    pub fn write(self: Self, frame: Mat) void {
        c.VideoWriter_Write(self.ptr, frame.ptr);
    }

    /// Create VideoWriter with parameters and API preference
    pub fn initWithParamsAndAPI(filename: []const u8, apiPreference: VideoCaptureAPI, fourcc_code: i32, fps: f64, frameSize: Size, isColor: bool) !Self {
        const filename_z = try std.heap.c_allocator.dupeZ(u8, filename);
        defer std.heap.c_allocator.free(filename_z);

        const ptr = c.VideoWriter_NewWithParamsAndAPI(filename_z.ptr, @intFromEnum(apiPreference), fourcc_code, fps, frameSize.toC(), if (isColor) 1 else 0) orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Open video file for writing with API preference
    pub fn openWithAPI(self: Self, filename: []const u8, apiPreference: VideoCaptureAPI, fourcc_code: i32, fps: f64, frameSize: Size, isColor: bool) !bool {
        const filename_z = try std.heap.c_allocator.dupeZ(u8, filename);
        defer std.heap.c_allocator.free(filename_z);

        return c.VideoWriter_OpenWithAPI(self.ptr, filename_z.ptr, @intFromEnum(apiPreference), fourcc_code, fps, frameSize.toC(), if (isColor) 1 else 0) != 0;
    }

    /// Get backend name
    pub fn getBackendName(self: Self) []const u8 {
        const name_ptr = c.VideoWriter_GetBackendName(self.ptr);
        if (name_ptr == null) return "";
        return std.mem.span(name_ptr);
    }
};

/// Create FourCC code
pub fn fourcc(c1: u8, c2: u8, c3: u8, c4: u8) i32 {
    return c.VideoWriter_FourCC(c1, c2, c3, c4);
}
