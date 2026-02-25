# n8n Workflows GitOps

使用 Git 管理 n8n 工作流，实现版本控制和 CI/CD 部署。

## 目录结构

```
n8n-workflows/
├── workflows/          # 工作流 JSON 文件
├── scripts/
│   ├── export.sh       # 导出工作流到本地
│   ├── import.sh       # 导入工作流到 n8n
│   └── sync.sh         # 同步（导出+提交）
└── README.md
```

## 使用方法

### 1. 导出工作流（备份）
```bash
./scripts/export.sh
```

### 2. 导入工作流（部署）
```bash
# 导入所有工作流
./scripts/import.sh

# 导入单个工作流
./scripts/import.sh workflows/my-workflow.json
```

### 3. 同步到 Git
```bash
./scripts/sync.sh "commit message"
```

## CI/CD 集成

### GitHub Actions 示例

```yaml
name: Deploy n8n Workflows

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: self-hosted
    steps:
      - uses: actions/checkout@v4
      - name: Import workflows to n8n
        run: ./scripts/import.sh
```

## 工作流命名建议

建议重命名 JSON 文件为有意义的名称：
- `notion-sync.json` - Notion 同步工作流
- `webhook-handler.json` - Webhook 处理
- `daily-report.json` - 每日报告

## 注意事项

- 导入会创建新工作流，不会覆盖现有工作流
- 修改后需要在 n8n UI 中删除旧版本
- 凭证（Credentials）不会被导出，需要单独配置
