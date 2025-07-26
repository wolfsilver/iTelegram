# GitHub Actions 构建说明

本项目包含两个 GitHub Actions 工作流来自动化构建过程：

## 工作流说明

### 1. `build-release.yml` - 发布构建
**触发条件：**
- 推送带有 `release-*` 前缀的标签时
- 手动触发（可以指定标签名）

**功能：**
- 使用 Docker 构建所有版本的 APK 和 Bundle
- 生成校验和文件
- 创建预发布（Pre-release）到 GitHub Releases
- 自动上传所有构建产物

**产物包括：**
- `telegram-{version}-standalone.apk` - 直接下载版本
- `telegram-{version}-playstore.apk` - Google Play 商店版本  
- `telegram-{version}-huawei.apk` - 华为应用商店版本
- `telegram-{version}-bundle.aab` - Play 商店 Bundle
- `telegram-{version}-bundle-sdk23.aab` - Play 商店 Bundle (SDK 23)
- `checksums.txt` - 所有文件的 SHA256 校验和

### 2. `build-dev.yml` - 开发构建
**触发条件：**
- 推送到 `master`、`develop`、`build` 分支
- 向 `master` 分支提交 Pull Request
- 只有相关文件变更时才触发

**功能：**
- 快速构建验证
- 将构建产物作为 Artifacts 上传（保存7天）
- 生成构建摘要

## 使用方法

### 创建发布版本

1. **使用标签触发：**
   ```bash
   git tag release-9.3.3_3026
   git push origin release-9.3.3_3026
   ```

2. **手动触发：**
   - 前往 GitHub 仓库的 Actions 页面
   - 选择 "Build and Release APK" 工作流
   - 点击 "Run workflow"
   - 输入标签名（如：`release-9.3.3_3026`）

### 查看构建结果

1. **发布版本：**
   - 构建完成后会在 GitHub Releases 页面创建一个预发布
   - 所有 APK 和 Bundle 文件都会自动上传
   - 包含详细的发布说明和校验和信息

2. **开发构建：**
   - 在 Actions 页面查看构建日志
   - 下载 Artifacts 获取构建产物
   - 查看构建摘要了解产物信息

## 验证构建

按照发布说明中的步骤验证构建的可重现性：

1. 克隆仓库并切换到相应标签
2. 使用 Docker 本地构建
3. 比较生成的 APK 与发布的文件
4. 验证 SHA256 校验和

## 注意事项

- 确保仓库有适当的权限来创建 Releases
- 构建过程需要较长时间（通常 20-40 分钟）
- 所有发布都标记为预发布，需要手动改为正式发布
- 开发构建的 Artifacts 只保存 7 天

## 故障排除

如果构建失败：

1. 检查 Docker 构建日志
2. 确认所有依赖文件存在
3. 验证标签格式是否正确
4. 检查是否有足够的构建资源

更多详细信息请参考项目主 README.md 文件。
