# ArUco Module (contrib)

ArUco marker detection and dictionary generation.

## ArucoDetector

```zig
const ArucoDetector = struct {
    fn init() !ArucoDetector;
    fn deinit(self: *ArucoDetector) void;
    fn detectMarkers(self: ArucoDetector, image: Mat, markerCorners: *PointsVector,
                     markerIds: *Mat, rejectedImgPoints: ?*PointsVector) void;
};
```

## Dictionary

```zig
const ArucoDictionary = struct {
    fn init(dictionaryId: PredefinedDictionaryType) !ArucoDictionary;
    fn deinit(self: *ArucoDictionary) void;
    fn generateImageMarker(self: ArucoDictionary, id: i32, sidePixels: i32, dst: *Mat, borderBits: i32) void;
};

const PredefinedDictionaryType = enum(i32) {
    dict_4x4_50, dict_4x4_100, dict_4x4_250, dict_4x4_1000,
    dict_5x5_50, dict_5x5_100, dict_5x5_250, dict_5x5_1000,
    dict_6x6_50, dict_6x6_100, dict_6x6_250, dict_6x6_1000,
    dict_7x7_50, dict_7x7_100, dict_7x7_250, dict_7x7_1000,
    dict_aruco_original, dict_apriltag_16h5, dict_apriltag_25h9,
    dict_apriltag_36h10, dict_apriltag_36h11,
};
```

## Drawing

```zig
fn drawDetectedMarkers(image: *Mat, markerCorners: PointsVector, markerIds: Mat, borderColor: Scalar) void;
```
