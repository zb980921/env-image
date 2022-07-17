FROM ubuntu

USER root

# 更新安装相应工具
RUN  apt-get clean
RUN apt-get update && apt-get install -y \
    zsh \
    vim \
    wget \
    curl \
    python2 \
    git \
    language-pack-zh-hans

ENV TZ=Asia/Shanghai
# 设置时区
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone \
    && apt-get install tzdata

#  安装 zsh，以后进入容器中时，更加方便地使用 shell
RUN git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh \
    && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc \
    && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting \
    && sed -i 's/^plugins=(/plugins=(zsh-autosuggestions zsh-syntax-highlighting z /' ~/.zshrc \
    && chsh -s /bin/zsh

# 支持中文
RUN echo LANG="zh_CN.UTF-8" >> /etc/environment \
    && echo LANGUAGE="zh_CN:zh:en_US:en" >> /etc/environment \
    && echo en_US.UTF-8 UTF-8 >> /var/lib/locales/supported.d/local \
    && echo zh_CN.UTF-8 UTF-8 >> /var/lib/locales/supported.d/local \
    && locale-gen

# 安装 nvm 和 node
ENV NVM_DIR /root/.nvm
ENV NODE_VERSION v16
RUN mkdir -p ${NVM_DIR} && \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash \
        && . ${NVM_DIR}/nvm.sh \
        && nvm install ${NODE_VERSION} \
        && nvm use ${NODE_VERSION} \
        && npm install --location=global nrm yarn pnpm @antfu/ni

# 删除 apt/lists，可以减少最终镜像大小，详情见：https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#general-guidelines-and-recommendations
RUN rm -rf /var/lib/apt/lists/*
