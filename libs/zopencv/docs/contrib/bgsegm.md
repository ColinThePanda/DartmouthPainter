# bgsegm Module (contrib)

Advanced background subtraction algorithms for motion detection.

## BackgroundSubtractor

```zig
const BackgroundSubtractor = struct {
    fn createMOG(history: i32, nmixtures: i32, backgroundRatio: f64, noiseSigma: f64) !BackgroundSubtractor;
    fn createGMG(initFrames: i32, decisionThreshold: f64) !BackgroundSubtractor;
    fn createCNT(minPixelStability: i32, useHistory: bool, maxPixelStability: i32, isParallel: bool) !BackgroundSubtractor;
    fn createGSOC() !BackgroundSubtractor;
    fn createLSBP() !BackgroundSubtractor;
    fn deinit(self: *BackgroundSubtractor) void;
    fn apply(self: BackgroundSubtractor, image: Mat, fgmask: *Mat, learningRate: f64) void;
    fn getBackgroundImage(self: BackgroundSubtractor, bg: *Mat) void;
};
```

## Algorithms

| Algorithm | Speed  | Quality   | Best For                                    |
| --------- | ------ | --------- | ------------------------------------------- |
| MOG       | Medium | Good      | General purpose, adaptive backgrounds       |
| GMG       | Slow   | Excellent | High-quality segmentation, shadow detection |
| CNT       | Fast   | Basic     | Real-time applications                      |
| GSOC      | Medium | Good      | Robust to illumination changes              |
| LSBP      | Medium | Excellent | Complex scenes, shadows                     |

## Example

```zig
var bg = try cv.contrib.bgsegm.BackgroundSubtractor.createCNT(15, true, 15 * 60, true);
defer bg.deinit();
var fgmask = try cv.Mat.init();
defer fgmask.deinit();
bg.apply(frame, &fgmask, -1.0);
```
