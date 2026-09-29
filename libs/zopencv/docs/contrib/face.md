# Face Module (contrib)

Face recognition using Local Binary Pattern Histograms.

## LBPHFaceRecognizer

```zig
const LBPHFaceRecognizer = struct {
    fn init() !LBPHFaceRecognizer;
    fn initWithParams(radius: i32, neighbors: i32, grid_x: i32, grid_y: i32, threshold: f64) !LBPHFaceRecognizer;
    fn deinit(self: *LBPHFaceRecognizer) void;
    fn train(self: LBPHFaceRecognizer, images: []Mat, labels: Mat) void;
    fn update(self: LBPHFaceRecognizer, images: []Mat, labels: Mat) void;
    fn predict(self: LBPHFaceRecognizer, image: Mat) struct { label: i32, confidence: f64 };
    fn save(self: LBPHFaceRecognizer, filename: []const u8) void;
    fn load(self: LBPHFaceRecognizer, filename: []const u8) void;
};
```
