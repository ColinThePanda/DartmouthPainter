const std = @import("std");
const c_import = @import("c.zig");
const c = c_import.c;
const core = @import("core.zig");

pub const Mat = core.Mat;
pub const Rect = core.Rect;

/// Window flags
pub const WindowFlag = enum(i32) {
    normal = 0x00000000,
    autosize = 0x00000001,
    opengl = 0x00001000,
    freeratio = 0x00000100,
};

/// Window property flags
pub const WindowPropertyFlag = enum(i32) {
    fullscreen = 0,
    autosize = 1,
    aspect_ratio = 2,
    opengl = 3,
};

/// Mouse event types
pub const MouseEventTypes = enum(i32) {
    mouse_move = 0,
    lbutton_down = 1,
    rbutton_down = 2,
    mbutton_down = 3,
    lbutton_up = 4,
    rbutton_up = 5,
    mbutton_up = 6,
    lbutton_dblclk = 7,
    rbutton_dblclk = 8,
    mbutton_dblclk = 9,
    mouse_wheel = 10,
    mouse_hwheel = 11,
};

/// Show image in window
pub fn imshow(winname: []const u8, mat: Mat) !void {
    const winname_z = try std.heap.c_allocator.dupeZ(u8, winname);
    defer std.heap.c_allocator.free(winname_z);
    c.ImShow(winname_z.ptr, mat.ptr);
}

/// Wait for key press
pub fn waitKey(delay: i32) i32 {
    return c.WaitKey(delay);
}

/// Wait for key press (returns full key code including modifiers)
pub fn waitKeyEx(delay: i32) i32 {
    return c.WaitKeyEx(delay);
}

/// Poll for key press (non-blocking)
pub fn pollKey() i32 {
    return c.PollKey();
}

/// Destroy a specific window
pub fn destroyWindow(winname: []const u8) !void {
    const winname_z = try std.heap.c_allocator.dupeZ(u8, winname);
    defer std.heap.c_allocator.free(winname_z);
    c.DestroyWindow(winname_z.ptr);
}

/// Destroy all windows
pub fn destroyAllWindows() void {
    c.DestroyAllWindows();
}

/// Create named window
pub fn namedWindow(winname: []const u8, flags: WindowFlag) !void {
    const winname_z = try std.heap.c_allocator.dupeZ(u8, winname);
    defer std.heap.c_allocator.free(winname_z);
    c.NamedWindow(winname_z.ptr, @intFromEnum(flags));
}

/// Resize window
pub fn resizeWindow(winname: []const u8, width: i32, height: i32) !void {
    const winname_z = try std.heap.c_allocator.dupeZ(u8, winname);
    defer std.heap.c_allocator.free(winname_z);
    c.ResizeWindow(winname_z.ptr, width, height);
}

/// Move window
pub fn moveWindow(winname: []const u8, x: i32, y: i32) !void {
    const winname_z = try std.heap.c_allocator.dupeZ(u8, winname);
    defer std.heap.c_allocator.free(winname_z);
    c.MoveWindow(winname_z.ptr, x, y);
}

/// Set window property
pub fn setWindowProperty(winname: []const u8, prop_id: WindowPropertyFlag, prop_value: f64) !void {
    const winname_z = try std.heap.c_allocator.dupeZ(u8, winname);
    defer std.heap.c_allocator.free(winname_z);
    c.SetWindowProperty(winname_z.ptr, @intFromEnum(prop_id), prop_value);
}

/// Get window property
pub fn getWindowProperty(winname: []const u8, prop_id: WindowPropertyFlag) !f64 {
    const winname_z = try std.heap.c_allocator.dupeZ(u8, winname);
    defer std.heap.c_allocator.free(winname_z);
    return c.GetWindowProperty(winname_z.ptr, @intFromEnum(prop_id));
}

/// Set window title
pub fn setWindowTitle(winname: []const u8, title: []const u8) !void {
    const winname_z = try std.heap.c_allocator.dupeZ(u8, winname);
    defer std.heap.c_allocator.free(winname_z);
    const title_z = try std.heap.c_allocator.dupeZ(u8, title);
    defer std.heap.c_allocator.free(title_z);
    c.zocv_SetWindowTitle(winname_z.ptr, title_z.ptr);
}

/// Select ROI interactively
pub fn selectROI(winname: []const u8, img: Mat, show_crosshair: bool, from_center: bool) !Rect {
    const winname_z = try std.heap.c_allocator.dupeZ(u8, winname);
    defer std.heap.c_allocator.free(winname_z);
    const result = c.SelectROI(
        winname_z.ptr,
        img.ptr,
        if (show_crosshair) 1 else 0,
        if (from_center) 1 else 0,
    );
    return Rect{ .x = result.x, .y = result.y, .width = result.width, .height = result.height };
}

/// Create trackbar
pub fn createTrackbar(
    trackbarname: []const u8,
    winname: []const u8,
    value: ?*i32,
    count: i32,
    on_change: ?*const fn (i32, ?*anyopaque) callconv(.C) void,
) !void {
    const tb_z = try std.heap.c_allocator.dupeZ(u8, trackbarname);
    defer std.heap.c_allocator.free(tb_z);
    const wn_z = try std.heap.c_allocator.dupeZ(u8, winname);
    defer std.heap.c_allocator.free(wn_z);
    c.CreateTrackbar(
        tb_z.ptr,
        wn_z.ptr,
        value,
        count,
        @ptrCast(on_change),
    );
}

/// Get trackbar position
pub fn getTrackbarPos(trackbarname: []const u8, winname: []const u8) !i32 {
    const tb_z = try std.heap.c_allocator.dupeZ(u8, trackbarname);
    defer std.heap.c_allocator.free(tb_z);
    const wn_z = try std.heap.c_allocator.dupeZ(u8, winname);
    defer std.heap.c_allocator.free(wn_z);
    return c.GetTrackbarPos(tb_z.ptr, wn_z.ptr);
}

/// Set trackbar position
pub fn setTrackbarPos(trackbarname: []const u8, winname: []const u8, pos: i32) !void {
    const tb_z = try std.heap.c_allocator.dupeZ(u8, trackbarname);
    defer std.heap.c_allocator.free(tb_z);
    const wn_z = try std.heap.c_allocator.dupeZ(u8, winname);
    defer std.heap.c_allocator.free(wn_z);
    c.SetTrackbarPos(tb_z.ptr, wn_z.ptr, pos);
}

/// Set trackbar minimum value
pub fn setTrackbarMin(trackbarname: []const u8, winname: []const u8, minval: i32) !void {
    const tb_z = try std.heap.c_allocator.dupeZ(u8, trackbarname);
    defer std.heap.c_allocator.free(tb_z);
    const wn_z = try std.heap.c_allocator.dupeZ(u8, winname);
    defer std.heap.c_allocator.free(wn_z);
    c.SetTrackbarMin(tb_z.ptr, wn_z.ptr, minval);
}

/// Set trackbar maximum value
pub fn setTrackbarMax(trackbarname: []const u8, winname: []const u8, maxval: i32) !void {
    const tb_z = try std.heap.c_allocator.dupeZ(u8, trackbarname);
    defer std.heap.c_allocator.free(tb_z);
    const wn_z = try std.heap.c_allocator.dupeZ(u8, winname);
    defer std.heap.c_allocator.free(wn_z);
    c.SetTrackbarMax(tb_z.ptr, wn_z.ptr, maxval);
}

/// Set mouse callback for a window
pub fn setMouseCallback(
    winname: []const u8,
    on_mouse: ?*const fn (i32, i32, i32, i32, ?*anyopaque) callconv(.C) void,
    userdata: ?*anyopaque,
) !void {
    const winname_z = try std.heap.c_allocator.dupeZ(u8, winname);
    defer std.heap.c_allocator.free(winname_z);
    c.SetMouseCallback(winname_z.ptr, @ptrCast(on_mouse), userdata);
}
