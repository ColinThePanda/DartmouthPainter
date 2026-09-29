# XFeatures2D Module (contrib)

Extended feature descriptors: SURF and BriefDescriptorExtractor.

## SURF

```zig
const SURF = struct {
    fn init() !SURF;
    fn deinit(self: *SURF) void;
    fn detect(self: SURF, image: Mat, keypoints: *KeyPointVector, mask: ?Mat) void;
    fn compute(self: SURF, image: Mat, keypoints: *KeyPointVector, descriptors: *Mat) void;
    fn detectAndCompute(self: SURF, image: Mat, mask: ?Mat,
                        keypoints: *KeyPointVector, descriptors: *Mat) void;
};
```

## BriefDescriptorExtractor

```zig
const BriefDescriptorExtractor = struct {
    fn init() !BriefDescriptorExtractor;
    fn deinit(self: *BriefDescriptorExtractor) void;
    fn compute(self: BriefDescriptorExtractor, image: Mat,
               keypoints: *KeyPointVector, descriptors: *Mat) void;
};
```
