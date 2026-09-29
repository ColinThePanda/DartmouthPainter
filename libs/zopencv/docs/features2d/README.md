# Features2D Module

Feature detection, description, and matching.

## Feature Detectors

### ORB

```zig
const ORB = struct {
    fn init() !ORB;
    fn initWithParams(nfeatures: i32, scaleFactor: f32, nlevels: i32,
                      edgeThreshold: i32, firstLevel: i32, WTA_K: i32,
                      scoreType: i32, patchSize: i32, fastThreshold: i32) !ORB;
    fn deinit(self: *ORB) void;
    fn detect(self: ORB, image: Mat, keypoints: *KeyPointVector, mask: ?Mat) void;
    fn compute(self: ORB, image: Mat, keypoints: *KeyPointVector, descriptors: *Mat) void;
    fn detectAndCompute(self: ORB, image: Mat, mask: ?Mat,
                        keypoints: *KeyPointVector, descriptors: *Mat) void;
};
```

### SIFT

```zig
const SIFT = struct {
    fn init() !SIFT;
    fn deinit(self: *SIFT) void;
    fn detect(self: SIFT, image: Mat, keypoints: *KeyPointVector, mask: ?Mat) void;
    fn compute(self: SIFT, image: Mat, keypoints: *KeyPointVector, descriptors: *Mat) void;
    fn detectAndCompute(self: SIFT, image: Mat, mask: ?Mat,
                        keypoints: *KeyPointVector, descriptors: *Mat) void;
};
```

### AKAZE

```zig
const AKAZE = struct {
    fn init() !AKAZE;
    fn deinit(self: *AKAZE) void;
    fn detect(self: AKAZE, image: Mat, keypoints: *KeyPointVector, mask: ?Mat) void;
    fn compute(self: AKAZE, image: Mat, keypoints: *KeyPointVector, descriptors: *Mat) void;
    fn detectAndCompute(self: AKAZE, image: Mat, mask: ?Mat,
                        keypoints: *KeyPointVector, descriptors: *Mat) void;
};
```

## Matching

### BFMatcher

```zig
const BFMatcher = struct {
    fn init() !BFMatcher;
    fn initWithParams(normType: i32, crossCheck: bool) !BFMatcher;
    fn deinit(self: *BFMatcher) void;
    fn knnMatch(self: BFMatcher, queryDescriptors: Mat, trainDescriptors: Mat,
                k: i32) !DMatchVectorVector;
};
```

## Support Types

```zig
const KeyPointVector = struct {
    fn init() !KeyPointVector;
    fn deinit(self: *KeyPointVector) void;
    fn size(self: KeyPointVector) usize;
    fn at(self: KeyPointVector, index: usize) KeyPointData;
};

const KeyPointData = struct { x: f32, y: f32, size: f32, angle: f32, response: f32, octave: i32, class_id: i32 };

const DMatch = struct { queryIdx: i32, trainIdx: i32, imgIdx: i32, distance: f32 };
```

## Example

```zig
const cv = @import("zopencv");

var orb = try cv.features2d.ORB.init();
defer orb.deinit();

var kps = try cv.features2d.KeyPointVector.init();
defer kps.deinit();
var desc = try cv.Mat.init();
defer desc.deinit();

orb.detectAndCompute(img, null, &kps, &desc);
```
