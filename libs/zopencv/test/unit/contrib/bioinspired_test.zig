const std = @import("std");
const testing = std.testing;
const cv = @import("zopencv");

test "bioinspired: Retina creation and basic operations" {
    var retina = try cv.contrib.bioinspired.Retina.create(100, 100, true);
    defer retina.deinit();

    // Create test input
    var input = try cv.Mat.initWithSize(100, 100, 16); // CV_8UC3
    defer input.deinit();

    // Run retina filter
    retina.run(input);

    // Get outputs
    var parvo = try cv.Mat.init();
    defer parvo.deinit();
    retina.getParvo(&parvo);

    var magno = try cv.Mat.init();
    defer magno.deinit();
    retina.getMagno(&magno);

    try testing.expect(!parvo.empty());
    try testing.expect(!magno.empty());
}

test "bioinspired: Retina clear buffers" {
    var retina = try cv.contrib.bioinspired.Retina.create(50, 50, false);
    defer retina.deinit();

    var input = try cv.Mat.initWithSize(50, 50, 0); // CV_8UC1
    defer input.deinit();

    retina.run(input);
    retina.clearBuffers();

    // Should still work after clearing
    retina.run(input);
}

test "bioinspired: Retina grayscale mode" {
    var retina = try cv.contrib.bioinspired.Retina.create(64, 64, false);
    defer retina.deinit();

    var input = try cv.Mat.initWithSize(64, 64, 0);
    defer input.deinit();

    retina.run(input);

    var output = try cv.Mat.init();
    defer output.deinit();
    retina.getParvo(&output);

    try testing.expect(!output.empty());
}

test "bioinspired: Different image sizes" {
    // Small image
    var retina_small = try cv.contrib.bioinspired.Retina.create(32, 32, true);
    defer retina_small.deinit();

    var small = try cv.Mat.initWithSize(32, 32, 16);
    defer small.deinit();
    retina_small.run(small);

    // Large image
    var retina_large = try cv.contrib.bioinspired.Retina.create(256, 256, true);
    defer retina_large.deinit();

    var large = try cv.Mat.initWithSize(256, 256, 16);
    defer large.deinit();
    retina_large.run(large);
}

test "bioinspired: Sequential frame processing" {
    var retina = try cv.contrib.bioinspired.Retina.create(64, 64, true);
    defer retina.deinit();

    // Process multiple frames sequentially
    var i: usize = 0;
    while (i < 3) : (i += 1) {
        var frame = try cv.Mat.initWithSize(64, 64, 16);
        defer frame.deinit();

        retina.run(frame);

        var parvo = try cv.Mat.init();
        defer parvo.deinit();
        retina.getParvo(&parvo);

        try testing.expect(!parvo.empty());
    }
}
