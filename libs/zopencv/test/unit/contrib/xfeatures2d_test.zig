const std = @import("std");
const testing = std.testing;
const cv = @import("zopencv");

test "xfeatures2d: SURF creation" {
    // SURF might fail if nonfree is not enabled, we should handle this gracefully
    if (cv.contrib.xfeatures2d.SURF.createDefault()) |result| {
        var surf = result;
        defer surf.deinit();
    } else |err| {
        // If it fails due to initialization (likely nonfree issue), we skip/log but don't fail the test
        if (err == error.AlgorithmInitializationFailed) {
            std.debug.print("Skipping SURF test (nonfree not enabled)\n", .{});
            return;
        }
        return err;
    }
}

test "xfeatures2d: FREAK creation" {
    var freak = try cv.contrib.xfeatures2d.FREAK.createDefault();
    defer freak.deinit();
    // Successfully created
}

test "xfeatures2d: BriefDescriptorExtractor creation" {
    var brief = try cv.contrib.xfeatures2d.BriefDescriptorExtractor.createDefault();
    defer brief.deinit();
    // Successfully created
}
