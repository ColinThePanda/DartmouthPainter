# VideoIO Module

Video capture and writing.

## VideoCapture

```zig
const VideoCapture = struct {
    fn init() !VideoCapture;
    fn initFromIndex(index: i32) !VideoCapture;
    fn initFromFile(filename: []const u8) !VideoCapture;
    fn deinit(self: *VideoCapture) void;
    fn isOpened(self: VideoCapture) bool;
    fn read(self: *VideoCapture, image: *Mat) bool;
    fn grab(self: *VideoCapture) bool;
    fn retrieve(self: *VideoCapture, image: *Mat) bool;
    fn get(self: VideoCapture, prop: VideoCaptureProperty) f64;
    fn set(self: *VideoCapture, prop: VideoCaptureProperty, value: f64) bool;
    fn getBackendName(self: VideoCapture, allocator: Allocator) ![]u8;
};
```

## VideoWriter

```zig
const VideoWriter = struct {
    fn init() !VideoWriter;
    fn initWithParams(filename: []const u8, fourcc: i32, fps: f64,
                      frame_size: Size, is_color: bool) !VideoWriter;
    fn deinit(self: *VideoWriter) void;
    fn isOpened(self: VideoWriter) bool;
    fn write(self: *VideoWriter, image: Mat) void;
};

fn fourcc(c1: u8, c2: u8, c3: u8, c4: u8) i32;
```

## VideoCaptureProperty

```zig
const VideoCaptureProperty = enum(i32) {
    pos_msec, pos_frames, pos_avi_ratio, frame_width, frame_height,
    fps, fourcc, frame_count, format, mode, brightness, contrast,
    saturation, hue, gain, exposure, // ... more
};
```

## Example

```zig
const cv = @import("zopencv");

var cap = try cv.videoio.VideoCapture.initFromFile("video.mp4");
defer cap.deinit();

var frame = try cv.Mat.init();
defer frame.deinit();

while (cap.read(&frame)) {
    if (frame.empty()) break;
    // Process frame...
}
```
