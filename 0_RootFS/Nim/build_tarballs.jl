using BinaryBuilder

include("../common.jl")

name = "Nim"
version = v"1.4.4"

sources = [
    "https://nim-lang.org/download/nim-1.4.4-linux_x64.tar.xz" =>
    "0e31f1f8b549edb83aac7eb6cdf40ccd154d341645d37e12dff35f346d354af7"
]

# Bash recipe for building across all platforms
script = raw"""
mv ${WORKSPACE}/srcdir/nim ${prefix}/
"""

# We only build for Linux x86_64
platforms = [
    # TODO: Switch to musl once https://github.com/rust-lang/rustup.rs/pull/1882 is released
    Platform("x86_64", "linux"; libc="musl"),
]

# Dependencies that must be installed before this package can be built
dependencies = []

# The products that we will ensure are always built
products = [
    ExecutableProduct("nim", :nim, "nim/bin"),
]

# Build the tarballs, and possibly a `build.jl` as well.
build_info = build_tarballs(ARGS, "$(name)", version, sources, script, platforms, products, dependencies; skip_audit=true)

upload_and_insert_shards("JuliaPackaging/Yggdrasil", name, version, build_info)
