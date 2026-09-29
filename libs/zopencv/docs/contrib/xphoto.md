# xphoto Module (contrib)

Extended photography: white balance, denoising, and artistic effects.

## White Balance

```zig
const WhiteBalancer = struct {
    fn createSimple() !WhiteBalancer;
    fn createGrayWorld() !WhiteBalancer;
    fn createLearningBased() !WhiteBalancer;
    fn deinit(self: *WhiteBalancer) void;
    fn balanceWhite(self: WhiteBalancer, src: Mat, dst: *Mat) void;
};
```

## Denoising

```zig
fn bm3dDenoising(src: Mat, dst: *Mat, h: f32) void;
fn dctDenoising(src: Mat, dst: *Mat, sigma: f64, psize: i32) void;
```

## Inpainting & Effects

```zig
fn inpaintFMM(src: Mat, mask: Mat, dst: *Mat, radius: i32) void;
fn oilPainting(src: Mat, dst: *Mat, size: i32, dynRatio: i32) void;
fn applyChannelGains(src: Mat, dst: *Mat, gainB: f32, gainG: f32, gainR: f32) void;
```

## Example

```zig
// Auto white balance
var wb = try cv.contrib.xphoto.WhiteBalancer.createGrayWorld();
defer wb.deinit();
var corrected = try cv.Mat.init();
defer corrected.deinit();
wb.balanceWhite(img, &corrected);

// Oil painting effect
var painting = try cv.Mat.init();
defer painting.deinit();
cv.contrib.xphoto.oilPainting(img, &painting, 7, 1);
```
