FROM ubuntu:22.04
maintainer "mipu"

USER root
RUN apt-get update && apt-get -y upgrade

# Install base utilities.
RUN apt-get update -y && apt-get upgrade -y && apt-get install -y \
build-essential git curl wget \
libssl-dev libudev-dev pkg-config zlib1g-dev llvm clang cmake make libprotobuf-dev protobuf-compiler

# Install rust.
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs/ | sh -s -- -y
RUN echo "export PATH=$HOME/.cargo/bin:$PATH" >> ~/.bashrc
ENV PATH="/root/.cargo/bin:$PATH"
RUN /bin/bash -c "rustup component add rustfmt clippy"

# install Anchor CLI using AVM
RUN cargo install --git https://github.com/coral-xyz/anchor avm --force

RUN avm install latest
RUN avm use latest

# Install solana-cli
RUN sh -c "$(curl -sSfL https://release.anza.xyz/stable/install)"

RUN echo "export PATH=$HOME/.local/share/solana/install/active_release/bin:$PATH" >> ~/.bashrc
ENV PATH="/root/.local/share/solana/install/active_release/bin:$PATH"
RUN echo $PATH

# update solana to latest version
RUN agave-install update


# Install NVM, NodeJS
ENV NODE_VERSION="18/*"

RUN mkdir /usr/local/nvm
ENV NVM_DIR /usr/local/nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm use $NODE_VERSION \
    && npm i -g yarn

# Install typescript
ENV TYPESCRIPT_VERSION="^5.2.2"
RUN /bin/bash -c "source $NVM_DIR/nvm.sh && npm i -g typescript@${TYPESCRIPT_VERSION}"

# Install ts-node
RUN /bin/bash -c "source $NVM_DIR/nvm.sh && npm i -g ts-node"

# Install Anchor
ENV ANCHOR_VERSION="~0.28.0"
RUN /bin/bash -c "source $NVM_DIR/nvm.sh && npm i -g @coral-xyz/anchor-cli@${ANCHOR_VERSION}"

WORKDIR /src
CMD ["tail", "-f", "/dev/null"]