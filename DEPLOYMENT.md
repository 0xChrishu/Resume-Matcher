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
1. 点击 "New Project"
2. 选择 "Deploy from Dockerfile"
3. 连接你的 GitHub 仓库

### 1.3 配置环境变量

在 Railway 项目设置中添加以下环境变量：

```bash
# GLM 智谱AI 配置
LLM_PROVIDER=openai
LLM_MODEL=glm-4-flash
LLM_API_KEY=你的智谱API密钥
LLM_API_BASE=https://open.bigmodel.cn/api/paas/v4

# 服务器配置
HOST=0.0.0.0
PORT=8000

# CORS 配置（稍后填入你的域名）
FRONTEND_BASE_URL=https://your-domain.com
CORS_ORIGINS=["https://your-domain.com"]
```

### 1.4 获取后端 URL
部署完成后，Railway 会提供一个 URL，例如：
```
https://your-backend.railway.app
```

**复制这个 URL**，下一步会用到。

---

## 第二步：部署前端 (Vercel)

### 2.1 安装 Vercel CLI
```bash
npm install -g vercel
```

### 2.2 登录并部署
```bash
# 在项目根目录
vercel login
vercel
```

按提示操作：
- 选择链接到现有项目
- 选择你的 GitHub 仓库
- **重要**：当询问 `NEXT_PUBLIC_API_URL` 时，填入第一步获取的 Railway URL

### 2.3 配置环境变量

在 Vercel 项目设置中添加：
```bash
NEXT_PUBLIC_API_URL=https://your-backend.railway.app
```

### 2.4 获取前端 URL
Vercel 会提供一个默认域名，例如：
```
https://your-project.vercel.app
```

---

## 第三步：配置自定义域名

### 3.1 在 Vercel 添加域名
1. 进入 Vercel 项目 → Settings → Domains
2. 添加你的域名 `your-domain.com`
3. Vercel 会显示需要配置的 DNS 记录

### 3.2 在域名注册商配置 DNS

添加以下 DNS 记录：

| 类型 | 名称 | 值 |
|------|------|-----|
| CNAME | www | cname.vercel-dns.com |
| A | @ | 76.76.21.21 |

### 3.3 更新后端 CORS 配置

回到 Railway，更新环境变量：
```bash
FRONTEND_BASE_URL=https://your-domain.com
CORS_ORIGINS=["https://your-domain.com"]
```

然后重新部署后端。

---

## 第四步：测试部署

### 4.1 健康检查
```bash
# 检查后端
curl https://your-backend.railway.app/api/v1/health

# 检查前端
curl https://your-domain.com
```

### 4.2 完整测试
1. 访问 `https://your-domain.com`
2. 进入设置页面
3. 配置 GLM API Key（应该在环境变量中已配置，但可以在 UI 中测试）
4. 上传简历测试

---

## GLM 智谱AI 配置说明

### 获取 API Key
1. 访问 [open.bigmodel.cn](https://open.bigmodel.cn/)
2. 注册并实名认证
3. 创建 API Key

### 支持的模型
| 模型 | 说明 |
|------|------|
| `glm-4-flash` | 速度快，适合简单任务 |
| `glm-4-plus` | 能力强，适合复杂任务 |
| `glm-4-air` | 性价比高 |

### 环境变量配置
```bash
LLM_PROVIDER=openai
LLM_MODEL=glm-4-flash
LLM_API_KEY=你的智谱API密钥
LLM_API_BASE=https://open.bigmodel.cn/api/paas/v4
```

---

## 常见问题

### Q: PDF 生成失败
**A:** 确保 Railway 部署使用的是 Dockerfile，已安装 Playwright 和 Chromium。

### Q: CORS 错误
**A:** 检查后端 `CORS_ORIGINS` 是否包含你的前端域名。

### Q: GLM API 调用失败
**A:** 确认：
1. API Key 正确
2. `LLM_API_BASE` 设置为 `https://open.bigmodel.cn/api/paas/v4`
3. `LLM_PROVIDER` 设置为 `openai`（智谱兼容 OpenAI 格式）

---

## 费用估算

| 平台 | 免费额度 | 超出费用 |
|------|----------|----------|
| Vercel | 100GB 流量/月 | $20/100GB |
| Railway | $5 免费额度 | 按使用计费 |
| GLM | 新用户有额度 | 按tokens计费 |

---

## 监控和维护

### 日志查看
- **Vercel**: 项目 → Logs
- **Railway**: 项目 → Logs

### 数据备份
Railway 使用 volume 持久化数据，建议定期：
1. 进入 Railway 容器
2. 导出 `data/` 目录
3. 下载备份

---

## 下一步

部署完成后，你可以：
1. 添加用户认证
2. 配置 CDN 加速
3. 设置日志监控
4. 添加性能分析

祝部署顺利！有问题随时问。
