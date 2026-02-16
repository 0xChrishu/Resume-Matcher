# Resume Matcher 部署指南

> Vercel (前端) + Railway (后端) + GLM (智谱AI)

## 部署架构

```
用户 → your-domain.com (Vercel)
           ↓
       Next.js 前端
           ↓
    Railway 后端 API
           ↓
      GLM 智谱AI
```

---

## 第一步：部署后端 (Railway)

### 1.1 注册 Railway
访问 [railway.app](https://railway.app/) 并注册账号

### 1.2 创建新项目

1. 点击 **"New Project"** 或 **"New+"**
2. 点击 **"Deploy from GitHub repo"**
3. 选择你的 Resume-Matcher fork 仓库 (`0xChrishu/Resume-Matcher`)
4. Railway 会自动检测到 Dockerfile 和 railway.toml

### 1.3 配置环境变量

进入项目 → **Variables** 标签页，添加以下环境变量：

| 变量名 | 值 | 说明 |
|--------|-----|------|
| `LLM_PROVIDER` | `openai` | 智谱AI使用OpenAI兼容格式 |
| `LLM_MODEL` | `glm-4-flash` | 智谱AI模型 |
| `LLM_API_KEY` | `你的智谱API密钥` | 在 open.bigmodel.cn 获取 |
| `LLM_API_BASE` | `https://open.bigmodel.cn/api/paas/v4` | 智谱AI API地址 |
| `PORT` | `8000` | 后端端口 |
| `BACKEND_PORT` | `8000` | 后端端口 |

> **注意**: `FRONTEND_BASE_URL` 和 `CORS_ORIGINS` 需要在部署完前端后再更新

### 1.4 配置持久化存储

进入项目 → **Settings** → **Volumes**：

1. 点击 **"New Volume"**
2. 名称: `data`
3. 挂载路径: `/app/backend/data`

### 1.5 开始部署

1. 点击 **"Deploy"** 按钮
2. Railway 会开始构建 Docker 镜像
3. 等待部署完成（首次部署可能需要 5-10 分钟）

### 1.6 获取后端 URL

部署完成后，在项目顶部会看到生成的 URL，例如：
```
https://resume-matcher-production.up.railway.app
```

**复制这个 URL**，下一步会用到。

### 1.7 测试后端

访问健康检查端点：
```bash
curl https://your-backend.railway.app/api/v1/health
```

应该返回：`{"status":"ok"}`

---

## 第二步：部署前端 (Vercel)

### 2.1 注册 Vercel
访问 [vercel.com](https://vercel.com/) 并注册账号

### 2.2 创建新项目

1. 点击 **"Add New..."** → **"Project"**
2. 导入你的 GitHub 仓库
3. Vercel 会自动检测到 `vercel.json` 配置

### 2.3 配置环境变量

在 Vercel 项目设置中添加：

| 变量名 | 值 |
|--------|-----|
| `NEXT_PUBLIC_API_URL` | `https://your-backend.railway.app` |

> 将 `your-backend.railway.app` 替换为第一步获取的 Railway URL

### 2.4 开始部署

1. 点击 **"Deploy"**
2. 等待部署完成（通常 1-2 分钟）

### 2.5 获取前端 URL

Vercel 会提供一个默认域名，例如：
```
https://resume-matcher.vercel.app
```

---

## 第三步：更新后端 CORS 配置

现在前端已部署，需要更新后端的 CORS 配置：

### 3.1 回到 Railway

进入项目 → **Variables**，添加/更新：

| 变量名 | 值 |
|--------|-----|
| `FRONTEND_BASE_URL` | `https://resume-matcher.vercel.app` |
| `CORS_ORIGINS` | `["https://resume-matcher.vercel.app"]` |

> 请将 `resume-matcher.vercel.app` 替换为你的实际 Vercel 域名

### 3.2 重新部署

更新环境变量后，Railway 会自动重新部署。

---

## 第四步：配置自定义域名

### 4.1 在 Vercel 添加域名

1. 进入 Vercel 项目 → **Settings** → **Domains**
2. 点击 **"Add"**，输入你的域名 `your-domain.com`
3. Vercel 会显示需要配置的 DNS 记录

### 4.2 配置 DNS 记录

在你的域名注册商（如阿里云、腾讯云、Namecheap）添加：

| 类型 | 名称 | 值 |
|------|------|-----|
| CNAME | www | cname.vercel-dns.com |
| A | @ | 76.76.21.21 |

### 4.3 更新 Railway CORS

再次更新 Railway 的环境变量：

```bash
FRONTEND_BASE_URL=https://your-domain.com
CORS_ORIGINS=["https://your-domain.com"]
```

---

## 第五步：完整测试

### 5.1 健康检查

```bash
# 检查后端
curl https://your-backend.railway.app/api/v1/health

# 检查前端
curl https://your-domain.com
```

### 5.2 功能测试

1. 访问 `https://your-domain.com`
2. 进入设置页面，确认 GLM 配置正确
3. 上传简历测试
4. 生成 PDF 测试

---

## GLM 智谱AI 配置说明

### 获取 API Key

1. 访问 [open.bigmodel.cn](https://open.bigmodel.cn/)
2. 注册并完成实名认证
3. 进入 **"API Key"** 页面
4. 创建新的 API Key

### 支持的模型

| 模型 | 说明 | 推荐场景 |
|------|------|----------|
| `glm-4-flash` | 速度快，成本低 | 简历筛选、简单匹配 |
| `glm-4-plus` | 能力强 | 复杂分析、生成建议 |
| `glm-4-air` | 性价比高 | 日常使用 |

### 环境变量配置

```bash
LLM_PROVIDER=openai
LLM_MODEL=glm-4-flash
LLM_API_KEY=你的智谱API密钥
LLM_API_BASE=https://open.bigmodel.cn/api/paas/v4
```

---

## 常见问题排查

### Railway 部署失败

**问题**: VOLUME keyword error
- ✅ 已修复：使用 Railway volumes 代替 Docker VOLUME

**问题**: 构建超时
- 解决：Railway 免费版构建时间限制为 15 分钟，如超时请重试

**问题**: Playwright 安装失败
- ✅ 已修复：Playwright 现在在 Dockerfile 构建时预安装

### Vercel 部署问题

**问题**: 前端无法连接后端
- 检查 `NEXT_PUBLIC_API_URL` 是否正确
- 检查后端 `CORS_ORIGINS` 是否包含前端域名

**问题**: 构建失败
- 确保 Node.js 版本为 22+
- 删除 `node_modules` 和 `.next` 后重新部署

### CORS 错误

```bash
# 错误示例
Access to fetch at 'https://backend.com' from origin 'https://frontend.com' has been blocked by CORS

# 解决方案
# 在 Railway 环境变量中检查：
CORS_ORIGINS=["https://your-frontend-domain.com"]
```

### GLM API 调用失败

1. 确认 API Key 正确
2. 确认账户有足够额度
3. 检查 `LLM_API_BASE` 设置正确
4. 查看 Railway 日志获取详细错误

---

## 文件说明

本项目包含以下部署相关文件：

| 文件 | 说明 |
|------|------|
| `Dockerfile` | Railway 后端镜像构建 |
| `railway.toml` | Railway 部署配置 |
| `vercel.json` | Vercel 前端部署配置 |
| `.railway/env.example` | Railway 环境变量示例 |
| `.env.glm.example` | GLM 本地开发配置 |

---

## 费用估算

| 平台 | 免费额度 | 超出费用 |
|------|----------|----------|
| Vercel | 100GB 流量/月 | $20/100GB |
| Railway | $5/月 免费额度 | 按使用计费 |
| GLM | 新用户赠送额度 | 按 tokens 计费 |

---

## 监控和维护

### 查看日志

**Vercel**: 项目 → Deployments → 点击部署 → View Logs

**Railway**: 项目 → View Logs

### 数据备份

Railway volume 会持久化数据，建议定期备份：

1. Railway 项目 → 你的服务
2. 点击 **"Exec"** 进入容器
3. 执行：`tar -czf /tmp/backup.tar.gz /app/backend/data`
4. 下载备份文件

---

## 部署检查清单

部署完成后，确认以下事项：

- [ ] Railway 后端部署成功
- [ ] 后端健康检查通过 (`/api/v1/health`)
- [ ] Vercel 前端部署成功
- [ ] 前端可以访问
- [ ] 前端可以调用后端 API
- [ ] CORS 配置正确
- [ ] GLM API Key 已配置
- [ ] 上传简历功能正常
- [ ] PDF 生成功能正常
- [ ] 自定义域名已配置（可选）

---

祝部署顺利！如有问题，请查看 Railway 和 Vercel 的部署日志。
