#!/bin/bash
# 安全的包添加流程

# 1. 基础准备
make defconfig
./scripts/feeds update -a
./scripts/feeds install -a

# 2. 添加目标包
PACKAGES=(
    "luci"
    "your-custom-package"
    "kmod-usb-storage"
)

for pkg in "${PACKAGES[@]}"; do
    echo "CONFIG_PACKAGE_${pkg}=y" >> .config
done

# 3. 多轮依赖解析
make olddefconfig
make defconfig      # 重新整理
make olddefconfig   # 再次解析依赖

# 4. 验证依赖完整性
make prepare V=s 2>&1 | tee prepare.log
if grep -q "ERROR\|missing" prepare.log; then
    echo "发现依赖问题，请检查 prepare.log"
    exit 1
fi

# 5. 可选：最终检查
make menuconfig  # 快速浏览确认无遗漏