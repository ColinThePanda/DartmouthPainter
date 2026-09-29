# Stitching Module

Image stitching and panorama creation.

## Stitcher

```zig
const Stitcher = struct {
    fn create(mode: StitcherMode) !Stitcher;
    fn deinit(self: *Stitcher) void;
    fn stitch(self: Stitcher, images: []Mat, pano: *Mat) StitcherStatus;
    fn getRegistrationResol(self: Stitcher) f64;
    fn setRegistrationResol(self: Stitcher, resol: f64) void;
    fn getSeamEstimationResol(self: Stitcher) f64;
    fn setSeamEstimationResol(self: Stitcher, resol: f64) void;
    fn getCompositingResol(self: Stitcher) f64;
    fn setCompositingResol(self: Stitcher, resol: f64) void;
    fn getPanoConfidenceThresh(self: Stitcher) f64;
    fn setPanoConfidenceThresh(self: Stitcher, conf_thresh: f64) void;
    fn getWaveCorrection(self: Stitcher) bool;
    fn setWaveCorrection(self: Stitcher, flag: bool) void;
};

const StitcherMode = enum(i32) { panorama, scans };
const StitcherStatus = enum(i32) { ok, err_need_more_imgs, err_homography_est_fail, err_camera_params_adjust_fail };
```
