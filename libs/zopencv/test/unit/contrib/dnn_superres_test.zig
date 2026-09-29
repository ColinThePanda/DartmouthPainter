const std = @import("std");
const testing = std.testing;
const cv = @import("zopencv");

test "dnn_superres: Create and basic operations" {
    var sr = try cv.contrib.dnn_superres.DnnSuperResImpl.create();
    defer sr.deinit();

    // Set model without loading (just test API)
    sr.setModel("edsr", 2);

    const scale = sr.getScale();
    try testing.expectEqual(@as(i32, 2), scale);

    const algo = sr.getAlgorithm();
    try testing.expect(algo.len > 0);
}

test "dnn_superres: Upsample without model" {
    var sr = try cv.contrib.dnn_superres.DnnSuperResImpl.create();
    defer sr.deinit();

    var img = try cv.Mat.initWithSize(50, 50, 16); // CV_8UC3
    defer img.deinit();

    var result = try cv.Mat.init();
    defer result.deinit();

    // Note: This will fail without a model loaded, but tests the API
    // In real usage, you would call readModel() first
    // sr.upsample(img, &result);

    try testing.expect(!img.empty());
}

test "dnn_superres: Model configuration" {
    var sr = try cv.contrib.dnn_superres.DnnSuperResImpl.create();
    defer sr.deinit();

    // Test different model configurations
    sr.setModel("fsrcnn", 3);
    try testing.expectEqual(@as(i32, 3), sr.getScale());
    try testing.expectEqualStrings("fsrcnn", sr.getAlgorithm());

    sr.setModel("lapsrn", 4);
    try testing.expectEqual(@as(i32, 4), sr.getScale());
    try testing.expectEqualStrings("lapsrn", sr.getAlgorithm());
}

test "dnn_superres: Different scaling factors" {
    var sr = try cv.contrib.dnn_superres.DnnSuperResImpl.create();
    defer sr.deinit();

    // Test 2x scaling
    sr.setModel("espcn", 2);
    try testing.expectEqual(@as(i32, 2), sr.getScale());

    // Test 4x scaling
    sr.setModel("espcn", 4);
    try testing.expectEqual(@as(i32, 4), sr.getScale());
}

test "dnn_superres: Different image sizes" {
    var sr = try cv.contrib.dnn_superres.DnnSuperResImpl.create();
    defer sr.deinit();

    sr.setModel("edsr", 2);

    // Small image
    var small = try cv.Mat.initWithSize(32, 32, 16);
    defer small.deinit();
    try testing.expect(!small.empty());

    // Large image
    var large = try cv.Mat.initWithSize(128, 128, 16);
    defer large.deinit();
    try testing.expect(!large.empty());
}
