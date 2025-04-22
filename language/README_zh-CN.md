# 快速网站部署

这是一个帮助新手用户快速部署HTTPS网站的自动化脚本。

## 功能特点

- 🚀 自动配置HTTPS证书
- 🔒 自动设置Nginx反向代理
- 🛡️ 自动配置防火墙规则
- 📝 自动设置证书续期
- ⚡ 支持HTTP/2协议
- 🔄 自动备份已有配置

## 使用前准备

1. 确保您有一个已经解析到服务器的域名
2. 确保您的服务器运行的是Ubuntu/Debian系统
3. 确保您有root权限
4. 确保您的后端服务已经在运行

## 使用步骤

1. 克隆仓库：
```bash
git clone https://github.com/ChuranNeko/quick-site-deployment.git
# 或者使用Gitee
git clone https://gitee.com/ChuranNeko/quick-site-deployment.git
```

2. 进入项目目录：
```bash
cd quick-site-deployment
```

3. 运行脚本：
```bash
# 使用中文版本脚本
sudo bash deploy.sh

# 使用英文版本脚本
sudo bash deploy_en.sh
```

> 提示：两个脚本功能完全相同，只是提示语言不同，您可以选择适合您的版本。

4. 根据提示输入以下信息：
   - 您的域名
   - 您的电子邮件地址（用于SSL证书）
   - 您的后端服务端口号

## 注意事项

1. 域名配置：
   - 确保域名已经正确解析到您的服务器IP
   - 支持二级域名

2. 端口配置：
   - 默认使用7001端口
   - 可以根据实际情况修改
   - 确保端口未被其他服务占用

3. SSL证书：
   - 自动申请Let's Encrypt证书
   - 自动配置证书续期
   - 证书有效期为90天
   - 系统会自动在到期前续期

4. 安全提示：
   - 脚本会自动配置防火墙
   - 仅开放80和443端口
   - 自动启用HTTPS强制跳转

## 常见问题

1. 如果遇到"此脚本必须以root用户身份运行"：
   - 使用sudo运行脚本

2. 如果遇到"端口无服务监听"：
   - 检查后端服务是否正常运行
   - 确认端口号是否正确

3. 如果遇到域名解析错误：
   - 检查DNS解析是否正确
   - 等待DNS解析生效（通常需要几分钟到几小时）

## 技术支持

如果您在使用过程中遇到任何问题，欢迎：
- 提交 [GitHub Issue](https://github.com/ChuranNeko/quick-site-deployment/issues)
- 提交 [Gitee Issue](https://gitee.com/ChuranNeko/quick-site-deployment/issues)

## 许可证

本项目采用 [MIT License](../LICENSE) 许可证（包含中英双语版本）。

- ✅ 可以商业使用
- ✅ 可以修改
- ✅ 可以分发
- ✅ 私人使用
- 📝 需包含许可证声明

这意味着您可以自由地使用、修改和分发本项目，只需在您的项目中包含原始许可证即可。许可证文件已包含完整的中英文版本说明。