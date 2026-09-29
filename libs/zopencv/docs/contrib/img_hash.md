# img_hash Module (contrib)

Perceptual image hashing for similarity comparison.

## ImgHashBase

```zig
const ImgHashBase = struct {
    fn createAverageHash() !ImgHashBase;
    fn createPHash() !ImgHashBase;
    fn createBlockMeanHash(mode: i32) !ImgHashBase;
    fn createMarrHildrethHash(alpha: f32, scale: f32) !ImgHashBase;
    fn createRadialVarianceHash(sigma: f64, numOfAngleLine: i32) !ImgHashBase;
    fn createColorMomentHash() !ImgHashBase;
    fn deinit(self: *ImgHashBase) void;
    fn compute(self: ImgHashBase, input: Mat, output: *Mat) void;
    fn compare(self: ImgHashBase, hashOne: Mat, hashTwo: Mat) f64;
};
```

## Algorithms

| Algorithm          | Speed | Robustness | Best For                    |
| ------------------ | ----- | ---------- | --------------------------- |
| AverageHash        | ⚡⚡⚡   | Basic      | Quick duplicate detection   |
| PHash              | ⚡⚡⚡   | Good       | General similarity matching |
| BlockMeanHash      | ⚡⚡    | Good       | Rotation-tolerant matching  |
| MarrHildrethHash   | ⚡⚡    | Very Good  | Edge-based similarity       |
| RadialVarianceHash | ⚡     | Excellent  | Rotation-invariant          |
| ColorMomentHash    | ⚡⚡    | Good       | Color-based similarity      |

## Example

```zig
var hasher = try cv.contrib.img_hash.ImgHashBase.createPHash();
defer hasher.deinit();
var hash1 = try cv.Mat.init(); defer hash1.deinit();
var hash2 = try cv.Mat.init(); defer hash2.deinit();
hasher.compute(img1, &hash1);
hasher.compute(img2, &hash2);
const distance = hasher.compare(hash1, hash2); // 0 = identical
```
