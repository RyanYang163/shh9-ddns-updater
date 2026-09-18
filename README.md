# DDNS Updater

| 项 | 值 |
|---|---|
| 应用 ID | `shh9-ddns-updater` |
| 形态 | Deb 应用（单包模式） · WebUI 内嵌（iframe） |
| 版本 | 1.0.0 |
| 上游项目 | https://github.com/qdm12/ddns-updater |
| 上游许可证 | MIT |
| 宿主端口 | 18809 |

## 简介

动态域名解析客户端：定时把本机公网 IP 更新到 DNS 服务商，支持数十家服务商。

## 打包

```bash
./build.sh                # 默认 x86_64
./build.sh aarch64        # ARM（Deb 应用）
```

产物在 `build/output/`，同级生成 `<包名>.sha256`。

## 提交前必办事项

- 上游提供 **zero-dependency 的 Go 静态二进制**，是 9 个应用中最适合 Deb 单包形态的一个。
- 把 x86_64 / aarch64 的二进制放进 bin/ 即可，无需任何运行时。
- ⚠️ 首次启动前必须在 WebUI 中配置至少一个 DNS provider，否则服务空转。
- [ ] 真机安装、启动、停止、卸载残留四项实测
- [ ] 首屏加载 ≤ 5 秒（指引 H10）
- [ ] x86_64 与 aarch64 分别构建并测试（指引 H7）
- [ ] 提交前跑一遍指引 13.9 上架前自查清单

## 隐私政策

见 [PRIVACY.md](./PRIVACY.md)（对应审核项 C3–C8）。

## 许可证与出处

本仓库**仅包含 TOS 平台集成所需的配置文件与打包脚本**，应用本体的源码与二进制来自上游项目：https://github.com/qdm12/ddns-updater

上游许可证：**%s**。本封装保留上游许可证声明，未修改上游代码（Deb 形态下按上游许可证要求随包提供 LICENSE）。

应用名称与图标为上游项目的标识；本仓库图标为自行绘制的简易图形，不含上游商标元素（对应审核项 H19）。
