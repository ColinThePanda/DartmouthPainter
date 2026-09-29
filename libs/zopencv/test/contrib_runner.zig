// Contrib test runner — imports all contrib test modules
// Requires: zig build test-contrib -Dcontrib=true
const std = @import("std");

test {
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

    // Integration tests
    _ = @import("integration/contrib/contrib_test.zig");
}
