const std = @import("std");
const testing = std.testing;
const cv = @import("zopencv");

test "saliency: StaticSaliency SpectralResidual create and deinit" {
    var saliency = try cv.contrib.saliency.StaticSaliency.createSpectralResidual();
    defer saliency.deinit();
}

test "saliency: StaticSaliency FineGrained create and deinit" {
    var saliency = try cv.contrib.saliency.StaticSaliency.createFineGrained();
    defer saliency.deinit();
}

test "saliency: SpectralResidual computeSaliency on synthetic image" {
    var img = try cv.Mat.initWithSize(64, 64, 16); // CV_8UC3
    defer img.deinit();

    var saliency = try cv.contrib.saliency.StaticSaliency.createSpectralResidual();
    defer saliency.deinit();

    var saliencyMap = try cv.Mat.init();
    defer saliencyMap.deinit();
    const success = saliency.computeSaliency(img, &saliencyMap);
    try testing.expect(success);
    try testing.expect(!saliencyMap.empty());
}

test "saliency: FineGrained computeSaliency on synthetic image" {
    var img = try cv.Mat.initWithSize(64, 64, 16); // CV_8UC3
    defer img.deinit();

    var saliency = try cv.contrib.saliency.StaticSaliency.createFineGrained();
    defer saliency.deinit();

    var saliencyMap = try cv.Mat.init();
    defer saliencyMap.deinit();
    const success = saliency.computeSaliency(img, &saliencyMap);
    try testing.expect(success);
    try testing.expect(!saliencyMap.empty());
}
