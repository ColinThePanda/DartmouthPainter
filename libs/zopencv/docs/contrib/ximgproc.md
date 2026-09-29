# ximgproc Module (contrib)

Extended image processing: edge-aware filters, thinning, adaptive thresholding.

## Filters

```zig
fn guidedFilter(src: Mat, guide: Mat, dst: *Mat, radius: i32, eps: f64) void;
fn bilateralTextureFilter(src: Mat, dst: *Mat, fr: i32, numIter: i32, sigmaAlpha: f64, sigmaAvg: f64) void;
fn adaptiveManifoldFilter(src: Mat, dst: *Mat, sigmaS: f64, sigmaR: f64, adjustOutliers: bool) void;
fn anisotropicDiffusion(src: Mat, dst: *Mat, alpha: f32, k: f32, niters: i32) void;
```

## Edge Detection

```zig
const StructuredEdgeDetection = struct {
    fn create(modelPath: [:0]const u8) !StructuredEdgeDetection;
    fn deinit(self: *StructuredEdgeDetection) void;
    fn detectEdges(self: StructuredEdgeDetection, src: Mat, dst: *Mat) void;
};
```

## Morphology & Thresholding

```zig
fn thinning(src: Mat, dst: *Mat, thinningType: ThinningType) void;
fn niBlackThreshold(src: Mat, dst: *Mat, maxValue: f64, thresholdType: i32,
    blockSize: i32, k: f64, method: BinarizationMethod) void;

const ThinningType = enum(i32) { zhang_suen, guo_hall };
const BinarizationMethod = enum(i32) { niblack, sauvola, wolf, nick };
```

## Example

```zig
// Skeletonization
var thin = try cv.Mat.init();
defer thin.deinit();
cv.contrib.ximgproc.thinning(binary_img, &thin, .zhang_suen);
```
