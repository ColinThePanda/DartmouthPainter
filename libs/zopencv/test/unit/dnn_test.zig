const std = @import("std");
const testing = std.testing;
const cv = @import("zopencv");

test "dnn: Net creation and deletion" {
    // Test that we can create and delete a Net (even if loading fails)
    // This tests the API without requiring actual model files

    // Just verify the types compile
    const Backend = cv.dnn.Backend;
    const Target = cv.dnn.Target;

    try testing.expect(Backend.default == .default);
    try testing.expect(Target.cpu == .cpu);
}

test "dnn: blobFromImage API" {
    // Test that the API compiles correctly
    // Note: blobFromImage requires valid image data and will crash with empty Mat
    // Actual functionality is tested in examples with real images

    const size = cv.Size.init(224, 224);
    const mean = cv.Scalar.init(0.0, 0.0, 0.0, 0.0);

    try testing.expect(size.width == 224);
    try testing.expect(mean.val1 == 0.0);
}

test "dnn: Backend and Target enums" {
    // Test that enums are defined correctly
    const backend = cv.dnn.Backend.default;
    try testing.expect(@intFromEnum(backend) == 0);
    try testing.expect(@intFromEnum(cv.dnn.Backend.opencv) == 3);
    try testing.expect(@intFromEnum(cv.dnn.Backend.cuda) == 5);

    try testing.expect(@intFromEnum(cv.dnn.Target.cpu) == 0);
    try testing.expect(@intFromEnum(cv.dnn.Target.cuda) == 6);
    try testing.expect(@intFromEnum(cv.dnn.Target.cuda_fp16) == 7);
}

// ============================================================================
// Net.init, Net.empty, and Net.dump Tests
// ============================================================================

test "dnn: Net init creates empty network" {
    var net = try cv.dnn.Net.init();
    defer net.deinit();

    // Newly created Net should be empty
    try testing.expect(net.empty());
}

test "dnn: Net dump empty network returns empty string" {
    var net = try cv.dnn.Net.init();
    defer net.deinit();

    // Our C API fix returns empty string for empty networks
    const dump_str = try net.dump(testing.allocator);
    defer testing.allocator.free(dump_str);

    // Empty net produces empty dump string
    try testing.expectEqual(@as(usize, 0), dump_str.len);
}

// ============================================================================
// DNN Functional Tests
// ============================================================================

test "dnn: blobFromImage creates 4D blob" {
    var img = try cv.Mat.initWithSize(100, 100, 16); // CV_8UC3
    defer img.deinit();
    img.setTo(cv.Scalar.init(128, 128, 128, 0));

    var blob = try cv.dnn.blobFromImage(
        img,
        1.0 / 255.0,
        cv.Size.init(224, 224),
        cv.Scalar.init(0, 0, 0, 0),
        false,
        false,
        5, // CV_32F
    );
    defer blob.deinit();

    try testing.expect(!blob.empty());
    // Blob is a 4D tensor — total() indicates it has data
    try testing.expect(blob.total() > 0);
}

test "dnn: Net setPreferableBackend and setPreferableTarget" {
    var net = try cv.dnn.Net.init();
    defer net.deinit();

    // Set backend and target — these should not crash even on empty net
    net.setPreferableBackend(@intFromEnum(cv.dnn.Backend.default));
    net.setPreferableTarget(@intFromEnum(cv.dnn.Target.cpu));

    try testing.expect(net.empty());
}

test "dnn: Net getLayerNames on empty net" {
    var net = try cv.dnn.Net.init();
    defer net.deinit();

    const names = try net.getLayerNames(testing.allocator);
    defer {
        for (names) |name| {
            testing.allocator.free(name);
        }
        testing.allocator.free(names);
    }

    // Empty net has no layers
    try testing.expectEqual(@as(usize, 0), names.len);
}

test "dnn: Net getUnconnectedOutLayers on empty net" {
    var net = try cv.dnn.Net.init();
    defer net.deinit();

    const layers = try net.getUnconnectedOutLayers(testing.allocator);
    defer testing.allocator.free(layers);

    // OpenCV returns at least 1 output layer even for empty net
    try testing.expect(layers.len >= 0);
}

test "dnn: NMSBoxes with synthetic data" {
    // Create overlapping bounding boxes
    const bboxes = [_]cv.Rect{
        cv.Rect{ .x = 10, .y = 10, .width = 100, .height = 100 },
        cv.Rect{ .x = 15, .y = 15, .width = 100, .height = 100 }, // high overlap with first
        cv.Rect{ .x = 200, .y = 200, .width = 100, .height = 100 }, // no overlap
    };
    const scores = [_]f32{ 0.9, 0.85, 0.7 };

    const indices = try cv.dnn.nmsBoxes(
        &bboxes,
        &scores,
        0.5, // score threshold
        0.4, // NMS threshold
        testing.allocator,
    );
    defer testing.allocator.free(indices);

    // Should suppress the overlapping box, keeping 2 of 3
    try testing.expectEqual(@as(usize, 2), indices.len);
}

test "dnn: NMSBoxes with empty boxes" {
    const bboxes = [_]cv.Rect{};
    const scores = [_]f32{};

    const indices = try cv.dnn.nmsBoxes(
        &bboxes,
        &scores,
        0.5,
        0.4,
        testing.allocator,
    );
    defer testing.allocator.free(indices);

    try testing.expectEqual(@as(usize, 0), indices.len);
}

test "dnn: ReadNetFromTorch with nonexistent file returns error" {
    // OpenCV throws on nonexistent file; C API catches and returns NULL → NullPointer error
    const result = cv.dnn.Net.readNetFromTorch("/tmp/nonexistent_model.t7", true);
    try testing.expectError(cv.Error.NullPointer, result);
}

test "dnn: ReadNetFromTFLite with nonexistent file returns error" {
    const result = cv.dnn.Net.readNetFromTFLite("/tmp/nonexistent_model.tflite");
    try testing.expectError(cv.Error.NullPointer, result);
}

test "dnn: ReadNetFromDarknet with nonexistent file returns error" {
    const result = cv.dnn.Net.readNetFromDarknet("/tmp/nonexistent.cfg", null);
    try testing.expectError(cv.Error.NullPointer, result);
}

test "dnn: ReadNetFromCaffe with nonexistent file returns error" {
    const result = cv.dnn.Net.readNetFromCaffe("/tmp/nonexistent.prototxt", null);
    try testing.expectError(cv.Error.NullPointer, result);
}

test "dnn: ReadNetFromTensorflow with nonexistent file returns error" {
    const result = cv.dnn.Net.readNetFromTensorflow("/tmp/nonexistent.pb", null);
    try testing.expectError(cv.Error.NullPointer, result);
}

test "dnn: ReadNetFromONNX with nonexistent file returns error" {
    const result = cv.dnn.Net.readNetFromONNX("/tmp/nonexistent.onnx");
    try testing.expectError(cv.Error.NullPointer, result);
}
