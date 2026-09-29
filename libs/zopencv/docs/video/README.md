# Video Module

Video analysis: optical flow, background subtraction, and object tracking.

## Background Subtraction

### BackgroundSubtractorMOG2

```zig
const BackgroundSubtractorMOG2 = struct {
    fn init() !BackgroundSubtractorMOG2;
    fn initWithParams(history: i32, varThreshold: f64, detectShadows: bool) !BackgroundSubtractorMOG2;
    fn deinit(self: *BackgroundSubtractorMOG2) void;
    fn apply(self: BackgroundSubtractorMOG2, src: Mat, dst: *Mat) void;
};
```

### BackgroundSubtractorKNN

```zig
const BackgroundSubtractorKNN = struct {
    fn init() !BackgroundSubtractorKNN;
    fn initWithParams(history: i32, dist2Threshold: f64, detectShadows: bool) !BackgroundSubtractorKNN;
    fn deinit(self: *BackgroundSubtractorKNN) void;
    fn apply(self: BackgroundSubtractorKNN, src: Mat, dst: *Mat) void;
};
```

## Optical Flow

```zig
fn calcOpticalFlowPyrLK(prevImg: Mat, nextImg: Mat, prevPts: Point2fVector,
    nextPts: *Point2fVector, status: *Mat, err_mat: *Mat) void;

fn calcOpticalFlowFarneback(prev: Mat, next: Mat, flow: *Mat, pyrScale: f64,
    levels: i32, winSize: i32, iterations: i32, polyN: i32, polySigma: f64, flags: i32) void;
```

## Tracking

### Tracker

```zig
const Tracker = struct {
    fn initMIL() !Tracker;
    fn initGOTURN() !Tracker;
    fn deinit(self: *Tracker) void;
    fn initTracker(self: Tracker, image: Mat, boundingBox: Rect) bool;
    fn update(self: Tracker, image: Mat) ?Rect;
};
```

## Example

```zig
const cv = @import("zopencv");

// Background subtraction
var bg = try cv.video.BackgroundSubtractorMOG2.init();
defer bg.deinit();
var mask = try cv.Mat.init();
defer mask.deinit();
bg.apply(frame, &mask);
```
