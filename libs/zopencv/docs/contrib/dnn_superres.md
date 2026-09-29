# dnn_superres Module (contrib)

DNN-based image super resolution.

## DnnSuperResImpl

```zig
const DnnSuperResImpl = struct {
    fn create() !DnnSuperResImpl;
    fn deinit(self: *DnnSuperResImpl) void;
    fn readModel(self: DnnSuperResImpl, path: []const u8) void;
    fn setModel(self: DnnSuperResImpl, algo: []const u8, scale: i32) void;
    fn upsample(self: DnnSuperResImpl, img: Mat, result: *Mat) void;
    fn getScale(self: DnnSuperResImpl) i32;
    fn getAlgorithm(self: DnnSuperResImpl) []const u8;
};
```

## Supported Algorithms

| Algorithm  | Description                           |
| ---------- | ------------------------------------- |
| `"edsr"`   | Enhanced Deep Residual (best quality) |
| `"espcn"`  | Efficient Sub-Pixel CNN (fastest)     |
| `"fsrcnn"` | Fast Super-Resolution CNN             |
| `"lapsrn"` | Laplacian Pyramid Super-Resolution    |

## Example

```zig
var sr = try cv.contrib.dnn_superres.DnnSuperResImpl.create();
defer sr.deinit();
sr.readModel("EDSR_x4.pb");
sr.setModel("edsr", 4);
var result = try cv.Mat.init();
defer result.deinit();
sr.upsample(img, &result); // 4× upscale
```
