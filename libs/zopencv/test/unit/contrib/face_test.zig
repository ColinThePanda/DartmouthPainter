const testing = @import("std").testing;
const cv = @import("zopencv");

test "face: FaceRecognizer Eigenfaces creation" {
    var recognizer = try cv.contrib.face.FaceRecognizer.createEigenfaces(0, 1.7976931348623157e+308);
    defer recognizer.deinit();
}

test "face: FaceRecognizer Fisherfaces creation" {
    var recognizer = try cv.contrib.face.FaceRecognizer.createFisherfaces(0, 1.7976931348623157e+308);
    defer recognizer.deinit();
}

test "face: FaceRecognizer LBPH creation" {
    var recognizer = try cv.contrib.face.FaceRecognizer.createLBPH(1, 8, 8, 8, 100.0);
    defer recognizer.deinit();
}

test "face: Mats vector creation and append" {
    var mats = try cv.contrib.face.Mats.init();
    defer mats.deinit();

    try testing.expectEqual(@as(usize, 0), mats.size());

    // Create a synthetic image and append it
    var img = try cv.Mat.initWithSize(50, 50, 0); // 50x50 grayscale
    defer img.deinit();

    mats.append(img);
    try testing.expectEqual(@as(usize, 1), mats.size());
}

test "face: LBPH train and predict with Mats" {
    var recognizer = try cv.contrib.face.FaceRecognizer.createLBPH(1, 8, 8, 8, 1000.0);
    defer recognizer.deinit();

    // Create synthetic training images as proper 2D Mats
    var img1 = try cv.Mat.initWithSize(50, 50, 0); // 50x50 grayscale
    defer img1.deinit();
    var img2 = try cv.Mat.initWithSize(50, 50, 0);
    defer img2.deinit();

    // Build Mats vector
    var images = try cv.contrib.face.Mats.init();
    defer images.deinit();
    images.append(img1);
    images.append(img2);

    // Labels: [0, 1] as a 2x1 CV_32SC1 Mat
    var labels = try cv.Mat.initWithSize(2, 1, 4); // CV_32SC1 = 4
    defer labels.deinit();

    // Train
    recognizer.train(images, labels);

    // Predict on a test image
    var test_img = try cv.Mat.initWithSize(50, 50, 0);
    defer test_img.deinit();

    const result = recognizer.predict(test_img);
    // Just verify predict returns without crashing
    _ = result.label;
    _ = result.confidence;
}

test "face: LBPH save and load with Mats" {
    var recognizer = try cv.contrib.face.FaceRecognizer.createLBPH(1, 8, 8, 8, 1000.0);
    defer recognizer.deinit();

    var img1 = try cv.Mat.initWithSize(50, 50, 0);
    defer img1.deinit();
    var img2 = try cv.Mat.initWithSize(50, 50, 0);
    defer img2.deinit();

    var images = try cv.contrib.face.Mats.init();
    defer images.deinit();
    images.append(img1);
    images.append(img2);

    var labels = try cv.Mat.initWithSize(2, 1, 4);
    defer labels.deinit();

    recognizer.train(images, labels);

    // Save model
    recognizer.save("/tmp/face_model_test.yml");

    // Create a new recognizer and load
    var recognizer2 = try cv.contrib.face.FaceRecognizer.createLBPH(1, 8, 8, 8, 1000.0);
    defer recognizer2.deinit();
    recognizer2.load("/tmp/face_model_test.yml");

    // Predict with loaded model
    var test_img = try cv.Mat.initWithSize(50, 50, 0);
    defer test_img.deinit();
    const result = recognizer2.predict(test_img);
    _ = result.label;
    _ = result.confidence;
}
