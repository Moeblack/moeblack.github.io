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
