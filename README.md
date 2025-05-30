# 佛山电站数据监控系统

一个完整的光伏发电数据采集、分析和可视化平台，用于监控佛山地区的光伏电站运行状况和经济效益。

## 功能特性

### 数据采集
- 实时数据采集：支持当日数据的实时采集和更新
- 历史数据采集：支持指定时间范围的历史数据采集
- 多电站支持：可同时监控多个光伏电站
- 自动化采集：支持定时自动采集数据

### 数据分析
- 发电量统计：按时段统计光伏发电量
- 自用电量分析：计算自用电量和上网电量
- 经济效益计算：根据电价政策计算经济收益
- 时段分析：支持尖峰平谷时段的详细分析

### 数据可视化
- 实时监控面板：显示当前发电状况
- 历史数据图表：多维度数据可视化
- 经济效益报表：收益分析和成本核算
- 响应式设计：支持多设备访问

## 技术架构

### 后端技术栈
- **Python 3.x**: 主要开发语言
- **Flask**: Web框架
- **SQLite**: 数据库
- **Requests**: HTTP客户端
- **APScheduler**: 定时任务调度

### 前端技术栈
- **Vue.js 2.x**: 前端框架
- **Element UI**: UI组件库
- **ECharts**: 数据可视化
- **Axios**: HTTP客户端
- **Vue Router**: 路由管理

## 项目结构

```
├── backend/                 # 后端代码
│   ├── app.py              # Flask应用主文件
│   ├── collector_db.py     # 数据采集核心模块
│   ├── collector_today.py  # 当日数据采集
│   ├── collector_yesterday.py # 昨日数据采集
│   ├── collector_custom.py # 自定义时间范围采集
│   ├── init_db.py         # 数据库初始化
│   ├── requirements.txt   # Python依赖
│   └── power_station_data.db # SQLite数据库
├── frontend/               # 前端代码
│   ├── src/
│   │   ├── components/    # Vue组件
│   │   ├── views/        # 页面视图
│   │   ├── router/       # 路由配置
│   │   ├── services/     # API服务
│   │   └── utils/        # 工具函数
│   ├── package.json      # Node.js依赖
│   └── vue.config.js     # Vue配置
└── start.sh              # 启动脚本
```

## 快速开始

### 环境要求
- Python 3.7+
- Node.js 14+
- npm 6+

### 安装步骤

1. **克隆项目**
```bash
git clone https://github.com/sdsupernfs/foshan-power-station-monitor.git
cd foshan-power-station-monitor
```

2. **后端设置**
```bash
cd backend
python3 -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
```

3. **初始化数据库**
```bash
python init_db.py
```

4. **前端设置**
```bash
cd ../frontend
npm install
```

5. **启动服务**
```bash
# 使用启动脚本（推荐）
chmod +x start.sh
./start.sh

# 或手动启动
# 后端
cd backend && python app.py
# 前端（新终端）
cd frontend && npm run serve
```

6. **访问应用**
- 前端界面：http://localhost:8080
- 后端API：http://localhost:3030

## 使用说明

### 数据采集

#### 手动采集
```bash
# 采集当日数据
python collector_db.py --action collect --mode current_day

# 采集昨日数据
python collector_db.py --action collect --mode yesterday

# 采集当月数据
python collector_db.py --action collect --mode current_month

# 采集上月数据
python collector_db.py --action collect --mode last_month

# 自定义时间范围
python collector_db.py --action collect --start-time "2025-05-01 00:00" --end-time "2025-05-31 23:59"
```

#### API接口
```bash
# 刷新当日数据
curl -X POST http://localhost:3030/api/refresh-today-data

# 刷新昨日数据
curl -X POST http://localhost:3030/api/refresh-yesterday-data

# 刷新当月数据
curl -X POST http://localhost:3030/api/refresh-current-month-data

# 刷新上月数据
curl -X POST http://localhost:3030/api/refresh-last-month-data
```

### 数据查询

#### 获取统计数据
```bash
# 当日数据
curl http://localhost:3030/api/today-data

# 昨日数据
curl http://localhost:3030/api/yesterday-data

# 当月数据
curl http://localhost:3030/api/current-month-data

# 上月数据
curl http://localhost:3030/api/last-month-data

# 历史数据
curl "http://localhost:3030/api/history-data?start_date=2025-05-01&end_date=2025-05-31"
```

## 配置说明

### 电站配置
电站信息在 `backend/collector_db.py` 中的 `STATION_CONFIG` 配置：

```python
STATION_CONFIG = [
    {
        'id': 'station_id_1',
        'name': '电站名称1',
        'multiplier': 1.0  # 电表倍率
    },
    # 更多电站配置...
]
```

### 电价配置
电价信息按月份配置，支持尖峰平谷时段：

```python
ELECTRICITY_PRICES = {
    '2025-01': {
        'self_use': {  # 自用电价（节省的电费）
            'peak': 1.2345,    # 尖段
            'high': 0.9876,    # 峰段
            'normal': 0.6543,  # 平段
            'low': 0.3210      # 谷段
        },
        'grid': {      # 上网电价（卖电收益）
            'peak': 0.8765,
            'high': 0.6543,
            'normal': 0.4321,
            'low': 0.2109
        }
    }
}
```

## API文档

### 数据刷新接口
- `POST /api/refresh-today-data` - 刷新当日数据
- `POST /api/refresh-yesterday-data` - 刷新昨日数据
- `POST /api/refresh-current-month-data` - 刷新当月数据
- `POST /api/refresh-last-month-data` - 刷新上月数据

### 数据查询接口
- `GET /api/today-data` - 获取当日统计数据
- `GET /api/yesterday-data` - 获取昨日统计数据
- `GET /api/current-month-data` - 获取当月统计数据
- `GET /api/last-month-data` - 获取上月统计数据
- `GET /api/history-data` - 获取历史数据（支持日期范围查询）

### 电价管理接口
- `GET /api/electricity-prices` - 获取电价配置
- `POST /api/electricity-prices` - 更新电价配置

## 开发指南

### 添加新电站
1. 在 `STATION_CONFIG` 中添加电站配置
2. 确保电站ID和倍率正确
3. 重启后端服务

### 修改电价政策
1. 更新 `ELECTRICITY_PRICES` 配置
2. 或通过前端电价设置页面修改
3. 重新计算历史数据经济效益

### 自定义时段
时段定义在代码中可以调整：
- 尖段：通常为用电高峰期
- 峰段：次高峰期
- 平段：正常用电期
- 谷段：用电低谷期

## 故障排除

### 常见问题

1. **数据采集失败**
   - 检查网络连接
   - 验证电站ID是否正确
   - 查看后端日志文件

2. **前端无法访问后端**
   - 确认后端服务已启动
   - 检查端口3030是否被占用
   - 验证CORS配置

3. **数据库错误**
   - 重新运行 `python init_db.py`
   - 检查数据库文件权限

### 日志查看
```bash
# 后端日志
tail -f backend/backend.log

# 实时监控采集过程
python collector_db.py --action collect --mode current_day --verbose
```

## 贡献指南

1. Fork 项目
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开 Pull Request

## 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 联系方式

如有问题或建议，请通过以下方式联系：

- 项目Issues：https://github.com/sdsupernfs/foshan-power-station-monitor/issues

## 更新日志

### v1.0.0 (2025-05-30)
- 初始版本发布
- 完整的数据采集功能
- Web界面和API接口
- 经济效益计算
- 多电站支持