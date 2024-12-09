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

    - name: Configure Git User
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
4. ssh认证，需要配置ssh公钥和私钥，否则会报错。

> 在 GitHub Actions 中，如果你想使用 SSH 密钥进行认证，并使用环境变量 `${{ env.DEPLOY_KEY }}` 存储私钥，你通常不需要手动执行 Git 命令来设置 SSH 认证。而是使用现成的 Action，例如 `webfactory/ssh-agent`，来为你管理 SSH 代理和私钥。

> **以下是使用 `webfactory/ssh-agent` Action 的步骤和说明：**
> 
> **1. 生成 SSH 密钥对：**
> 
>    如果你还没有 SSH 密钥对，可以使用以下命令生成：
> 
>    ```bash
>    ssh-keygen -t ed25519 -C "your-email@example.com"
>    ```
> 
>    将 `your-email@example.com` 替换为你的 GitHub 邮箱。按提示操作，记住私钥的保存位置（通常是 `~/.ssh/id_ed25519`）。
> 
> **2. 将公钥添加到 GitHub：** 
> 
>    *   复制公钥内容：
> 
>        ```bash
>        cat ~/.ssh/id_ed25519.pub
>        ```
> 
>    *   打开你的 GitHub 账户设置，进入 "SSH and GPG keys" 页面。
>    *   点击 "New SSH key"。
>    *   在 "Title" 中填写一个描述性的名称（例如 "GitHub Actions Deploy Key"）。
>    *   将复制的公钥内容粘贴到 "Key" 字段中。
>    *   点击 "Add SSH key"。
> 
> **3. 将私钥添加到 GitHub Actions Secrets：**
> 
>    *   打开你的 GitHub 仓库的 "Settings" -> "Security" -> "Secrets and variables" -> "Actions" 页面。
>    *   点击 "New repository secret"。
>    *   在 "Name" 字段中输入 `DEPLOY_KEY`（或其他你喜欢的名称）。
>    *   **将私钥内容（不是公钥）复制并粘贴到 "Secret" 字段中。** 注意：是 `~/.ssh/id_ed25519` 文件的内容，不是 `.pub` 文件。
>    *   点击 "Add secret"。
> 
> **4. 修改 `deploy.yml` 文件：**
> 
>    在你的 Workflow 文件 (`.github/workflows/deploy.yml`) 中，添加以下步骤：
> 
>    ```yaml
>    - name: Start SSH Agent
>      uses: webfactory/ssh-agent@v0.9.0
>      with:
>        ssh-private-key: ${{ secrets.DEPLOY_KEY }}
> 
>    - name: Deploy to GitHub Pages (using hexo-deployer-git)
>      run: npx hexo deploy
>      env:
>        GIT_USER: ${{ secrets.GIT_USER }}
>        GIT_EMAIL: ${{ secrets.GIT_EMAIL }}
> 
>    - name: Configure Git User (Optional)
>      if: env.GIT_USER != '' && env.GIT_EMAIL != ''
>      run: |
>          git config --global user.name "${{ env.GIT_USER }}"
>          git config --global user.email "${{ env.GIT_EMAIL }}"
>    ```
> 
> **代码解释：**
> 
> *   **`webfactory/ssh-agent@v0.9.0` Action：**
>     *   **`uses: webfactory/ssh-agent@v0.9.0`：**  指定使用的 Action。
>     *   **`with: ssh-private-key: ${{ secrets.DEPLOY_KEY }}`：**  将 `DEPLOY_KEY` Secret 的内容（即你的私钥）提供给 SSH 代理。
> *   **后续步骤：**
>     *   在 `webfactory/ssh-agent` 启动并配置好 SSH 代理后，后续的步骤（例如 `npx hexo deploy`）就可以通过 SSH 协议进行 Git 操作，无需再进行额外的认证配置。
> 
> **总结：**
> 
> 在 GitHub Actions 中使用 SSH 密钥进行认证的推荐方法是使用 `webfactory/ssh-agent` Action。你不需要手动执行 Git 命令来设置 SSH 认证，`webfactory/ssh-agent` Action 会帮你处理好这些细节。你只需要将私钥存> 储在 Secrets 中，并在 Workflow 文件中引用它即可。
> 
> **关键点：**
> 
> *   使用 `webfactory/ssh-agent` Action 来管理 SSH 代理。
> *   将私钥存储在名为 `DEPLOY_KEY` 的 Secret 中。
> *   在 `webfactory/ssh-agent` 的配置中，使用 `ssh-private-key: ${{ secrets.DEPLOY_KEY }}` 将私钥提供给 SSH 代理。
> *   确保你的 `_config.yml` 文件中 `deploy` 部分的 `repo` 字段使用的是 SSH 链接地址, 例如: `git@github.com:your-username/your-repo.git`
> 
> 通过这种方式，你的 GitHub Actions Workflow 就可以使用 SSH 密钥安全地进行 Git 操作，将你的 Hexo 博客部署到 GitHub Pages。

