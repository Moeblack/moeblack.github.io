@echo off
chcp 65001
echo 正在执行 Hexo 清理...
call hexo clean

echo 正在部署到远程仓库...
call hexo deploy

echo 部署完成!
pause
