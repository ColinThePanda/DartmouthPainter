# HighGUI Module

Window management, trackbars, and mouse events.

## Window Functions

```zig
fn namedWindow(winname: []const u8, flags: WindowFlag) !void;
fn imshow(winname: []const u8, mat: Mat) !void;
fn waitKey(delay: i32) i32;
fn waitKeyEx(delay: i32) i32;
fn pollKey() i32;
fn destroyWindow(winname: []const u8) !void;
fn destroyAllWindows() void;
fn resizeWindow(winname: []const u8, width: i32, height: i32) !void;
fn moveWindow(winname: []const u8, x: i32, y: i32) !void;
fn setWindowTitle(winname: []const u8, title: []const u8) !void;
fn setWindowProperty(winname: []const u8, prop_id: WindowPropertyFlag, prop_value: f64) !void;
fn getWindowProperty(winname: []const u8, prop_id: WindowPropertyFlag) !f64;
fn selectROI(winname: []const u8, img: Mat, show_crosshair: bool, from_center: bool) !Rect;
```

## Trackbars

```zig
fn createTrackbar(trackbarname: []const u8, winname: []const u8, count: i32, callback: TrackbarCallback) !void;
fn getTrackbarPos(trackbarname: []const u8, winname: []const u8) !i32;
fn setTrackbarPos(trackbarname: []const u8, winname: []const u8, pos: i32) !void;
fn setTrackbarMin(trackbarname: []const u8, winname: []const u8, minval: i32) !void;
fn setTrackbarMax(trackbarname: []const u8, winname: []const u8, maxval: i32) !void;
```

## Mouse Events

```zig
fn setMouseCallback(winname: []const u8, callback: MouseCallback) !void;

const MouseEventTypes = enum(i32) { mousemove, lbuttondown, rbuttondown, mbuttondown, lbuttonup, rbuttonup, mbuttonup, lbuttondblclk, /* ... */ };
```

## Enums

```zig
const WindowFlag = enum(i32) { normal, autosize, opengl, fullscreen, freeratio, keepratio, gui_expanded, gui_normal };
```
