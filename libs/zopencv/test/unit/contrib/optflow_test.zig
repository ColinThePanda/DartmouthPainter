const std = @import("std");
const testing = std.testing;
const cv = @import("zopencv");

test "optflow: DualTVL1OpticalFlow create and deinit" {
    var flow = try cv.contrib.optflow.DualTVL1OpticalFlow.create();
    defer flow.deinit();
}

test "optflow: DualTVL1OpticalFlow calc on synthetic images" {
    var img1 = try cv.Mat.initWithSize(32, 32, 0); // CV_8UC1
    defer img1.deinit();
    var img2 = try cv.Mat.initWithSize(32, 32, 0);
    defer img2.deinit();

    var flow = try cv.contrib.optflow.DualTVL1OpticalFlow.create();
    defer flow.deinit();

    var result = try cv.Mat.init();
    defer result.deinit();
    flow.calc(img1, img2, &result);

    try testing.expect(!result.empty());
    try testing.expectEqual(@as(i32, 32), result.rows());
    try testing.expectEqual(@as(i32, 32), result.cols());
}
