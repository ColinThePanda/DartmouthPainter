const std = @import("std");
const testing = std.testing;
const cv = @import("zopencv");

test "tracking: TrackerKCF creation" {
    var tracker = try cv.contrib.tracking.Tracker.createKCF();
    defer tracker.deinit();
    // Successfully created
}

test "tracking: TrackerCSRT creation" {
    var tracker = try cv.contrib.tracking.Tracker.createCSRT();
    defer tracker.deinit();
    // Successfully created
}

test "tracking: TrackerMIL creation" {
    var tracker = try cv.contrib.tracking.Tracker.createMIL();
    defer tracker.deinit();
    // Successfully created
}
