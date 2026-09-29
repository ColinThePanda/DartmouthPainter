# Tracking Module (contrib)

Object tracking algorithms.

## TrackerKCF

```zig
const TrackerKCF = struct {
    fn init() !TrackerKCF;
    fn deinit(self: *TrackerKCF) void;
    fn initTracker(self: TrackerKCF, image: Mat, boundingBox: Rect) void;
    fn update(self: TrackerKCF, image: Mat, boundingBox: *Rect) bool;
};
```

## Example

```zig
var tracker = try cv.contrib.tracking.TrackerKCF.init();
defer tracker.deinit();

tracker.initTracker(first_frame, initial_bbox);

while (cap.read(&frame)) {
    var bbox: cv.Rect = undefined;
    if (tracker.update(frame, &bbox)) {
        cv.imgproc.rectangle(&frame, bbox, green, 2, 8, 0);
    }
}
```
