// Unit test runner - imports all unit test modules (pure logic, no I/O)
// Optionally includes contrib unit tests when -Dcontrib=true
const cv = @import("zopencv");
const enable_contrib = @hasDecl(cv.contrib, "tracking");

test {
    _ = @import("unit/core_test.zig");
    _ = @import("unit/imgproc_test.zig");
    _ = @import("unit/imgcodecs_test.zig");
    _ = @import("unit/calib3d_test.zig");
    _ = @import("unit/features2d_test.zig");
    _ = @import("unit/objdetect_test.zig");
    _ = @import("unit/dnn_test.zig");
    _ = @import("unit/video_test.zig");
    _ = @import("unit/videoio_test.zig");
    _ = @import("unit/highgui_test.zig");
    _ = @import("unit/photo_test.zig");
    _ = @import("unit/ml_test.zig");
    _ = @import("unit/flann_test.zig");
    _ = @import("unit/stitching_test.zig");
}

// Contrib unit tests (only when -Dcontrib=true)
test {
    if (enable_contrib) {
        _ = @import("unit/contrib/tracking_test.zig");
        _ = @import("unit/contrib/aruco_test.zig");
        _ = @import("unit/contrib/face_test.zig");
        _ = @import("unit/contrib/text_test.zig");
        _ = @import("unit/contrib/xfeatures2d_test.zig");
        _ = @import("unit/contrib/ximgproc_test.zig");
        _ = @import("unit/contrib/xphoto_test.zig");
        _ = @import("unit/contrib/img_hash_test.zig");
        _ = @import("unit/contrib/bgsegm_test.zig");
        _ = @import("unit/contrib/dnn_superres_test.zig");
        _ = @import("unit/contrib/bioinspired_test.zig");
        _ = @import("unit/contrib/optflow_test.zig");
        _ = @import("unit/contrib/saliency_test.zig");
    }
}
