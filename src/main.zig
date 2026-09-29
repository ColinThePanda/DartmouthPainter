const std = @import("std");

const rl = @import("raylib"); // Raylib for windowing and drawing
const rg = @import("raygui"); // Raylib GUI for ui
const cv = @import("zopencv"); // OpenCV for camera feed

/// Enum for what to display on screen
const DisplayMode = enum {
    Painting,
    Camera,
    Brush,
    Both,
};

// Calculate sum of difference of red green and blue
fn colorDiff(c1: rl.Color, c2: rl.Color) i32 {
    const dr = @as(i32, c1.r) - @as(i32, c2.r);
    const dg = @as(i32, c1.g) - @as(i32, c2.g);
    const db = @as(i32, c1.b) - @as(i32, c2.b);
    return @intCast(@abs(dr) + @abs(dg) + @abs(db));
}

/// Get pixel at x and y in u8 buffer
fn pixelAt(buf: [*]u8, stride: usize, x: usize, y: usize) rl.Color {
    const off = y * stride + x * 3;
    const px = rl.Color{
        .r = buf[off + 0],
        .g = buf[off + 1],
        .b = buf[off + 2],
        .a = 255,
    };
    return px;
}

/// Set pixel at x and y in u8 buffer
fn setPixel(buf: [*]u8, stride: usize, x: usize, y: usize, color: rl.Color) void {
    const off = y * stride + x * 3;
    buf[off + 0] = color.r;
    buf[off + 1] = color.g;
    buf[off + 2] = color.b;
}

/// Finds the largest floodfill region in an image buffer
fn getLargestRegion(buf: [*]u8, width: usize, height: usize, tol: usize, target_color: rl.Color, min_size: usize, allocator: std.mem.Allocator, region: *std.AutoHashMapUnmanaged(usize, void)) !void {
    const stride = width * 3;
    var visited: []bool = try allocator.alloc(bool, width * height);
    for (0..width * height) |i| {
        visited[i] = false;
    }
    var queue: std.ArrayList(usize) = .empty;
    var current: std.ArrayList(usize) = .empty;
    region.clearRetainingCapacity();

    defer current.deinit(allocator);
    defer queue.deinit(allocator);
    defer allocator.free(visited);

    for (0..height) |sy| {
        for (0..width) |sx| {
            const seed_off = sy * width + sx;
            if (visited[seed_off]) continue;
            const seed_px = pixelAt(buf, stride, sx, sy);
            if (colorDiff(seed_px, target_color) >= tol) continue;

            current.items.len = 0;
            try queue.append(allocator, seed_off);
            visited[seed_off] = true;

            while (queue.pop()) |p| {
                const px_x = p % width;
                const px_y = p / width;
                try current.append(allocator, p);

                const neighbors = [_][2]i32{ .{ -1, -1 }, .{ 0, -1 }, .{ 1, -1 }, .{ -1, 0 }, .{ 1, 0 }, .{ -1, 1 }, .{ 0, 1 }, .{ 1, 1 } };
                for (neighbors) |d| {
                    const nx = @as(i32, @intCast(px_x)) + d[0];
                    const ny = @as(i32, @intCast(px_y)) + d[1];
                    if (nx < 0 or ny < 0 or nx >= width or ny >= height) continue;
                    const noff = @as(usize, @intCast(ny)) * width + @as(usize, @intCast(nx));
                    if (visited[noff]) continue;
                    const npx = pixelAt(buf, stride, @intCast(nx), @intCast(ny));
                    const diff = colorDiff(npx, target_color);
                    if (diff < tol) {
                        visited[noff] = true;
                        try queue.append(allocator, noff);
                    }
                }
            }

            if (current.items.len >= min_size and current.items.len > region.count()) {
                region.clearRetainingCapacity();
                for (current.items) |item| {
                    try region.put(allocator, item, {});
                }
            }
        }
    }
}

pub fn main(init: std.process.Init) !void {
    var cap = try cv.videoio.VideoCapture.init(); // open camera
    defer cap.deinit(); // deinitialize camera at end of main

    if (!cap.openDevice(0) or !cap.isOpened()) {
        std.debug.print("No camera found\n", .{});
        return;
    }

    // set camera feed resolution to 720p (1080p is very slow)
    _ = cap.set(.frame_width, 1280);
    _ = cap.set(.frame_height, 720);

    const width: i32 = @intFromFloat(cap.get(.frame_width));
    const height: i32 = @intFromFloat(cap.get(.frame_height));
    std.debug.print("Camera opened: {d}x{d}\n", .{ width, height });

    var frame = try cv.Mat.init(); // BGR from the camera
    defer frame.deinit();
    var rgb = try cv.Mat.init(); // converted to RGB for raylib
    defer rgb.deinit();

    rl.initWindow(width, height, "Painter"); // Initialize raylib window with camera dimensions
    defer rl.closeWindow();
    rl.setTargetFPS(60); // Target 60fps

    // Grab one frame to build the texture at the right size and format
    if (!cap.read(&frame) or frame.empty()) {
        std.debug.print("Failed to read first frame\n", .{});
        return;
    }
    cv.imgproc.cvtColor(frame, &rgb, .bgr2rgb);

    const image = rl.Image{
        .data = rgb.data(), // rgb.data() gets image data as a u8 buffer
        .width = width,
        .height = height,
        .mipmaps = 1,
        .format = .uncompressed_r8g8b8,
    };

    const texture = try rl.loadTextureFromImage(image); // texture is a gpu image, image is cpu
    defer rl.unloadTexture(texture);

    const cursor_width = 50;
    const cursor_thickness = 5;

    var started: bool = false;
    var is_painting: bool = false;
    var save_requested: bool = false; // store this as a variable because we check keypresses before rendering, but we have to save the image after rendering
    var display_mode: DisplayMode = .Both;
    var target_color: rl.Color = rl.Color.black;
    var tol_f: f32 = 100; // float version of tolerance to be changed by slider
    var paint_color: rl.Color = rl.Color.green;
    const slider_rect = rl.Rectangle{ .x = 80, .y = 40, .width = 200, .height = 20 }; // tolerance slider
    const picker_area = rl.Rectangle{ .x = 10, .y = 80, .width = 150 + 30, .height = 150 }; // paint color picker
    var region: std.AutoHashMapUnmanaged(usize, void) = .empty; // Hashmap for paintbrush region (stores indices in u8 buffer)
    var painting: std.AutoHashMapUnmanaged(usize, void) = .empty; // Hashmap for painting region (stores indices in u8 buffer)
    defer region.deinit(init.gpa);
    defer painting.deinit(init.gpa);
    while (!rl.windowShouldClose()) { // while window not being closed (also checks if esc is pressed)
        if (!cap.read(&frame) or frame.empty()) break;
        cv.imgproc.cvtColor(frame, &rgb, .bgr2rgb);

        const output_image = rgb.data();

        const mouse_pos = rl.getMousePosition();
        const mousex: i32 = @intFromFloat(mouse_pos.x);
        const mousey: i32 = @intFromFloat(mouse_pos.y);

        const over_gui = rl.checkCollisionPointRec(mouse_pos, slider_rect) or rl.checkCollisionPointRec(mouse_pos, picker_area); // if clicking over gui, don't set target color
        if (rl.isMouseButtonPressed(.left) and !over_gui) {
            if (mousex >= 0 and mousex < width and mousey >= 0 and mousey < height) {
                const buf = rgb.data();
                const stride: usize = @as(usize, @intCast(width)) * 3;
                const off: usize = @as(usize, @intCast(mousey)) * stride + @as(usize, @intCast(mousex)) * 3;
                target_color = rl.Color{
                    .r = buf[off + 0],
                    .g = buf[off + 1],
                    .b = buf[off + 2],
                    .a = 255,
                };

                started = true;
            }
        }
        std.debug.print("Target color: {}, {}, {}\n", .{ target_color.r, target_color.g, target_color.b });

        if (rl.isKeyPressed(.space)) { // toggle painting on space
            is_painting = !is_painting;
        } else if (rl.isKeyPressed(.c)) { // clear on c
            painting.clearAndFree(init.gpa);
        } else if (rl.isKeyPressed(.one)) { // display painting and camera on 1
            display_mode = .Both;
        } else if (rl.isKeyPressed(.two)) { // display just camera on 2
            display_mode = .Camera;
        } else if (rl.isKeyPressed(.three)) { // display just painting on 3
            display_mode = .Painting;
        } else if (rl.isKeyPressed(.four)) { // display just camera and brush not painting on 4
            display_mode = .Brush;
        } else if ((rl.isKeyDown(.left_control) or rl.isKeyDown(.right_control)) and rl.isKeyPressed(.s)) { // save image on ctrl s
            save_requested = true;
        }

        const buf = rgb.data(); // u8 buffer
        const w: usize = @intCast(width);
        const h: usize = @intCast(height);
        const stride = w * 3; // 3 u8s per color
        if (display_mode == .Painting) {
            @memset(buf[0 .. h * stride], 255); // override camera with white background
        }

        region.clearAndFree(init.gpa);
        if (started) try getLargestRegion(buf, w, h, @intFromFloat(tol_f), target_color, 100, init.gpa, &region);
        std.debug.print("Size: {}\n", .{region.count()});

        if (display_mode == .Painting or display_mode == .Both or display_mode == .Brush) {
            if (is_painting) {
                var region_it = region.keyIterator();
                while (region_it.next()) |item| {
                    try painting.put(init.gpa, item.*, {});
                }
            } else {
                var region_it = region.keyIterator();
                if (started) {
                    while (region_it.next()) |item| {
                        setPixel(output_image, stride, @intCast(item.* % w), @intCast(@divTrunc(item.*, w)), paint_color);
                    }
                }
            }
            if (display_mode != .Brush) {
                var painting_it = painting.keyIterator();
                if (started) {
                    while (painting_it.next()) |item| {
                        setPixel(buf, stride, @intCast(item.* % w), @intCast(@divTrunc(item.*, w)), paint_color);
                    }
                }
            }
        }

        if (save_requested) {
            // construct image to export instead of exporting draw buffer so gui isn't visible
            const out = rl.Image{
                .data = output_image,
                .width = width,
                .height = height,
                .mipmaps = 1,
                .format = .uncompressed_r8g8b8,
            };
            _ = rl.exportImage(out, "painting.png");
            save_requested = false;
        }

        rl.updateTexture(texture, output_image); // send image to gpu

        rl.beginDrawing();
        rl.clearBackground(rl.Color.white);
        rl.drawTexture(texture, 0, 0, rl.Color.white); // draw texture

        rl.drawRectangle(mousex - @divTrunc(cursor_width, 2), mousey - @divTrunc(cursor_thickness, 2), cursor_width, cursor_thickness, rl.Color.black); // draw horizontal part of cursor
        rl.drawRectangle(mousex - @divTrunc(cursor_thickness, 2), mousey - @divTrunc(cursor_width, 2), cursor_thickness, cursor_width, rl.Color.black); // draw vertical part of cursor

        rl.drawFPS(10, 10); // draw fps number in top left

        _ = rg.slider(.{ .x = 80, .y = 40, .width = 200, .height = 20 }, "Tolerance", "", &tol_f, 0, 300); // draw slider
        _ = rg.colorPicker(.{ .x = 10, .y = 80, .width = 150, .height = 150 }, "", &paint_color); // draw color picker
        rl.endDrawing(); // present image
    }

    std.debug.print("Done\n", .{});
}
