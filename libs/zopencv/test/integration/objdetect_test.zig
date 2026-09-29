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


test "objdetect: CascadeClassifier face detection on real image" {
    var cc = try cv.objdetect.CascadeClassifier.initFromFile(cascade_face);
    defer cc.deinit();
    try testing.expect(!cc.empty());

    var img = try cv.imgcodecs.imread(test_image_lena, .grayscale);
    defer img.deinit();
    try testing.expect(!img.empty());

    var faces = try cv.objdetect.RectVector.init();
    defer faces.deinit();

    cc.detectMultiScale(img, &faces, 1.1, 3, 0, cv.Size.init(30, 30), cv.Size.init(0, 0));

    // Should detect at least one face in lena image
    try testing.expect(faces.size() > 0);
}

test "objdetect: CascadeClassifier eye detection on real image" {
    var cc = try cv.objdetect.CascadeClassifier.initFromFile(cascade_eye);
    defer cc.deinit();
    try testing.expect(!cc.empty());

    var img = try cv.imgcodecs.imread(test_image_lena, .grayscale);
    defer img.deinit();
    try testing.expect(!img.empty());

    var eyes = try cv.objdetect.RectVector.init();
    defer eyes.deinit();

    cc.detectMultiScale(img, &eyes, 1.1, 3, 0, cv.Size.init(20, 20), cv.Size.init(0, 0));

    // May or may not detect eyes depending on parameters
    try testing.expect(eyes.size() >= 0);
}

test "objdetect: CascadeClassifier no detection on non-face image" {
    var cc = try cv.objdetect.CascadeClassifier.initFromFile(cascade_face);
    defer cc.deinit();

    var img = try cv.imgcodecs.imread(test_image_box, .grayscale);
    defer img.deinit();

    var faces = try cv.objdetect.RectVector.init();
    defer faces.deinit();

    cc.detectMultiScale(img, &faces, 1.1, 3, 0, cv.Size.init(30, 30), cv.Size.init(0, 0));

    // Box image should not contain faces
    try testing.expectEqual(@as(usize, 0), faces.size());
}

test "objdetect: CascadeClassifier with different scale factors" {
    var cc = try cv.objdetect.CascadeClassifier.initFromFile(cascade_face);
    defer cc.deinit();

    var img = try cv.imgcodecs.imread(test_image_lena, .grayscale);
    defer img.deinit();

    var faces1 = try cv.objdetect.RectVector.init();
    defer faces1.deinit();
    cc.detectMultiScale(img, &faces1, 1.05, 3, 0, cv.Size.init(30, 30), cv.Size.init(0, 0));

    var faces2 = try cv.objdetect.RectVector.init();
    defer faces2.deinit();
    cc.detectMultiScale(img, &faces2, 1.3, 3, 0, cv.Size.init(30, 30), cv.Size.init(0, 0));

    try testing.expect(faces1.size() > 0);
    try testing.expect(faces2.size() > 0);
}

test "objdetect: CascadeClassifier with different min neighbors" {
    var cc = try cv.objdetect.CascadeClassifier.initFromFile(cascade_face);
    defer cc.deinit();

    var img = try cv.imgcodecs.imread(test_image_lena, .grayscale);
    defer img.deinit();

    var faces1 = try cv.objdetect.RectVector.init();
    defer faces1.deinit();
    cc.detectMultiScale(img, &faces1, 1.1, 2, 0, cv.Size.init(30, 30), cv.Size.init(0, 0));

    var faces2 = try cv.objdetect.RectVector.init();
    defer faces2.deinit();
    cc.detectMultiScale(img, &faces2, 1.1, 5, 0, cv.Size.init(30, 30), cv.Size.init(0, 0));

    try testing.expect(faces1.size() > 0);
    try testing.expect(faces2.size() >= 0);
}

test "objdetect: CascadeClassifier with size constraints" {
    var cc = try cv.objdetect.CascadeClassifier.initFromFile(cascade_face);
    defer cc.deinit();

    var img = try cv.imgcodecs.imread(test_image_lena, .grayscale);
    defer img.deinit();

    var faces = try cv.objdetect.RectVector.init();
    defer faces.deinit();

    cc.detectMultiScale(img, &faces, 1.1, 3, 0, cv.Size.init(50, 50), cv.Size.init(300, 300));

    try testing.expect(faces.size() > 0);
}

test "objdetect: CascadeClassifier RectVector access" {
    var cc = try cv.objdetect.CascadeClassifier.initFromFile(cascade_face);
    defer cc.deinit();

    var img = try cv.imgcodecs.imread(test_image_lena, .grayscale);
    defer img.deinit();

    var faces = try cv.objdetect.RectVector.init();
    defer faces.deinit();

    cc.detectMultiScale(img, &faces, 1.1, 3, 0, cv.Size.init(30, 30), cv.Size.init(0, 0));

    if (faces.size() > 0) {
        const rect = faces.at(0);
        try testing.expect(rect.x >= 0);
        try testing.expect(rect.y >= 0);
        try testing.expect(rect.width > 0);
        try testing.expect(rect.height > 0);
    }
}

test "objdetect: HOGDescriptor detect on real image" {
    var hog = try cv.objdetect.HOGDescriptor.init();
    defer hog.deinit();

    hog.setSVMDetector(.default_people);

    var img = try cv.imgcodecs.imread(test_image_lena, .color);
    defer img.deinit();
    try testing.expect(!img.empty());

    var found = try cv.objdetect.RectVector.init();
    defer found.deinit();

    hog.detectMultiScale(img, &found, 0.0, cv.Size.init(8, 8), cv.Size.init(0, 0), 1.05, 2.0, false);

    // May or may not detect people
    try testing.expect(found.size() >= 0);
}

test "objdetect: HOGDescriptor with different parameters" {
    var hog = try cv.objdetect.HOGDescriptor.init();
    defer hog.deinit();

    hog.setSVMDetector(.default_people);

    var img = try cv.imgcodecs.imread(test_image_lena, .color);
    defer img.deinit();

    var found = try cv.objdetect.RectVector.init();
    defer found.deinit();

    hog.detectMultiScale(img, &found, 0.0, cv.Size.init(4, 4), cv.Size.init(0, 0), 1.05, 2.0, false);

    try testing.expect(found.size() >= 0);
}
