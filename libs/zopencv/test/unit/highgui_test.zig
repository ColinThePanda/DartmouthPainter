const std = @import("std");
const testing = std.testing;
const cv = @import("zopencv");

test "highgui: WindowFlag enum" {
    const normal = cv.highgui.WindowFlag.normal;
    const autosize = cv.highgui.WindowFlag.autosize;

    try testing.expectEqual(@as(i32, 0x00000000), @intFromEnum(normal));
    try testing.expectEqual(@as(i32, 0x00000001), @intFromEnum(autosize));
}

test "highgui: waitKey returns value" {
    // waitKey should return -1 if no key pressed (with 0 or small delay)
    const key = cv.highgui.waitKey(1);
    try testing.expect(key == -1 or key >= 0);
}
