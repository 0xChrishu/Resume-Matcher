# GLM 智谱AI 配置指南

## 📋 配置步骤

### 1. 填写你的 API Key

编辑 `apps/backend/.env.local` 文件：

```bash
# 将你的 API Key 填入这里
LLM_API_KEY=你的智谱API密钥
```

### 2. 本地测试（可选）

如果想先在本地测试：

```bash
# 终端 1：启动后端
cd apps/backend
cp .env.local .env
uv run uvicorn app.main:app --reload --port 8000

# 终端 2：启动前端
cd apps/frontend
npm run dev
```

然后访问 http://localhost:3000

---

## 🚀 上传到 GitHub

### 第一步：查看当前状态

```bash
git status
```

你会看到新增的部署文件：
- `DEPLOYMENT.md` - 部署指南
- `railway.toml` - Railway 配置
- `vercel.json` - Vercel 配置

### 第二步：提交更改

```bash
git add .
git commit -m "添加 Vercel + Railway 部署配置，支持 GLM 智谱AI"
git push
```

**注意**：`.env.local` 文件不会被提交（已在 .gitignore 中保护）

---

## 🌐 部署到 Railway（后端）

### 方式一：通过 GitHub 连接（推荐）

1. 访问 [railway.app](https://railway.app/)
2. 点击 "New Project" → "Deploy from GitHub repo"
3. 选择你的仓库
4. Railway 会自动检测 `railway.toml` 配置

### 方式二：通过 CLI

```bash
npm install -g @railway/cli
railway login
railway init
railway up
```

### 配置环境变量

在 Railway 项目设置中添加：

```bash
LLM_PROVIDER=openai
LLM_MODEL=glm-4-flash
LLM_API_KEY=你的智谱API密钥
LLM_API_BASE=https://open.bigmodel.cn/api/paas/v4
FRONTEND_BASE_URL=https://你的域名.com
CORS_ORIGINS=["https://你的域名.com"]
```

---

## 🌐 部署到 Vercel（前端）

### 通过 CLI 部署

```bash
npm install -g vercel
vercel login
vercel
```

按提示操作，选择：
- 链接到现有项目
- 你的 GitHub 仓库
- 当询问环境变量时，填入你的 Railway 后端 URL

### 配置环境变量

在 Vercel 项目设置中添加：

```bash
NEXT_PUBLIC_API_URL=https://你的后端.railway.app
```

---

## ✅ 验证部署

```bash
# 测试后端健康检查
curl https://你的后端.railway.app/api/v1/health

# 测试前端
curl https://你的前端.vercel.app
```

---

## 📝 目录结构说明

```
Resume-Matcher/
├── apps/
│   ├── backend/
│   │   ├── .env.local          # 本地配置（不提交）
│   │   ├── .env.example        # 配置模板（已提交）
│   │   └── app/
│   └── frontend/
├── DEPLOYMENT.md               # 部署指南
├── railway.toml               # Railway 配置
├── vercel.json                # Vercel 配置
├── .env.glm.example           # GLM 配置模板
└── .gitignore                 # Git 忽略规则
```

---

## 🔒 安全提醒

| 文件 | 是否提交到 Git |
|------|---------------|
| `.env.local` | ❌ 不提交 |
| `.env` | ❌ 不提交 |
| `.env.example` | ✅ 可以提交 |
| `apps/backend/data/config.json` | ❌ 不提交 |

---

## ❓ 常见问题

**Q: 我的 API Key 会被泄露吗？**
A: 不会，`.env.local` 文件在 `.gitignore` 中，不会被提交到 GitHub。

**Q: Railway 上如何配置 API Key？**
A: 在 Railway 项目的环境变量中配置，不要写在代码里。

**Q: 可以同时部署多个环境吗？**
A: 可以，在 Railway 和 Vercel 创建多个项目（dev/staging/prod）。

---

需要帮助？查看 [DEPLOYMENT.md](./DEPLOYMENT.md) 获取完整部署指南。
