FROM ubuntu:22.04

# 安装构建工具和交叉编译工具链
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    git curl wget bc build-essential bison flex libssl-dev \
    libelf-dev libncurses-dev lz4 cpio device-tree-compiler \
    gcc-aarch64-linux-gnu binutils-aarch64-linux-gnu \
    vim zip

# 安装 Clang-17 / LLD-17
RUN wget -qO - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    echo "deb http://apt.llvm.org/jammy/ llvm-toolchain-jammy-17 main" > /etc/apt/sources.list.d/llvm.list && \
    apt-get update && apt-get install -y clang-17 lld-17

# 设置默认工作目录
WORKDIR /workspace

CMD ["/bin/bash"]