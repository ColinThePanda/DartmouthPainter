const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const enable_contrib = b.option(bool, "contrib", "Enable opencv_contrib modules (default: false)") orelse false;

    const config = b.addOptions();
    config.addOption(bool, "enable_contrib", enable_contrib);

    const c_wrapper = buildCWrapper(b, target, optimize, enable_contrib);

    const zopencv_mod = b.addModule("zopencv", .{
        .root_source_file = b.path("src/main.zig"),
    });
    zopencv_mod.addOptions("config", config);
    zopencv_mod.addIncludePath(b.path("c_api"));
    zopencv_mod.linkLibrary(c_wrapper);
}

fn buildCWrapper(b: *std.Build, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, enable_contrib: bool) *std.Build.Step.Compile {
    _ = enable_contrib;

    const lib = b.addLibrary(.{
        .name = "opencv_wrapper",
        .linkage = .static,
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
        }),
    });

    // Prebuilt with MSYS2 g++ (libstdc++ ABI) — see the g++ loop.
    const objects = [_][]const u8{
        "build/core.o",      "build/imgproc.o", "build/imgcodecs.o",
        "build/videoio.o",   "build/highgui.o", "build/features2d.o",
        "build/objdetect.o", "build/photo.o",   "build/video.o",
        "build/calib3d.o",   "build/dnn.o",     "build/ml.o",
        "build/stitching.o", "build/flann.o",
    };
    for (objects) |obj| {
        lib.root_module.addObjectFile(b.path(obj));
    }

    lib.root_module.addIncludePath(b.path("c_api"));
    // NO link_libcpp — objects already carry libstdc++ symbols.
    linkOpenCV(lib.root_module);

    return lib;
}

pub fn linkOpenCV(module: *std.Build.Module) void {
    module.linkSystemLibrary("opencv4", .{});

    const target_os = module.resolved_target.?.result.os.tag;
    switch (target_os) {
        .linux => {
            module.linkSystemLibrary("stdc++", .{});
            module.linkSystemLibrary("m", .{});
            module.linkSystemLibrary("pthread", .{});
        },
        .macos => {
            module.linkSystemLibrary("c++", .{});
            module.linkFramework("Accelerate", .{});
        },
        .windows => {},
        else => {},
    }
}
