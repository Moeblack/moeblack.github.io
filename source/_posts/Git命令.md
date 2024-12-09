---
title: Git命令
date: 2024-12-09 16:59:07
tags: 
- tools
- git
- article
categories: Tools
---

Git这个工具在Windows上天天出现权限问题，记录一下常用的解决方法和命令。

# 常用命令

## 配置用户名和邮箱

```bash
git config --global user.name "your_name"
git config --global user.email "your_email"
```

## 配置ssh

```bash
ssh-keygen -t ed25519 -C "your_email"
```

之后会在`~/.ssh/`目录下生成`id_ed25519`和`id_ed25519.pub`两个文件。用记事本软件打开`id_ed25519.pub`文件，复制里面的内容，然后粘贴到github的ssh公钥中。
具体是在settings -> SSH and GPG keys -> New SSH key -> 粘贴内容 -> Add SSH key。

## 配置代理

```bash
git config --global http.proxy http://127.0.0.1:7890
git config --global https.proxy https://127.0.0.1:7890
```

## 取消代理

```bash
git config --global --unset http.proxy
git config --global --unset https.proxy
```

## 查看git设置项内容

例如查看代理设置内容，查看邮箱设置

```bash
git config --global https.proxy
git config --global user.email
```

即可。

# Git推送踩坑指令相关

```bash
git remote -v
```
查看上游

如果没有，使用
```bash
git remote add origin https://github.com/Moeblack/moeblack.github.io.git
```

以后 origin 就是上游，代表了github仓库。

## 推送本地 master 分支到远程 main 分支并设置上游

```bash 
git push -u origin master:main
```

> 命令解释：
> git push： 推送命令。
> -u： 设置上游分支（--set-upstream 的简写）。
> origin： 远程仓库的别名。
> master:main： 将本地的 master 分支推送到远程的 main 分支。




