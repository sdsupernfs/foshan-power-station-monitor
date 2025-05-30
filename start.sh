#!/bin/bash

# 佛山电站数据监控系统 - 启动脚本

# 颜色定义
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
RED="\033[0;31m"
NC="\033[0m" # No Color

echo -e "${BLUE}佛山电站数据监控系统 - 启动脚本${NC}"
echo -e "${YELLOW}=====================================${NC}"

# 检查是否安装了必要的命令
command -v python3 >/dev/null 2>&1 || { echo -e "${RED}错误: 需要安装 python3${NC}"; exit 1; }
command -v npm >/dev/null 2>&1 || { echo -e "${RED}错误: 需要安装 npm${NC}"; exit 1; }

# 当前目录
BASE_DIR=$(pwd)
BACKEND_DIR="$BASE_DIR/backend"
FRONTEND_DIR="$BASE_DIR/frontend"

# 初始化后端
echo -e "\n${YELLOW}[1/4] 初始化后端环境...${NC}"
cd "$BACKEND_DIR" || { echo -e "${RED}错误: 无法进入后端目录${NC}"; exit 1; }

# 检查虚拟环境
if [ ! -d "venv" ]; then
  echo -e "${BLUE}创建Python虚拟环境...${NC}"
  python3 -m venv venv || { echo -e "${RED}错误: 无法创建虚拟环境${NC}"; exit 1; }
fi

# 激活虚拟环境
echo -e "${BLUE}激活虚拟环境...${NC}"
source "$BACKEND_DIR/venv/bin/activate" || { echo -e "${RED}错误: 无法激活虚拟环境${NC}"; exit 1; }

# 安装基础工具
echo -e "${BLUE}安装基础工具...${NC}"
python3 -m pip install --upgrade pip setuptools wheel --break-system-packages || { echo -e "${RED}错误: 无法安装基础工具${NC}"; exit 1; }

# 安装依赖
echo -e "${BLUE}安装后端依赖...${NC}"
python3 -m pip install -r requirements.txt --prefer-binary --break-system-packages || { echo -e "${RED}错误: 无法安装后端依赖${NC}"; exit 1; }

# 初始化数据库
echo -e "\n${YELLOW}[2/4] 初始化数据库...${NC}"
python3 init_db.py || { echo -e "${RED}错误: 数据库初始化失败${NC}"; exit 1; }

# 启动后端服务
echo -e "\n${YELLOW}[3/4] 启动后端服务...${NC}"
echo -e "${BLUE}后端服务将在 http://localhost:3030 启动${NC}"
python3 app.py &
BACKEND_PID=$!
echo -e "${GREEN}后端服务已启动 (PID: $BACKEND_PID)${NC}"

# 等待后端启动
echo -e "${BLUE}等待后端服务启动...${NC}"
sleep 3

# 初始化前端
echo -e "\n${YELLOW}[4/4] 初始化前端环境...${NC}"
cd "$FRONTEND_DIR" || { echo -e "${RED}错误: 无法进入前端目录${NC}"; exit 1; }

# 安装前端依赖
if [ ! -d "node_modules" ]; then
  echo -e "${BLUE}安装前端依赖...${NC}"
  npm install || { echo -e "${RED}错误: 无法安装前端依赖${NC}"; exit 1; }
fi

# 启动前端服务
echo -e "${BLUE}启动前端服务...${NC}"
echo -e "${BLUE}前端服务将在 http://localhost:8080 启动${NC}"
npm run serve &
FRONTEND_PID=$!
echo -e "${GREEN}前端服务已启动 (PID: $FRONTEND_PID)${NC}"

echo -e "\n${GREEN}=====================================${NC}"
echo -e "${GREEN}系统启动完成！${NC}"
echo -e "${BLUE}前端地址: http://localhost:8080${NC}"
echo -e "${BLUE}后端地址: http://localhost:3030${NC}"
echo -e "${YELLOW}按 Ctrl+C 停止所有服务${NC}"
echo -e "${GREEN}=====================================${NC}"

# 等待用户中断
wait