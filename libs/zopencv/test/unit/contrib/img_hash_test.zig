const std = @import("std");
const testing = std.testing;
const cv = @import("zopencv");

test "img_hash: AverageHash" {
    var img = try cv.Mat.initWithSize(100, 100, 0); // CV_8UC1
    defer img.deinit();

    var hash1 = try cv.Mat.init();
    defer hash1.deinit();

    // Create average hash
    var hasher = try cv.contrib.img_hash.ImgHashBase.createAverageHash();
    defer hasher.deinit();

    // Compute hash
    hasher.compute(img, &hash1);

    try testing.expect(!hash1.empty());
}

test "img_hash: PHash" {
    var img = try cv.Mat.initWithSize(100, 100, 0);
    defer img.deinit();

    var hash1 = try cv.Mat.init();
    defer hash1.deinit();

    var hasher = try cv.contrib.img_hash.ImgHashBase.createPHash();
    defer hasher.deinit();

    hasher.compute(img, &hash1);

    try testing.expect(!hash1.empty());
}

test "img_hash: Compare hashes" {
    var img = try cv.Mat.initWithSize(100, 100, 0);
    defer img.deinit();

    var hash1 = try cv.Mat.init();
    defer hash1.deinit();

    var hash2 = try cv.Mat.init();
    defer hash2.deinit();

    var hasher = try cv.contrib.img_hash.ImgHashBase.createAverageHash();
    defer hasher.deinit();

    // Compute same hash twice
    hasher.compute(img, &hash1);
    hasher.compute(img, &hash2);

    // Compare - should be identical (distance = 0)
    const distance = hasher.compare(hash1, hash2);
    try testing.expectEqual(@as(f64, 0.0), distance);
}

test "img_hash: BlockMeanHash" {
    var img = try cv.Mat.initWithSize(64, 64, 0);
    defer img.deinit();

    var hash = try cv.Mat.init();
    defer hash.deinit();

    var hasher = try cv.contrib.img_hash.ImgHashBase.createBlockMeanHash(0);
    defer hasher.deinit();

    hasher.compute(img, &hash);
    try testing.expect(!hash.empty());
}

test "img_hash: ColorMomentHash" {
    var img = try cv.Mat.initWithSize(100, 100, 16); // CV_8UC3 for color
    defer img.deinit();

    var hash = try cv.Mat.init();
    defer hash.deinit();

    var hasher = try cv.contrib.img_hash.ImgHashBase.createColorMomentHash();
    defer hasher.deinit();

    hasher.compute(img, &hash);
    try testing.expect(!hash.empty());
}

test "img_hash: Multiple algorithm comparison" {
    var img = try cv.Mat.initWithSize(100, 100, 0);
    defer img.deinit();

    // Test multiple hash algorithms
    var hasher_avg = try cv.contrib.img_hash.ImgHashBase.createAverageHash();
    defer hasher_avg.deinit();

    var hasher_p = try cv.contrib.img_hash.ImgHashBase.createPHash();
    defer hasher_p.deinit();

    var hash_avg = try cv.Mat.init();
    defer hash_avg.deinit();
    hasher_avg.compute(img, &hash_avg);

    var hash_p = try cv.Mat.init();
    defer hash_p.deinit();
    hasher_p.compute(img, &hash_p);

    // Both should produce valid hashes
    try testing.expect(!hash_avg.empty());
    try testing.expect(!hash_p.empty());
}
