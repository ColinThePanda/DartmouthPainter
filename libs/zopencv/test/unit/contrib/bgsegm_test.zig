const std = @import("std");
const testing = std.testing;
const cv = @import("zopencv");

test "bgsegm: BackgroundSubtractorMOG" {
    var img = try cv.Mat.initWithSize(100, 100, 16); // CV_8UC3
    defer img.deinit();

    var fgmask = try cv.Mat.init();
    defer fgmask.deinit();

    // Create MOG background subtractor
    var bs = try cv.contrib.bgsegm.BackgroundSubtractor.createMOG(200, 5, 0.7, 0);
    defer bs.deinit();

    // Apply background subtraction
    bs.apply(img, &fgmask, -1);

    try testing.expect(!fgmask.empty());
}

test "bgsegm: BackgroundSubtractorGMG" {
    var img = try cv.Mat.initWithSize(100, 100, 16);
    defer img.deinit();

    var fgmask = try cv.Mat.init();
    defer fgmask.deinit();

    var bs = try cv.contrib.bgsegm.BackgroundSubtractor.createGMG(120, 0.8);
    defer bs.deinit();

    bs.apply(img, &fgmask, -1);

    try testing.expect(!fgmask.empty());
}

test "bgsegm: BackgroundSubtractorCNT" {
    var img = try cv.Mat.initWithSize(100, 100, 16);
    defer img.deinit();

    var fgmask = try cv.Mat.init();
    defer fgmask.deinit();

    var bs = try cv.contrib.bgsegm.BackgroundSubtractor.createCNT(15, true, 15 * 60, false);
    defer bs.deinit();

    bs.apply(img, &fgmask, -1);

    try testing.expect(!fgmask.empty());
}

test "bgsegm: BackgroundSubtractorGSOC" {
    var img = try cv.Mat.initWithSize(100, 100, 16);
    defer img.deinit();

    var fgmask = try cv.Mat.init();
    defer fgmask.deinit();

    var bs = try cv.contrib.bgsegm.BackgroundSubtractor.createGSOC();
    defer bs.deinit();

    bs.apply(img, &fgmask, -1);
    try testing.expect(!fgmask.empty());
}

test "bgsegm: BackgroundSubtractorLSBP" {
    var img = try cv.Mat.initWithSize(100, 100, 16);
    defer img.deinit();

    var fgmask = try cv.Mat.init();
    defer fgmask.deinit();

    var bs = try cv.contrib.bgsegm.BackgroundSubtractor.createLSBP();
    defer bs.deinit();

    bs.apply(img, &fgmask, -1);
    try testing.expect(!fgmask.empty());
}

test "bgsegm: Multi-frame processing" {
    var bs = try cv.contrib.bgsegm.BackgroundSubtractor.createMOG(200, 5, 0.7, 0);
    defer bs.deinit();

    // Process multiple frames
    var i: usize = 0;
    while (i < 3) : (i += 1) {
        var frame = try cv.Mat.initWithSize(64, 64, 16);
        defer frame.deinit();

        var fgmask = try cv.Mat.init();
        defer fgmask.deinit();

        bs.apply(frame, &fgmask, -1);
        try testing.expect(!fgmask.empty());
    }
}
