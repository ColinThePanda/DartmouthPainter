# Object Detection Module

Cascade classifiers, HOG descriptors, and QR code detection.

## CascadeClassifier

```zig
const CascadeClassifier = struct {
    fn init() !CascadeClassifier;
    fn initFromFile(filename: []const u8) !CascadeClassifier;
    fn deinit(self: *CascadeClassifier) void;
    fn load(self: *CascadeClassifier, filename: []const u8) !bool;
    fn detectMultiScale(self: CascadeClassifier, image: Mat, objects: *RectVector,
        scaleFactor: f64, minNeighbors: i32, flags: i32, minSize: Size, maxSize: Size) void;
    fn detectMultiScaleWithParams(self: CascadeClassifier, image: Mat, objects: *RectVector,
        rejectLevels: *[]i32, levelWeights: *[]f64, scaleFactor: f64, minNeighbors: i32,
        flags: i32, minSize: Size, maxSize: Size, outputRejectLevels: bool) void;
    fn empty(self: CascadeClassifier) bool;
};
```

## HOGDescriptor

```zig
const HOGDescriptor = struct {
    fn init() !HOGDescriptor;
    fn deinit(self: *HOGDescriptor) void;
    fn setSVMDetector(self: *HOGDescriptor, detector: HOGDetectorType) void;
    fn detectMultiScale(self: HOGDescriptor, image: Mat, foundLocations: *RectVector,
        hitThreshold: f64, winStride: Size, padding: Size, scale: f64,
        finalThreshold: f64, useMeanshiftGrouping: bool) void;
};

const HOGDetectorType = enum { default_people_detector };
```

## QRCodeDetector

```zig
const QRCodeDetector = struct {
    fn init() !QRCodeDetector;
    fn deinit(self: *QRCodeDetector) void;
    fn detectAndDecode(self: QRCodeDetector, img: Mat, points: *Mat,
        straight_qrcode: *Mat, allocator: Allocator) ![]u8;
};
```

## Example

```zig
const cv = @import("zopencv");

var classifier = try cv.objdetect.CascadeClassifier.init();
defer classifier.deinit();
_ = try classifier.load("/path/to/haarcascade_frontalface_default.xml");

var faces = try cv.RectVector.init();
defer faces.deinit();

classifier.detectMultiScale(img, &faces, 1.1, 3, 0,
    cv.Size.init(30, 30), cv.Size.init(0, 0));
```
