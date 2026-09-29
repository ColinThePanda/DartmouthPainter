const std = @import("std");
const testing = std.testing;
const cv = @import("zopencv");

test "aruco: ArucoDictionary creation" {
    var dict = try cv.contrib.aruco.ArucoDictionary.getPredefined(cv.contrib.aruco.PredefinedDictionaryType.dict_6x6_250);
    defer dict.deinit();
    // Successfully created
}

test "aruco: ArucoDetector creation" {
    var dict = try cv.contrib.aruco.ArucoDictionary.getPredefined(cv.contrib.aruco.PredefinedDictionaryType.dict_4x4_50);
    defer dict.deinit();

    var detector = try cv.contrib.aruco.ArucoDetector.create(dict);
    defer detector.deinit();
    // Successfully created
}

test "aruco: PredefinedDictionaryType enum" {
    const dict_4x4_50 = cv.contrib.aruco.PredefinedDictionaryType.dict_4x4_50;
    const dict_6x6_250 = cv.contrib.aruco.PredefinedDictionaryType.dict_6x6_250;
    const dict_aruco_original = cv.contrib.aruco.PredefinedDictionaryType.dict_aruco_original;

    try testing.expectEqual(@as(i32, 0), @intFromEnum(dict_4x4_50));
    try testing.expectEqual(@as(i32, 10), @intFromEnum(dict_6x6_250));
    try testing.expectEqual(@as(i32, 16), @intFromEnum(dict_aruco_original));
}
