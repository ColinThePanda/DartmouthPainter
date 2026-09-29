const std = @import("std");
const testing = std.testing;
const cv = @import("zopencv");

// Test data paths
const cascade_face = "testdata/models/haarcascades/haarcascade_frontalface_default.xml";
const cascade_eye = "testdata/models/haarcascades/haarcascade_eye.xml";
const test_image_lena = "testdata/images/lena_face.jpg";
const test_image_box = "testdata/images/box.png";

// ============================================================================
// CascadeClassifier Tests (10 tests)
// ============================================================================


test "objdetect: CascadeClassifier creation" {
    var cc = try cv.objdetect.CascadeClassifier.init();
    defer cc.deinit();
    try testing.expect(cc.empty());
}

test "objdetect: CascadeClassifier load from file" {
    var cc = try cv.objdetect.CascadeClassifier.initFromFile(cascade_face);
    defer cc.deinit();
    try testing.expect(!cc.empty());
}

test "objdetect: CascadeClassifier load" {
    var cc = try cv.objdetect.CascadeClassifier.init();
    defer cc.deinit();

    const loaded = try cc.load(cascade_face);
    try testing.expect(loaded);
    try testing.expect(!cc.empty());
}

test "objdetect: HOGDescriptor creation" {
    var hog = try cv.objdetect.HOGDescriptor.init();
    defer hog.deinit();
}

test "objdetect: HOGDescriptor set default people detector" {
    var hog = try cv.objdetect.HOGDescriptor.init();
    defer hog.deinit();

    hog.setSVMDetector(.default_people);
}

test "objdetect: RectVector creation" {
    var rv = try cv.objdetect.RectVector.init();
    defer rv.deinit();
    try testing.expectEqual(@as(usize, 0), rv.size());
}

test "objdetect: RectVector size" {
    var rv = try cv.objdetect.RectVector.init();
    defer rv.deinit();
    try testing.expect(rv.size() == 0);
}

test "objdetect: QRCodeDetector create and delete" {
    var qr = try cv.QRCodeDetector.init();
    defer qr.deinit();
}

test "objdetect: QRCodeDetector detect on blank image" {
    var qr = try cv.QRCodeDetector.init();
    defer qr.deinit();

    var img = try cv.Mat.initWithSize(200, 200, 0); // CV_8UC1
    defer img.deinit();
    img.setTo(cv.Scalar.init(255, 0, 0, 0));

    var points = try cv.PointVector.init();
    defer points.deinit();

    const found = qr.detect(img, &points);
    // Blank image should not find QR code
    try testing.expect(!found);
}

test "objdetect: QRCodeDetector detectAndDecode on blank image" {
    var qr = try cv.QRCodeDetector.init();
    defer qr.deinit();

    var img = try cv.Mat.initWithSize(200, 200, 16); // CV_8UC3
    defer img.deinit();
    img.setTo(cv.Scalar.init(255, 255, 255, 0));

    var points = try cv.PointVector.init();
    defer points.deinit();

    var straight = try cv.Mat.init();
    defer straight.deinit();

    const result = qr.detectAndDecode(img, &points, &straight);
    // No QR code in blank image
    try testing.expect(result == null);
}

// ============================================================================
// QRCodeDetector Decode Tests
// ============================================================================

test "objdetect: QRCodeDetector decode with empty image" {
    var qr = try cv.QRCodeDetector.init();
    defer qr.deinit();

    var img = try cv.Mat.initWithSize(100, 100, 0); // CV_8UC1 - blank
    defer img.deinit();

    var points = try cv.PointVector.init();
    defer points.deinit();

    var straight = try cv.Mat.init();
    defer straight.deinit();

    // Decode on blank image should return null
    const result = qr.decode(img, &points, &straight);
    try testing.expect(result == null);
}
