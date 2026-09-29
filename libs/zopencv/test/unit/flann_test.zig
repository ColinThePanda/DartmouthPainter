const std = @import("std");
const testing = std.testing;
const cv = @import("zopencv");

test "flann: FlannIndex creation with linear" {
    // Create simple feature matrix (3 points, 2 dimensions)
    // CV_32F = 5
    var features = try cv.Mat.initWithSize(3, 2, 5);
    defer features.deinit();

    var index = try cv.flann.FlannIndex.create(features, cv.flann.FlannIndexType.linear);
    defer index.deinit();
    // Successfully created
}

test "flann: FlannIndex creation with KDTree" {
    // CV_32F = 5
    var features = try cv.Mat.initWithSize(10, 4, 5);
    defer features.deinit();

    var index = try cv.flann.FlannIndex.createKDTree(features, 4);
    defer index.deinit();
    // Successfully created with 4 trees
}

test "flann: FlannIndexType enum" {
    const linear = cv.flann.FlannIndexType.linear;
    const kdtree = cv.flann.FlannIndexType.kdtree;
    const kmeans = cv.flann.FlannIndexType.kmeans;
    const autotuned = cv.flann.FlannIndexType.autotuned;

    try testing.expectEqual(@as(i32, 0), @intFromEnum(linear));
    try testing.expectEqual(@as(i32, 1), @intFromEnum(kdtree));
    try testing.expectEqual(@as(i32, 2), @intFromEnum(kmeans));
    try testing.expectEqual(@as(i32, 255), @intFromEnum(autotuned));
}

// ============================================================================
// FLANN Search Tests
// ============================================================================

test "flann: knnSearch" {
    // Create feature data: 10 points in 4D space
    var features = try cv.Mat.initWithSize(10, 4, 5); // CV_32FC1
    defer features.deinit();
    // Fill with distinct values so knn has something to match
    var i: i32 = 0;
    while (i < 10) : (i += 1) {
        var j: i32 = 0;
        while (j < 4) : (j += 1) {
            features.setFloat(i, j, @as(f32, @floatFromInt(i * 4 + j)));
        }
    }

    var index = try cv.flann.FlannIndex.createKDTree(features, 4);
    defer index.deinit();

    // Query: search for point closest to feature 0
    var query = try cv.Mat.initWithSize(1, 4, 5);
    defer query.deinit();
    query.setFloat(0, 0, 0.0);
    query.setFloat(0, 1, 1.0);
    query.setFloat(0, 2, 2.0);
    query.setFloat(0, 3, 3.0);

    var indices = try cv.Mat.init();
    defer indices.deinit();
    var dists = try cv.Mat.init();
    defer dists.deinit();

    index.knnSearch(query, &indices, &dists, 3);
    try testing.expect(!indices.empty());
    try testing.expect(!dists.empty());
    try testing.expectEqual(@as(i32, 1), indices.rows());
    try testing.expectEqual(@as(i32, 3), indices.cols()); // k=3
}

test "flann: radiusSearch" {
    // Create feature data: 10 points in 2D space
    var features = try cv.Mat.initWithSize(10, 2, 5); // CV_32FC1
    defer features.deinit();
    var i: i32 = 0;
    while (i < 10) : (i += 1) {
        features.setFloat(i, 0, @as(f32, @floatFromInt(i)));
        features.setFloat(i, 1, @as(f32, @floatFromInt(i)));
    }

    var index = try cv.flann.FlannIndex.create(features, .linear);
    defer index.deinit();

    // Query: search for points within radius of (0,0)
    var query = try cv.Mat.initWithSize(1, 2, 5);
    defer query.deinit();
    query.setFloat(0, 0, 0.0);
    query.setFloat(0, 1, 0.0);

    var indices = try cv.Mat.init();
    defer indices.deinit();
    var dists = try cv.Mat.init();
    defer dists.deinit();

    // Radius of 5.0 should find nearby points
    const count = index.radiusSearch(query, &indices, &dists, 5.0, 10);
    // Should find at least 1 point (the origin itself)
    try testing.expect(count >= 1);
    try testing.expect(!indices.empty());
}
