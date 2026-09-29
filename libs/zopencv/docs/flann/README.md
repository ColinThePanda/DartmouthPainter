# FLANN Module

Fast Library for Approximate Nearest Neighbors.

## FlannIndex

```zig
const FlannIndex = struct {
    fn create(features: Mat, index_type: FlannIndexType) !FlannIndex;
    fn createKDTree(features: Mat, trees: i32) !FlannIndex;
    fn deinit(self: *FlannIndex) void;
    fn knnSearch(self: FlannIndex, query: Mat, indices: *Mat, dists: *Mat, knn: i32) void;
    fn radiusSearch(self: FlannIndex, query: Mat, indices: *Mat, dists: *Mat,
                    radius: f64, max_results: i32) i32;
};

const FlannIndexType = enum(i32) { linear, kdtree, kmeans, composite, autotuned };
```

## Example

```zig
var index = try cv.flann.FlannIndex.createKDTree(features, 4);
defer index.deinit();
var indices = try cv.Mat.init();
defer indices.deinit();
var dists = try cv.Mat.init();
defer dists.deinit();
index.knnSearch(query, &indices, &dists, 5);
```
