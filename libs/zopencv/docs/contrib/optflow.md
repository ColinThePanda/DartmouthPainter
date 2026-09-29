# Optical Flow Module (contrib)

Dense optical flow using the Dual TVL1 algorithm.

## DualTVL1OpticalFlow

```zig
const DualTVL1OpticalFlow = struct {
    fn create() !DualTVL1OpticalFlow;
    fn deinit(self: *DualTVL1OpticalFlow) void;
    fn calc(self: DualTVL1OpticalFlow, prevImg: Mat, nextImg: Mat, flow: *Mat) void;
};
```

## Example

```zig
const cv = @import("zopencv");

var flow = try cv.contrib.optflow.DualTVL1OpticalFlow.create();
defer flow.deinit();

var result = try cv.Mat.init();
defer result.deinit();
flow.calc(prev_gray, next_gray, &result);
// result is a 2-channel float Mat (dx, dy per pixel)
```
