const std = @import("std");
const testing = std.testing;
const cv = @import("zopencv");

test "text: OCRTesseract creation" {
    // Note: This test may fail if Tesseract is not installed
    // We'll just test creation without running OCR
    var ocr = cv.contrib.text.OCRTesseract.create() catch |err| {
        // If Tesseract is not available, skip this test
        if (err == error.NullPointer) {
            return error.SkipZigTest;
        }
        return err;
    };
    defer ocr.deinit();
    // Successfully created
}

test "text: OCRTesseract creation with params" {
    // Test with custom parameters
    var ocr = cv.contrib.text.OCRTesseract.createWithParams(null, "eng", null, 3, 3) catch |err| {
        if (err == error.NullPointer) {
            return error.SkipZigTest;
        }
        return err;
    };
    defer ocr.deinit();
    // Successfully created
}

test "text: OCRTesseract run on blank image" {
    var ocr = cv.contrib.text.OCRTesseract.create() catch |err| {
        if (err == error.NullPointer) {
            return error.SkipZigTest;
        }
        return err;
    };
    defer ocr.deinit();

    // Create a blank grayscale image
    var img = try cv.Mat.initWithSize(100, 200, 0); // CV_8UC1
    defer img.deinit();

    // Run OCR on blank image — should return empty or whitespace text
    const text = try ocr.run(img, testing.allocator);
    defer testing.allocator.free(text);
    // Text result may be empty or whitespace for a blank image
}
