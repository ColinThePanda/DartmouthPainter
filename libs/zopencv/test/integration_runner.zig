// Integration test runner - imports tests that use real images, video, and I/O
const std = @import("std");
const cv = @import("zopencv");
const enable_contrib = @hasDecl(cv.contrib, "tracking");

test {
    _ = @import("integration/imgproc_test.zig");
    _ = @import("integration/imgcodecs_test.zig");
    _ = @import("integration/calib3d_test.zig");
    _ = @import("integration/features2d_test.zig");
    _ = @import("integration/objdetect_test.zig");
    _ = @import("integration/video_test.zig");
    _ = @import("integration/videoio_test.zig");
}

// Contrib integration tests (only when -Dcontrib=true)
test {
    if (enable_contrib) {
        _ = @import("integration/contrib/contrib_test.zig");
    }
}
