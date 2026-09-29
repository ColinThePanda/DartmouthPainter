# Text Module (contrib)

Text detection and OCR.

## OCRTesseract

```zig
const OCRTesseract = struct {
    fn init(datapath: ?[*:0]const u8, language: ?[*:0]const u8,
            char_whitelist: ?[*:0]const u8, oem: i32, psmode: i32) !OCRTesseract;
    fn deinit(self: *OCRTesseract) void;
    fn run(self: OCRTesseract, image: Mat, allocator: Allocator) ![]u8;
    fn runWithConfidence(self: OCRTesseract, image: Mat, allocator: Allocator) !struct { text: []u8, confidence: i32 };
};
```

## Text Detection

```zig
fn detectTextSWT(image: Mat, dark_on_light: bool, result: *Mat) void;
```
