# Photo Module

Computational photography: denoising, inpainting, HDR, tone mapping, and artistic effects.

## Denoising

```zig
fn fastNlMeansDenoising(src: Mat, dst: *Mat, h: f32, templateWindowSize: i32, searchWindowSize: i32) void;
fn fastNlMeansDenoisingColored(src: Mat, dst: *Mat, h: f32, hColor: f32,
    templateWindowSize: i32, searchWindowSize: i32) void;
fn fastNlMeansDenoisingMulti(src_imgs: []const Mat, dst: *Mat, imgToDenoiseIndex: i32,
    temporalWindowSize: i32, h: f32, templateWindowSize: i32, searchWindowSize: i32) void;
fn fastNlMeansDenoisingColoredMulti(src_imgs: []const Mat, dst: *Mat, imgToDenoiseIndex: i32,
    temporalWindowSize: i32, h: f32, hColor: f32, templateWindowSize: i32, searchWindowSize: i32) void;
```

## Inpainting

```zig
fn inpaint(src: Mat, inpaintMask: Mat, dst: *Mat, inpaintRadius: f64, flags: InpaintFlag) void;

const InpaintFlag = enum(i32) { navier_stokes, telea };
```

## HDR & Tone Mapping

```zig
const MergeMertens = struct {
    fn init() Self;
    fn initWithParams(contrast_weight: f32, saturation_weight: f32, exposure_weight: f32) Self;
    fn process(self: Self, src_imgs: []const Mat, dst: *Mat) void;
    fn deinit(self: Self) void;
};

const Tonemap = struct { fn init(gamma: f32) Self; fn process(self: Self, src: Mat, dst: *Mat) void; fn deinit(self: Self) void; };
const TonemapDrago = struct { fn init(gamma: f32, saturation: f32, bias: f32) Self; /* ... */ };
const TonemapReinhard = struct { fn init(gamma: f32, intensity: f32, lightAdapt: f32, colorAdapt: f32) Self; /* ... */ };
const TonemapMantiuk = struct { fn init(gamma: f32, scale: f32, saturation: f32) Self; /* ... */ };

const AlignMTB = struct { fn init(max_bits: i32, exclude_range: i32, cut: bool) Self; /* ... */ };
const CalibrateDebevec = struct { fn init(samples: i32, lambda: f32, random: bool) Self; /* ... */ };
const MergeDebevec = struct { fn init() Self; /* ... */ };
```

## Artistic Effects

```zig
fn detailEnhance(src: Mat, dst: *Mat, sigma_s: f32, sigma_r: f32) void;
fn edgePreservingFilter(src: Mat, dst: *Mat, flags: EdgePreservingFilterFlag, sigma_s: f32, sigma_r: f32) void;
fn pencilSketch(src: Mat, dst1: *Mat, dst2: *Mat, sigma_s: f32, sigma_r: f32, shade_factor: f32) void;
fn stylization(src: Mat, dst: *Mat, sigma_s: f32, sigma_r: f32) void;
fn seamlessClone(src: Mat, dst: Mat, mask: Mat, p: Point, blend: *Mat, flags: SeamlessCloningFlag) void;
fn colorChange(src: Mat, mask: Mat, dst: *Mat, red_mul: f32, green_mul: f32, blue_mul: f32) void;
fn illuminationChange(src: Mat, mask: Mat, dst: *Mat, alpha: f32, beta: f32) void;
fn textureFlattening(src: Mat, mask: Mat, dst: *Mat, low_threshold: f32, high_threshold: f32, kernel_size: i32) void;
fn decolorization(src: Mat, grayscale: *Mat, color_boost: *Mat) void;
```
