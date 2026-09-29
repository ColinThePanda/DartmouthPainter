const std = @import("std");
const testing = std.testing;
const cv = @import("zopencv");

test "ml: SVM creation" {
    var svm = try cv.ml.SVM.init();
    defer svm.deinit();
    // Successfully created
}

test "ml: SVM set parameters" {
    var svm = try cv.ml.SVM.init();
    defer svm.deinit();

    svm.setType(cv.ml.SVMType.c_svc);
    svm.setKernel(cv.ml.SVMKernel.rbf);
    svm.setC(1.0);
    svm.setGamma(0.5);

    try testing.expectEqual(cv.ml.SVMType.c_svc, svm.getType());
    try testing.expectEqual(cv.ml.SVMKernel.rbf, svm.getKernel());
}

test "ml: KNearest creation" {
    var knn = try cv.ml.KNearest.init();
    defer knn.deinit();
    // Successfully created
}

test "ml: KNearest set parameters" {
    var knn = try cv.ml.KNearest.init();
    defer knn.deinit();

    knn.setDefaultK(5);
    try testing.expectEqual(@as(i32, 5), knn.getDefaultK());

    knn.setAlgorithmType(cv.ml.KNearestAlgorithm.brute_force);
    // Successfully set algorithm
}

test "ml: SVMType enum" {
    const c_svc = cv.ml.SVMType.c_svc;
    const nu_svc = cv.ml.SVMType.nu_svc;
    const eps_svr = cv.ml.SVMType.eps_svr;

    try testing.expectEqual(@as(i32, 100), @intFromEnum(c_svc));
    try testing.expectEqual(@as(i32, 101), @intFromEnum(nu_svc));
    try testing.expectEqual(@as(i32, 103), @intFromEnum(eps_svr));
}

test "ml: SVMKernel enum" {
    const linear = cv.ml.SVMKernel.linear;
    const rbf = cv.ml.SVMKernel.rbf;
    const poly = cv.ml.SVMKernel.poly;

    try testing.expectEqual(@as(i32, 0), @intFromEnum(linear));
    try testing.expectEqual(@as(i32, 2), @intFromEnum(rbf));
    try testing.expectEqual(@as(i32, 1), @intFromEnum(poly));
}

// ============================================================================
// SVM Train/Predict Tests
// ============================================================================

test "ml: SVM train and predict" {
    var svm = try cv.ml.SVM.init();
    defer svm.deinit();

    svm.setType(cv.ml.SVMType.c_svc);
    svm.setKernel(cv.ml.SVMKernel.linear);
    svm.setC(1.0);

    // Create training data: 4 samples, 2 features each
    // Class 0: (1,1), (2,2)  — Class 1: (10,10), (11,11)
    var train_data = try cv.Mat.initWithSize(4, 2, 5); // CV_32FC1
    defer train_data.deinit();
    train_data.setFloat(0, 0, 1.0);
    train_data.setFloat(0, 1, 1.0);
    train_data.setFloat(1, 0, 2.0);
    train_data.setFloat(1, 1, 2.0);
    train_data.setFloat(2, 0, 10.0);
    train_data.setFloat(2, 1, 10.0);
    train_data.setFloat(3, 0, 11.0);
    train_data.setFloat(3, 1, 11.0);

    // Labels: 0, 0, 1, 1
    var labels = try cv.Mat.initWithSize(4, 1, 4); // CV_32SC1
    defer labels.deinit();
    labels.setInt(0, 0, 0);
    labels.setInt(1, 0, 0);
    labels.setInt(2, 0, 1);
    labels.setInt(3, 0, 1);

    // ROW_SAMPLE = 0
    svm.train(train_data, 0, labels);

    // Predict a sample close to class 0
    var test_sample = try cv.Mat.initWithSize(1, 2, 5); // CV_32FC1
    defer test_sample.deinit();
    test_sample.setFloat(0, 0, 1.5);
    test_sample.setFloat(0, 1, 1.5);

    const prediction = svm.predict(test_sample, null, 0);
    // Should predict class 0
    try testing.expectApproxEqAbs(@as(f32, 0.0), prediction, 0.1);
}

// ============================================================================
// KNearest Train/Predict Tests
// ============================================================================

test "ml: KNearest train and predict" {
    var knn = try cv.ml.KNearest.init();
    defer knn.deinit();

    knn.setDefaultK(3);

    // Create training data: 6 samples, 2 features
    // Class 0: (1,1), (2,1), (1,2) — Class 1: (8,8), (9,8), (8,9)
    var train_data = try cv.Mat.initWithSize(6, 2, 5); // CV_32FC1
    defer train_data.deinit();
    train_data.setFloat(0, 0, 1.0);
    train_data.setFloat(0, 1, 1.0);
    train_data.setFloat(1, 0, 2.0);
    train_data.setFloat(1, 1, 1.0);
    train_data.setFloat(2, 0, 1.0);
    train_data.setFloat(2, 1, 2.0);
    train_data.setFloat(3, 0, 8.0);
    train_data.setFloat(3, 1, 8.0);
    train_data.setFloat(4, 0, 9.0);
    train_data.setFloat(4, 1, 8.0);
    train_data.setFloat(5, 0, 8.0);
    train_data.setFloat(5, 1, 9.0);

    var labels = try cv.Mat.initWithSize(6, 1, 4); // CV_32SC1
    defer labels.deinit();
    labels.setInt(0, 0, 0);
    labels.setInt(1, 0, 0);
    labels.setInt(2, 0, 0);
    labels.setInt(3, 0, 1);
    labels.setInt(4, 0, 1);
    labels.setInt(5, 0, 1);

    knn.train(train_data, 0, labels);

    // Predict a sample near class 1
    var test_sample = try cv.Mat.initWithSize(1, 2, 5);
    defer test_sample.deinit();
    test_sample.setFloat(0, 0, 8.5);
    test_sample.setFloat(0, 1, 8.5);

    var results = try cv.Mat.init();
    defer results.deinit();

    const prediction = knn.predict(test_sample, &results, null, null);
    // Should predict class 1
    try testing.expectApproxEqAbs(@as(f32, 1.0), prediction, 0.1);
}
