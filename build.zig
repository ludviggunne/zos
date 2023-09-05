const std = @import("std");

pub fn build(b: *std.Build) void {

    const target = std.zig.CrossTarget {
        .cpu_arch = .aarch64,
        .os_tag = .freestanding,
        .abi = .eabi,
    };
    
    const elf = b.addExecutable(.{
        .name = "kernel8.elf",
        .root_source_file = std.build.FileSource { .path = "src/main.zig", },
        .target = target,
        .optimize = .ReleaseFast,
    });

    elf.setLinkerScriptPath(std.build.FileSource {
        .path = "linker.ld",
    });
    
    const install_elf = b.addInstallArtifact(elf, .{});
    
    const img = elf.addObjCopy(.{
        .basename = "kernel8.img",
        .format = .bin,
    });
    img.step.dependOn(&install_elf.step);

    const install_img = b.addInstallBinFile(img.getOutputSource(), img.basename);
    b.getInstallStep().dependOn(&install_img.step);

    // Tools
    const readelf = b.addSystemCommand(&[_][]const u8 {
        "aarch64-linux-gnu-readelf",
        b.getInstallPath(.{ .custom = "bin", }, elf.out_filename),
        "-a",
    });
    readelf.step.dependOn(&install_elf.step);
    b.step("readelf", "Display ELF content").dependOn(&readelf.step);

    const objdump = b.addSystemCommand(&[_][]const u8 {
        "aarch64-linux-gnu-objdump",
        b.getInstallPath(.{ .custom = "bin", }, elf.out_filename),
        "-td",
    });
    objdump.step.dependOn(&install_elf.step);
    b.step("objdump", "").dependOn(&objdump.step);
}
