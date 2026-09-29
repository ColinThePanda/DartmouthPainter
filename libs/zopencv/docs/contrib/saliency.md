# Saliency Module (contrib)

Static saliency detection for identifying visually important regions.

## StaticSaliency

```zig
const StaticSaliency = struct {
    fn createSpectralResidual() !StaticSaliency;
    fn createFineGrained() !StaticSaliency;
    fn deinit(self: *StaticSaliency) void;
    fn computeSaliency(self: StaticSaliency, image: Mat, saliencyMap: *Mat) bool;
};
```

## Algorithms

| Algorithm        | Description                                                     |
| ---------------- | --------------------------------------------------------------- |
| SpectralResidual | Fast saliency detection based on spectral residual of image FFT |
| FineGrained      | More detailed saliency map at higher computational cost         |

## Example

```zig
const cv = @import("zopencv");

var saliency = try cv.contrib.saliency.StaticSaliency.createSpectralResidual();
defer saliency.deinit();

var saliencyMap = try cv.Mat.init();
defer saliencyMap.deinit();
const ok = saliency.computeSaliency(img, &saliencyMap);
```
