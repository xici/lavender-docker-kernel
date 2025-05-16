# lavender-docker-kernel

为红米 note 7 编译的支持 docker 的内核。

内核源码来自 [Crdroid:android_kernel_xiaomi_lavender](https://github.com/crdroidandroid/android_kernel_xiaomi_lavender/tree/b7b27af5994f7afc11f69cfef194a8dc738842b4)，对应的 ROM 为 [crd for lavender 10.11](https://crdroid.net/lavender/10)，最后更新日期为 `2024-12-13` 的版本。

## 我做了什么？

根据这篇教程：[Docker On Android](https://gist.github.com/FreddieOliveira/efe850df7ff3951cb62d74bd770dce27)，修改了内核文件 `kernel/Makefile` 和 `net/netfilter/xt_qtaguid.c`（路径基于内核源码根目录）。

教程提到：

> All packages, except for Tini have been added to [termux-root](https://github.com/termux/termux-root-packages).

所以下载了 [tini-0.19.0-alt2.aarch64.rpm](https://altlinux.pkgs.org/p11/classic-aarch64/tini-0.19.0-alt2.aarch64.rpm.html) ，解压获得 `tini` 文件，重命名为 `docker-init` 并放置于 `/data/data/com.termux/files/home/usr/bin` 目录下。

根据[内核测试脚本](https://github.com/moby/moby/blob/master/contrib/check-config.sh)的测试结果，在内核编译配置中开启对应的选项。

## 如何使用

请确认系统版本是否正确！请备份boot，dtbo分区！完成这些操作后，使用任意第三方 recovery 刷入 `lavender-docker-kernel-x.zip` 即可（x 为版本号000）。

## docker 支持情况

已测试可以运行：

- docker 官方提供的 `hello-world` 镜像
- [LangBot 的镜像](https://docs.langbot.app/zh/)

## 问题

容器似乎无法联网，除非使用 host 网络（未完全测试）。

目前的内核测试脚本结果：

```log
~ # bash check-config.sh 
info: reading kernel config from /proc/config.gz ...

Generally Necessary:
- cgroup hierarchy: cgroupv2
  Controllers:
  - cpu: missing
  - cpuset: missing
  - io: missing
  - memory: missing
  - pids: missing
- CONFIG_NAMESPACES: enabled
- CONFIG_NET_NS: enabled
- CONFIG_PID_NS: enabled
- CONFIG_IPC_NS: enabled
- CONFIG_UTS_NS: enabled
- CONFIG_CGROUPS: enabled
- CONFIG_CGROUP_CPUACCT: enabled
- CONFIG_CGROUP_DEVICE: enabled
- CONFIG_CGROUP_FREEZER: enabled
- CONFIG_CGROUP_SCHED: enabled
- CONFIG_CPUSETS: enabled
- CONFIG_MEMCG: enabled
- CONFIG_KEYS: enabled
- CONFIG_VETH: enabled
- CONFIG_BRIDGE: enabled
- CONFIG_BRIDGE_NETFILTER: enabled
- CONFIG_IP_NF_FILTER: enabled
- CONFIG_IP_NF_MANGLE: enabled
- CONFIG_IP_NF_TARGET_MASQUERADE: enabled
- CONFIG_IP6_NF_FILTER: enabled
- CONFIG_IP6_NF_MANGLE: enabled
- CONFIG_IP6_NF_TARGET_MASQUERADE: enabled
- CONFIG_NETFILTER_XT_MATCH_ADDRTYPE: enabled
- CONFIG_NETFILTER_XT_MATCH_CONNTRACK: enabled
- CONFIG_NETFILTER_XT_MATCH_IPVS: enabled
- CONFIG_NETFILTER_XT_MARK: enabled
- CONFIG_IP_NF_RAW: enabled
- CONFIG_IP_NF_NAT: enabled
- CONFIG_NF_NAT: enabled
- CONFIG_IP6_NF_RAW: enabled
- CONFIG_IP6_NF_NAT: enabled
- CONFIG_NF_NAT: enabled
- CONFIG_POSIX_MQUEUE: enabled
- CONFIG_NF_NAT_IPV4: enabled
- CONFIG_NF_NAT_NEEDED: enabled
- CONFIG_CGROUP_BPF: enabled

Optional Features:
- CONFIG_USER_NS: enabled
- CONFIG_SECCOMP: enabled
- CONFIG_SECCOMP_FILTER: enabled
- CONFIG_CGROUP_PIDS: enabled
- CONFIG_MEMCG_SWAP: enabled
- CONFIG_MEMCG_SWAP_ENABLED: enabled
    (cgroup swap accounting is currently enabled)
- CONFIG_IOSCHED_CFQ: missing
- CONFIG_CFQ_GROUP_IOSCHED: missing
- CONFIG_BLK_CGROUP: enabled
- CONFIG_BLK_DEV_THROTTLING: enabled
- CONFIG_CGROUP_PERF: enabled
- CONFIG_CGROUP_HUGETLB: missing
- CONFIG_NET_CLS_CGROUP: enabled
- CONFIG_CGROUP_NET_PRIO: enabled
- CONFIG_CFS_BANDWIDTH: enabled
- CONFIG_FAIR_GROUP_SCHED: enabled
- CONFIG_IP_NF_TARGET_REDIRECT: enabled
- CONFIG_IP_VS: enabled
- CONFIG_IP_VS_NFCT: enabled
- CONFIG_IP_VS_PROTO_TCP: enabled
- CONFIG_IP_VS_PROTO_UDP: enabled
- CONFIG_IP_VS_RR: enabled
- CONFIG_SECURITY_SELINUX: enabled
- CONFIG_SECURITY_APPARMOR: enabled
- CONFIG_EXT4_FS: enabled
- CONFIG_EXT4_FS_POSIX_ACL: enabled
- CONFIG_EXT4_FS_SECURITY: enabled
- Network Drivers:
  - "overlay":
    - CONFIG_VXLAN: enabled
    - CONFIG_BRIDGE_VLAN_FILTERING: missing
      Optional (for encrypted networks):
      - CONFIG_CRYPTO: enabled
      - CONFIG_CRYPTO_AEAD: enabled
      - CONFIG_CRYPTO_GCM: enabled
      - CONFIG_CRYPTO_SEQIV: enabled
      - CONFIG_CRYPTO_GHASH: enabled
      - CONFIG_XFRM: enabled
      - CONFIG_XFRM_USER: enabled
      - CONFIG_XFRM_ALGO: enabled
      - CONFIG_INET_ESP: enabled
      - CONFIG_NETFILTER_XT_MATCH_BPF: enabled
      - CONFIG_INET_XFRM_MODE_TRANSPORT: enabled
  - "ipvlan":
    - CONFIG_IPVLAN: enabled
  - "macvlan":
    - CONFIG_MACVLAN: enabled
    - CONFIG_DUMMY: enabled
  - "ftp,tftp client in container":
    - CONFIG_NF_NAT_FTP: enabled
    - CONFIG_NF_CONNTRACK_FTP: enabled
    - CONFIG_NF_NAT_TFTP: enabled
    - CONFIG_NF_CONNTRACK_TFTP: enabled
- Storage Drivers:
  - "btrfs":
    - CONFIG_BTRFS_FS: enabled
    - CONFIG_BTRFS_FS_POSIX_ACL: enabled
  - "overlay":
    - CONFIG_OVERLAY_FS: enabled
  - "zfs":
    - /dev/zfs: missing
    - zfs command: missing
    - zpool command: missing

Limits:
- /proc/sys/kernel/keys/root_maxkeys: 1000000
```

奇怪的是 missing 的选项我已经在内核编译配置中启用了，但刷入之后测试还是没有。

~~更奇怪的是我一开始以为这个脚本检测的是内核编译配置文件~~

## tips

[这篇博客](https://www.cnblogs.com/kanadeblisst/p/18308946)提到：

> 这里并不清楚什么原因，但偶然记得之前在酷安上看到一个东西，过去[翻了翻](https://www.coolapk.com/feed/51581431?shareKey=MmRlNTgxOTVmNjliNjY5M2QwMGU~)，说是要降级containerd包的版本。

所以需要将 containerd 包降级为 `1.6.21-1`。由于酷安帖子中的链接已失效，所以 containerd 包是从[博客主的 github 仓库](https://github.com/kanadeblisst00/docker-in-guacamole)获取的。

如果需要支持 `docker compose`，需要在 `/data/data/com.termux/files/usr/var/run` 中新建 `docker.sock` 文件，否则 `docker compose` 会报错找不到文件。

## 自行编译

可以使用我提供的 `Dockerfile` 构建镜像。在内核源码根目录执行 `build_kernel.sh` 脚本快速开始编译：

```bash
bash build_kernel.sh
```

编译脚本在编译成功后会自动合并 `Image.gz` 和 `sdm660-xiaomi-lavender.dtb` 文件，生成 `Image.gz-dtb` 文件。

之后再使用 AnyKernel3 提供的模板进行打包，生成可刷入的 zip 文件。基础教程：[如何使用 AnyKernel3 打包内核](https://github.com/tiann/KernelSU/discussions/952)

## 免责声明

仅在本人的设备上正常运行，如果刷入后你的设备出现无法启动等变砖现象，本人概不负责！一切风险自行承担！刷入即代表同意上述条款。

## Special Thanks

[Crdroid](https://crdroid.net/) for kernel source and ROM of lavender

[pkgs.org](https://altlinux.pkgs.org) for tini package

[moby](https://github.com/moby/moby) for kernel testing script

[AnyKernel3](https://github.com/osm0sis/AnyKernel3) for making module

[Open AI:ChatGPT](https://chatgpt.com/)

[ByteDance:DouBao](https://www.doubao.com/)

[DeepSeek:DeepSeek](https://chat.deepseek.com/)