FROM ubuntu

USER root

RUN  apt-get clean

# 更新安装相应工具
RUN apt-get update && apt-get install -y \
    zsh \
    vim \
    wget \
    curl \
    python2 \
    git

#  安装 zsh，以后进入容器中时，更加方便地使用 shell
RUN git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh \
    && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc \
    && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting \
    && sed -i 's/^plugins=(/plugins=(zsh-autosuggestions zsh-syntax-highlighting z /' ~/.zshrc \
    && chsh -s /bin/zsh

# 安装 nvm 和 node
ENV NVM_DIR /root/.nvm
ENV NODE_VERSION v16
RUN mkdir -p ${NVM_DIR} && \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash \
        && . ${NVM_DIR}/nvm.sh \
        && nvm install ${NODE_VERSION} \
        && nvm use ${NODE_VERSION} \
        && npm install --location=global nrm yarn pnpm @antfu/ni
