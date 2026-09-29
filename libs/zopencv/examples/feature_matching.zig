const std = @import("std");
const cv = @import("zopencv");

pub fn main() !void {
    std.debug.print("OpenCV Version: {s}\n\n", .{cv.getVersion()});

    // Test ORB feature detector
    std.debug.print("=== Testing ORB Feature Detector ===\n", .{});
    var orb = try cv.features2d.ORB.init();
    defer orb.deinit();
    std.debug.print("✅ ORB detector created\n", .{});

    // Test SIFT feature detector
    std.debug.print("\n=== Testing SIFT Feature Detector ===\n", .{});
    var sift = try cv.features2d.SIFT.init();
    defer sift.deinit();
    std.debug.print("✅ SIFT detector created\n", .{});

    // Test AKAZE feature detector
    std.debug.print("\n=== Testing AKAZE Feature Detector ===\n", .{});
    var akaze = try cv.features2d.AKAZE.init();
    defer akaze.deinit();
    std.debug.print("✅ AKAZE detector created\n", .{});

    // Test KeyPointVector
    std.debug.print("\n=== Testing KeyPointVector ===\n", .{});
    var keypoints = try cv.features2d.KeyPointVector.init();
    defer keypoints.deinit();
    std.debug.print("✅ KeyPointVector created\n", .{});
    std.debug.print("   Size: {}\n", .{keypoints.size()});

    // Test CascadeClassifier
    std.debug.print("\n=== Testing CascadeClassifier ===\n", .{});
    var cascade = try cv.objdetect.CascadeClassifier.init();
    defer cascade.deinit();
    std.debug.print("✅ CascadeClassifier created\n", .{});
    std.debug.print("   Is empty: {}\n", .{cascade.empty()});

    // Test HOGDescriptor
    std.debug.print("\n=== Testing HOGDescriptor ===\n", .{});
    var hog = try cv.objdetect.HOGDescriptor.init();
    defer hog.deinit();
    hog.setSVMDetector(.default_people);
    std.debug.print("✅ HOGDescriptor created with default people detector\n", .{});

    // Test RectVector
    std.debug.print("\n=== Testing RectVector ===\n", .{});
    var rects = try cv.objdetect.RectVector.init();
    defer rects.deinit();
    std.debug.print("✅ RectVector created\n", .{});
    std.debug.print("   Size: {}\n", .{rects.size()});

    std.debug.print("\n🎉 Success! All features2d and objdetect APIs working!\n", .{});
}
