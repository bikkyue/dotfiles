FROM ubuntu:24.04

# install.sh の実行に必要なパッケージ
RUN apt-get update \
    && apt-get install -y \
        git \
        sudo \
        curl \
        xz-utils \
        ca-certificates \
        locales \
    && locale-gen en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

ARG USERNAME=user

# ユーザーを作成してsudo権限を付与
RUN useradd -m -s /bin/bash ${USERNAME} \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

USER ${USERNAME}
WORKDIR /home/${USERNAME}
ENV USER=${USERNAME}

ENTRYPOINT ["entrypoint.sh"]
