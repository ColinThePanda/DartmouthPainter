# Image Codecs Module

Image file reading, writing, encoding, and decoding.

## Functions

```zig
fn imread(filename: []const u8, flags: ImreadMode) !Mat;
fn imwrite(filename: []const u8, img: Mat) !void;
fn imwriteWithParams(filename: []const u8, img: Mat, params: []const i32) !void;
fn imencode(ext: []const u8, img: Mat, params: ?[]const i32) ![]u8;
fn imdecode(buf: []const u8, flags: ImreadMode) !Mat;
fn imreadMulti(filename: []const u8, flags: ImreadMode, allocator: Allocator) ![]Mat;
fn haveImageReader(filename: []const u8) !bool;
fn haveImageWriter(filename: []const u8) !bool;
fn imcount(filename: []const u8, flags: ImreadMode) !i32;
```

## Enums

```zig
const ImreadMode = enum(i32) {
    unchanged = -1, grayscale = 0, color = 1, anydepth = 2, anycolor = 4,
    load_gdal = 8, reduced_grayscale_2 = 16, reduced_color_2 = 17,
    reduced_grayscale_4 = 32, reduced_color_4 = 33,
    reduced_grayscale_8 = 64, reduced_color_8 = 65,
    ignore_orientation = 128,
};

const ImwriteFlags = struct {
    const jpeg_quality: i32 = 1;
    const png_compression: i32 = 16;
    const webp_quality: i32 = 64;
    // ... more
};
```

## Example

```zig
var img = try cv.imgcodecs.imread("photo.jpg", .color);
defer img.deinit();
try cv.imgcodecs.imwrite("output.png", img);
```
