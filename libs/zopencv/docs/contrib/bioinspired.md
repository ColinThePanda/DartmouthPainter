# bioinspired Module (contrib)

Bio-inspired retina model for image processing.

## Retina

Simulates the human retina to produce two output channels:
- **Parvo** (parvocellular): fine details, color information
- **Magno** (magnocellular): motion detection, temporal contrast

```zig
const Retina = struct {
    fn create(width: i32, height: i32, colorMode: bool) !Retina;
    fn deinit(self: *Retina) void;
    fn run(self: Retina, input: Mat) void;
    fn getParvo(self: Retina, output: *Mat) void;
    fn getMagno(self: Retina, output: *Mat) void;
    fn clearBuffers(self: Retina) void;
};
```

## Example

```zig
var retina = try cv.contrib.bioinspired.Retina.create(640, 480, true);
defer retina.deinit();
retina.run(frame);
var parvo = try cv.Mat.init();
defer parvo.deinit();
retina.getParvo(&parvo); // Enhanced details
var magno = try cv.Mat.init();
defer magno.deinit();
retina.getMagno(&magno); // Motion map
```
