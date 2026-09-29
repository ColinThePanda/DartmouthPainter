const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const raylib_dep = b.dependency("raylib_zig", .{
        .target = target,
        .optimize = optimize,
    });

    const raylib = raylib_dep.module("raylib");
    const raylib_artifact = raylib_dep.artifact("raylib");

    const exe = b.addExecutable(.{
        .name = "Painter",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    exe.root_module.addImport("raylib", raylib);
    exe.root_module.linkLibrary(raylib_artifact);

    const raygui = raylib_dep.module("raygui");
    exe.root_module.addImport("raygui", raygui);

    const zopencv = b.dependency("zopencv", .{
        .target = target,
        .optimize = optimize,
        .contrib = false,
    });
    exe.root_module.addImport("zopencv", zopencv.module("zopencv"));

    if (target.result.os.tag == .windows) {
        const libdir = std.mem.trim(u8, b.run(&.{
            "pkg-config", "--variable=libdir", "opencv4",
        }), " \t\r\n");
        const libgcc = std.mem.trim(u8, b.run(&.{
            "g++", "-print-libgcc-file-name",
        }), " \t\r\n");
        const gcc_dir = std.fs.path.dirname(libgcc) orelse ".";
        exe.root_module.addObjectFile(.{ .cwd_relative = b.pathJoin(&.{ libdir, "libstdc++.a" }) });
        exe.root_module.addObjectFile(.{ .cwd_relative = libgcc });
        exe.root_module.addObjectFile(.{ .cwd_relative = b.pathJoin(&.{ gcc_dir, "libgcc_eh.a" }) });
    }

    b.installArtifact(exe);

    const run_step = b.step("run", "Run the app");
    const run_cmd = b.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
}
