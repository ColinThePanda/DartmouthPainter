# DNN Module

Deep neural network inference module. Supports loading models from multiple frameworks.

## Types

### Net

```zig
const Net = struct {
    fn readNetFromDarknet(cfgFile: [*:0]const u8, darknetModel: ?[*:0]const u8) !Net;
    fn readNetFromCaffe(prototxt: [*:0]const u8, caffeModel: ?[*:0]const u8) !Net;
    fn readNetFromTensorflow(model: [*:0]const u8, config: ?[*:0]const u8) !Net;
    fn readNetFromONNX(onnxFile: [*:0]const u8) !Net;
    fn readNetFromTorch(model: [*:0]const u8, isBinary: bool) !Net;
    fn readNetFromTFLite(model: [*:0]const u8) !Net;
    fn init() !Net;
    fn deinit(self: *Net) void;
    fn empty(self: Net) bool;
    fn setInput(self: Net, blob: Mat, name: ?[*:0]const u8) void;
    fn forward(self: Net, outputName: ?[*:0]const u8) !Mat;
    fn setPreferableBackend(self: Net, backendId: i32) void;
    fn setPreferableTarget(self: Net, targetId: i32) void;
    fn getUnconnectedOutLayers(self: Net, allocator: Allocator) ![]i32;
    fn getUnconnectedOutLayersNames(self: Net, allocator: Allocator) ![][]u8;
    fn getLayerNames(self: Net, allocator: Allocator) ![][]u8;
    fn getPerfProfile(self: Net) f64;
    fn dump(self: Net, allocator: Allocator) ![]u8;
};
```

## Free Functions

```zig
fn blobFromImage(image: Mat, scalefactor: f64, size: Size, mean: Scalar,
                 swapRB: bool, crop: bool, ddepth: i32) !Mat;

fn nmsBoxes(bboxes: []Rect, scores: []f32, score_threshold: f32,
            nms_threshold: f32, allocator: Allocator) ![]i32;
```

## Supported Frameworks

| Framework    | Load Function           | File Extensions             |
| ------------ | ----------------------- | --------------------------- |
| Darknet/YOLO | `readNetFromDarknet`    | `.cfg` + `.weights`         |
| Caffe        | `readNetFromCaffe`      | `.prototxt` + `.caffemodel` |
| TensorFlow   | `readNetFromTensorflow` | `.pb` + `.pbtxt`            |
| ONNX         | `readNetFromONNX`       | `.onnx`                     |
| Torch        | `readNetFromTorch`      | `.t7`, `.net`               |
| TFLite       | `readNetFromTFLite`     | `.tflite`                   |

## Error Handling

All `readNetFrom*` functions return `error.NullPointer` if the model file cannot be loaded (file not found, invalid format, etc.). This is safely handled via try/catch in the C API layer.

## Example

```zig
const cv = @import("zopencv");

// Load ONNX model
var net = try cv.dnn.Net.readNetFromONNX("model.onnx");
defer net.deinit();

// Prepare input
var blob = try cv.dnn.blobFromImage(img, 1.0/255.0,
    cv.Size.init(416, 416), cv.Scalar.init(0,0,0,0), true, false, 5);
defer blob.deinit();

net.setInput(blob, null);
var output = try net.forward(null);
defer output.deinit();
```
