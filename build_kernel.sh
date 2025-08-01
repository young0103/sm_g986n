#!/usr/bin/env bash
# Samsung SM‑G986N custom kernel – Neutron 18 local build

set -e
export ARCH=arm64

# ---------- Toolchain ----------
TC_CLANG="$PWD/toolchain/neutron-clang-18.0.2/bin/clang"
TC_GCC="$PWD/toolchain/gcc-linaro-13.2.0-2023.10-x86_64_aarch64-linux-gnu/bin"

export CC="$TC_CLANG"
export LLVM=1
export CROSS_COMPILE="${TC_GCC}/aarch64-linux-gnu-"
export CROSS_COMPILE_COMPAT="${TC_GCC}/arm-linux-gnueabi-"
export PATH="$(dirname "$CC"):$TC_GCC:$PATH"

# ---------- Build ----------
DEFCONFIG=y2q_kor_singlex_defconfig   # ★ 필요에 따라 변경
OUTDIR=out

mkdir -p "$OUTDIR"
make O=$OUTDIR "$DEFCONFIG"
make -j$(nproc) O=$OUTDIR

# ---------- Copy artifacts ----------
cp "$OUTDIR/arch/arm64/boot/Image"* ./   # Image 또는 Image.gz‑dtb
cp "$OUTDIR/arch/arm64/boot/dts/vendor/qcom/dtbo.img" ./ 2>/dev/null || true
echo ">>> Build done: $(date)"