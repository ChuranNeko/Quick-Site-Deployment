# Quick Site Deployment

[![GitHub](https://img.shields.io/badge/GitHub-ChuranNeko-blue)](https://github.com/ChuranNeko/quick-site-deployment)
[![Gitee](https://img.shields.io/badge/Gitee-ChuranNeko-red)](https://gitee.com/ChuranNeko/quick-site-deployment)

一个简单而强大的自动化脚本，帮助小白用户快速部署带有HTTPS的网站。

A simple yet powerful automation script to help beginners quickly deploy websites with HTTPS.

## 特性 | Features

- 🚀 一键配置 HTTPS 证书
- 🔒 自动配置 Nginx 反向代理
- 🛡️ 内置防火墙配置
- 📝 自动证书续期
- ⚡ 支持 HTTP/2
- 🔄 自动备份原有配置

## 前提条件 | Prerequisites

- Ubuntu/Debian 系统
- Root 权限
- 已解析的域名
- 运行中的后端服务

## 快速开始 | Quick Start

1. 克隆仓库 | Clone the repository:
```bash
git clone https://github.com/ChuranNeko/quick-site-deployment.git
# 或使用 Gitee
git clone https://gitee.com/ChuranNeko/quick-site-deployment.git
```

2. 进入项目目录 | Enter the project directory:
```bash
cd quick-site-deployment
```

3. 运行脚本 | Run the script:
```bash
# 中文版本 | Chinese version
sudo bash deploy.sh

# 英文版本 | English version
sudo bash deploy_en.sh
```

4. 按提示输入信息 | Follow the prompts:
   - 域名 | Domain name
   - 邮箱地址 | Email address
   - 后端服务端口 | Backend service port

## 注意事项 | Notes

- 确保域名已正确解析到服务器
- 确保后端服务已启动并正常运行
- 脚本需要 root 权限执行
- 将自动备份原有 Nginx 配置
- 支持多语言文档，详见 [language](./language) 目录

## 工作流程 | Workflow

1. 验证输入参数
2. 安装必要依赖
3. 配置防火墙规则
4. 验证后端服务状态
5. 备份现有 Nginx 配置
6. 生成新的 Nginx 配置
7. 申请并配置 SSL 证书
8. 测试证书自动续期

## 贡献 | Contributing

欢迎提交 Issue 和 Pull Request！

Issues and Pull Requests are welcome!

## 许可证 | License

本项目采用 [MIT License](LICENSE) 许可证（包含中英双语版本）。

This project is licensed under the [MIT License](LICENSE) (includes both English and Chinese versions).

- ✅ 可以商业使用 | Commercial use allowed
- ✅ 可以修改 | Modification allowed
- ✅ 可以分发 | Distribution allowed
- ✅ 私人使用 | Private use allowed
- 📝 需包含许可证声明 | License notice required

## 作者 | Author

ChuranNeko
- GitHub: [@ChuranNeko](https://github.com/ChuranNeko)
- Gitee: [@ChuranNeko](https://gitee.com/ChuranNeko)