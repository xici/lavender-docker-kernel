#!/bin/bash

# 设置输出日志文件
LOG_FILE=build_kernel.log

# 清空日志
: > "$LOG_FILE"

echo "清理源码" >> "$LOG_FILE"
make mrproper >> "$LOG_FILE"
# rm -rf out
# mkdir out

# 配置内核
make O=out ARCH=arm64 lavender_defconfig >> "$LOG_FILE" 2>&1

# 编译内核
make -j$(nproc) O=out ARCH=arm64 \
  CC=clang-17 CLANG_TRIPLE=aarch64-linux-gnu- \
  CROSS_COMPILE=aarch64-linux-gnu- \
  Image.gz dtbs >> "$LOG_FILE" 2>&1

# 检查编译是否成功
if [ $? -eq 0 ]; then
  echo "[INFO] 编译成功，正在合并 Image.gz 与 DTB ..." >> "$LOG_FILE"
  cat out/arch/arm64/boot/Image.gz out/arch/arm64/boot/dts/vendor/qcom/sdm660-mtp-lavender.dtb > Image.gz-dtb
  echo "[INFO] 合并完成：Image.gz-dtb" >> "$LOG_FILE"
else
  echo "[ERROR] 编译失败，跳过合并操作。" >> "$LOG_FILE"
  exit 1
fi

