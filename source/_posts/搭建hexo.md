---
title: 搭建hexo
date: 2024-12-09 16:20:07
tags: 
- tools
- hexo
- article
categories: Tools
---

按照本周计划搭建博客，记录一下踩坑的点。

# 搭建hexo过程中

使用cnpm安装npm，避免因为网络原因导致安装失败。

# Github Pages

了解github pages的工作原理，方便之后其他静态网页工具的搭建。

## 重点

github Pages 默认显示的就是main分支下的index.html文件的内容。也就是说以后如果有其他静态网页工具，只需要写一个相关的仓库，做好index.html入口文件，就可以部署到github pages上。

例如react相关功能，可以写一个react仓库，做好index.html入口文件，就可以部署到github pages上。

github pages 可以自由选择发布分支，例如我选择gh-pages分支，那么我就可以在main分支下写文章，写完之后推送到gh-pages分支，就可以在github pages上看到我写的内容。

## 局限性

仅能托管前端页面，如果需要使用数据库之类的功能，需要前后端分离，使用RESTful API, 在前后端之间进行通信。

# github actions

这个自动化工具可以实现一些简单的任务，例如我可以把hexo的部署任务交给github actions，这样我就可以在本地写完文章后，直接推送到github上，github actions就会自动帮我部署到github pages上。

## 使用方法

在 Actions 中，使用自定义空白脚本。输入以下内容

```yml
name: Deploy Hexo Blog

on:
  push:
    branches:
      - main  # 或者你的主分支名称，例如 master
    paths:
      - 'source/_posts/**'

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout Repository
      uses: actions/checkout@v3

    - name: Set up Node.js
      uses: actions/setup-node@v3
      with:
        node-version: 16 # 或者你需要的 Node.js 版本

    - name: Install Dependencies
      run: npm install

    - name: Build Hexo
      run: npx hexo generate

    - name: Configure Git User (Optional)
      if: env.GIT_USER != '' && env.GIT_EMAIL != ''
      env:
        GIT_USER: ${{ secrets.GIT_USER }} # 可选，Git 用户名
        GIT_EMAIL: ${{ secrets.GIT_EMAIL }} # 可选，Git 邮箱
        # 如果你的 hexo-deployer-git 需要其他环境变量，也在这里添加
      run: |
          git config --global user.name "${{ env.GIT_USER }}"
          git config --global user.email "${{ env.GIT_EMAIL }}"

    - name: Deploy to GitHub Pages (using hexo-deployer-git)
      run: npx hexo deploy



```

之后在settings -> secrets and variables -> actions -> 点击New repository secret -> 输入GIT_USER和GIT_EMAIL -> 点击Add secret。

这之后，每次推送到main分支，就会自动部署到github pages上。

## 踩坑

1. 使用github actions部署时，需要使用hexo-deployer-git插件，否则会报错。
2. 现在github已经步入了main时代，master分支已经不再使用，所以需要将main分支设置为默认分支。
3. github actions 需要自己撰写，注意配置文件的正确性。
